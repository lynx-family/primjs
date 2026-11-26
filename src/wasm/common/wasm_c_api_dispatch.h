// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_WASM_C_API_DISPATCH_H_
#define SRC_WASM_COMMON_WASM_C_API_DISPATCH_H_

#include "prism/wasm_c_api.h"

#define PRIMJS_WASM_C_API_SUFFIX_LIST(M, A) \
  M(A, byte_vec_delete)                     \
  M(A, engine_new)                          \
  M(A, engine_delete)                       \
  M(A, store_new)                           \
  M(A, store_delete)                        \
  M(A, valtype_new)                         \
  M(A, valtype_delete)                      \
  M(A, valtype_kind)                        \
  M(A, functype_params)                     \
  M(A, functype_results)                    \
  M(A, functype_delete)                     \
  M(A, globaltype_content)                  \
  M(A, globaltype_mutability)               \
  M(A, tabletype_new)                       \
  M(A, tabletype_delete)                    \
  M(A, tabletype_limits)                    \
  M(A, memorytype_new)                      \
  M(A, memorytype_delete)                   \
  M(A, memorytype_limits)                   \
  M(A, externtype_kind)                     \
  M(A, externtype_as_functype_const)        \
  M(A, externtype_as_globaltype_const)      \
  M(A, externtype_as_tabletype_const)       \
  M(A, externtype_as_memorytype_const)      \
  M(A, importtype_module)                   \
  M(A, importtype_name)                     \
  M(A, importtype_type)                     \
  M(A, importtype_vec_delete)               \
  M(A, exporttype_name)                     \
  M(A, exporttype_vec_delete)               \
  M(A, module_new)                          \
  M(A, module_delete)                       \
  M(A, module_imports)                      \
  M(A, module_exports)                      \
  M(A, trap_new)                            \
  M(A, trap_delete)                         \
  M(A, trap_message)                        \
  M(A, func_new_with_env)                   \
  M(A, func_delete)                         \
  M(A, func_type)                           \
  M(A, func_call)                           \
  M(A, func_as_extern)                      \
  M(A, func_as_ref)                         \
  M(A, func_get_host_info)                  \
  M(A, func_set_host_info)                  \
  M(A, global_new)                          \
  M(A, global_delete)                       \
  M(A, global_get)                          \
  M(A, global_as_extern)                    \
  M(A, table_new)                           \
  M(A, table_delete)                        \
  M(A, table_type)                          \
  M(A, table_get)                           \
  M(A, table_set)                           \
  M(A, table_size)                          \
  M(A, table_grow)                          \
  M(A, table_as_extern)                     \
  M(A, table_get_host_info)                 \
  M(A, table_set_host_info)                 \
  M(A, memory_new)                          \
  M(A, memory_delete)                       \
  M(A, memory_copy)                         \
  M(A, memory_type)                         \
  M(A, memory_data)                         \
  M(A, memory_data_size)                    \
  M(A, memory_grow)                         \
  M(A, memory_as_extern)                    \
  M(A, memory_get_host_info)                \
  M(A, memory_set_host_info)                \
  M(A, extern_kind)                         \
  M(A, extern_as_func)                      \
  M(A, extern_as_global)                    \
  M(A, extern_as_table)                     \
  M(A, extern_as_memory)                    \
  M(A, extern_vec_delete)                   \
  M(A, ref_as_func)                         \
  M(A, ref_delete)                          \
  M(A, instance_new)                        \
  M(A, instance_delete)                     \
  M(A, instance_exports)

#define PRIMJS_WASM_APPLY_PREFIX(V, suffix) V(wasm_##suffix)
#define PRIMJS_WASM_C_API_FUNCTIONS(V) \
  PRIMJS_WASM_C_API_SUFFIX_LIST(PRIMJS_WASM_APPLY_PREFIX, V)

