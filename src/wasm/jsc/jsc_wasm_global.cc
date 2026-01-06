// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm_global.h"

#include "common/interop_runtime.h"
#include "common/js_type.h"
#include "common/messages.h"
#include "common/wasm_utils.h"
#include "jsc/js_env_jsc.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"
#include "jsc/jsc_wasm.h"

namespace primjs::jsc {
using wasm::PrismGlobal;
using wasm::Wasm3Global;

// static
JSClassRef JSCWasmGlobal::class_ref() {
  static JSClassRef class_ref = JSCWasmGlobal::InitClassRef();
  return class_ref;
}
JSClassRef JSCWasmGlobal::prototype_class_ref() {
  static JSClassRef prototype_class_ref = JSCWasmGlobal::InitProtoClassRef();
  return prototype_class_ref;
}
JSClassRef JSCWasmGlobal::constructor_class_ref() {
  static JSClassRef constructor_class_ref = JSCWasmGlobal::InitCtorClassRef();
  return constructor_class_ref;
}

JSClassRef JSCWasmGlobal::InitClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Global", Finalize);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmGlobal::InitCtorClassRef() {
  JSClassDefinition def = JSClassCreator::GetClassDefinition(
      "WebAssembly.Global", NULL, CallAsConstructor);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmGlobal::InitProtoClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Global.Prototype", NULL);

  JSPropertyAttributes default_attr = JSClassCreator::DefaultAttr();

  JSStaticFunction static_funcs[] = {{"valueOf", ValueOfCallback, default_attr},
                                     {0, 0, 0}};
  def.staticFunctions = static_funcs;
  return JSClassCreate(&def);
}

void JSCWasmGlobal::ReleaseClassRef() {
  JSClassRelease(class_ref());
  JSClassRelease(prototype_class_ref());
  JSClassRelease(constructor_class_ref());
}

JSCWasmGlobal::JSCWasmGlobal(WasmGlobalRef global, InteropRuntime* interop)
    : global_(std::move(global)) {
  interop_runtime_ = interop;
  InteropRuntime::IncreaseRefCount(interop_runtime_);
}

JSCWasmGlobal::~JSCWasmGlobal() {
  WLOGD("Running JSCWasmGlobal::%s...", __func__);
  if (global_.is<Wasm3Global*>()) {
    delete global_.get<Wasm3Global*>();
  } else {
    delete global_.get<PrismGlobal*>();
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

// static
void JSCWasmGlobal::Finalize(JSObjectRef object) {
  WLOGD("Running JSCWasmGlobal::%s...", __func__);
  auto global = static_cast<JSCWasmGlobal*>(JSObjectGetPrivate(object));
  delete global;
}

// static
JSObjectRef JSCWasmGlobal::CreatePrototype(JSContextRef ctx,
                                           JSValueRef* exception) {
  JSObjectRef prototype = JSObjectMake(ctx, prototype_class_ref(), NULL);

  PropertyDescriptor instance_values[] = {
      {"value", GetValueCallback, SetValueCallback, PropertyAttributes::None},
      {0, 0, 0, PropertyAttributes::None}};
  DefineProperties(ctx, prototype, instance_values, exception);

  return prototype;
}

// static
JSObjectRef JSCWasmGlobal::CreateJSObject(JSContextRef ctx,
                                          JSObjectRef constructor,
                                          WasmGlobalRef global,
                                          JSValueRef* exception) {
  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(constructor));
  WASM_DCHECK(interop != nullptr);
  auto global_data = new JSCWasmGlobal(global, interop);

  JSObjectRef obj = JSObjectMake(ctx, class_ref(), global_data);

  JSValueRef maybe_prototype = JSObjectGetProperty(
      ctx, constructor, JSCBuiltinObjects::PrototypeStr(), exception);
  JSObjectRef prototype = JSValueToObject(ctx, maybe_prototype, exception);

  JSObjectSetPrototype(ctx, obj, prototype);
  return obj;
}

// static
JSObjectRef JSCWasmGlobal::CallAsConstructor(JSContextRef ctx,
                                             JSObjectRef constructor,
                                             size_t argc,
                                             const JSValueRef argv[],
                                             JSValueRef* exception) {
  WLOGD("Running JSCWasmGlobal::%s...", __func__);
  constexpr const char* code = "WebAssembly.Global()";

  if (argc == 0 || !JSValueIsObject(ctx, argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kDescriptorNeeded_1001, exception);
  }

  JSObjectRef descriptor = JSValueToObject(ctx, argv[0], exception);

  JSValueRef mutableValue =
      JSObjectGetProperty(ctx, descriptor, JSString("mutable"), exception);
  bool mutability = JSValueToBoolean(ctx, mutableValue);

  JSValueRef value =
      JSObjectGetProperty(ctx, descriptor, JSString("value"), exception);
  JSStringRef value_string = JSValueToStringCopy(ctx, value, exception);

  size_t type_name_length = JSStringGetMaximumUTF8CStringSize(value_string);
  char type_name[type_name_length];
  type_name_length =
      JSStringGetUTF8CString(value_string, type_name, type_name_length);

  JSValueRef argument = argc == 2 ? argv[1] : JSValueMakeUndefined(ctx);

  double number = JSValueToNumber(ctx, argument, exception);

  ValueType type = StrToType(type_name);

  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(constructor));
  WasmGlobalRef global = interop->CreateWasmGlobal(type, mutability, number);

  return CreateJSObject(ctx, constructor, global, exception);
}

