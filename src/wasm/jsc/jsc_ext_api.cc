// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_ext_api.h"

#include <cmath>

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
  // set [[prototype]] = __proto__ for constructor
  // JSObjectSetPrototype(
  //     ctx, ctor,
  //     JSCBuiltinObjects::GetInstance(ctx)->GetFunctionPrototype());
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

static JSValueRef DefaultDebugCallback(JSContextRef ctx, JSObjectRef function,
                                       JSObjectRef thisObject, size_t argc,
                                       const JSValueRef argv[],
                                       JSValueRef* exception) {
  WLOGI("DebugCallback @ %s\n", __func__);
  return NULL;
}

void AttachDebugger(JSContextRef ctx, JSObjectRef obj, const char* name,
                    JSValueRef* exception, DebugCallback callback) {
  if (!callback) {
    callback = DefaultDebugCallback;
  }
  JSObjectRef debugger = JSFunctionMake(ctx, name, callback);
  JSObjectSetProperty(ctx, obj, JSString(name), debugger,
                      kJSPropertyAttributeNone, exception);
}

bool ObjectHasProperty(JSContextRef ctx, JSObjectRef object, const char* name) {
  return JSObjectHasProperty(ctx, object, JSString(name));
}

JSObjectRef ObjectGetProperty(JSContextRef ctx, JSObjectRef object,
                              const char* name) {
  JSValueRef obj = JSObjectGetProperty(ctx, object, JSString(name), NULL);
  return JSValueToObject(ctx, obj, NULL);
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
        JSObjectMakeFunctionWithCallback(ctx, NULL, descriptor.getter);
    JSObjectSetProperty(ctx, desc_ref, JSString("get"), getter,
                        kJSPropertyAttributeNone, exception);
  }
  if (descriptor.setter) {
    JSObjectRef setter =
        JSObjectMakeFunctionWithCallback(ctx, NULL, descriptor.setter);
    JSObjectSetProperty(ctx, desc_ref, JSString("set"), setter,
                        kJSPropertyAttributeNone, exception);
  }

  JSValueRef args[] = {
      object, JSValueMakeString(ctx, JSString(descriptor.name)), desc_ref};
  JSObjectCallAsFunction(ctx, fnDefineProperty, nullptr, 3, args, exception);
}

bool HasInstance(JSContextRef ctx, JSObjectRef constructor, JSValueRef value,
                 JSValueRef* exception) {
  // constructor here is WebAssembly.XXX.prototype.constructor
  constexpr const char* kCodeMessages = "object instanceof WebAssembly.XXX";

  JSValueRef proto = JSObjectGetProperty(
      ctx, constructor, JSCBuiltinObjects::PrototypeStr(), exception);

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

  return false;
}

JSValueRef ThrowCallException(JSContextRef ctx, JSObjectRef function,
                              JSObjectRef thisObject, size_t argc,
                              const JSValueRef argv[], JSValueRef* exception) {
  if (exception) {
    JSStringRef js_str = JSValueToStringCopy(ctx, function, NULL);
    size_t len = JSStringGetLength(js_str);
    // including null-terminated character
    char str[len + 1];
    JSStringGetUTF8CString(js_str, str, len + 1);
    char msg[256] = {0};
    snprintf(msg, 255, "Exception by invoke Object without [[Call]] on %s",
             str);
    ThrowIfException(ctx, ErrorTypes::kError, "", msg, exception);
  }
  return JSValueMakeUndefined(ctx);
}

bool JSValueGetInt32(JSContextRef ctx, JSValueRef js_val, int32_t* res) {
  double ret = JSValueToNumber(ctx, js_val, NULL);
  if (!std::isfinite(ret) || ret > INT32_MAX) {
    return false;
  }
  *res = static_cast<int32_t>(ret);
  return true;
}

static FORCE_INLINE JSObjectRef CreateError(JSContextRef ctx,
                                            JSObjectRef global, const char* err,
                                            JSValueRef msg,
                                            JSValueRef* exception) {
  JSValueRef error_ctor_value =
      JSObjectGetProperty(ctx, global, JSString(err), exception);
  JSObjectRef error_ctor = JSValueToObject(ctx, error_ctor_value, exception);
  JSObjectRef error =
      JSObjectCallAsConstructor(ctx, error_ctor, 1, &msg, exception);

  return error;
}

JSValueRef ThrowError(JSContextRef ctx, const char* err, JSValueRef code,
                      JSValueRef msg, JSValueRef* exception) {
  WASM_DCHECK(msg != nullptr);

  JSObjectRef global = JSContextGetGlobalObject(ctx);

  JSObjectRef error{};
  if (strcmp(err, "Error") != 0) {
    error = CreateError(ctx, global, err, msg, exception);
  } else {
    JSObjectRef cause = JSObjectMake(ctx, NULL, NULL);
    JSObjectSetProperty(ctx, cause, JSString("code"), code,
                        kJSPropertyAttributeNone, exception);
    error = JSObjectMakeError(ctx, 1, &msg, exception);
    JSObjectSetProperty(ctx, error, JSString("cause"), cause,
                        kJSPropertyAttributeDontEnum, exception);
  }

  return error;
}

void SetConstructorProto(JSContextRef ctx, JSObjectRef object,
                         JSValueRef* exception) {
  JSObjectRef global = JSContextGetGlobalObject(ctx);
  JSValueRef value =
      JSObjectGetProperty(ctx, global, JSString("Function"), exception);
  if (exception && *exception) return;
  // If we don't have Function then something bad is going on.
  JSObjectRef func_ctor = JSValueToObject(ctx, value, exception);
  if (exception && *exception) return;
  if (func_ctor) {
    JSValueRef func_proto = JSObjectGetPrototype(ctx, func_ctor);
    JSObjectSetPrototype(ctx, object, func_proto);
  }
}

}  // namespace primjs::jsc
