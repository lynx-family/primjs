// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/codegen/setup.h"

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

void InterpreterSetup::Setup(const char* module_name,
                             son::CompilationOptions options) {
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
    auto desc = son::node::CallDescriptors::CallBcHandler(kind, i);
    GenerateCode(codegen, generator, desc);
  }
  kind = son::node::CallKind::kBcHandler2;
  for (int i = 0; i < size; i++) {
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
