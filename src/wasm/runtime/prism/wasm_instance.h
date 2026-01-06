// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_PRISM_WASM_INSTANCE_H_
#define SRC_WASM_RUNTIME_PRISM_WASM_INSTANCE_H_

#include <vector>

#include "common/js_type.h"
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

class PrismInstance {
 public:
  PrismInstance(PrismRuntime* rt);
  ~PrismInstance();

  static void IncreaseRefCount(PrismInstance*& instance);
  static void DecreaseRefCount(PrismInstance*& instance);
  static void Destructor(PrismInstance*& instance);

  wasm_instance_t* instance() const { return instance_; }
  void set_instance(wasm_instance_t* instance) { instance_ = instance; }

  template <typename JSEnv>
  int BindImports(JSEnv* js_env, const typename JSEnv::JSObject import_obj,
                  InteropRuntime* interop, wasm_importtype_vec_t* iv,
                  wasm_extern_t** imports, wasm_module_t* w_mod,
                  PrismInstance* instance) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;

    if (!js_env->IsObject(import_obj)) return 1;

    // do not consider importing tables & memories here
    for (size_t i = 0; i < iv->size; ++i) {
      // TODO(wasm): consider to introduce a fast way to bind imports
      //  without comparing their names, based on a hypothosis that imports
      //  are assigned in a right order.
      JSValue bind_target = LookupImport(js_env, import_obj, iv->data[i]);
      if (js_env->IsUndefined(bind_target)) {
        return 1;
      }
      const wasm_externtype_t* ity = wasm_importtype_type(iv->data[i]);
      const wasm_externkind_t e_kind = wasm_externtype_kind(ity);
      uint32_t global_idx = 0;
      switch (e_kind) {
        case WASM_EXTERN_GLOBAL: {
          PrismGlobal* global = nullptr;
          JSObject global_obj;
          if (js_env->IsNumber(bind_target)) {
            wasm_global_t* gbl = prism_get_global(w_mod, global_idx++);
            double number = 0;
            JSValue ret = js_env->MakeUndefined();
            js_env->ValueToNumber(number, bind_target, ret);
            global = new PrismGlobal(gbl, number, runtime_);
            global_obj = js_env->MakeWasmGlobal(interop, global);
          } else {
            global_obj = js_env->ValueToObject(bind_target);
            WasmGlobalRef wasm_global = js_env->GetWasmGlobal(global_obj);
            if (wasm_global.is<PrismGlobal*>()) {
              global = wasm_global.get<PrismGlobal*>();
            }
            if (wasm_unlikely(!global)) {
              return 1;
            }
          }
          if (wasm_likely(global)) {
            wasm_global_t* gbl = global->global();
            imports[i] = wasm_global_as_extern(gbl);
            auto& global_cache = js_env->wasm_global_cache();
            uint32_t idx = prism_get_global_idx(gbl);
            uintptr_t ptr = reinterpret_cast<uintptr_t>(instance) + idx;
            if (wasm_likely(!global_cache.count(ptr))) {
              global_cache[ptr] = js_env->DupValue(global_obj);
            }
            break;
          }
          return 1;
        }
        case WASM_EXTERN_MEMORY: {
          JSObject memory_obj = js_env->ValueToObject(bind_target);
          PrismMemory* memory = nullptr;
          WasmMemoryRef wasm_memory = js_env->GetWasmMemory(memory_obj);
          if (wasm_memory.is<PrismMemory*>()) {
            memory = wasm_memory.get<PrismMemory*>();
          }
          if (memory) {
            wasm_memory_t* mem = memory->memory();
            imports[i] = wasm_memory_as_extern(mem);
            auto& mem_cache = js_env->wasm_memory_cache();
            prism_mem_info* minfo = prism_get_memory(mem);
            uintptr_t ptr = reinterpret_cast<uintptr_t>(minfo);
            if (wasm_likely(!mem_cache.count(ptr))) {
              mem_cache[ptr] = js_env->DupValue(memory_obj);
            }
            break;
          }
          return 1;
        }
        case WASM_EXTERN_TABLE: {
          JSObject table_obj = js_env->ValueToObject(bind_target);
          PrismTable* table = nullptr;
          WasmTableRef wasm_table = js_env->GetWasmTable(table_obj);
          if (wasm_table.is<PrismTable*>()) {
            table = wasm_table.get<PrismTable*>();
          }
          if (table) {
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
          return 1;
        }
        case WASM_EXTERN_FUNC: {
          JSObject func_obj = js_env->ValueToFunction(bind_target);
          if (!js_env->IsNull(func_obj)) {
            const wasm_functype_t* fty = wasm_externtype_as_functype_const(ity);
            PrismFunction* prism_function =
                new PrismFunction(func_obj, runtime_);
            wasm_func_t* w_func = nullptr;
            const wasm_valtype_vec_t* ret_type = wasm_functype_results(fty);
            if constexpr (std::is_same_v<JSEnv, qjs::QJSEnv>) {
              if (ret_type->size == 1 &&
                  (wasm_valtype_kind(ret_type->data[0]) == WASM_F32 ||
                   wasm_valtype_kind(ret_type->data[0]) == WASM_F64)) {
                w_func = wasm_func_new_with_env(
                    runtime_->wasm_store(), fty,
                    (wasm_func_callback_with_env_t)
                        PrismFunction::QJSPrismCallback_f,
                    prism_function, PrismRuntime::WasmFunctionFinalizer);
              } else {
                w_func = wasm_func_new_with_env(
                    runtime_->wasm_store(), fty,
                    (wasm_func_callback_with_env_t)
                        PrismFunction::QJSPrismCallback,
                    prism_function, PrismRuntime::WasmFunctionFinalizer);
              }
              imports[i] = wasm_func_as_extern(w_func);
            }
#if defined(__APPLE__)
            else {
              if (ret_type->size == 1 &&
                  (wasm_valtype_kind(ret_type->data[0]) == WASM_F32 ||
                   wasm_valtype_kind(ret_type->data[0]) == WASM_F64)) {
                w_func = wasm_func_new_with_env(
                    runtime_->wasm_store(), fty,
                    (wasm_func_callback_with_env_t)
                        PrismFunction::JSCPrismCallback_f,
                    prism_function, PrismRuntime::WasmFunctionFinalizer);
              } else {
                w_func = wasm_func_new_with_env(
                    runtime_->wasm_store(), fty,
                    (wasm_func_callback_with_env_t)
                        PrismFunction::JSCPrismCallback,
                    prism_function, PrismRuntime::WasmFunctionFinalizer);
              }
              imports[i] = wasm_func_as_extern(w_func);
            }
#endif
            auto& func_cache = js_env->wasm_func_cache();
            // here `prism_function` equals to `w_func->cb_env.userdata`
            // However, `w_func`'s type definition is not available here, so we
            // use `prism_function instead`
            uintptr_t ptr = reinterpret_cast<uintptr_t>(prism_function);
            if (wasm_likely(!func_cache.count(ptr))) {
              func_cache[ptr] = js_env->DupValue(func_obj);
            }
            break;
          }
          return 1;
        }
      }
    }
    return 0;
  }

  template <typename JSEnv>
  typename JSEnv::JSValue LookupImport(
      JSEnv* js_env, const typename JSEnv::JSObject import_obj,
      wasm_importtype_t* ity) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;

    const wasm_name_t* m_name = nullptr;
    m_name = wasm_importtype_module(ity);

    std::string c_name(m_name->data, m_name->size);
    JSValue may_import_module = js_env->GetProperty(import_obj, c_name.c_str());

    if (js_env->IsObject(may_import_module)) {
      JSObject import_module = js_env->ValueToObject(may_import_module);
      m_name = wasm_importtype_name(ity);
      c_name = std::string(m_name->data, m_name->size);
      JSValue prop = js_env->GetProperty(import_module, c_name.c_str());
      return prop;
    }

    return js_env->MakeUndefined();
  }

  std::atomic_int ref_count_{0};

 private:
  BORROWER PrismRuntime* runtime_;
  OWNER wasm_instance_t* instance_ = nullptr;
};

}  // namespace wasm
}  // namespace primjs

#endif  // SRC_WASM_RUNTIME_PRISM_WASM_INSTANCE_H_
