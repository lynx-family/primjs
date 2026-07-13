// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_INTERP_SETUP_H
#define PRIMJS_INTERP_SETUP_H

#include "primjs/base/globals.h"
#include "primjs/base/zone.h"
#include "primjs/codegen/codeGenerator.h"

namespace primjs {

class LLVMCodeGen;
class InterpreterSetup {
 public:
  static void Setup(const char* filename, son::CompilationOptions options);
  static void GenerateBytecodeHandlers(LLVMCodeGen* codegen);
  static void GenerateCodeStub(LLVMCodeGen* codegen);
  static void InstallBcDescriptors(son::node::NodeGraph* graph);

  static void GenerateCode(LLVMCodeGen* codegen, CodeGenerator& generator,
                           son::node::CallDescriptor desc);
};

}  // namespace primjs
#endif  // PRIMJS_INTERP_SETUP_H
