// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_BUILTIN_OBJECT_H_
#define SRC_WASM_JSC_BUILTIN_OBJECT_H_

#include <JavaScriptCore/JavaScriptCore.h>

namespace primjs::jsc {
class JSCBuiltinObjects {
 public:
  static JSObjectRef GetJSFunction(JSContextRef ctx,
                                   JSValueRef* exception = nullptr);
  static JSObjectRef GetFnDefineProperty(JSContextRef ctx,
                                         JSValueRef* exception);

  static JSStringRef PrototypeStr();
};

}  // namespace primjs::jsc

#endif  // SRC_WASM_JSC_BUILTIN_OBJECT_H_