// static
JSObjectRef JSCWasmGlobal::CreateConstructor(JSContextRef ctx,
                                             InteropRuntime* interop,
                                             JSValueRef* exception) {
  JSObjectRef ctor = JSObjectMake(ctx, constructor_class_ref(), interop);

  JSObjectRef prototype = CreatePrototype(ctx, exception);
  InitConstructor(ctx, ctor, "Global", prototype, exception);

  auto js_env = interop->js_env<JSCEnv*>();
  js_env->SetGlobalConstructor(ctor);

  return ctor;
}

// static
JSValueRef JSCWasmGlobal::GetValueCallback(JSContextRef ctx,
                                           JSObjectRef function,
                                           JSObjectRef thisObject, size_t argc,
                                           const JSValueRef argv[],
                                           JSValueRef* exception) {
  WLOGD("Calling JSCWasmGlobal::%s...", __func__);

  auto global = static_cast<JSCWasmGlobal*>(JSObjectGetPrivate(thisObject));
  if (!global) return JSValueMakeUndefined(ctx);
  auto interop_runtime = global->interop_runtime_;
  auto js_env = interop_runtime->js_env<JSCEnv*>();
  JSValueRef value = js_env->MakeUndefined();

  WasmGlobalRef wasm_global = global->global_;
  if (wasm_global.is<Wasm3Global*>()) {
    auto wasm3_global = wasm_global.get<Wasm3Global*>();
    M3TaggedValue tagged_value;
    wasm3_global->GetValue(&tagged_value);
    wasm3_global->runtime()->ToJSValue(js_env, &value, &tagged_value);
  } else {
    auto prism_global = wasm_global.get<PrismGlobal*>();
    wasm_val_t wasm_value;
    prism_global->GetValue(&wasm_value);
    prism_global->runtime()->ToJSValue(js_env, &value, &wasm_value);
  }

  return value;
}

// static
JSValueRef JSCWasmGlobal::SetValueCallback(JSContextRef ctx,
                                           JSObjectRef function,
                                           JSObjectRef thisObject, size_t argc,
                                           const JSValueRef argv[],
                                           JSValueRef* exception) {
  WLOGD("Running JSCWasmGlobal::%s...", __func__);
  constexpr const char* code = "set WebAssembly.Global.value";

  if (JSValueIsNull(ctx, argv[0]) || JSValueIsUndefined(ctx, argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kInvalidArgs_1001, exception);
  }

  JSValueRef val = argv[0];

  auto global = static_cast<JSCWasmGlobal*>(JSObjectGetPrivate(thisObject));
  if (!global) {
    return ThrowIfException(ctx, ErrorTypes::kError, code,
                            ErrorMessages::kInvalidArgs_1002, exception);
  }
  auto interop_runtime = global->interop_runtime_;
  auto js_env = interop_runtime->js_env<JSCEnv*>();

  constexpr const char* err_msg = "Can't set the value of an immutable global";

  ValueType type = ValueType::kTypeNone;
  if (global->global_.is<Wasm3Global*>()) {
    auto wasm3_global = global->global_.get<Wasm3Global*>();
    if (!wasm3_global->mutability()) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg,
                              exception);
    }
    type = wasm3_global->GetType();
    if (type == ValueType::kTypeV128) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "Set global v128 value not supported!",
                              exception);
    }

    double value;
    if (JSValueRef err = JsToValue(ctx, &value, val, type)) {
      return err;
    }

    if (wasm3_global->SetValue(value)) {
      return ThrowIfException(ctx, ErrorTypes::kError, code,
                              "Global set failed.", exception);
    }
  } else {
    auto prism_global = global->global_.get<PrismGlobal*>();
    if (!prism_global->mutability()) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg,
                              exception);
    }
    type = prism_global->GetType();
    if (type == ValueType::kTypeV128) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "Set global v128 value not supported!",
                              exception);
    }

    double value;
    if (JSValueRef err = JsToValue(ctx, &value, val, type)) {
      return err;
    }

    if (prism_global->set_value(value)) {
      return ThrowIfException(ctx, ErrorTypes::kError, code,
                              "Global set failed.", exception);
    }
  }

  return js_env->MakeUndefined();
}

// static
JSValueRef JSCWasmGlobal::ValueOfCallback(JSContextRef ctx,
                                          JSObjectRef function,
                                          JSObjectRef thisObject, size_t argc,
                                          const JSValueRef argv[],
                                          JSValueRef* exception) {
  return GetValueCallback(ctx, function, thisObject, argc, argv, exception);
}

// static
JSValueRef JSCWasmGlobal::JsToValue(JSContextRef ctx, double* val,
                                    JSValueRef js_val, ValueType type) {
  constexpr const char* code = "JsToValue";

  if (type == ValueType::kTypeI32) {
    int32_t num;
    if (!JSValueIsNumber(ctx, js_val)) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "Invalid value type converted to i32", nullptr);
    }
    num = static_cast<int32_t>(JSValueToNumber(ctx, js_val, nullptr));
    *val = static_cast<double>(num);
  } else if (type == ValueType::kTypeI64) {
    int64_t num;
    if (JSValueIsUndefined(ctx, js_val) || JSValueIsNull(ctx, js_val)) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "Undefined or Null value cannot convert to i64",
                              nullptr);
    }
    if (!JSValueIsNumber(ctx, js_val)) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "Invalid value type converted to i64", nullptr);
    }
    num = static_cast<int64_t>(JSValueToNumber(ctx, js_val, nullptr));
    *val = static_cast<double>(num);
  } else if (type == ValueType::kTypeF32 || type == ValueType::kTypeF64) {
    if (!JSValueIsNumber(ctx, js_val)) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "Invalid value type converted to f32/f64",
                              nullptr);
    }
    *val = JSValueToNumber(ctx, js_val, nullptr);
  }

  return nullptr;
}

}  // namespace primjs::jsc
