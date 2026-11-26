// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_INSTANCE_H_
#define SRC_WASM_JSC_INSTANCE_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/wasm_store_owner.h"
#include "jsc/js_env_jsc.h"

namespace primjs::jsc {

class JSCWasmInstance {
 public:
  JSCWasmInstance(JSCEnv* env, wasm_instance_t* instance);
  ~JSCWasmInstance();

  static JSClassRef class_ref();
  static JSClassRef prototype_class_ref();
  static JSClassRef constructor_class_ref();
  static void ReleaseClassRef();

  static JSObjectRef CreateConstructor(JSContextRef ctx, JSCEnv* env,
                                       JSValueRef* exception);
  static JSObjectRef CallAsConstructor(JSContextRef ctx,
                                       JSObjectRef constructor, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception);
  JSCKeepSet& keep_set() { return keep_set_; }
  const JSCKeepSet& keep_set() const { return keep_set_; }

 private:
  static JSClassRef InitClassRef();
  static JSClassRef InitProtoClassRef();
  static JSClassRef InitCtorClassRef();
  static void Finalize(JSObjectRef object);
  static void DetachOnExit(wasm::WasmTrackedHandle* handle, void* exit_ctx);
  void DetachWasmInstance();

  static JSObjectRef CreatePrototype(JSContextRef ctx, JSValueRef* exception);

  wasm::WasmTrackedHandle tracked_;
  wasm::WasmStoreOwner* store_owner_ = nullptr;
  wasm_instance_t* instance_ = nullptr;
  JSCKeepSet keep_set_;
};

}  // namespace primjs::jsc

#endif  // SRC_WASM_JSC_INSTANCE_H_
