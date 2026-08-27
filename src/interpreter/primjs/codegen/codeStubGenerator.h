// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_INTERP_CODE_STUB_GENERATOR_H
#define PRIMJS_INTERP_CODE_STUB_GENERATOR_H

#include "primjs/base/globals.h"
#include "primjs/codegen/codeAssembler.h"
#include "primjs/codegen/codeGenerator.h"
#include "primjs/son/graphBuilder.h"

namespace primjs {

class CodeStubAssembler : public CodeAssembler {
 public:
  CodeStubAssembler(son::node::NodeGraph* graph);
  void GenerateCallEntry(son::node::NodeGraph* graph);
};

class CodeStubGenerator : public CodeGenerator {
 public:
  CodeStubGenerator() : CodeGenerator() {}
  virtual ~CodeStubGenerator() {}
  void Generate(son::node::NodeGraph* graph) override;
};

}  // namespace primjs
#endif  // PRIMJS_INTERP_CODE_STUB_GENERATOR_H
