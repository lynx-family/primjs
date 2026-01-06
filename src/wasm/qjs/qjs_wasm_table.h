// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_TABLE_H_
#define SRC_WASM_QJS_QJS_WASM_TABLE_H_

#include "common/one_of.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs {
class InteropRuntime;

namespace wasm {
class Wasm3Table;
class PrismTable;
}  // namespace wasm

using WasmTableRef = OneOf<wasm::Wasm3Table *, wasm::PrismTable *>;

namespace qjs {
class QJSWasmTable {
 public:
  QJSWasmTable(WasmTableRef table, InteropRuntime *interop);
  ~QJSWasmTable();

  static LEPUSValue CreateConstructor(LEPUSContext *ctx, LEPUSValue wasm_root);

  static LEPUSValue CreateJSObject(LEPUSContext *ctx, InteropRuntime *interop,
                                   const WasmTableRef &table);

  static inline LEPUSClassID class_id() {
    static LEPUSClassID class_id = LEPUS_NewClassID(&class_id);
    return class_id;
  }

  WasmTableRef &table() { return table_; }

 protected:
  static void Finalize(LEPUSRuntime *rt, LEPUSValue obj);

  static LEPUSValue CreatePrototype(LEPUSContext *ctx, LEPUSClassID class_id_);

  static LEPUSValue CallAsConstructor(LEPUSContext *ctx,
                                      LEPUSValueConst new_target, int argc,
                                      LEPUSValueConst *argv);

  static LEPUSValue GetLengthCallback(LEPUSContext *ctx,
                                      LEPUSValueConst this_val);

  static LEPUSValue GetIndexCallback(LEPUSContext *ctx,
                                     LEPUSValueConst this_val, int argc,
                                     LEPUSValueConst *argv);
  static LEPUSValue SetIndexCallback(LEPUSContext *ctx,
                                     LEPUSValueConst this_val, int argc,
                                     LEPUSValueConst *argv);

  static LEPUSValue GrowCallback(LEPUSContext *ctx, LEPUSValueConst this_val,
                                 int argc, LEPUSValueConst *argv);

 private:
  //  Default max table size of wasm3 we used is 100000. Table imported from JS
  //  will be compared with wasm3 table declaration. If the table size in JS is
  //  not specified, max size in JS and wasm3 will be different. This will cause
  //  import failure.
  static constexpr uint32_t MaxSaneTableSize = 100000;

  OWNER WasmTableRef table_;

  BORROWER InteropRuntime *interop_runtime_;
};

}  // namespace qjs
}  // namespace primjs

#endif  // SRC_WASM_QJS_QJS_WASM_TABLE_H_
