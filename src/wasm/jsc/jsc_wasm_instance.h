// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_WASM_INSTANCE_
#define SRC_WASM_JSC_WASM_INSTANCE_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/one_of.h"
#include "common/wasm_utils.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Instance;
class PrismInstance;
}  // namespace wasm

using WasmInstanceRef = OneOf<wasm::Wasm3Instance*, wasm::PrismInstance*>;

namespace jsc {
class JSCWasmInstance {
 public:
  JSCWasmInstance(WasmInstanceRef instance, InteropRuntime* interop);
  ~JSCWasmInstance();

  static JSObjectRef CreateConstructor(JSContextRef ctx,
                                       InteropRuntime* interop,
                                       JSValueRef* exception);

  static JSObjectRef CreateJSObject(JSContextRef ctx, JSObjectRef constructor,
                                    WasmInstanceRef instance,
                                    JSValueRef* exception);

  static JSObjectRef CreatePrototype(JSContextRef ctx, JSValueRef* exception);

  static JSObjectRef CallAsConstructor(JSContextRef ctx,
                                       JSObjectRef constructor, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception);

  static void Finalize(JSObjectRef object);

  static void ReleaseClassRef();

 private:
  // WasmInstance has a lot of links from/to imports&exports,
  // so that it is maintained by shared_ptr.
  OWNER WasmInstanceRef instance_;
  BORROWER InteropRuntime* interop_runtime_;

  static JSClassRef InitClassRef();
  static JSClassRef InitCtorClassRef();
  static JSClassRef InitProtoClassRef();

  static JSClassRef class_ref();
  static JSClassRef prototype_class_ref();
  static JSClassRef constructor_class_ref();
};
}  // namespace jsc
}  // namespace primjs
#endif  // SRC_WASM_JSC_WASM_INSTANCE_
