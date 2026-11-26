// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm.h"

#include <algorithm>
#include <array>
#include <mutex>
#include <utility>
#include <vector>

#include "common/wasm_log.h"
#include "common/wasm_store_owner.h"
#include "jsc/js_env_jsc.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"
#include "jsc/jsc_wasm_instance.h"
#include "jsc/jsc_wasm_memory.h"
#include "jsc/jsc_wasm_module.h"
#include "jsc/jsc_wasm_table.h"

namespace primjs::jsc {

namespace {
struct TrackedRoot {
  JSContextRef ctx = nullptr;
  JSObjectRef root = nullptr;
  JSCEnv* env = nullptr;
};
using RootRegistry = std::vector<TrackedRoot>;

RootRegistry& GetRootRegistry() {
  static auto* const registry = new RootRegistry();
  return *registry;
}

std::mutex& GetRootRegistryMutex() {
  static auto* const mutex = new std::mutex();
  return *mutex;
}

void TrackRoot(JSContextRef ctx, JSObjectRef root, JSCEnv* env) {
  std::lock_guard<std::mutex> lock(GetRootRegistryMutex());
  GetRootRegistry().push_back({ctx, root, env});
}

std::vector<TrackedRoot> TakeRoots(JSContextRef ctx) {
  std::lock_guard<std::mutex> lock(GetRootRegistryMutex());
  auto& registry = GetRootRegistry();
  std::vector<TrackedRoot> taken;
  for (auto it = registry.begin(); it != registry.end();) {
    if (it->ctx == ctx) {
      taken.push_back(*it);
      it = registry.erase(it);
    } else {
      ++it;
    }
  }
  return taken;
}

void UntrackRoot(JSObjectRef root) {
  std::lock_guard<std::mutex> lock(GetRootRegistryMutex());
  auto& registry = GetRootRegistry();
  registry.erase(std::remove_if(registry.begin(), registry.end(),
                                [root](const TrackedRoot& entry) {
                                  return entry.root == root;
                                }),
                 registry.end());
}

void ReleaseRootEnv(JSObjectRef root, JSCEnv* env, bool can_use_jsc_api,
                    bool drain_handles) {
  if (!env) return;
  if (root && JSObjectGetPrivate(root) == env) {
    JSObjectSetPrivate(root, nullptr);
  }
  wasm::WasmStoreOwner* owner = env->store_owner();
  if (owner && owner->active_jsc_env() == env) {
    owner->SetActiveJSCEnv(nullptr);
  }
  if (drain_handles && can_use_jsc_api) {
    env->DetachAllWasmMemoryBuffers();
  }
  if (drain_handles && owner) {
    owner->DrainHandlesOnExit(nullptr);
  }
  if (can_use_jsc_api) {
    env->Finalize();
  }
  delete env;
  wasm::WasmStoreOwner::RequestReleaseAndConsumeRef(owner);
}
}  // namespace

JSClassRef JSCWasmExt::wasm_class_ref() {
  static JSClassRef class_ref = InitWasmClassRef();
  return class_ref;
}

JSClassRef JSCWasmExt::InitWasmClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition(kWasmName, Finalize);
  static const JSStaticFunction static_funcs[] = {{nullptr, nullptr, 0}};
  def.staticFunctions = static_funcs;
  return JSClassCreate(&def);
}

void JSCWasmExt::RegisterWebAssembly(JSContextRef ctx,
                                     std::atomic_bool* ctx_invalid) {
  if (wasm_unlikely(!ctx)) return;

  wasm::WasmStoreOwner* store_owner = wasm::WasmStoreOwner::Create();
  if (wasm_unlikely(!store_owner)) {
    WLOGE("Creating WebAssembly store failed!");
    return;
  }
  wasm::WasmStoreOwner::Retain(store_owner);

  auto* env = new JSCEnv(ctx, ctx_invalid, store_owner);
  store_owner->SetActiveJSCEnv(env);
  JSObjectRef wasm_obj = JSObjectMake(ctx, wasm_class_ref(), env);
  env->SetWasmRoot(wasm_obj);

  JSValueRef exception = nullptr;
  Attach(ctx, kWasmName, wasm_obj,
         kJSPropertyAttributeReadOnly | kJSPropertyAttributeDontEnum, nullptr,
         &exception);
  if (exception) {
    WLOGE("Attach WebAssembly failed!");
    ReleaseRootEnv(wasm_obj, env, true, true);
    return;
  }
  TrackRoot(ctx, wasm_obj, env);

  const JSPropertyAttributes default_attr = kJSPropertyAttributeDontEnum;
  std::array<std::pair<const char*, JSObjectRef>, 4> constructors = {
      {{kModuleName, JSCWasmModule::CreateConstructor(ctx, env, &exception)},
       {kInstanceName,
        JSCWasmInstance::CreateConstructor(ctx, env, &exception)},
       {kMemoryName, JSCWasmMemory::CreateConstructor(ctx, env, &exception)},
       {kTableName, JSCWasmTable::CreateConstructor(ctx, env, &exception)}}};

  for (const auto& [name, ctor] : constructors) {
    if (!ctor || exception ||
        !RetainWasmRootOnJSCObject(ctx, ctor, wasm_obj, &exception)) {
      WLOGE("Retaining WebAssembly root for %s failed!", name);
      return;
    }
    Attach(ctx, name, ctor, default_attr, wasm_obj, &exception);
    if (exception) {
      WLOGE("Attach WebAssembly.%s failed!", name);
      return;
    }
  }
}

void JSCWasmExt::PrepareForContextRelease(JSContextRef ctx) {
  for (auto& entry : TakeRoots(ctx)) {
    ReleaseRootEnv(entry.root, entry.env, true, true);
  }
}

void JSCWasmExt::Finalize(JSObjectRef obj) {
  auto* env = static_cast<JSCEnv*>(JSObjectGetPrivate(obj));
  if (!env) return;
  JSObjectSetPrivate(obj, nullptr);
  UntrackRoot(obj);
  ReleaseRootEnv(nullptr, env, false, false);
}

#if defined(QJS_UNITTEST)
bool JSCWasmExt::SetCurrentPrismReleaseCountForTesting(
    JSContextRef ctx, std::atomic_int* release_count) {
  std::lock_guard<std::mutex> lock(GetRootRegistryMutex());
  for (auto& entry : GetRootRegistry()) {
    if (entry.ctx == ctx && entry.env && entry.env->store_owner()) {
      entry.env->store_owner()->SetReleaseCountForTesting(release_count);
      return true;
    }
  }
  return false;
}
#endif

}  // namespace primjs::jsc
