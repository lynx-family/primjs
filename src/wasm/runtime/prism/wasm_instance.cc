// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/prism/wasm_instance.h"

#include "runtime/prism/wasm_runtime.h"

namespace primjs::wasm {

PrismInstance::PrismInstance(PrismRuntime* runtime) : runtime_(runtime) {
  WLOGD("Running PrismInstance::%s...", __func__);
}

PrismInstance::~PrismInstance() {
  WLOGD("Running PrismInstance::%s...", __func__);
  if (instance_) wasm_instance_delete(instance_);
}

// static
void PrismInstance::IncreaseRefCount(PrismInstance*& instance) {
  if (!instance) return;
  instance->ref_count_.fetch_add(1, std::memory_order_relaxed);
  WLOGD("Increasing PrismInstance ref count..., ref_count_ = %d",
        instance->ref_count_.load(std::memory_order_relaxed));
}

// static
void PrismInstance::DecreaseRefCount(PrismInstance*& instance) {
  if (!instance) return;
  WASM_DCHECK(instance->ref_count_.load(std::memory_order_acquire) > 0);
  instance->ref_count_.fetch_sub(1, std::memory_order_release);
  WLOGD("Decreasing PrismInstance ref count..., ref_count_ = %d",
        instance->ref_count_.load(std::memory_order_relaxed));
  if (instance->ref_count_.load(std::memory_order_acquire) == 0) {
    Destructor(instance);
  }
}

// static
void PrismInstance::Destructor(PrismInstance*& instance) {
  if (!instance) return;
  WLOGD("Destroying PrismInstance instance...");
  delete instance;
  instance = nullptr;
}

}  // namespace primjs::wasm
