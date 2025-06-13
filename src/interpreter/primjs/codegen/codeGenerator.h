// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_INTERP_CODE_GENERATOR_H
#define PRIMJS_INTERP_CODE_GENERATOR_H

#include "primjs/base/globals.h"
#include "primjs/son/nodeGraph.h"

namespace primjs {

class CodeGenerator {
 public:
  CodeGenerator() {}
  virtual ~CodeGenerator() {}

  virtual void Generate(son::node::NodeGraph* graph) = 0;
};

}  // namespace primjs
#endif  // PRIMJS_INTERP_CODE_GENERATOR_H
