// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/prism/wasm_table.h"

#include <string>

#include "common/wasm_log.h"
#include "prism/wasm_c_api.h"
#include "runtime/prism/wasm_function.h"
#include "runtime/prism/wasm_instance.h"
#include "runtime/prism/wasm_runtime.h"

namespace primjs::wasm {
class PrismInstance;

PrismTable::PrismTable(PrismRuntime* runtime, uint32_t initial,
                       uint32_t maximum, wasm_table_t* table)
    : maximum_(maximum), runtime_(runtime), table_(table) {
  if (!table) {
    wasm_limits_t limits = {initial, maximum};
    wasm_tabletype_t* type = wasm_tabletype_new(NULL, &limits);
    table_ = wasm_table_new(NULL, type, NULL);
  }
}

PrismTable::PrismTable(PrismRuntime* runtime, wasm_table_t* table,
                       PrismInstance* instance)
    : runtime_(runtime), table_(table), instance_(instance) {
  const wasm_tabletype_t* type = wasm_table_type(table);
  const wasm_limits_t* limits = wasm_tabletype_limits(type);
  maximum_ = limits->max;
  PrismInstance::IncreaseRefCount(instance_);
}

PrismTable::~PrismTable() {
  WLOGD("Running PrismTable::%s...", __func__);
  if (table_) {
    wasm_table_delete(table_);
  }
  PrismInstance::DecreaseRefCount(instance_);
}

uint32_t PrismTable::size() { return wasm_table_size(table_); }

wasm_func_t* PrismTable::get(size_t index) {
  // Index has been ensured by caller.
  WLOGD("Running Table.get(%zu)...", index);

  wasm_ref_t* elem = wasm_table_get(table_, index);
  wasm_func_t* target = wasm_ref_as_func(elem);

  // TODO wasm_ref_delete not defined in prism
  // wasm_ref_delete(elem);

  // create anonymous js wasm function
  return target;
}

bool PrismTable::set(size_t index, wasm_func_t* func_data) {
  // Index has been ensured by caller.
  WLOGD("Running Table.set(%zu) = %p...", index, func_data);

  if (!table_) return false;

  wasm_ref_t* func_ref = wasm_func_as_ref(func_data);

  return wasm_table_set(table_, index, func_ref);
}

bool PrismTable::grow(uint32_t num) {
  WLOGD("Running Table.grow from [%u] to [%u]...", size(), size() + num);

  if (table_ && wasm_table_grow(table_, num, nullptr)) {
    return true;
  }
  WLOGI("Table.grow from [%u] to [%u] failed!", size(), size() + num);
  return false;
}

bool PrismTable::OutOfBounds(uint32_t delta) const {
  return wasm_table_size(table_) + delta > maximum_;
}

}  // namespace primjs::wasm
