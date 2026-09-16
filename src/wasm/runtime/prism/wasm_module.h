// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_PRISM_WASM_MODULE_H_
#define SRC_WASM_RUNTIME_PRISM_WASM_MODULE_H_

#include <vector>

#ifdef ENABLE_WASM_PERF_COMPARE
#include "common/interop_runtime_perf.h"
#endif
#include "common/wasm_utils.h"
#include "prism/prism.h"
#include "prism/wasm_c_api.h"
#include "runtime/prism/wasm_instance.h"
#include "runtime/prism/wasm_runtime.h"

#if defined(QJS_UNITTEST) && !defined(ENABLE_WASM_PERF_TEST_CAPTURE)
#include <atomic>
#endif

namespace primjs {
namespace wasm {
constexpr const char* ExternKindName(wasm_externkind_t kind) {
  // Use the symbolic enum values: the production Prism header and the OSS
  // build-only stub intentionally use different numeric orders.
  switch (kind) {
    case WASM_EXTERN_FUNC:
      return "function";
    case WASM_EXTERN_TABLE:
      return "table";
    case WASM_EXTERN_MEMORY:
      return "memory";
    case WASM_EXTERN_GLOBAL:
      return "global";
  }
  return "unknown";
}

class PrismModule {
 public:
  PrismModule(wasm_module_t* module, PrismRuntime* runtime);
  ~PrismModule();

  template <typename JSEnv>
  void exports(JSEnv* js_env, typename JSEnv::JSObject array,
               typename JSEnv::JSValue* exception) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;

    wasm_exporttype_vec_t export_types;
    wasm_module_exports(module_, &export_types);

    for (size_t i = 0; i < export_types.size; ++i) {
      const wasm_externtype_t* e_type =
          wasm_exporttype_type(export_types.data[i]);
      const char* kind_str = ExternKindName(wasm_externtype_kind(e_type));
      JSObject temp = js_env->MakeObject();
      JSValue js_kind_str = js_env->MakeString(kind_str);
      // Here we create js string of "kind" & "name" every time.
      // TODO(wasm): If this method is frequently called, find a way to save
      //             this overhead while being compatible to different js
      //             engines.
      js_env->SetProperty(temp, "kind", js_kind_str);

      const wasm_name_t* e_name = wasm_exporttype_name(export_types.data[i]);
      std::string e_name_str(e_name->data, e_name->size);
      JSValue name_str = js_env->MakeString(e_name_str.c_str());
      js_env->SetProperty(temp, "name", name_str);

      js_env->SetPropertyAtIndex(array, i, temp);
    }
    wasm_exporttype_vec_delete(&export_types);
  }
  template <typename JSEnv>
  void imports(JSEnv* js_env, typename JSEnv::JSObject array,
               typename JSEnv::JSValue* exception) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;

    wasm_importtype_vec_t import_types;
    wasm_module_imports(module_, &import_types);

    for (size_t i = 0; i < import_types.size; ++i) {
      const wasm_externtype_t* e_type =
          wasm_importtype_type(import_types.data[i]);
      const char* kind_str = ExternKindName(wasm_externtype_kind(e_type));
      JSObject temp = js_env->MakeObject();
      JSValue js_kind_str = js_env->MakeString(kind_str);
      js_env->SetProperty(temp, "kind", js_kind_str);

      const wasm_name_t* e_name = wasm_importtype_module(import_types.data[i]);
      std::string module_str(e_name->data, e_name->size);
      JSValue js_module_str = js_env->MakeString(module_str.c_str());
      js_env->SetProperty(temp, "module", js_module_str);

      e_name = wasm_importtype_name(import_types.data[i]);
      std::string name_str(e_name->data, e_name->size);
      JSValue js_name_str = js_env->MakeString(name_str.c_str());
      js_env->SetProperty(temp, "name", js_name_str);

      js_env->SetPropertyAtIndex(array, i, temp);
    }
    wasm_importtype_vec_delete(&import_types);
  }

  // Temporary approach.
  wasm_module_t* module() const { return module_; }

  PrismRuntime* runtime() const { return runtime_; }

#ifdef ENABLE_WASM_PERF_COMPARE
  wasm_perf::LoadToken& perf_load() { return perf_load_; }
#endif

  // Note:
  // There is no need to check whether wasm runtime is instantiated
  // when creating a wasm instance, because only if a valid wasm
  // module is provided this function will be called.
  template <typename JSEnv>
  PrismInstance* CreateWasmInstance(JSEnv* js_env,
                                    typename JSEnv::JSObject import,
                                    InteropRuntime* interop, WasmResult& result,
                                    typename JSEnv::JSValue* import_exception) {
    result = WasmSucceed;
    wasm_importtype_vec_t import_types{0, nullptr};

    auto set_instantiation_exception = [&](const char* message) {
      if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
        LEPUSValue pending;
        if (js_env->TakeWasmException(&pending)) {
          LEPUS_Throw(js_env->js_ctx(), pending);
          if (import_exception) {
            *import_exception = JSEnv::FromQJS(
                LEPUS_EXCEPTION, LEPUS_GetRuntime(js_env->js_ctx()));
          }
          return;
        }
      }
#if defined(__APPLE__)
      else {
        JSValueRef pending = js_env->TakeWasmException();
        if (pending) {
          if (import_exception) *import_exception = pending;
          JSValueUnprotect(js_env->js_ctx(), pending);
          return;
        }
      }
#endif
      if (import_exception) {
        js_env->MakeException(ErrorTypes::kError, "new WebAssembly.Instance()",
                              message, import_exception);
      }
    };

