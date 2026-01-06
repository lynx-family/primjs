// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_WASM3_GLOBAL_H_
#define SRC_WASM_RUNTIME_WASM3_GLOBAL_H_

#include "common/wasm_type.h"
#include "wasm3/m3_env.h"

namespace primjs::wasm {
class Wasm3Instance;
class Wasm3Runtime;

// Global class for wasm3 engine, including IM3Global pointer for import/export
// and IM3TaggedValue for standalone global.value from javascript.
class Wasm3Global {
 public:
  Wasm3Global(Wasm3Runtime* runtime, bool mutability, double value,
              ValueType type);
  Wasm3Global(Wasm3Runtime* runtime, IM3Global global, Wasm3Instance* instance);
  ~Wasm3Global();

  int SetValue(double value);

  M3TaggedValue& value() { return value_; }

  int GetValue(IM3TaggedValue value);

  void set_global(IM3Global global) { global_ = global; }

  bool mutability() { return mutability_; }

  IM3Global global() const { return global_; }

  Wasm3Instance* instance() const { return instance_; }

  Wasm3Runtime* runtime() const { return runtime_; }

  void set_instance(Wasm3Instance* instance);

  int SetLinkedValue(double value);

  ValueType GetType();

 private:
  Wasm3Global(const Wasm3Global&) = delete;
  Wasm3Global(Wasm3Global&&) = delete;
  Wasm3Global& operator=(Wasm3Global&&) = delete;

  BORROWER Wasm3Runtime* runtime_;

  bool mutability_ = false;
  // Global imported into or exported from wasm3 engine.
  // No need to free.
  BORROWER IM3Global global_ = nullptr;
  // This value is constructed by JavaScript `new WebAssembly.Global(xxx)`;
  // It may not equals to the value in `this->global_` because if `global_` is
  // not NULL, this member should be deprecated and never used again. Although,
  // if we follow WebAssembly JS-API spec, this->value_ should always equal to
  // the value in this->global_. But, based on the fact that wasm3's instance is
  // destroyed after runtime did, this->global_ will not deleted until wasm
  // program exited, so we can always use global_ once it is not null.
  M3TaggedValue value_;

  BORROWER Wasm3Instance* instance_ = nullptr;
};

}  // namespace primjs::wasm

#endif  // SRC_WASM_RUNTIME_WASM3_GLOBAL_H_
