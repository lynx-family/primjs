// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_EXT_API_H_
#define SRC_WASM_JSC_EXT_API_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/js_type.h"
#include "common/wasm_utils.h"

namespace primjs::jsc {
typedef enum {
  None = 0,
  Writable = 1 << 0,
  Enumerable = 1 << 1,
  Configurable = 1 << 2,
  DefaultMethod = Enumerable | Configurable,
  DefaultProperty = Enumerable | Configurable | Writable,
} PropertyAttributes;

using JSObjectPropertyGetter = JSObjectCallAsFunctionCallback;
using JSObjectPropertySetter = JSObjectCallAsFunctionCallback;

typedef struct {
  const char* name;
  JSObjectPropertyGetter getter;
  JSObjectPropertySetter setter;
  PropertyAttributes attributes;
} PropertyDescriptor;

using DebugCallback = JSValueRef (*)(JSContextRef ctx, JSObjectRef function,
                                     JSObjectRef thisObject, size_t argc,
                                     const JSValueRef argv[],
                                     JSValueRef* exception);

// evaluate script with exception handling
JSObjectRef JSFunctionMake(JSContextRef ctx, const char* name,
                           JSObjectCallAsFunctionCallback cb);

void InitConstructor(JSContextRef ctx, JSObjectRef ctor, const char* name,
                     JSObjectRef prototype, JSValueRef* exception);
// attach obj to parent (parent[name] = obj), if parent == NULL adopt Global as
// parent
void Attach(JSContextRef ctx, const char* name, JSObjectRef obj,
            JSPropertyAttributes attrs, JSObjectRef parent = NULL,
            JSValueRef* exception = NULL);

void DefineProperties(JSContextRef ctx, JSObjectRef object,
                      const PropertyDescriptor* descriptor,
                      JSValueRef* exception);

bool ObjectHasProperty(JSContextRef ctx, JSObjectRef object, const char* name);
JSObjectRef ObjectGetProperty(JSContextRef ctx, JSObjectRef object,
                              const char* name);

// add the debug method
void AttachDebugger(JSContextRef ctx, JSObjectRef obj, const char* name,
                    JSValueRef* exception = NULL,
                    DebugCallback callback = NULL);

JSValueRef ThrowCallException(JSContextRef ctx, JSObjectRef function,
                              JSObjectRef thisObject, size_t argc,
                              const JSValueRef argv[], JSValueRef* exception);

bool HasInstance(JSContextRef ctx, JSObjectRef constructor,
                 JSValueRef possibleInstance, JSValueRef* exception);

bool JSValueGetInt32(JSContextRef ctx, JSValueRef js_val, int32_t* res);

void DefineProperty(JSContextRef ctx, JSObjectRef object,
                    JSObjectRef fnDefineProperty,
                    const PropertyDescriptor& descriptor,
                    JSValueRef* exception = NULL);

JSValueRef ThrowError(JSContextRef ctx, const char* err, JSValueRef code,
                      JSValueRef msg, JSValueRef* exception);

class JSString {
 public:
  JSString(const char* name) : string_(JSStringCreateWithUTF8CString(name)) {}
  ~JSString() { JSStringRelease(string_); }
  operator JSStringRef() { return string_; }

 private:
  JSStringRef string_;
};

FORCE_INLINE JSObjectRef ThrowIfException(JSContextRef ctx, ErrorTypes err,
                                          const char* code, const char* msg,
                                          JSValueRef* exception) {
  uint32_t err_idx = static_cast<uint32_t>(err);
  WLOGE("%s: %s: %s", kErrorStrings[err_idx], code, msg);

  if (wasm_likely(exception)) {
    JSValueRef code_value = JSValueMakeString(ctx, JSString(code));
    JSValueRef msg_value = JSValueMakeString(ctx, JSString(msg));
    *exception = ThrowError(ctx, kErrorStrings[err_idx], code_value, msg_value,
                            exception);
  }

  return {};
}

void SetConstructorProto(JSContextRef ctx, JSObjectRef object,
                         JSValueRef* exception);

}  // namespace primjs::jsc

#endif  // SRC_WASM_JSC_EXT_API_H_
