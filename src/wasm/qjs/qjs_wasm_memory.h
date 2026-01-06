// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_MEMORY_H_
#define SRC_WASM_QJS_QJS_WASM_MEMORY_H_

#include "common/wasm_type.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs {
class InteropRuntime;

namespace qjs {
class QJSEnv;
}

namespace wasm {
class Wasm3Memory;
class PrismMemory;
}  // namespace wasm

using WasmMemoryRef = OneOf<wasm::Wasm3Memory *, wasm::PrismMemory *>;

namespace qjs {
class QJSWasmMemory {
 public:
  QJSWasmMemory(WasmMemoryRef memory, size_t pages, InteropRuntime *interop);
  ~QJSWasmMemory();

  static LEPUSValue CreateConstructor(LEPUSContext *ctx, LEPUSValue wasm_root);

  static LEPUSValue CreateJSObject(LEPUSContext *ctx, InteropRuntime *interop,
                                   WasmMemoryRef memory, size_t pages);

  static LEPUSClassID class_id() {
    static LEPUSClassID class_id = LEPUS_NewClassID(&class_id);
    return class_id;
  }

  static void Finalize(LEPUSRuntime *rt, LEPUSValue obj);

  static void GCMark(LEPUSRuntime *rt, LEPUSValueConst obj,
                     LEPUS_MarkFunc *mark_func, uint64_t trace_tool);

  static LEPUSValue CreatePrototype(LEPUSContext *ctx);

  static LEPUSValue CallAsConstructor(LEPUSContext *ctx,
                                      LEPUSValueConst new_target, int argc,
                                      LEPUSValueConst *argv);

  static LEPUSValue GetBufferCallback(LEPUSContext *ctx,
                                      LEPUSValueConst this_val);

  static LEPUSValue GrowCallback(LEPUSContext *ctx, LEPUSValueConst this_val,
                                 int argc, LEPUSValueConst *argv);

  static LEPUSValue InitializeMemory(LEPUSContext *ctx, uintptr_t memaddr,
                                     LEPUSValue memory_obj,
                                     WasmMemoryRef &memory,
                                     InteropRuntime *interop_runtime);

  WasmMemoryRef &memory() { return memory_; }

  void set_buffer(LEPUSContext *ctx, LEPUSValue buffer) {
    if (!LEPUS_IsGCMode(ctx)) {
      LEPUS_FreeValue(ctx, buffer_);
    }
    buffer_ = buffer;
  }

 private:
  size_t pages_;

  LEPUSValue buffer_ = LEPUS_UNDEFINED;

  OWNER WasmMemoryRef memory_;

  BORROWER InteropRuntime *interop_runtime_;
};

}  // namespace qjs
}  // namespace primjs

#endif  // SRC_WASM_QJS_QJS_WASM_MEMORY_H_
