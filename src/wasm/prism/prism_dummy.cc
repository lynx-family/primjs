// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
//
// This is a dummy implementation for the prism c api for open source.

#include "prism/prism.h"
#include "prism/wasm_c_api.h"

// Dummy implementations for functions in prism.h

prism_func* prism_get_func(wasm_func_t* func) { return nullptr; }

prism_table* prism_get_table(wasm_table_t* tab) { return nullptr; }

prism_mem_info* prism_get_memory(wasm_memory_t* mem) { return nullptr; }

wasm_global_t* prism_get_global(const wasm_module_t* mod, uint32_t idx) {
  return nullptr;
}

uint32_t prism_get_global_idx(wasm_global_t* global) { return 0; }

const wasm_module_t* prism_get_module(wasm_instance_t* inst) { return nullptr; }

void prism_g_zone_clean() {
  // no-op
}

void* prism_get_prism_func_userdata(prism_func* pf) { return nullptr; }

// Dummy implementations for functions in wasm_c_api.h

void wasm_byte_vec_new_empty(wasm_byte_vec_t* out) {}

void wasm_byte_vec_new_uninitialized(wasm_byte_vec_t* out, size_t size) {}

void wasm_byte_vec_new(wasm_byte_vec_t* out, size_t size, byte_t const data[]) {
}

void wasm_byte_vec_copy(wasm_byte_vec_t* out, const wasm_byte_vec_t* vec) {}

void wasm_byte_vec_delete(wasm_byte_vec_t* vec) {}

wasm_engine_t* wasm_engine_new(void) { return nullptr; }

void wasm_engine_delete(wasm_engine_t* engine) {
  // no-op
}

wasm_store_t* wasm_store_new(wasm_engine_t* engine) { return nullptr; }

void wasm_store_delete(wasm_store_t* store) {
  // no-op
}

wasm_valtype_t* wasm_valtype_new(wasm_valkind_t kind) { return nullptr; }

wasm_valkind_t wasm_valtype_kind(const wasm_valtype_t* type) {
  return WASM_I32;
}

void wasm_valtype_delete(wasm_valtype_t* type) {
  // no-op
}

wasm_valtype_t* wasm_valtype_copy(const wasm_valtype_t* type) {
  return nullptr;
}

void wasm_valtype_vec_new_empty(wasm_valtype_vec_t* out) {}

void wasm_valtype_vec_new_uninitialized(wasm_valtype_vec_t* out, size_t size) {}

void wasm_valtype_vec_new(wasm_valtype_vec_t* out, size_t size,
                          wasm_valtype_t* const data[]) {}

void wasm_valtype_vec_copy(wasm_valtype_vec_t* out,
                           const wasm_valtype_vec_t* vec) {}

void wasm_valtype_vec_delete(wasm_valtype_vec_t* vec) {}

wasm_functype_t* wasm_functype_new(wasm_valtype_vec_t* params,
                                   wasm_valtype_vec_t* results) {
  return nullptr;
}

const wasm_valtype_vec_t* wasm_functype_params(const wasm_functype_t* type) {
  return nullptr;
}

const wasm_valtype_vec_t* wasm_functype_results(const wasm_functype_t* type) {
  return nullptr;
}

void wasm_functype_delete(wasm_functype_t* type) {
  // no-op
}

wasm_functype_t* wasm_functype_copy(const wasm_functype_t* type) {
  return nullptr;
}

wasm_globaltype_t* wasm_globaltype_new(wasm_valtype_t* type,
                                       wasm_mutability_t mut) {
  return nullptr;
}

const wasm_valtype_t* wasm_globaltype_content(const wasm_globaltype_t* type) {
  return nullptr;
}

wasm_mutability_t wasm_globaltype_mutability(const wasm_globaltype_t* type) {
  return WASM_CONST;
}

void wasm_globaltype_delete(wasm_globaltype_t* type) {
  // no-op
}

