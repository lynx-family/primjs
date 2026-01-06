// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/prism/wasm_module.h"

#include <string>

#include "runtime/prism/wasm_runtime.h"

namespace primjs::wasm {
PrismModule::PrismModule(wasm_module_t* module, PrismRuntime* runtime)
    : runtime_(runtime), module_(module) {
  WLOGD("Running PrismMemory::%s...", __func__);
}

PrismModule::~PrismModule() {
  WLOGD("Running PrismMemory::%s...", __func__);
  if (module_) wasm_module_delete(module_);
}

}  // namespace primjs::wasm
