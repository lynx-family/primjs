// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_WASM_PRISM_GLOBAL_H_
#define SRC_WASM_RUNTIME_WASM_PRISM_GLOBAL_H_

#include <memory>

#include "common/wasm_type.h"
#include "prism/wasm_c_api.h"
#include "runtime/prism/wasm_runtime.h"

namespace primjs::wasm {
class PrismInstance;

class PrismGlobal {
 public:
  PrismGlobal(wasm_global_t* global, double value, PrismRuntime* runtime);

  PrismGlobal(wasm_global_t* global, bool mutability, wasm_val_t* value,
              PrismRuntime* runtime);

  PrismGlobal(wasm_global_t* global, bool mutability, wasm_val_t* value,
              PrismRuntime* runtime, PrismInstance* instance);

  ~PrismGlobal();

  // setter and getter for value
  int set_value(double value);

  int GetValue(wasm_val_t* value) {
    wasm_global_get(global_, value);
    return 0;
  }

  wasm_val_t* value() { return &value_; }

  // get metadata from here
  bool mutability() { return mutability_; }

  wasm_global_t* global() { return global_; }

  void set_global(wasm_global_t* global);

  static bool mutability(wasm_global_t* global);

  ValueType GetType();

  PrismRuntime* runtime() const { return runtime_; }

 private:
  bool mutability_;

  PrismRuntime* runtime_ = nullptr;

  wasm_val_t value_;
  wasm_global_t* global_ = nullptr;
  [[maybe_unused]] PrismInstance* instance_ = nullptr;
};

}  // namespace primjs::wasm
#endif  // SRC_WASM_RUNTIME_WASM_PRISM_GLOBAL_H_
