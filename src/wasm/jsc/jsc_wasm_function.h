// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_FUNCTION_H_
#define SRC_WASM_JSC_FUNCTION_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/wasm_store_owner.h"
#include "common/wasm_type.h"
#include "jsc/js_env_jsc.h"

namespace primjs::jsc {

class JSCWasmFunction {
 public:
  JSCWasmFunction(JSCEnv* env, wasm_func_t* func, JSObjectRef js_obj);
  ~JSCWasmFunction();

  static JSClassRef class_id();
  static JSObjectRef CreatePrototype(JSContextRef ctx, JSValueRef* exception);

  static JSCWasmFunction* Of(const wasm_func_t* func) {
    return func ? static_cast<JSCWasmFunction*>(wasm_func_get_host_info(func))
                : nullptr;
  }

  static bool IsWasmFunction(JSContextRef ctx, JSValueRef val) {
    return val && JSValueIsObjectOfClass(ctx, val, class_id());
  }

  static JSObjectRef GetOrWrapOwnedFunc(JSContextRef ctx, JSCEnv* env,
                                        wasm_func_t* func, const char* name,
                                        JSValueRef* exception,
                                        JSStringRef prebuilt_name = nullptr,
                                        JSValueRef* cached_proto = nullptr);

  static wasm_func_t* CreateImportBridge(JSCEnv* env, JSObjectRef js_fn,
                                         const wasm_functype_t* expected_type,
                                         uint64_t transaction);

  wasm_func_t* function() const { return func_; }
  wasm::WasmStoreOwner* store_owner() const { return store_owner_; }
  JSObjectRef js_object() const { return js_obj_; }
  bool EnsureSignature() { return sig_.Ensure(func_); }
  const WasmSignature& signature() const { return sig_; }
  JSCKeepSet& keep_set() { return keep_set_; }
  const JSCKeepSet& keep_set() const { return keep_set_; }

 private:
  static void Finalize(JSObjectRef object);
  static void DetachOnExit(wasm::WasmTrackedHandle* handle, void* exit_ctx);
  void DetachWasmFunc();
  static JSObjectRef WrapOwnedFunc(JSContextRef ctx, JSCEnv* env,
                                   wasm_func_t* func, const char* name,
                                   JSValueRef* exception,
                                   JSStringRef prebuilt_name = nullptr,
                                   JSValueRef* cached_proto = nullptr);
  static JSValueRef CallWasmFunction(JSContextRef ctx, JSObjectRef function,
                                     JSObjectRef thisObject, size_t argc,
                                     const JSValueRef argv[],
                                     JSValueRef* exception);
  JSValueRef CallWith(JSContextRef ctx, JSCEnv* env, size_t argc,
                      const JSValueRef argv[], wasm_val_t* values,
                      JSValueRef* exception);

  wasm::WasmTrackedHandle tracked_;
  wasm::WasmStoreOwner* store_owner_ = nullptr;
  wasm_func_t* func_ = nullptr;
  JSObjectRef js_obj_ = nullptr;
  WasmSignature sig_;
  JSCKeepSet keep_set_;
};

}  // namespace primjs::jsc

#endif  // SRC_WASM_JSC_FUNCTION_H_
