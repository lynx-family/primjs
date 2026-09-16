// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_INTEROP_RUNTIME_H_
#define SRC_WASM_COMMON_INTEROP_RUNTIME_H_

// NOTE:
// THIS HEADER FILE SHOULD NOT BE INCLUDED IN ANY HEADERS IN RUNTIME MODULE

#include <atomic>
#include <cstddef>
#include <map>

#include "js_type.h"
#include "one_of.h"
#include "wasm3/wasm3.h"
#include "wasm_type.h"
#include "wasm_utils.h"
#if defined(__APPLE__)
#include "jsc/js_env_jsc.h"
#endif
#include "qjs/js_env_qjs.h"
#include "runtime/prism/wasm_function.h"
#include "runtime/prism/wasm_global.h"
#include "runtime/prism/wasm_instance.h"
#include "runtime/prism/wasm_memory.h"
#include "runtime/prism/wasm_module.h"
#include "runtime/prism/wasm_runtime.h"
#include "runtime/prism/wasm_table.h"
#include "runtime/wasm3/wasm_function.h"
#include "runtime/wasm3/wasm_global.h"
#include "runtime/wasm3/wasm_instance.h"
#include "runtime/wasm3/wasm_memory.h"
#include "runtime/wasm3/wasm_module.h"
#include "runtime/wasm3/wasm_runtime.h"
#include "runtime/wasm3/wasm_table.h"
#ifdef ENABLE_WASM_PERF_COMPARE
#include "common/interop_runtime_perf.h"
#endif  // ENABLE_WASM_PERF_COMPARE

namespace primjs {
using jsc::JSCEnv;
using qjs::QJSEnv;

using wasm::PrismFunction;
using wasm::PrismGlobal;
using wasm::PrismInstance;
using wasm::PrismMemory;
using wasm::PrismModule;
using wasm::PrismRuntime;
using wasm::PrismTable;
using wasm::Wasm3Function;
using wasm::Wasm3Global;
using wasm::Wasm3Instance;
using wasm::Wasm3Memory;
using wasm::Wasm3Module;
using wasm::Wasm3Runtime;
using wasm::Wasm3Table;

using WasmModuleRef = OneOf<Wasm3Module*, PrismModule*>;
using WasmInstanceRef = OneOf<Wasm3Instance*, PrismInstance*>;
using WasmMemoryRef = OneOf<Wasm3Memory*, PrismMemory*>;
using WasmGlobalRef = OneOf<Wasm3Global*, PrismGlobal*>;
using WasmTableRef = OneOf<Wasm3Table*, PrismTable*>;
using WasmFunctionRef = OneOf<Wasm3Function*, PrismFunction*>;
using WasmRuntimeRef = OneOf<Wasm3Runtime*, PrismRuntime*>;

using MemoryCacheRef = OneOf<IM3Memory, wasm_memory_t*>;
using GlobalCacheRef = OneOf<M3Global*, wasm_global_t*>;
using TableCacheRef = OneOf<M3Table*, wasm_table_t*>;
using FunctionCacheRef = OneOf<M3Function*, wasm_func_t*>;

using JSEnvRef = OneOf<QJSEnv*, JSCEnv*>;

class InteropRuntime {
 public:
  template <typename T, typename U>
  static InteropRuntime* Constructor(T* js_env, U* wasm_runtime) {
#if defined(__APPLE__)
    static_assert(std::is_same_v<T, JSCEnv> || std::is_same_v<T, QJSEnv>);
#else
    static_assert(std::is_same_v<T, QJSEnv>);
#endif
    auto instance = new InteropRuntime(js_env, wasm_runtime);
    wasm_runtime->SetJSEnv(js_env);

    return instance;
  }

  auto& wasm_runtime() { return wasm_runtime_; }

  static void IncreaseRefCount(InteropRuntime*& instance) {
    instance->ref_count_.fetch_add(1, std::memory_order_relaxed);
    WLOGD("Increasing interop runtime ref count..., ref_count_ = %d",
          instance->ref_count_.load(std::memory_order_relaxed));
  }

  static void DecreaseRefCount(InteropRuntime*& instance) {
    WASM_DCHECK(instance->ref_count_.load(std::memory_order_acquire) > 0);
    if (instance->wasm_runtime_.is<PrismRuntime*>()) {
      int remaining =
          instance->ref_count_.fetch_sub(1, std::memory_order_acq_rel) - 1;
      WLOGD("Decreasing interop runtime ref count..., ref_count_ = %d",
            remaining);

      if (remaining == 0) MaybeReleasePrism(instance);
      return;
    }

    // Same rule as the Prism branch above: decide on the decrement's own return
    // value. A separate load lets two threads that drop the last two references
    // both observe zero and both run Destructor.
    const int remaining =
        instance->ref_count_.fetch_sub(1, std::memory_order_acq_rel) - 1;
    WLOGD("Decreasing interop runtime ref count..., ref_count_ = %d",
          remaining);

    if (remaining == 0) {
      Destructor(instance);
    }
  }

  int GetRefCount() const { return ref_count_.load(std::memory_order_acquire); }

#if defined(QJS_UNITTEST)
  static void SetPrismReleaseCountForTesting(InteropRuntime* instance,
                                             std::atomic_int* release_count) {
    instance->prism_release_count_for_testing_ = release_count;
  }
#endif

  // Prism owns all native handles through one store. Requesting release does
  // not delete the store until every JS wrapper has finished its native-only
  // finalizer, so wrapper teardown can never inspect a store-owned handle
  // after the store has been released.
  // The caller keeps its current reference; use this while that owner still
  // remains reachable through the JS root.
  static void RequestPrismRelease(InteropRuntime*& instance) {
    if (!instance || !instance->wasm_runtime_.is<PrismRuntime*>()) return;
    instance->prism_release_requested_.store(true, std::memory_order_release);
    MaybeReleasePrism(instance);
  }

