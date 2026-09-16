// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// ---------------------------------------------------------------------------
// SCOPE: this header is the open-source build's private contract for the
// dummy Prism stub in oss/src/wasm/prism/prism_dummy.cc. It is NOT a mirror of
// the upstream Prism include/prism.h, and it must NOT be hand-synced against
// it.
//
// It is reachable only from the two open-source targets that put
// oss/src/wasm/include on the include path (oss/tools/qjs-cli/BUILD.gn and
// oss/Android/PrimjsWasm/cmake/QJSWasm.cmake). Those targets link the stub,
// whose entry points all return nullptr/0, so no real prism_func object is
// ever dereferenced through the declarations below and the layout here does
// not have to match upstream.
//
// The internal build never sees this file: it compiles the real runtime
// sources against the pinned Prism release, whose headers arrive
// automatically (Android: cmake/Prism.cmake `prism_include`; iOS: the
// `prism/runtime` pod; GN: ${root_build_dir}/prism/out/include). The layout
// here therefore differs from upstream on purpose.
//
// Do not "fix" that difference by copying upstream text in. If a real
// (non-stub) consumer ever needs a field, take the header from the pinned
// release instead. Shared runtime code must not depend on prism_func's private
// tail layout.
// ---------------------------------------------------------------------------

#ifndef PRISM_EXTERN_H_
#define PRISM_EXTERN_H_

#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

#include "wasm_c_api.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef int64_t prism_pc;
typedef uint16_t prism_tp;
typedef uint32_t prism_reg;
typedef uint64_t prism_ir;
typedef double prism_fr;
typedef uint64_t prism_mcp_slot;
typedef uint64_t prism_st;
typedef uint8_t prism_mem;
typedef uint64_t prism_st_slot;
typedef struct prism_global prism_global;

// Compile-only callback contract for the dummy runtime. Stub instance creation
// always fails, so these callbacks are never installed or executed.
typedef enum { prism_err_unfinished = 1 } prism_result;
typedef struct {
  uint32_t frame_size;
} prism_stub_stack_info;

#define HANDLER_SIG                                      \
  prism_mcp_slot *pc, prism_st_slot *st, prism_mem *mem, \
      prism_stub_stack_info *sinfo
#define GET_INT_IMM_VALUE(slot, type) (*(type*)(slot))
#define GET_INT_SLOT_VALUE(slot, type) (*(type*)(slot))
#define SET_INT_VAR_VALUE(slot, value, type) (*(type*)(slot) = (value))
#define DUMP_CALL_NATIVE_END(retc, ret) ((void)0)
#define PRISM_NATIVE_REENTRY_EPILOGUE(pc) return prism_err_unfinished

typedef enum {
  I32 = 0x7f,
  I64 = 0x7e,
  F32 = 0x7d,
  F64 = 0x7c
} prism_value_type;

struct prism_func_info {
  uint32_t ret_nb;
  uint32_t arg_nb;
  prism_value_type* type;  // ret is in front of arg
};

struct prism_import_info {
  const char* mod;
  const char* field;
};

typedef struct prism_func_info prism_func_info;
typedef struct prism_import_info prism_import_info;
typedef struct prism_op prism_op;
typedef struct reg_map reg_map;
typedef struct prism_mem_info prism_mem_info;

typedef struct {
  char* name;
  prism_func_info info;
  bool is_import;
  bool is_c_api;
  prism_import_info import_info;
  uint64_t local_count;
  prism_value_type* local_types;
  uint32_t idx;
  uint32_t ops_size;
  prism_op* ops;
  uint32_t ops_capacity;
  reg_map* rm;
  reg_map* frm;
  prism_tp tp_max;
  prism_tp ftp_max;
  void* func_entry;
  uint32_t mcp_size;
  void* userdata;
} prism_func;

typedef prism_func* prism_table;

typedef struct prism_module_import_view {
  const char* module_name;
  size_t module_name_size;
  const char* field_name;
  size_t field_name_size;
  wasm_externkind_t kind;
} prism_module_import_view;

size_t prism_module_import_count(const wasm_module_t* module);
bool prism_module_imports_are_all_functions(const wasm_module_t* module);
bool prism_module_import_borrow(const wasm_module_t* module, size_t index,
                                prism_module_import_view* out);
bool prism_module_import_func_matches(const wasm_module_t* module, size_t index,
                                      const wasm_func_t* func);
wasm_func_t* prism_func_new_with_env_for_import(
    wasm_store_t* store, const wasm_module_t* module, size_t index,
    wasm_func_callback_with_env_t callback, void* env,
    void (*finalizer)(void*));

prism_func* prism_get_func(wasm_func_t* func);
prism_func* prism_get_func_ptr(const wasm_instance_t* instance, uint32_t index);
prism_global* prism_get_global_ptr(wasm_global_t* global);
prism_mem* prism_update_memory(prism_mem* mem);
prism_table* prism_get_table(wasm_table_t* tab);
prism_mem_info* prism_get_memory(wasm_memory_t* mem);
wasm_global_t* prism_get_global(const wasm_module_t* mod, uint32_t idx);
uint32_t prism_get_global_idx(wasm_global_t* global);
const wasm_module_t* prism_get_module(wasm_instance_t* inst);
void prism_g_zone_clean();
void* prism_get_prism_func_userdata(prism_func* pf);
#ifdef __cplusplus
}  // extern "C"
#endif

#endif
