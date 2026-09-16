// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/prism/wasm_table.h"

#include <cstddef>

#include "common/wasm_log.h"
#include "common/wasm_utils.h"
#include "prism/prism.h"
#include "prism/wasm_c_api.h"
#include "runtime/prism/wasm_function.h"
#include "runtime/prism/wasm_instance.h"
#include "runtime/prism/wasm_runtime.h"

namespace primjs::wasm {
class PrismInstance;

static_assert(offsetof(prism_func, is_import) == (sizeof(void*) == 8 ? 24 : 16),
              "Prism function prefix layout changed");

PrismTable::PrismTable(PrismRuntime* runtime, uint32_t initial,
                       uint32_t maximum, wasm_table_t* table)
    : maximum_(maximum), runtime_(runtime), table_(table) {
  if (!table) {
    wasm_limits_t limits = {initial, maximum};
    wasm_tabletype_t* type = wasm_tabletype_new(NULL, &limits);
    table_ = wasm_table_new(runtime->wasm_store(), type, nullptr);
    wasm_tabletype_delete(type);
  }
}

PrismTable::PrismTable(PrismRuntime* runtime, wasm_table_t* table,
                       PrismInstance* instance)
    : runtime_(runtime),
      table_(table),
      instance_(instance),
      owns_handle_(true) {
  wasm_tabletype_t* type = wasm_table_type(table);
  const wasm_limits_t* limits = wasm_tabletype_limits(type);
  maximum_ = limits->max;
  PrismInstance::IncreaseRefCount(instance_);
  wasm_tabletype_delete(type);
}

PrismTable::~PrismTable() {
  WLOGD("Running PrismTable::%s...", __func__);
  if (owns_handle_) {
    wasm_table_delete(table_);
  }
  table_ = nullptr;
  PrismInstance::DecreaseRefCount(instance_);
}

uint32_t PrismTable::size() { return wasm_table_size(table_); }

uintptr_t PrismTable::function_identity(size_t index) const {
  if (wasm_unlikely(!table_ || index >= wasm_table_size(table_))) {
    return 0;
  }

  prism_table* entries = prism_get_table(table_);
  if (wasm_unlikely(!entries || !entries[index])) {
    return 0;
  }

  prism_func* func = entries[index];
  // Prism 1.1.6 may place a per-slot lazy wrapper in the table. For a
  // non-import function, its userdata points at the underlying function,
  // which is the stable JS identity used by exported-function caches.
  if (!func->is_import) {
    if (void* target = prism_get_prism_func_userdata(func)) {
      func = static_cast<prism_func*>(target);
    }
  }
  return reinterpret_cast<uintptr_t>(func);
}

wasm_func_t* PrismTable::get(size_t index) {
  // Index has been ensured by caller.
  WLOGD("Running Table.get(%zu)...", index);

  wasm_ref_t* elem = wasm_table_get(table_, index);
  wasm_func_t* target = wasm_ref_as_func(elem);
  wasm_ref_delete(elem);

  // Prism 1.1.6 registers this handle in the store's function list. Its type
  // and handle are released with the store; clearing it earlier would leave a
  // list entry that later cross-instance calls can still resolve.
  return target;
}

bool PrismTable::set(size_t index, wasm_func_t* func_data) {
  if (wasm_unlikely(!table_)) {
    WLOGE("Table.set(%zu) = %p failed", index, func_data);
    return false;
  }

  WLOGD("Running Table.set(%zu) = %p...", index, func_data);
  wasm_ref_t* func_ref = wasm_func_as_ref(func_data);
  return wasm_table_set(table_, index, func_ref);
}

bool PrismTable::grow(uint32_t num) {
  uint32_t old_size = size();
  bool grew = table_ && wasm_table_grow(table_, num, nullptr);
  if (wasm_likely(grew)) {
    WLOGD("Running Table.grow from [%u] to [%u]...", old_size, old_size + num);
    return true;
  } else {
    WLOGE("Table.grow from [%u] to [%u] failed!", old_size, old_size + num);
    return false;
  }
}

bool PrismTable::OutOfBounds(uint32_t delta) const {
  return wasm_table_size(table_) + delta > maximum_;
}

}  // namespace primjs::wasm