#ifdef __cplusplus
namespace primjs::wasm {

struct WasmCApiTable {
#define PRIMJS_DECLARE_FIELD(name) decltype(&::name) fn_##name;
  PRIMJS_WASM_C_API_FUNCTIONS(PRIMJS_DECLARE_FIELD)
#undef PRIMJS_DECLARE_FIELD
};

constexpr size_t kWasmCApiSymbolCount = sizeof(WasmCApiTable) / sizeof(void*);

#if defined(PRIMJS_WASM_DYNAMIC_C_API)
extern WasmCApiTable g_wasm_c_api;

using WasmCApiSymbolResolver = void* (*)(void* library_handle,
                                         const char* symbol_name);

// Resolves every required wasm.h C API entry point via `resolve_symbol`.
// Publishes `g_wasm_c_api` only when all symbols resolve cleanly.
bool BindWasmCApiFromLibrary(void* library_handle,
                             WasmCApiSymbolResolver resolve_symbol,
                             const char** missing_symbol);
bool BindWasmCApiFromTable(const void* const* symbol_table,
                           size_t symbol_count);
bool IsWasmCApiBound();
void ResetWasmCApiForTesting();
#endif

}  // namespace primjs::wasm

#if defined(PRIMJS_WASM_DYNAMIC_C_API)
#define wasm_byte_vec_delete \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_byte_vec_delete)
#define wasm_engine_new (*::primjs::wasm::g_wasm_c_api.fn_wasm_engine_new)
#define wasm_engine_delete (*::primjs::wasm::g_wasm_c_api.fn_wasm_engine_delete)
#define wasm_store_new (*::primjs::wasm::g_wasm_c_api.fn_wasm_store_new)
#define wasm_store_delete (*::primjs::wasm::g_wasm_c_api.fn_wasm_store_delete)
#define wasm_valtype_new (*::primjs::wasm::g_wasm_c_api.fn_wasm_valtype_new)
#define wasm_valtype_delete \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_valtype_delete)
#define wasm_valtype_kind (*::primjs::wasm::g_wasm_c_api.fn_wasm_valtype_kind)
#define wasm_functype_params \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_functype_params)
#define wasm_functype_results \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_functype_results)
#define wasm_functype_delete \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_functype_delete)
#define wasm_globaltype_content \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_globaltype_content)
#define wasm_globaltype_mutability \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_globaltype_mutability)
#define wasm_tabletype_new (*::primjs::wasm::g_wasm_c_api.fn_wasm_tabletype_new)
#define wasm_tabletype_delete \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_tabletype_delete)
#define wasm_tabletype_limits \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_tabletype_limits)
#define wasm_memorytype_new \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_memorytype_new)
#define wasm_memorytype_delete \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_memorytype_delete)
#define wasm_memorytype_limits \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_memorytype_limits)
#define wasm_externtype_kind \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_externtype_kind)
#define wasm_externtype_as_functype_const \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_externtype_as_functype_const)
#define wasm_externtype_as_globaltype_const \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_externtype_as_globaltype_const)
#define wasm_externtype_as_tabletype_const \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_externtype_as_tabletype_const)
#define wasm_externtype_as_memorytype_const \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_externtype_as_memorytype_const)
#define wasm_importtype_module \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_importtype_module)
#define wasm_importtype_name \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_importtype_name)
#define wasm_importtype_type \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_importtype_type)
#define wasm_importtype_vec_delete \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_importtype_vec_delete)
#define wasm_exporttype_name \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_exporttype_name)
#define wasm_exporttype_vec_delete \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_exporttype_vec_delete)
#define wasm_module_new (*::primjs::wasm::g_wasm_c_api.fn_wasm_module_new)
#define wasm_module_delete (*::primjs::wasm::g_wasm_c_api.fn_wasm_module_delete)
#define wasm_module_imports \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_module_imports)
#define wasm_module_exports \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_module_exports)
#define wasm_trap_new (*::primjs::wasm::g_wasm_c_api.fn_wasm_trap_new)
#define wasm_trap_delete (*::primjs::wasm::g_wasm_c_api.fn_wasm_trap_delete)
#define wasm_trap_message (*::primjs::wasm::g_wasm_c_api.fn_wasm_trap_message)
#define wasm_func_new_with_env \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_func_new_with_env)
#define wasm_func_delete (*::primjs::wasm::g_wasm_c_api.fn_wasm_func_delete)
#define wasm_func_type (*::primjs::wasm::g_wasm_c_api.fn_wasm_func_type)
#define wasm_func_call (*::primjs::wasm::g_wasm_c_api.fn_wasm_func_call)
#define wasm_func_as_extern \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_func_as_extern)
#define wasm_func_as_ref (*::primjs::wasm::g_wasm_c_api.fn_wasm_func_as_ref)
#define wasm_func_get_host_info \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_func_get_host_info)
#define wasm_func_set_host_info \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_func_set_host_info)
#define wasm_global_new (*::primjs::wasm::g_wasm_c_api.fn_wasm_global_new)
#define wasm_global_delete (*::primjs::wasm::g_wasm_c_api.fn_wasm_global_delete)
#define wasm_global_get (*::primjs::wasm::g_wasm_c_api.fn_wasm_global_get)
#define wasm_global_as_extern \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_global_as_extern)
#define wasm_table_new (*::primjs::wasm::g_wasm_c_api.fn_wasm_table_new)
#define wasm_table_delete (*::primjs::wasm::g_wasm_c_api.fn_wasm_table_delete)
#define wasm_table_type (*::primjs::wasm::g_wasm_c_api.fn_wasm_table_type)
#define wasm_table_get (*::primjs::wasm::g_wasm_c_api.fn_wasm_table_get)
#define wasm_table_set (*::primjs::wasm::g_wasm_c_api.fn_wasm_table_set)
#define wasm_table_size (*::primjs::wasm::g_wasm_c_api.fn_wasm_table_size)
#define wasm_table_grow (*::primjs::wasm::g_wasm_c_api.fn_wasm_table_grow)
#define wasm_table_as_extern \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_table_as_extern)
#define wasm_table_get_host_info \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_table_get_host_info)
#define wasm_table_set_host_info \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_table_set_host_info)
#define wasm_memory_new (*::primjs::wasm::g_wasm_c_api.fn_wasm_memory_new)
#define wasm_memory_delete (*::primjs::wasm::g_wasm_c_api.fn_wasm_memory_delete)
#define wasm_memory_copy (*::primjs::wasm::g_wasm_c_api.fn_wasm_memory_copy)
#define wasm_memory_type (*::primjs::wasm::g_wasm_c_api.fn_wasm_memory_type)
#define wasm_memory_data (*::primjs::wasm::g_wasm_c_api.fn_wasm_memory_data)
#define wasm_memory_data_size \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_memory_data_size)
#define wasm_memory_grow (*::primjs::wasm::g_wasm_c_api.fn_wasm_memory_grow)
#define wasm_memory_as_extern \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_memory_as_extern)
#define wasm_memory_get_host_info \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_memory_get_host_info)
#define wasm_memory_set_host_info \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_memory_set_host_info)
#define wasm_extern_kind (*::primjs::wasm::g_wasm_c_api.fn_wasm_extern_kind)
#define wasm_extern_as_func \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_extern_as_func)
#define wasm_extern_as_global \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_extern_as_global)
#define wasm_extern_as_table \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_extern_as_table)
#define wasm_extern_as_memory \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_extern_as_memory)
#define wasm_extern_vec_delete \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_extern_vec_delete)
#define wasm_ref_as_func (*::primjs::wasm::g_wasm_c_api.fn_wasm_ref_as_func)
#define wasm_ref_delete (*::primjs::wasm::g_wasm_c_api.fn_wasm_ref_delete)
#define wasm_instance_new (*::primjs::wasm::g_wasm_c_api.fn_wasm_instance_new)
#define wasm_instance_delete \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_instance_delete)
#define wasm_instance_exports \
  (*::primjs::wasm::g_wasm_c_api.fn_wasm_instance_exports)
#endif  // defined(PRIMJS_WASM_DYNAMIC_C_API)
#endif  // __cplusplus

#endif  // SRC_WASM_COMMON_WASM_C_API_DISPATCH_H_
