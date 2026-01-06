// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_WASM_TYPE_H_
#define SRC_WASM_COMMON_WASM_TYPE_H_

#include "one_of.h"
#include "prism/wasm_c_api.h"
#include "wasm3/wasm3.h"

namespace primjs {
template <typename ValueType>
struct WasmValueT;

// Default definition for JSValueType
template <typename ValueType>
struct WasmValueT {};

// Specialization for JS engine: JSC
template <>
struct WasmValueT<M3TaggedValue> {
  using Value = M3TaggedValue;
  using Type = M3ValueType;
};

template <>
struct WasmValueT<wasm_val_t> {
  using Value = wasm_val_t;
  using Type = wasm_valkind_t;
};

// Type aliases using CRTP
template <typename ValueType>
using WasmValue = typename WasmValueT<ValueType>::Value;

template <typename ValueType>
using WasmValueType = typename WasmValueT<ValueType>::Type;

enum class WasmRuntimeType { WASM3 = 0, PRISM };

enum class ValueType {
  kTypeNone = 0,
  kTypeI32,
  kTypeI64,
  kTypeF32,
  kTypeF64,
  kTypeV128,
  kTypeExternref,
  kTypeAnyfunc
};

enum class TableElemType { kFuncRef = 0, kAnyRef = 1 };

inline ValueType StrToType(const char* type_str) {
  if (!strcmp(type_str, "i32")) {
    return ValueType::kTypeI32;
  } else if (!strcmp(type_str, "i64")) {
    return ValueType::kTypeI64;
  } else if (!strcmp(type_str, "f32")) {
    return ValueType::kTypeF32;
  } else if (!strcmp(type_str, "f64")) {
    return ValueType::kTypeF64;
  } else if (!strcmp(type_str, "externref")) {
    return ValueType::kTypeExternref;
  } else if (!strcmp(type_str, "anyfunc")) {
    return ValueType::kTypeAnyfunc;
  } else {
    return ValueType::kTypeNone;
  }
}

constexpr const int kWasmPageSize = 65536;
constexpr const uint32_t kMaxPagesNum = 65536;

using WasmResult = const char*;
constexpr const char* WasmSucceed = nullptr;

}  // namespace primjs

#endif  // SRC_WASM_COMMON_WASM_TYPE_H_
