// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_WASM3_WASM_INSTANCE_H_
#define SRC_WASM_RUNTIME_WASM3_WASM_INSTANCE_H_

// NOTE: THIS FILE SHOULD NOT BE INCLUDED IN HEADER FILES IN WASM RUNTIME MODULE

#include <map>
#include <vector>

#include "common/one_of.h"
#include "common/wasm_type.h"
#include "common/wasm_utils.h"
#include "runtime/wasm3/wasm_function.h"
#include "runtime/wasm3/wasm_global.h"
#include "runtime/wasm3/wasm_memory.h"
#include "runtime/wasm3/wasm_runtime.h"
#include "runtime/wasm3/wasm_table.h"
#include "wasm3/m3_env.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Instance {
 public:
  Wasm3Instance(Wasm3Runtime* rt);
  ~Wasm3Instance();

  static void IncreaseRefCount(Wasm3Instance*& instance);

  static void DecreaseRefCount(Wasm3Instance*& instance);

  static void Destructor(Wasm3Instance*& instance);

  IM3Module instance() const { return instance_; }

  void set_instance(IM3Module instance) { instance_ = instance; }

  template <typename JSEnv>
  int LinkMemory(JSEnv* js_env, IM3Module mod, typename JSEnv::JSObject imports,
                 WasmResult& result) {
    using JSObject = typename JSEnv::JSObject;
    using JSValue = typename JSEnv::JSValue;

    const char* m_name = mod->memoryImportInfo->moduleUtf8;
    const char* f_name = mod->memoryImportInfo->fieldUtf8;

    JSValue value = LookupImport(js_env, imports, m_name, f_name);
    if (!js_env->IsObject(value) || js_env->IsUndefined(value)) {
      result = "Imported memory is not an object.";
      return 1;
    }
    JSObject memory_obj = js_env->ValueToObject(value);

    Wasm3Memory* wasm3_memory = nullptr;
    WasmMemoryRef wasm_memory = js_env->GetWasmMemory(memory_obj);
    if (wasm_memory.is<Wasm3Memory*>())
      wasm3_memory = wasm_memory.get<Wasm3Memory*>();
    WASM_DCHECK(wasm3_memory != nullptr);

    if (wasm3_memory) {
      IM3Memory m3_memory = wasm3_memory->memory();
      auto& mem_cache = js_env->wasm_memory_cache();
      uintptr_t ptr = reinterpret_cast<uintptr_t>(m3_memory);
      if (!mem_cache.count(ptr)) mem_cache[ptr] = js_env->DupValue(memory_obj);
      result = m3_LinkMemory(mod, m3_memory);
      return result != WasmSucceed;
    }

    return 1;
  }

  template <typename JSEnv>
  int LinkTable(JSEnv* js_env, IM3Module mod, typename JSEnv::JSObject imports,
                WasmResult& result) {
    using JSObject = typename JSEnv::JSObject;
    using JSValue = typename JSEnv::JSValue;

    const char* m_name = mod->tableImportInfo->moduleUtf8;
    const char* f_name = mod->tableImportInfo->fieldUtf8;

    JSValue value = LookupImport(js_env, imports, m_name, f_name);
    if (!js_env->IsObject(value) || js_env->IsUndefined(value)) {
      result = "Imported value is not a table object";
      return 1;
    }

    JSObject table_obj = js_env->ValueToObject(value);

    Wasm3Table* wasm3_table = nullptr;
    WasmTableRef wasm_table = js_env->GetWasmTable(table_obj);
    if (wasm_table.is<Wasm3Table*>())
      wasm3_table = wasm_table.get<Wasm3Table*>();
    WASM_DCHECK(wasm3_table != nullptr);

    if (wasm3_table) {
      auto& wasm_table_cache = js_env->wasm_table_cache();
      IM3Table m3_table = wasm3_table->table();
      uintptr_t ptr = reinterpret_cast<uintptr_t>(m3_table);
      if (!wasm_table_cache.count(ptr))
        wasm_table_cache[ptr] = js_env->DupValue(table_obj);
      result = m3_LinkTable(mod, m3_table);
      return result != WasmSucceed;
    }

    return 1;
  }

  template <typename JSEnv>
  int LinkGlobal(JSEnv* js_env, IM3Module mod, typename JSEnv::JSObject imports,
                 int idx, InteropRuntime* interop, WasmResult& result) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;

    const char* m_name = mod->globals[idx].import.moduleUtf8;
    const char* f_name = mod->globals[idx].import.fieldUtf8;

    IM3Global m3_global = mod->globals + idx;
    JSValue imported_val = LookupImport(js_env, imports, m_name, f_name);
    if (js_env->IsUndefined(imported_val)) {
      result = "Import global value is undefined.";
      return 1;
    }

    Wasm3Global* wasm3_global = nullptr;
    JSValue value = js_env->MakeUndefined();
    JSObject global_obj;
    if (js_env->IsNumber(imported_val)) {
      value = imported_val;
      wasm3_global = new Wasm3Global(runtime_, m3_global, this);
      global_obj = js_env->MakeWasmGlobal(interop, wasm3_global);
    } else {
      global_obj = js_env->ValueToObject(imported_val);
      js_env->DupValue(global_obj);  // dup because cache needed.

      WasmGlobalRef wasm_global = js_env->GetWasmGlobal(global_obj);
      if (wasm_global.is<Wasm3Global*>())
        wasm3_global = wasm_global.get<Wasm3Global*>();
      if (!wasm3_global) {
        result = "LinkGlobal get global from import object failed.";
        return 1;
      }

      M3TaggedValue tagged_value;
      wasm3_global->GetValue(&tagged_value);
      runtime_->ToJSValue(js_env, &value, &tagged_value);
    }

    // Only get a number from imported Global.
    // Because JSC cannot figure out whether value is BigInt or Int64 or
    // float32 or Int32, it can only read Number, so we do not making a
    // convert here.
    double number = 0;
    JSValue exception = js_env->MakeNull();
    js_env->ValueToNumber(number, value, exception);
    if (!js_env->IsNull(exception)) {
      result = "LinkGlobal ValueToNumber failed.";
      return 1;
    }

    auto& wasm3_global_cache = js_env->wasm_global_cache();
    uintptr_t ptr = reinterpret_cast<uintptr_t>(m3_global);
    if (!wasm3_global_cache.count(ptr)) {
      wasm3_global_cache[ptr] = global_obj;
    }
    wasm3_global->set_global(m3_global);
    wasm3_global->set_instance(this);
    return wasm3_global->SetLinkedValue(number);
  }

  template <typename JSEnv>
  int BindFunctionImports(JSEnv* js_env,
                          const typename JSEnv::JSObject import_obj,
                          IM3Module m3_module) {
    using JSObject = typename JSEnv::JSObject;
    using JSValue = typename JSEnv::JSValue;

    // Handle functions only.
    // FIXME: To support each type to be imported.
    bool is_empty = !js_env->IsObject(import_obj);

    for (u32 i = 0; i < m3_module->numFunctions; ++i) {
      IM3Function m3_function = Module_GetFunction(m3_module, i);

      if (m3_function->import.moduleUtf8 && m3_function->import.fieldUtf8) {
        if (is_empty) return 1;

        const char* m_name = m3_function->import.moduleUtf8;
        const char* f_name = m3_function->import.fieldUtf8;

        JSValue value = LookupImport(js_env, import_obj, m_name, f_name);
        if (!js_env->IsFunction(value)) return 1;
        JSObject func_obj = js_env->ValueToObject(value);

        Wasm3Function* wasm3_function =
            new Wasm3Function(func_obj, runtime_, this, nullptr);
        std::string sig = Wasm3Runtime::CreateSignature(m3_function);

        if constexpr (std::is_same_v<JSEnv, QJSEnv>) {
          M3Result result = m3_LinkRawFunctionEx(
              m3_module, m_name, f_name, sig.c_str(),
              Wasm3Function::QJSWasmCallback, wasm3_function);
          if (result) {
            delete wasm3_function;
            return 1;
          }
        }
#if defined(__APPLE__)
        else {
          M3Result result = m3_LinkRawFunctionEx(
              m3_module, m_name, f_name, sig.c_str(),
              Wasm3Function::JSCWasmCallback, wasm3_function);
          if (result) {
            delete wasm3_function;
            return 1;
          }
        }
#endif
        auto& wasm_func_cache = js_env->wasm_func_cache();
        uintptr_t ptr = reinterpret_cast<uintptr_t>(m3_function);
        wasm_func_cache[ptr] = js_env->DupValue(func_obj);
      }
    }
    return 0;
  }

  template <typename JSEnv>
  typename JSEnv::JSValue LookupImport(
      JSEnv* js_env, const typename JSEnv::JSObject import_obj,
      const char* module_name, const char* field_name) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;

    JSValue may_import_module = js_env->GetProperty(import_obj, module_name);

    if (js_env->IsObject(may_import_module)) {
      JSObject import_module = js_env->ValueToObject(may_import_module);
      JSValue prop = js_env->GetProperty(import_module, field_name);
      return prop;
    }

    return js_env->MakeUndefined();
  }

  std::atomic_int ref_count_{0};

 private:
  BORROWER Wasm3Runtime* runtime_ = nullptr;

  OWNER IM3Module instance_ = nullptr;
};

}  // namespace wasm
}  // namespace primjs

#endif  // SRC_WASM_RUNTIME_WASM3_WASM_INSTANCE_H_
