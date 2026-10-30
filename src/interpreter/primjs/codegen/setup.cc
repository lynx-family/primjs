// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/codegen/setup.h"

#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "primjs/codegen/accessBuilder.h"
#include "primjs/codegen/bytecode.h"
#include "primjs/codegen/codeStubGenerator.h"
#include "primjs/codegen/interpreterGenerator.h"
#include "primjs/codegen/llvmCodeGen.h"
#include "primjs/son/graphLinearizer.h"

namespace base {
void* ZoneObject::operator new(size_t size, Zone* zone) {
  return zone->alloc(size);
}
}  // namespace base

namespace primjs {

namespace {

// Returns the 32-bit word at |offset| of a zeroed T after |set| modified it.
template <typename T, typename Set>
uint32_t WordAfter(int offset, Set set) {
  alignas(T) unsigned char storage[sizeof(T)] = {};
  set(reinterpret_cast<T*>(storage));
  uint32_t word;
  memcpy(&word, storage + offset, sizeof(word));
  return word;
}

// Returns the byte at |offset| of a zeroed T after |set| modified it.
template <typename T, typename Set>
uint8_t ByteAfter(int offset, Set set) {
  alignas(T) unsigned char storage[sizeof(T)] = {};
  set(reinterpret_cast<T*>(storage));
  return storage[offset];
}

}  // namespace

bool VerifyHandlerLayout() {
  bool ok = true;
  auto check = [&ok](bool matches, const char* field) {
    if (!matches) {
      fprintf(stderr, "vm_codegen: handler layout mismatch: %s\n", field);
      ok = false;
    }
  };
  using AB = AccessBuilder;

  const int object_flags = AB::object_flags_offset();
  check(ByteAfter<LEPUSObject>(object_flags,
                               [](LEPUSObject* p) { p->extensible = 1; }) ==
            AB::object_extensible_flag(),
        "LEPUSObject::extensible");
  check(ByteAfter<LEPUSObject>(object_flags,
                               [](LEPUSObject* p) { p->is_exotic = 1; }) ==
            AB::object_is_exotic_flag(),
        "LEPUSObject::is_exotic");
  check(ByteAfter<LEPUSObject>(object_flags,
                               [](LEPUSObject* p) { p->fast_array = 1; }) ==
            AB::object_fast_array_flag(),
        "LEPUSObject::fast_array");
  check(ByteAfter<LEPUSObject>(object_flags,
                               [](LEPUSObject* p) { p->is_constructor = 1; }) ==
            AB::object_is_constructor_flag(),
        "LEPUSObject::is_constructor");
  check(ByteAfter<LEPUSObject>(object_flags,
                               [](LEPUSObject* p) {
                                 p->is_std_array_prototype = 1;
                               }) == AB::object_is_std_array_prototype_flag(),
        "LEPUSObject::is_std_array_prototype");

  const int function_flags = AB::function_flags_offset();
  check(ByteAfter<LEPUSFunctionBytecode>(
            function_flags,
            [](LEPUSFunctionBytecode* b) { b->has_prototype = 1; }) ==
            AB::function_has_prototype_flag(),
        "LEPUSFunctionBytecode::has_prototype");
  check(ByteAfter<LEPUSFunctionBytecode>(function_flags,
                                         [](LEPUSFunctionBytecode* b) {
                                           b->is_derived_class_constructor = 1;
                                         }) ==
            AB::function_is_derived_class_constructor_flag(),
        "LEPUSFunctionBytecode::is_derived_class_constructor");
  check(ByteAfter<LEPUSFunctionBytecode>(function_flags,
                                         [](LEPUSFunctionBytecode* b) {
                                           b->func_kind = 3;
                                         }) == AB::function_kind_mask(),
        "LEPUSFunctionBytecode::func_kind");

  const int closure_flags = AB::closure_var_flags_offset();
  check(ByteAfter<LEPUSClosureVar>(
            closure_flags, [](LEPUSClosureVar* v) { v->is_local = 1; }) ==
            AB::closure_var_is_local_flag(),
        "LEPUSClosureVar::is_local");
  check(ByteAfter<LEPUSClosureVar>(closure_flags,
                                   [](LEPUSClosureVar* v) { v->is_arg = 1; }) ==
            AB::closure_var_is_arg_flag(),
        "LEPUSClosureVar::is_arg");

  const int length_word = AB::string_length_offset();
  check(WordAfter<JSString>(length_word,
                            [](JSString* s) { s->len = JS_STRING_LEN_MAX; }) ==
            AB::string_length_mask(),
        "JSString::len");
  check(WordAfter<JSString>(length_word, [](JSString* s) { s->has_aux = 1; }) ==
            AB::string_aux_mask(),
        "JSString::has_aux");
  check(WordAfter<JSString>(length_word,
                            [](JSString* s) { s->is_wide_char = 1; }) ==
            AB::string_wide_mask(),
        "JSString::is_wide_char");
  check(WordAfter<JSString>(AB::atom_type_offset(),
                            [](JSString* s) { s->meta.atom_type = 3; }) ==
            3u << AB::atom_type_shift(),
        "JSStringMeta::atom_type");
  check(WordAfter<JSSeparableString>(length_word,
                                     [](JSSeparableString* s) {
                                       s->len = JS_STRING_LEN_MAX;
                                       s->is_wide_char = 1;
                                     }) ==
            (AB::string_length_mask() | AB::string_wide_mask()),
        "JSSeparableString::len/is_wide_char");
  return ok;
}

void InterpreterSetup::Setup(const char* module_name,
                             son::CompilationOptions options) {
  if (!VerifyHandlerLayout()) {
    exit(EXIT_FAILURE);
  }
  base::Zone zone;
  LLVMAssembler* assembler = new (&zone) LLVMAssembler(module_name);
  LLVMModule* llvm_module = new (&zone) LLVMModule(&zone, assembler);
  assembler->set_llvm_module(llvm_module);
  LLVMCodeGen* codegen = new (&zone) LLVMCodeGen(assembler);
  assembler->Init(&zone, options);
  GenerateBytecodeHandlers(codegen);
  codegen->GenerateDispatchTable();
  GenerateCodeStub(codegen);
  assembler->RunPasses();
  assembler->Deinit();
}

void InterpreterSetup::GenerateCodeStub(LLVMCodeGen* codegen) {
  CodeStubGenerator generator;
  son::node::CallDescriptor desc =
      son::node::CallDescriptors::_call_stub_entry();
  GenerateCode(codegen, generator, desc);
}

void InterpreterSetup::InstallBcDescriptors(son::node::NodeGraph* graph) {
  int i;
  std::string name_r;
#define DEF_INTERP_HANDLER_NO_RET(name)           \
  i = static_cast<int>(CallBcIndex::k##name);     \
  name_r = #name;                                 \
  name_r += "_asm_h";                             \
  graph->GetCallDescriptors()->InitCallBcHandler( \
      son::node::CallKind::kBcHandler, name_r.c_str(), i);
#define DEF_INTERP_HANDLER_RET(name)              \
  i = static_cast<int>(CallBcIndex::k##name);     \
  name_r = #name;                                 \
  name_r += "_asm_h";                             \
  graph->GetCallDescriptors()->InitCallBcHandler( \
      son::node::CallKind::kCallHandler, name_r.c_str(), i);
#include "primjs/interp/interp.def"

#ifdef ENABLE_QUICKJS_DEBUGGER
  graph
      ->GetCallDescriptor(son::node::CallDescriptors::ExtCallBcHandler(
          static_cast<int>(CallBcIndex::kcommon_call_debugger0)))
      ->set_external_linkage();
  graph
      ->GetCallDescriptor(son::node::CallDescriptors::ExtCallBcHandler(
          static_cast<int>(CallBcIndex::kcommon_call_debugger1)))
      ->set_external_linkage();
  graph
      ->GetCallDescriptor(son::node::CallDescriptors::ExtCallBcHandler(
          static_cast<int>(CallBcIndex::kcommon_call_debugger2)))
      ->set_external_linkage();
#endif
}

void InterpreterSetup::GenerateBytecodeHandlers(LLVMCodeGen* codegen) {
  InterpreterGenerator generator;
  int start = static_cast<int>(CallBcIndex::kStart);
  auto bc_size = static_cast<int>(CallBcIndex::kAsmCount2);
  auto count1 = static_cast<int>(CallBcIndex::kAsmCount1);
  for (int i = start; i < bc_size; i++) {
    if (i < count1) {  // skip kAsmCount1
      auto desc = son::node::CallDescriptors::CallHandlerBcHandler(i);
      GenerateCode(codegen, generator, desc);
    } else if (i > count1) {
      auto desc = son::node::CallDescriptors::ExtCallBcHandler(i);
      GenerateCode(codegen, generator, desc);
    }
  }
  auto kind = son::node::CallKind::kBcHandler;
  auto size = static_cast<int>(PrimjsOpcode::kCount);
  for (int i = 0; i < size; i++) {
    auto desc = son::node::CallDescriptors::CallBcHandler(kind, i);
    GenerateCode(codegen, generator, desc);
  }
  if (!codegen->options().SupportMultiTable()) {
    return;
  }
  kind = son::node::CallKind::kBcHandler1;
  for (int i = 0; i < size; i++) {
    if (codegen->options().ShareMultiTableFallback() &&
        !is_multi_table_opcode(static_cast<PrimjsOpcode>(i))) {
      continue;
    }
    auto desc = son::node::CallDescriptors::CallBcHandler(kind, i);
    GenerateCode(codegen, generator, desc);
  }
  kind = son::node::CallKind::kBcHandler2;
  for (int i = 0; i < size; i++) {
    if (codegen->options().ShareMultiTableFallback() &&
        !is_multi_table_opcode(static_cast<PrimjsOpcode>(i))) {
      continue;
    }
    auto desc = son::node::CallDescriptors::CallBcHandler(kind, i);
    GenerateCode(codegen, generator, desc);
  }
}

void InterpreterSetup::GenerateCode(LLVMCodeGen* codegen,
                                    CodeGenerator& generator,
                                    son::node::CallDescriptor desc) {
  base::Zone zone;
  son::CompilationOptions options = codegen->options();
  if (codegen->is_32bit()) {
    options.SetTargetArch(son::TargetArch::kARM);
  } else {
    options.SetTargetArch(son::TargetArch::kAARCH64);
  }
  // options.SetFlag(son::CompilationOptions::Flag::kTraceLog);
  son::node::NodeGraph* graph = new (&zone) son::node::NodeGraph(&zone);
  son::node::ScheduleResult* result =
      new (&zone) son::node::ScheduleResult(&zone);
  result->set_graph(graph);
  graph->set_options(options);
  graph->set_call_descriptor(desc);
  InstallBcDescriptors(graph);

  generator.Generate(graph);
  // graph->print();
  son::node::GraphLinearizer linearizer(graph, &zone);
  linearizer.set_options(options);
  linearizer.Run(result);
  codegen->Run(result, desc);
}

}  // namespace primjs
