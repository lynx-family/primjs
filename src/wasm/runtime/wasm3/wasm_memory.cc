// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/wasm3/wasm_memory.h"

#include "common/wasm_utils.h"
#include "runtime/wasm3/wasm_runtime.h"

namespace primjs::wasm {

Wasm3Memory::Wasm3Memory(Wasm3Runtime* runtime, uint32_t initial,
                         uint32_t maximum, WasmResult& result)
    : runtime_(runtime) {
  result = m3_NewMemory(&memory_, runtime_->GetRuntime(), initial, maximum);
}

Wasm3Memory::Wasm3Memory(Wasm3Runtime* runtime, IM3Memory p_mem)
    : runtime_(runtime), memory_(p_mem) {}

Wasm3Memory::~Wasm3Memory() {
  // The following instruction is trivial if this memory is linked against one
  // instance which is responsible for releasing the actual memory.
  m3_FreeMemory(memory_);
  memory_ = nullptr;
}

bool Wasm3Memory::grow(uint32_t delta) {
  WLOGD("memory.grow from %u(+%u) -> %u", memory_->numPages, delta,
        memory_->numPages + delta);
  return m3Err_none == m3_GrowMemory(memory_, runtime_->GetRuntime(), delta);
}

size_t Wasm3Memory::pages() { return memory_->numPages; }

void* Wasm3Memory::buffer() const { return m3_GetMemory(memory_, nullptr, 0); }

}  // namespace primjs::wasm
