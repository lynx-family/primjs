// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/wasm3/wasm_table.h"

#include <string>

#include "common/wasm_log.h"
#include "runtime/wasm3/wasm_function.h"
#include "runtime/wasm3/wasm_instance.h"
#include "runtime/wasm3/wasm_runtime.h"
#include "wasm3/m3_env.h"
#include "wasm3/wasm3.h"

namespace primjs::wasm {

Wasm3Table::Wasm3Table(Wasm3Runtime* runtime, uint32_t initial,
                       uint32_t maximum, TableElemType type, M3Result* err)
    : runtime_(runtime),
      maximum_(maximum),
      table_(nullptr),
      instance_(nullptr) {
  // TODO(wasm): support extern reference type.
  WASM_DCHECK(type == TableElemType::kFuncRef);
  M3Result result = m3Err_none;
  result = m3_NewTable(&table_, kFuncRef, initial, maximum);
  if (err) *err = result;
}

Wasm3Table::Wasm3Table(Wasm3Runtime* runtime, IM3Table table,
                       Wasm3Instance* instance)
    : runtime_(runtime), table_(table), instance_(instance) {
  maximum_ = table_->info.maxSize;
  Wasm3Instance::IncreaseRefCount(instance_);
}

Wasm3Table::~Wasm3Table() {
  WLOGD("Running Wasm3Table::%s...", __func__);
  if (table_) m3_FreeTable(table_);
  Wasm3Instance::DecreaseRefCount(instance_);
}

uint32_t Wasm3Table::size() { return table_->info.curSize; }

// return the function ref at tbl[index]
IM3Function Wasm3Table::get(size_t index) {
  // Index has been ensured by caller.
  WLOGD("Running Table.get(%zu)...", index);

  IM3Function target = table_ ? table_->funcs[index] : nullptr;
  return target;
}

bool Wasm3Table::set(size_t index, IM3Function func_data) {
  // index has been ensured by caller.
  WLOGD("Running Table.set(%zu) = %p...", index, func_data);

  if (!table_) return false;

  table_->funcs[index] = func_data;

  return true;
}

bool Wasm3Table::grow(uint32_t num) {
  WLOGD("Running Table.grow from [%u] to [%u]...", size(), size() + num);
  M3Result result = m3Err_none;
  result = m3_GrowTable(table_, num);
  if (result) {
    WLOGE("Grow table in wasm runtime failed: %s", result);
    return false;
  }

  return true;
}

bool Wasm3Table::OutOfBounds(uint32_t delta) const {
  return table_->info.curSize + delta > maximum_;
}
}  // namespace primjs::wasm
