// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm_function.h"

#include <utility>

#include "common/interop_runtime.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/qjs_ext_api.h"
#include "qjs/qjs_wasm.h"

namespace primjs::qjs {
QJSWasmFunction::QJSWasmFunction(WasmFunctionRef function,
                                 InteropRuntime* interop)
    : function_(std::move(function)) {
  WLOGD("Running QJSWasmFunction::%s...", __func__);
  interop_runtime_ = interop;
  InteropRuntime::IncreaseRefCount(interop_runtime_);
}

QJSWasmFunction::~QJSWasmFunction() {
  if (function_.is<Wasm3Function*>()) {
    delete function_.get<Wasm3Function*>();
  } else if (function_.is<PrismFunction*>()) {
    delete function_.get<PrismFunction*>();
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

LEPUSValue QJSWasmFunction::CreatePrototype(LEPUSContext* ctx) {
  LEPUSClassDef def = {.class_name = "WebAssembly.Function",
                       .finalizer = Finalize,
                       .call = CallWasmFunction};

  if (JSSafeNewClass(ctx, class_id(), &def) != 0) {
    WLOGE("New Class for WebAssembly.Function failed!");
    return LEPUS_EXCEPTION;
  }

  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  LEPUSValue js_function = LEPUS_GetPropertyStr(ctx, global, "Function");
  LEPUSValue func_proto = LEPUS_GetPrototype(ctx, js_function);

  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_DupValue(ctx, func_proto);
  }
  LEPUS_SetClassProto(ctx, class_id(), func_proto);
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, js_function);
    LEPUS_FreeValue(ctx, global);
  }

  return LEPUS_UNDEFINED;
}

LEPUSValue QJSWasmFunction::CreateConstructor(LEPUSContext* ctx,
                                              LEPUSValue wasm_root) {
  return CreatePrototype(ctx);
}

LEPUSValue QJSWasmFunction::CallAsConstructor(LEPUSContext* ctx,
                                              LEPUSValueConst constructor,
                                              int argc, LEPUSValueConst* argv) {
  return LEPUS_UNDEFINED;
}

LEPUSValue QJSWasmFunction::CallWasmFunction(LEPUSContext* ctx,
                                             LEPUSValueConst func_obj,
                                             LEPUSValueConst this_val, int argc,
                                             LEPUSValueConst* argv, int flags) {
  WLOGD("Running QJSWasmFunction::%s...", __func__);

  auto func_opaque =
      static_cast<QJSWasmFunction*>(LEPUS_GetOpaque(func_obj, class_id()));
  if (!func_opaque) return LEPUS_EXCEPTION;

  auto& wasm_function = func_opaque->function();
  auto interop_runtime = func_opaque->interop_runtime_;
  LEPUSRuntime* rt = LEPUS_GetRuntime(ctx);
  QJSEnv::JSValue* argvs = new QJSEnv::JSValue[argc];
  for (int i = 0; i < argc; i++) {
    argvs[i] = QJSEnv::FromQJS(argv[i], rt);
  }
  QJSEnv::JSValue value = QJSEnv::FromQJS(LEPUS_UNDEFINED, rt);
  LEPUSValue res = QJSEnv::ToQJS(interop_runtime->CallWasmFunction<QJSEnv>(
      wasm_function, argc, argvs, &value));
  delete[] argvs;
  return res;
}

LEPUSValue QJSWasmFunction::CreateJSObject(LEPUSContext* ctx,
                                           InteropRuntime* interop,
                                           WasmFunctionRef function) {
  LEPUSValue obj = LEPUS_NewObjectClass(ctx, class_id());
  if (LEPUS_IsException(obj)) {
    return LEPUS_EXCEPTION;
  }
  auto func_opaque = new QJSWasmFunction(function, interop);
  LEPUS_SetOpaque(obj, func_opaque);
  return obj;
}

void QJSWasmFunction::Finalize(LEPUSRuntime* rt, LEPUSValue obj) {
  WLOGD("Running QJSWasmFunction::%s...", __func__);

  auto func_opaque =
      static_cast<QJSWasmFunction*>(LEPUS_GetOpaque(obj, class_id()));
  delete func_opaque;
  LEPUS_SetOpaque(obj, nullptr);
}

}  // namespace primjs::qjs
