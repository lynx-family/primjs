// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/prism/wasm_global.h"

#include "common/wasm_utils.h"
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
    if (global_type) {
      global_ = wasm_global_new(runtime_->wasm_store(), global_type, value);
      wasm_globaltype_delete(global_type);
    } else {
      wasm_valtype_delete(type);
    }
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
      instance_(instance),
      owns_handle_(true) {
  WLOGD("Running PrismGlobal::%s...", __func__);
  wasm_val_copy(&value_, value);
  PrismInstance::IncreaseRefCount(instance);
}

PrismGlobal::~PrismGlobal() {
  WLOGD("Running PrismGlobal::%s...", __func__);
  if (owns_handle_) {
    wasm_global_delete(global_);
  }
  global_ = nullptr;
  PrismInstance::DecreaseRefCount(instance_);
}

void PrismGlobal::set_global(wasm_global_t* global) {
  global_ = global;
  wasm_global_get(global_, &value_);
}

int PrismGlobal::set_value(double value) {
  if (wasm_unlikely(!global_)) {
    return 1;
  }
  wasm_globaltype_t* global_type = wasm_global_type(global_);
  value_.kind = wasm_valtype_kind(wasm_globaltype_content(global_type));
  wasm_globaltype_delete(global_type);
  if (wasm_unlikely(runtime_->NumberToWasm(value, &value_))) {
    return 1;
  }
  wasm_global_set(global_, &value_);
  return 0;
}

int PrismGlobal::set_value(const wasm_val_t* value) {
  if (wasm_unlikely(!global_ || !value)) {
    return 1;
  }
  wasm_globaltype_t* global_type = wasm_global_type(global_);
  wasm_valkind_t expected =
      wasm_valtype_kind(wasm_globaltype_content(global_type));
  wasm_globaltype_delete(global_type);
  if (wasm_unlikely(value->kind != expected)) {
    return 1;
  }
  wasm_val_copy(&value_, value);
  wasm_global_set(global_, &value_);
  return 0;
}

// static
bool PrismGlobal::mutability(wasm_global_t* global) {
  wasm_globaltype_t* val_type = wasm_global_type(global);
  wasm_mutability_t mutability = wasm_globaltype_mutability(val_type);
  wasm_globaltype_delete(val_type);
  return mutability == WASM_VAR;
}

ValueType PrismGlobal::GetType() {
  auto ret = ValueType::kTypeNone;
  wasm_globaltype_t* gbl_type = wasm_global_type(global_);
  const wasm_valtype_t* type = wasm_globaltype_content(gbl_type);
  switch (wasm_valtype_kind(type)) {
    case WASM_I32:
      ret = ValueType::kTypeI32;
      break;
    case WASM_I64:
      ret = ValueType::kTypeI64;
      break;
    case WASM_F32:
      ret = ValueType::kTypeF32;
      break;
    case WASM_F64:
      ret = ValueType::kTypeF64;
      break;
    case WASM_FUNCREF:
    case WASM_ANYREF:
    default:
      ret = ValueType::kTypeNone;
  }
  wasm_globaltype_delete(gbl_type);
  return ret;
}

}  // namespace primjs::wasm
