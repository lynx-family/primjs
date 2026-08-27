// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/codegen/llvmCodeGen.h"

#include <llvm/IR/Module.h>
#include <llvm/IR/Verifier.h>

#include <iostream>
#include <map>
#include <vector>

#include "llvm-c/Analysis.h"
#include "llvm-c/Core.h"
#include "llvm-c/Target.h"
#include "primjs/codegen/bytecode.h"
#include "primjs/codegen/interpreterAssembler.h"
#include "primjs/codegen/llvmIRBuilder.h"
#include "primjs/son/nodeType.h"

namespace primjs {

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
  std::string module_name =
      llvm::unwrap(_module)->getModuleIdentifier() + ".ll";

  LLVMVerifyModule(_module, LLVMAbortProcessAction, &_error);
  LLVMPassManagerRef funcPass = LLVMCreateFunctionPassManagerForModule(_module);
  LLVMInitializeFunctionPassManager(funcPass);
  for (LLVMValueRef fn = LLVMGetFirstFunction(_module); fn;
       fn = LLVMGetNextFunction(fn)) {
    LLVMRunFunctionPassManager(funcPass, fn);
  }
  LLVMFinalizeFunctionPassManager(funcPass);
  LLVMDisposePassManager(funcPass);

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
  } else {
    LLVMSetVisibility(function, LLVMHiddenVisibility);
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
      handlers.push_back(make_handler_pointer(
          son::node::CallDescriptors::CallBcHandler(kind, opcode)));
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