  static void RequestPrismReleaseAndConsumeRef(InteropRuntime*& instance) {
    if (!instance || !instance->wasm_runtime_.is<PrismRuntime*>()) return;

    // The QJS context registry owns one counted reference and transfers it
    // here. Publishing the request before consuming that reference prevents the
    // count from reaching zero and later being resurrected by a release pin.
    // Clear the caller's pointer up front so this ownership token is one-shot.
    auto* owned_instance = instance;
    instance = nullptr;
    owned_instance->prism_release_requested_.store(true,
                                                   std::memory_order_release);
    DecreaseRefCount(owned_instance);
  }

  static void ReleaseJSEnv(InteropRuntime*& instance) {
    if (wasm_unlikely(!instance)) return;

    if (instance->js_env_.is<QJSEnv*>()) {
      auto qjs_env = instance->js_env_.get<QJSEnv*>();
      if (wasm_unlikely(!qjs_env)) return;
      qjs_env->Finalize();
      delete qjs_env;
    }
#if defined(__APPLE__)
    else {
      auto jsc_env = instance->js_env_.get<JSCEnv*>();
      if (wasm_unlikely(!jsc_env)) return;
      jsc_env->Finalize();
      delete jsc_env;
    }
#endif
  }

  static void ReleasePrismJSEnv(InteropRuntime*& instance) {
    if (wasm_unlikely(!instance ||
                      !instance->wasm_runtime_.is<PrismRuntime*>())) {
      return;
    }
    if (instance->js_env_.is<QJSEnv*>()) {
      auto qjs_env = instance->js_env_.get<QJSEnv*>();
      if (qjs_env) {
        qjs_env->Finalize();
        delete qjs_env;
      }
      instance->js_env_ = JSEnvRef(static_cast<QJSEnv*>(nullptr));
    }
#if defined(__APPLE__)
    else {
      auto jsc_env = instance->js_env_.get<JSCEnv*>();
      if (jsc_env) {
        jsc_env->Finalize();
        delete jsc_env;
      }
      instance->js_env_ = JSEnvRef(static_cast<JSCEnv*>(nullptr));
    }
#endif
  }

  static void AbandonJSEnv(InteropRuntime*& instance) {
    if (wasm_unlikely(!instance)) return;
    if (instance->js_env_.is<QJSEnv*>()) {
      delete instance->js_env_.get<QJSEnv*>();
      instance->js_env_ = JSEnvRef(static_cast<QJSEnv*>(nullptr));
    }
#if defined(__APPLE__)
    else {
      delete instance->js_env_.get<JSCEnv*>();
      instance->js_env_ = JSEnvRef(static_cast<JSCEnv*>(nullptr));
    }
#endif
  }

  static void DestroyUnowned(InteropRuntime*& instance) {
    if (wasm_unlikely(!instance)) return;
    WASM_DCHECK(instance->ref_count_.load(std::memory_order_acquire) == 0);
    if (instance->wasm_runtime_.is<PrismRuntime*>()) {
      ReleasePrismJSEnv(instance);
    } else {
      ReleaseJSEnv(instance);
    }
    Destructor(instance);
  }

  InteropRuntime(const InteropRuntime&) = delete;
  InteropRuntime& operator=(const InteropRuntime&) = delete;

  template <class JSEnv>
  bool IsInvalid() {
    WASM_CHECK(js_env_.is<JSEnv*>());
    return js_env_.get<JSEnv*>()->IsInvalid();
  }

  WasmModuleRef CreateWasmModule(uint8_t* data, size_t size,
                                 WasmResult& result) {
#ifdef ENABLE_WASM_PERF_COMPARE
    const bool sample = wasm_perf::ShouldSampleLoad();
    const uint64_t start_ns = sample ? wasm_perf::NowNs() : 0;
#endif
    const bool is_wasm3 = wasm_runtime_.is<Wasm3Runtime*>();
    WasmModuleRef module;
    if (is_wasm3) {
      module = CreateWasm3Module(data, size, result);
    } else {
      module = CreatePrismModule(data, size, result);
    }
#ifdef ENABLE_WASM_PERF_COMPARE
    const uint64_t elapsed_ns = sample ? wasm_perf::ElapsedNs(start_ns) : 0;
    wasm_perf::LoadToken* load_token = nullptr;
    if (is_wasm3) {
      auto* wasm3_module = wasm_perf::TaggedPointerOrNull<Wasm3Module*>(module);
      if (wasm3_module) load_token = &wasm3_module->perf_load();
    } else {
      auto* prism_module = wasm_perf::TaggedPointerOrNull<PrismModule*>(module);
      if (prism_module) load_token = &prism_module->perf_load();
    }
    const bool module_created = result == WasmSucceed && load_token;
    if (module_created) load_token->BeginModuleJourney(sample, elapsed_ns);
    if (!module_created && sample) {
      wasm_perf::ReportFailure(
          MODULE_WASM, DEFAULT_BIZ_NAME,
          is_wasm3 ? "wasm_module_fail_wasm3" : "wasm_module_fail_prism");
    }
#endif
    return module;
  }

  WasmMemoryRef CreateWasmMemory(uint32_t initial, uint32_t maximum,
                                 WasmResult& result) {
    if (wasm_runtime_.is<Wasm3Runtime*>()) {
      return CreateWasm3Memory(initial, maximum, result);
    } else {
      return CreatePrismMemory(initial, maximum, result);
    }
  }

