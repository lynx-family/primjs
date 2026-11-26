// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_MEMORY_H_
#define SRC_WASM_JSC_MEMORY_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/wasm_store_owner.h"
#include "common/wasm_type.h"

namespace primjs::jsc {

class JSCEnv;

class JSCWasmMemory {
 public:
  JSCWasmMemory(JSCEnv* env, wasm_memory_t* memory, uint32_t maximum,
                JSObjectRef js_obj);
  ~JSCWasmMemory();

  static JSClassRef class_ref();
  static JSClassRef prototype_class_ref();
  static JSClassRef constructor_class_ref();
  static void ReleaseClassRef();

  static JSCWasmMemory* Of(const wasm_memory_t* memory) {
    return memory
               ? static_cast<JSCWasmMemory*>(wasm_memory_get_host_info(memory))
               : nullptr;
  }

  static bool IsJSCWasmMemory(JSContextRef ctx, JSValueRef target);

  static JSObjectRef CreateConstructor(JSContextRef ctx, JSCEnv* env,
                                       JSValueRef* exception);
  static JSObjectRef CallAsConstructor(JSContextRef ctx,
                                       JSObjectRef constructor, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception);

  static JSObjectRef GetOrWrapOwnedMemory(JSContextRef ctx, JSCEnv* env,
                                          wasm_memory_t* memory,
                                          JSValueRef* exception);

  wasm_memory_t* memory() const { return memory_; }
  wasm::WasmStoreOwner* store_owner() const { return store_owner_; }
  uint32_t maximum() const { return maximum_; }
  size_t pages() const {
    return memory_ ? (wasm_memory_data_size(memory_) / kWasmPageSize) : 0;
  }
  JSObjectRef js_object() const { return js_obj_; }

 private:
  static JSClassRef InitClassRef();
  static JSClassRef InitProtoClassRef();
  static JSClassRef InitCtorClassRef();
  static void Finalize(JSObjectRef object);
  static void DetachOnExit(wasm::WasmTrackedHandle* handle, void* exit_ctx);
  void DetachWasmMemory();

  static JSObjectRef CreatePrototype(JSContextRef ctx, JSValueRef* exception);
  static JSObjectRef WrapOwnedMemory(JSContextRef ctx, JSCEnv* env,
                                     wasm_memory_t* memory, uint32_t maximum,
                                     JSValueRef* exception);

  static JSValueRef GetBufferCallback(JSContextRef ctx, JSObjectRef function,
                                      JSObjectRef thisObject, size_t argc,
                                      const JSValueRef argv[],
                                      JSValueRef* exception);
  static JSValueRef GrowCallback(JSContextRef ctx, JSObjectRef function,
                                 JSObjectRef thisObject, size_t argc,
                                 const JSValueRef argv[],
                                 JSValueRef* exception);

  wasm::WasmTrackedHandle tracked_;
  wasm::WasmStoreOwner* store_owner_ = nullptr;
  wasm_memory_t* memory_ = nullptr;
  uint32_t maximum_ = wasm_limits_max_default;
  size_t pages_ = 0;
  JSObjectRef buffer_ = nullptr;
  JSObjectRef js_obj_ = nullptr;
};

}  // namespace primjs::jsc

#endif  // SRC_WASM_JSC_MEMORY_H_
