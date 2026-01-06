// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_PRISM_WASM_MODULE_H_
#define SRC_WASM_RUNTIME_PRISM_WASM_MODULE_H_

#include "prism/wasm_c_api.h"
#include "runtime/prism/wasm_instance.h"
#include "runtime/prism/wasm_runtime.h"

namespace primjs {
namespace wasm {
constexpr const char* extern_type_kinds[] = {"function", "global", "table",
                                             "memory"};

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
      const char* kind_str = extern_type_kinds[wasm_externtype_kind(e_type)];
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
      const char* kind_str = extern_type_kinds[wasm_externtype_kind(e_type)];
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
  }

  // Temporary approach.
  wasm_module_t* module() const { return module_; }

  PrismRuntime* runtime() const { return runtime_; }

  // Note:
  // There is no need to check whether wasm runtime is instantiated
  // when creating a wasm instance, because only if a valid wasm
  // module is provided this function will be called.
  template <typename JSEnv>
  PrismInstance* CreateWasmInstance(JSEnv* js_env,
                                    typename JSEnv::JSObject import,
                                    InteropRuntime* interop,
                                    WasmResult& result) {
    result = WasmSucceed;
    wasm_importtype_vec_t import_types;

    wasm_module_imports(module_, &import_types);

    wasm_extern_t* externs[import_types.size];
    wasm_extern_vec_t imports_vec = WASM_ARRAY_VEC(externs);
    // When the module requires non-empty importing object, aka.
    // import_types.size > 0, we return nullptr if no imported object is
    // provided or import-binding fails.
    auto prism_instance = new PrismInstance(runtime_);
    if (import_types.size &&
        prism_instance->BindImports(js_env, import, interop, &import_types,
                                    externs, module_, prism_instance)) {
      return nullptr;
    }

    wasm_instance_t* wasm_instance =
        wasm_instance_new_with_args(runtime_->wasm_store(), module_,
                                    &imports_vec, nullptr, KILOBYTE(32), 0);
    if (!wasm_instance) {
      result = "create prism instance failed";
      return nullptr;
    }
    prism_instance->set_instance(wasm_instance);
    return prism_instance;
  }

 private:
  PrismRuntime* runtime_;

  wasm_module_t* module_;
};

}  // namespace wasm
}  // namespace primjs

#endif  // SRC_WASM_RUNTIME_PRISM_WASM_MODULE_H_
