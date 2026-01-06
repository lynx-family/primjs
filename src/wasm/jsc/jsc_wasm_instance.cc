// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm_instance.h"

#include <JavaScriptCore/JavaScriptCore.h>

#include <memory>

#include "common/interop_runtime.h"
#include "common/messages.h"
#include "common/wasm_utils.h"
#include "jsc/js_env_jsc.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"
#include "jsc/jsc_wasm_memory.h"
#include "jsc/jsc_wasm_module.h"

namespace primjs::jsc {

JSClassRef JSCWasmInstance::class_ref() {
  static JSClassRef class_ref = JSCWasmInstance::InitClassRef();
  return class_ref;
}
JSClassRef JSCWasmInstance::prototype_class_ref() {
  static JSClassRef prototype_class_ref = JSCWasmInstance::InitProtoClassRef();
  return prototype_class_ref;
}

JSClassRef JSCWasmInstance::constructor_class_ref() {
  static JSClassRef constructor_class_ref = JSCWasmInstance::InitCtorClassRef();
  return constructor_class_ref;
}

JSClassRef JSCWasmInstance::InitClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Instance", Finalize);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmInstance::InitProtoClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Instance.Prototype", NULL);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmInstance::InitCtorClassRef() {
  JSClassDefinition def = JSClassCreator::GetClassDefinition(
      "WebAssembly.Instance", NULL, CallAsConstructor);
  return JSClassCreate(&def);
}

void JSCWasmInstance::ReleaseClassRef() {
  JSClassRelease(class_ref());
  JSClassRelease(prototype_class_ref());
  JSClassRelease(constructor_class_ref());
}

JSCWasmInstance::JSCWasmInstance(WasmInstanceRef instance,
                                 InteropRuntime* interop)
    : instance_(std::move(instance)) {
  interop_runtime_ = interop;
  InteropRuntime::IncreaseRefCount(interop_runtime_);
  if (instance_.is<Wasm3Instance*>()) {
    Wasm3Instance* wasm3_instance = instance_.get<Wasm3Instance*>();
    Wasm3Instance::IncreaseRefCount(wasm3_instance);
  } else {
    PrismInstance* prism_instance = instance_.get<PrismInstance*>();
    PrismInstance::IncreaseRefCount(prism_instance);
  }
}

JSCWasmInstance::~JSCWasmInstance() {
  WLOGD("Running JSCWasmInstance::%s...", __func__);
  if (instance_.is<Wasm3Instance*>()) {
    Wasm3Instance* wasm3_instance = instance_.get<Wasm3Instance*>();
    Wasm3Instance::DecreaseRefCount(wasm3_instance);
  } else {
    PrismInstance* prism_instance = instance_.get<PrismInstance*>();
    PrismInstance::DecreaseRefCount(prism_instance);
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

JSObjectRef JSCWasmInstance::CreateJSObject(JSContextRef ctx,
                                            JSObjectRef constructor,
                                            WasmInstanceRef instance,
                                            JSValueRef* exception) {
  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(constructor));
  WASM_DCHECK(interop != nullptr);
  auto inst_data = new JSCWasmInstance(instance, interop);

  JSObjectRef obj = JSObjectMake(ctx, class_ref(), inst_data);

  JSValueRef prototype = JSObjectGetProperty(
      ctx, constructor, JSCBuiltinObjects::PrototypeStr(), exception);
  prototype = JSValueToObject(ctx, prototype, exception);
  JSObjectSetPrototype(ctx, obj, prototype);
  return obj;
}

void JSCWasmInstance::Finalize(JSObjectRef object) {
  WLOGD("Running JSCWasmInstance::%s...", __func__);
  auto instance = static_cast<JSCWasmInstance*>(JSObjectGetPrivate(object));
  delete instance;
}

JSObjectRef JSCWasmInstance::CreatePrototype(JSContextRef ctx,
                                             JSValueRef* exception) {
  // FIXME(): add the private data to be attached to constructor;
  JSObjectRef prototype = JSObjectMake(ctx, prototype_class_ref(), NULL);

  return prototype;
}

JSObjectRef JSCWasmInstance::CreateConstructor(JSContextRef ctx,
                                               InteropRuntime* interop,
                                               JSValueRef* exception) {
  // set the private data with wctx object(PrismRuntime*)
  JSObjectRef ctor = JSObjectMake(ctx, constructor_class_ref(), interop);

  JSObjectRef prototype = CreatePrototype(ctx, exception);
  InitConstructor(ctx, ctor, "Instance", prototype, exception);

  auto js_env = interop->js_env<JSCEnv*>();
  js_env->SetInstanceConstructor(ctor);

  return ctor;
}

JSObjectRef JSCWasmInstance::CallAsConstructor(JSContextRef ctx,
                                               JSObjectRef constructor,
                                               size_t argc,
                                               const JSValueRef argv[],
                                               JSValueRef* exception) {
  WLOGD("Running JSCWasmInstance::%s...", __func__);
  constexpr const char* code = "WebAssembly.Instance()";

  if (argc == 0 || !JSValueIsObject(ctx, argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kModuleNeeded_1001, exception);
  }

  JSObjectRef module_obj = JSValueToObject(ctx, argv[0], exception);
  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(constructor));
  if (!interop) {
    return ThrowIfException(ctx, ErrorTypes::kError, code,
                            ErrorMessages::kModuleNeeded_1002, exception);
  }

  auto js_env = interop->js_env<JSCEnv*>();

  JSObjectRef module_ctor = js_env->js_module_constructor();
  if (!JSCWasmModule::IsWasmModuleObject(ctx, module_ctor, module_obj,
                                         exception)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kModuleNeeded_1003, exception);
  }

  JSObjectRef import_obj{};
  if (argc > 1 && JSValueIsObject(ctx, argv[1])) {
    import_obj = JSValueToObject(ctx, argv[1], exception);
  }

  auto module = static_cast<JSCWasmModule*>(JSObjectGetPrivate(module_obj));
  WasmModuleRef wasm_module = module->module();
  WasmResult result = WasmSucceed;
  WasmInstanceRef instance =
      interop->CreateWasmInstance<JSCEnv>(wasm_module, import_obj, result);
  if (result) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code, result,
                            exception);
  }

  JSObjectRef instance_obj =
      CreateJSObject(ctx, constructor, instance, exception);
  JSObjectRef exports_obj = JSObjectMake(ctx, nullptr, nullptr);

  if (interop->CreateJSExports<JSCEnv>(exports_obj, wasm_module, instance)) {
    return ThrowIfException(ctx, ErrorTypes::kError, code,
                            ErrorMessages::kInstantiationFailed_1001,
                            exception);
  }

  JSObjectSetProperty(ctx, instance_obj, JSString("exports"), exports_obj,
                      JSClassCreator::DefaultAttr(), exception);

  return instance_obj;
}

}  // namespace primjs::jsc
