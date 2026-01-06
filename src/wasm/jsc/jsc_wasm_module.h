// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_WASM_MODULE_
#define SRC_WASM_JSC_WASM_MODULE_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/one_of.h"
#include "common/wasm_utils.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Module;
class PrismModule;
}  // namespace wasm

using WasmModuleRef = OneOf<wasm::Wasm3Module*, wasm::PrismModule*>;

namespace jsc {
class JSCWasmModule {
 public:
  JSCWasmModule(WasmModuleRef module_inst, InteropRuntime* interop);
  ~JSCWasmModule();

  static JSObjectRef CreateConstructor(JSContextRef ctx,
                                       InteropRuntime* interop,
                                       JSValueRef* exception);

  static JSObjectRef CreateJSObject(JSContextRef ctx, JSObjectRef constructor,
                                    WasmModuleRef module,
                                    JSValueRef* exception);

  static JSObjectRef CreatePrototype(JSContextRef ctx, JSValueRef* exception);

  static JSObjectRef CallAsConstructor(JSContextRef ctx,
                                       JSObjectRef constructor, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception);

  static JSValueRef ExportsCallback(JSContextRef ctx, JSObjectRef function,
                                    JSObjectRef thisObject, size_t argc,
                                    const JSValueRef argv[],
                                    JSValueRef* exception);
  static JSValueRef ImportsCallback(JSContextRef ctx, JSObjectRef function,
                                    JSObjectRef thisObject, size_t argc,
                                    const JSValueRef argv[],
                                    JSValueRef* exception);
  static JSValueRef SupportBase64(JSContextRef ctx, JSObjectRef object,
                                  JSStringRef propertyName,
                                  JSValueRef* exception);

  static void Finalize(JSObjectRef object);

  static bool IsWasmModuleObject(JSContextRef ctx, JSObjectRef constructor,
                                 JSObjectRef target, JSValueRef* exception);

  static uint8_t* GetWireBytes(JSContextRef ctx, JSValueRef val,
                               size_t* byteLength, JSValueRef* exception);

  WasmModuleRef& module() { return module_; }

  void ReleaseClassRef();

 private:
  OWNER WasmModuleRef module_;

  static JSClassRef class_ref();
  static JSClassRef constructor_class_ref();
  static JSClassRef prototype_class_ref();

  BORROWER InteropRuntime* interop_runtime_;

  static JSClassRef InitClassRef();
  static JSClassRef InitProtoClassRef();
  static JSClassRef InitCtorClassRef();
};

}  // namespace jsc
}  // namespace primjs
#endif  // SRC_WASM_JSC_WASM_MODULE_