wasm_globaltype_t* wasm_globaltype_copy(const wasm_globaltype_t* type) {
  return nullptr;
}

wasm_tabletype_t* wasm_tabletype_new(wasm_valtype_t* type,
                                     const wasm_limits_t* limits) {
  return nullptr;
}

const wasm_valtype_t* wasm_tabletype_element(const wasm_tabletype_t* type) {
  return nullptr;
}

const wasm_limits_t* wasm_tabletype_limits(const wasm_tabletype_t* type) {
  return nullptr;
}

void wasm_tabletype_delete(wasm_tabletype_t* type) {
  // no-op
}

wasm_tabletype_t* wasm_tabletype_copy(const wasm_tabletype_t* type) {
  return nullptr;
}

wasm_memorytype_t* wasm_memorytype_new(const wasm_limits_t* limits) {
  return nullptr;
}

const wasm_limits_t* wasm_memorytype_limits(const wasm_memorytype_t* type) {
  return nullptr;
}

void wasm_memorytype_delete(wasm_memorytype_t* type) {
  // no-op
}

wasm_memorytype_t* wasm_memorytype_copy(const wasm_memorytype_t* type) {
  return nullptr;
}

wasm_externkind_t wasm_externtype_kind(const wasm_externtype_t* type) {
  return WASM_EXTERN_FUNC;
}

wasm_externtype_t* wasm_functype_as_externtype(wasm_functype_t* type) {
  return nullptr;
}

wasm_externtype_t* wasm_globaltype_as_externtype(wasm_globaltype_t* type) {
  return nullptr;
}

wasm_externtype_t* wasm_tabletype_as_externtype(wasm_tabletype_t* type) {
  return nullptr;
}

wasm_externtype_t* wasm_memorytype_as_externtype(wasm_memorytype_t* type) {
  return nullptr;
}

wasm_functype_t* wasm_externtype_as_functype(wasm_externtype_t* type) {
  return nullptr;
}

wasm_globaltype_t* wasm_externtype_as_globaltype(wasm_externtype_t* type) {
  return nullptr;
}

wasm_tabletype_t* wasm_externtype_as_tabletype(wasm_externtype_t* type) {
  return nullptr;
}

wasm_memorytype_t* wasm_externtype_as_memorytype(wasm_externtype_t* type) {
  return nullptr;
}

const wasm_externtype_t* wasm_functype_as_externtype_const(
    const wasm_functype_t* type) {
  return nullptr;
}

const wasm_externtype_t* wasm_globaltype_as_externtype_const(
    const wasm_globaltype_t* type) {
  return nullptr;
}

const wasm_externtype_t* wasm_tabletype_as_externtype_const(
    const wasm_tabletype_t* type) {
  return nullptr;
}

const wasm_externtype_t* wasm_memorytype_as_externtype_const(
    const wasm_memorytype_t* type) {
  return nullptr;
}

const wasm_functype_t* wasm_externtype_as_functype_const(
    const wasm_externtype_t* type) {
  return nullptr;
}

const wasm_globaltype_t* wasm_externtype_as_globaltype_const(
    const wasm_externtype_t* type) {
  return nullptr;
}

const wasm_tabletype_t* wasm_externtype_as_tabletype_const(
    const wasm_externtype_t* type) {
  return nullptr;
}

const wasm_memorytype_t* wasm_externtype_as_memorytype_const(
    const wasm_externtype_t* type) {
  return nullptr;
}

void wasm_externtype_delete(wasm_externtype_t* type) {
  // no-op
}

wasm_externtype_t* wasm_externtype_copy(const wasm_externtype_t* type) {
  return nullptr;
}

wasm_importtype_t* wasm_importtype_new(wasm_name_t* module, wasm_name_t* name,
                                       wasm_externtype_t* type) {
  return nullptr;
}

const wasm_name_t* wasm_importtype_module(const wasm_importtype_t* type) {
  return nullptr;
}

