// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm.h"

#include <array>
#include <atomic>
#include <cstddef>
#include <functional>
#include <mutex>
#include <unordered_map>

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
#include "runtime/prism/wasm_runtime.h"

namespace primjs::qjs {

namespace {
// Prism-only: 记录使用 PrismRuntime 的 QuickJS Context，按 Context 维度管理
// InteropRuntime/PrismRuntime（以及内部 wasm_store/wasm_engine）的生命周期。
// Each entry owns one InteropRuntime reference. Replacing or taking an entry
// transfers that reference to RequestPrismReleaseAndConsumeRef.
using PrismContextMap = std::unordered_map<LEPUSContext*, InteropRuntime*>;

PrismContextMap& GetPrismContextMap() {
  // Process-lifetime storage avoids both load-time construction and shutdown
  // ordering hazards with QuickJS context finalizers.
  static auto* const contexts = new PrismContextMap();
  return *contexts;
}

std::mutex& GetPrismContextMapMutex() {
  static auto* const mutex = new std::mutex();
  return *mutex;
}

void RegisterPrismContext(LEPUSContext* ctx, InteropRuntime* interop) {
  if (wasm_unlikely(!ctx || !interop)) return;
  InteropRuntime* previous = nullptr;
  {
    std::lock_guard<std::mutex> lock(GetPrismContextMapMutex());
    auto& slot = GetPrismContextMap()[ctx];
    if (slot == interop) return;

    // Acquire the registry's ownership before publishing the raw pointer.
    // The WebAssembly root already keeps interop alive during this transfer.
    InteropRuntime::IncreaseRefCount(interop);
    previous = slot;
    slot = interop;
  }
  if (previous) {
    InteropRuntime::RequestPrismReleaseAndConsumeRef(previous);
  }
}

InteropRuntime* TakePrismInterop(LEPUSContext* ctx) {
  if (wasm_unlikely(!ctx)) return nullptr;
  std::lock_guard<std::mutex> lock(GetPrismContextMapMutex());
  auto& contexts = GetPrismContextMap();
  auto it = contexts.find(ctx);
  if (it == contexts.end()) {
    return nullptr;
  }
  InteropRuntime* interop = it->second;
  contexts.erase(it);
  return interop;
}

// QuickJS 在 LEPUS_FreeContext 完成自身 GC/Finalizer 及内部清理后调用该回调。
// 此时不再允许在该 ctx 上执行任何 JS，仅依赖 ctx 作为标识从映射中取出
// 对应的 InteropRuntime，并在 Prism 路径下一次性释放 PrismRuntime
// （其中 PrismRuntime::ReleaseStore 负责释放 wasm_store/wasm_engine）。
void PrismOnContextFreed(LEPUSContext* ctx) {
  auto* interop = TakePrismInterop(ctx);
  if (!interop) {
    return;
  }
  if (!interop->wasm_runtime().is<PrismRuntime*>()) {
    return;
  }
  // All QJS finalizers have run. The shared release request now frees the one
  // Prism store only after the final wrapper reference has disappeared.
  InteropRuntime::RequestPrismReleaseAndConsumeRef(interop);
}

void EnsurePrismContextFreedCallback() {
  static std::once_flag once;
  std::call_once(once,
                 []() { LEPUS_SetContextFreedCallback(PrismOnContextFreed); });
}

}  // namespace

void QJSWebAssembly::RegisterWebAssembly(LEPUSContext* ctx,
                                         std::atomic_bool* ctx_invalid,
                                         WasmRuntimeType runtime_type) {
  // The settings-driven runtime override below is gated on ENABLE_MONITOR so
  // that it only applies in builds with a real `GetSettingsWithKey`
  // implementation (e.g. host apps wired to a runtime config service). In
  // OSS / CLI / unit-test builds — where `primjs_monitor.cc` ships a stub
  // that always returns false — this guard preserves the caller-supplied
  // `runtime_type`, so callers (CLI `--wasm-engine prism`, Prism-targeted
  // unit tests, etc.) can actually reach the Prism path instead of being
  // silently rerouted to WASM3.
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

void QJSWebAssembly::RegisterWebAssemblyForTesting(
    LEPUSContext* ctx, std::atomic_bool* ctx_invalid,
    WasmRuntimeType runtime_type) {
  constexpr const char* code = "Registering WebAssembly";
  constexpr const char* err_msg = "Creating global.WebAssembly failed...";

  WLOGI("RegisterWebAssembly! WasmRuntimeType: %d", runtime_type);

  if (wasm_unlikely(!ctx)) {
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

  if (wasm_unlikely(!interop || interop->IsInvalid<QJSEnv>())) {
    if (!LEPUS_IsGCMode(ctx)) {
      LEPUS_FreeValue(ctx, wasm_obj);
    }
    ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
    // `interop` may be nullptr here when the runtime-type factory lookup
    // above returned null (unsupported/disabled engine).
    if (interop) {
      InteropRuntime::DestroyUnowned(interop);
    }
    return;
  }

  // Ownership of interop is transferred to wasm_obj
  LEPUS_SetOpaque(wasm_obj, interop);
  InteropRuntime::IncreaseRefCount(interop);

  const bool is_prism = interop->wasm_runtime().is<PrismRuntime*>();
  if (is_prism) {
    interop->js_env<QJSEnv*>()->SetWasmRoot(wasm_obj);
    // The WebAssembly root owns the current reference. Publish the release
    // request before any remaining registration step can fail; the root's
    // finalizer will consume that reference even when no registry entry exists.
    // SAFETY: `wasm_obj` stays in `func_scope` for the rest of this function,
    // so the root finalizer cannot run here; ref_count cannot reach zero while
    // the release request is already published.
    InteropRuntime::RequestPrismRelease(interop);
  }

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
      if (is_prism) {
        // Registration did not publish these constructors. Prism constructors
        // retain the WebAssembly root, so freeing them drops those references
        // and lets the published release request finish.
        for (const auto& [name, ctor] : constructor_array) {
          (void)name;
          LEPUS_FreeValue(ctx, ctor);
        }
      }
      LEPUS_FreeValue(ctx, global);
    }
    ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
    return;
  }

  for (size_t i = 0; i < constructor_array.size(); ++i) {
    const auto& [name, ctor] = constructor_array[i];
    res = LEPUS_DefinePropertyValueStr(ctx, wasm_obj, name, ctor, default_flag);
    if (res <= 0) {
      ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
      if (!LEPUS_IsGCMode(ctx)) {
        if (is_prism) {
          // DefinePropertyValueStr consumed the current value. Release only
          // the unpublished Prism constructors that follow it.
          for (size_t remaining = i + 1; remaining < constructor_array.size();
               ++remaining) {
            LEPUS_FreeValue(ctx, constructor_array[remaining].second);
          }
        }
        LEPUS_FreeValue(ctx, global);
      }
      return;
    }
  }

  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, global);
  }

  if (is_prism) {
    // Publish the registry's counted owner only after WebAssembly and all of
    // its constructors have been installed successfully.
    RegisterPrismContext(ctx, interop);
    EnsurePrismContextFreedCallback();
  }
}

