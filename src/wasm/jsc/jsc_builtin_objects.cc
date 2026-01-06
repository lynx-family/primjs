// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_builtin_objects.h"

#include "common/wasm_log.h"
#include "jsc/jsc_ext_api.h"

namespace primjs::jsc {
JSStringRef JSCBuiltinObjects::PrototypeStr() {
  static JSStringRef prototype_ref = JSStringRetain(JSString("prototype"));
  return prototype_ref;
}

JSObjectRef JSCBuiltinObjects::GetFnDefineProperty(JSContextRef ctx,
                                                   JSValueRef* exception) {
  JSObjectRef global = JSContextGetGlobalObject(ctx);
  JSValueRef js_object_val =
      JSObjectGetProperty(ctx, global, JSString("Object"), exception);
  if (!js_object_val) return nullptr;
  JSObjectRef js_object = JSValueToObject(ctx, js_object_val, exception);
  if (js_object) {
    JSValueRef fn_value = JSObjectGetProperty(
        ctx, js_object, JSString("defineProperty"), nullptr);
    if (fn_value) {
      return JSValueToObject(ctx, fn_value, exception);
    }
  }
  return nullptr;
}

JSObjectRef JSCBuiltinObjects::GetJSFunction(JSContextRef ctx,
                                             JSValueRef* exception) {
  static JSStringRef fun_name = JSStringRetain(JSString("Function"));

  JSObjectRef global = JSContextGetGlobalObject(ctx);
  JSValueRef functor = JSObjectGetProperty(ctx, global, fun_name, exception);
  if (functor) {
    return JSValueToObject(ctx, functor, exception);
  }
  return nullptr;
}

}  // namespace primjs::jsc