  WasmTableRef CreateWasmTable(uint32_t initial, uint32_t maximum,
                               TableElemType type) {
    if (wasm_runtime_.is<Wasm3Runtime*>()) {
      return CreateWasm3Table(initial, maximum, type);
    } else {
      return CreatePrismTable(initial, maximum, type);
    }
  }

  WasmGlobalRef CreateWasmGlobal(ValueType type, bool mutability,
                                 double number) {
    if (wasm_runtime_.is<Wasm3Runtime*>()) {
      return CreateWasm3Global(type, mutability, number);
    } else {
      return CreatePrismGlobal(type, mutability, number);
    }
  }

  PrismGlobal* CreatePrismGlobalFromValue(bool mutability, wasm_val_t* value) {
    auto prism_runtime = wasm_runtime_.get<PrismRuntime*>();
    return new PrismGlobal(nullptr, mutability, value, prism_runtime);
  }

  template <typename JSEnv>
  WasmInstanceRef CreateWasmInstance(
      WasmModuleRef wasm_module, typename JSEnv::JSObject imports,
      WasmResult& result, typename JSEnv::JSValue* import_exception = nullptr) {
    WASM_CHECK(js_env_.is<JSEnv*>());
    auto js_env = js_env_.get<JSEnv*>();
    const bool is_wasm3 = wasm_runtime_.is<Wasm3Runtime*>();
#ifdef ENABLE_WASM_PERF_COMPARE
    wasm_perf::LoadToken* load_token = nullptr;
    if (is_wasm3) {
      auto* wasm3_module =
          wasm_perf::TaggedPointerOrNull<Wasm3Module*>(wasm_module);
      if (wasm3_module) load_token = &wasm3_module->perf_load();
    } else {
      auto* prism_module =
          wasm_perf::TaggedPointerOrNull<PrismModule*>(wasm_module);
      if (prism_module) load_token = &prism_module->perf_load();
    }
    const bool first_instance_pending =
        load_token && load_token->first_instance_pending();
    // The first instance inherits the module's one decision. Drawing again
    // here would make a first journey 19% likely to be selected. Reused
    // instances draw once from the same sampler as both engines.
    const bool sample_load =
        load_token &&
        (first_instance_pending ? load_token->first_instance_sampled()
                                : wasm_perf::ShouldSampleLoad());
    const uint64_t start_ns = sample_load ? wasm_perf::NowNs() : 0;
#endif

    WasmInstanceRef instance;
    if (is_wasm3) {
      if (wasm_unlikely(!wasm_module.is<Wasm3Module*>())) {
        result = "Wasm module belongs to a different runtime";
        instance = static_cast<Wasm3Instance*>(nullptr);
      } else {
        auto wasm3_module = wasm_module.get<Wasm3Module*>();
        instance = wasm3_module->CreateWasmInstance<JSEnv>(js_env, imports,
                                                           this, result);
      }
    } else {
      auto prism_runtime = wasm_runtime_.get<PrismRuntime*>();
      if (wasm_unlikely(!wasm_module.is<PrismModule*>())) {
        result = "Wasm module belongs to a different runtime";
        instance = static_cast<PrismInstance*>(nullptr);
      } else {
        auto prism_module = wasm_module.get<PrismModule*>();
        if (wasm_unlikely(prism_module->runtime() != prism_runtime)) {
          result = "Prism module belongs to a different runtime";
          instance = static_cast<PrismInstance*>(nullptr);
        } else {
          instance = prism_module->CreateWasmInstance<JSEnv>(
              js_env, imports, this, result, import_exception);
        }
      }
    }
#ifdef ENABLE_WASM_PERF_COMPARE
    const uint64_t elapsed_ns =
        sample_load ? wasm_perf::ElapsedNs(start_ns) : 0;
    wasm_perf::LoadFinishResult load_result;
    if (load_token && result == WasmSucceed) {
      wasm_perf::LoadToken* first_call_token = nullptr;
      if (is_wasm3) {
        auto* wasm3_instance =
            wasm_perf::TaggedPointerOrNull<Wasm3Instance*>(instance);
        if (wasm3_instance) first_call_token = &wasm3_instance->perf_load();
      } else {
        auto* prism_instance =
            wasm_perf::TaggedPointerOrNull<PrismInstance*>(instance);
        if (prism_instance) first_call_token = &prism_instance->perf_load();
      }
      if (first_call_token && first_instance_pending) {
        load_result = load_token->FinishFirstInstance(*first_call_token, true,
                                                      elapsed_ns);
      } else if (first_call_token) {
        load_result = wasm_perf::FinishReusedInstanceJourney(
            *first_call_token, sample_load, true, elapsed_ns);
      }
    }
    if (load_result.sampled) {
      wasm_perf::ReportDuration(
          MODULE_WASM, DEFAULT_BIZ_NAME,
          is_wasm3 ? "wasm_load_ms_wasm3" : "wasm_load_ms_prism",
          wasm_perf::NsToMs(load_result.load_ns));
    } else if (sample_load) {
      wasm_perf::ReportFailure(
          MODULE_WASM, DEFAULT_BIZ_NAME,
          is_wasm3 ? "wasm_instance_fail_wasm3" : "wasm_instance_fail_prism");
    }
#endif
    return instance;
  }

