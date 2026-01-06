// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_PRISM_FUNC_PACK_H_
#define SRC_WASM_RUNTIME_PRISM_FUNC_PACK_H_

#include <memory>

#include "common/js_type.h"
#if defined(__APPLE__)
#include "jsc/js_env_jsc.h"
#endif
#include "prism/wasm_c_api.h"
#include "qjs/js_env_qjs.h"
#include "runtime/prism/wasm_runtime.h"

namespace primjs {
namespace wasm {
class PrismInstance;

class PrismFunction {
 public:
  PrismFunction(JSValueRefs js_function, PrismRuntime* rt);

  PrismFunction(wasm_func_t* w_func, PrismRuntime* rt, PrismInstance* instance);

  ~PrismFunction();

  wasm_func_t* function() const { return function_; }

  void set_function(wasm_func_t* function) { function_ = function; };

  PrismRuntime* runtime() const { return runtime_; }

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
    using JSObject = typename JSEnv::JSObject;

    JSValue result = js_env->MakeUndefined();

    wasm_functype_t* func_ty = wasm_func_type(function_);
    const wasm_valtype_vec_t* param_tys = wasm_functype_params(func_ty);

    size_t w_argc = param_tys->size;
    wasm_val_t wasm_args[w_argc];

    for (size_t i = 0; i < param_tys->size; ++i) {
      wasm_args[i].kind = wasm_valtype_kind(param_tys->data[i]);
      JSValue arg = i < argc ? argv[i] : js_env->MakeNumber(NAN);

      if (!runtime_->ToWebAssemblyValue<JSEnv>(js_env, arg, wasm_args + i)) {
        return js_env->MakeException(ErrorTypes::kError, code,
                                     "Illegal parameter(s) for wasm function.",
                                     exception);
      }
    }

    const wasm_valtype_vec_t* res_tys = wasm_functype_results(func_ty);
    wasm_val_t wasm_res[res_tys->size];
    for (size_t i = 0; i < res_tys->size; ++i) {
      wasm_res[i].kind = WASM_ANYREF;
      wasm_res[i].of.ref = NULL;
    }

    wasm_val_vec_t args_vec = WASM_ARRAY_VEC(wasm_args);
    wasm_val_vec_t results = WASM_ARRAY_VEC(wasm_res);
    wasm_trap_t* trap = wasm_func_call(function_, &args_vec, &results);
    if (trap) {
      wasm_name_t message;
      wasm_trap_message(trap, &message);

      static const char* prefix = "WebAssembly Trap: ";
      static size_t prefix_len = strlen(prefix);
      size_t len = message.size + prefix_len + 1;
      char msg[len];
      memcpy(msg, prefix, prefix_len);
      memcpy(msg + prefix_len, message.data, message.size);
      msg[len] = '\0';

      return js_env->MakeException(ErrorTypes::kError, code, msg, exception);
    }

    if (res_tys->size == 1) {
      runtime_->ToJSValue(js_env, &result, &wasm_res[0]);
    }

    return result;
  }

  static uint64_t QJSPrismCallback(prism_mcp_slot* pc, prism_st* st,
                                   prism_mem* mem);
  static double QJSPrismCallback_f(prism_mcp_slot* pc, prism_st* st,
                                   prism_mem* mem);

#if defined(__APPLE__)
  static uint64_t JSCPrismCallback(prism_mcp_slot* pc, prism_st* st,
                                   prism_mem* mem);
  static double JSCPrismCallback_f(prism_mcp_slot* pc, prism_st* st,
                                   prism_mem* mem);
#endif

 private:
  BORROWER PrismRuntime* runtime_;
  OWNER wasm_func_t* function_;
  OWNER JSValueRefs js_function_;

  // FuncType ftype_;
  // Only when ftype_ equals to kWasmFunction, field 'instance_'
  // can have a valid value rather than nullptr.
  [[maybe_unused]] PrismInstance* instance_ = nullptr;
};

}  // namespace wasm
}  // namespace primjs

#endif  // SRC_WASM_RUNTIME_PRISM_FUNC_PACK_H_
