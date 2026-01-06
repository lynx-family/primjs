// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_WASM3_FUNC_PACK_H_
#define SRC_WASM_RUNTIME_WASM3_FUNC_PACK_H_

#include <string>

#include "common/js_type.h"
#include "common/wasm_log.h"
#if defined(__APPLE__)
#include "jsc/js_env_jsc.h"
#endif
#include "qjs/js_env_qjs.h"
#include "runtime/wasm3/wasm_runtime.h"
#include "wasm3/m3_env.h"

namespace primjs::wasm {
class Wasm3Instance;

class Wasm3Function {
 public:
  Wasm3Function(IM3Function m3_func, Wasm3Runtime* rt, Wasm3Instance* instance);
  Wasm3Function(JSValueRefs func, Wasm3Runtime* rt, Wasm3Instance* instance,
                IM3Function m3_func);

  ~Wasm3Function();

  Wasm3Function(const Wasm3Function&) = default;

  IM3Function function() const { return m3_function_; }

  static const void* QJSWasmCallback(IM3Runtime runtime, IM3ImportContext _ctx,
                                     u64* _sp, void* _mem);

#if defined(__APPLE__)
  static const void* JSCWasmCallback(IM3Runtime runtime, IM3ImportContext _ctx,
                                     u64* _sp, void* _mem);
#endif

  template <typename JSEnv>
  int JsToWasm(JSEnv* js_env, typename JSEnv::JSValue val, M3ValueType m3_type,
               u64* w_val) {
    // Only support number yet.
    if (!js_env->IsNumber(val)) return 1;
    double dvalue = js_env->ValueToNumber(val);

    switch (m3_type) {
      case c_m3Type_i32:
        if (wasm_unlikely(isnan(dvalue) || isinf(dvalue))) {
          *(reinterpret_cast<uint32_t*>(w_val)) = 0;
        } else {
          *(reinterpret_cast<uint32_t*>(w_val)) = static_cast<int32_t>(dvalue);
        }
        break;
      case c_m3Type_i64:
        if (wasm_unlikely(isnan(dvalue) || isinf(dvalue))) {
          *(reinterpret_cast<uint64_t*>(w_val)) = 0;
        } else {
          *(reinterpret_cast<uint64_t*>(w_val)) = static_cast<int64_t>(dvalue);
        }
        break;
      case c_m3Type_f32:
        *(reinterpret_cast<float*>(w_val)) = static_cast<float>(dvalue);
        break;
      case c_m3Type_f64:
        *(reinterpret_cast<double*>(w_val)) = dvalue;
        break;
      default:
        return 1;
    }
    return 0;
  }

  template <typename JSEnv>
  typename JSEnv::JSValue CallWasmFunction(JSEnv* js_env, size_t argc,
                                           const typename JSEnv::JSValue argv[],
                                           const char* code,
                                           typename JSEnv::JSValue* exception) {
#if defined(__APPLE__)
    static_assert(std::is_same_v<JSEnv, qjs::QJSEnv> ||
                  std::is_same_v<JSEnv, jsc::JSCEnv>);
#else
    static_assert(std::is_same_v<JSEnv, qjs::QJSEnv>);
#endif

    using JSValue = typename JSEnv::JSValue;

    IM3Function m3_function = m3_function_;
    uint32_t wasm_argc = m3_GetArgCount(m3_function);
    M3TaggedValue val_buffer[128] = {};
    const void* val_ptr[128] = {};

    for (uint32_t i = 0; i < wasm_argc; ++i) {
      IM3TaggedValue tagged_ptr = val_buffer + i;
      M3ValueType type = m3_GetArgType(m3_function, i);

      val_ptr[i] = &(tagged_ptr->value);
      tagged_ptr->type = type;

      JSValue arg = i < argc ? argv[i] : js_env->MakeNumber(NAN);
      if (!runtime_->ToWebAssemblyValue<JSEnv>(js_env, arg, tagged_ptr)) {
        return js_env->MakeException(ErrorTypes::kError, code,
                                     "Illegal parameter(s) for wasm function.",
                                     exception);
      }
    }

    M3Result m3_result = m3Err_none;
    m3_result = m3_Call(m3_function, wasm_argc, val_ptr);
    if (m3_result) {
      return js_env->MakeException(ErrorTypes::kError, code, m3_result,
                                   exception);
    }

    int ret_count = m3_GetRetCount(m3_function);
    // reuse val_buffer for return values
    memset(val_buffer, 0, sizeof(val_buffer));
    for (int i = 0; i < ret_count; i++) {
      val_ptr[i] = &(val_buffer[i].value);
    }

    m3_result = m3_GetResults(m3_function, ret_count, val_ptr);
    if (m3_result) {
      return js_env->MakeException(ErrorTypes::kError, code, m3_result,
                                   exception);
    }

    u32 ret_num = m3_GetRetCount(m3_function);
    JSValue result = js_env->MakeUndefined();
    if (ret_num > 0) {
      M3TaggedValue tagged;
      M3ValueType type = m3_GetRetType(m3_function, 0);
      tagged.value.i64 = *(uint64_t*)val_ptr[0];
      tagged.type = type;
      runtime_->ToJSValue(js_env, &result, &tagged);
    }

    return result;
  }

 private:
  BORROWER Wasm3Runtime* runtime_;
  BORROWER Wasm3Instance* instance_ = nullptr;

  OWNER IM3Function m3_function_;
  OWNER JSValueRefs js_function_;
};

}  // namespace primjs::wasm

#endif  // SRC_WASM_RUNTIME_WASM3_FUNC_PACK_H_