  template <typename JSEnv>
  typename JSEnv::JSValue CallWasmFunction(WasmFunctionRef wasm_function_ref,
                                           size_t argc,
                                           const typename JSEnv::JSValue argv[],
                                           typename JSEnv::JSValue* exception) {
#if defined(__APPLE__)
    static_assert(std::is_same_v<JSEnv, QJSEnv> ||
                  std::is_same_v<JSEnv, JSCEnv>);
#else
    static_assert(std::is_same_v<JSEnv, QJSEnv>);
#endif
    constexpr const char* code = "Call WebAssembly Function";
    WASM_CHECK(js_env_.is<JSEnv*>());
    auto js_env = js_env_.get<JSEnv*>();
#ifndef ENABLE_WASM_PERF_COMPARE
    using JSValue = typename JSEnv::JSValue;
    JSValue result = js_env->MakeUndefined();
    if (wasm_function_ref.is<Wasm3Function*>()) {
      auto function = wasm_function_ref.get<Wasm3Function*>();
      result = function->CallWasmFunction(js_env, argc, argv, code, exception);
    } else {
      auto function = wasm_function_ref.get<PrismFunction*>();
      result = function->CallWasmFunction(js_env, argc, argv, code, exception);
    }
    return result;
#else
    if (wasm_function_ref.is<Wasm3Function*>()) {
      return CallWasmFunctionForEngine<true>(
          js_env, wasm_function_ref.get<Wasm3Function*>(), argc, argv, code,
          exception);
    }
    return CallWasmFunctionForEngine<false>(
        js_env, wasm_function_ref.get<PrismFunction*>(), argc, argv, code,
        exception);
#endif
  }

  template <typename JSEnv>
  int CreateJSExports(typename JSEnv::JSObject obj, WasmModuleRef module,
                      WasmInstanceRef instance) {
    WLOGD("Running %s...", __func__);

    if (wasm_runtime_.is<Wasm3Runtime*>()) {
      auto wasm3_module = module.get<Wasm3Module*>();
      auto wasm3_instance = instance.get<Wasm3Instance*>();
      return CreateJSWasm3Exports<JSEnv>(obj, wasm3_module, wasm3_instance);
    } else {
      auto prism_module = module.get<PrismModule*>();
      auto prism_instance = instance.get<PrismInstance*>();
      return CreateJSPrismExports<JSEnv>(obj, prism_module, prism_instance);
    }
  }

  template <typename JSEnv>
  int CreateJSWasm3Exports(typename JSEnv::JSObject exports,
                           Wasm3Module* module, Wasm3Instance* instance) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;

    WASM_CHECK(js_env_.is<JSEnv*>());
    auto js_env = js_env_.get<JSEnv*>();
    auto wasm3_runtime = wasm_runtime_.get<Wasm3Runtime*>();

    IM3Module m3_instance = instance->instance();
    M3ExportedFunction* cur = m3_instance->exportedFuncs;

    while (cur) {
      IM3Function m3_function = cur->func;
      if (!m3_function) {
        cur = cur->next;
        continue;
      }
      int start_index = m3_function->import.fieldUtf8 ? 1 : 0;

      auto wasm3_function =
          new Wasm3Function(m3_function, wasm3_runtime, instance);

      JSObject func_obj = js_env->MakeWasmFunction(
          this, m3_function->names[start_index], wasm3_function);
      if (js_env->IsNull(func_obj)) {
        WLOGE("MakeFunction %s failed!", m3_function->names[start_index]);
        delete wasm3_function;
        return 1;
      }

      // Add a new Exported Function from funcaddr.
      auto& func_cache = js_env->wasm_func_cache();
      uintptr_t ptr = reinterpret_cast<uintptr_t>(m3_function);
      if (!func_cache.count(ptr)) {
        func_cache[ptr] = js_env->DupValue(func_obj);
      } else if (!js_env->IsWasmFunction(func_cache[ptr])) {
        auto func_data = new Wasm3Function(func_cache[ptr], wasm3_runtime,
                                           instance, m3_function);
        func_cache[ptr] = js_env->MakeWasmFunction(this, nullptr, func_data);
      }

      // If the function has multiple names, we add it under each name.
      for (int i = start_index; i < m3_function->numNames; ++i) {
        WLOGD("Wasm3Runtime Exporting function: `%s`", m3_function->names[i]);
        if (wasm_unlikely(
                !js_env->SetProperty(exports, m3_function->names[i],
                                     js_env->DupValue(func_cache[ptr])))) {
          WLOGE("exports set function %s failed!", m3_function->names[i]);
          js_env->FreeValue(func_cache[ptr]);
          return 1;
        }
      }

      js_env->FreeValue(func_obj);
      cur = cur->next;
    }

    // Exporting Memory
    if (m3_instance->memoryNameCount) {
      IM3Memory m3_memory = m3_instance->memory;

      JSObject memory_obj{};

      auto& memory_cache = js_env->wasm_memory_cache();
      uintptr_t ptr = reinterpret_cast<uintptr_t>(m3_memory);
      if (memory_cache.count(ptr)) {
        JSObject cached_obj = memory_cache[ptr];
        memory_obj = js_env->DupValue(cached_obj);
      } else {
        auto wasm3_memory = new Wasm3Memory(wasm3_runtime, m3_instance->memory);
        memory_obj =
            js_env->MakeWasmMemory(this, wasm3_memory, wasm3_memory->pages());
        memory_cache[ptr] = js_env->DupValue(memory_obj);
        if (wasm_unlikely(js_env->IsNull(memory_obj))) {
          delete wasm3_memory;
          return 1;
        }
      }

      for (uint8_t idx = 0; idx < m3_instance->memoryNameCount; idx++) {
        WLOGD("Exporting memory: `%s`", m3_instance->memoryNames[idx]);
        if (wasm_unlikely(!js_env->SetProperty(exports,
                                               m3_instance->memoryNames[idx],
                                               js_env->DupValue(memory_obj)))) {
          WLOGE("exports set memory %s failed", m3_instance->memoryNames[idx]);
          js_env->FreeValue(memory_obj);
          return 1;
        }
      }

      js_env->FreeValue(memory_obj);
    }