const wasm_name_t* wasm_importtype_name(const wasm_importtype_t* type) {
  return nullptr;
}

const wasm_externtype_t* wasm_importtype_type(const wasm_importtype_t* type) {
  return nullptr;
}

void wasm_importtype_delete(wasm_importtype_t* type) {
  // no-op
}

wasm_importtype_t* wasm_importtype_copy(const wasm_importtype_t* type) {
  return nullptr;
}

void wasm_importtype_vec_new_empty(wasm_importtype_vec_t* out) {}

void wasm_importtype_vec_new_uninitialized(wasm_importtype_vec_t* out,
                                           size_t size) {}

void wasm_importtype_vec_new(wasm_importtype_vec_t* out, size_t size,
                             wasm_importtype_t* const data[]) {}

void wasm_importtype_vec_copy(wasm_importtype_vec_t* out,
                              const wasm_importtype_vec_t* vec) {}

void wasm_importtype_vec_delete(wasm_importtype_vec_t* vec) {}

wasm_exporttype_t* wasm_exporttype_new(wasm_name_t* name,
                                       wasm_externtype_t* type) {
  return nullptr;
}

const wasm_name_t* wasm_exporttype_name(const wasm_exporttype_t* type) {
  return nullptr;
}

const wasm_externtype_t* wasm_exporttype_type(const wasm_exporttype_t* type) {
  return nullptr;
}

void wasm_exporttype_delete(wasm_exporttype_t* type) {
  // no-op
}

wasm_exporttype_t* wasm_exporttype_copy(const wasm_exporttype_t* type) {
  return nullptr;
}

void wasm_exporttype_vec_new_empty(wasm_exporttype_vec_t* out) {}

void wasm_exporttype_vec_new_uninitialized(wasm_exporttype_vec_t* out,
                                           size_t size) {}

void wasm_exporttype_vec_new(wasm_exporttype_vec_t* out, size_t size,
                             wasm_exporttype_t* const data[]) {}

void wasm_exporttype_vec_copy(wasm_exporttype_vec_t* out,
                              const wasm_exporttype_vec_t* vec) {}

void wasm_exporttype_vec_delete(wasm_exporttype_vec_t* vec) {}

void wasm_val_copy(wasm_val_t* out, const wasm_val_t* val) {}

void wasm_val_vec_new_empty(wasm_val_vec_t* out) {}

void wasm_val_vec_new_uninitialized(wasm_val_vec_t* out, size_t size) {}

void wasm_val_vec_new(wasm_val_vec_t* out, size_t size,
                      wasm_val_t const data[]) {}

void wasm_val_vec_copy(wasm_val_vec_t* out, const wasm_val_vec_t* vec) {}

void wasm_val_vec_delete(wasm_val_vec_t* vec) {}

void wasm_ref_delete(wasm_ref_t* ref) {
  // no-op
}

wasm_ref_t* wasm_ref_copy(const wasm_ref_t* ref) { return nullptr; }

bool wasm_ref_same(const wasm_ref_t* ref1, const wasm_ref_t* ref2) {
  return false;
}

void* wasm_ref_get_host_info(const wasm_ref_t* ref) { return nullptr; }

void wasm_ref_set_host_info(wasm_ref_t* ref, void* info) {
  // no-op
}

void wasm_ref_set_host_info_with_finalizer(wasm_ref_t* ref, void* info,
                                           void (*finalizer)(void*)) {
  // no-op
}

wasm_trap_t* wasm_trap_new(wasm_store_t* store, const wasm_message_t* message) {
  return nullptr;
}

void wasm_trap_message(const wasm_trap_t* trap, wasm_message_t* out) {
  // no-op
}

void wasm_trap_delete(wasm_trap_t* trap) {
  // no-op
}

wasm_trap_t* wasm_trap_copy(const wasm_trap_t* trap) { return nullptr; }

wasm_module_t* wasm_module_new(wasm_store_t* store,
                               const wasm_byte_vec_t* binary) {
  return nullptr;
}

