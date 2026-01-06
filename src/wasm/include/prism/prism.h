// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRISM_EXTERN_H_
#define PRISM_EXTERN_H_

#include <stdbool.h>
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

prism_func* prism_get_func(wasm_func_t* func);
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