    // Exporting Table
    // if table0 exported, make WasmTable for exports.
    if (m3_instance->tableInfo.tableName) {
      WLOGD("Wasm3Runtime Exporting table: `%s`",
            m3_instance->tableInfo.tableName);

      IM3Table m3_table = m3_GetTable(m3_instance);
      JSObject table_obj{};

      auto& table_cache = js_env->wasm_table_cache();
      uintptr_t ptr = reinterpret_cast<uintptr_t>(m3_table);
      if (table_cache.count(ptr)) {
        table_obj = js_env->DupValue(table_cache[ptr]);
      } else {
        auto wasm3_table = new Wasm3Table(wasm3_runtime, m3_table, instance);
        if (wasm_unlikely(!m3_table)) return 1;
        table_obj = js_env->MakeWasmTable(this, wasm3_table);
        if (wasm_unlikely(js_env->IsNull(table_obj))) {
          delete wasm3_table;
          return 1;
        }
      }

      if (wasm_unlikely(!js_env->SetProperty(
              exports, m3_instance->tableInfo.tableName, table_obj))) {
        WLOGE("WasmRuntime: SetProperty for exported table %s failed",
              m3_instance->tableInfo.tableName);
        return 1;
      }
    }

    for (int i = 0; i < m3_instance->numGlobals; i++) {
      IM3Global m3_global = m3_instance->globals + i;
      if (m3_global->name) {
        WLOGD("Wasm3Runtime Exporting global: `%s`", m3_global->name);

        JSObject global_obj{};

        auto& global_cache = js_env->wasm_global_cache();
        uintptr_t ptr = reinterpret_cast<uintptr_t>(m3_global);
        if (global_cache.count(ptr)) {
          global_obj = js_env->DupValue(global_cache[ptr]);
        } else {
          auto wasm3_global = new Wasm3Global(
              wasm3_runtime, m3_instance->globals + i, instance);
          global_obj = js_env->MakeWasmGlobal(this, wasm3_global);
          if (wasm_unlikely(js_env->IsNull(global_obj))) {
            delete wasm3_global;
            return 1;
          }
        }

        if (wasm_unlikely(
                !js_env->SetProperty(exports, m3_global->name, global_obj))) {
          WLOGE("WasmRuntime: SetProperty for exported global %s failed",
                m3_global->name);
          return 1;
        }
      }
    }

    return 0;
  }

  template <typename JSEnv>
  int CreateJSPrismExports(typename JSEnv::JSObject obj, PrismModule* module,
                           PrismInstance* instance) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;

    if (wasm_unlikely(!module || !instance)) {
      return 1;
    }

    WASM_CHECK(js_env_.is<JSEnv*>());
    auto js_env = js_env_.get<JSEnv*>();
    auto prism_runtime = wasm_runtime_.get<PrismRuntime*>();

    wasm_module_t* prism_module = module->module();
    wasm_instance_t* prism_instance = instance->instance();
    wasm_extern_vec_t exports{};
    wasm_instance_exports(prism_instance, &exports);
    // Prism returns fresh owned handles, even for cached imports or aliases.
    // Cache hits borrow the existing JS wrapper and leave the fresh handle in
    // this vector for deletion. Only a new wrapper takes ownership below.
    struct ExternVecScope {
      wasm_extern_vec_t* vec;
      ~ExternVecScope() { wasm_extern_vec_delete(vec); }
    } exports_scope{&exports};

    wasm_exporttype_vec_t export_types{};
    wasm_module_exports(prism_module, &export_types);
    struct ExportTypeVecScope {
      wasm_exporttype_vec_t* vec;
      ~ExportTypeVecScope() { wasm_exporttype_vec_delete(vec); }
    } export_types_scope{&export_types};

#if defined(QJS_UNITTEST)
    if (PrismInstance::fail_export_after_for_testing_ == 0) return 1;
#endif
    if (wasm_unlikely(exports.size != export_types.size)) {
      WLOGE("Prism export count does not match module metadata");
      return 1;
    }

