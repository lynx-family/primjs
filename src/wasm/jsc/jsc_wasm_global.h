// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_WASM_GLOBAL_H_
#define SRC_WASM_JSC_WASM_GLOBAL_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/one_of.h"
#include "common/wasm_type.h"
#include "common/wasm_utils.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Global;
class PrismGlobal;
}  // namespace wasm

using WasmGlobalRef = OneOf<wasm::Wasm3Global*, wasm::PrismGlobal*>;

namespace jsc {
class JSCWasmGlobal {
 public:
  JSCWasmGlobal(WasmGlobalRef global, InteropRuntime* interop);
  ~JSCWasmGlobal();

  static JSObjectRef CreateConstructor(JSContextRef ctx,
                                       InteropRuntime* interop,
                                       JSValueRef* exception);

  static JSObjectRef CreateJSObject(JSContextRef ctx, JSObjectRef constructor,
                                    WasmGlobalRef global,
                                    JSValueRef* exception);

  static JSObjectRef CreatePrototype(JSContextRef ctx, JSValueRef* exception);

  static JSObjectRef CallAsConstructor(JSContextRef ctx,
                                       JSObjectRef constructor, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception);

  static JSValueRef GetValueCallback(JSContextRef ctx, JSObjectRef function,
                                     JSObjectRef thisObject, size_t argc,
                                     const JSValueRef argv[],
                                     JSValueRef* exception);

  static JSValueRef SetValueCallback(JSContextRef ctx, JSObjectRef function,
                                     JSObjectRef thisObject, size_t argc,
                                     const JSValueRef argv[],
                                     JSValueRef* exception);

  static JSValueRef ValueOfCallback(JSContextRef ctx, JSObjectRef function,
                                    JSObjectRef thisObject, size_t argc,
                                    const JSValueRef argv[],
                                    JSValueRef* exception);

  static JSValueRef JsToValue(JSContextRef ctx, double* val, JSValueRef js_val,
                              ValueType type);

  static void Finalize(JSObjectRef object);

  WasmGlobalRef global() const { return global_; }
  void ReleaseClassRef();

 private:
  static JSClassRef InitClassRef();
  static JSClassRef InitCtorClassRef();
  static JSClassRef InitProtoClassRef();

  static JSClassRef class_ref();
  static JSClassRef prototype_class_ref();
  static JSClassRef constructor_class_ref();
  OWNER WasmGlobalRef global_;
  BORROWER InteropRuntime* interop_runtime_;
};

}  // namespace jsc
}  // namespace primjs

#endif  // SRC_WASM_JSC_WASM_GLOBAL_H_
