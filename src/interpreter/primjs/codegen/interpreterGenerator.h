// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_INTERP_INTERPRETER_GENERATOR_H
#define PRIMJS_INTERP_INTERPRETER_GENERATOR_H

#include "primjs/base/globals.h"
#include "primjs/codegen/codeGenerator.h"
#include "primjs/codegen/interpreterAssembler.h"

namespace primjs {

class InterpreterGenerator : public CodeGenerator {
 public:
  InterpreterGenerator() : CodeGenerator() {}
  virtual ~InterpreterGenerator() {}
  void Generate(son::node::NodeGraph* graph) override;
  void GenerateBcHandler(son::node::NodeGraph* graph, int call_index,
                         DispatchState dispatch_state);
  void GenerateExtHandler(son::node::NodeGraph* graph, int call_index);
};

}  // namespace primjs
#endif  // PRIMJS_INTERP_INTERPRETER_GENERATOR_H
