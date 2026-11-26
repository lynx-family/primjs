// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_TABLE_H_
#define SRC_WASM_QJS_QJS_WASM_TABLE_H_

#include "common/wasm_store_owner.h"
#include "common/wasm_type.h"
#include "qjs/qjs_ext_api.h"

namespace primjs::qjs {

class QJSEnv;

class QJSWasmTable : public QJSWasmWrapperBase {
 public:
  static constexpr int32_t kMaxSaneTableSize = 100000;

  QJSWasmTable(LEPUSRuntime* rt, LEPUSValue wasm_root, QJSEnv* env,
               wasm_table_t* table, uint32_t maximum, LEPUSValue js_obj);
  ~QJSWasmTable();

  static LEPUSClassID class_id() {
    return GetWasmClassId(WasmQJSClass::kTable);
  }

  static QJSWasmTable* Of(const wasm_table_t* table) {
    return table ? static_cast<QJSWasmTable*>(wasm_table_get_host_info(table))
                 : nullptr;
  }

  static bool Register(LEPUSContext* ctx, LEPUSValue wasm_root);
  static LEPUSValue CallAsConstructor(LEPUSContext* ctx,
                                      LEPUSValueConst new_target, int argc,
                                      LEPUSValueConst* argv);

  static LEPUSValue GetOrWrapOwnedTable(LEPUSContext* ctx, QJSEnv* env,
                                        wasm_table_t* table);

  wasm_table_t* table() const { return table_; }
  uint32_t maximum() const { return maximum_; }
  uint32_t size() const { return table_ ? wasm_table_size(table_) : 0; }
  LEPUSValue js_object() const { return js_obj_; }

 private:
  static LEPUSValue WrapOwnedTable(LEPUSContext* ctx, QJSEnv* env,
                                   wasm_table_t* table, uint32_t maximum);
  static void DetachTable(QJSWasmWrapperBase* base, LEPUSRuntime* rt);
  static LEPUSValue GetLengthCallback(LEPUSContext* ctx,
                                      LEPUSValueConst this_val);
  static LEPUSValue GetIndexCallback(LEPUSContext* ctx,
                                     LEPUSValueConst this_val, int argc,
                                     LEPUSValueConst* argv);
  static LEPUSValue SetIndexCallback(LEPUSContext* ctx,
                                     LEPUSValueConst this_val, int argc,
                                     LEPUSValueConst* argv);
  static LEPUSValue GrowCallback(LEPUSContext* ctx, LEPUSValueConst this_val,
                                 int argc, LEPUSValueConst* argv);

  wasm_table_t* table_ = nullptr;
  uint32_t maximum_ = wasm_limits_max_default;
  LEPUSValue js_obj_ = LEPUS_UNDEFINED;
};

}  // namespace primjs::qjs

#endif  // SRC_WASM_QJS_QJS_WASM_TABLE_H_
