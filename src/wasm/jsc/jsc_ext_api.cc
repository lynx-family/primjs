// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_ext_api.h"

#include <climits>
#include <cmath>
#include <cstdio>
#include <cstring>

#include "common/js_type.h"
#include "common/wasm_utils.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"

namespace primjs::jsc {

JSObjectRef JSFunctionMake(JSContextRef ctx, const char* name,
                           JSObjectCallAsFunctionCallback cb) {
  return JSObjectMakeFunctionWithCallback(ctx, JSString(name), cb);
}

void InitConstructor(JSContextRef ctx, JSObjectRef ctor, const char* name,
                     JSObjectRef prototype, JSValueRef* exception) {
  JSValueRef name_str = JSValueMakeString(ctx, JSString(name));
  JSObjectSetProperty(ctx, ctor, JSString("name"), name_str,
                      kJSPropertyAttributeReadOnly |
                          kJSPropertyAttributeDontEnum |
                          kJSPropertyAttributeDontDelete,
                      exception);
  JSObjectSetProperty(ctx, ctor, JSCBuiltinObjects::PrototypeStr(), prototype,
                      kJSPropertyAttributeReadOnly |
                          kJSPropertyAttributeDontEnum |
                          kJSPropertyAttributeDontDelete,
                      exception);
  JSObjectSetProperty(ctx, prototype, JSString("constructor"), ctor,
                      kJSPropertyAttributeDontEnum, exception);

  SetConstructorProto(ctx, ctor, exception);
}

void Attach(JSContextRef ctx, const char* name, JSObjectRef obj,
            JSPropertyAttributes attrs, JSObjectRef parent,
            JSValueRef* exception) {
  if (!parent) {
    parent = JSContextGetGlobalObject(ctx);
  }
  JSObjectSetProperty(ctx, parent, JSString(name), obj, attrs, exception);
}

void DefineProperties(JSContextRef ctx, JSObjectRef object,
                      const PropertyDescriptor* descriptor,
                      JSValueRef* exception) {
  JSObjectRef fn = JSCBuiltinObjects::GetFnDefineProperty(ctx, exception);
  if (!fn) return;
  while (descriptor && descriptor->name) {
    DefineProperty(ctx, object, fn, *descriptor, exception);
    ++descriptor;
  }
}

void DefineProperty(JSContextRef ctx, JSObjectRef object,
                    JSObjectRef fnDefineProperty,
                    const PropertyDescriptor& descriptor,
                    JSValueRef* exception) {
  JSObjectRef desc_ref = JSObjectMake(ctx, nullptr, nullptr);
  JSObjectSetProperty(
      ctx, desc_ref, JSString("enumerable"),
      JSValueMakeBoolean(
          ctx, descriptor.attributes & PropertyAttributes::Enumerable),
      kJSPropertyAttributeNone, exception);
  JSObjectSetProperty(
      ctx, desc_ref, JSString("configurable"),
      JSValueMakeBoolean(
          ctx, descriptor.attributes & PropertyAttributes::Configurable),
      kJSPropertyAttributeNone, exception);
  if (descriptor.getter) {
    JSObjectRef getter =
        JSObjectMakeFunctionWithCallback(ctx, nullptr, descriptor.getter);
    JSObjectSetProperty(ctx, desc_ref, JSString("get"), getter,
                        kJSPropertyAttributeNone, exception);
  }
  if (descriptor.setter) {
    JSObjectRef setter =
        JSObjectMakeFunctionWithCallback(ctx, nullptr, descriptor.setter);
    JSObjectSetProperty(ctx, desc_ref, JSString("set"), setter,
                        kJSPropertyAttributeNone, exception);
  }

  JSValueRef args[] = {
      object, JSValueMakeString(ctx, JSString(descriptor.name)), desc_ref};
  JSObjectCallAsFunction(ctx, fnDefineProperty, nullptr, 3, args, exception);
}

bool HasInstance(JSContextRef ctx, JSObjectRef constructor, JSValueRef value,
                 JSValueRef* exception) {
  constexpr const char* kCodeMessages = "object instanceof WebAssembly.XXX";

  JSValueRef proto = JSObjectGetProperty(
      ctx, constructor, JSCBuiltinObjects::PrototypeStr(), exception);
  if (exception && *exception) return false;

  if (!JSValueIsObject(ctx, value)) {
    return false;
  }

  if (!JSValueIsObject(ctx, proto)) {
    ThrowIfException(
        ctx, ErrorTypes::kTypeError, kCodeMessages,
        "instanceof called on an object with an invalid prototype property",
        exception);
    return false;
  }

  JSObjectRef object = JSValueToObject(ctx, value, exception);
  if ((exception && *exception) || !object) {
    return false;
  }

  while (true) {
    JSValueRef object_value = JSObjectGetPrototype(ctx, object);
    if (!JSValueIsObject(ctx, object_value)) {
      return false;
    }

    object = JSValueToObject(ctx, object_value, exception);
    if ((exception && *exception) || !object) {
      return false;
    }

    if (JSValueIsStrictEqual(ctx, proto, object)) {
      return true;
    }
  }
}

JSValueRef ThrowCallException(JSContextRef ctx, JSObjectRef function,
                              JSObjectRef thisObject, size_t argc,
                              const JSValueRef argv[], JSValueRef* exception) {
  (void)thisObject;
  (void)argc;
  (void)argv;
  if (exception) {
    char str[128] = "an object";
    JSStringRef js_str = JSValueToStringCopy(ctx, function, nullptr);
    if (js_str != nullptr) {
      JSStringGetUTF8CString(js_str, str, sizeof(str));
      JSStringRelease(js_str);
    }
    char msg[256] = {0};
    std::snprintf(msg, sizeof(msg),
                  "Exception by invoke Object without [[Call]] on %s", str);
    ThrowIfException(ctx, ErrorTypes::kTypeError, "", msg, exception);
  }
  return JSValueMakeUndefined(ctx);
}

bool JSValueGetInt32(JSContextRef ctx, JSValueRef js_val, int32_t* res,
                     JSValueRef* exception) {
  JSValueRef local_exc = nullptr;
  double ret = JSValueToNumber(ctx, js_val, &local_exc);
  if (local_exc) {
    if (exception) *exception = local_exc;
    return false;
  }
  if (!std::isfinite(ret) || ret > INT32_MAX || ret < INT32_MIN) {
    return false;
  }
  *res = static_cast<int32_t>(ret);
  return true;
}

namespace {
JSObjectRef CreateError(JSContextRef ctx, JSObjectRef global, const char* err,
                        JSValueRef msg, JSValueRef* exception) {
  JSValueRef error_ctor_value =
      JSObjectGetProperty(ctx, global, JSString(err), exception);
  if (exception && *exception) return nullptr;
  JSObjectRef error_ctor = JSValueToObject(ctx, error_ctor_value, exception);
  if ((exception && *exception) || !error_ctor) return nullptr;
  return JSObjectCallAsConstructor(ctx, error_ctor, 1, &msg, exception);
}
}  // namespace

JSValueRef ThrowError(JSContextRef ctx, const char* err, JSValueRef code,
                      JSValueRef msg, JSValueRef* exception) {
  JSObjectRef global = JSContextGetGlobalObject(ctx);
  if (std::strcmp(err, "Error") != 0) {
    return CreateError(ctx, global, err, msg, exception);
  }
  JSObjectRef cause = JSObjectMake(ctx, nullptr, nullptr);
  JSObjectSetProperty(ctx, cause, JSString("code"), code,
                      kJSPropertyAttributeNone, exception);
  JSObjectRef error = JSObjectMakeError(ctx, 1, &msg, exception);
  if (error) {
    JSObjectSetProperty(ctx, error, JSString("cause"), cause,
                        kJSPropertyAttributeDontEnum, exception);
  }
  return error;
}

JSObjectRef ThrowIfException(JSContextRef ctx, ErrorTypes err, const char* code,
                             const char* msg, JSValueRef* exception) {
  const uint32_t err_idx = static_cast<uint32_t>(err);
  const char* safe_code = code ? code : "";
  const char* safe_msg = msg ? msg : "unknown error";
  WLOGE("%s: %s: %s", kErrorStrings[err_idx], safe_code, safe_msg);

  if (wasm_likely(exception)) {
    JSValueRef code_value = JSValueMakeString(ctx, JSString(safe_code));
    JSValueRef msg_value = JSValueMakeString(ctx, JSString(safe_msg));
    JSValueRef inner_exc = nullptr;
    JSValueRef created = ThrowError(ctx, kErrorStrings[err_idx], code_value,
                                    msg_value, &inner_exc);
    *exception = inner_exc ? inner_exc : created;
  }
  return nullptr;
}

void SetConstructorProto(JSContextRef ctx, JSObjectRef object,
                         JSValueRef* exception) {
  JSObjectRef global = JSContextGetGlobalObject(ctx);
  JSValueRef value =
      JSObjectGetProperty(ctx, global, JSString("Function"), exception);
  if (exception && *exception) return;
  JSObjectRef func_ctor = JSValueToObject(ctx, value, exception);
  if (exception && *exception) return;
  if (func_ctor) {
    JSValueRef func_proto = JSObjectGetPrototype(ctx, func_ctor);
    JSObjectSetPrototype(ctx, object, func_proto);
  }
}

bool RetainWasmRootOnJSCObject(JSContextRef ctx, JSObjectRef obj,
                               JSObjectRef wasm_root, JSValueRef* exception) {
  if (wasm_unlikely(!obj || !wasm_root)) return false;
  static JSStringRef root_prop =
      JSStringCreateWithUTF8CString(kWasmRootProperty);
  JSValueRef local_exc = nullptr;
  JSObjectSetProperty(ctx, obj, root_prop, wasm_root,
                      kJSPropertyAttributeReadOnly |
                          kJSPropertyAttributeDontEnum |
                          kJSPropertyAttributeDontDelete,
                      &local_exc);
  if (local_exc) {
    if (exception) *exception = local_exc;
    return false;
  }
  return true;
}

}  // namespace primjs::jsc
