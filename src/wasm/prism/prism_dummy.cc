// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>

#include "prism/wasm_c_api.h"

// Stub definitions of the standard WebAssembly C API (wasm.h) for standalone
// open-source builds that compile the JS binding without linking Prism.

extern "C" {

void wasm_byte_vec_delete(wasm_byte_vec_t* v) {
  if (v) {
    v->size = 0;
    v->data = nullptr;
  }
}

wasm_engine_t* wasm_engine_new(void) { return nullptr; }
void wasm_engine_delete(wasm_engine_t*) {}

wasm_store_t* wasm_store_new(wasm_engine_t*) { return nullptr; }
void wasm_store_delete(wasm_store_t*) {}

wasm_valtype_t* wasm_valtype_new(wasm_valkind_t) { return nullptr; }
void wasm_valtype_delete(wasm_valtype_t*) {}
wasm_valkind_t wasm_valtype_kind(const wasm_valtype_t*) { return WASM_I32; }

const wasm_valtype_vec_t* wasm_functype_params(const wasm_functype_t*) {
  return nullptr;
}
const wasm_valtype_vec_t* wasm_functype_results(const wasm_functype_t*) {
  return nullptr;
}
void wasm_functype_delete(wasm_functype_t*) {}

wasm_globaltype_t* wasm_globaltype_new(wasm_valtype_t*, wasm_mutability_t) {
  return nullptr;
}
void wasm_globaltype_delete(wasm_globaltype_t*) {}
const wasm_valtype_t* wasm_globaltype_content(const wasm_globaltype_t*) {
  return nullptr;
}
wasm_mutability_t wasm_globaltype_mutability(const wasm_globaltype_t*) {
  return WASM_CONST;
}

wasm_tabletype_t* wasm_tabletype_new(wasm_valtype_t*, const wasm_limits_t*) {
  return nullptr;
}
void wasm_tabletype_delete(wasm_tabletype_t*) {}
const wasm_limits_t* wasm_tabletype_limits(const wasm_tabletype_t*) {
  return nullptr;
}

wasm_memorytype_t* wasm_memorytype_new(const wasm_limits_t*) { return nullptr; }
void wasm_memorytype_delete(wasm_memorytype_t*) {}
const wasm_limits_t* wasm_memorytype_limits(const wasm_memorytype_t*) {
  return nullptr;
}

wasm_externkind_t wasm_externtype_kind(const wasm_externtype_t*) {
  return WASM_EXTERN_FUNC;
}
const wasm_functype_t* wasm_externtype_as_functype_const(
    const wasm_externtype_t*) {
  return nullptr;
}
const wasm_globaltype_t* wasm_externtype_as_globaltype_const(
    const wasm_externtype_t*) {
  return nullptr;
}
const wasm_tabletype_t* wasm_externtype_as_tabletype_const(
    const wasm_externtype_t*) {
  return nullptr;
}
const wasm_memorytype_t* wasm_externtype_as_memorytype_const(
    const wasm_externtype_t*) {
  return nullptr;
}

const wasm_name_t* wasm_importtype_module(const wasm_importtype_t*) {
  return nullptr;
}
const wasm_name_t* wasm_importtype_name(const wasm_importtype_t*) {
  return nullptr;
}
const wasm_externtype_t* wasm_importtype_type(const wasm_importtype_t*) {
  return nullptr;
}
void wasm_importtype_vec_delete(wasm_importtype_vec_t* v) {
  if (v) {
    v->size = 0;
    v->data = nullptr;
  }
}

const wasm_name_t* wasm_exporttype_name(const wasm_exporttype_t*) {
  return nullptr;
}
const wasm_externtype_t* wasm_exporttype_type(const wasm_exporttype_t*) {
  return nullptr;
}
void wasm_exporttype_vec_delete(wasm_exporttype_vec_t* v) {
  if (v) {
    v->size = 0;
    v->data = nullptr;
  }
}

wasm_module_t* wasm_module_new(wasm_store_t*, const wasm_byte_vec_t*) {
  return nullptr;
}
void wasm_module_delete(wasm_module_t*) {}
void wasm_module_imports(const wasm_module_t*, wasm_importtype_vec_t* out) {
  if (out) {
    out->size = 0;
    out->data = nullptr;
  }
}
void wasm_module_exports(const wasm_module_t*, wasm_exporttype_vec_t* out) {
  if (out) {
    out->size = 0;
    out->data = nullptr;
  }
}

wasm_trap_t* wasm_trap_new(wasm_store_t*, const wasm_message_t*) {
  return nullptr;
}
void wasm_trap_delete(wasm_trap_t*) {}
void wasm_trap_message(const wasm_trap_t*, wasm_message_t* out) {
  if (out) {
    out->size = 0;
    out->data = nullptr;
  }
}

wasm_func_t* wasm_func_new_with_env(wasm_store_t*, const wasm_functype_t*,
                                    wasm_func_callback_with_env_t, void*,
                                    void (*)(void*)) {
  return nullptr;
}
void wasm_func_delete(wasm_func_t*) {}
wasm_func_t* wasm_func_copy(const wasm_func_t*) { return nullptr; }
wasm_functype_t* wasm_func_type(const wasm_func_t*) { return nullptr; }
wasm_trap_t* wasm_func_call(const wasm_func_t*, const wasm_val_vec_t*,
                            wasm_val_vec_t*) {
  return nullptr;
}
wasm_extern_t* wasm_func_as_extern(wasm_func_t*) { return nullptr; }
wasm_ref_t* wasm_func_as_ref(wasm_func_t*) { return nullptr; }
void* wasm_func_get_host_info(const wasm_func_t*) { return nullptr; }
void wasm_func_set_host_info(wasm_func_t*, void*) {}

wasm_global_t* wasm_global_new(wasm_store_t*, const wasm_globaltype_t*,
                               const wasm_val_t*) {
  return nullptr;
}
void wasm_global_delete(wasm_global_t*) {}
wasm_global_t* wasm_global_copy(const wasm_global_t*) { return nullptr; }
wasm_globaltype_t* wasm_global_type(const wasm_global_t*) { return nullptr; }
void wasm_global_get(const wasm_global_t*, wasm_val_t* out) {
  if (out) std::memset(out, 0, sizeof(*out));
}
void wasm_global_set(wasm_global_t*, const wasm_val_t*) {}
wasm_extern_t* wasm_global_as_extern(wasm_global_t*) { return nullptr; }
void* wasm_global_get_host_info(const wasm_global_t*) { return nullptr; }
void wasm_global_set_host_info(wasm_global_t*, void*) {}

wasm_table_t* wasm_table_new(wasm_store_t*, const wasm_tabletype_t*,
                             wasm_ref_t*) {
  return nullptr;
}
void wasm_table_delete(wasm_table_t*) {}
wasm_table_t* wasm_table_copy(const wasm_table_t*) { return nullptr; }
wasm_tabletype_t* wasm_table_type(const wasm_table_t*) { return nullptr; }
wasm_ref_t* wasm_table_get(const wasm_table_t*, wasm_table_size_t) {
  return nullptr;
}
bool wasm_table_set(wasm_table_t*, wasm_table_size_t, wasm_ref_t*) {
  return false;
}
wasm_table_size_t wasm_table_size(const wasm_table_t*) { return 0; }
bool wasm_table_grow(wasm_table_t*, wasm_table_size_t, wasm_ref_t*) {
  return false;
}
wasm_extern_t* wasm_table_as_extern(wasm_table_t*) { return nullptr; }
void* wasm_table_get_host_info(const wasm_table_t*) { return nullptr; }
void wasm_table_set_host_info(wasm_table_t*, void*) {}

wasm_memory_t* wasm_memory_new(wasm_store_t*, const wasm_memorytype_t*) {
  return nullptr;
}
void wasm_memory_delete(wasm_memory_t*) {}
wasm_memory_t* wasm_memory_copy(const wasm_memory_t*) { return nullptr; }
wasm_memorytype_t* wasm_memory_type(const wasm_memory_t*) { return nullptr; }
byte_t* wasm_memory_data(wasm_memory_t*) { return nullptr; }
size_t wasm_memory_data_size(const wasm_memory_t*) { return 0; }
wasm_memory_pages_t wasm_memory_size(const wasm_memory_t*) { return 0; }
bool wasm_memory_grow(wasm_memory_t*, wasm_memory_pages_t) { return false; }
wasm_extern_t* wasm_memory_as_extern(wasm_memory_t*) { return nullptr; }
void* wasm_memory_get_host_info(const wasm_memory_t*) { return nullptr; }
void wasm_memory_set_host_info(wasm_memory_t*, void*) {}

wasm_externkind_t wasm_extern_kind(const wasm_extern_t*) {
  return WASM_EXTERN_FUNC;
}
wasm_func_t* wasm_extern_as_func(wasm_extern_t*) { return nullptr; }
wasm_global_t* wasm_extern_as_global(wasm_extern_t*) { return nullptr; }
wasm_table_t* wasm_extern_as_table(wasm_extern_t*) { return nullptr; }
wasm_memory_t* wasm_extern_as_memory(wasm_extern_t*) { return nullptr; }
void wasm_extern_vec_delete(wasm_extern_vec_t* v) {
  if (v) {
    v->size = 0;
    v->data = nullptr;
  }
}

wasm_func_t* wasm_ref_as_func(wasm_ref_t*) { return nullptr; }
void wasm_ref_delete(wasm_ref_t*) {}

wasm_instance_t* wasm_instance_new(wasm_store_t*, const wasm_module_t*,
                                   const wasm_extern_vec_t*, wasm_trap_t**) {
  return nullptr;
}
void wasm_instance_delete(wasm_instance_t*) {}
void wasm_instance_exports(const wasm_instance_t*, wasm_extern_vec_t* out) {
  if (out) {
    out->size = 0;
    out->data = nullptr;
  }
}

void wasm_val_copy(wasm_val_t* out, const wasm_val_t* src) {
  if (out && src) *out = *src;
}

}  // extern "C"
