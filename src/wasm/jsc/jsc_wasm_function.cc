// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm_function.h"

#include <JavaScriptCore/JavaScriptCore.h>

#include <cstddef>

#include "common/interop_runtime.h"
#include "common/js_type.h"
#include "common/wasm_utils.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"

namespace primjs::jsc {
// static
JSClassRef JSCWasmFunction::class_id_ = nullptr;

JSCWasmFunction::JSCWasmFunction(WasmFunctionRef function,
                                 InteropRuntime* interop)
    : function_(std::move(function)) {
  interop_runtime_ = interop;
  InteropRuntime::IncreaseRefCount(interop_runtime_);
}

JSCWasmFunction::~JSCWasmFunction() {
  if (function_.is<Wasm3Function*>()) {
    delete function_.get<Wasm3Function*>();
  } else {
    delete function_.get<PrismFunction*>();
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

// static
void JSCWasmFunction::Finalize(JSObjectRef object) {
  WLOGD("Running JSCWasmFunction::%s...", __func__);
  auto function = static_cast<JSCWasmFunction*>(JSObjectGetPrivate(object));
  delete function;
}

// static
JSObjectRef JSCWasmFunction::CreatePrototype(JSContextRef ctx,
                                             JSValueRef* exception) {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Function", Finalize);
  def.callAsFunction = CallWasmFunction;
  JSClassRef obj_jsclass = JSClassCreate(&def);
  class_id_ = obj_jsclass;

  return JSObjectMake(ctx, nullptr, nullptr);
}

// static
JSObjectRef JSCWasmFunction::CreateJSObject(JSContextRef ctx,
                                            JSObjectRef constructor,
                                            WasmFunctionRef function,
                                            JSValueRef* exception) {
  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(constructor));
  WASM_DCHECK(interop != nullptr);
  auto func_opaque = new JSCWasmFunction(function, interop);

  WASM_DCHECK(class_id_ != nullptr);
  JSObjectRef obj = JSObjectMake(ctx, class_id_, func_opaque);

  JSObjectRef js_function = JSCBuiltinObjects::GetJSFunction(ctx, exception);
  if (!js_function || (exception && *exception)) return nullptr;
  JSValueRef may_func_prototype = JSObjectGetPrototype(ctx, js_function);
  JSObjectSetPrototype(ctx, obj, may_func_prototype);

  return obj;
}

JSValueRef JSCWasmFunction::CallWasmFunction(
    JSContextRef ctx, JSObjectRef function, JSObjectRef thisObject, size_t argc,
    const JSValueRef argv[], JSValueRef* exception) {
  auto func_opaque =
      static_cast<JSCWasmFunction*>(JSObjectGetPrivate(function));
  if (!func_opaque) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, "",
                            "Invalid wasm function to be called.", exception);
  }

  auto& wasm_func = func_opaque->function();
  auto interop_runtime = func_opaque->interop_runtime_;
  return interop_runtime->CallWasmFunction<JSCEnv>(wasm_func, argc, argv,
                                                   exception);
}

}  // namespace primjs::jsc