#if defined(QJS_UNITTEST)
int QJSWebAssembly::LivePrismInstancesForTesting() {
  return PrismInstance::live_instances_for_testing_.load();
}

void QJSWebAssembly::FailPrismExportAfterForTesting(int exports) {
  PrismInstance::fail_export_after_for_testing_ = exports;
}

int QJSWebAssembly::GetCurrentPrismRefCountForTesting(LEPUSContext* ctx) {
  std::lock_guard<std::mutex> lock(GetPrismContextMapMutex());
  auto& contexts = GetPrismContextMap();
  auto it = contexts.find(ctx);
  if (it == contexts.end() || !it->second ||
      !it->second->wasm_runtime().is<PrismRuntime*>()) {
    return -1;
  }
  return it->second->GetRefCount();
}

bool QJSWebAssembly::SetCurrentPrismReleaseCountForTesting(
    LEPUSContext* ctx, std::atomic_int* release_count) {
  std::lock_guard<std::mutex> lock(GetPrismContextMapMutex());
  auto& contexts = GetPrismContextMap();
  auto it = contexts.find(ctx);
  if (it == contexts.end() || !it->second ||
      !it->second->wasm_runtime().is<PrismRuntime*>()) {
    return false;
  }
  InteropRuntime::SetPrismReleaseCountForTesting(it->second, release_count);
  return true;
}

void QJSWebAssembly::InvalidateWasmRootForTesting(LEPUSContext* ctx) {
  std::lock_guard<std::mutex> lock(GetPrismContextMapMutex());
  auto& contexts = GetPrismContextMap();
  auto it = contexts.find(ctx);
  if (it == contexts.end() || !it->second) return;
  auto* env = it->second->js_env<QJSEnv*>();
  if (env) env->SetWasmRoot(LEPUS_UNDEFINED);
}
#endif

#if defined(QJS_UNITTEST) && !defined(ENABLE_WASM_PERF_TEST_CAPTURE)
void QJSWebAssembly::ResetPrismImportBindingPathForTesting() {
  wasm::PrismModule::ResetImportBindingPathForTesting();
}

QJSWebAssembly::PrismImportBindingPathForTesting
QJSWebAssembly::LastPrismImportBindingPathForTesting() {
  using ModulePath = wasm::PrismModule::ImportBindingPathForTesting;
  switch (wasm::PrismModule::LastImportBindingPathForTesting()) {
    case ModulePath::kBorrowedAllFunctions:
      return PrismImportBindingPathForTesting::kBorrowedAllFunctions;
    case ModulePath::kOwnedDescriptors:
      return PrismImportBindingPathForTesting::kOwnedDescriptors;
    case ModulePath::kUnknown:
      return PrismImportBindingPathForTesting::kUnknown;
  }
  return PrismImportBindingPathForTesting::kUnknown;
}

size_t QJSWebAssembly::PrismBorrowedImportViewCallsForTesting() {
  return wasm::PrismModule::BorrowedImportViewCallsForTesting();
}

size_t QJSWebAssembly::PrismOwnedImportDescriptorEnumerationsForTesting() {
  return wasm::PrismModule::OwnedImportDescriptorEnumerationsForTesting();
}

size_t QJSWebAssembly::PrismRolledBackImportFunctionsForTesting() {
  return wasm::PrismModule::RolledBackImportFunctionsForTesting();
}

size_t QJSWebAssembly::PrismRolledBackImportCallbackRootsForTesting() {
  return wasm::PrismModule::RolledBackImportCallbackRootsForTesting();
}
#endif

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
  if (interop == nullptr) return;

  if (interop->wasm_runtime().is<PrismRuntime*>()) {
    InteropRuntime::ReleasePrismJSEnv(interop);
  } else {
    InteropRuntime::ReleaseJSEnv(interop);
  }
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
