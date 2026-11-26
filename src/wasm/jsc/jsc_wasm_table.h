// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_TABLE_H_
#define SRC_WASM_JSC_TABLE_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/wasm_store_owner.h"
#include "common/wasm_type.h"
#include "jsc/js_env_jsc.h"

namespace primjs::jsc {

class JSCWasmTable {
 public:
  static constexpr int32_t kMaxSaneTableSize = 100000;

  JSCWasmTable(JSCEnv* env, wasm_table_t* table, uint32_t maximum,
               JSObjectRef js_obj);
  ~JSCWasmTable();

  static JSClassRef class_ref();
  static JSClassRef prototype_class_ref();
  static JSClassRef constructor_class_ref();
  static void ReleaseClassRef();

  static JSCWasmTable* Of(const wasm_table_t* table) {
    return table ? static_cast<JSCWasmTable*>(wasm_table_get_host_info(table))
                 : nullptr;
  }

  static bool IsJSCWasmTable(JSContextRef ctx, JSValueRef target);

  static JSObjectRef CreateConstructor(JSContextRef ctx, JSCEnv* env,
                                       JSValueRef* exception);
  static JSObjectRef CallAsConstructor(JSContextRef ctx,
                                       JSObjectRef constructor, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception);

  static JSObjectRef GetOrWrapOwnedTable(JSContextRef ctx, JSCEnv* env,
                                         wasm_table_t* table,
                                         JSValueRef* exception);

  wasm_table_t* table() const { return table_; }
  wasm::WasmStoreOwner* store_owner() const { return store_owner_; }
  uint32_t maximum() const { return maximum_; }
  uint32_t size() const { return table_ ? wasm_table_size(table_) : 0; }
  JSObjectRef js_object() const { return js_obj_; }
  JSCKeepSet& keep_set() { return keep_set_; }
  const JSCKeepSet& keep_set() const { return keep_set_; }

 private:
  static JSClassRef InitClassRef();
  static JSClassRef InitProtoClassRef();
  static JSClassRef InitCtorClassRef();
  static void Finalize(JSObjectRef object);
  static void DetachOnExit(wasm::WasmTrackedHandle* handle, void* exit_ctx);
  void DetachWasmTable();

  static JSObjectRef CreatePrototype(JSContextRef ctx, JSValueRef* exception);
  static JSObjectRef WrapOwnedTable(JSContextRef ctx, JSCEnv* env,
                                    wasm_table_t* table, uint32_t maximum,
                                    JSValueRef* exception);

  static JSValueRef GetLengthCallback(JSContextRef ctx, JSObjectRef function,
                                      JSObjectRef thisObject, size_t argc,
                                      const JSValueRef argv[],
                                      JSValueRef* exception);
  static JSValueRef GetIndexCallback(JSContextRef ctx, JSObjectRef function,
                                     JSObjectRef thisObject, size_t argc,
                                     const JSValueRef argv[],
                                     JSValueRef* exception);
  static JSValueRef SetIndexCallback(JSContextRef ctx, JSObjectRef function,
                                     JSObjectRef thisObject, size_t argc,
                                     const JSValueRef argv[],
                                     JSValueRef* exception);
  static JSValueRef GrowCallback(JSContextRef ctx, JSObjectRef function,
                                 JSObjectRef thisObject, size_t argc,
                                 const JSValueRef argv[],
                                 JSValueRef* exception);

  wasm::WasmTrackedHandle tracked_;
  wasm::WasmStoreOwner* store_owner_ = nullptr;
  wasm_table_t* table_ = nullptr;
  uint32_t maximum_ = wasm_limits_max_default;
  JSObjectRef js_obj_ = nullptr;
  JSCKeepSet keep_set_;
};

}  // namespace primjs::jsc

#endif  // SRC_WASM_JSC_TABLE_H_