    size_t export_size = exports.size;
    for (size_t i = 0; i < export_size; ++i) {
      const wasm_externtype_t* type =
          wasm_exporttype_type(export_types.data[i]);
      const wasm_name_t* name = wasm_exporttype_name(export_types.data[i]);

      // Start without a GC handle. A cached function is a borrowed value;
      // converting undefined to an object first would create an exception
      // handle, then overwrite its runtime with the borrowed value's nullptr.
      JSObject prop{};
      bool release_qjs_prop = false;
      if (wasm_unlikely(exports.data[i] == nullptr || type == nullptr)) {
        return 1;
      }
      assert(wasm_extern_kind(exports.data[i]) == wasm_externtype_kind(type));

      switch (wasm_externtype_kind(type)) {
        case WASM_EXTERN_FUNC: {
          wasm_func_t* w_func = wasm_extern_as_func(exports.data[i]);
          prism_func* p_func = prism_get_func(w_func);
          uintptr_t ptr = reinterpret_cast<uintptr_t>(p_func);
          if (!prism_runtime->GetExportFunctionObject<JSEnv>(ptr, &prop) ||
              !js_env->IsWasmFunction(prop)) {
            PrismFunction* func =
                new PrismFunction(w_func, prism_runtime, instance, true);
            exports.data[i] = nullptr;
            std::string func_name(name->data, name->size);
            prop = js_env->MakeWasmFunction(this, func_name.c_str(), func);
            if (wasm_unlikely(js_env->IsNull(prop))) {
              WLOGE("MakeFunction %s failed!", func_name.c_str());
              delete func;
              return 1;
            }
            prism_runtime->CacheExportFunctionObject<JSEnv>(ptr, prop);
            if constexpr (std::is_same_v<JSEnv, QJSEnv>) {
              release_qjs_prop = true;
            }
          }
        } break;
        case WASM_EXTERN_TABLE: {
          wasm_table_t* table = wasm_extern_as_table(exports.data[i]);
          auto& tab_cache = js_env->wasm_table_cache();
          prism_table* p_tab = prism_get_table(table);
          uintptr_t ptr = reinterpret_cast<uintptr_t>(p_tab);
          if (tab_cache.count(ptr)) {
            prop = tab_cache[ptr];
          } else {
            PrismTable* tbl = new PrismTable(prism_runtime, table, instance);
            exports.data[i] = nullptr;
            prop = js_env->MakeWasmTable(this, tbl);
            if (wasm_unlikely(js_env->IsNull(prop))) {
              delete tbl;
              return 1;
            }
            if constexpr (std::is_same_v<JSEnv, QJSEnv>) {
              tab_cache[ptr] = prop;
            } else {
              tab_cache[ptr] = js_env->DupValue(prop);
            }
          }
        } break;
        case WASM_EXTERN_MEMORY: {
          wasm_memory_t* memory = wasm_extern_as_memory(exports.data[i]);
          auto& mem_cache = js_env->wasm_memory_cache();
          prism_mem_info* minfo = prism_get_memory(memory);
          uintptr_t ptr = reinterpret_cast<uintptr_t>(minfo);
          if (mem_cache.count(ptr)) {
            prop = mem_cache[ptr];
          } else {
            wasm_limits_t limits{};
            if (!PrismInstance::ReadMemoryTypeLimits(type, &limits)) {
              return 1;
            }
            PrismMemory* mem_wrapper =
                new PrismMemory(memory, prism_runtime, instance, limits.max);
            exports.data[i] = nullptr;
            prop =
                js_env->MakeWasmMemory(this, mem_wrapper, mem_wrapper->pages());
            if (wasm_unlikely(js_env->IsNull(prop))) {
              delete mem_wrapper;
              return 1;
            }
            if constexpr (std::is_same_v<JSEnv, QJSEnv>) {
              mem_cache[ptr] = prop;
            } else {
              mem_cache[ptr] = js_env->DupValue(prop);
            }
          }
        } break;
        case WASM_EXTERN_GLOBAL: {
          wasm_global_t* global = wasm_extern_as_global(exports.data[i]);
          prism_global* gbl = prism_get_global_ptr(global);
          auto& global_cache = js_env->wasm_global_cache();
          uintptr_t ptr = reinterpret_cast<uintptr_t>(gbl);
          if (global_cache.count(ptr)) {
            prop = global_cache[ptr];
          } else {
            wasm_val_t val;
            wasm_global_get(global, &val);
            bool mutability = PrismGlobal::mutability(global);
            PrismGlobal* gbl = new PrismGlobal(global, mutability, &val,
                                               prism_runtime, instance);
            exports.data[i] = nullptr;
            prop = js_env->MakeWasmGlobal(this, gbl);
            if (wasm_unlikely(js_env->IsNull(prop))) {
              delete gbl;
              return 1;
            }
            if constexpr (std::is_same_v<JSEnv, QJSEnv>) {
              global_cache[ptr] = prop;
            } else {
              global_cache[ptr] = js_env->DupValue(prop);
            }
          }
        } break;
        default:
          assert(false && "unreachable code.");
      }
      std::string prop_name_str(name->data, name->size);
      WLOGD("Exporting %s: `%s`",
            wasm::ExternKindName(wasm_externtype_kind(type)),
            prop_name_str.c_str());
      JSValue property_value = prop;
      if constexpr (std::is_same_v<JSEnv, QJSEnv>) {
        property_value = js_env->DupValue(prop);
      }
      if (wasm_unlikely(!js_env->SetProperty(obj, prop_name_str.c_str(),
                                             property_value))) {
        WLOGE("Exporting %s `%s` failed",
              wasm::ExternKindName(wasm_externtype_kind(type)),
              prop_name_str.c_str());
        if constexpr (std::is_same_v<JSEnv, QJSEnv>) {
          if (release_qjs_prop) {
            js_env->FreeValue(prop);
          }
        }
        return 1;
      }
      if (release_qjs_prop) {
        js_env->FreeValue(prop);
      }
#if defined(QJS_UNITTEST)
      if (PrismInstance::fail_export_after_for_testing_ ==
          static_cast<int>(i + 1)) {
        return 1;
      }
#endif
    }
    return 0;
  }

  // module
  Wasm3Module* CreateWasm3Module(uint8_t* data, size_t len,
                                 WasmResult& result) {
    auto runtime = wasm_runtime_.get<Wasm3Runtime*>();
    auto m3_env = runtime->m3_env();

    if (wasm_unlikely(!m3_env) && runtime->InitRuntime()) {
      return nullptr;
    }

    IM3Module module = nullptr;

    result = WasmSucceed;
    runtime->ParseWasmModule(&module, data, len, result);
    if (result) {
      WLOGE("m3_ParseModule failed: %s", result);
      return nullptr;
    }

    return new Wasm3Module(data, len, module, runtime);
  }

  PrismModule* CreatePrismModule(void* data, size_t len, WasmResult& result) {
    auto prism_runtime = wasm_runtime_.get<PrismRuntime*>();
    wasm_byte_vec_t binary;
    binary.size = len;
    binary.data = static_cast<char*>(data);

    wasm_module_t* module =
        wasm_module_new(prism_runtime->wasm_store(), &binary);
    if (wasm_unlikely(module == nullptr)) {
      result = "Create prism module failed!";
      return nullptr;
    }
    result = WasmSucceed;
    return new PrismModule(module, prism_runtime);
  }
  // table
  Wasm3Table* CreateWasm3Table(uint32_t initial, uint32_t maximum,
                               TableElemType type) {
    // only support funcref yet.
    WASM_DCHECK(type == TableElemType::kFuncRef);

    auto runtime = wasm_runtime_.get<Wasm3Runtime*>();
    auto m3_env = runtime->m3_env();

    if (wasm_unlikely(!m3_env) && runtime->InitRuntime()) {
      return nullptr;
    }

    WLOGD("Wasm3Runtime Creating table { initial: %u, maximum: %u, type: %d }",
          initial, maximum, type);

    M3Result result = m3Err_none;
    auto table = new Wasm3Table(runtime, initial, maximum, type, &result);
    if (result || !table->valid()) {
      WLOGE("Failed to create table in wasm runtime: %s", result);
      delete table;
      return nullptr;
    }

    return table;
  }
  PrismTable* CreatePrismTable(uint32_t initial, uint32_t maximum,
                               TableElemType type) {
    auto prism_runtime = wasm_runtime_.get<PrismRuntime*>();

    // only support funcref yet.
    WASM_DCHECK(type == TableElemType::kFuncRef);
    WLOGD("CreateWasmTable with initial:%u, maximum: %u, type:%d", initial,
          maximum, type);
    auto table = new PrismTable(prism_runtime, initial, maximum, nullptr);
    if (!table->valid()) {
      delete table;
      return nullptr;
    }
    return table;
  }
  // memory
  Wasm3Memory* CreateWasm3Memory(uint32_t initial, uint32_t maximum,
                                 WasmResult& result) {
    WLOGD("Running InteropRuntime::%s... Creating memory { init: %u, max: %u }",
          __func__, initial, maximum);

    auto runtime = wasm_runtime_.get<Wasm3Runtime*>();
    auto m3_env = runtime->m3_env();

    if (wasm_unlikely(!m3_env) && runtime->InitRuntime()) {
      return nullptr;
    }

    result = WasmSucceed;
    auto memory = new Wasm3Memory(runtime, initial, maximum, result);
    if (result) {
      delete memory;
      return nullptr;
    }

    return memory;
  }

  PrismMemory* CreatePrismMemory(uint32_t initial, uint32_t maximum,
                                 WasmResult& result) {
    auto prism_runtime = wasm_runtime_.get<PrismRuntime*>();
    auto memory = new PrismMemory(prism_runtime, initial, maximum);
    if (!memory->valid()) {
      delete memory;
      result = "Create prism memory failed!";
      return nullptr;
    }
    result = WasmSucceed;
    return memory;
  }
  // global
  Wasm3Global* CreateWasm3Global(ValueType type, bool mutability,
                                 double number) {
    auto runtime = wasm_runtime_.get<Wasm3Runtime*>();
    auto m3_env = runtime->m3_env();

    if (wasm_unlikely(!m3_env) && runtime->InitRuntime()) {
      return nullptr;
    }

    return new Wasm3Global(runtime, mutability, number, type);
  }

  PrismGlobal* CreatePrismGlobal(ValueType type, bool mutability,
                                 double number) {
    auto prism_runtime = wasm_runtime_.get<PrismRuntime*>();

    wasm_val_t val = WASM_INIT_VAL;
    val.kind = prism_runtime->WasmType(type);
    prism_runtime->NumberToWasm(number, &val);
    return new PrismGlobal(nullptr, mutability, &val, prism_runtime);
  }

  template <typename T>
  T js_env() {
#if defined(__APPLE__)
    static_assert(std::is_same_v<T, QJSEnv*> || std::is_same_v<T, JSCEnv*>);
#else
    static_assert(std::is_same_v<T, QJSEnv*>);
#endif
    WASM_CHECK(js_env_.is<T>());
    return js_env_.get<T>();
  }

  template <typename T>
  T wasm_runtime() {
    static_assert(std::is_same_v<T, Wasm3Runtime*> ||
                  std::is_same_v<T, PrismRuntime*>);
    return wasm_runtime_.get<T>();
  }

  uintptr_t GetMemoryPtr(WasmMemoryRef memory) {
    uintptr_t ptr = 0;
    if (memory.is<Wasm3Memory*>()) {
      auto wasm3_memory = memory.get<Wasm3Memory*>();
      ptr = reinterpret_cast<uintptr_t>(wasm3_memory->memory());
    } else {
      auto prism_memory = memory.get<PrismMemory*>();
      ptr = reinterpret_cast<uintptr_t>(prism_memory->memory());
    }
    return ptr;
  }

  uint8_t* GetMemoryBuffer(WasmMemoryRef memory, size_t& pages) {
    uint8_t* buffer = nullptr;
    if (memory.is<Wasm3Memory*>()) {
      auto wasm3_memory = memory.get<Wasm3Memory*>();
      buffer = static_cast<uint8_t*>(wasm3_memory->buffer());
      pages = wasm3_memory->pages();
    } else {
      auto prism_memory = memory.get<PrismMemory*>();
      buffer = static_cast<uint8_t*>(prism_memory->buffer());
      pages = prism_memory->pages();
    }
    return buffer;
  }

 private:
