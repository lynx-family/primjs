// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_PRISM_WASM_INSTANCE_H_
#define SRC_WASM_RUNTIME_PRISM_WASM_INSTANCE_H_

#include <atomic>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <type_traits>
#include <vector>

#ifdef ENABLE_WASM_PERF_COMPARE
#include "common/interop_runtime_perf.h"
#endif
#include "common/js_type.h"
#include "common/wasm_utils.h"
#include "prism/prism.h"
#include "prism/wasm_c_api.h"
#include "runtime/prism/wasm_function.h"
#include "runtime/prism/wasm_global.h"
#include "runtime/prism/wasm_memory.h"
#include "runtime/prism/wasm_table.h"

namespace primjs {
class InteropRuntime;
namespace qjs {
class QJSEnv;
}

namespace wasm {
class PrismRuntime;

enum class PrismImportBindingMode {
  kOwnedDescriptors,
  kBorrowedAllFunctions,
};

#if defined(QJS_UNITTEST) && !defined(ENABLE_WASM_PERF_TEST_CAPTURE)
class PrismImportBindingCountersForTesting {
 public:
  static void Reset() {
    borrowed_view_calls_.store(0, std::memory_order_relaxed);
    owned_descriptor_enumerations_.store(0, std::memory_order_relaxed);
    rolled_back_function_handles_.store(0, std::memory_order_relaxed);
    rolled_back_callback_roots_.store(0, std::memory_order_relaxed);
  }

  static void RecordBorrowedViewCall() {
    borrowed_view_calls_.fetch_add(1, std::memory_order_relaxed);
  }

  static void RecordOwnedDescriptorEnumeration() {
    owned_descriptor_enumerations_.fetch_add(1, std::memory_order_relaxed);
  }

  static void RecordRolledBackFunctionHandle() {
    rolled_back_function_handles_.fetch_add(1, std::memory_order_relaxed);
  }

  static void RecordRolledBackCallbackRoots(size_t count) {
    rolled_back_callback_roots_.fetch_add(count, std::memory_order_relaxed);
  }

  static size_t BorrowedViewCalls() {
    return borrowed_view_calls_.load(std::memory_order_relaxed);
  }

  static size_t OwnedDescriptorEnumerations() {
    return owned_descriptor_enumerations_.load(std::memory_order_relaxed);
  }

  static size_t RolledBackFunctionHandles() {
    return rolled_back_function_handles_.load(std::memory_order_relaxed);
  }

  static size_t RolledBackCallbackRoots() {
    return rolled_back_callback_roots_.load(std::memory_order_relaxed);
  }

 private:
  inline static std::atomic<size_t> borrowed_view_calls_{0};
  inline static std::atomic<size_t> owned_descriptor_enumerations_{0};
  inline static std::atomic<size_t> rolled_back_function_handles_{0};
  inline static std::atomic<size_t> rolled_back_callback_roots_{0};
};
#endif

class PrismInstance {
 public:
  PrismInstance(PrismRuntime* rt);
  ~PrismInstance();

  static void IncreaseRefCount(PrismInstance*& instance);
  static void DecreaseRefCount(PrismInstance*& instance);
  static void Destructor(PrismInstance*& instance);

#if defined(QJS_UNITTEST)
  inline static std::atomic_int live_instances_for_testing_{0};
  inline static thread_local int fail_export_after_for_testing_ = -1;
#endif

  wasm_instance_t* instance() const { return instance_; }
  wasm_instance_t** instance_ptr() { return &instance_; }
  void set_instance(wasm_instance_t* instance) { instance_ = instance; }

#ifdef ENABLE_WASM_PERF_COMPARE
  wasm_perf::LoadToken& perf_load() { return perf_load_; }
#endif

  // Prism 1.1.6 publishes wasm_memorytype_limits in its header but does not
  // export the symbol. Its memory type is the standard C-API layout used by
  // wasm_memorytype_new and wasm_module_imports/exports: kind, then limits.
  // Keep this compatibility read local to the pinned Prism version and copy
  // the bytes to avoid aliasing through an opaque public type.
  static bool ReadMemoryTypeLimits(const wasm_externtype_t* type,
                                   wasm_limits_t* limits) {
    struct MemoryTypeLayout {
      wasm_externkind_enum kind;
      wasm_limits_t limits;
    };
    static_assert(offsetof(MemoryTypeLayout, limits) ==
                  sizeof(wasm_externkind_enum));
    if (!type || !limits || wasm_externtype_kind(type) != WASM_EXTERN_MEMORY) {
      return false;
    }
    std::memcpy(limits,
                reinterpret_cast<const uint8_t*>(type) +
                    offsetof(MemoryTypeLayout, limits),
                sizeof(*limits));
    return true;
  }

