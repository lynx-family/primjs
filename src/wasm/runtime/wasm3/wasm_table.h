// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_RUNTIME_WASM3_WASM_TABLE_H_
#define SRC_WASM_RUNTIME_WASM3_WASM_TABLE_H_

#include <cstdint>
#include <cstdlib>
#include <map>
#include <memory>

#include "common/wasm_type.h"
#include "wasm3/wasm3.h"

namespace primjs::wasm {
class Wasm3Instance;
class Wasm3Function;
class Wasm3Runtime;

class Wasm3Table {
 public:
  using elem_ref = IM3Function;

  // create WasmTable with IM3Table
  Wasm3Table(Wasm3Runtime* runtime, uint32_t initial, uint32_t maximum,
             TableElemType type, M3Result* err = nullptr);
  Wasm3Table(Wasm3Runtime* runtime, IM3Table table, Wasm3Instance* instance);
  ~Wasm3Table();

  // return the function ref at tbl[index]
  IM3Function get(size_t index);

  uint32_t size();
  bool OutOfBounds(uint32_t size) const;

  bool set(size_t index, IM3Function func_data);

  bool grow(uint32_t num);

  bool valid() const { return table_ != nullptr; }

  IM3Table table() const { return table_; }

  Wasm3Instance* instance() const { return instance_; }

  Wasm3Runtime* runtime() const { return runtime_; }

 private:
  BORROWER Wasm3Runtime* runtime_;

  uint32_t maximum_;

  OWNER IM3Table table_;
  BORROWER Wasm3Instance* instance_ = nullptr;
};

}  // namespace primjs::wasm

#endif  // SRC_WASM_RUNTIME_WASM3_WASM_TABLE_H_
