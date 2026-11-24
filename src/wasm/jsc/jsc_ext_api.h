// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_EXT_API_H_
#define SRC_WASM_JSC_EXT_API_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include "common/js_type.h"
#include "common/wasm_utils.h"

namespace primjs::jsc {
constexpr const char* kWasmRootProperty = "__PRIMJS_WASM_ROOT__";

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

JSObjectRef JSFunctionMake(JSContextRef ctx, const char* name,
                           JSObjectCallAsFunctionCallback cb);

void InitConstructor(JSContextRef ctx, JSObjectRef ctor, const char* name,
                     JSObjectRef prototype, JSValueRef* exception);

void Attach(JSContextRef ctx, const char* name, JSObjectRef obj,
            JSPropertyAttributes attrs, JSObjectRef parent = nullptr,
            JSValueRef* exception = nullptr);

void DefineProperties(JSContextRef ctx, JSObjectRef object,
                      const PropertyDescriptor* descriptor,
                      JSValueRef* exception);

JSValueRef ThrowCallException(JSContextRef ctx, JSObjectRef function,
                              JSObjectRef thisObject, size_t argc,
                              const JSValueRef argv[], JSValueRef* exception);

bool HasInstance(JSContextRef ctx, JSObjectRef constructor,
                 JSValueRef possibleInstance, JSValueRef* exception);

bool JSValueGetInt32(JSContextRef ctx, JSValueRef js_val, int32_t* res,
                     JSValueRef* exception = nullptr);

void DefineProperty(JSContextRef ctx, JSObjectRef object,
                    JSObjectRef fnDefineProperty,
                    const PropertyDescriptor& descriptor,
                    JSValueRef* exception = nullptr);

JSValueRef ThrowError(JSContextRef ctx, const char* err, JSValueRef code,
                      JSValueRef msg, JSValueRef* exception);

class JSString {
 public:
  explicit JSString(const char* name)
      : string_(JSStringCreateWithUTF8CString(name)) {}
  ~JSString() { JSStringRelease(string_); }
  operator JSStringRef() const { return string_; }

 private:
  JSStringRef string_;
};

#if defined(__GNUC__) || defined(__clang__)
__attribute__((cold, noinline))
#endif
JSObjectRef
ThrowIfException(JSContextRef ctx, ErrorTypes err, const char* code,
                 const char* msg, JSValueRef* exception);

void SetConstructorProto(JSContextRef ctx, JSObjectRef object,
                         JSValueRef* exception);

bool RetainWasmRootOnJSCObject(JSContextRef ctx, JSObjectRef obj,
                               JSObjectRef wasm_root, JSValueRef* exception);

}  // namespace primjs::jsc

#endif  // SRC_WASM_JSC_EXT_API_H_
