// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/prism/wasm_memory.h"

#include <cstdlib>

#include "common/wasm_log.h"
#include "common/wasm_type.h"
#include "common/wasm_utils.h"
#include "prism/wasm_c_api.h"
#include "runtime/prism/wasm_runtime.h"

namespace primjs::wasm {
class PrismInstance;

PrismMemory::PrismMemory(PrismRuntime* runtime, uint32_t initial,
                         uint32_t maximum)
    : memory_(nullptr), maximum_(maximum), runtime_(runtime) {
  WLOGD("Running PrismMemory::%s...", __func__);
  wasm_limits_t limit = {initial, maximum};
  wasm_memorytype_t* type = wasm_memorytype_new(&limit);
  memory_ = wasm_memory_new(runtime_->wasm_store(), type);
  wasm_memorytype_delete(type);
}

PrismMemory::PrismMemory(wasm_memory_t* memory) : memory_(memory) {}

PrismMemory::PrismMemory(wasm_memory_t* memory, PrismRuntime* runtime,
                         PrismInstance* instance, uint32_t maximum)
    : memory_(memory),
      maximum_(maximum),
      runtime_(runtime),
      instance_(instance),
      owns_handle_(true) {}

PrismMemory::~PrismMemory() {
  if (owns_handle_) {
    wasm_memory_delete(memory_);
  }
  memory_ = nullptr;
}

bool PrismMemory::valid() const { return memory_ != nullptr; }

void* PrismMemory::buffer() {
  // memory by exports
  if (wasm_likely(memory_)) {
    return wasm_memory_data(memory_);
  } else {
    return nullptr;
  }
}

size_t PrismMemory::pages() {
  // create by exports
  if (wasm_likely(memory_)) {
    return wasm_memory_data_size(memory_) / kWasmPageSize;
  } else {
    return 0;
  }
}

bool PrismMemory::grow(uint32_t delta) {
  return wasm_memory_grow(memory_, delta);
}
}  // namespace primjs::wasm
