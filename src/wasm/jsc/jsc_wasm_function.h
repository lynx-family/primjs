// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_WASM_FUNCTION_H_
#define SRC_WASM_JSC_WASM_FUNCTION_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/one_of.h"
#include "common/wasm_utils.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Function;
class PrismFunction;
}  // namespace wasm

using WasmFunctionRef = OneOf<wasm::Wasm3Function*, wasm::PrismFunction*>;

namespace jsc {
class JSCWasmFunction {
 public:
  JSCWasmFunction(WasmFunctionRef function, InteropRuntime* interop);
  ~JSCWasmFunction();

  static JSObjectRef CreateConstructor(JSContextRef ctx,
                                       InteropRuntime* interop,
                                       JSValueRef* exception);

  static JSObjectRef CreateJSObject(JSContextRef ctx, JSObjectRef constructor,
                                    WasmFunctionRef global,
                                    JSValueRef* exception);

  static JSObjectRef CreatePrototype(JSContextRef ctx, JSValueRef* exception);

  static JSObjectRef CallAsConstructor(JSContextRef ctx,
                                       JSObjectRef constructor, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception);

  static JSValueRef CallWasmFunction(JSContextRef ctx, JSObjectRef function,
                                     JSObjectRef thisObject, size_t argc,
                                     const JSValueRef argv[],
                                     JSValueRef* exception);

  static void Finalize(JSObjectRef object);

  WasmFunctionRef& function() { return function_; }

  static JSClassRef class_id() { return class_id_; }

 private:
  static JSClassRef class_id_;

  OWNER WasmFunctionRef function_;

  BORROWER InteropRuntime* interop_runtime_;
};

}  // namespace jsc
}  // namespace primjs

#endif  // SRC_WASM_JSC_WASM_FUNCTION_H_
