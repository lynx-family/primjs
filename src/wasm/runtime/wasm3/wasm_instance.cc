// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/wasm3/wasm_instance.h"

#include "runtime/wasm3/wasm_runtime.h"

namespace primjs::wasm {

Wasm3Instance::Wasm3Instance(Wasm3Runtime* runtime) : runtime_(runtime) {
  WLOGD("Running Wasm3Instance::%s...", __func__);
}

Wasm3Instance::~Wasm3Instance() {
  WLOGD("Running Wasm3Instance::%s...", __func__);

  if (instance_) {
    m3_UnloadModule(instance_);
    m3_FreeModule(instance_);
  }
}

// static
void Wasm3Instance::IncreaseRefCount(Wasm3Instance*& instance) {
  if (!instance) return;
  instance->ref_count_.fetch_add(1, std::memory_order_relaxed);
  WLOGD("Increasing Wasm3Instance ref count..., ref_count_ = %d",
        instance->ref_count_.load(std::memory_order_relaxed));
}

// static
void Wasm3Instance::DecreaseRefCount(Wasm3Instance*& instance) {
  if (!instance) return;
  WASM_DCHECK(instance->ref_count_.load(std::memory_order_acquire) > 0);
  instance->ref_count_.fetch_sub(1, std::memory_order_release);
  WLOGD("Decreasing Wasm3Instance ref count..., ref_count_ = %d",
        instance->ref_count_.load(std::memory_order_relaxed));
  if (instance->ref_count_.load(std::memory_order_acquire) == 0) {
    Destructor(instance);
  }
}

// static
void Wasm3Instance::Destructor(Wasm3Instance*& instance) {
  if (!instance) return;
  WLOGD("Destroying Wasm3Instance instance...");
  delete instance;
  instance = nullptr;
}

}  // namespace primjs::wasm
