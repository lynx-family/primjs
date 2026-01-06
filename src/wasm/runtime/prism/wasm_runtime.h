// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_WASM_PRISM_RUNTIME_H_
#define SRC_WASM_RUNTIME_WASM_PRISM_RUNTIME_H_

#include <cmath>
#include <memory>

#include "common/wasm_type.h"
#include "common/wasm_utils.h"
#include "prism/prism.h"
#include "prism/wasm_c_api.h"

namespace primjs {
namespace qjs {
class QJSEnv;
}
namespace jsc {
class JSCEnv;
}

namespace wasm {
using jsc::JSCEnv;
using qjs::QJSEnv;
using JSEnvRef = OneOf<QJSEnv*, JSCEnv*>;

class PrismRuntime {
 public:
  PrismRuntime();
  ~PrismRuntime();

  wasm_store_t* wasm_store() const { return wasm_store_; }

  static void WasmFunctionFinalizer(void* env);

  void SetJSEnv(JSEnvRef js_env) { js_env_ = js_env; }

  auto& js_env() { return js_env_; }

  // FIXME(wasm):
  // There is accuracy loss in conversion from double to float, eg. 3.2 is
  // transformed to 3.200000047683716.
  template <typename JSEnv>
  bool ToJSValue(JSEnv* js_env, typename JSEnv::JSValue* js_value,
                 wasm_val_t* wasm_value) {
    // Only support number yet.
    double d_value = 0;
    wasm_valkind_t type = wasm_value->kind;
    switch (type) {
      case wasm_valkind_enum::WASM_I32:
        d_value = static_cast<double>(wasm_value->of.i32);
        break;
      case wasm_valkind_enum::WASM_I64:
        d_value = static_cast<double>(wasm_value->of.i64);
        break;
      case wasm_valkind_enum::WASM_F32:
        d_value = static_cast<float>(wasm_value->of.f32);
        break;
      case wasm_valkind_enum::WASM_F64:
        d_value = wasm_value->of.f64;
        break;
      default:
        return false;
    }

    *js_value = js_env->MakeNumber(d_value);
    return true;
  }

  template <typename JSEnv>
  bool ToJSValue(JSEnv* js_env, typename JSEnv::JSValue* js_value,
                 prism_value_type type, uint64_t* w_val) {
    double dvalue = 0;
    switch (type) {
      case I32: {
        int32_t r = *(reinterpret_cast<int32_t*>(w_val));
        dvalue = static_cast<double>(r);
        break;
      }
      case I64: {
        int64_t r = *(reinterpret_cast<int64_t*>(w_val));
        dvalue = static_cast<double>(r);
        break;
      }
      case F32: {
        float r = *(reinterpret_cast<double*>(w_val));
        dvalue = static_cast<double>(r);
        break;
      }
      case F64: {
        dvalue = *(reinterpret_cast<double*>(w_val));
        break;
      }
      default:
        return false;
    }
    *js_value = js_env->MakeNumber(dvalue);
    return true;
  }

  template <typename JSEnv>
  bool ToWebAssemblyValue(JSEnv* js_env, typename JSEnv::JSValue js_value,
                          wasm_val_t* wasm_value) {
#if defined(__APPLE__)
    static_assert(std::is_same_v<JSEnv, qjs::QJSEnv> ||
                  std::is_same_v<JSEnv, jsc::JSCEnv>);
#else
    static_assert(std::is_same_v<JSEnv, qjs::QJSEnv>);
#endif
    using JSValue = typename JSEnv::JSValue;

    wasm_valkind_t type = wasm_value->kind;
    JSValue exception = js_env->MakeNull();
    switch (type) {
      case wasm_valkind_enum::WASM_I32: {
        int32_t i32 = 0;
        js_env->ValueToInt32(i32, js_value, exception);
        wasm_value->of.i32 = i32;
        break;
      }
      case wasm_valkind_enum::WASM_I64: {
        int64_t i64 = 0;
        js_env->ValueToBigInt64(i64, js_value, exception);
        wasm_value->of.i64 = i64;
        break;
      }
      case wasm_valkind_enum::WASM_F32: {
        double f32 = 0;
        js_env->ValueToNumber(f32, js_value, exception);
        wasm_value->of.f32 = static_cast<float>(f32);
        break;
      }
      case wasm_valkind_enum::WASM_F64: {
        double f64 = 0;
        js_env->ValueToNumber(f64, js_value, exception);
        wasm_value->of.f64 = f64;
        break;
      }
      default:
        return false;
    }

    if (wasm_unlikely(!js_env->IsNull(exception))) return false;
    return true;
  }

  template <typename JSEnv>
  bool ToWebAssemblyValue(JSEnv* js_env, typename JSEnv::JSValue js_value,
                          prism_value_type type, uint64_t* w_val) {
#if defined(__APPLE__)
    static_assert(std::is_same_v<JSEnv, qjs::QJSEnv> ||
                  std::is_same_v<JSEnv, jsc::JSCEnv>);
#else
    static_assert(std::is_same_v<JSEnv, qjs::QJSEnv>);
#endif
    using JSValue = typename JSEnv::JSValue;

    JSValue exception = js_env->MakeNull();
    switch (type) {
      case I32: {
        int32_t i32 = 0;
        js_env->ValueToInt32(i32, js_value, exception);
        *(reinterpret_cast<uint32_t*>(w_val)) = (uint32_t)i32;
        break;
      }
      case I64: {
        int64_t i64 = 0;
        js_env->ValueToBigInt64(i64, js_value, exception);
        *(reinterpret_cast<uint64_t*>(w_val)) = (uint64_t)i64;
        break;
      }
      case F32: {
        double f32 = 0;
        js_env->ValueToNumber(f32, js_value, exception);
        *(reinterpret_cast<double*>(w_val)) = static_cast<float>(f32);
        break;
      }
      case F64: {
        double f64 = 0;
        js_env->ValueToNumber(f64, js_value, exception);
        *(reinterpret_cast<double*>(w_val)) = f64;
        break;
      }
      default:
        return false;
    }

    if (wasm_unlikely(!js_env->IsNull(exception))) return false;
    return true;
  }

  int NumberToWasm(double d_value, wasm_val_t* w_val);

  wasm_valkind_t WasmType(ValueType type);

  int InitRuntime();

 private:
  BORROWER JSEnvRef js_env_;

  OWNER wasm_engine_t* wasm_engine_;
  OWNER wasm_store_t* wasm_store_;
};

}  // namespace wasm
}  // namespace primjs
#endif  // SRC_WASM_RUNTIME_WASM_PRISM_RUNTIME_H_
