// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_WASM_STORE_OWNER_H_
#define SRC_WASM_COMMON_WASM_STORE_OWNER_H_

#include <pthread.h>

#include <atomic>
#include <cstddef>

#include "common/wasm_c_api_dispatch.h"
#include "common/wasm_utils.h"
#if __has_include("quickjs/include/primjs_monitor.h")
#include "quickjs/include/primjs_monitor.h"
#define PRIMJS_HAS_MONITOR_HEADER 1
#endif

namespace primjs {
namespace qjs {
class QJSEnv;
}
namespace jsc {
class JSCEnv;
}

namespace wasm {

struct WasmTrackedHandle {
  using DetachCallback = void (*)(WasmTrackedHandle* self, void* exit_ctx);

  WasmTrackedHandle* prev = nullptr;
  WasmTrackedHandle* next = nullptr;
  void* owner_object = nullptr;
  DetachCallback detach_fn = nullptr;
  bool priority_buffer_phase = false;
};

// Single-engine store owner shared by a JS context and all Wasm entity
// wrappers created within it. Supports both normal GC/RC wrapper reclamation
// during execution and deterministic unified reclamation at context exit so
// leaked JS cycles/handles in imperfect RC/GC environments never retain Wasm
// linear memory, instances, modules, or stores after context teardown.
class WasmStoreOwner {
 public:
  static WasmStoreOwner* Create() {
    WasmStoreOwner* owner = CreateRaw();
#if defined(PRIMJS_HAS_MONITOR_HEADER)
    if (owner) {
      MonitorEvent(MODULE_WASM, DEFAULT_BIZ_NAME, "PrismRuntime", "true");
    }
#endif
    return owner;
  }

  WasmStoreOwner(const WasmStoreOwner&) = delete;
  WasmStoreOwner& operator=(const WasmStoreOwner&) = delete;

  wasm_store_t* store() const { return store_; }
  wasm_engine_t* engine() const { return engine_; }

  void SetActiveQJSEnv(qjs::QJSEnv* env) {
    active_qjs_env_.store(env, std::memory_order_release);
  }
  qjs::QJSEnv* active_qjs_env() const {
    return active_qjs_env_.load(std::memory_order_acquire);
  }

  void SetActiveJSCEnv(jsc::JSCEnv* env) {
    active_jsc_env_.store(env, std::memory_order_release);
  }
  jsc::JSCEnv* active_jsc_env() const {
    return active_jsc_env_.load(std::memory_order_acquire);
  }

  void LinkHandle(WasmTrackedHandle* handle, void* owner_object,
                  WasmTrackedHandle::DetachCallback detach_fn,
                  bool priority_buffer_phase = false);

  bool UnlinkHandle(WasmTrackedHandle* handle);

  void DrainHandlesOnExit(void* exit_ctx);

  static void Retain(WasmStoreOwner* owner) {
    if (wasm_unlikely(!owner)) return;
    owner->ref_count_.fetch_add(1, std::memory_order_relaxed);
  }

  static bool TryRetain(WasmStoreOwner* owner);
  static void Release(WasmStoreOwner*& owner);
  static void RequestRelease(WasmStoreOwner* owner);
  static void RequestReleaseAndConsumeRef(WasmStoreOwner*& owner);

  using BeforeDeleteCallback = void (*)(WasmStoreOwner* owner);
  void SetBeforeDeleteCallback(BeforeDeleteCallback cb) {
    before_delete_cb_.store(cb, std::memory_order_release);
  }

  int GetRefCount() const { return ref_count_.load(std::memory_order_acquire); }

#if defined(QJS_UNITTEST)
  void SetReleaseCountForTesting(std::atomic_int* release_count) {
    release_count_for_testing_ = release_count;
  }

  inline static std::atomic_int live_modules_for_testing_{0};
  inline static std::atomic_int live_instances_for_testing_{0};
  inline static int fail_export_after_for_testing_{-1};
  inline static size_t import_descriptor_enumerations_for_testing_{0};
  inline static size_t rolled_back_import_functions_for_testing_{0};
  inline static size_t rolled_back_import_callbacks_for_testing_{0};
#endif

 private:
  static WasmStoreOwner* CreateRaw();
  WasmStoreOwner();
  ~WasmStoreOwner();
  WasmTrackedHandle* PopOneHandleForDetach(bool priority_buffer_phase,
                                           pthread_t tid);
  void FinishHandleDetach();
  void DrainMatchingHandles(void* exit_ctx, bool priority_buffer_phase);
  bool Init();
  void ReleaseStore();
  static void MaybeFinishRelease(WasmStoreOwner* owner);

  wasm_engine_t* engine_ = nullptr;
  wasm_store_t* store_ = nullptr;
  std::atomic<qjs::QJSEnv*> active_qjs_env_{nullptr};
  std::atomic<jsc::JSCEnv*> active_jsc_env_{nullptr};
  std::atomic<BeforeDeleteCallback> before_delete_cb_{nullptr};
  pthread_mutex_t tracked_mutex_;
  pthread_cond_t tracked_cv_;
  WasmTrackedHandle* detaching_ = nullptr;
  pthread_t detaching_tid_{};
  bool detaching_active_ = false;
  WasmTrackedHandle head_;
  std::atomic_int ref_count_{0};
  std::atomic_bool release_requested_{false};
  std::atomic_bool release_claimed_{false};
  std::atomic_int* release_count_for_testing_ = nullptr;
};

struct WasmBufferKeep {
  WasmTrackedHandle tracked;
  WasmStoreOwner* owner = nullptr;
  wasm_memory_t* memory = nullptr;
  std::atomic_bool dropped{false};
  bool in_exit_detach = false;

  static WasmBufferKeep* Create(
      WasmStoreOwner* store_owner, wasm_memory_t* source_memory,
      WasmTrackedHandle::DetachCallback exit_detach = nullptr);

  static WasmBufferKeep* FromTracked(WasmTrackedHandle* h) {
    return static_cast<WasmBufferKeep*>(h->owner_object);
  }

  void DropOnce();
};

inline wasm_trap_t* NewJsExceptionTrap(wasm_store_t* store) {
  static constexpr char kText[] = "JavaScript exception";
  wasm_message_t message = {sizeof(kText), const_cast<char*>(kText)};
  return wasm_trap_new(store, &message);
}

}  // namespace wasm
}  // namespace primjs

#endif  // SRC_WASM_COMMON_WASM_STORE_OWNER_H_
