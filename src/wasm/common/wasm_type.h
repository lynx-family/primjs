// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_WASM_TYPE_H_
#define SRC_WASM_COMMON_WASM_TYPE_H_

#include <cmath>
#include <cstdint>
#include <cstdlib>
#include <cstring>

#include "common/wasm_c_api_dispatch.h"
#include "common/wasm_utils.h"

namespace primjs {

inline bool LimitsMatch(const wasm_limits_t* expected, uint32_t actual_size,
                        uint32_t actual_max) {
  if (!expected || actual_size < expected->min) return false;
  if (expected->max == wasm_limits_max_default) return true;
  return actual_max != wasm_limits_max_default && actual_max <= expected->max;
}

inline bool NumberToWasmVal(double dvalue, wasm_val_t* w_val) {
  switch (w_val->kind) {
    case WASM_I32:
      w_val->of.i32 = (std::isnan(dvalue) || std::isinf(dvalue))
                          ? 0
                          : static_cast<int32_t>(dvalue);
      return true;
    case WASM_I64:
      w_val->of.i64 = (std::isnan(dvalue) || std::isinf(dvalue))
                          ? 0
                          : static_cast<int64_t>(dvalue);
      return true;
    case WASM_F32:
      w_val->of.f32 = static_cast<float>(dvalue);
      return true;
    case WASM_F64:
      w_val->of.f64 = dvalue;
      return true;
    default:
      return false;
  }
}

// Compact function signature cache without per-function std::vector overhead.
class WasmSignature {
 public:
  static constexpr size_t kInlineCap = 8;

  WasmSignature() = default;
  ~WasmSignature() { std::free(heap_kinds_); }
  WasmSignature(const WasmSignature&) = delete;
  WasmSignature& operator=(const WasmSignature&) = delete;

  bool Ensure(const wasm_func_t* func) {
    if (wasm_likely(ready_)) return true;
    return EnsureSlow(func);
  }

  bool Matches(const wasm_functype_t* expected) const;

  size_t param_count() const { return param_count_; }
  size_t result_count() const { return result_count_; }
  const wasm_valkind_t* param_kinds() const {
    return (param_count_ + result_count_ > kInlineCap) ? heap_kinds_
                                                       : inline_kinds_;
  }
  const wasm_valkind_t* result_kinds() const {
    return param_kinds() + param_count_;
  }

 private:
  bool EnsureSlow(const wasm_func_t* func);

  uint16_t param_count_ = 0;
  uint16_t result_count_ = 0;
  bool ready_ = false;
  wasm_valkind_t inline_kinds_[kInlineCap] = {};
  wasm_valkind_t* heap_kinds_ = nullptr;
};

constexpr const int kWasmPageSize = 65536;
constexpr const uint32_t kMaxPagesNum = 65536;

using WasmResult = const char*;
constexpr const char* WasmSucceed = nullptr;

}  // namespace primjs

#endif  // SRC_WASM_COMMON_WASM_TYPE_H_
