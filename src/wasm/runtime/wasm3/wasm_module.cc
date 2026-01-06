// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/wasm3/wasm_module.h"

#include "common/wasm_utils.h"
#include "runtime/wasm3/wasm_runtime.h"

namespace primjs::wasm {
Wasm3Module::Wasm3Module(const uint8_t* data, const size_t len,
                         IM3Module module, Wasm3Runtime* rt)
    : runtime_(rt), data_(new uint8_t[len]), len_(len), module_(module) {
  std::memcpy(data_, data, len);
}

Wasm3Module::~Wasm3Module() {
  WLOGD("Running Wasm3Module::%s...", __func__);

  // When this module is not loaded to runtime.
  // It is owned by M3Runtime otherwise.
  if (module_ && !module_->runtime) FreeModule();
  delete[] data_;
  data_ = nullptr;
}

void Wasm3Module::FreeModule() {
  // When instantiating failed.
  m3_FreeModule(module_);
  module_ = nullptr;
}

void Wasm3Module::ReParse(IM3Module* module, M3Result& result) {
  runtime_->ParseWasmModule(module, data_, len_, result);
}

}  // namespace primjs::wasm
