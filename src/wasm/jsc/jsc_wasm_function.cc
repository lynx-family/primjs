// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm_function.h"

#include <array>
#include <memory>
#include <vector>

#include "common/wasm_utils.h"
#include "jsc/js_env_jsc.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"

namespace primjs::jsc {

namespace {
constexpr size_t kInlineWasmValues = 16;
constexpr size_t kInlineJSArgs = 8;
constexpr const char* kCallCode = "Call WebAssembly Function";

struct JSCImportBridgeEnv {
  wasm::WasmStoreOwner* store_owner = nullptr;
  JSObjectRef js_fn = nullptr;
};

void FinalizeJSCImportBridgeEnv(void* raw) {
  auto* bridge = static_cast<JSCImportBridgeEnv*>(raw);
  if (!bridge) return;
  if (bridge->store_owner) {
    if (JSCEnv* env = bridge->store_owner->active_jsc_env()) {
      env->ReleaseWasmImportCallback(bridge);
    }
    wasm::WasmStoreOwner::Release(bridge->store_owner);
  }
  delete bridge;
}

wasm_trap_t* InvokeJSCImportBridge(void* raw_env, const wasm_val_vec_t* args,
                                   wasm_val_vec_t* results) {
  auto* bridge = static_cast<JSCImportBridgeEnv*>(raw_env);
  JSCEnv* env = bridge && bridge->store_owner
                    ? bridge->store_owner->active_jsc_env()
                    : nullptr;
  if (wasm_unlikely(!env || env->IsInvalid())) {
    return bridge && bridge->store_owner
               ? wasm::NewJsExceptionTrap(bridge->store_owner->store())
               : nullptr;
  }
  JSContextRef ctx = env->js_ctx();
  const size_t argc = args ? args->size : 0;

  std::array<JSValueRef, kInlineJSArgs> inline_args;
  std::unique_ptr<JSValueRef[]> heap_args;
  JSValueRef* js_args = inline_args.data();
  if (argc > kInlineJSArgs) {
    heap_args = std::make_unique<JSValueRef[]>(argc);
    js_args = heap_args.get();
  }

  JSValueRef exc = nullptr;
  for (size_t i = 0; i < argc; ++i) {
    js_args[i] = env->FromWasmValue(args->data[i], &exc);
    if (wasm_unlikely(exc != nullptr)) {
      env->StashWasmException(exc);
      return wasm::NewJsExceptionTrap(env->wasm_store());
    }
  }

  JSObjectRef undefined_receiver =
      const_cast<JSObjectRef>(JSValueMakeUndefined(ctx));
  JSValueRef ret = JSObjectCallAsFunction(
      ctx, bridge->js_fn, undefined_receiver, argc, js_args, &exc);
  if (exc != nullptr) {
    env->StashWasmException(exc);
    return wasm::NewJsExceptionTrap(env->wasm_store());
  }

  if (results && results->size > 0) {
    bool ok = false;
    if (wasm_likely(results->size == 1)) {
      ok =
          env->ToWasmValue(ret, results->data[0].kind, &results->data[0], &exc);
    } else {
      ThrowIfException(ctx, ErrorTypes::kTypeError, kCallCode,
                       "Multi-value host import return is unsupported", &exc);
    }
    if (!ok) {
      env->StashWasmException(exc);
      return wasm::NewJsExceptionTrap(env->wasm_store());
    }
  }
  return nullptr;
}
}  // namespace

JSClassRef JSCWasmFunction::class_id() {
  static JSClassRef id = [] {
    JSClassDefinition def =
        JSClassCreator::GetClassDefinition("Function", Finalize);
    def.callAsFunction = CallWasmFunction;
    return JSClassCreate(&def);
  }();
  return id;
}

JSObjectRef JSCWasmFunction::CreatePrototype(JSContextRef ctx,
                                             JSValueRef* exception) {
  (void)exception;
  class_id();
  return JSObjectMake(ctx, nullptr, nullptr);
}

JSCWasmFunction::JSCWasmFunction(JSCEnv* env, wasm_func_t* func,
                                 JSObjectRef js_obj)
    : store_owner_(env->store_owner()), func_(func), js_obj_(js_obj) {
  wasm::WasmStoreOwner::Retain(store_owner_);
  store_owner_->LinkHandle(&tracked_, this, DetachOnExit);
  wasm_func_set_host_info(func_, this);
}

JSCWasmFunction::~JSCWasmFunction() {
  if (store_owner_) {
    store_owner_->UnlinkHandle(&tracked_);
  }
  DetachWasmFunc();
}

void JSCWasmFunction::DetachWasmFunc() {
  if (func_) {
    if (Of(func_) == this) {
      wasm_func_set_host_info(func_, nullptr);
    }
    wasm_func_delete(func_);
    func_ = nullptr;
  }
  wasm::WasmStoreOwner::Release(store_owner_);
}

void JSCWasmFunction::DetachOnExit(wasm::WasmTrackedHandle* handle,
                                   void* exit_ctx) {
  (void)exit_ctx;
  auto* self = static_cast<JSCWasmFunction*>(handle->owner_object);
  self->DetachWasmFunc();
}

void JSCWasmFunction::Finalize(JSObjectRef object) {
  auto* fn = static_cast<JSCWasmFunction*>(JSObjectGetPrivate(object));
  delete fn;
}

JSObjectRef JSCWasmFunction::WrapOwnedFunc(JSContextRef ctx, JSCEnv* env,
                                           wasm_func_t* func, const char* name,
                                           JSValueRef* exception,
                                           JSStringRef prebuilt_name,
                                           JSValueRef* cached_proto) {
  if (wasm_unlikely(!env || !func)) return nullptr;

  JSValueRef func_proto = cached_proto ? *cached_proto : nullptr;
  if (!func_proto) {
    JSObjectRef js_function = JSCBuiltinObjects::GetJSFunction(ctx, exception);
    if (!js_function || (exception && *exception)) return nullptr;
    func_proto = JSObjectGetPrototype(ctx, js_function);
    if (cached_proto) *cached_proto = func_proto;
  }

  JSObjectRef obj = JSObjectMake(ctx, class_id(), nullptr);
  if (!RetainWasmRootOnJSCObject(ctx, obj, env->wasm_root(), exception)) {
    return nullptr;
  }
  JSObjectSetPrototype(ctx, obj, func_proto);
  if (prebuilt_name || name) {
    static JSStringRef name_prop = JSStringCreateWithUTF8CString("name");
    JSValueRef name_val = prebuilt_name
                              ? JSValueMakeString(ctx, prebuilt_name)
                              : JSValueMakeString(ctx, JSString(name));
    JSObjectSetProperty(ctx, obj, name_prop, name_val,
                        JSClassCreator::DefaultAttr(), exception);
    if (exception && *exception) return nullptr;
  }

  auto* opaque = new JSCWasmFunction(env, func, obj);
  WASM_CHECK(JSObjectSetPrivate(obj, opaque));
  return obj;
}

JSObjectRef JSCWasmFunction::GetOrWrapOwnedFunc(JSContextRef ctx, JSCEnv* env,
                                                wasm_func_t* func,
                                                const char* name,
                                                JSValueRef* exception,
                                                JSStringRef prebuilt_name,
                                                JSValueRef* cached_proto) {
  if (!func) return nullptr;
  if (JSCWasmFunction* existing = Of(func)) {
    JSObjectRef obj = existing->js_object();
    wasm_func_delete(func);
    return obj;
  }
  JSObjectRef wrapped = WrapOwnedFunc(ctx, env, func, name, exception,
                                      prebuilt_name, cached_proto);
  if (!wrapped) {
    wasm_func_delete(func);
  }
  return wrapped;
}

wasm_func_t* JSCWasmFunction::CreateImportBridge(
    JSCEnv* env, JSObjectRef js_fn, const wasm_functype_t* expected_type,
    uint64_t transaction) {
  if (wasm_unlikely(!env || !js_fn || !expected_type)) return nullptr;
  wasm::WasmStoreOwner* owner = env->store_owner();
  wasm::WasmStoreOwner::Retain(owner);
  auto* bridge_env = new JSCImportBridgeEnv{owner, js_fn};
  wasm_func_t* bridge = wasm_func_new_with_env(
      env->wasm_store(), expected_type, InvokeJSCImportBridge, bridge_env,
      FinalizeJSCImportBridgeEnv);
  if (wasm_unlikely(!bridge)) {
    wasm::WasmStoreOwner::Release(owner);
    delete bridge_env;
    return nullptr;
  }
  env->CacheWasmImportCallback(js_fn, transaction, bridge_env);
  return bridge;
}

JSValueRef JSCWasmFunction::CallWasmFunction(
    JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argc,
    const JSValueRef argv[], JSValueRef* exception) {
  (void)thisObject;
  auto* fn = static_cast<JSCWasmFunction*>(JSObjectGetPrivate(function));
  JSCEnv* env =
      fn && fn->store_owner_ ? fn->store_owner_->active_jsc_env() : nullptr;
  if (wasm_unlikely(!fn || !fn->func_ || !env)) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, kCallCode,
                     "Invalid wasm function to be called.", exception);
    return JSValueMakeUndefined(ctx);
  }
  if (wasm_unlikely(!fn->sig_.Ensure(fn->func_))) {
    ThrowIfException(ctx, ErrorTypes::kError, kCallCode,
                     "Unable to inspect WebAssembly function signature",
                     exception);
    return JSValueMakeUndefined(ctx);
  }

  const size_t total = fn->sig_.param_count() + fn->sig_.result_count();
  if (wasm_unlikely(total > kInlineWasmValues)) {
    std::vector<wasm_val_t> heap_vals(total);
    return fn->CallWith(ctx, env, argc, argv, heap_vals.data(), exception);
  }
  std::array<wasm_val_t, kInlineWasmValues> inline_vals;
  return fn->CallWith(ctx, env, argc, argv, inline_vals.data(), exception);
}