    size_t import_count = 0;
    PrismImportBindingMode import_binding_mode =
        PrismImportBindingMode::kOwnedDescriptors;
    import_count = prism_module_import_count(module_);
    if (prism_module_imports_are_all_functions(module_)) {
      import_binding_mode = PrismImportBindingMode::kBorrowedAllFunctions;
    } else if (import_count > 0) {
      // Mixed-kind modules retain the established standard C-API path. The
      // borrowed extension is deliberately limited to the all-function shape
      // so table, memory and global import semantics remain unchanged. Prism
      // classifies this shape from parsed import-kind counts in O(1), avoiding
      // a redundant pre-scan before descriptor construction.
#if defined(QJS_UNITTEST) && !defined(ENABLE_WASM_PERF_TEST_CAPTURE)
      PrismImportBindingCountersForTesting::RecordOwnedDescriptorEnumeration();
#endif
      wasm_module_imports(module_, &import_types);
      import_count = import_types.size;
    }
#if defined(QJS_UNITTEST) && !defined(ENABLE_WASM_PERF_TEST_CAPTURE)
    last_import_binding_path_for_testing_.store(
        import_binding_mode == PrismImportBindingMode::kBorrowedAllFunctions
            ? ImportBindingPathForTesting::kBorrowedAllFunctions
            : ImportBindingPathForTesting::kOwnedDescriptors,
        std::memory_order_relaxed);
#endif

    // Standard C++ has no variable-length arrays. Keep one padding slot for
    // the zero-import case, while exposing the real import count to Prism.
    std::vector<wasm_extern_t*> externs(import_count > 0 ? import_count : 1,
                                        nullptr);
    wasm_extern_vec_t imports_vec = {import_count, externs.data()};
    auto prism_instance = new PrismInstance(runtime_);
    if (!import_count) {
      wasm_instance_t* wasm_instance =
          wasm_instance_new_with_args(runtime_->wasm_store(), module_,
                                      &imports_vec, nullptr, KILOBYTE(256), 0);
      if (wasm_unlikely(!wasm_instance)) {
        result = "create prism instance failed";
        set_instantiation_exception("start or initialization trapped");
        wasm_importtype_vec_delete(&import_types);
        delete prism_instance;
        return nullptr;
      }
      prism_instance->set_instance(wasm_instance);
      wasm_importtype_vec_delete(&import_types);
      return prism_instance;
    }

    // Getter evaluation may synchronously instantiate another module. Tag
    // callback roots with this transaction rather than truncating the shared
    // root vector to a size checkpoint, which could discard roots committed by
    // a successful re-entrant instantiation.
    const uint64_t callback_root_transaction =
        js_env->BeginWasmImportCallbackTransaction();
    struct PendingImportCallbackRoots {
      JSEnv* env;
      uint64_t transaction;

      ~PendingImportCallbackRoots() {
        if (!env) return;
        const size_t rolled_back =
            env->RollbackWasmImportCallbackTransaction(transaction);
#if defined(QJS_UNITTEST) && !defined(ENABLE_WASM_PERF_TEST_CAPTURE)
        PrismImportBindingCountersForTesting::RecordRolledBackCallbackRoots(
            rolled_back);
#endif
      }

      void Release() { env = nullptr; }
    } pending_import_callback_roots{js_env, callback_root_transaction};

    // wasm_global_new returns an owned caller handle. Keep it alive through
    // instance construction, then release it on every success and failure
    // exit. Declare this owner before the function owner below: the latter
    // inspects the mixed extern array during rollback, so it must finish while
    // generated global handles in that array are still alive.
    //
    // Pinned Prism 1.1.11 makes this delete a no-op because the handle and
    // backing value are Store-zone owned. Any future C-API-compatible
    // implementation must keep the imported Global's underlying object alive
    // independently of this caller handle; caller-side deletion remains
    // required by the API.
    struct GeneratedImportGlobalOwners {
      std::vector<wasm_global_t*> handles;
      ~GeneratedImportGlobalOwners() {
        for (wasm_global_t* global : handles) {
          wasm_global_delete(global);
        }
      }
    };
    GeneratedImportGlobalOwners generated_import_global_owners;

