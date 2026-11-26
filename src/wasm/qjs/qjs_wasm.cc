// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm.h"

#include <pthread.h>

#include "common/wasm_log.h"
#include "common/wasm_store_owner.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/js_env_qjs.h"
#include "qjs/qjs_ext_api.h"
#include "qjs/qjs_wasm_instance.h"
#include "qjs/qjs_wasm_memory.h"
#include "qjs/qjs_wasm_module.h"
#include "qjs/qjs_wasm_table.h"

namespace primjs::qjs {

namespace {
struct ContextRegNode {
  ContextRegNode* next = nullptr;
  LEPUSContext* ctx = nullptr;
  wasm::WasmStoreOwner* store_owner = nullptr;
  QJSEnv* js_env = nullptr;
  bool holds_registry_ref = false;
};

pthread_mutex_t g_context_map_mutex = PTHREAD_MUTEX_INITIALIZER;
ContextRegNode* g_reg_head = nullptr;
bool g_freed_cb_registered = false;

ContextRegNode* FindLastContextReg(LEPUSContext* ctx) {
  ContextRegNode* last = nullptr;
  for (ContextRegNode* cur = g_reg_head; cur != nullptr; cur = cur->next) {
    if (cur->ctx == ctx) last = cur;
  }
  return last;
}

void UntrackDeletedStoreOwner(wasm::WasmStoreOwner* owner) {
  pthread_mutex_lock(&g_context_map_mutex);
  ContextRegNode** pp = &g_reg_head;
  while (ContextRegNode* cur = *pp) {
    if (cur->store_owner == owner) {
      *pp = cur->next;
      delete cur;
    } else {
      pp = &cur->next;
    }
  }
  pthread_mutex_unlock(&g_context_map_mutex);
}

void OnContextFreed(LEPUSContext* ctx);

void RegisterContextStore(LEPUSContext* ctx, wasm::WasmStoreOwner* owner,
                          QJSEnv* env) {
  if (wasm_unlikely(!ctx || !owner)) return;
  wasm::WasmStoreOwner* previous = nullptr;
  bool need_register_cb = false;
  owner->SetBeforeDeleteCallback(UntrackDeletedStoreOwner);
  pthread_mutex_lock(&g_context_map_mutex);
  if (!g_freed_cb_registered) {
    g_freed_cb_registered = true;
    need_register_cb = true;
  }
  if (ContextRegNode* last = FindLastContextReg(ctx)) {
    if (last->store_owner == owner) {
      last->js_env = env;
      pthread_mutex_unlock(&g_context_map_mutex);
      if (need_register_cb) LEPUS_SetContextFreedCallback(OnContextFreed);
      return;
    }
    if (last->holds_registry_ref) {
      last->holds_registry_ref = false;
      previous = last->store_owner;
    }
  }
  wasm::WasmStoreOwner::Retain(owner);
  auto* node = new ContextRegNode{nullptr, ctx, owner, env, true};
  ContextRegNode** tail = &g_reg_head;
  while (*tail) tail = &(*tail)->next;
  *tail = node;
  pthread_mutex_unlock(&g_context_map_mutex);

  if (need_register_cb) {
    LEPUS_SetContextFreedCallback(OnContextFreed);
  }
  if (previous) {
    wasm::WasmStoreOwner::RequestReleaseAndConsumeRef(previous);
  }
}

void ClearEnvFromRegistry(QJSEnv* env) {
  if (!env) return;
  pthread_mutex_lock(&g_context_map_mutex);
  for (ContextRegNode* cur = g_reg_head; cur != nullptr; cur = cur->next) {
    if (cur->js_env == env) {
      cur->js_env = nullptr;
    }
  }
  pthread_mutex_unlock(&g_context_map_mutex);
}

ContextRegNode* TakeContextRegistrations(LEPUSContext* ctx) {
  if (wasm_unlikely(!ctx)) return nullptr;
  pthread_mutex_lock(&g_context_map_mutex);
  ContextRegNode* taken_head = nullptr;
  ContextRegNode** taken_tail = &taken_head;
  ContextRegNode** pp = &g_reg_head;
  while (ContextRegNode* cur = *pp) {
    if (cur->ctx != ctx) {
      pp = &cur->next;
      continue;
    }
    *pp = cur->next;
    cur->next = nullptr;
    if (cur->store_owner) {
      if (!cur->holds_registry_ref) {
        if (!wasm::WasmStoreOwner::TryRetain(cur->store_owner)) {
          delete cur;
          continue;
        }
        cur->holds_registry_ref = true;
      }
      cur->store_owner->SetBeforeDeleteCallback(nullptr);
    }
    *taken_tail = cur;
    taken_tail = &cur->next;
  }
  pthread_mutex_unlock(&g_context_map_mutex);
  return taken_head;
}

void OnContextFreed(LEPUSContext* ctx) {
  ContextRegNode* cur = TakeContextRegistrations(ctx);
  while (cur) {
    ContextRegNode* next = cur->next;
    wasm::WasmStoreOwner* owner = cur->store_owner;
    QJSEnv* js_env = cur->js_env;
    const bool holds_ref = cur->holds_registry_ref;
    delete cur;
    cur = next;

    if (owner) {
      owner->SetActiveQJSEnv(nullptr);
    }
    if (js_env) {
      LEPUSValue root = js_env->raw_wasm_root_object();
      if (LEPUS_IsObject(root) &&
          LEPUS_GetOpaque(root, QJSWebAssembly::class_id()) == js_env) {
        LEPUS_SetOpaque(root, nullptr);
      }
    }
    if (owner) {
      owner->DrainHandlesOnExit(ctx);
    }
    if (js_env) {
      wasm::WasmStoreOwner* env_owner = js_env->store_owner();
      js_env->Finalize();
      delete js_env;
      wasm::WasmStoreOwner::Release(env_owner);
    }
    if (owner && holds_ref) {
      wasm::WasmStoreOwner::RequestReleaseAndConsumeRef(owner);
    }
  }
}
}  // namespace

LEPUSClassID QJSWebAssembly::class_id() {
  return GetWasmClassId(WasmQJSClass::kWebAssembly);
}

QJSEnv* QJSWebAssembly::GetEnvFromRoot(LEPUSValueConst wasm_root) {
  if (!LEPUS_IsObject(wasm_root)) return nullptr;
  return static_cast<QJSEnv*>(LEPUS_GetOpaque(wasm_root, class_id()));
}

void QJSWebAssembly::RegisterWebAssembly(LEPUSContext* ctx,
                                         std::atomic_bool* ctx_invalid) {
  constexpr const char* code = "Registering WebAssembly";
  constexpr const char* err_msg = "Creating global.WebAssembly failed...";

  if (wasm_unlikely(!ctx)) {
    WLOGE("%s", err_msg);
    return;
  }

  LEPUSValue wasm_obj = CreateWasmObject(ctx);
  if (LEPUS_IsException(wasm_obj)) return;
  HandleScope func_scope(ctx, &wasm_obj, HANDLE_TYPE_LEPUS_VALUE);

  wasm::WasmStoreOwner* store_owner = wasm::WasmStoreOwner::Create();
  if (wasm_unlikely(!store_owner)) {
    FreeValueIfRC(ctx, wasm_obj);
    ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
    return;
  }
  wasm::WasmStoreOwner::Retain(store_owner);
  wasm::WasmStoreOwner::RequestRelease(store_owner);

  auto* js_env = new QJSEnv(ctx, ctx_invalid, store_owner);
  if (wasm_unlikely(js_env->IsInvalid())) {
    delete js_env;
    wasm::WasmStoreOwner::Release(store_owner);
    FreeValueIfRC(ctx, wasm_obj);
    ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
    return;
  }

  js_env->SetWasmRoot(wasm_obj);
  store_owner->SetActiveQJSEnv(js_env);
  LEPUS_SetOpaque(wasm_obj, js_env);

  if (!QJSWasmModule::Register(ctx, wasm_obj) ||
      !QJSWasmInstance::Register(ctx, wasm_obj) ||
      !QJSWasmTable::Register(ctx, wasm_obj) ||
      !QJSWasmMemory::Register(ctx, wasm_obj)) {
    Finalize(LEPUS_GetRuntime(ctx), wasm_obj);
    FreeValueIfRC(ctx, wasm_obj);
    return;
  }

  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  const int res = LEPUS_DefinePropertyValueStr(
      ctx, global, "WebAssembly", wasm_obj, LEPUS_PROP_CONFIGURABLE);
  FreeValueIfRC(ctx, global);
  if (res <= 0) {
    Finalize(LEPUS_GetRuntime(ctx), wasm_obj);
    ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
    return;
  }

  RegisterContextStore(ctx, store_owner, js_env);
}

LEPUSValue QJSWebAssembly::CreateWasmObject(LEPUSContext* ctx) {
  const LEPUSClassID cid = class_id();
  LEPUSClassDef def = {
      .class_name = "WebAssembly", .finalizer = Finalize, .gc_mark = GCMark};
  if (JSSafeNewClass(ctx, cid, &def)) {
    return LEPUS_EXCEPTION;
  }
  LEPUSValue prototype = LEPUS_NewObject(ctx);
  if (LEPUS_IsException(prototype)) return prototype;
  HandleScope func_scope(ctx, &prototype, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetClassProto(ctx, cid, prototype);
  return LEPUS_NewObjectClass(ctx, cid);
}

void QJSWebAssembly::Finalize(LEPUSRuntime* rt, LEPUSValue obj) {
  (void)rt;
  auto* js_env = static_cast<QJSEnv*>(LEPUS_GetOpaque(obj, class_id()));
  if (!js_env) return;
  LEPUS_SetOpaque(obj, nullptr);
  ClearEnvFromRegistry(js_env);
  wasm::WasmStoreOwner* owner = js_env->store_owner();
  if (owner && owner->active_qjs_env() == js_env) {
    owner->SetActiveQJSEnv(nullptr);
  }
  js_env->Finalize();
  delete js_env;
  wasm::WasmStoreOwner::Release(owner);
}

void QJSWebAssembly::GCMark(LEPUSRuntime* rt, LEPUSValueConst obj,
                            LEPUS_MarkFunc* mark_func, uint64_t trace_tool) {
  auto* js_env = static_cast<QJSEnv*>(LEPUS_GetOpaque(obj, class_id()));
  if (js_env) {
    js_env->Mark(mark_func, rt, trace_tool);
  }
}

#if defined(QJS_UNITTEST)
int QJSWebAssembly::LivePrismInstancesForTesting() {
  return wasm::WasmStoreOwner::live_instances_for_testing_.load();
}

int QJSWebAssembly::LivePrismModulesForTesting() {
  return wasm::WasmStoreOwner::live_modules_for_testing_.load();
}

void QJSWebAssembly::FailPrismExportAfterForTesting(int exports) {
  wasm::WasmStoreOwner::fail_export_after_for_testing_ = exports;
}

int QJSWebAssembly::GetCurrentPrismRefCountForTesting(LEPUSContext* ctx) {
  pthread_mutex_lock(&g_context_map_mutex);
  ContextRegNode* last = FindLastContextReg(ctx);
  const int count =
      (last && last->store_owner) ? last->store_owner->GetRefCount() : -1;
  pthread_mutex_unlock(&g_context_map_mutex);
  return count;
}

bool QJSWebAssembly::SetCurrentPrismReleaseCountForTesting(
    LEPUSContext* ctx, std::atomic_int* release_count) {
  pthread_mutex_lock(&g_context_map_mutex);
  ContextRegNode* last = FindLastContextReg(ctx);
  if (!last || !last->store_owner) {
    pthread_mutex_unlock(&g_context_map_mutex);
    return false;
  }
  last->store_owner->SetReleaseCountForTesting(release_count);
  pthread_mutex_unlock(&g_context_map_mutex);
  return true;
}

void QJSWebAssembly::InvalidateWasmRootForTesting(LEPUSContext* ctx) {
  pthread_mutex_lock(&g_context_map_mutex);
  ContextRegNode* last = FindLastContextReg(ctx);
  if (last && last->js_env) {
    last->js_env->InvalidateWasmRoot();
  }
  pthread_mutex_unlock(&g_context_map_mutex);
}

void QJSWebAssembly::ResetPrismImportBindingCountersForTesting() {
  wasm::WasmStoreOwner::import_descriptor_enumerations_for_testing_ = 0;
  wasm::WasmStoreOwner::rolled_back_import_functions_for_testing_ = 0;
  wasm::WasmStoreOwner::rolled_back_import_callbacks_for_testing_ = 0;
}

size_t QJSWebAssembly::PrismImportDescriptorEnumerationsForTesting() {
  return wasm::WasmStoreOwner::import_descriptor_enumerations_for_testing_;
}

size_t QJSWebAssembly::PrismRolledBackImportFunctionsForTesting() {
  return wasm::WasmStoreOwner::rolled_back_import_functions_for_testing_;
}

size_t QJSWebAssembly::PrismRolledBackImportCallbackRootsForTesting() {
  return wasm::WasmStoreOwner::rolled_back_import_callbacks_for_testing_;
}

size_t QJSWebAssembly::ActivePrismImportCallbackRootsForTesting(
    LEPUSContext* ctx) {
  pthread_mutex_lock(&g_context_map_mutex);
  ContextRegNode* last = FindLastContextReg(ctx);
  const size_t count = (last && last->js_env)
                           ? last->js_env->ActiveImportCallbackCountForTesting()
                           : 0;
  pthread_mutex_unlock(&g_context_map_mutex);
  return count;
}
#endif

}  // namespace primjs::qjs
