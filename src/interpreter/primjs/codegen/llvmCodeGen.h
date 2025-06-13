// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_INTERP_LLVM_CODEGEN_H
#define PRIMJS_INTERP_LLVM_CODEGEN_H

#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>

#include "primjs/base/globals.h"
#include "primjs/base/zoneContainers.h"
#include "primjs/son/callDescriptor.h"
#include "primjs/son/compilationOptions.h"

namespace son::node {
class NodeGraph;
class ScheduleResult;
}  // namespace son::node

namespace primjs {

class LLVMModule;
class LLVMAssembler : public base::ZoneObject {
 public:
  static constexpr int kMaxCallArgs = 16;

  LLVMAssembler(const char* module_name) : _module_name(module_name) {}
  ~LLVMAssembler() {}

  void Init(base::Zone* zone, son::CompilationOptions options);
  void Deinit();
  void RunPasses();
  LLVMTypeRef ConvertToLLVMType(son::node::MachineType machine_type);

  LLVMContextRef context() { return _context; }
  LLVMModuleRef module() { return _module; }
  LLVMTypeRef int8_type() const { return _int8_type; }
  LLVMTypeRef int16_type() const { return _int16_type; }
  LLVMTypeRef int32_type() const { return _int32_type; }
  LLVMTypeRef int64_type() const { return _int64_type; }
  LLVMTypeRef double_type() const { return _double_type; }
  LLVMTypeRef intptr_type() const { return _intptr_type; }
  LLVMTypeRef raw_type() const { return _raw_type; }
  LLVMTypeRef bool_type() const { return _int1_type; }

  LLVMTypeRef* input_buffer() { return _input_buffer; }

  LLVMModule* llvm_module() const { return _llvm_module; }
  void set_llvm_module(LLVMModule* module) { _llvm_module = module; }
  LLVMModuleRef module() const { return _module; }
  bool is_32bit() const { return _options.Is32Bit(); }
  bool is_host() const { return _options.IsHost(); }
  son::CompilationOptions options() const { return _options; }

 private:
  LLVMContextRef _context{nullptr};
  LLVMModuleRef _module{nullptr};
  char* _error{nullptr};
  const char* _module_name{nullptr};
  LLVMTypeRef* _input_buffer{nullptr};
  LLVMModule* _llvm_module{nullptr};

  LLVMTypeRef _void_type{nullptr};
  LLVMTypeRef _int1_type{nullptr};
  LLVMTypeRef _int8_type{nullptr};
  LLVMTypeRef _int16_type{nullptr};
  LLVMTypeRef _int32_type{nullptr};
  LLVMTypeRef _int64_type{nullptr};
  LLVMTypeRef _double_type{nullptr};
  LLVMTypeRef _raw_type{nullptr};
  LLVMTypeRef _intptr_type{nullptr};

  son::CompilationOptions _options;
};

class LLVMModule : public base::ZoneObject {
 public:
  LLVMModule(base::Zone* zone, LLVMAssembler* assembler)
      : _functions(zone), _assembler(assembler) {}

  ~LLVMModule() {}

  LLVMValueRef AddFunction(son::node::CallDescriptorData* desc);
  LLVMTypeRef GenerateFunctionType(son::node::CallDescriptorData* desc);

  LLVMValueRef GetFunction(son::node::CallDescriptor desc) {
    vmassert(_functions.find(desc) != _functions.end(), "function not found");
    return _functions[desc];
  }

  LLVMValueRef GetOrCreateFunction(son::node::CallDescriptorData* desc) {
    auto res = _functions.find(desc->descriptor());
    if (res != _functions.end()) {
      return res->second;
    }
    return AddFunction(desc);
  }
  LLVMTypeRef* input_buffer() const { return _assembler->input_buffer(); }

 private:
  base::ZoneMap<son::node::CallDescriptor, LLVMValueRef> _functions;
  LLVMAssembler* _assembler{nullptr};
};

class LLVMCodeGen : public base::ZoneObject {
 private:
  LLVMAssembler* _assembler{nullptr};

 public:
  LLVMCodeGen(LLVMAssembler* assembler) : _assembler(assembler) {}

  ~LLVMCodeGen() {}

  bool is_32bit() const { return _assembler->is_32bit(); }
  bool is_host() const { return _assembler->is_host(); }

  son::CompilationOptions options() const { return _assembler->options(); }

  void Run(son::node::ScheduleResult* result, son::node::CallDescriptor desc);
};

}  // namespace primjs

#endif  // PRIMJS_INTERP_LLVM_CODEGEN_H
