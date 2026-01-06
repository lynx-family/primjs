// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/prism/wasm_global.h"

#include "runtime/prism/wasm_instance.h"
#include "runtime/prism/wasm_runtime.h"

namespace primjs::wasm {

PrismGlobal::PrismGlobal(wasm_global_t* global, double value,
                         PrismRuntime* runtime)
    : runtime_(runtime), global_(global) {
  WLOGD("Running PrismGlobal::%s...", __func__);
  set_value(value);
}

PrismGlobal::PrismGlobal(wasm_global_t* global, bool mutability,
                         wasm_val_t* value, PrismRuntime* runtime)
    : mutability_(mutability), runtime_(runtime), global_(global) {
  WLOGD("Running PrismGlobal::%s...", __func__);
  if (!global_) {
    wasm_valtype_t* type = wasm_valtype_new(value->kind);
    wasm_globaltype_t* global_type =
        wasm_globaltype_new(type, mutability ? WASM_VAR : WASM_CONST);
    global_ = wasm_global_new(const_cast<wasm_store_t*>(runtime_->wasm_store()),
                              global_type, value);
  }
  wasm_val_copy(&value_, value);
  wasm_global_set(global_, &value_);
}

PrismGlobal::PrismGlobal(wasm_global_t* global, bool mutability,
                         wasm_val_t* value, PrismRuntime* runtime,
                         PrismInstance* instance)
    : mutability_(mutability),
      runtime_(runtime),
      global_(global),
      instance_(instance) {
  WLOGD("Running PrismGlobal::%s...", __func__);
  wasm_val_copy(&value_, value);
  PrismInstance::IncreaseRefCount(instance);
}

PrismGlobal::~PrismGlobal() {
  WLOGD("Running PrismGlobal::%s...", __func__);
  if (global_) {
    wasm_global_delete(global_);
  }
  PrismInstance::DecreaseRefCount(instance_);
}

void PrismGlobal::set_global(wasm_global_t* global) {
  global_ = global;
  wasm_global_get(global_, &value_);
}

int PrismGlobal::set_value(double value) {
  if (!global_) {
    return 1;
  }
  value_.kind =
      wasm_valtype_kind(wasm_globaltype_content(wasm_global_type(global_)));
  if (runtime_->NumberToWasm(value, &value_)) {
    return 1;
  }
  wasm_global_set(global_, &value_);
  return 0;
}

// static
bool PrismGlobal::mutability(wasm_global_t* global) {
  wasm_globaltype_t* val_type = wasm_global_type(global);
  wasm_mutability_t mutability = wasm_globaltype_mutability(val_type);
  return mutability == WASM_VAR;
}

ValueType PrismGlobal::GetType() {
  wasm_globaltype_t* gbl_type = wasm_global_type(global_);
  const wasm_valtype_t* type = wasm_globaltype_content(gbl_type);
  switch (wasm_valtype_kind(type)) {
    case WASM_I32:
      return ValueType::kTypeI32;
    case WASM_I64:
      return ValueType::kTypeI64;
    case WASM_F32:
      return ValueType::kTypeF32;
    case WASM_F64:
      return ValueType::kTypeF64;
    case WASM_FUNCREF:
    case WASM_ANYREF:
    default:
      return ValueType::kTypeNone;
  }
}

}  // namespace primjs::wasm
