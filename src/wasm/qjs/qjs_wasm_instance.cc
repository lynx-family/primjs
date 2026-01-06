// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm_instance.h"

#include "common/interop_runtime.h"
#include "common/messages.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/js_env_qjs.h"
#include "qjs/qjs_ext_api.h"
#include "qjs/qjs_wasm.h"
#include "qjs/qjs_wasm_module.h"
#include "runtime/wasm3/wasm_function.h"

namespace primjs::qjs {
QJSWasmInstance::QJSWasmInstance(WasmInstanceRef instance,
                                 InteropRuntime* interop)
    : instance_(std::move(instance)) {
  WLOGD("Running QJSWasmInstance::%s...", __func__);
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

QJSWasmInstance::~QJSWasmInstance() {
  WLOGD("Running QJSWasmInstance::%s...", __func__);
  if (instance_.is<Wasm3Instance*>()) {
    Wasm3Instance* wasm3_instance = instance_.get<Wasm3Instance*>();
    Wasm3Instance::DecreaseRefCount(wasm3_instance);
  } else {
    PrismInstance* prism_instance = instance_.get<PrismInstance*>();
    PrismInstance::DecreaseRefCount(prism_instance);
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

LEPUSValue QJSWasmInstance::CreateConstructor(LEPUSContext* ctx,
                                              LEPUSValue wasm_root) {
  LEPUSClassDef def = {.class_name = "WebAssembly.Instance",
                       .finalizer = Finalize};

  if (JSSafeNewClass(ctx, class_id(), &def) != 0) {
    WLOGE("New Class failed in WebAssembly.Instance.");
    return LEPUS_EXCEPTION;
  }

  LEPUSValue proto = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &proto, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetClassProto(ctx, class_id(), proto);

  constexpr const char* name = "Instance";
  LEPUSValue constructor =
      InitConstructor(ctx, wasm_root, name, CallAsConstructor, 2, proto);
  return constructor;
}

void QJSWasmInstance::Finalize(LEPUSRuntime* rt, LEPUSValue obj) {
  auto instance =
      static_cast<QJSWasmInstance*>(LEPUS_GetOpaque(obj, class_id()));
  delete instance;
  LEPUS_SetOpaque(obj, nullptr);
}

LEPUSValue QJSWasmInstance::CallAsConstructor(LEPUSContext* ctx,
                                              LEPUSValueConst new_target,
                                              int argc, LEPUSValueConst* argv) {
  WLOGD("Running QJSWasmInstance::%s...", __func__);

  constexpr const char* code = "new WebAssembly.Instance()";

  if (argc == 0 ||
      LEPUS_GetClassID(ctx, argv[0]) != QJSWasmModule::class_id()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kModuleNeeded_1006);
  }
  LEPUSValue import_obj = argv[1];

  auto module = static_cast<QJSWasmModule*>(
      LEPUS_GetOpaque(argv[0], QJSWasmModule::class_id()));
  auto interop =
      static_cast<InteropRuntime*>(JSGetPrivateData(ctx, new_target));
  WasmModuleRef wasm_module = module->module();
  WasmResult result = WasmSucceed;
  WasmInstanceRef instance =
      interop->CreateWasmInstance<QJSEnv>(wasm_module, import_obj, result);
  if (result) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code, result);
  }

  LEPUSValue instance_obj = LEPUS_NewObjectClass(ctx, class_id());
  HandleScope func_scope(ctx, &instance_obj, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue exported_obj = LEPUS_NewObject(ctx);
  func_scope.PushHandle(&exported_obj, HANDLE_TYPE_LEPUS_VALUE);
  if (!LEPUS_IsException(instance_obj) && !LEPUS_IsException(exported_obj)) {
    if (interop->CreateJSExports<QJSEnv>(exported_obj, wasm_module, instance)) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "wasm instance exporting failed.");
    } else {
      LEPUS_SetPropertyStr(ctx, instance_obj, "exports", exported_obj);
      auto opaque = new QJSWasmInstance(instance, interop);
      LEPUS_SetOpaque(instance_obj, opaque);
      return instance_obj;
    }
  }

  return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                          ErrorMessages::kInstantiationFailed_1002);
}

}  // namespace primjs::qjs