  template <typename JSEnv>
  void CacheFunctionObject(JSEnv* js_env, uintptr_t ptr,
                           typename JSEnv::JSObject func_obj) {
    auto& func_cache = js_env->wasm_func_cache();
    if (func_cache.count(ptr)) {
      js_env->FreeValue(func_cache[ptr]);
    }
    func_cache[ptr] = js_env->DupValue(func_obj);
  }

  template <typename JSEnv>
  void CacheImportedWasmFunctionObject(size_t index,
                                       typename JSEnv::JSObject func_obj) {
    if (imported_wasm_functions_.size() <= index) {
      imported_wasm_functions_.resize(index + 1);
    }
    auto& entry = imported_wasm_functions_[index];
    if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
      entry.kind = ExportFunctionCacheEntry::Kind::kQJS;
      entry.qjs_value = func_obj.Get();
    } else {
      entry.kind = ExportFunctionCacheEntry::Kind::kJSC;
      entry.jsc_object = func_obj;
    }
  }

  template <typename JSEnv>
  void CacheLinkedImportFunctionObjects(JSEnv* js_env) {
    for (size_t i = 0; i < imported_wasm_functions_.size(); ++i) {
      auto& entry = imported_wasm_functions_[i];
      typename JSEnv::JSObject func_obj{};
      if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
        if (entry.kind != ExportFunctionCacheEntry::Kind::kQJS) continue;
        func_obj = typename JSEnv::JSObject(entry.qjs_value);
      } else {
        if (entry.kind != ExportFunctionCacheEntry::Kind::kJSC) continue;
        func_obj = entry.jsc_object;
      }
      prism_func* func = prism_get_func_ptr(instance_, i);
      if (!func) continue;
      uintptr_t ptr = reinterpret_cast<uintptr_t>(func);
      CacheFunctionObject(js_env, ptr, func_obj);
      runtime_->CacheExportFunctionObject<JSEnv>(ptr, func_obj);
    }
  }

  template <typename JSEnv>
  int BindImports(JSEnv* js_env, const typename JSEnv::JSObject import_obj,
                  InteropRuntime* interop, wasm_importtype_vec_t* iv,
                  PrismImportBindingMode binding_mode, wasm_extern_t** imports,
                  std::vector<wasm_global_t*>* generated_import_globals,
                  uint64_t callback_root_transaction, wasm_module_t* w_mod,
                  PrismInstance* instance,
                  typename JSEnv::JSValue* import_exception) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;
    uint32_t func_idx = 0;

    auto limits_match = [](const wasm_limits_t* expected, uint32_t actual_min,
                           uint32_t actual_max) {
      if (!expected || actual_min < expected->min) return false;
      return expected->max == wasm_limits_max_default ||
             (actual_max != wasm_limits_max_default &&
              actual_max <= expected->max);
    };

    auto link_error = [&](const char* message) {
      if (import_exception) {
        JSValue exception = js_env->MakeNull();
        js_env->MakeException(ErrorTypes::kError, "new WebAssembly.Instance()",
                              message, &exception);
        *import_exception = exception;
      }
      return 1;
    };

    if (wasm_unlikely(!js_env->IsObject(import_obj))) return 1;

    const bool use_borrowed_function_imports =
        binding_mode == PrismImportBindingMode::kBorrowedAllFunctions;
    size_t import_count = 0;
    if (use_borrowed_function_imports) {
      if (wasm_unlikely(w_mod == nullptr ||
                        !prism_module_imports_are_all_functions(w_mod))) {
        return 1;
      }
      import_count = prism_module_import_count(w_mod);
    } else {
      if (wasm_unlikely(iv == nullptr)) return 1;
      import_count = iv->size;
    }

