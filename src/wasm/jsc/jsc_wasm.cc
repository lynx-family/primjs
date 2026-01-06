// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm.h"

#include <array>
#include <atomic>
#include <cstddef>
#include <functional>

#include "common/interop_runtime.h"
#include "common/wasm_utils.h"
#include "jsc/js_env_jsc.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"
#include "jsc/jsc_wasm_global.h"
#include "jsc/jsc_wasm_instance.h"
#include "jsc/jsc_wasm_memory.h"
#include "jsc/jsc_wasm_module.h"
#include "jsc/jsc_wasm_table.h"

namespace primjs::jsc {
JSClassRef JSCWasmExt::wasm_class_ref() {
  static JSClassRef class_ref = JSCWasmExt::InitWasmClassRef();
  return class_ref;
}

JSClassRef JSCWasmExt::InitWasmClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition(JSCWasmExt::kWasmName, Finalize);
  JSStaticFunction static_funcs[] = {{0, 0, 0}};
  def.staticFunctions = static_funcs;
  return JSClassCreate(&def);
}

void JSCWasmExt::RegisterWebAssembly(JSContextRef ctx,
                                     std::atomic_bool* ctx_invalid,
                                     WasmRuntimeType runtime_type) {
  bool is_prism = GetSettingsWithKey("wasm_runtime_type");
  if (is_prism) {
    runtime_type = WasmRuntimeType::PRISM;
  } else {
    runtime_type = WasmRuntimeType::WASM3;
  }

  WLOGI("Registering WebAssembly, WasmRuntimeType: %d", runtime_type);

  // Factory function type, construct InteropRuntime singleton here, remember to
  // destruct it.
  using RuntimeFactory = std::function<InteropRuntime*(JSContextRef)>;
  // New JS Environment and Wasm Environment here, and Creating a Interop
  // Runtime to manage js env and wasm env.
  std::array<std::pair<WasmRuntimeType, RuntimeFactory>, 2> factory_array = {{
      {WasmRuntimeType::WASM3,
       [ctx_invalid](JSContextRef ctx) -> InteropRuntime* {
         return InteropRuntime::Constructor(new JSCEnv(ctx, ctx_invalid),
                                            new Wasm3Runtime());
       }},
      {WasmRuntimeType::PRISM,
       [ctx_invalid](JSContextRef ctx) -> InteropRuntime* {
         return InteropRuntime::Constructor(new JSCEnv(ctx, ctx_invalid),
                                            new PrismRuntime());
       }},
  }};

  // Create InteropRuntime instance
  InteropRuntime* interop = nullptr;
  for (const auto& elem : factory_array) {
    if (elem.first == runtime_type) {
      interop = elem.second(ctx);
      break;
    }
  }

  // Create WebAssembly object, and set it as global.WebAssembly. Move OWNERSHIP
  // of interop to wasm_obj.
  JSObjectRef wasm_obj = CreateWasmObject(ctx, interop, ctx_invalid);

  JSValueRef exception{};
  Attach(ctx, JSCWasmExt::kWasmName, wasm_obj,
         kJSPropertyAttributeReadOnly | kJSPropertyAttributeDontEnum, nullptr,
         &exception);
  if (exception) {
    WLOGE("Attach WebAssembly failed!");
    InteropRuntime::DecreaseRefCount(interop);
    return;
  }

  JSPropertyAttributes default_attr = kJSPropertyAttributeDontEnum;
  std::array<std::pair<const char*, JSObjectRef>, 5> constructors = {
      {{JSCWasmExt::kModuleName,
        JSCWasmModule::CreateConstructor(ctx, interop, &exception)},
       {JSCWasmExt::kInstanceName,
        JSCWasmInstance::CreateConstructor(ctx, interop, &exception)},
       {JSCWasmExt::kMemoryName,
        JSCWasmMemory::CreateConstructor(ctx, interop, &exception)},
       {JSCWasmExt::kTableName,
        JSCWasmTable::CreateConstructor(ctx, interop, &exception)},
       {JSCWasmExt::kGlobalName,
        JSCWasmGlobal::CreateConstructor(ctx, interop, &exception)}}};

  for (const auto& elem : constructors) {
    Attach(ctx, elem.first, elem.second, default_attr, wasm_obj, &exception);
    if (exception) {
      WLOGE("Attach WebAssembly.%s failed!", elem.first);
      return;
    }
  }
}

void JSCWasmExt::RegisterWebAssembly(JSContextRef ctx,
                                     std::atomic_bool* ctx_invalid) {
  JSCWasmExt::RegisterWebAssembly(ctx, ctx_invalid, WasmRuntimeType::PRISM);
}

JSObjectRef JSCWasmExt::CreateWasmObject(JSContextRef ctx,
                                         InteropRuntime* interop,
                                         std::atomic_bool* ctx_invalid) {
  JSObjectRef wasm_obj = JSObjectMake(ctx, wasm_class_ref(), interop);
  InteropRuntime::IncreaseRefCount(interop);

  return wasm_obj;
}

void JSCWasmExt::Finalize(JSObjectRef obj) {
  WLOGD("Finalizing globalThis.WebAssembly Object...");

  auto interop = static_cast<InteropRuntime*>(JSObjectGetPrivate(obj));

  InteropRuntime::ReleaseJSEnv(interop);
  InteropRuntime::DecreaseRefCount(interop);
}

}  // namespace primjs::jsc
