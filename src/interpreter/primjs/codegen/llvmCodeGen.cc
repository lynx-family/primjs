// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/codegen/llvmCodeGen.h"

#include <llvm/IR/Attributes.h>
#include <llvm/IR/Module.h>
#include <llvm/IR/PassManager.h>
#include <llvm/IR/Verifier.h>
#include <llvm/Passes/PassBuilder.h>
#include <llvm/Transforms/InstCombine/InstCombine.h>
#include <llvm/Transforms/Scalar/ADCE.h>
#include <llvm/Transforms/Scalar/BDCE.h>
#include <llvm/Transforms/Scalar/CorrelatedValuePropagation.h>
#include <llvm/Transforms/Scalar/EarlyCSE.h>
#include <llvm/Transforms/Scalar/GVN.h>
#include <llvm/Transforms/Scalar/JumpThreading.h>
#include <llvm/Transforms/Scalar/LICM.h>
#include <llvm/Transforms/Scalar/SCCP.h>
#include <llvm/Transforms/Scalar/SROA.h>
#include <llvm/Transforms/Scalar/SimplifyCFG.h>

#include <algorithm>
#include <iostream>
#include <map>
#include <string_view>
#include <unordered_set>
#include <vector>

#include "llvm-c/Analysis.h"
#include "llvm-c/Core.h"
#include "llvm-c/Target.h"
#include "primjs/codegen/bytecode.h"
#include "primjs/codegen/interpreterAssembler.h"
#include "primjs/codegen/llvmIRBuilder.h"
#include "primjs/son/nodeType.h"