    // do not consider importing tables & memories here
    for (size_t i = 0; i < import_count; ++i) {
      // TODO(wasm): consider to introduce a fast way to bind imports
      //  without comparing their names, based on a hypothosis that imports
      //  are assigned in a right order.
      const wasm_externtype_t* ity = nullptr;
      wasm_externkind_t e_kind;
      const char* module_name = nullptr;
      size_t module_name_size = 0;
      const char* field_name = nullptr;
      size_t field_name_size = 0;
      if (use_borrowed_function_imports) {
#if defined(QJS_UNITTEST) && !defined(ENABLE_WASM_PERF_TEST_CAPTURE)
        PrismImportBindingCountersForTesting::RecordBorrowedViewCall();
#endif
        prism_module_import_view view{};
        if (wasm_unlikely(!prism_module_import_borrow(w_mod, i, &view) ||
                          view.kind != WASM_EXTERN_FUNC)) {
          return 1;
        }
        e_kind = view.kind;
        module_name = view.module_name;
        module_name_size = view.module_name_size;
        field_name = view.field_name;
        field_name_size = view.field_name_size;
      } else {
        wasm_importtype_t* import_type = iv->data[i];
        ity = wasm_importtype_type(import_type);
        e_kind = wasm_externtype_kind(ity);
        const wasm_name_t* name = wasm_importtype_module(import_type);
        module_name = name->data;
        module_name_size = name->size;
        name = wasm_importtype_name(import_type);
        field_name = name->data;
        field_name_size = name->size;
      }
      JSValue bind_target =
          LookupImport(js_env, import_obj, module_name, module_name_size,
                       field_name, field_name_size, import_exception);
      struct BindTargetGuard {
        JSEnv* env;
        JSValue value;
        ~BindTargetGuard() {
          if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
            env->ReleaseValue(value);
          }
        }
      } bind_target_guard{js_env, bind_target};
      if (import_exception && !js_env->IsNull(*import_exception)) {
        return 1;
      }
      switch (e_kind) {
        case WASM_EXTERN_FUNC: {
          JSObject func_obj = js_env->ValueToFunction(bind_target);
          if (wasm_unlikely(js_env->IsNull(func_obj))) {
            return link_error("function import requires a callable value");
          }
          const wasm_functype_t* fty =
              use_borrowed_function_imports
                  ? nullptr
                  : wasm_externtype_as_functype_const(ity);
          bool reuse_wasm_function = false;
          if (js_env->IsWasmFunction(func_obj)) {
            WasmFunctionRef wasm_function = js_env->GetWasmFunction(func_obj);
            if (!wasm_function.is<PrismFunction*>()) {
              return link_error("function import uses a different runtime");
            }
            PrismFunction* prism_function = wasm_function.get<PrismFunction*>();
            wasm_func_t* function = prism_function->function();
            if (!function || prism_function->runtime() != runtime_) {
              return link_error("function import uses a different runtime");
            }
            bool type_matches = false;
            if (use_borrowed_function_imports) {
              type_matches =
                  prism_module_import_func_matches(w_mod, i, function);
            } else {
              type_matches =
                  FunctionTypesEqual(fty, wasm_func_type_borrow(function));
            }
            if (!type_matches) {
              return link_error("function import type does not match");
            }
            reuse_wasm_function = true;
          }

          // Prism exports do not expose a host callback entry that can be
          // linked directly into a second instance. After validating an
          // exported function's real signature above, retain the established
          // JS callback bridge for both exported and ordinary callables.
          PrismFunction* prism_function =
              new PrismFunction(func_obj, runtime_, this, nullptr);
          wasm_func_callback_with_env_t cb = nullptr;
          if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
            cb = (wasm_func_callback_with_env_t)PrismFunction::QJSPrismCallback;
          }
#if defined(__APPLE__)
          else {
            cb = (wasm_func_callback_with_env_t)PrismFunction::JSCPrismCallback;
          }
#endif
          wasm_func_t* w_func = nullptr;
          if (use_borrowed_function_imports) {
            w_func = prism_func_new_with_env_for_import(
                runtime_->wasm_store(), w_mod, i, cb, prism_function,
                PrismRuntime::WasmFunctionFinalizer);
          } else {
            w_func = wasm_func_new_with_env(
                runtime_->wasm_store(), fty, cb, prism_function,
                PrismRuntime::WasmFunctionFinalizer);
          }
          if (wasm_unlikely(w_func == NULL)) {
            delete prism_function;
            return 1;
          }
          imports[i] = wasm_func_as_extern(w_func);

          const uint32_t current_func_idx = func_idx++;
          js_env->CacheWasmImportCallback(func_obj, callback_root_transaction);
          if (reuse_wasm_function) {
            instance->CacheImportedWasmFunctionObject<JSEnv>(current_func_idx,
                                                             func_obj);
          }
          break;
        }
        case WASM_EXTERN_TABLE: {
          if (!js_env->IsObject(bind_target)) {
            return link_error("table import requires a Table");
          }
          JSObject table_obj = js_env->ValueToObject(bind_target);
          PrismTable* table = nullptr;
          WasmTableRef wasm_table = js_env->GetWasmTable(table_obj);
          if (wasm_likely(wasm_table.is<PrismTable*>())) {
            table = wasm_table.get<PrismTable*>();
          }
          if (wasm_likely(table)) {
            if (table->runtime() != runtime_) {
              return link_error("table import uses a different runtime");
            }
            const wasm_tabletype_t* expected_type =
                wasm_externtype_as_tabletype_const(ity);
            const wasm_limits_t* expected_limits =
                wasm_tabletype_limits(expected_type);
            if (!limits_match(expected_limits, table->size(),
                              table->maximum())) {
              return link_error("table import limits do not match");
            }
            wasm_table_t* tab = table->table();
            imports[i] = wasm_table_as_extern(tab);
            auto& tab_cache = js_env->wasm_table_cache();
            prism_table* p_tab = prism_get_table(tab);
            uintptr_t ptr = reinterpret_cast<uintptr_t>(p_tab);
            if (wasm_likely(!tab_cache.count(ptr))) {
              tab_cache[ptr] = js_env->DupValue(table_obj);
            }
            break;
          }
          return link_error("table import requires a Table");
        }
        case WASM_EXTERN_MEMORY: {
          if (!js_env->IsObject(bind_target)) {
            return link_error("memory import requires a Memory");
          }
          JSObject memory_obj = js_env->ValueToObject(bind_target);
          PrismMemory* memory = nullptr;
          WasmMemoryRef wasm_memory = js_env->GetWasmMemory(memory_obj);
          if (wasm_likely(wasm_memory.is<PrismMemory*>())) {
            memory = wasm_memory.get<PrismMemory*>();
          }
          if (wasm_likely(memory)) {
            if (memory->runtime() != runtime_) {
              return link_error("memory import uses a different runtime");
            }
            wasm_limits_t expected_limits{};
            if (!ReadMemoryTypeLimits(ity, &expected_limits) ||
                !limits_match(&expected_limits,
                              static_cast<uint32_t>(memory->pages()),
                              memory->maximum())) {
              return link_error("memory import limits do not match");
            }
            wasm_memory_t* mem = memory->memory();
            imports[i] = wasm_memory_as_extern(mem);
            auto& mem_cache = js_env->wasm_memory_cache();
            prism_mem_info* minfo = prism_get_memory(mem);
            uintptr_t ptr = reinterpret_cast<uintptr_t>(minfo);
            if (!mem_cache.count(ptr)) {
              mem_cache[ptr] = js_env->DupValue(memory_obj);
            }
            break;
          }
          return link_error("memory import requires a Memory");
        }
        case WASM_EXTERN_GLOBAL: {
          const wasm_globaltype_t* expected_type =
              wasm_externtype_as_globaltype_const(ity);
          if (wasm_unlikely(!expected_type)) return 1;

          PrismGlobal* wrapped_global = nullptr;
          JSObject global_obj{};
          if (js_env->IsObject(bind_target)) {
            global_obj = js_env->ValueToObject(bind_target);
            WasmGlobalRef wasm_global = js_env->GetWasmGlobal(global_obj);
            if (wasm_global.is<PrismGlobal*>()) {
              wrapped_global = wasm_global.get<PrismGlobal*>();
            } else if (wasm_global.is<Wasm3Global*>()) {
              return link_error("global import uses a different runtime");
            }
          }

          if (wrapped_global) {
            if (wrapped_global->runtime() != runtime_) {
              return link_error("global import uses a different runtime");
            }
            wasm_global_t* global = wrapped_global->global();
            if (wasm_unlikely(!global)) return 1;
            wasm_globaltype_t* actual_type = wasm_global_type(global);
            if (wasm_unlikely(
                    !actual_type ||
                    wasm_globaltype_mutability(actual_type) !=
                        wasm_globaltype_mutability(expected_type) ||
                    wasm_valtype_kind(wasm_globaltype_content(actual_type)) !=
                        wasm_valtype_kind(
                            wasm_globaltype_content(expected_type)))) {
              if (actual_type) wasm_globaltype_delete(actual_type);
              return link_error("global import type does not match");
            }
            wasm_globaltype_delete(actual_type);
            imports[i] = wasm_global_as_extern(global);

            auto& global_cache = js_env->wasm_global_cache();
            uintptr_t ptr =
                reinterpret_cast<uintptr_t>(prism_get_global_ptr(global));
            if (!global_cache.count(ptr)) {
              global_cache[ptr] = js_env->DupValue(global_obj);
            }
          } else {
            // Mutable imports must preserve a shared Global object. Immutable
            // numeric imports may use primitive values of the exact JS type
            // required by the WebAssembly JS API.
            if (wasm_globaltype_mutability(expected_type) != WASM_CONST) {
              return link_error("mutable global import requires a Global");
            }
            wasm_val_t value = WASM_INIT_VAL;
            value.kind =
                wasm_valtype_kind(wasm_globaltype_content(expected_type));
            if (value.kind == WASM_I64) {
              if (!js_env->IsBigInt(bind_target)) {
                return link_error("i64 global import requires a BigInt");
              }
            } else if (value.kind == WASM_I32 || value.kind == WASM_F32 ||
                       value.kind == WASM_F64) {
              if (!js_env->IsNumber(bind_target)) {
                return link_error("numeric global import requires a Number");
              }
            } else {
              return link_error("global import value type is unsupported");
            }
            JSValue conversion_exception = js_env->MakeNull();
            if (!runtime_->ToWebAssemblyValue(js_env, bind_target, &value,
                                              &conversion_exception)) {
              return link_error("global import value conversion failed");
            }
            wasm_global_t* global =
                wasm_global_new(runtime_->wasm_store(), expected_type, &value);
            if (wasm_unlikely(!global)) return 1;
            generated_import_globals->push_back(global);
            imports[i] = wasm_global_as_extern(global);
          }
          break;
        }
      }
    }
    return 0;
  }

  template <typename JSEnv>
  typename JSEnv::JSValue LookupImport(
      JSEnv* js_env, const typename JSEnv::JSObject import_obj,
      const char* module_name, size_t module_name_size, const char* field_name,
      size_t field_name_size, typename JSEnv::JSValue* import_exception) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;

    std::string c_name(module_name, module_name_size);
    JSValue may_import_module;
    if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
      may_import_module = js_env->GetPropertyForPrism(
          import_obj, c_name.c_str(), import_exception);
    } else {
      may_import_module =
          js_env->GetProperty(import_obj, c_name.c_str(), import_exception);
    }
    struct ImportModuleGuard {
      JSEnv* env;
      JSValue value;
      ~ImportModuleGuard() {
        if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
          env->ReleaseValue(value);
        }
      }
    } import_module_guard{js_env, may_import_module};
    if (import_exception && !js_env->IsNull(*import_exception)) {
      return js_env->MakeUndefined();
    }

    if (js_env->IsObject(may_import_module)) {
      JSObject import_module = js_env->ValueToObject(may_import_module);
      c_name.assign(field_name, field_name_size);
      JSValue prop;
      if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
        prop = js_env->GetPropertyForPrism(import_module, c_name.c_str(),
                                           import_exception);
      } else {
        prop = js_env->GetProperty(import_module, c_name.c_str(),
                                   import_exception);
      }
      return prop;
    }

    if (import_exception) {
      JSValue exception = js_env->MakeNull();
      js_env->MakeException(ErrorTypes::kTypeError,
                            "new WebAssembly.Instance()",
                            "import module must be an object", &exception);
      *import_exception = exception;
    }

    return js_env->MakeUndefined();
  }

  std::atomic_int ref_count_{0};

 private:
  static bool FunctionTypesEqual(const wasm_functype_t* expected,
                                 const wasm_functype_t* actual) {
    if (!expected || !actual) return false;
    const wasm_valtype_vec_t* expected_params = wasm_functype_params(expected);
    const wasm_valtype_vec_t* actual_params = wasm_functype_params(actual);
    const wasm_valtype_vec_t* expected_results =
        wasm_functype_results(expected);
    const wasm_valtype_vec_t* actual_results = wasm_functype_results(actual);
    return ValueTypesEqual(expected_params, actual_params) &&
           ValueTypesEqual(expected_results, actual_results);
  }

  static bool ValueTypesEqual(const wasm_valtype_vec_t* expected,
                              const wasm_valtype_vec_t* actual) {
    if (!expected || !actual || expected->size != actual->size) return false;
    for (size_t i = 0; i < expected->size; ++i) {
      if (wasm_valtype_kind(expected->data[i]) !=
          wasm_valtype_kind(actual->data[i])) {
        return false;
      }
    }
    return true;
  }

  using ExportFunctionCacheEntry = PrismRuntime::ExportFunctionCacheEntry;

  BORROWER PrismRuntime* runtime_;
  OWNER wasm_instance_t* instance_ = nullptr;
  std::vector<ExportFunctionCacheEntry> imported_wasm_functions_;
#ifdef ENABLE_WASM_PERF_COMPARE
  wasm_perf::LoadToken perf_load_;
#endif
};

}  // namespace wasm
}  // namespace primjs

#endif  // SRC_WASM_RUNTIME_PRISM_WASM_INSTANCE_H_
