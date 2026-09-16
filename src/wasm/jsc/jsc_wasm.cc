// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm.h"

#include <algorithm>
#include <array>
#include <atomic>
#include <cstddef>
#include <functional>
#include <mutex>
#include <unordered_map>
#include <utility>
#include <vector>

#include "common/interop_runtime.h"
#include "jsc/js_env_jsc.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"
#include "jsc/jsc_wasm_global.h"
#include "jsc/jsc_wasm_instance.h"
#include "jsc/jsc_wasm_memory.h"
#include "jsc/jsc_wasm_module.h"
#include "jsc/jsc_wasm_table.h"

namespace primjs::jsc {
namespace {
using PrismRoot = std::pair<JSObjectRef, InteropRuntime*>;
using PrismRootRegistry =
    std::unordered_map<JSContextRef, std::vector<PrismRoot>>;

PrismRootRegistry& GetPrismRootRegistry() {
  static auto* const registry = new PrismRootRegistry();
  return *registry;
}

std::mutex& GetPrismRootRegistryMutex() {
  static auto* const mutex = new std::mutex();
  return *mutex;
}

void TrackPrismRoot(JSContextRef ctx, JSObjectRef root,
                    InteropRuntime* interop) {
  std::lock_guard<std::mutex> lock(GetPrismRootRegistryMutex());
  GetPrismRootRegistry()[ctx].emplace_back(root, interop);
}

std::vector<PrismRoot> TakePrismRoots(JSContextRef ctx) {
  std::lock_guard<std::mutex> lock(GetPrismRootRegistryMutex());
  auto& registry = GetPrismRootRegistry();
  auto it = registry.find(ctx);
  if (it == registry.end()) return {};
  auto roots = std::move(it->second);
  registry.erase(it);
  return roots;
}

void UntrackPrismRoot(JSObjectRef root) {
  std::lock_guard<std::mutex> lock(GetPrismRootRegistryMutex());
  auto& registry = GetPrismRootRegistry();
  for (auto it = registry.begin(); it != registry.end();) {
    auto& roots = it->second;
    roots.erase(std::remove_if(roots.begin(), roots.end(),
                               [root](const PrismRoot& entry) {
                                 return entry.first == root;
                               }),
                roots.end());
    if (roots.empty()) {
      it = registry.erase(it);
    } else {
      ++it;
    }
  }
}

void ReleasePrismRoot(JSObjectRef root, InteropRuntime*& interop,
                      bool can_use_jsc_api) {
  if (!interop) return;
  if (root && JSObjectGetPrivate(root) == interop) {
    JSObjectSetPrivate(root, nullptr);
  }
  if (can_use_jsc_api) {
    InteropRuntime::ReleasePrismJSEnv(interop);
  } else {
    InteropRuntime::AbandonJSEnv(interop);
  }
  InteropRuntime::RequestPrismRelease(interop);
  InteropRuntime::DecreaseRefCount(interop);
}
}  // namespace

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
#ifdef ENABLE_MONITOR
  bool is_prism = GetSettingsWithKey("wasm_runtime_type");
  if (is_prism) {
    runtime_type = WasmRuntimeType::PRISM;
  } else {
    runtime_type = WasmRuntimeType::WASM3;
  }
#endif

  RegisterWebAssemblyForTesting(ctx, ctx_invalid, runtime_type);
}

void JSCWasmExt::RegisterWebAssemblyForTesting(JSContextRef ctx,
                                               std::atomic_bool* ctx_invalid,
                                               WasmRuntimeType runtime_type) {
  WLOGI("Registering WebAssembly, WasmRuntimeType: %d", runtime_type);

  // Factory function type, construct InteropRuntime singleton here, remember to
  // destruct it.
  using RuntimeFactory = std::function<InteropRuntime*(JSContextRef)>;
  // New JS Environment and Wasm Environment here, and Creating a Interop
  // Runtime to manage js env and wasm env.
  std::array<std::pair<WasmRuntimeType, RuntimeFactory>, 2> factory_array = {{
      {WasmRuntimeType::WASM3,
       [ctx_invalid](JSContextRef ctx) -> InteropRuntime* {
         return InteropRuntime::Constructor(new JSCEnv(ctx, ctx_invalid, false),
                                            new Wasm3Runtime());
       }},
      {WasmRuntimeType::PRISM,
       [ctx_invalid](JSContextRef ctx) -> InteropRuntime* {
         return InteropRuntime::Constructor(new JSCEnv(ctx, ctx_invalid, true),
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
    if (runtime_type == WasmRuntimeType::PRISM) {
      ReleasePrismRoot(wasm_obj, interop, true);
    } else {
      InteropRuntime::DecreaseRefCount(interop);
    }
    return;
  }
  if (runtime_type == WasmRuntimeType::PRISM) {
    TrackPrismRoot(ctx, wasm_obj, interop);
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
    if (runtime_type == WasmRuntimeType::PRISM) {
      // Prism releases its store once, through the WebAssembly root. Keep that
      // root reachable while a constructor remains reachable.
      JSObjectSetProperty(
          ctx, elem.second, JSString(kWasmRootProperty), wasm_obj,
          kJSPropertyAttributeReadOnly | kJSPropertyAttributeDontEnum |
              kJSPropertyAttributeDontDelete,
          &exception);
      if (exception) {
        WLOGE("Retaining WebAssembly root for %s failed!", elem.first);
        return;
      }
    }
    Attach(ctx, elem.first, elem.second, default_attr, wasm_obj, &exception);
    if (exception) {
      WLOGE("Attach WebAssembly.%s failed!", elem.first);
      return;
    }
  }
}

#if defined(QJS_UNITTEST)
bool JSCWasmExt::SetCurrentPrismReleaseCountForTesting(
    JSContextRef ctx, std::atomic_int* release_count) {
  std::lock_guard<std::mutex> lock(GetPrismRootRegistryMutex());
  auto& registry = GetPrismRootRegistry();
  auto it = registry.find(ctx);
  if (it == registry.end()) return false;
  for (auto& entry : it->second) {
    auto* interop = entry.second;
    if (interop && interop->wasm_runtime().is<PrismRuntime*>()) {
      InteropRuntime::SetPrismReleaseCountForTesting(interop, release_count);
      return true;
    }
  }
  return false;
}
#endif

void JSCWasmExt::RegisterWebAssembly(JSContextRef ctx,
                                     std::atomic_bool* ctx_invalid) {
  JSCWasmExt::RegisterWebAssembly(ctx, ctx_invalid, WasmRuntimeType::WASM3);
}

void JSCWasmExt::PrepareForContextRelease(JSContextRef ctx) {
  for (auto& [root, interop] : TakePrismRoots(ctx)) {
    ReleasePrismRoot(root, interop, true);
  }
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
  if (interop == nullptr) return;

  auto wasm_runtime = interop->wasm_runtime();
  JSObjectSetPrivate(obj, nullptr);
  if (wasm_runtime.is<PrismRuntime*>()) {
    UntrackPrismRoot(obj);
    ReleasePrismRoot(nullptr, interop, false);
  } else {
    InteropRuntime::ReleaseJSEnv(interop);
    InteropRuntime::DecreaseRefCount(interop);
  }
}

}  // namespace primjs::jsc
