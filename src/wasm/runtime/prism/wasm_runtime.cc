// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "runtime/prism/wasm_runtime.h"

#include <string>

#include "common/wasm_log.h"
#include "common/wasm_utils.h"
#include "quickjs/include/primjs_monitor.h"
#include "runtime/prism/wasm_function.h"
#include "runtime/prism/wasm_instance.h"
#include "runtime/prism/wasm_module.h"

namespace primjs::wasm {
PrismRuntime::PrismRuntime() : wasm_engine_(nullptr), wasm_store_(nullptr) {
  WLOGD("Running PrismRuntime::%s...", __func__);
}

PrismRuntime::~PrismRuntime() {
  WLOGD("Running PrismRuntime::%s...", __func__);
}

int PrismRuntime::NumberToWasm(double dvalue, wasm_val_t* w_val) {
  switch (w_val->kind) {
    case WASM_I32:
      if (wasm_unlikely(isnan(dvalue) || isinf(dvalue))) {
        w_val->of.i32 = 0;
      } else {
        w_val->of.i32 = static_cast<int32_t>(dvalue);
      }
      break;
    case WASM_I64:
      if (wasm_unlikely(isnan(dvalue) || isinf(dvalue))) {
        w_val->of.i64 = 0;
      } else {
        w_val->of.i64 = static_cast<int64_t>(dvalue);
      }
      break;
    case WASM_F32:
      w_val->of.f32 = static_cast<float>(dvalue);
      break;
    case WASM_F64:
      w_val->of.f64 = dvalue;
      break;
    // TODO: Cover there two cases.
    case WASM_FUNCREF:
    case WASM_ANYREF:
      assert(false && "Unimplemented!");
      break;
  }
  return 0;
}

void PrismRuntime::WasmFunctionFinalizer(void* env) {
  WLOGD("Running PrismRuntime::%s...", __func__);
  auto pack = static_cast<PrismFunction*>(env);
  delete pack;
}

wasm_valkind_t PrismRuntime::WasmType(ValueType type) {
  switch (type) {
    case ValueType::kTypeI32:
      return WASM_I32;
    case ValueType::kTypeI64:
      return WASM_I64;
    case ValueType::kTypeF32:
      return WASM_F32;
    case ValueType::kTypeF64:
      return WASM_F64;
    case ValueType::kTypeExternref:
      return WASM_FUNCREF;
    default:
      return WASM_ANYREF;
  }
}

int PrismRuntime::InitRuntime() {
  WLOGD("Running PrismRuntime::%s...", __func__);
  MonitorEvent(MODULE_WASM, DEFAULT_BIZ_NAME, "PrismRuntime", "true");
  wasm_engine_ = wasm_engine_new();
  wasm_store_ = wasm_store_new(wasm_engine_);
  return !wasm_engine_ || !wasm_store_;
}
}  // namespace primjs::wasm