namespace primjs {

namespace {

bool IsColdRuntimeCall(son::node::CallId id) {
  switch (id) {
    case son::node::CallId::kprim_try_malloc_gc:
    case son::node::CallId::kfmod:
    case son::node::CallId::kcall_c_func:
    case son::node::CallId::kcall_cfunc_func:
    case son::node::CallId::kcall_cfunc_generic:
    case son::node::CallId::kcall_cfunc_generic_magic:
    case son::node::CallId::kcall_getter:
    case son::node::CallId::kcall_setter:
    case son::node::CallId::kcall_getter_magic:
    case son::node::CallId::kcall_setter_magic:
    case son::node::CallId::kprim_call_c_function_default:
    case son::node::CallId::kjs_create_ordinary_constructor_this_GC:
    case son::node::CallId::kDebuggerPause:
    case son::node::CallId::kDebuggerCallEachOp:
    case son::node::CallId::kDebuggerCallEachFunc:
    case son::node::CallId::kprim_debug_trace:
    case son::node::CallId::kcall_runtime_wrapper:
      return false;
    default:
      return true;
  }
}

bool IsColdExtHandler(int call_index) {
  switch (static_cast<CallBcIndex>(call_index)) {
    case CallBcIndex::kexception:
    case CallBcIndex::kexception_spill_top0:
    case CallBcIndex::kexception_spill_top1:
    case CallBcIndex::kexception_spill_top0_top1:
    case CallBcIndex::kSlowCloseVarRefs:
    case CallBcIndex::kSlowToBoolean:
    case CallBcIndex::kSlowJSPostInc:
    case CallBcIndex::kSlowJSNot:
    case CallBcIndex::kSlowJSAdd:
    case CallBcIndex::kSlowPutField:
    case CallBcIndex::kSlowGetArrayEl:
    case CallBcIndex::kSlowPutArrayEl:
    case CallBcIndex::kThrowReferenceErrorUninitialized:
    case CallBcIndex::kThrowThisReferenceError:
    case CallBcIndex::kThrowTypeErrorNotFunction_Return:
    case CallBcIndex::kThrowStackOverflow_Return:
      return true;
    default:
      return false;
  }
}

bool IsHotHandlerName(std::string_view name) {
  static const std::unordered_set<std::string_view> kHotExact = {
      "common_call_asm_h",          "common_return_asm_h",
      "common_return_direct_asm_h", "common_call_from_entry_asm_h",
      "call_native_asm_h",          "FastTypedArrayGet_asm_h",
      "FastTypedArraySet_asm_h",    "FastAddNamedProperty_asm_h",
      "FastFclosure_asm_h",         "FastStringEqual_asm_h",
      "FastJSConcatString_asm_h",   "FastCallConstructor_asm_h",
  };
  if (kHotExact.count(name) != 0) {
    return true;
  }

  // Opcode handlers end with "_0_asm_h", "_1_asm_h", or "_2_asm_h".
  constexpr std::string_view kSuffix = "_asm_h";
  if (name.size() <= kSuffix.size() + 2 ||
      name.substr(name.size() - kSuffix.size()) != kSuffix) {
    return false;
  }
  char table_ch = name[name.size() - kSuffix.size() - 1];
  if (name[name.size() - kSuffix.size() - 2] != '_' ||
      (table_ch != '0' && table_ch != '1' && table_ch != '2')) {
    return false;
  }
  std::string_view base = name.substr(0, name.size() - kSuffix.size() - 2);
  static const std::unordered_set<std::string_view> kHotOpcodes = {
      "get_loc0",     "get_loc1",     "get_loc2",     "get_loc3",
      "get_loc8",     "put_loc0",     "put_loc1",     "put_loc2",
      "put_loc3",     "put_loc8",     "set_loc0",     "set_loc1",
      "set_loc2",     "set_loc3",     "set_loc8",     "get_arg0",
      "get_arg1",     "get_arg2",     "get_arg3",     "put_arg0",
      "put_arg1",     "put_arg2",     "put_arg3",     "get_var_ref0",
      "get_var_ref1", "get_var_ref2", "get_var_ref3", "put_var_ref0",
      "put_var_ref1", "put_var_ref2", "put_var_ref3", "push_minus1",
      "push_0",       "push_1",       "push_2",       "push_3",
      "push_4",       "push_5",       "push_6",       "push_7",
      "push_i8",      "push_i16",     "push_i32",     "push_const8",
      "push_const",   "undefined",    "null",         "push_true",
      "push_false",   "push_this",    "drop",         "dup",
      "dup1",         "swap",         "nip",          "add",
      "sub",          "mul",          "div",          "mod",
      "and",          "or",           "xor",          "shl",
      "sar",          "shr",          "neg",          "not",
      "lnot",         "inc",          "dec",          "post_inc",
      "post_dec",     "inc_loc",      "dec_loc",      "add_loc",
      "lt",           "lte",          "gt",           "gte",
      "eq",           "neq",          "strict_eq",    "strict_neq",
      "if_false8",    "if_true8",     "if_false",     "if_true",
      "goto8",        "goto16",       "goto",         "get_field",
      "get_field2",   "put_field",    "get_array_el", "get_array_el2",
      "put_array_el", "get_length",   "get_var",      "get_var_undef",
      "put_var",      "call0",        "call1",        "call2",
      "call3",        "call",         "call_method",  "call_constructor",
      "return",       "return_undef", "object",       "array_from",
      "fclosure8",    "fclosure",     "is_undefined", "is_null",
      "is_function",  "typeof",
  };
  return kHotOpcodes.count(base) != 0;
}

void ReorderFunctionsHotCold(llvm::Module& module) {
  std::vector<llvm::Function*> primary_hot_funcs;
  std::vector<llvm::Function*> secondary_hot_funcs;
  std::vector<llvm::Function*> cold_funcs;
  static const std::unordered_set<std::string_view> kSecondaryHot = {
      "FastTypedArrayGet_asm_h",    "FastTypedArraySet_asm_h",
      "FastAddNamedProperty_asm_h", "FastFclosure_asm_h",
      "FastStringEqual_asm_h",      "FastJSConcatString_asm_h",
      "FastCallConstructor_asm_h",
  };
  for (llvm::Function& fn : module) {
    if (fn.isDeclaration()) {
      continue;
    }
    if (kSecondaryHot.count(fn.getName()) != 0) {
      secondary_hot_funcs.push_back(&fn);
    } else if (IsHotHandlerName(fn.getName())) {
      primary_hot_funcs.push_back(&fn);
    } else {
      cold_funcs.push_back(&fn);
    }
  }
  auto& fn_list = module.getFunctionList();
  for (llvm::Function* fn : primary_hot_funcs) {
    fn_list.splice(fn_list.end(), fn_list, fn->getIterator());
  }
  for (llvm::Function* fn : secondary_hot_funcs) {
    fn_list.splice(fn_list.end(), fn_list, fn->getIterator());
  }
  for (llvm::Function* fn : cold_funcs) {
    fn_list.splice(fn_list.end(), fn_list, fn->getIterator());
  }
}

}  // namespace

void LLVMAssembler::Init(base::Zone* zone, son::CompilationOptions options) {
  _options = options;
  _context = LLVMContextCreate();
  _module = LLVMModuleCreateWithNameInContext(_module_name, _context);
  _input_buffer = zone->alloc_array<LLVMTypeRef>(kMaxCallArgs);
  _void_type = LLVMVoidTypeInContext(_context);
  _int1_type = LLVMInt1TypeInContext(_context);
  _int8_type = LLVMInt8TypeInContext(_context);
  _int16_type = LLVMInt16TypeInContext(_context);
  _int32_type = LLVMInt32TypeInContext(_context);
  _int64_type = LLVMInt64TypeInContext(_context);
  _double_type = LLVMDoubleTypeInContext(_context);
  _raw_type = LLVMPointerType(LLVMInt64TypeInContext(_context), 0);
  _intptr_type = _options.Is32Bit() ? LLVMInt32TypeInContext(_context)
                                    : LLVMInt64TypeInContext(_context);
}

void LLVMAssembler::Deinit() {
  if (_error != nullptr) {
    LLVMDisposeMessage(_error);
  }
  _module = nullptr;
  LLVMContextDispose(_context);
  _context = nullptr;
}

void LLVMAssembler::RunPasses() {
  llvm::Module* mod = llvm::unwrap(_module);
  std::string module_name = mod->getModuleIdentifier() + ".ll";

  LLVMVerifyModule(_module, LLVMAbortProcessAction, &_error);

  llvm::LoopAnalysisManager lam;
  llvm::FunctionAnalysisManager fam;
  llvm::CGSCCAnalysisManager cgam;
  llvm::ModuleAnalysisManager mam;

  llvm::PassBuilder pb;
  pb.registerModuleAnalyses(mam);
  pb.registerCGSCCAnalyses(cgam);
  pb.registerFunctionAnalyses(fam);
  pb.registerLoopAnalyses(lam);
  pb.crossRegisterProxies(lam, fam, cgam, mam);

  llvm::SimplifyCFGOptions cfg_opts;
  cfg_opts.hoistCommonInsts(false).sinkCommonInsts(false);

  llvm::FunctionPassManager fpm;
  fpm.addPass(llvm::SimplifyCFGPass(cfg_opts));
  fpm.addPass(llvm::SROAPass(llvm::SROAOptions::PreserveCFG));
  fpm.addPass(llvm::EarlyCSEPass(/*UseMemorySSA=*/true));
  fpm.addPass(llvm::InstCombinePass());
  fpm.addPass(llvm::JumpThreadingPass());
  fpm.addPass(llvm::CorrelatedValuePropagationPass());
  fpm.addPass(llvm::SimplifyCFGPass(cfg_opts));
  fpm.addPass(llvm::GVNPass());
  fpm.addPass(llvm::SCCPPass());
  fpm.addPass(llvm::BDCEPass());
  fpm.addPass(llvm::InstCombinePass());
  fpm.addPass(llvm::createFunctionToLoopPassAdaptor(
      llvm::LICMPass(llvm::LICMOptions()), /*UseMemorySSA=*/true));
  fpm.addPass(llvm::ADCEPass());
  fpm.addPass(llvm::SimplifyCFGPass(cfg_opts));

  for (llvm::Function& fn : *mod) {
    if (!fn.isDeclaration()) {
      fpm.run(fn, fam);
    }
  }

  LLVMVerifyModule(_module, LLVMAbortProcessAction, &_error);

  // Pack frequently executed handlers together at the start of the generated
  // code block so hot code stays dense in the instruction cache.
  ReorderFunctionsHotCold(*mod);

  // Functions are emitted in module order, so the first function with a body
  // starts the generated code block.
  for (LLVMValueRef fn = LLVMGetFirstFunction(_module); fn;
       fn = LLVMGetNextFunction(fn)) {
    if (!LLVMIsDeclaration(fn)) {
      LLVMSetAlignment(fn, kCodeBlockAlignment);
      break;
    }
  }

  LLVMPrintModuleToFile(_module, module_name.c_str(), &_error);
}

LLVMTypeRef LLVMAssembler::ConvertToLLVMType(
    son::node::MachineType machine_type) {
  static std::map<son::node::MachineType, LLVMTypeRef> machine_type_map = {
      {son::node::MachineType::kNone, _void_type},
      {son::node::MachineType::kBool, _int1_type},
      {son::node::MachineType::kInt8, _int8_type},
      {son::node::MachineType::kInt16, _int16_type},
      {son::node::MachineType::kInt32, _int32_type},
      {son::node::MachineType::kInt64, _int64_type},
      {son::node::MachineType::kIntptr, _intptr_type},
      {son::node::MachineType::kFloat64, _double_type},
      {son::node::MachineType::kObject, _raw_type},
      {son::node::MachineType::kRawType, _raw_type},
      {son::node::MachineType::kMetaType, _raw_type},
  };
  return machine_type_map[machine_type];
}

LLVMTypeRef LLVMModule::GenerateFunctionType(
    son::node::CallDescriptorData* desc) {
  auto return_type = _assembler->ConvertToLLVMType(desc->return_type());
  int arg_count = desc->param_count();
  vmassert(arg_count <= LLVMAssembler::kMaxCallArgs, "too many arguments");
  for (int i = 0; i < arg_count; i++) {
    input_buffer()[i] = _assembler->ConvertToLLVMType(desc->param_type(i));
  }
  LLVMTypeRef func_type = LLVMFunctionType(return_type, input_buffer(),
                                           arg_count, desc->is_is_var_arg());
  return func_type;
}

LLVMValueRef LLVMModule::AddFunction(son::node::CallDescriptorData* desc) {
  auto func_type = GenerateFunctionType(desc);
  auto module = _assembler->module();
  auto name = desc->func_name();
  LLVMValueRef function = LLVMAddFunction(module, name, func_type);
  if (desc->kind() == son::node::CallKind::kRuntime) {
    LLVMSetLinkage(function, LLVMExternalLinkage);
    LLVMSetFunctionCallConv(function, LLVMCCallConv);
    if (IsColdRuntimeCall(static_cast<son::node::CallId>(desc->call_index()))) {
      llvm::unwrap<llvm::Function>(function)->addFnAttr(llvm::Attribute::Cold);
    }
  } else if (desc->kind() == son::node::CallKind::kStub ||
             desc->has_external_linkage()) {
    LLVMSetVisibility(function, LLVMHiddenVisibility);
  } else {
    LLVMSetLinkage(function, LLVMPrivateLinkage);
    if (desc->kind() == son::node::CallKind::kBcHandler &&
        IsColdExtHandler(desc->call_index())) {
      llvm::unwrap<llvm::Function>(function)->addFnAttr(llvm::Attribute::Cold);
    }
  }
  _functions[desc->descriptor()] = function;
  return function;
}

void LLVMCodeGen::GenerateDispatchTable() {
  static_assert(static_cast<int>(PrimjsOpcode::kCount) == OP_COUNT,
                "PrimJS and QuickJS opcode counts must match");

  constexpr int kNormalTableCount = 3;
  constexpr char kDispatchTableName[] = "primjs_dispatch_table";
  const int opcode_count = static_cast<int>(PrimjsOpcode::kCount);
  LLVMTypeRef handler_pointer_type = _assembler->raw_type();
  LLVMModule* llvm_module = _assembler->llvm_module();

  auto make_handler_pointer = [&](son::node::CallDescriptor desc) {
    LLVMValueRef function = llvm_module->GetFunction(desc);
    return LLVMConstPointerCast(function, handler_pointer_type);
  };

  std::vector<LLVMValueRef> rows;
  rows.reserve(kNormalTableCount
#ifdef ENABLE_QUICKJS_DEBUGGER
               * 2
#endif
  );

  constexpr son::node::CallKind kNormalKinds[kNormalTableCount] = {
      son::node::CallKind::kBcHandler, son::node::CallKind::kBcHandler1,
      son::node::CallKind::kBcHandler2};
  for (int table_index = 0; table_index < kNormalTableCount; ++table_index) {
    // Keep the three-row dispatch table ABI even without the multi-table
    // optimization. Only row zero is used in that configuration.
    son::node::CallKind kind = options().SupportMultiTable()
                                   ? kNormalKinds[table_index]
                                   : kNormalKinds[0];
    std::vector<LLVMValueRef> handlers;
    handlers.reserve(opcode_count);
    for (int opcode = 0; opcode < opcode_count; ++opcode) {
      son::node::CallDescriptor desc;
      if (table_index == 0 || !options().SupportMultiTable() ||
          !options().ShareMultiTableFallback() ||
          is_multi_table_opcode(static_cast<PrimjsOpcode>(opcode))) {
        desc = son::node::CallDescriptors::CallBcHandler(kind, opcode);
      } else {
        CallBcIndex fallback = table_index == 1
                                   ? CallBcIndex::kspill_table1_to_table0
                                   : CallBcIndex::kspill_table2_to_table0;
        desc = son::node::CallDescriptors::ExtCallBcHandler(
            static_cast<int>(fallback));
      }
      handlers.push_back(make_handler_pointer(desc));
    }
    rows.push_back(LLVMConstArray2(handler_pointer_type, handlers.data(),
                                   handlers.size()));
  }

#ifdef ENABLE_QUICKJS_DEBUGGER
  constexpr CallBcIndex kDebuggerHandlers[kNormalTableCount] = {
      CallBcIndex::kcommon_call_debugger0, CallBcIndex::kcommon_call_debugger1,
      CallBcIndex::kcommon_call_debugger2};
  for (CallBcIndex debugger_handler : kDebuggerHandlers) {
    LLVMValueRef handler =
        make_handler_pointer(son::node::CallDescriptors::ExtCallBcHandler(
            static_cast<int>(debugger_handler)));
    std::vector<LLVMValueRef> handlers(opcode_count, handler);
    rows.push_back(LLVMConstArray2(handler_pointer_type, handlers.data(),
                                   handlers.size()));
  }
#endif

  LLVMTypeRef row_type = LLVMTypeOf(rows.front());
  LLVMValueRef initializer =
      LLVMConstArray2(row_type, rows.data(), rows.size());
  LLVMValueRef table = LLVMAddGlobal(
      _assembler->module(), LLVMTypeOf(initializer), kDispatchTableName);
  LLVMSetInitializer(table, initializer);
  LLVMSetGlobalConstant(table, true);
  LLVMSetLinkage(table, LLVMExternalLinkage);
  LLVMSetVisibility(table, LLVMHiddenVisibility);
  LLVMSetAlignment(table, _assembler->is_32bit() ? 4 : 8);
}

void LLVMCodeGen::Run(son::node::ScheduleResult* result,
                      son::node::CallDescriptor desc) {
  auto graph = result->graph();
  auto desc_data = graph->GetCallDescriptor(desc);
  auto func = _assembler->llvm_module()->GetOrCreateFunction(desc_data);
  LLVMIRBuilder builder(_assembler, graph, result);
  builder.Build(func, desc_data);
}

}  // namespace primjs
