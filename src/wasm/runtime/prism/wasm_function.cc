// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/prism/wasm_function.h"

#include <array>

#include "common/wasm_log.h"
#if defined(__APPLE__)
#include "jsc/js_env_jsc.h"
#endif
#include "qjs/js_env_qjs.h"
#include "runtime/prism/wasm_instance.h"
#include "runtime/prism/wasm_runtime.h"

namespace primjs::wasm {

namespace {

constexpr size_t kInlineWasmCallbackArgs = 16;

struct CallbackImplResult {
  bool ok = false;
  uint64_t bits = 0;
};

// WASMGCPersistent owns a global handle in tracing-GC mode, but wraps a raw
// caller-owned QuickJS value in RC mode. Keep the explicit RC decref paired
// with each successful wasm-to-JS conversion on every callback exit path.
class QJSCallbackArgsScope {
 public:
  QJSCallbackArgsScope(qjs::QJSEnv* js_env, QJSEnv::JSValue* values)
      : js_env_(js_env), values_(values) {}

  QJSCallbackArgsScope(const QJSCallbackArgsScope&) = delete;
  QJSCallbackArgsScope& operator=(const QJSCallbackArgsScope&) = delete;

  ~QJSCallbackArgsScope() {
    for (uint32_t i = 0; i < size_; ++i) {
      js_env_->FreeValue(values_[i]);
    }
  }

  void Add() { ++size_; }

 private:
  qjs::QJSEnv* js_env_;
  QJSEnv::JSValue* values_;
  uint32_t size_ = 0;
};

class QJSCallbackResultScope {
 public:
  QJSCallbackResultScope(qjs::QJSEnv* js_env, QJSEnv::JSValue* value)
      : js_env_(js_env), value_(value) {}

  QJSCallbackResultScope(const QJSCallbackResultScope&) = delete;
  QJSCallbackResultScope& operator=(const QJSCallbackResultScope&) = delete;

  ~QJSCallbackResultScope() { js_env_->FreeValue(*value_); }

