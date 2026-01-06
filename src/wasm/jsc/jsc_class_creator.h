// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_CLASS_CREATOR_H_
#define SRC_WASM_JSC_CLASS_CREATOR_H_

#include <JavaScriptCore/JavaScriptCore.h>

namespace primjs::jsc {
class JSClassCreator {
 public:
  static JSClassRef JSCreateClass(const JSClassDefinition& def);
  static JSClassRef JSCreateClass(const char* name,
                                  JSObjectFinalizeCallback finalizer);
  static JSClassDefinition GetClassDefinition(
      const char* name, JSObjectFinalizeCallback finalizer = NULL,
      JSObjectCallAsConstructorCallback callback = NULL);

  inline static JSPropertyAttributes DefaultAttr() {
    return kJSPropertyAttributeReadOnly | kJSPropertyAttributeDontEnum |
           kJSPropertyAttributeDontDelete;
  }
};

}  // namespace primjs::jsc
#endif  // SRC_WASM_JSC_CLASS_CREATOR_H_
