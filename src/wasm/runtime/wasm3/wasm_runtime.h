// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_WASM3_WASM_RUNTIME_H_
#define SRC_WASM_RUNTIME_WASM3_WASM_RUNTIME_H_

#include <atomic>
#include <cmath>
#include <string>

#include "common/one_of.h"
#include "common/wasm_utils.h"
#include "wasm3/wasm3.h"

namespace primjs {
namespace qjs {
class QJSEnv;
}

namespace jsc {
class JSCEnv;
}

namespace wasm {
class WasmInstance;

using jsc::JSCEnv;
using qjs::QJSEnv;
using JSEnvRef = OneOf<QJSEnv*, JSCEnv*>;

class Wasm3Runtime {
 public:
  Wasm3Runtime();
  ~Wasm3Runtime();

  IM3Runtime GetRuntime() const { return m3_runtime_; }

  void ParseWasmModule(IM3Module* module, const uint8_t* const data, size_t len,
                       M3Result& result);

  static void WasmFunctionFinalizer(void* env);

  void SetJSEnv(JSEnvRef js_env) { js_env_ = js_env; }

  int InitRuntime();

  IM3Runtime m3_runtime() const { return m3_runtime_; }

  IM3Environment m3_env() const { return m3_env_; }

  auto& js_env() { return js_env_; }

  // spec: https://www.w3.org/TR/wasm-js-api-2/#towebassemblyvalue
  template <typename JSEnv>
  bool ToWebAssemblyValue(JSEnv* js_env, typename JSEnv::JSValue js_value,
                          IM3TaggedValue wasm_value) {
#if defined(__APPLE__)
    static_assert(std::is_same_v<JSEnv, QJSEnv> ||
                  std::is_same_v<JSEnv, JSCEnv>);
#else
    static_assert(std::is_same_v<JSEnv, QJSEnv>);
#endif
    using JSValue = typename JSEnv::JSValue;

    // 1. Assert: type is not v128. skip...
    M3ValueType type = wasm_value->type;
    JSValue exception = js_env->MakeNull();
    switch (type) {
      // 3. If type is i32,
      case M3ValueType::c_m3Type_i32: {
        // 3.1 Let i32 be ? ToInt32(v).
        int32_t i32 = 0;
        js_env->ValueToInt32(i32, js_value, exception);
        // 3.2 Return i32.const i32.
        wasm_value->value.i32 = i32;
        break;
      }
      // 2. If type is i64,
      case M3ValueType::c_m3Type_i64: {
        // 2.1 Let i64 be ? ToBigInt64(v).
        int64_t i64 = 0;
        js_env->ValueToBigInt64(i64, js_value, exception);
        // 2.2 Return i64.const i64.
        wasm_value->value.i64 = i64;
        break;
      }
      // 4. If type is f32,
      case M3ValueType::c_m3Type_f32: {
        // 4.1 Let f32 be ? ToNumber(v) rounded to the nearest representable
        //     value using IEEE 754-2008 round to nearest, ties to even
        //     mode.
        double f32 = 0;
        js_env->ValueToNumber(f32, js_value, exception);
        // 4.2 Return f32.const f32.
        wasm_value->value.f32 = static_cast<float>(f32);
        break;
      }
      // 5. If type is f64,
      case M3ValueType::c_m3Type_f64: {
        // 5.1 Let f64 be ? ToNumber(v).
        double f64 = 0;
        js_env->ValueToNumber(f64, js_value, exception);
        // 5.2 Return f64.const f64.
        wasm_value->value.f64 = f64;
        break;
      }
      // 6. funcref and 7. externref not supported, skip...
      // 8. Assert: This step is not reached.
      default:
        return false;
    }

    if (!js_env->IsNull(exception)) return false;
    return true;
  }

  template <typename JSEnv>
  bool ToJSValue(JSEnv* js_env, typename JSEnv::JSValue* js_value,
                 IM3TaggedValue wasm_value) {
    // Only support number yet.
    double d_value = 0;
    M3ValueType type = wasm_value->type;
    switch (type) {
      case M3ValueType::c_m3Type_i32: {
        int32_t r = *(reinterpret_cast<int32_t*>(&wasm_value->value.i32));
        d_value = static_cast<double>(r);
      } break;
      case M3ValueType::c_m3Type_i64: {
        int64_t r = *(reinterpret_cast<int64_t*>(&wasm_value->value.i64));
        d_value = static_cast<double>(r);
      } break;
      case M3ValueType::c_m3Type_f32: {
        float r = *(reinterpret_cast<float*>(&wasm_value->value.f32));
        d_value = static_cast<double>(r);
      } break;
      case M3ValueType::c_m3Type_f64:
        d_value = *(reinterpret_cast<double*>(&wasm_value->value.f64));
        break;
      default:
        return false;
    }

    *js_value = js_env->MakeNumber(d_value);
    return true;
  }

  static std::string CreateSignature(IM3Function target);

  static char ConvertTypeIdToTypeChar(M3ValueType ty);

 private:
  BORROWER JSEnvRef js_env_;

  OWNER IM3Environment m3_env_;

  OWNER IM3Runtime m3_runtime_;
};

}  // namespace wasm
}  // namespace primjs
#endif  // SRC_WASM_RUNTIME_WASM3_WASM_RUNTIME_H_