 private:
  qjs::QJSEnv* js_env_;
  QJSEnv::JSValue* value_;
};

// Keep non-trivial callback temporaries inside the helper so their lifetimes
// end before the outer handler publishes its interpreter resume point.
__attribute__((noinline)) CallbackImplResult QJSPrismCallbackImpl(
    QJSEnv::JSValue js_function, PrismRuntime* prism_runtime,
    qjs::QJSEnv* js_env, prism_func* func, prism_st_slot* st,
    prism_mcp_slot* pc) {
  CallbackImplResult result;
  uint32_t retc = func->info.ret_nb;
  uint32_t argc = func->info.arg_nb;
  prism_value_type* arg_types = func->info.type + retc;
  prism_mcp_slot* cursor = pc;
  std::array<QJSEnv::JSValue, kInlineWasmCallbackArgs> inline_args;
  std::vector<QJSEnv::JSValue> overflow_args;
  QJSEnv::JSValue* js_args = inline_args.data();
  if (argc > inline_args.size()) {
    overflow_args.resize(argc);
    js_args = overflow_args.data();
  }
  QJSCallbackArgsScope args_scope(js_env, js_args);
  for (uint32_t i = 0; i < argc; ++i) {
    QJSEnv::JSValue conversion_exception = js_env->MakeNull();
    if (!prism_runtime->ToJSValue(js_env, &js_args[i], arg_types[i],
                                  st + *(++cursor), &conversion_exception)) {
      if (!js_env->IsNull(conversion_exception)) {
        js_env->CapturePendingWasmException();
      }
      return result;
    }
    args_scope.Add();
  }

  QJSEnv::JSValue exception = js_env->MakeUndefined();
  QJSEnv::JSValue ret_val = js_env->CallAsFunctionForPrism(
      js_function, js_env->MakeUndefined(), argc, js_args, &exception);
  QJSCallbackResultScope result_scope(js_env, &ret_val);

  // W3C wasm JS API spec: an exception thrown by an imported JS function
  // must propagate out through the wasm call boundary. Detect the throw
  // via the LEPUS_EXCEPTION sentinel on the return value, NOT via the
  // out-param (which can collide with `throw undefined` / `throw null`
  // payloads). Signal failure so the outer dispatch returns a prism trap
  // and CallWasmFunction re-throws verbatim from the QJS pending slot.
  if (js_env->IsException(ret_val)) {
    return result;  // result.ok == false
  }

  if (retc == 0) {
    result.ok = true;
    return result;
  }

  uint64_t ret = 0;
  QJSEnv::JSValue conversion_exception = js_env->MakeNull();
  if (prism_runtime->ToWebAssemblyValue(js_env, ret_val, *(func->info.type),
                                        &ret, &conversion_exception)) {
    result.ok = true;
    result.bits = ret;
  } else if (!js_env->IsNull(conversion_exception)) {
    js_env->CapturePendingWasmException();
  }
  return result;
}

#if defined(__APPLE__)
__attribute__((noinline)) CallbackImplResult JSCPrismCallbackImpl(
    JSObjectRef js_function, PrismRuntime* prism_runtime, jsc::JSCEnv* js_env,
    prism_func* func, prism_st_slot* st, prism_mcp_slot* pc) {
  CallbackImplResult result;
  uint32_t retc = func->info.ret_nb;
  uint32_t argc = func->info.arg_nb;
  prism_value_type* arg_types = func->info.type + retc;
  prism_mcp_slot* cursor = pc;
  std::array<JSValueRef, kInlineWasmCallbackArgs> inline_args;
  std::vector<JSValueRef> overflow_args;
  JSValueRef* js_args = inline_args.data();
  if (argc > inline_args.size()) {
    overflow_args.resize(argc);
    js_args = overflow_args.data();
  }
  for (uint32_t i = 0; i < argc; ++i) {
    JSValueRef conversion_exception = nullptr;
    if (!prism_runtime->ToJSValue(js_env, &js_args[i], arg_types[i],
                                  st + *(++cursor), &conversion_exception)) {
      if (conversion_exception != nullptr) {
        js_env->StashWasmException(conversion_exception);
      }
      return result;
    }
  }

  JSValueRef exception = nullptr;
  JSValueRef ret_val =
      js_env->CallAsFunction(js_function, nullptr, argc, js_args, &exception);

  // Surface a JS-side throw as a prism trap so the wasm call boundary
  // does not silently swallow it. Stash the original JSValueRef in the
  // JSCEnv pending-exception slot so the outer CallWasmFunction can
  // re-throw it verbatim instead of replacing it with a generic trap
  // message. This brings the prism+jsc path to behavioural parity with
  // the QJS path (which has a runtime-level pending slot built in).
  if (exception != nullptr) {
    js_env->StashWasmException(exception);
    return result;  // result.ok == false
  }

  if (retc == 0) {
    result.ok = true;
    return result;
  }

  uint64_t ret = 0;
  JSValueRef conversion_exception = nullptr;
  if (prism_runtime->ToWebAssemblyValue(js_env, ret_val, *(func->info.type),
                                        &ret, &conversion_exception)) {
    result.ok = true;
    result.bits = ret;
  } else if (conversion_exception != nullptr) {
    js_env->StashWasmException(conversion_exception);
  }
  return result;
}
#endif

}  // namespace

PrismFunction::PrismFunction(JSValueRefs js_function, PrismRuntime* rt,
                             PrismInstance* instance, wasm_func_t* w_func)
    : runtime_(rt),
      function_(w_func),
      js_function_(std::move(js_function)),
      instance_(instance) {
  WLOGD("Running PrismFunction::%s...", __func__);
}

PrismFunction::PrismFunction(wasm_func_t* w_func, PrismRuntime* rt,
                             PrismInstance* instance, bool owns_handle)
    : runtime_(rt),
      function_(w_func),
      owns_handle_(owns_handle),
      instance_(instance) {
  WLOGD("Running PrismFunction::%s...", __func__);
  if (function_ != nullptr) {
    export_func_cache_key_ =
        reinterpret_cast<uintptr_t>(prism_get_func(function_));
  }
  PrismInstance::IncreaseRefCount(instance);
}

PrismFunction::~PrismFunction() {
  WLOGD("Running PrismFunction::%s...", __func__);
  if (js_function_ == nullptr) {
    if (export_func_cache_key_ != 0) {
      runtime_->ClearExportFunctionObject(export_func_cache_key_);
    }
    if (owns_handle_) {
      wasm_func_delete(function_);
    }
    function_ = nullptr;
    PrismInstance::DecreaseRefCount(instance_);
  }
}

// pc structure when using native callback to adapt to native call from prism
// handler pc : prism_func* pc + 1 : 0 pc + 2 : 1
// ...
// pc + args_size : arg_size - 1

prism_result PrismFunction::QJSPrismCallback(HANDLER_SIG) {
  prism_func* func = GET_INT_IMM_VALUE(++pc, prism_func*);
  PrismFunction* pack =
      reinterpret_cast<PrismFunction*>(prism_get_prism_func_userdata(func));
  PrismRuntime* prism_runtime = pack->runtime_;
  auto js_env = prism_runtime->js_env().get<qjs::QJSEnv*>();
  uint32_t retc = func->info.ret_nb;
  CallbackImplResult result =
      QJSPrismCallbackImpl(pack->js_function_.get<QJSEnv::JSValue>(),
                           prism_runtime, js_env, func, st, pc);
  pc += func->info.arg_nb;

  // Prism versions before the resume-memory protocol require the embedder to
  // refresh its callback-local base. Newer Prism combines that existing work
  // with the suspended interpreter's negotiated refresh.
#if !defined(PRISM_NATIVE_REENTRY_MEMORY_PROTOCOL) || \
    !PRISM_NATIVE_REENTRY_MEMORY_PROTOCOL
  mem = prism_update_memory(mem);
#endif

  // JS callback raised an exception (left in the QJS pending slot by
  // QJSEnv::CallAsFunction). Abort the dispatch chain with a trap; the
  // outer CallWasmFunction picks the original exception back up and
  // re-throws it.
  if (!result.ok) {
    return prism_err_unfinished;
  }

  // Only support one return value.
  uint64_t ret = result.bits;
  if (retc > 0) {
    prism_st_slot* callee_st = st + sinfo->frame_size;
    uint32_t ret_idx = GET_INT_SLOT_VALUE(callee_st - 2, uint32_t);
    SET_INT_VAR_VALUE(callee_st - ret_idx, ret, prism_ir);
    // TODO: RESTORE_REG(callee_st);
  }
  DUMP_CALL_NATIVE_END(retc, ret);

#if defined(PRISM_NATIVE_REENTRY_MEMORY_PROTOCOL) && \
    PRISM_NATIVE_REENTRY_MEMORY_PROTOCOL
  PRISM_NATIVE_REENTRY_EPILOGUE_REFRESH_MEMORY(++pc);
#else
  PRISM_NATIVE_REENTRY_EPILOGUE(++pc);
#endif
}

#if defined(__APPLE__)

prism_result PrismFunction::JSCPrismCallback(HANDLER_SIG) {
  prism_func* func = GET_INT_IMM_VALUE(++pc, prism_func*);
  PrismFunction* pack =
      reinterpret_cast<PrismFunction*>(prism_get_prism_func_userdata(func));
  PrismRuntime* prism_runtime = pack->runtime_;
  auto js_env = prism_runtime->js_env().get<jsc::JSCEnv*>();
  uint32_t retc = func->info.ret_nb;
  CallbackImplResult result =
      JSCPrismCallbackImpl(pack->js_function_.get<JSObjectRef>(), prism_runtime,
                           js_env, func, st, pc);
  pc += func->info.arg_nb;

  // Keep the old dependency path source-compatible; the negotiated protocol
  // refreshes once when the linked Prism supports it.
#if !defined(PRISM_NATIVE_REENTRY_MEMORY_PROTOCOL) || \
    !PRISM_NATIVE_REENTRY_MEMORY_PROTOCOL
  mem = prism_update_memory(mem);
#endif

  // Same trap-on-JS-throw rationale as the QJS path above. The original
  // JSValueRef has been stashed in the JSCEnv pending slot inside
  // JSCPrismCallbackImpl; CallWasmFunction picks it back up and re-
  // throws it verbatim through the *exception out-param.
  if (!result.ok) {
    return prism_err_unfinished;
  }

  // Only support one return value.
  uint64_t ret = result.bits;
  if (retc > 0) {
    prism_st_slot* callee_st = st + sinfo->frame_size;
    uint32_t ret_idx = GET_INT_SLOT_VALUE(callee_st - 2, uint32_t);
    SET_INT_VAR_VALUE(callee_st - ret_idx, ret, prism_ir);
    // TODO: RESTORE_REG(callee_st);
  }
  DUMP_CALL_NATIVE_END(retc, ret);

#if defined(PRISM_NATIVE_REENTRY_MEMORY_PROTOCOL) && \
    PRISM_NATIVE_REENTRY_MEMORY_PROTOCOL
  PRISM_NATIVE_REENTRY_EPILOGUE_REFRESH_MEMORY(++pc);
#else
  PRISM_NATIVE_REENTRY_EPILOGUE(++pc);
#endif
}

#endif
}  // namespace primjs::wasm
