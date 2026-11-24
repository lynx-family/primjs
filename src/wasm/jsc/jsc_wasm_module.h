// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_MODULE_H_
#define SRC_WASM_JSC_MODULE_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/wasm_store_owner.h"
#include "common/wasm_type.h"

namespace primjs::jsc {

class JSCEnv;

class JSCWasmModule {
 public:
  JSCWasmModule(JSCEnv* env, wasm_module_t* module);
  ~JSCWasmModule();

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

  static bool IsWasmModuleObject(JSContextRef ctx, JSValueRef target);

  wasm_module_t* module() const { return module_; }
  wasm::WasmStoreOwner* store_owner() const { return store_owner_; }
  const wasm_importtype_vec_t* ImportTypes();

 private:
  static JSClassRef InitClassRef();
  static JSClassRef InitProtoClassRef();
  static JSClassRef InitCtorClassRef();
  static void Finalize(JSObjectRef object);
  static void DetachOnExit(wasm::WasmTrackedHandle* handle, void* exit_ctx);
  void DetachWasmModule();

  static JSObjectRef CreatePrototype(JSContextRef ctx, JSValueRef* exception);
  static JSObjectRef CreateJSObject(JSContextRef ctx, JSObjectRef constructor,
                                    JSCEnv* env, wasm_module_t* module,
                                    JSValueRef* exception);

  static uint8_t* GetWireBytes(JSContextRef ctx, JSValueRef val,
                               size_t* byteLength, JSValueRef* exception);

  static JSValueRef SupportBase64(JSContextRef ctx, JSObjectRef object,
                                  JSStringRef propertyName,
                                  JSValueRef* exception);

  wasm::WasmTrackedHandle tracked_;
  wasm::WasmStoreOwner* store_owner_ = nullptr;
  wasm_module_t* module_ = nullptr;
  wasm_importtype_vec_t import_types_ = {0, nullptr};
  bool imports_loaded_ = false;
};

}  // namespace primjs::jsc

#endif  // SRC_WASM_JSC_MODULE_H_
