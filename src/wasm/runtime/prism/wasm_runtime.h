// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_WASM_PRISM_RUNTIME_H_
#define SRC_WASM_RUNTIME_WASM_PRISM_RUNTIME_H_

#include <cstring>
#include <map>
#include <type_traits>

#include "common/js_type.h"
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

  // 显式释放当前 PrismRuntime 持有的 wasm_store/wasm_engine。
  // 该接口需在 JSContext 确认退出时调用，内部实现幂等，允许重复调用。
  void ReleaseStore();

  wasm_store_t* wasm_store() const { return wasm_store_; }

  static void WasmFunctionFinalizer(void* env);

  void SetJSEnv(JSEnvRef js_env) { js_env_ = js_env; }

  auto& js_env() { return js_env_; }

  struct ExportFunctionCacheEntry {
    enum class Kind { kNone, kQJS, kJSC };
    Kind kind = Kind::kNone;
    LEPUSValue qjs_value = LEPUS_UNDEFINED;
    JSObjectRef jsc_object = nullptr;
  };

  template <typename JSEnv>
  void CacheExportFunctionObject(uintptr_t ptr,
                                 typename JSEnv::JSObject func_obj) {
    // One weak identity cache per store, shared by exports and all tables,
    // including JS-created tables without an owning instance. Wrappers erase
    // their entry in PrismFunction's destructor; import roots stay separate.
    ExportFunctionCacheEntry entry;
    if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
      entry.kind = ExportFunctionCacheEntry::Kind::kQJS;
      entry.qjs_value = func_obj.Get();
    } else {
      entry.kind = ExportFunctionCacheEntry::Kind::kJSC;
      entry.jsc_object = func_obj;
    }
    export_func_cache_[ptr] = entry;
  }

  template <typename JSEnv>
  bool GetExportFunctionObject(uintptr_t ptr,
                               typename JSEnv::JSObject* func_obj) {
    auto it = export_func_cache_.find(ptr);
    if (it == export_func_cache_.end()) {
      return false;
    }
    if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
      if (it->second.kind != ExportFunctionCacheEntry::Kind::kQJS) {
        return false;
      }
      *func_obj = typename JSEnv::JSObject(it->second.qjs_value);
      return true;
    } else {
      if (it->second.kind != ExportFunctionCacheEntry::Kind::kJSC) {
        return false;
      }
      *func_obj = it->second.jsc_object;
      return true;
    }
  }

  void ClearExportFunctionObject(uintptr_t ptr) {
    export_func_cache_.erase(ptr);
  }

  // FIXME(wasm):
  // There is accuracy loss in conversion from double to float, eg. 3.2 is
  // transformed to 3.200000047683716.
  template <typename JSEnv>
  bool ToJSValue(JSEnv* js_env, typename JSEnv::JSValue* js_value,
                 wasm_val_t* wasm_value,
                 typename JSEnv::JSValue* conversion_exception = nullptr) {
    // Only support number yet.
    double d_value = 0;
    wasm_valkind_t type = wasm_value->kind;
    switch (type) {
      case wasm_valkind_enum::WASM_I32:
        d_value = static_cast<double>(wasm_value->of.i32);
        break;
      case wasm_valkind_enum::WASM_I64:
        return js_env->MakeBigInt64(wasm_value->of.i64, js_value,
                                    conversion_exception);
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
                 prism_value_type type, uint64_t* w_val,
                 typename JSEnv::JSValue* conversion_exception = nullptr) {
    double dvalue = 0;
    switch (type) {
      case I32: {
        int32_t r = 0;
        std::memcpy(&r, w_val, sizeof(r));
        dvalue = static_cast<double>(r);
        break;
      }
      case I64: {
        int64_t r = 0;
        std::memcpy(&r, w_val, sizeof(r));
        return js_env->MakeBigInt64(r, js_value, conversion_exception);
      }
      case F32: {
        double slot_value = 0;
        std::memcpy(&slot_value, w_val, sizeof(slot_value));
        float r = static_cast<float>(slot_value);
        dvalue = static_cast<double>(r);
        break;
      }
      case F64: {
        std::memcpy(&dvalue, w_val, sizeof(dvalue));
        break;
      }
      default:
        return false;
    }
    *js_value = js_env->MakeNumber(dvalue);
    return true;
  }

  template <typename JSEnv>
  bool ToWebAssemblyValue(
      JSEnv* js_env, typename JSEnv::JSValue js_value, wasm_val_t* wasm_value,
      typename JSEnv::JSValue* conversion_exception = nullptr) {
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
        js_env->ValueToBigInt64ForPrism(i64, js_value, exception);
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

    if (wasm_unlikely(!js_env->IsNull(exception))) {
      if (conversion_exception != nullptr) {
        *conversion_exception = exception;
      }
      return false;
    }
    return true;
  }

  template <typename JSEnv>
  bool ToWebAssemblyValue(
      JSEnv* js_env, typename JSEnv::JSValue js_value, prism_value_type type,
      uint64_t* w_val,
      typename JSEnv::JSValue* conversion_exception = nullptr) {
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
        uint32_t bits = static_cast<uint32_t>(i32);
        std::memcpy(w_val, &bits, sizeof(bits));
        break;
      }
      case I64: {
        int64_t i64 = 0;
        js_env->ValueToBigInt64ForPrism(i64, js_value, exception);
        uint64_t bits = static_cast<uint64_t>(i64);
        std::memcpy(w_val, &bits, sizeof(bits));
        break;
      }
      case F32: {
        double f32 = 0;
        js_env->ValueToNumber(f32, js_value, exception);
        double slot_value = static_cast<float>(f32);
        std::memcpy(w_val, &slot_value, sizeof(slot_value));
        break;
      }
      case F64: {
        double f64 = 0;
        js_env->ValueToNumber(f64, js_value, exception);
        std::memcpy(w_val, &f64, sizeof(f64));
        break;
      }
      default:
        return false;
    }

    if (wasm_unlikely(!js_env->IsNull(exception))) {
      if (conversion_exception != nullptr) {
        *conversion_exception = exception;
      }
      return false;
    }
    return true;
  }

  int NumberToWasm(double d_value, wasm_val_t* w_val);

  wasm_valkind_t WasmType(ValueType type);

  int InitRuntime();

 private:
  BORROWER JSEnvRef js_env_;

  std::map<uintptr_t, ExportFunctionCacheEntry> export_func_cache_;

  OWNER wasm_engine_t* wasm_engine_;
  OWNER wasm_store_t* wasm_store_;
};

}  // namespace wasm
}  // namespace primjs
#endif  // SRC_WASM_RUNTIME_WASM_PRISM_RUNTIME_H_
