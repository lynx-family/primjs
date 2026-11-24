// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm_function.h"

#include <array>
#include <cstdlib>

#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/js_env_qjs.h"
#include "qjs/qjs_wasm.h"

namespace primjs::qjs {

namespace {
constexpr size_t kInlineWasmValues = 16;
constexpr size_t kInlineJSArgs = 8;
constexpr const char* kCallCode = "Call WebAssembly Function";

struct QJSImportBridgeEnv {
  wasm::WasmStoreOwner* store_owner = nullptr;
  LEPUSValue js_fn = LEPUS_UNDEFINED;
};

WASM_MINSIZE void FinalizeImportBridgeEnv(void* raw) {
  auto* bridge = static_cast<QJSImportBridgeEnv*>(raw);
  if (!bridge) return;
  if (bridge->store_owner) {
    if (QJSEnv* env = bridge->store_owner->active_qjs_env()) {
      env->ReleaseImportCallback(bridge);
    }
    wasm::WasmStoreOwner::Release(bridge->store_owner);
  }
  delete bridge;
}

#if defined(__GNUC__) || defined(__clang__)
__attribute__((cold, noinline))
#endif
wasm_trap_t*
CaptureCurrentJSExceptionTrap(QJSEnv* env, LEPUSContext* ctx) {
  env->StashWasmException(LEPUS_GetException(ctx));
  return wasm::NewJsExceptionTrap(env->wasm_store());
}

#if defined(__GNUC__) || defined(__clang__)
__attribute__((minsize, noinline))
#else
WASM_MINSIZE
#endif
LEPUSValue
BuildMultiValueArray(LEPUSContext* ctx, const wasm_val_t* results,
                     size_t result_count) {
  LEPUSValue arr = LEPUS_NewArray(ctx);
  if (LEPUS_IsException(arr)) return LEPUS_EXCEPTION;
  HandleScope scope(ctx, &arr, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue elem = LEPUS_UNDEFINED;
  scope.PushHandle(&elem, HANDLE_TYPE_LEPUS_VALUE);
  for (size_t i = 0; i < result_count; ++i) {
    elem = QJSEnv::FromWasmValueSlow(ctx, results[i]);
    if (LEPUS_IsException(elem) ||
        LEPUS_DefinePropertyValueUint32(ctx, arr, static_cast<uint32_t>(i),
                                        elem, LEPUS_PROP_C_W_E) < 0) {
      FreeValueIfRC(ctx, arr);
      return LEPUS_EXCEPTION;
    }
    elem = LEPUS_UNDEFINED;
  }
  return arr;
}

wasm_trap_t* InvokeQJSImportBridge(void* raw_env, const wasm_val_vec_t* args,
                                   wasm_val_vec_t* results) {
  auto* bridge = static_cast<QJSImportBridgeEnv*>(raw_env);
  QJSEnv* env = bridge && bridge->store_owner
                    ? bridge->store_owner->active_qjs_env()
                    : nullptr;
  if (wasm_unlikely(!env || env->IsInvalid())) {
    return bridge && bridge->store_owner
               ? wasm::NewJsExceptionTrap(bridge->store_owner->store())
               : nullptr;
  }
  LEPUSContext* ctx = env->js_ctx();
  LEPUSRuntime* rt = env->js_rt();
  const size_t argc = args ? args->size : 0;
  const bool gc_mode = LEPUS_IsGCModeRT(rt);

  std::array<LEPUSValue, kInlineJSArgs> inline_args;
  LEPUSValue* heap_args = nullptr;
  LEPUSValue* js_args = inline_args.data();
  if (wasm_unlikely(argc > kInlineJSArgs)) {
    heap_args =
        static_cast<LEPUSValue*>(std::malloc(argc * sizeof(LEPUSValue)));
    if (!heap_args) {
      env->StashWasmException(LEPUS_ThrowOutOfMemory(ctx));
      return wasm::NewJsExceptionTrap(env->wasm_store());
    }
    js_args = heap_args;
  }
  HandleScope scope(ctx);
  if (gc_mode && argc > 0) {
    for (size_t i = 0; i < argc; ++i) {
      js_args[i] = LEPUS_UNDEFINED;
    }
    scope.PushLEPUSValueArrayHandle(js_args, static_cast<int>(argc), false);
  }

  for (size_t i = 0; i < argc; ++i) {
    js_args[i] = QJSEnv::FromWasmValue(ctx, args->data[i]);
    if (wasm_unlikely(LEPUS_IsException(js_args[i]))) {
      if (!gc_mode) {
        for (size_t j = 0; j < i; ++j) LEPUS_FreeValueRT(rt, js_args[j]);
      }
      std::free(heap_args);
      return CaptureCurrentJSExceptionTrap(env, ctx);
    }
  }

  LEPUSValue ret = LEPUS_Call(ctx, bridge->js_fn, LEPUS_UNDEFINED,
                              static_cast<int>(argc), js_args);
  if (gc_mode) {
    scope.PushHandle(&ret, HANDLE_TYPE_LEPUS_VALUE);
  } else {
    for (size_t i = 0; i < argc; ++i) {
      LEPUS_FreeValueRT(rt, js_args[i]);
    }
  }
  std::free(heap_args);

  if (wasm_unlikely(LEPUS_IsException(ret))) {
    return CaptureCurrentJSExceptionTrap(env, ctx);
  }

  if (results && results->size > 0) {
    bool ok = false;
    if (wasm_likely(results->size == 1)) {
      ok = QJSEnv::ToWasmValue(ctx, ret, results->data[0].kind,
                               &results->data[0]);
    } else {
      ThrowIfException(ctx, ErrorTypes::kTypeError, kCallCode,
                       "Multi-value host import return is unsupported");
    }
    if (wasm_unlikely(!ok)) {
      if (!gc_mode) LEPUS_FreeValueRT(rt, ret);
      return CaptureCurrentJSExceptionTrap(env, ctx);
    }
  }

  if (!gc_mode) {
    LEPUS_FreeValueRT(rt, ret);
  }
  return nullptr;
}
}  // namespace

WASM_MINSIZE QJSWasmFunction::QJSWasmFunction(LEPUSRuntime* rt,
                                              LEPUSValue wasm_root, QJSEnv* env,
                                              wasm_func_t* func,
                                              LEPUSValue js_obj)
    : QJSWasmWrapperBase(rt, wasm_root, env->store_owner(), DetachFunc),
      func_(func),
      js_obj_(js_obj) {
  wasm_func_set_host_info(func_, this);
}

WASM_MINSIZE QJSWasmFunction::~QJSWasmFunction() { UnlinkAndDetach(); }

WASM_MINSIZE void QJSWasmFunction::DetachFunc(QJSWasmWrapperBase* base,
                                              LEPUSRuntime*) {
  auto* self = static_cast<QJSWasmFunction*>(base);
  if (self->func_) {
    if (Of(self->func_) == self) {
      wasm_func_set_host_info(self->func_, nullptr);
    }
    wasm_func_delete(self->func_);
    self->func_ = nullptr;
  }
}

WASM_MINSIZE LEPUSValue QJSWasmFunction::CreatePrototype(LEPUSContext* ctx) {
  const LEPUSClassID cid = class_id();
  LEPUSClassDef def = {.class_name = "WebAssembly.Function",
                       .finalizer = WasmWrapperFinalizer,
                       .gc_mark = WasmWrapperGCMark,
                       .call = CallWasmFunction};
  if (JSSafeNewClass(ctx, cid, &def)) {
    return LEPUS_EXCEPTION;
  }

  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  HandleScope func_scope(ctx, &global, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue js_function = LEPUS_GetPropertyStr(ctx, global, "Function");
  FreeValueIfRC(ctx, global);
  if (LEPUS_IsException(js_function) || !LEPUS_IsObject(js_function)) {
    if (!LEPUS_IsException(js_function)) FreeValueIfRC(ctx, js_function);
    return LEPUS_IsException(js_function)
               ? js_function
               : ThrowIfException(ctx, ErrorTypes::kTypeError, kCallCode,
                                  "Global Function is invalid");
  }
  func_scope.PushHandle(&js_function, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue func_proto = LEPUS_GetPrototype(ctx, js_function);
  FreeValueIfRC(ctx, js_function);
  if (LEPUS_IsException(func_proto) || !LEPUS_IsObject(func_proto)) {
    if (!LEPUS_IsException(func_proto)) FreeValueIfRC(ctx, func_proto);
    return LEPUS_IsException(func_proto)
               ? func_proto
               : ThrowIfException(ctx, ErrorTypes::kTypeError, kCallCode,
                                  "Function.prototype is invalid");
  }
  func_scope.PushHandle(&func_proto, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetClassProto(ctx, cid, DupValueIfRC(ctx, func_proto));
  return func_proto;
}

WASM_MINSIZE LEPUSValue QJSWasmFunction::WrapOwnedFunc(LEPUSContext* ctx,
                                                       QJSEnv* env,
                                                       wasm_func_t* func) {
  if (wasm_unlikely(!func)) return LEPUS_EXCEPTION;
  LEPUSValue obj =
      NewWasmWrapperObject(ctx, env, WasmQJSClass::kFunction, kCallCode);
  if (LEPUS_IsException(obj)) {
    wasm_func_delete(func);
    return LEPUS_EXCEPTION;
  }
  LEPUS_SetOpaque(obj, new QJSWasmFunction(LEPUS_GetRuntime(ctx),
                                           env->wasm_root(), env, func, obj));
  return obj;
}

WASM_MINSIZE LEPUSValue QJSWasmFunction::GetOrWrapOwnedFunc(LEPUSContext* ctx,
                                                            QJSEnv* env,
                                                            wasm_func_t* func) {
  if (!func) return LEPUS_NULL;
  if (QJSWasmFunction* existing = Of(func)) {
    wasm_func_delete(func);
    return DupValueIfRC(ctx, existing->js_object());
  }
  return WrapOwnedFunc(ctx, env, func);
}

WASM_MINSIZE wasm_func_t* QJSWasmFunction::CreateImportBridge(
    QJSEnv* env, LEPUSValue js_fn, const wasm_functype_t* expected_type,
    uint64_t transaction) {
  if (wasm_unlikely(!env || !expected_type)) return nullptr;
  wasm::WasmStoreOwner* owner = env->store_owner();
  wasm::WasmStoreOwner::Retain(owner);
  auto* bridge_env = new QJSImportBridgeEnv{owner, js_fn};
  wasm_func_t* bridge = wasm_func_new_with_env(
      env->wasm_store(), expected_type, InvokeQJSImportBridge, bridge_env,
      FinalizeImportBridgeEnv);
  if (wasm_unlikely(!bridge)) {
    wasm::WasmStoreOwner::Release(owner);
    delete bridge_env;
    return nullptr;
  }
  env->RetainImportCallback(js_fn, transaction, bridge_env);
  return bridge;
}

LEPUSValue QJSWasmFunction::CallWasmFunction(LEPUSContext* ctx,
                                             LEPUSValueConst func_obj,
                                             LEPUSValueConst this_val, int argc,
                                             LEPUSValueConst* argv, int flags) {
  (void)this_val;
  if (wasm_unlikely((flags & LEPUS_CALL_FLAG_CONSTRUCTOR) != 0)) {
    return ThrowIfException(
        ctx, ErrorTypes::kTypeError, kCallCode,
        "WebAssembly exported function is not a constructor");
  }
  auto* fn =
      static_cast<QJSWasmFunction*>(LEPUS_GetOpaque(func_obj, class_id()));
  if (wasm_unlikely(!fn || !fn->func_)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, kCallCode,
                            "Invalid WebAssembly function");
  }
  if (wasm_unlikely(!fn->sig_.Ensure(fn->func_))) {
    return ThrowIfException(ctx, ErrorTypes::kError, kCallCode,
                            "Unable to inspect WebAssembly function signature");
  }
  const size_t total = fn->sig_.param_count() + fn->sig_.result_count();
  if (wasm_unlikely(total > kInlineWasmValues)) {
    auto* heap_vals =
        static_cast<wasm_val_t*>(std::calloc(total, sizeof(wasm_val_t)));
    if (!heap_vals) return LEPUS_ThrowOutOfMemory(ctx);
    LEPUSValue res = fn->CallWith(ctx, argc, argv, heap_vals);
    std::free(heap_vals);
    return res;
  }
  std::array<wasm_val_t, kInlineWasmValues> inline_vals;
  return fn->CallWith(ctx, argc, argv, inline_vals.data());
}

LEPUSValue QJSWasmFunction::CallWith(LEPUSContext* ctx, int argc,
                                     LEPUSValueConst* argv,
                                     wasm_val_t* values) {
  const size_t param_count = sig_.param_count();
  const size_t result_count = sig_.result_count();
  const wasm_valkind_t* p_kinds = sig_.param_kinds();
  const wasm_valkind_t* r_kinds = sig_.result_kinds();
  wasm_val_t* results = values + param_count;

  for (size_t i = 0; i < param_count; ++i) {
    LEPUSValueConst arg =
        i < static_cast<size_t>(argc) ? argv[i] : LEPUS_UNDEFINED;
    if (wasm_unlikely(!QJSEnv::ToWasmValue(ctx, arg, p_kinds[i], &values[i]))) {
      return LEPUS_EXCEPTION;
    }
  }
  for (size_t i = 0; i < result_count; ++i) {
    results[i].kind = r_kinds[i];
    results[i].of.i64 = 0;
  }

  wasm_val_vec_t arg_vec = {param_count, values};
  wasm_val_vec_t res_vec = {result_count, results};
  wasm_trap_t* trap = wasm_func_call(func_, &arg_vec, &res_vec);
  if (wasm_unlikely(trap != nullptr)) {
    if (QJSEnv* env = QJSWebAssembly::GetEnvFromRoot(wasm_root())) {
      return env->ThrowTrap(trap, kCallCode);
    }
    wasm_trap_delete(trap);
    return ThrowIfException(ctx, ErrorTypes::kError, kCallCode,
                            "WebAssembly Trap");
  }

  if (result_count == 0) return LEPUS_UNDEFINED;
  if (wasm_likely(result_count == 1)) {
    return QJSEnv::FromWasmValue(ctx, results[0]);
  }
  return BuildMultiValueArray(ctx, results, result_count);
}

}  // namespace primjs::qjs