void wasm_module_imports(const wasm_module_t* module,
                         wasm_importtype_vec_t* out) {
  // no-op
}

void wasm_module_exports(const wasm_module_t* module,
                         wasm_exporttype_vec_t* out) {
  // no-op
}

void wasm_module_delete(wasm_module_t* module) {
  // no-op
}

wasm_func_t* wasm_func_new(wasm_store_t* store, const wasm_functype_t* type,
                           wasm_func_callback_t callback) {
  return nullptr;
}

wasm_func_t* wasm_func_new_with_env(wasm_store_t* store,
                                    const wasm_functype_t* type,
                                    wasm_func_callback_with_env_t callback,
                                    void* env, void (*finalizer)(void*)) {
  return nullptr;
}

wasm_functype_t* wasm_func_type(const wasm_func_t* func) { return nullptr; }

size_t wasm_func_param_arity(const wasm_func_t* func) { return 0; }

size_t wasm_func_result_arity(const wasm_func_t* func) { return 0; }

wasm_trap_t* wasm_func_call(const wasm_func_t* func, const wasm_val_vec_t* args,
                            wasm_val_vec_t* results) {
  return nullptr;
}

void wasm_func_delete(wasm_func_t* func) {
  // no-op
}

wasm_func_t* wasm_func_copy(const wasm_func_t* func) { return nullptr; }

wasm_global_t* wasm_global_new(wasm_store_t* store,
                               const wasm_globaltype_t* type,
                               const wasm_val_t* val) {
  return nullptr;
}

wasm_globaltype_t* wasm_global_type(const wasm_global_t* global) {
  return nullptr;
}

void wasm_global_get(const wasm_global_t* global, wasm_val_t* out) {
  // no-op
}

void wasm_global_set(wasm_global_t* global, const wasm_val_t* val) {
  // no-op
}

void wasm_global_delete(wasm_global_t* global) {
  // no-op
}

wasm_global_t* wasm_global_copy(const wasm_global_t* global) { return nullptr; }

wasm_table_t* wasm_table_new(wasm_store_t* store, const wasm_tabletype_t* type,
                             wasm_ref_t* init) {
  return nullptr;
}

wasm_tabletype_t* wasm_table_type(const wasm_table_t* table) { return nullptr; }

wasm_ref_t* wasm_table_get(const wasm_table_t* table, wasm_table_size_t index) {
  return nullptr;
}

bool wasm_table_set(wasm_table_t* table, wasm_table_size_t index,
                    wasm_ref_t* ref) {
  return false;
}

wasm_table_size_t wasm_table_size(const wasm_table_t* table) { return 0; }

bool wasm_table_grow(wasm_table_t* table, wasm_table_size_t delta,
                     wasm_ref_t* init) {
  return false;
}

void wasm_table_delete(wasm_table_t* table) {
  // no-op
}

wasm_table_t* wasm_table_copy(const wasm_table_t* table) { return nullptr; }

wasm_memory_t* wasm_memory_new(wasm_store_t* store,
                               const wasm_memorytype_t* type) {
  return nullptr;
}

wasm_memorytype_t* wasm_memory_type(const wasm_memory_t* memory) {
  return nullptr;
}

byte_t* wasm_memory_data(wasm_memory_t* memory) { return nullptr; }

size_t wasm_memory_data_size(const wasm_memory_t* memory) { return 0; }

wasm_memory_pages_t wasm_memory_size(const wasm_memory_t* memory) { return 0; }

bool wasm_memory_grow(wasm_memory_t* memory, wasm_memory_pages_t delta) {
  return false;
}

void wasm_memory_delete(wasm_memory_t* memory) {
  // no-op
}

wasm_memory_t* wasm_memory_copy(const wasm_memory_t* memory) { return nullptr; }

wasm_externkind_t wasm_extern_kind(const wasm_extern_t* ext) {
  return WASM_EXTERN_FUNC;
}

