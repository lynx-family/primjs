// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_WASM_MEMORY_
#define SRC_WASM_JSC_WASM_MEMORY_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/one_of.h"
#include "common/wasm_utils.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Memory;
class PrismMemory;
}  // namespace wasm

using WasmMemoryRef = OneOf<wasm::Wasm3Memory*, wasm::PrismMemory*>;

namespace jsc {
class JSCWasmMemory {
 public:
  JSCWasmMemory(WasmMemoryRef memory, size_t pages, InteropRuntime* interop);
  ~JSCWasmMemory();

  // return the WebAssembly.Memory() Constructor
  static JSObjectRef CreateConstructor(JSContextRef ctx,
                                       InteropRuntime* interop,
                                       JSValueRef* exception);

  static JSObjectRef CreateJSObject(JSContextRef ctx, JSObjectRef constructor,
                                    WasmMemoryRef memory, size_t pages,
                                    JSValueRef* exception);

  WasmMemoryRef& memory() { return memory_; }

 protected:
  static void Finalize(JSObjectRef object);

  static JSObjectRef CreatePrototype(JSContextRef ctx, JSValueRef* exception);

  static JSObjectRef CallAsConstructor(JSContextRef ctx,
                                       JSObjectRef constructor, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception);

  static JSValueRef GetBufferCallback(JSContextRef ctx, JSObjectRef function,
                                      JSObjectRef thisObject, size_t argc,
                                      const JSValueRef argv[],
                                      JSValueRef* exception);

  static JSValueRef GrowCallback(JSContextRef ctx, JSObjectRef function,
                                 JSObjectRef thisObject, size_t argc,
                                 const JSValueRef argv[],
                                 JSValueRef* exception);
  static void ReleaseClassRef();

 private:
  static constexpr uint32_t kMaxPagesNum = 65536;

  OWNER WasmMemoryRef memory_;

  size_t pages_;

  OWNER JSObjectRef buffer_;

  static JSClassRef class_ref();
  static JSClassRef prototype_class_ref();
  static JSClassRef constructor_class_ref();

  BORROWER InteropRuntime* interop_runtime_;

  static JSClassRef InitClassRef();
  static JSClassRef InitCtorClassRef();
  static JSClassRef InitProtoClassRef();
};

}  // namespace jsc
}  // namespace primjs

#endif  // SRC_WASM_JSC_WASM_MEMORY_
