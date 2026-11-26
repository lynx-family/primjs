// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm_module.h"

#include <cstdlib>
#include <cstring>
#include <string>

#include "common/messages.h"
#include "common/wasm_utils.h"
#include "jsc/js_env_jsc.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"

namespace primjs::jsc {

JSClassRef JSCWasmModule::class_ref() {
  static JSClassRef ref = InitClassRef();
  return ref;
}

JSClassRef JSCWasmModule::constructor_class_ref() {
  static JSClassRef ref = InitCtorClassRef();
  return ref;
}

JSClassRef JSCWasmModule::prototype_class_ref() {
  static JSClassRef ref = InitProtoClassRef();
  return ref;
}

JSClassRef JSCWasmModule::InitClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Module", Finalize);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmModule::InitProtoClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Module.Prototype", nullptr);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmModule::InitCtorClassRef() {
  JSClassDefinition def = JSClassCreator::GetClassDefinition(
      "WebAssembly.Module", nullptr, CallAsConstructor);

  const JSPropertyAttributes default_attr = JSClassCreator::DefaultAttr();
  static const JSStaticValue static_values[] = {
      {"supportBase64", SupportBase64, nullptr, default_attr},
      {nullptr, nullptr, nullptr, 0}};

  def.staticValues = static_values;
  return JSClassCreate(&def);
}

void JSCWasmModule::ReleaseClassRef() {
  JSClassRelease(class_ref());
  JSClassRelease(constructor_class_ref());
  JSClassRelease(prototype_class_ref());
}

JSCWasmModule::JSCWasmModule(JSCEnv* env, wasm_module_t* module)
    : store_owner_(env->store_owner()), module_(module) {
  wasm::WasmStoreOwner::Retain(store_owner_);
  store_owner_->LinkHandle(&tracked_, this, DetachOnExit);
}

JSCWasmModule::~JSCWasmModule() {
  if (store_owner_) {
    store_owner_->UnlinkHandle(&tracked_);
  }
  DetachWasmModule();
}

void JSCWasmModule::DetachWasmModule() {
  if (imports_loaded_) {
    wasm_importtype_vec_delete(&import_types_);
    imports_loaded_ = false;
  }
  if (module_) {
    wasm_module_delete(module_);
    module_ = nullptr;
  }
  wasm::WasmStoreOwner::Release(store_owner_);
}

void JSCWasmModule::DetachOnExit(wasm::WasmTrackedHandle* handle,
                                 void* exit_ctx) {
  (void)exit_ctx;
  auto* self = static_cast<JSCWasmModule*>(handle->owner_object);
  self->DetachWasmModule();
}

const wasm_importtype_vec_t* JSCWasmModule::ImportTypes() {
  if (!imports_loaded_) {
    wasm_module_imports(module_, &import_types_);
    imports_loaded_ = true;
  }
  return &import_types_;
}

bool JSCWasmModule::IsWasmModuleObject(JSContextRef ctx, JSValueRef target) {
  if (!target || !JSValueIsObjectOfClass(ctx, target, class_ref())) {
    return false;
  }
  auto* mod = static_cast<JSCWasmModule*>(
      JSObjectGetPrivate(JSValueToObject(ctx, target, nullptr)));
  return mod != nullptr && mod->module_ != nullptr;
}

void JSCWasmModule::Finalize(JSObjectRef object) {
  auto* mod = static_cast<JSCWasmModule*>(JSObjectGetPrivate(object));
  delete mod;
}

JSObjectRef JSCWasmModule::CreatePrototype(JSContextRef ctx,
                                           JSValueRef* exception) {
  (void)exception;
  return JSObjectMake(ctx, prototype_class_ref(), nullptr);
}

JSObjectRef JSCWasmModule::CreateConstructor(JSContextRef ctx, JSCEnv* env,
                                             JSValueRef* exception) {
  JSObjectRef ctor = JSObjectMake(ctx, constructor_class_ref(), env);
  JSObjectRef prototype = CreatePrototype(ctx, exception);
  InitConstructor(ctx, ctor, "Module", prototype, exception);
  env->SetModuleConstructor(ctor);
  return ctor;
}

JSObjectRef JSCWasmModule::CreateJSObject(JSContextRef ctx,
                                          JSObjectRef constructor, JSCEnv* env,
                                          wasm_module_t* module,
                                          JSValueRef* exception) {
  JSValueRef proto_val = JSObjectGetProperty(
      ctx, constructor, JSCBuiltinObjects::PrototypeStr(), exception);
  if (exception && *exception) {
    wasm_module_delete(module);
    return nullptr;
  }
  JSObjectRef prototype = JSValueToObject(ctx, proto_val, exception);
  if ((exception && *exception) || !prototype) {
    wasm_module_delete(module);
    return nullptr;
  }

  JSObjectRef obj = JSObjectMake(ctx, class_ref(), nullptr);
  if (!RetainWasmRootOnJSCObject(ctx, obj, env->wasm_root(), exception)) {
    wasm_module_delete(module);
    return nullptr;
  }
  JSObjectSetPrototype(ctx, obj, prototype);
  auto* module_data = new JSCWasmModule(env, module);
  WASM_CHECK(JSObjectSetPrivate(obj, module_data));
  return obj;
}

