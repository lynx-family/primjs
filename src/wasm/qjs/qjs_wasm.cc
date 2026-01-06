// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm.h"

#include <array>
#include <atomic>
#include <cstddef>
#include <functional>

#include "common/interop_runtime.h"
#include "common/wasm_log.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/js_env_qjs.h"
#include "qjs/qjs_ext_api.h"
#include "qjs/qjs_wasm_function.h"
#include "qjs/qjs_wasm_global.h"
#include "qjs/qjs_wasm_instance.h"
#include "qjs/qjs_wasm_memory.h"
#include "qjs/qjs_wasm_module.h"
#include "qjs/qjs_wasm_table.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs::qjs {
void QJSWebAssembly::RegisterWebAssembly(LEPUSContext* ctx,
                                         std::atomic_bool* ctx_invalid,
                                         WasmRuntimeType runtime_type) {
  constexpr const char* code = "Registering WebAssembly";
  constexpr const char* err_msg = "Creating global.WebAssembly failed...";

  bool is_prism = GetSettingsWithKey("wasm_runtime_type");
  if (is_prism) {
    runtime_type = WasmRuntimeType::PRISM;
  } else {
    runtime_type = WasmRuntimeType::WASM3;
  }

  WLOGI("RegisterWebAssembly! WasmRuntimeType: %d", runtime_type);

  if (!ctx) {
    WLOGE("%s", err_msg);
    return;
  }

  // Create WebAssembly object, and set it as global.WebAssembly
  LEPUSValue wasm_obj = CreateWasmObject(ctx);
  HandleScope func_scope(ctx, &wasm_obj, HANDLE_TYPE_LEPUS_VALUE);

  // Factory function type
  using RuntimeFactory = std::function<InteropRuntime*(LEPUSContext*)>;
  // New JS Environment and Wasm Environment here, and Creating a Interop
  // Runtime to manage js env and wasm env.
  std::array<std::pair<WasmRuntimeType, RuntimeFactory>, 2> factory_array = {{
      {WasmRuntimeType::WASM3,
       [ctx_invalid](LEPUSContext* ctx) {
         return InteropRuntime::Constructor(new QJSEnv(ctx, ctx_invalid),
                                            new Wasm3Runtime());
       }},
      {WasmRuntimeType::PRISM,
       [ctx_invalid](LEPUSContext* ctx) {
         return InteropRuntime::Constructor(new QJSEnv(ctx, ctx_invalid),
                                            new PrismRuntime());
       }},
  }};

  // Create InteropRuntime instance
  InteropRuntime* interop = nullptr;
  for (const auto& [runtime, factory] : factory_array) {
    // If and Only If the runtime type matches the required type, we will create
    // it. Otherwise, we will skip it.
    if (runtime == runtime_type && factory) {
      interop = factory(ctx);
      break;
    }
  }

  if (!interop || interop->IsInvalid<QJSEnv>()) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
    InteropRuntime::DecreaseRefCount(interop);
    return;
  }

  // Ownership of interop is transferred to wasm_obj
  LEPUS_SetOpaque(wasm_obj, interop);
  InteropRuntime::IncreaseRefCount(interop);

  // Define the mapping of constructors and names to be registered
  LEPUSValue mod_ctor = QJSWasmModule::CreateConstructor(ctx, wasm_obj);
  func_scope.PushHandle(&mod_ctor, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue inst_ctor = QJSWasmInstance::CreateConstructor(ctx, wasm_obj);
  func_scope.PushHandle(&inst_ctor, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue table_ctor = QJSWasmTable::CreateConstructor(ctx, wasm_obj);
  func_scope.PushHandle(&table_ctor, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue memory_ctor = QJSWasmMemory::CreateConstructor(ctx, wasm_obj);
  func_scope.PushHandle(&memory_ctor, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue global_ctor = QJSWasmGlobal::CreateConstructor(ctx, wasm_obj);
  func_scope.PushHandle(&global_ctor, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue function_ctor = QJSWasmFunction::CreateConstructor(ctx, wasm_obj);
  func_scope.PushHandle(&function_ctor, HANDLE_TYPE_LEPUS_VALUE);
  std::array<std::pair<const char*, LEPUSValue>, 6> constructor_array = {
      {{"Module", mod_ctor},
       {"Instance", inst_ctor},
       {"Table", table_ctor},
       {"Memory", memory_ctor},
       {"Global", global_ctor},
       {"Function", function_ctor}}};

  int default_flag = LEPUS_PROP_CONFIGURABLE | LEPUS_PROP_WRITABLE;

  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  int res = LEPUS_DefinePropertyValueStr(ctx, global, "WebAssembly", wasm_obj,
                                         LEPUS_PROP_CONFIGURABLE);
  if (res <= 0) {
    if (!LEPUS_IsGCMode(ctx)) {
      LEPUS_FreeValue(ctx, global);
    }
    ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
    return;
  }

  for (const auto& [name, ctor] : constructor_array) {
    res = LEPUS_DefinePropertyValueStr(ctx, wasm_obj, name, ctor, default_flag);
    if (res <= 0) {
      ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
      if (!LEPUS_IsGCMode(ctx)) {
        LEPUS_FreeValue(ctx, global);
      }
      return;
    }
  }
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, global);
  }
}

LEPUSValue QJSWebAssembly::CreateWasmObject(LEPUSContext* ctx) {
  LEPUSClassDef def = {.class_name = "WebAssembly",
                       .finalizer = Finalize,
                       .gc_mark = QJSWebAssembly::GCMark};

  if (JSSafeNewClass(ctx, class_id(), &def) != 0) {
    WLOGE("NewClass for WebAssembly failed.");
    return LEPUS_EXCEPTION;
  }

  // WebAssembly static methods
  // TODO(wasm): Implement these methods.
  const LEPUSCFunctionListEntry wasm_func_list[] = {
      // LEPUS_CFUNC_DEF("compile", 1, nullptr),
      // LEPUS_CFUNC_DEF("compileStreaming", 1, nullptr),
      // LEPUS_CFUNC_DEF("instantiate", 1, nullptr),
      // LEPUS_CFUNC_DEF("instantiateStreaming", 1, nullptr),
      // LEPUS_CFUNC_DEF("validate", 1, nullptr),
  };

  LEPUSValue prototype = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &prototype, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyFunctionList(ctx, prototype, wasm_func_list,
                                countof(wasm_func_list));
  LEPUS_SetClassProto(ctx, class_id(), prototype);

  LEPUSValue wasm_obj = LEPUS_NewObjectClass(ctx, class_id());
  if (LEPUS_IsException(wasm_obj)) {
    return wasm_obj;
  }

  return wasm_obj;
}

// static
void QJSWebAssembly::Finalize(LEPUSRuntime* rt, LEPUSValue obj) {
  WLOGD("Running QJSWebAssembly::%s...", __func__);

  auto interop = static_cast<InteropRuntime*>(LEPUS_GetOpaque(obj, class_id()));
  WASM_DCHECK(interop != nullptr);

  InteropRuntime::ReleaseJSEnv(interop);
  InteropRuntime::DecreaseRefCount(interop);
  LEPUS_SetOpaque(obj, nullptr);
}

// static
void QJSWebAssembly::GCMark(LEPUSRuntime* rt, LEPUSValueConst obj,
                            LEPUS_MarkFunc* mark_func, uint64_t trace_tool) {
  auto interop = static_cast<InteropRuntime*>(LEPUS_GetOpaque(obj, class_id()));
  if (interop) {
    auto js_env = interop->js_env<QJSEnv*>();
    WASM_DCHECK(js_env != nullptr);
    js_env->Mark(mark_func, rt, trace_tool);
  }
}

}  // namespace primjs::qjs
