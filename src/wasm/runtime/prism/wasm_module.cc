// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/prism/wasm_module.h"

#include "runtime/prism/wasm_runtime.h"

namespace primjs::wasm {
PrismModule::PrismModule(wasm_module_t* module, PrismRuntime* runtime)
    : runtime_(runtime), module_(module) {
  WLOGD("Running PrismModule::%s...", __func__);
}

PrismModule::~PrismModule() {
  WLOGD("Running PrismModule::%s...", __func__);
  // Older Prism revisions either freed bytecode still aliased by a live lazy
  // instance or made module deletion a no-op. Only opt in when the runtime
  // explicitly advertises the safe, escape-aware ownership contract.
#if defined(PRISM_MODULE_DELETE_RELEASES_UNINSTANTIATED_BYTECODE) && \
    PRISM_MODULE_DELETE_RELEASES_UNINSTANTIATED_BYTECODE
  wasm_module_delete(module_);
#endif
}

}  // namespace primjs::wasm
