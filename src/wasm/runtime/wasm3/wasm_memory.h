// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_WASM3_WASM_MEMORY_H_
#define SRC_WASM_RUNTIME_WASM3_WASM_MEMORY_H_

#include <cstdint>

#include "common/wasm_type.h"
#include "wasm3/m3_env.h"

namespace primjs::wasm {
class Wasm3Instance;
class Wasm3Runtime;

class Wasm3Memory {
 public:
  Wasm3Memory(Wasm3Runtime* runtime, uint32_t initial, uint32_t maximum,
              WasmResult& result);

  Wasm3Memory(Wasm3Runtime* runtime, IM3Memory p_mem);

  ~Wasm3Memory();

  bool valid() const;

  size_t pages();

  void* buffer() const;

  bool grow(uint32_t delta);

  IM3Memory memory() const { return memory_; }

 private:
  Wasm3Runtime* runtime_ = nullptr;

  IM3Memory memory_ = nullptr;
};

}  // namespace primjs::wasm

#endif  // SRC_WASM_RUNTIME_WASM3_WASM_MEMORY_H_
