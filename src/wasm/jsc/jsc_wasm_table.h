// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_WASM_TABLE_
#define SRC_WASM_JSC_WASM_TABLE_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/one_of.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Table;
class PrismTable;
}  // namespace wasm

using WasmTableRef = OneOf<wasm::Wasm3Table*, wasm::PrismTable*>;

namespace jsc {
class JSCWasmTable {
 public:
  JSCWasmTable(WasmTableRef table, InteropRuntime* interop);

  ~JSCWasmTable();

  // return the WebAssembly.Table() Constructor
  // ctx : A JavaScript execution context
  // wctx: WebAssembly execution context representing the "WebAssembly"
  // namespace
  static JSObjectRef CreateConstructor(JSContextRef ctx,
                                       InteropRuntime* interop,
                                       JSValueRef* exception);

  // create JSObject with self Constructor
  static JSObjectRef CreateJSObject(JSContextRef ctx, JSObjectRef constructor,
                                    WasmTableRef table, JSValueRef* exception);

  static JSObjectRef CreatePrototype(JSContextRef ctx, JSValueRef* exception);

  static JSObjectRef CallAsConstructor(JSContextRef ctx,
                                       JSObjectRef constructor, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception);

  static void Finalize(JSObjectRef object);

  static bool IsJSCWasmTable(JSContextRef ctx, JSValueRef target);

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

  WasmTableRef& table() { return table_; }
  static void ReleaseClassRef();

 private:
  //  Default max table size of wasm3 we used is 100000. Table imported from JS
  //  will be compared with wasm3 table declaration. If the table size in JS is
  //  not specified, max size in JS and wasm3 will be different. This will cause
  //  import failure.
  static constexpr uint32_t MaxSaneTableSize = 100000;

  static JSClassRef class_ref_;
  static JSClassRef prototype_class_ref_;
  static JSClassRef constructor_class_ref_;

  OWNER WasmTableRef table_;

  BORROWER InteropRuntime* interop_runtime_;

  static JSClassRef InitClassRef();
  static JSClassRef InitProtoClassRef();
  static JSClassRef InitCtorClassRef();
};
}  // namespace jsc
}  // namespace primjs
#endif  // SRC_WASM_JSC_WASM_TABLE_