wasm_externtype_t* wasm_extern_type(const wasm_extern_t* ext) {
  return nullptr;
}

wasm_extern_t* wasm_func_as_extern(wasm_func_t* func) { return nullptr; }

wasm_extern_t* wasm_global_as_extern(wasm_global_t* global) { return nullptr; }

wasm_extern_t* wasm_table_as_extern(wasm_table_t* table) { return nullptr; }

wasm_extern_t* wasm_memory_as_extern(wasm_memory_t* memory) { return nullptr; }

wasm_func_t* wasm_extern_as_func(wasm_extern_t* ext) { return nullptr; }

wasm_global_t* wasm_extern_as_global(wasm_extern_t* ext) { return nullptr; }

wasm_table_t* wasm_extern_as_table(wasm_extern_t* ext) { return nullptr; }

wasm_memory_t* wasm_extern_as_memory(wasm_extern_t* ext) { return nullptr; }

const wasm_extern_t* wasm_func_as_extern_const(const wasm_func_t* func) {
  return nullptr;
}

const wasm_extern_t* wasm_global_as_extern_const(const wasm_global_t* global) {
  return nullptr;
}

const wasm_extern_t* wasm_table_as_extern_const(const wasm_table_t* table) {
  return nullptr;
}

const wasm_extern_t* wasm_memory_as_extern_const(const wasm_memory_t* memory) {
  return nullptr;
}

const wasm_func_t* wasm_extern_as_func_const(const wasm_extern_t* ext) {
  return nullptr;
}

const wasm_global_t* wasm_extern_as_global_const(const wasm_extern_t* ext) {
  return nullptr;
}

const wasm_table_t* wasm_extern_as_table_const(const wasm_extern_t* ext) {
  return nullptr;
}

const wasm_memory_t* wasm_extern_as_memory_const(const wasm_extern_t* ext) {
  return nullptr;
}

void wasm_extern_delete(wasm_extern_t* ext) {
  // no-op
}

wasm_extern_t* wasm_extern_copy(const wasm_extern_t* ext) { return nullptr; }

void wasm_extern_vec_new_empty(wasm_extern_vec_t* out) {}

void wasm_extern_vec_new_uninitialized(wasm_extern_vec_t* out, size_t size) {}

void wasm_extern_vec_new(wasm_extern_vec_t* out, size_t size,
                         wasm_extern_t* const data[]) {}

void wasm_extern_vec_copy(wasm_extern_vec_t* out,
                          const wasm_extern_vec_t* vec) {}

void wasm_extern_vec_delete(wasm_extern_vec_t* vec) {}

wasm_instance_t* wasm_instance_new(wasm_store_t* store,
                                   const wasm_module_t* module,
                                   const wasm_extern_vec_t* imports,
                                   wasm_trap_t** trap) {
  return nullptr;
}

void wasm_instance_exports(const wasm_instance_t* instance,
                           wasm_extern_vec_t* out) {
  // no-op
}

void wasm_instance_delete(wasm_instance_t* instance) {
  // no-op
}

wasm_instance_t* wasm_instance_copy(const wasm_instance_t* instance) {
  return nullptr;
}
wasm_memory_t* wasm_import_memory_new(uint32_t initial, uint32_t maximum) {
  return nullptr;
}

void wasm_import_memory_delete(wasm_memory_t* memory) {
  // no-op
}

wasm_instance_t* wasm_instance_new_with_args(wasm_store_t* store,
                                             const wasm_module_t* module,
                                             const wasm_extern_vec_t* imports,
                                             wasm_trap_t** trap,
                                             const uint32_t stack_size,
                                             const uint32_t heap_size) {
  return nullptr;
}
wasm_func_t* wasm_ref_as_func(wasm_ref_t* ref) { return nullptr; }

wasm_ref_t* wasm_func_as_ref(wasm_func_t* func) { return nullptr; }
