// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_PRISM_FUNC_PACK_H_
#define SRC_WASM_RUNTIME_PRISM_FUNC_PACK_H_

#include <array>
#include <vector>

#ifdef ENABLE_WASM_PERF_COMPARE
#include "common/interop_runtime_perf.h"
#endif
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
  PrismFunction(JSValueRefs js_function, PrismRuntime* rt,
                PrismInstance* instance, wasm_func_t* w_func);

  PrismFunction(wasm_func_t* w_func, PrismRuntime* rt, PrismInstance* instance,
                bool owns_handle);

  ~PrismFunction();

  wasm_func_t* function() const { return function_; }

  void set_function(wasm_func_t* function) { function_ = function; };

  PrismRuntime* runtime() const { return runtime_; }

#ifdef ENABLE_WASM_PERF_COMPARE
  wasm_perf::CallSamplingState& perf_call_state() { return perf_call_state_; }
  PrismInstance* perf_instance() const { return instance_; }
#endif

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

    // Borrow the functype owned by wasm_func_t. The JS->wasm hot path only
    // needs to inspect the signature, so avoid wasm_func_type() copy/free
    // on every export call.
    const wasm_functype_t* func_ty = wasm_func_type_borrow(function_);
    const wasm_valtype_vec_t* param_tys = wasm_functype_params(func_ty);

    size_t w_argc = param_tys->size;
    constexpr size_t kInlineWasmValues = 16;
    std::array<wasm_val_t, kInlineWasmValues> inline_args;
    std::vector<wasm_val_t> overflow_args;
    wasm_val_t* wasm_args = inline_args.data();
    if (w_argc > inline_args.size()) {
      overflow_args.resize(w_argc);
      wasm_args = overflow_args.data();
    }

    for (size_t i = 0; i < param_tys->size; ++i) {
      wasm_args[i].kind = wasm_valtype_kind(param_tys->data[i]);
      JSValue arg = i < argc ? argv[i] : js_env->MakeNumber(NAN);

      JSValue conversion_exception = js_env->MakeNull();
      if (!runtime_->ToWebAssemblyValue<JSEnv>(js_env, arg, wasm_args + i,
                                               &conversion_exception)) {
        if (!js_env->IsNull(conversion_exception)) {
          if (exception != nullptr) {
            *exception = conversion_exception;
          }
          return conversion_exception;
        }
        return js_env->MakeException(ErrorTypes::kError, code,
                                     "Illegal parameter(s) for wasm function.",
                                     exception);
      }
    }

    const wasm_valtype_vec_t* res_tys = wasm_functype_results(func_ty);
    std::array<wasm_val_t, kInlineWasmValues> inline_results;
    std::vector<wasm_val_t> overflow_results;
    wasm_val_t* wasm_res = inline_results.data();
    if (res_tys->size > inline_results.size()) {
      overflow_results.resize(res_tys->size);
      wasm_res = overflow_results.data();
    }
    for (size_t i = 0; i < res_tys->size; ++i) {
      wasm_res[i].kind = WASM_ANYREF;
      wasm_res[i].of.ref = NULL;
    }

    wasm_val_vec_t args_vec = {w_argc, wasm_args};
    wasm_val_vec_t results = {res_tys->size, wasm_res};
    wasm_trap_t* trap = wasm_func_call(function_, &args_vec, &results);
    if (trap) {
      // W3C wasm JS API spec: an exception thrown by an imported JS function
      // must propagate verbatim. The Prism-only callback stashes presence and
      // payload separately so null and undefined are preserved too.
      if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
        LEPUSContext* ctx = js_env->js_ctx();
        LEPUSRuntime* rt = LEPUS_GetRuntime(ctx);
        LEPUSValue pending;
        if (js_env->TakeWasmException(&pending)) {
          if (exception) *exception = JSEnv::FromQJS(pending, rt);
          LEPUS_Throw(ctx, pending);
          wasm_trap_delete(trap);
          return JSEnv::FromQJS(LEPUS_EXCEPTION, rt);
        }
      }
#if defined(__APPLE__)
      // JSC mirror of the QJS recovery above. The PrismFunction JSC
      // callback stashes the original JSValueRef in JSCEnv's pending
      // slot before signalling a trap; recover it here and surface it
      // verbatim through *exception so the JS try/catch sees the
      // ORIGINAL Error instead of a generic "WebAssembly Trap" string.
      else if constexpr (std::is_same_v<JSEnv, jsc::JSCEnv>) {
        if (JSValueRef stashed = js_env->TakeWasmException()) {
          if (exception) *exception = stashed;
          // Drop the protect taken in StashWasmException now that the
          // value has been handed off to the embedder via *exception.
          // Safety relies on two JSC invariants documented here:
          //   1. JSC's GC is a conservative stack scan -- the local
          //      `stashed` register and the C-API caller's *exception
          //      slot both look like roots for the duration of this
          //      frame, so dropping the explicit Protect cannot leave
          //      the value reclaimable on this return path.
          //   2. CallWasmFunction does not allocate further JS objects
          //      between this Unprotect and returning to the embedder,
          //      so no GC point intervenes.
          // If JSC ever switches to precise/moving GC, or if more JS
          // allocation is added after this point, this Unprotect must
          // be deferred until after *exception is consumed.
          JSValueUnprotect(js_env->js_ctx(), stashed);
          wasm_trap_delete(trap);
          return js_env->MakeNull();
        }
      }
#endif

      wasm_name_t message;
      wasm_trap_message(trap, &message);

      static const char* prefix = "WebAssembly Trap: ";
      static size_t prefix_len = strlen(prefix);
      size_t len = message.size + prefix_len;
      std::vector<char> msg(len + 1);
      memcpy(msg.data(), prefix, prefix_len);
      memcpy(msg.data() + prefix_len, message.data, message.size);
      msg[len] = '\0';
      wasm_name_delete(&message);
      wasm_trap_delete(trap);
      return js_env->MakeException(ErrorTypes::kError, code, msg.data(),
                                   exception);
    }

    if (res_tys->size == 1) {
      JSValue conversion_exception = js_env->MakeNull();
      if (!runtime_->ToJSValue(js_env, &result, &wasm_res[0],
                               &conversion_exception)) {
        if (!js_env->IsNull(conversion_exception)) {
          if (exception != nullptr) {
            *exception = conversion_exception;
          }
          if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
            return conversion_exception;
          }
          return js_env->MakeNull();
        }
        return js_env->MakeException(ErrorTypes::kTypeError, code,
                                     "Unable to convert wasm result",
                                     exception);
      }
    }

    return result;
  }

  static prism_result QJSPrismCallback(HANDLER_SIG);

#if defined(__APPLE__)
  static prism_result JSCPrismCallback(HANDLER_SIG);
#endif

 private:
  BORROWER PrismRuntime* runtime_;
  OWNER wasm_func_t* function_;
  OWNER JSValueRefs js_function_;
  bool owns_handle_ = false;
  uintptr_t export_func_cache_key_ = 0;

  // FuncType ftype_;
  // Only when ftype_ equals to kWasmFunction, field 'instance_'
  // can have a valid value rather than nullptr.
  [[maybe_unused]] PrismInstance* instance_ = nullptr;
#ifdef ENABLE_WASM_PERF_COMPARE
  wasm_perf::CallSamplingState perf_call_state_;
#endif
};

}  // namespace wasm
}  // namespace primjs

#endif  // SRC_WASM_RUNTIME_PRISM_FUNC_PACK_H_
