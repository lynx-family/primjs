// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm_module.h"

#include <JavaScriptCore/JavaScriptCore.h>

#include "basic/modp_b64/modp_b64.h"
#include "common/interop_runtime.h"
#include "common/messages.h"
#include "common/wasm_type.h"
#include "common/wasm_utils.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"
#include "jsc/jsc_wasm_memory.h"

namespace primjs::jsc {

// static
JSClassRef JSCWasmModule::class_ref() {
  static JSClassRef class_ref = JSCWasmModule::InitClassRef();
  return class_ref;
}
JSClassRef JSCWasmModule::constructor_class_ref() {
  static JSClassRef constructor_class_ref = JSCWasmModule::InitCtorClassRef();
  return constructor_class_ref;
}

JSClassRef JSCWasmModule::prototype_class_ref() {
  static JSClassRef prototype_class_ref = JSCWasmModule::InitProtoClassRef();
  return prototype_class_ref;
}

JSClassRef JSCWasmModule::InitClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Module", Finalize);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmModule::InitProtoClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Module.Prototype", NULL);

  return JSClassCreate(&def);
}

JSClassRef JSCWasmModule::InitCtorClassRef() {
  JSClassDefinition def = JSClassCreator::GetClassDefinition(
      "WebAssembly.Module", NULL, CallAsConstructor);

  JSPropertyAttributes default_attr = JSClassCreator::DefaultAttr();
  JSStaticFunction static_funcs[] = {
      {"exports", ExportsCallback, default_attr},
      {"imports", ImportsCallback, default_attr},
      // FIXME(wasm): implement this function.
      //  {"customSection", nullptr, default_attr},
      {0, 0, 0}};
  JSStaticValue static_values[] = {
      {"supportBase64", SupportBase64, nullptr, kJSPropertyAttributeNone},
      {nullptr, nullptr, nullptr, 0}};
  def.staticFunctions = static_funcs;
  def.staticValues = static_values;

  return JSClassCreate(&def);
}

void JSCWasmModule::ReleaseClassRef() {
  JSClassRelease(class_ref());
  JSClassRelease(prototype_class_ref());
  JSClassRelease(constructor_class_ref());
}

JSCWasmModule::JSCWasmModule(WasmModuleRef module, InteropRuntime* interop)
    : module_(std::move(module)) {
  interop_runtime_ = interop;
  InteropRuntime::IncreaseRefCount(interop_runtime_);
}