JSObjectRef JSCWasmModule::CallAsConstructor(JSContextRef ctx,
                                             JSObjectRef constructor,
                                             size_t argc,
                                             const JSValueRef argv[],
                                             JSValueRef* exception) {
  constexpr const char* code = "WebAssembly.Module()";

  auto* env = static_cast<JSCEnv*>(JSObjectGetPrivate(constructor));
  if (!env || !env->wasm_store()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "WebAssembly context is not active", exception);
  }

  if (argc == 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kArrayBufferNeeded_1001, exception);
  }

  bool use_base64 = false;
  if (argc > 1 && !JSValueIsUndefined(ctx, argv[1])) {
    JSObjectRef encode_obj = JSValueToObject(ctx, argv[1], exception);
    if ((exception && *exception) || !encode_obj) return nullptr;

    JSValueRef encode_val =
        JSObjectGetProperty(ctx, encode_obj, JSString("encode"), exception);
    if (exception && *exception) return nullptr;
    if (!JSValueIsUndefined(ctx, encode_val)) {
      JSStringRef encode_str = JSValueToStringCopy(ctx, encode_val, exception);
      if ((exception && *exception) || encode_str == nullptr) return nullptr;
      use_base64 = JSStringIsEqualToUTF8CString(encode_str, "base64");
      JSStringRelease(encode_str);
    }
  }

  size_t byte_length = 0;
  uint8_t* data = nullptr;
  uint8_t* owned_str_data = nullptr;
  const JSType arg0_type = JSValueGetType(ctx, argv[0]);
  if (arg0_type == kJSTypeString) {
    if (!use_base64) {
      return ThrowIfException(
          ctx, ErrorTypes::kTypeError, code,
          "First argument must be an ArrayBuffer when not using base64 encode",
          exception);
    }
    JSStringRef b64_str = JSValueToStringCopy(ctx, argv[0], exception);
    if ((exception && *exception) || !b64_str) return nullptr;
    const size_t max_utf8 = JSStringGetMaximumUTF8CStringSize(b64_str);
    owned_str_data =
        static_cast<uint8_t*>(std::malloc(max_utf8 ? max_utf8 : 1));
    if (!owned_str_data) {
      JSStringRelease(b64_str);
      return ThrowIfException(ctx, ErrorTypes::kError, code,
                              ErrorMessages::kMemoryAllocFailed_1001,
                              exception);
    }
    const size_t written = JSStringGetUTF8CString(
        b64_str, reinterpret_cast<char*>(owned_str_data), max_utf8);
    JSStringRelease(b64_str);
    byte_length = written > 0 ? written - 1 : 0;
    data = owned_str_data;
  } else {
    data = GetWireBytes(ctx, argv[0], &byte_length, exception);
  }
  if (exception && *exception) {
    std::free(owned_str_data);
    return nullptr;
  }
  if (data == nullptr) {
    std::free(owned_str_data);
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kArrayBufferNeeded_1002, exception);
  }

  uint8_t* owned_decoded = nullptr;
  if (use_base64) {
    size_t decoded = 0;
    const bool ok =
        wasm::DecodeBase64(data, byte_length, &owned_decoded, &decoded);
    std::free(owned_str_data);
    owned_str_data = nullptr;
    if (!ok) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              ErrorMessages::kArrayBufferNeeded_1003,
                              exception);
    }
    data = owned_decoded;
    byte_length = decoded;
  }

  wasm_byte_vec_t binary = {byte_length, reinterpret_cast<char*>(data)};
  wasm_module_t* module = wasm_module_new(env->wasm_store(), &binary);
  std::free(owned_str_data);
  std::free(owned_decoded);

  if (wasm_unlikely(!module)) {
    return ThrowIfException(ctx, ErrorTypes::kError, code,
                            "create prism module failed", exception);
  }
  return CreateJSObject(ctx, constructor, env, module, exception);
}

uint8_t* JSCWasmModule::GetWireBytes(JSContextRef ctx, JSValueRef val,
                                     size_t* byteLength,
                                     JSValueRef* exception) {
  JSTypedArrayType type = JSValueGetTypedArrayType(ctx, val, exception);
  if (exception && *exception) return nullptr;
  if (type == kJSTypedArrayTypeNone) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, "",
                     ErrorMessages::kArrayBufferNeeded_1003, exception);
    return nullptr;
  }

  JSObjectRef buffer = JSValueToObject(ctx, val, exception);
  if ((exception && *exception) || !buffer) return nullptr;
  if (type != kJSTypedArrayTypeArrayBuffer) {
    *byteLength = JSObjectGetTypedArrayByteLength(ctx, buffer, exception);
    if (exception && *exception) return nullptr;
    const size_t byte_offset =
        JSObjectGetTypedArrayByteOffset(ctx, buffer, exception);
    if (exception && *exception) return nullptr;
    auto* base = static_cast<uint8_t*>(
        JSObjectGetTypedArrayBytesPtr(ctx, buffer, exception));
    if (exception && *exception) return nullptr;
    static uint8_t kEmptyByte = 0;
    return base ? (base + byte_offset) : &kEmptyByte;
  }
  *byteLength = JSObjectGetArrayBufferByteLength(ctx, buffer, exception);
  if (exception && *exception) return nullptr;
  auto* base = static_cast<uint8_t*>(
      JSObjectGetArrayBufferBytesPtr(ctx, buffer, exception));
  if (exception && *exception) return nullptr;
  static uint8_t kEmptyByte = 0;
  return base ? base : &kEmptyByte;
}

JSValueRef JSCWasmModule::SupportBase64(JSContextRef ctx, JSObjectRef object,
                                        JSStringRef propertyName,
                                        JSValueRef* exception) {
  (void)object;
  (void)propertyName;
  (void)exception;
  return JSValueMakeBoolean(ctx, true);
}

}  // namespace primjs::jsc