#ifdef ENABLE_WASM_PERF_COMPARE
  template <bool IsWasm3, typename JSEnv, typename Function>
  typename JSEnv::JSValue CallWasmFunctionForEngine(
      JSEnv* js_env, Function* function, size_t argc,
      const typename JSEnv::JSValue argv[], const char* code,
      typename JSEnv::JSValue* exception) {
    using JSValue = typename JSEnv::JSValue;
    JSValue result = js_env->MakeUndefined();
    auto& call_state = function->perf_call_state();
    const wasm_perf::CallSampleKind sample_kind =
        wasm_perf::BeginCall(call_state);
    auto* perf_instance = function->perf_instance();
    const uint64_t claimed_load =
        sample_kind == wasm_perf::CallSampleKind::kFirstAttempt && perf_instance
            ? perf_instance->perf_load().TryClaim()
            : 0;
    const bool sample_load = wasm_perf::LoadToken::OwnsClaim(claimed_load);
    const bool sample_call =
        sample_kind == wasm_perf::CallSampleKind::kSteady || sample_load;
    const uint64_t call_start_ns = sample_call ? wasm_perf::NowNs() : 0;

    result = function->CallWasmFunction(js_env, argc, argv, code, exception);

    if (sample_kind != wasm_perf::CallSampleKind::kNone) {
      const uint64_t elapsed_ns =
          sample_call ? wasm_perf::ElapsedNs(call_start_ns) : 0;
      bool failed = false;
      if constexpr (std::is_same_v<JSEnv, QJSEnv>) {
        failed = (exception && !js_env->IsUndefined(*exception)) ||
                 js_env->IsException(result);
      }
      // On non-Apple builds the static_assert in CallWasmFunction forces
      // JSEnv == QJSEnv. On Apple this branch handles JSC's exception slot.
#if defined(__APPLE__)
      else {
        failed = (exception && *exception != nullptr);
      }
#endif

      if (sample_kind == wasm_perf::CallSampleKind::kFirstAttempt) {
        auto* load_token =
            perf_instance ? &perf_instance->perf_load() : nullptr;
        const wasm_perf::FirstCallResult first_attempt =
            wasm_perf::FinishFirstAttempt(call_state, load_token, claimed_load,
                                          !failed, elapsed_ns);
        if (first_attempt.completed_first_call) {
          constexpr const char* kFirstCallKey =
              IsWasm3 ? "wasm_first_call_ms_wasm3" : "wasm_first_call_ms_prism";
          wasm_perf::ReportDuration(
              MODULE_WASM, DEFAULT_BIZ_NAME, kFirstCallKey,
              wasm_perf::NsToMs(first_attempt.first_call_ns));
        } else if (first_attempt.sampled_failure) {
          constexpr const char* kCallFailKey =
              IsWasm3 ? "wasm_call_fail_wasm3" : "wasm_call_fail_prism";
          wasm_perf::ReportFailure(MODULE_WASM, DEFAULT_BIZ_NAME, kCallFailKey);
        }
      } else {
        wasm_perf::FinishCall(call_state, sample_kind, !failed);
        if (failed) {
          constexpr const char* kCallFailKey =
              IsWasm3 ? "wasm_call_fail_wasm3" : "wasm_call_fail_prism";
          wasm_perf::ReportFailure(MODULE_WASM, DEFAULT_BIZ_NAME, kCallFailKey);
        } else {
          constexpr const char* kCallKey = IsWasm3
                                               ? "wasm_steady_call_ms_wasm3"
                                               : "wasm_steady_call_ms_prism";
          wasm_perf::ReportDuration(MODULE_WASM, DEFAULT_BIZ_NAME, kCallKey,
                                    wasm_perf::NsToMs(elapsed_ns));
        }
      }
    }
    return result;
  }