    // Every function import is represented by a fresh wasm_func_t wrapper.
    // Prism owns the wrapper storage through the Store, but wasm_func_delete
    // releases its copied function type and invokes the PrismFunction
    // finalizer. Roll those payloads back when a later import rejects the
    // binding transaction; Store teardown can safely visit the inert wrapper
    // again because wasm_func_delete clears both owned fields.
    struct PendingImportFunctionOwners {
      wasm_extern_t** handles;
      size_t count;

      ~PendingImportFunctionOwners() {
        if (!handles) return;
        for (size_t i = 0; i < count; ++i) {
          wasm_extern_t* handle = handles[i];
          if (handle && wasm_extern_kind(handle) == WASM_EXTERN_FUNC) {
            wasm_func_delete(wasm_extern_as_func(handle));
#if defined(QJS_UNITTEST) && !defined(ENABLE_WASM_PERF_TEST_CAPTURE)
            PrismImportBindingCountersForTesting::
                RecordRolledBackFunctionHandle();
#endif
          }
        }
      }

      void Release() {
        handles = nullptr;
        count = 0;
      }
    } pending_import_function_owners{externs.data(), import_count};

    // When the module requires non-empty importing object, aka.
    // import_count > 0, we return nullptr if no imported object is
    // provided or import-binding fails.
    //
    // Bind imports before constructing the runtime instance. Primitive
    // immutable globals are represented by standalone wasm_global_t handles;
    // wrapped globals, functions, tables and memories already provide their
    // own handles. This keeps every import shape on one real-instance path and
    // avoids allocating a complete temporary stat (functions, table and
    // initial linear memory) solely to obtain global import slots.

    // Link
    if (prism_instance->BindImports(js_env, import, interop, &import_types,
                                    import_binding_mode, externs.data(),
                                    &generated_import_global_owners.handles,
                                    callback_root_transaction, module_,
                                    prism_instance, import_exception)) {
      result = "link prism imports failed";
      wasm_importtype_vec_delete(&import_types);
      delete prism_instance;
      return nullptr;
    }
    // Mixed owned-descriptor imports may publish this instance's function
    // entries into a caller-owned imported table during initialization. Keep
    // the established Store lifetime once binding succeeds, even if a later
    // start function traps. The borrowed path is guaranteed to contain only
    // functions, so its handles remain transactional until instance creation
    // succeeds.
    if (import_binding_mode == PrismImportBindingMode::kOwnedDescriptors) {
      pending_import_function_owners.Release();
      pending_import_callback_roots.Release();
    }
    wasm_instance_t* wasm_instance_linked =
        wasm_instance_new_with_args(runtime_->wasm_store(), module_,
                                    &imports_vec, nullptr, KILOBYTE(256), 0);
    if (wasm_unlikely(!wasm_instance_linked)) {
      result = "create prism instance failed";
      set_instantiation_exception("start or initialization trapped");
      wasm_importtype_vec_delete(&import_types);
      delete prism_instance;
      return nullptr;
    }
    pending_import_function_owners.Release();
    pending_import_callback_roots.Release();
    prism_instance->set_instance(wasm_instance_linked);
    prism_instance->CacheLinkedImportFunctionObjects(js_env);
    wasm_importtype_vec_delete(&import_types);
    return prism_instance;
  }

#if defined(QJS_UNITTEST) && !defined(ENABLE_WASM_PERF_TEST_CAPTURE)
  enum class ImportBindingPathForTesting {
    kUnknown,
    kBorrowedAllFunctions,
    kOwnedDescriptors,
  };

  static void ResetImportBindingPathForTesting() {
    last_import_binding_path_for_testing_.store(
        ImportBindingPathForTesting::kUnknown, std::memory_order_relaxed);
    PrismImportBindingCountersForTesting::Reset();
  }

  static ImportBindingPathForTesting LastImportBindingPathForTesting() {
    return last_import_binding_path_for_testing_.load(
        std::memory_order_relaxed);
  }

  static size_t BorrowedImportViewCallsForTesting() {
    return PrismImportBindingCountersForTesting::BorrowedViewCalls();
  }

  static size_t OwnedImportDescriptorEnumerationsForTesting() {
    return PrismImportBindingCountersForTesting::OwnedDescriptorEnumerations();
  }

  static size_t RolledBackImportFunctionsForTesting() {
    return PrismImportBindingCountersForTesting::RolledBackFunctionHandles();
  }

  static size_t RolledBackImportCallbackRootsForTesting() {
    return PrismImportBindingCountersForTesting::RolledBackCallbackRoots();
  }
#endif

 private:
#if defined(QJS_UNITTEST) && !defined(ENABLE_WASM_PERF_TEST_CAPTURE)
  inline static std::atomic<ImportBindingPathForTesting>
      last_import_binding_path_for_testing_{
          ImportBindingPathForTesting::kUnknown};
#endif

  PrismRuntime* runtime_;

  wasm_module_t* module_;
#ifdef ENABLE_WASM_PERF_COMPARE
  wasm_perf::LoadToken perf_load_;
#endif
};

}  // namespace wasm
}  // namespace primjs

#endif  // SRC_WASM_RUNTIME_PRISM_WASM_MODULE_H_
