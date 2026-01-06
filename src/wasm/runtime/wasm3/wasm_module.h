// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "common/js_type.h"
#include "common/wasm_log.h"
#include "common/wasm_type.h"
#include "runtime/wasm3/wasm_instance.h"
#include "runtime/wasm3/wasm_runtime.h"
#include "wasm3/m3_api_libc.h"
#include "wasm3/m3_env.h"
#include "wasm3/wasm3.h"

namespace primjs::wasm {
class Wasm3Module {
 public:
  Wasm3Module(const uint8_t* const data, const size_t len, IM3Module module,
              Wasm3Runtime* rt);
  ~Wasm3Module();

  void ReParse(IM3Module* module, M3Result& result);

  // There is no need to check whether wasm runtime is instantiated when
  // creating a wasm instance, because only if a valid wasm module is provided
  // this function will be called.
  template <typename JSEnv>
  Wasm3Instance* CreateWasmInstance(JSEnv* js_env,
                                    typename JSEnv::JSObject import,
                                    InteropRuntime* interop,
                                    WasmResult& result) {
    result = WasmSucceed;
    IM3Module m3_module;

    // Create new parsed module for this instances
    ReParse(&m3_module, result);
    if (result) {
      WLOGE("Wasm3Runtime m3_module reparse failed: %s", result);
      return nullptr;
    }

    auto wasm3_instance = new Wasm3Instance(runtime_);
    if (m3_module->memoryImportInfo &&
        wasm3_instance->LinkMemory(js_env, m3_module, import, result)) {
      delete wasm3_instance;
      return nullptr;
    }

    if (m3_module->tableImportInfo &&
        wasm3_instance->LinkTable(js_env, m3_module, import, result)) {
      delete wasm3_instance;
      return nullptr;
    }

    int global_num = m3_module->numGlobals;
    for (int i = 0; i < global_num; i++) {
      M3Global m3_global = m3_module->globals[i];
      if (m3_global.imported &&
          wasm3_instance->LinkGlobal(js_env, m3_module, import, i, interop,
                                     result)) {
        delete wasm3_instance;
        return nullptr;
      }
    }

    IM3Runtime m3_runtime = runtime_->m3_runtime();
    // FIXME(zode): no module in m3_runtime
    result = m3_LoadModule(m3_runtime, m3_module);
    if (!m3_runtime->modules || result) {
      if (!result) result = "m3_LoadModule failed";
      FreeModule();
      delete wasm3_instance;
      return nullptr;
    }

    wasm3_instance->set_instance(m3_module);

    result = m3_LinkLibC(m3_module);
    if (result) return nullptr;

    if (wasm3_instance->BindFunctionImports(js_env, import, m3_module)) {
      result = "Wasm3Runtime Binding imports failed.";
      return nullptr;
    }

    result = m3_CompileModule(m3_module);
    if (result) return nullptr;

    if (m3_module->startFunction >= 0) {
      result = m3_RunStart(m3_module);
      if (result) return nullptr;
    }

    return wasm3_instance;
  }

  template <typename JSEnv>
  void exports(JSEnv* js_env, typename JSEnv::JSObject array,
               typename JSEnv::JSValue* exception) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;

    WLOGD("Running Wasm3Module::%s", __func__);

    size_t export_num = 0;

    JSObject export_obj;
    JSValue name_str;
    // handle global exports
    JSValue js_kind_str = js_env->MakeString("global");
    for (int i = 0; i < module_->numGlobals; i++) {
      const M3Global& gbl_obj = module_->globals[i];
      if (gbl_obj.name) {
        export_obj = js_env->MakeObject();
        name_str = js_env->MakeString(gbl_obj.name);
        js_env->SetProperty(export_obj, "name", name_str);
        // need to dup for quickjs values
        js_env->DupValue(js_kind_str);
        js_env->SetProperty(export_obj, "kind", js_kind_str);
        js_env->SetPropertyAtIndex(array, export_num++, export_obj);
      }
    }
    js_env->FreeValue(js_kind_str);

    // handle func exports
    js_kind_str = js_env->MakeString("function");
    IM3Function fn = NULL;
    M3ExportedFunction* cur = module_->exportedFuncs;
    while (cur && (fn = cur->func)) {
      int start_index = fn->import.fieldUtf8 ? 1 : 0;
      for (int i = start_index; i < fn->numNames; ++i) {
        const char* func_name = fn->names[i];
        if (func_name) {
          export_obj = js_env->MakeObject();
          name_str = js_env->MakeString(func_name);
          js_env->SetProperty(export_obj, "name", name_str);
          // need to dup for quickjs values
          js_env->DupValue(js_kind_str);
          js_env->SetProperty(export_obj, "kind", js_kind_str);
          js_env->SetPropertyAtIndex(array, export_num++, export_obj);
        }
      }
      cur = cur->next;
    }
    js_env->FreeValue(js_kind_str);

    // handle func exports
    // if table0 exported, make WasmTable for exports.
    js_kind_str = js_env->MakeString("table");
    if (module_->tableInfo.tableName) {
      export_obj = js_env->MakeObject();
      name_str = js_env->MakeString(module_->tableInfo.tableName);
      js_env->SetProperty(export_obj, "name", name_str);
      js_env->DupValue(js_kind_str);
      js_env->SetProperty(export_obj, "kind", js_kind_str);
      js_env->SetPropertyAtIndex(array, export_num++, export_obj);
    }
    js_env->FreeValue(js_kind_str);

    // handle memory exports
    js_kind_str = js_env->MakeString("memory");
    if (module_->memoryNameCount) {
      for (uint8_t idx = 0; idx < module_->memoryNameCount; idx++) {
        export_obj = js_env->MakeObject();
        name_str = js_env->MakeString(module_->memoryNames[idx]);
        js_env->SetProperty(export_obj, "name", name_str);
        js_env->DupValue(js_kind_str);
        js_env->SetProperty(export_obj, "kind", js_kind_str);
        js_env->SetPropertyAtIndex(array, export_num++, export_obj);
      }
    }
    js_env->FreeValue(js_kind_str);
  }

  template <typename JSEnv>
  void imports(JSEnv* js_env, typename JSEnv::JSValue array,
               typename JSEnv::JSValue* exception) {
    using JSValue = typename JSEnv::JSValue;
    using JSObject = typename JSEnv::JSObject;

    js_env->MakeException(ErrorTypes::kError, "",
                          "WebAssembly.Module.imports not implemented!",
                          exception);
  }

  // Temporary approach.
  IM3Module module() const { return module_; }

  void FreeModule();

 private:
  BORROWER Wasm3Runtime* runtime_;

  OWNER uint8_t* data_;
  const size_t len_ = 0;

  OWNER IM3Module module_;
};

}  // namespace primjs::wasm