#endif

  static void Destructor(InteropRuntime*& instance) {
    WLOGD("Destroying interop runtime instance...");
    delete instance;
    instance = nullptr;
  }

  static void MaybeReleasePrism(InteropRuntime*& instance) {
    // Only the caller whose own fetch_sub observed zero reaches this point.
    // That transition is the release credential. A second object-local claim
    // would be too late to protect a contender from dereferencing freed memory.
    if (!instance ||
        !instance->prism_release_requested_.load(std::memory_order_acquire) ||
        instance->ref_count_.load(std::memory_order_acquire) != 0) {
      return;
    }
    WASM_DCHECK(instance->ref_count_.load(std::memory_order_acquire) == 0);
    auto* prism = instance->wasm_runtime_.get<PrismRuntime*>();
#if defined(QJS_UNITTEST)
    if (auto* count = instance->prism_release_count_for_testing_) {
      count->fetch_add(1, std::memory_order_acq_rel);
    }
#endif
    if (prism) prism->ReleaseStore();
    Destructor(instance);
  }

  template <typename JSEnv, typename WRuntime>
  InteropRuntime(JSEnv* js_env, WRuntime* wasm_runtime) {
#if defined(__APPLE__)
    static_assert(std::is_same_v<JSEnv, QJSEnv> ||
                  std::is_same_v<JSEnv, JSCEnv>);
#else
    static_assert(std::is_same_v<JSEnv, QJSEnv>);
#endif
    static_assert(std::is_same_v<WRuntime, Wasm3Runtime> ||
                  std::is_same_v<WRuntime, PrismRuntime>);

    js_env_ = js_env;
    wasm_runtime_ = wasm_runtime;
  }

  ~InteropRuntime() {
    if (wasm_runtime_.is<PrismRuntime*>()) {
      delete wasm_runtime_.get<PrismRuntime*>();
    } else {
      delete wasm_runtime_.get<Wasm3Runtime*>();
    }
  }

  // Only Freed by global.WebAssembly.Finalize()
  BORROWER JSEnvRef js_env_;

  OWNER WasmRuntimeRef wasm_runtime_;
  // refcount of interop runtime, only all borrower destroyed, interop runtime
  // will be destroyed
  std::atomic_int ref_count_{0};
  std::atomic_bool prism_release_requested_{false};
#if defined(QJS_UNITTEST)
  std::atomic_int* prism_release_count_for_testing_{nullptr};
#endif
};
}  // namespace primjs

#endif  // SRC_WASM_COMMON_INTEROP_RUNTIME_H_