JSCWasmModule::~JSCWasmModule() {
  WLOGD("Running JSCWasmModule::%s...", __func__);
  if (module_.is<Wasm3Module*>()) {
    delete module_.get<Wasm3Module*>();
  } else {
    delete module_.get<PrismModule*>();
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

bool JSCWasmModule::IsWasmModuleObject(JSContextRef ctx,
                                       JSObjectRef constructor,
                                       JSObjectRef target,
                                       JSValueRef* exception) {
  return HasInstance(ctx, constructor, target, exception);
}

JSObjectRef JSCWasmModule::CreateJSObject(JSContextRef ctx,
                                          JSObjectRef constructor,
                                          WasmModuleRef module,
                                          JSValueRef* exception) {
  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(constructor));
  WASM_DCHECK(interop != nullptr);
  JSCWasmModule* module_data = new JSCWasmModule(module, interop);

  JSObjectRef obj = JSObjectMake(ctx, class_ref(), module_data);

  JSValueRef prototype = JSObjectGetProperty(
      ctx, constructor, JSCBuiltinObjects::PrototypeStr(), exception);
  prototype = JSValueToObject(ctx, prototype, exception);
  JSObjectSetPrototype(ctx, obj, prototype);

  return obj;
}

void JSCWasmModule::Finalize(JSObjectRef object) {
  WLOGD("Running JSCWasmModule::%s...", __func__);
  auto module = static_cast<JSCWasmModule*>(JSObjectGetPrivate(object));
  delete module;
}

JSObjectRef JSCWasmModule::CreatePrototype(JSContextRef ctx,
                                           JSValueRef* exception) {
  // FIXME(): add the private data to be attached to constructor;
  JSObjectRef prototype = JSObjectMake(ctx, prototype_class_ref(), NULL);

  return prototype;
}

// static
JSObjectRef JSCWasmModule::CreateConstructor(JSContextRef ctx,
                                             InteropRuntime* interop,
                                             JSValueRef* exception) {
  WASM_DCHECK(interop != nullptr);
  // Do not own interop here, do not destroy it.
  JSObjectRef ctor = JSObjectMake(ctx, constructor_class_ref(), interop);

  JSObjectRef prototype = CreatePrototype(ctx, exception);
  InitConstructor(ctx, ctor, "Module", prototype, exception);

  auto js_env = interop->js_env<JSCEnv*>();
  js_env->SetModuleConstructor(ctor);

  return ctor;
}

JSObjectRef JSCWasmModule::CallAsConstructor(JSContextRef ctx,
                                             JSObjectRef constructor,
                                             size_t argc,
                                             const JSValueRef argv[],
                                             JSValueRef* exception) {
  WLOGD("Running JSCWasmModule::%s...", __func__);
  constexpr const char* code = "WebAssembly.Module()";

  if (argc == 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kArrayBufferNeeded_1001, exception);
  }
  bool useBase64 = false;
  if (argc > 1) {
    JSObjectRef encode = JSValueToObject(ctx, argv[1], exception);
    if (exception && *exception) {
      return nullptr;
    }

    auto encodeVal =
        JSObjectGetProperty(ctx, encode, JSString("encode"), exception);
    auto encodeStr = JSValueToStringCopy(ctx, encodeVal, exception);
    size_t length = JSStringGetMaximumUTF8CStringSize(encodeStr);
    char encodeName[length];
    length = JSStringGetUTF8CString(encodeStr, encodeName, length);
    if (strcmp(encodeName, "base64") == 0) {
      useBase64 = true;
    }
    JSStringRelease(encodeStr);
  }

  size_t byteLength = 0;
  uint8_t* data = nullptr;
  JSType arg0Type = JSValueGetType(ctx, argv[0]);
  if (arg0Type == kJSTypeString) {
    if (useBase64) {
      JSStringRef base64Str = JSValueToStringCopy(ctx, argv[0], NULL);
      byteLength = JSStringGetLength(base64Str);
      // JSStringGetUTF8CString will add '\0' at the end of str
      data = (uint8_t*)std::malloc(byteLength + 1);
      JSStringGetUTF8CString(base64Str, (char*)data, byteLength + 1);
      JSStringRelease(base64Str);
    } else {
      return ThrowIfException(
          ctx, ErrorTypes::kTypeError, code,
          "First argument must be a ArrayBuffer when not using base64 encode",
          exception);
    }
  } else {
    data = GetWireBytes(ctx, argv[0], &byteLength, exception);
  }
  if (exception && *exception) return nullptr;
  if (data == nullptr) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kArrayBufferNeeded_1002, exception);
  }
  if (useBase64) {
    size_t decode_len = modp_b64_decode_len(byteLength);
    uint8_t* wasm_data = (uint8_t*)std::malloc(decode_len);
    byteLength =
        modp_b64_decode((char*)wasm_data, (const char*)data, byteLength);
    if (arg0Type == kJSTypeString) {
      std::free(data);
    }
    data = wasm_data;
  }

  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(constructor));
  WasmResult result = WasmSucceed;
  WasmModuleRef module = interop->CreateWasmModule(data, byteLength, result);
  if (useBase64) {
    std::free(data);
  }
  if (result != WasmSucceed) {
    return ThrowIfException(ctx, ErrorTypes::kError, code, result, exception);
  }

  return CreateJSObject(ctx, constructor, module, exception);
}

