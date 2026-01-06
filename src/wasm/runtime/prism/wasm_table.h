// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_WASM_PRISM_TABLE_H_
#define SRC_WASM_RUNTIME_WASM_PRISM_TABLE_H_

#include <cstdint>
#include <cstdlib>
#include <map>
#include <memory>

#include "prism/wasm_c_api.h"

namespace primjs {
namespace wasm {
class PrismFunction;
class PrismInstance;
class PrismRuntime;

class PrismTable {
 public:
  using elem_ref = wasm_ref_t;

  PrismTable(PrismRuntime* runtime, uint32_t initial, uint32_t maximum,
             wasm_table_t* table);
  PrismTable(PrismRuntime* runtime, wasm_table_t* table,
             PrismInstance* instance);
  ~PrismTable();

  uint32_t size();
  // return the function ref at tbl[index]
  wasm_func_t* get(size_t index);

  wasm_table_t* table() { return table_; }

  bool OutOfBounds(uint32_t size) const;

  bool set(size_t index, wasm_func_t* func_data);
  bool grow(uint32_t num);

  bool valid() const { return table_ != nullptr; }

  PrismRuntime* runtime() const { return runtime_; }
  PrismInstance* instance() const { return instance_; }

 private:
  uint32_t maximum_;
  PrismRuntime* runtime_;
  wasm_table_t* table_;
  PrismInstance* instance_ = nullptr;
};

}  // namespace wasm
}  // namespace primjs
#endif  // SRC_WASM_RUNTIME_WASM_PRISM_TABLE_H_