JSValueRef JSCWasmFunction::CallWith(JSContextRef ctx, JSCEnv* env, size_t argc,
                                     const JSValueRef argv[],
                                     wasm_val_t* values,
                                     JSValueRef* exception) {
  const size_t param_count = sig_.param_count();
  const size_t result_count = sig_.result_count();
  const wasm_valkind_t* p_kinds = sig_.param_kinds();
  const wasm_valkind_t* r_kinds = sig_.result_kinds();
  wasm_val_t* results = values + param_count;

  JSValueRef undef = JSValueMakeUndefined(ctx);
  for (size_t i = 0; i < param_count; ++i) {
    JSValueRef arg = i < argc ? argv[i] : undef;
    if (wasm_unlikely(
            !env->ToWasmValue(arg, p_kinds[i], &values[i], exception))) {
      return undef;
    }
  }
  for (size_t i = 0; i < result_count; ++i) {
    results[i].kind = r_kinds[i];
    results[i].of.i64 = 0;
  }

  wasm_val_vec_t arg_vec = {param_count, values};
  wasm_val_vec_t res_vec = {result_count, results};
  wasm::WasmStoreOwner* call_owner = store_owner_;
  wasm::WasmStoreOwner::Retain(call_owner);
  struct OwnerCallGuard {
    wasm::WasmStoreOwner* owner;
    ~OwnerCallGuard() { wasm::WasmStoreOwner::Release(owner); }
  } call_guard{call_owner};

  wasm_trap_t* trap = wasm_func_call(func_, &arg_vec, &res_vec);
  if (wasm_unlikely(!call_owner || call_owner->active_jsc_env() != env)) {
    if (trap) wasm_trap_delete(trap);
    ThrowIfException(ctx, ErrorTypes::kTypeError, kCallCode,
                     "WebAssembly context was released during call", exception);
    return undef;
  }
  if (wasm_unlikely(trap != nullptr)) {
    return env->ThrowTrap(trap, kCallCode, exception);
  }

  if (result_count == 0) return undef;
  if (result_count == 1) return env->FromWasmValue(results[0], exception);

  JSObjectRef arr = JSObjectMakeArray(ctx, 0, nullptr, exception);
  if ((exception && *exception) || !arr) return undef;
  for (size_t i = 0; i < result_count; ++i) {
    JSValueRef elem = env->FromWasmValue(results[i], exception);
    if (exception && *exception) return undef;
    JSObjectSetPropertyAtIndex(ctx, arr, static_cast<unsigned>(i), elem,
                               exception);
    if (exception && *exception) return undef;
  }
  return arr;
}

}  // namespace primjs::jsc