uint8_t* JSCWasmModule::GetWireBytes(JSContextRef ctx, JSValueRef val,
                                     size_t* byteLength,
                                     JSValueRef* exception) {
  JSTypedArrayType type{JSValueGetTypedArrayType(ctx, val, exception)};
  if (type == kJSTypedArrayTypeNone) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, "",
                     ErrorMessages::kArrayBufferNeeded_1003, exception);
    return nullptr;
  }

  JSObjectRef buffer = JSValueToObject(ctx, val, exception);
  if (type != kJSTypedArrayTypeArrayBuffer) {
    *byteLength = JSObjectGetTypedArrayByteLength(ctx, buffer, exception);
    size_t byte_offset{JSObjectGetTypedArrayByteOffset(ctx, buffer, exception)};
    uint8_t* data = static_cast<uint8_t*>(
                        JSObjectGetTypedArrayBytesPtr(ctx, buffer, exception)) +
                    byte_offset;
    return data;
  }
  *byteLength = JSObjectGetArrayBufferByteLength(ctx, buffer, exception);
  return static_cast<uint8_t*>(
      JSObjectGetArrayBufferBytesPtr(ctx, buffer, exception));
}

JSValueRef JSCWasmModule::ExportsCallback(JSContextRef ctx,
                                          JSObjectRef function,
                                          JSObjectRef thisObject, size_t argc,
                                          const JSValueRef argv[],
                                          JSValueRef* exception) {
  WLOGD("Running JSCWasmModule::%s...", __func__);
  constexpr const char* code = "WebAssembly.Module.exports";

  if (argc == 0 && !JSValueIsObject(ctx, argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kModuleNeeded_1004, exception);
  }
  JSObjectRef module_obj = JSValueToObject(ctx, argv[0], nullptr);
  JSObjectRef exports = JSObjectMakeArray(ctx, 0, NULL, nullptr);

  auto js_mod = static_cast<JSCWasmModule*>(JSObjectGetPrivate(module_obj));
  WASM_DCHECK(js_mod != nullptr);
  auto interop_runtime = js_mod->interop_runtime_;
  WASM_DCHECK(interop_runtime != nullptr);
  auto js_env = interop_runtime->js_env<JSCEnv*>();

  WasmModuleRef wasm_module = js_mod->module_;
  if (wasm_module.is<Wasm3Module*>()) {
    auto wasm3_module = wasm_module.get<Wasm3Module*>();
    wasm3_module->exports(js_env, exports, nullptr);
  } else {
    auto prism_module = wasm_module.get<PrismModule*>();
    prism_module->exports(js_env, exports, nullptr);
  }

  return exports;
}

JSValueRef JSCWasmModule::ImportsCallback(JSContextRef ctx,
                                          JSObjectRef function,
                                          JSObjectRef thisObject, size_t argc,
                                          const JSValueRef argv[],
                                          JSValueRef* exception) {
  WLOGD("Running JSCWasmModule::%s...", __func__);
  constexpr const char* code = "WebAssembly.Module.imports()";

  if (argc == 0 && !JSValueIsObject(ctx, argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kModuleNeeded_1005, exception);
  }
  JSObjectRef module_obj = JSValueToObject(ctx, argv[0], nullptr);
  JSObjectRef imports = JSObjectMakeArray(ctx, 0, NULL, nullptr);

  auto js_mod = static_cast<JSCWasmModule*>(JSObjectGetPrivate(module_obj));
  WASM_DCHECK(js_mod != nullptr);
  auto interop_runtime = js_mod->interop_runtime_;
  auto js_env = interop_runtime->js_env<JSCEnv*>();

  if (js_mod->module_.is<Wasm3Module*>()) {
    auto wasm3_module = js_mod->module_.get<Wasm3Module*>();
    wasm3_module->imports(js_env, imports, exception);
  } else {
    auto prism_module = js_mod->module_.get<PrismModule*>();
    prism_module->imports(js_env, imports, exception);
  }

  if (exception && *exception) {
    return js_env->MakeUndefined();
  }

  return imports;
}

JSValueRef JSCWasmModule::SupportBase64(JSContextRef ctx, JSObjectRef object,
                                        JSStringRef propertyName,
                                        JSValueRef* exception) {
  return JSValueMakeBoolean(ctx, true);
}

}  // namespace primjs::jsc
