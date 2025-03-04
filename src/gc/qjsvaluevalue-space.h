// Copyright 2009 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_GC_QJSVALUEVALUE_SPACE_H_
#define SRC_GC_QJSVALUEVALUE_SPACE_H_

#include "gc/persistent-handle.h"
class QJSValueValueSpace final {
 public:
  QJSValueValueSpace(const QJSValueValueSpace&) = delete;
  QJSValueValueSpace& operator=(const QJSValueValueSpace&) = delete;

  class NodeBlock;
  class NodeIterator;
  class NodeSpace;

  static void Destroy(void* location);
  explicit QJSValueValueSpace(LEPUSRuntime* runtime);
  ~QJSValueValueSpace();
  void* Create();
  void IterateAllRoots(int local_idx);
  LEPUSRuntime* runtime() const { return runtime_; }

 private:
  LEPUSRuntime* runtime_;
  NodeSpace* regular_nodes_;
};

#endif  // SRC_GC_QJSVALUEVALUE_SPACE_H_
