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

class PrismMemory {
 public:
  explicit PrismMemory(wasm_memory_t* memory);
  PrismMemory(uint32_t initial, uint32_t maximum);
  PrismMemory(wasm_memory_t* memory, PrismInstance* instance);
  ~PrismMemory();

  wasm_memory_t* memory() { return memory_; }

  bool valid() const;
  size_t pages();
  void* buffer();
  bool grow(uint32_t delta);

 private:
  wasm_memory_t* memory_;
  [[maybe_unused]] PrismInstance* instance_ = nullptr;
};

}  // namespace wasm
}  // namespace primjs

#endif  // SRC_WASM_RUNTIME_WASM_PRISM_MEMORY_H_
