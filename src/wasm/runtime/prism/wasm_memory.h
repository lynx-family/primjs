// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_WASM_PRISM_MEMORY_H_
#define SRC_WASM_RUNTIME_WASM_PRISM_MEMORY_H_

#include <cstdint>
#include <memory>

#include "prism/wasm_c_api.h"

namespace primjs {
namespace wasm {
class PrismInstance;
class PrismRuntime;

class PrismMemory {
 public:
  explicit PrismMemory(wasm_memory_t* memory);
  PrismMemory(PrismRuntime* runtime, uint32_t initial, uint32_t maximum);
  PrismMemory(wasm_memory_t* memory, PrismRuntime* runtime,
              PrismInstance* instance, uint32_t maximum);
  ~PrismMemory();

  wasm_memory_t* memory() { return memory_; }
  uint32_t maximum() const { return maximum_; }
  PrismRuntime* runtime() const { return runtime_; }

  bool valid() const;
  size_t pages();
  void* buffer();
  bool grow(uint32_t delta);

 private:
  wasm_memory_t* memory_;
  uint32_t maximum_ = wasm_limits_max_default;
  PrismRuntime* runtime_ = nullptr;
  [[maybe_unused]] PrismInstance* instance_ = nullptr;
  bool owns_handle_ = false;
};

}  // namespace wasm
}  // namespace primjs

#endif  // SRC_WASM_RUNTIME_WASM_PRISM_MEMORY_H_
