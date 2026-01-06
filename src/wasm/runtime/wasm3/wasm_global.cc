// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/wasm3/wasm_global.h"

#include "runtime/wasm3/wasm_function.h"
#include "runtime/wasm3/wasm_instance.h"
#include "runtime/wasm3/wasm_runtime.h"

namespace primjs::wasm {

Wasm3Global::Wasm3Global(Wasm3Runtime* runtime, bool mutability, double value,
                         ValueType type)
    : runtime_(runtime),
      mutability_(mutability),
      global_(nullptr),
      instance_(nullptr) {
  // Wasm3 global only support four number types.
  // The value here must be filtered and converted by `ToWebAssemblyValue()`,
  // see https://webassembly.github.io/spec/js-api/#towebassemblyvalue
  switch (type) {
    case ValueType::kTypeI32:
      value_.type = c_m3Type_i32;
      value_.value.i32 = (i32)value;
      break;
    case ValueType::kTypeI64:
      value_.type = c_m3Type_i64;
      value_.value.i64 = (i64)value;
      break;
    case ValueType::kTypeF32:
      value_.type = c_m3Type_f32;
      value_.value.f32 = (f32)value;
      break;
    case ValueType::kTypeF64:
      value_.type = c_m3Type_f64;
      value_.value.f64 = (f64)value;
      break;
    default:
      return;
  }
}

Wasm3Global::Wasm3Global(Wasm3Runtime* runtime, IM3Global global,
                         Wasm3Instance* instance)
    : runtime_(runtime),
      mutability_(global->isMutable),
      global_(global),
      instance_(instance) {
  Wasm3Instance::IncreaseRefCount(instance);
}

Wasm3Global::~Wasm3Global() {
  global_ = nullptr;
  Wasm3Instance::DecreaseRefCount(instance_);
}

// The value here must be filtered and converted by `ToWebAssemblyValue()`,
int Wasm3Global::SetValue(double value) {
  // There is no need to compare type here because `ToWebAssemblyValue` have
  // done this.
  M3ValueType type = global_ ? m3_GetGlobalType(global_) : value_.type;
  value_.type = type;

  switch (type) {
    case c_m3Type_i32:
      value_.value.i32 = (i32)value;
      break;
    case c_m3Type_i64:
      value_.value.i64 = (i64)value;
      break;
    case c_m3Type_f32:
      value_.value.f32 = (f32)value;
      break;
    case c_m3Type_f64:
      value_.value.f64 = (f64)value;
      break;
    default:
      return 1;
  }

  if (global_) {
    return m3_SetGlobal(global_, &value_) != m3Err_none;
  }

  return 0;
}

int Wasm3Global::GetValue(IM3TaggedValue value) {
  int result = 0;

  if (global_ && value) {
    result = m3_GetGlobal(global_, value) == m3Err_none;
  } else {
    *value = value_;
  }

  return result;
}

int Wasm3Global::SetLinkedValue(double value) {
  if (!global_) {
    return 1;
  }

  M3ValueType type = m3_GetGlobalType(global_);
  switch (type) {
    case c_m3Type_i32:
      global_->intValue = (i32)value;
      break;
    case c_m3Type_i64:
      global_->intValue = (i64)value;
      break;
    case c_m3Type_f32:
      global_->f32Value = (f32)value;
      break;
    case c_m3Type_f64:
      global_->f64Value = (f64)value;
      break;
    default:
      return 1;
  }

  return 0;
}

ValueType Wasm3Global::GetType() {
  M3ValueType type = global_ ? m3_GetGlobalType(global_) : value_.type;
  switch (type) {
    case c_m3Type_i32:
      return ValueType::kTypeI32;
    case c_m3Type_i64:
      return ValueType::kTypeI64;
    case c_m3Type_f32:
      return ValueType::kTypeF32;
    case c_m3Type_f64:
      return ValueType::kTypeF64;
    default:
      return ValueType::kTypeNone;
  }
}

void Wasm3Global::set_instance(Wasm3Instance* instance) {
  Wasm3Instance::IncreaseRefCount(instance);
  Wasm3Instance::DecreaseRefCount(instance_);
  instance_ = instance;
}

}  // namespace primjs::wasm
