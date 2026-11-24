// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm_table.h"

#include <cmath>
#include <cstring>
#include <limits>

#include "common/messages.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/js_env_qjs.h"
#include "qjs/qjs_wasm.h"
#include "qjs/qjs_wasm_function.h"

namespace primjs::qjs {

namespace {
bool ReadTableSizeProp(LEPUSContext* ctx, LEPUSValueConst obj, const char* name,
                       bool* present, int32_t* out) {
  LEPUSValue val = LEPUS_GetPropertyStr(ctx, obj, name);
  if (LEPUS_IsException(val)) return false;
  if (LEPUS_IsUndefined(val)) {
    *present = false;
    return true;
  }
  *present = true;
  HandleScope s(ctx, &val, HANDLE_TYPE_LEPUS_VALUE);
  double number = 0;
  const int rc = LEPUS_ToFloat64(ctx, &number, val);
  FreeValueIfRC(ctx, val);
  if (rc < 0) return false;
  if (!std::isfinite(number) || number > std::numeric_limits<int32_t>::max() ||
      number < std::numeric_limits<int32_t>::min()) {
    LEPUS_ThrowTypeError(ctx, "table size is not a valid int32");
    return false;
  }
  *out = static_cast<int32_t>(number);
  return true;
}
}  // namespace

QJSWasmTable::QJSWasmTable(LEPUSRuntime* rt, LEPUSValue wasm_root, QJSEnv* env,
                           wasm_table_t* table, uint32_t maximum,
                           LEPUSValue js_obj)
    : QJSWasmWrapperBase(rt, wasm_root, env->store_owner(), DetachTable),
      table_(table),
      maximum_(maximum),
      js_obj_(js_obj) {
  wasm_table_set_host_info(table_, this);
}

QJSWasmTable::~QJSWasmTable() { UnlinkAndDetach(); }

void QJSWasmTable::DetachTable(QJSWasmWrapperBase* base, LEPUSRuntime*) {
  auto* self = static_cast<QJSWasmTable*>(base);
  if (self->table_) {
    if (Of(self->table_) == self) {
      wasm_table_set_host_info(self->table_, nullptr);
    }
    wasm_table_delete(self->table_);
    self->table_ = nullptr;
  }
}

bool QJSWasmTable::Register(LEPUSContext* ctx, LEPUSValue wasm_root) {
  static const LEPUSCFunctionListEntry proto_funcs[] = {
      LEPUS_CFUNC_DEF("set", 2, SetIndexCallback),
      LEPUS_CFUNC_DEF("get", 1, GetIndexCallback),
      LEPUS_CFUNC_DEF("grow", 1, GrowCallback),
      LEPUS_CGETSET_DEF("length", GetLengthCallback, nullptr),
  };
  return RegisterWasmClass(ctx, wasm_root, WasmQJSClass::kTable,
                           "WebAssembly.Table", "Table", CallAsConstructor,
                           proto_funcs, countof(proto_funcs));
}

LEPUSValue QJSWasmTable::WrapOwnedTable(LEPUSContext* ctx, QJSEnv* env,
                                        wasm_table_t* table, uint32_t maximum) {
  LEPUSValue obj = NewWasmWrapperObject(ctx, env, WasmQJSClass::kTable,
                                        "WebAssembly.Table()");
  if (LEPUS_IsException(obj)) {
    wasm_table_delete(table);
    return LEPUS_EXCEPTION;
  }
  LEPUS_SetOpaque(obj, new QJSWasmTable(LEPUS_GetRuntime(ctx), env->wasm_root(),
                                        env, table, maximum, obj));
  return obj;
}

LEPUSValue QJSWasmTable::GetOrWrapOwnedTable(LEPUSContext* ctx, QJSEnv* env,
                                             wasm_table_t* table) {
  if (!table) return LEPUS_EXCEPTION;
  if (QJSWasmTable* existing = Of(table)) {
    wasm_table_delete(table);
    return DupValueIfRC(ctx, existing->js_object());
  }
  uint32_t maximum = wasm_limits_max_default;
  if (wasm_tabletype_t* ttype = wasm_table_type(table)) {
    if (const wasm_limits_t* limits = wasm_tabletype_limits(ttype)) {
      maximum = limits->max;
    }
    wasm_tabletype_delete(ttype);
  }
  return WrapOwnedTable(ctx, env, table, maximum);
}

LEPUSValue QJSWasmTable::CallAsConstructor(LEPUSContext* ctx,
                                           LEPUSValueConst new_target, int argc,
                                           LEPUSValueConst* argv) {
  constexpr const char* code = "WebAssembly.Table()";

  QJSEnv* env = RequireConstructorEnv(ctx, new_target, code);
  if (!env) return LEPUS_EXCEPTION;

  if (argc < 1 || !LEPUS_IsObject(argv[0])) {
    return LEPUS_ThrowTypeError(ctx, "new Table without TableDescriptor!");
  }

  LEPUSValue table_desc = argv[0];
  bool has_init = false;
  int32_t initial = 0;
  if (!ReadTableSizeProp(ctx, table_desc, "initial", &has_init, &initial)) {
    return LEPUS_EXCEPTION;
  }
  if (!has_init) {
    return LEPUS_ThrowTypeError(ctx, "table size is not a valid int32");
  }
  if (initial < 0) {
    return LEPUS_ThrowTypeError(ctx, ErrorMessages::kInvalidInitialSize_1001);
  }

  bool has_max = false;
  int32_t maximum = kMaxSaneTableSize;
  if (!ReadTableSizeProp(ctx, table_desc, "maximum", &has_max, &maximum)) {
    return LEPUS_EXCEPTION;
  }
  if (has_max) {
    if (maximum < 0) {
      return LEPUS_ThrowTypeError(ctx, ErrorMessages::kInvalidTableLimits_1001);
    }
    if (maximum > kMaxSaneTableSize) maximum = kMaxSaneTableSize;
  }
  if (initial > maximum) {
    return LEPUS_ThrowRangeError(ctx, ErrorMessages::kInvalidTableLimits_1002);
  }

  LEPUSValue elem_val = LEPUS_GetPropertyStr(ctx, table_desc, "element");
  if (LEPUS_IsException(elem_val)) return LEPUS_EXCEPTION;
  const char* type_str = nullptr;
  {
    HandleScope s(ctx, &elem_val, HANDLE_TYPE_LEPUS_VALUE);
    type_str = LEPUS_ToCString(ctx, elem_val);
    FreeValueIfRC(ctx, elem_val);
  }
  if (!type_str) return LEPUS_EXCEPTION;
  const bool supported = (std::strcmp(type_str, "anyfunc") == 0 ||
                          std::strcmp(type_str, "funcref") == 0);
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeCString(ctx, type_str);
  if (!supported) {
    return LEPUS_ThrowTypeError(ctx, ErrorMessages::kUnsupportedElemType_1002);
  }

  wasm_limits_t limits = {static_cast<uint32_t>(initial),
                          static_cast<uint32_t>(maximum)};
  wasm_valtype_t* elem_type = wasm_valtype_new(WASM_FUNCREF);
  if (wasm_unlikely(!elem_type)) {
    return LEPUS_ThrowRangeError(ctx, "Unable to create WebAssembly.Table");
  }
  wasm_tabletype_t* ttype = wasm_tabletype_new(elem_type, &limits);
  if (wasm_unlikely(!ttype)) {
    wasm_valtype_delete(elem_type);
    return LEPUS_ThrowRangeError(ctx, "Unable to create WebAssembly.Table");
  }
  wasm_table_t* table = wasm_table_new(env->wasm_store(), ttype, nullptr);
  wasm_tabletype_delete(ttype);
  if (wasm_unlikely(!table)) {
    return LEPUS_ThrowRangeError(ctx, "Unable to create WebAssembly.Table");
  }
  return WrapOwnedTable(ctx, env, table, static_cast<uint32_t>(maximum));
}

LEPUSValue QJSWasmTable::GetLengthCallback(LEPUSContext* ctx,
                                           LEPUSValueConst this_val) {
  auto* tbl =
      static_cast<QJSWasmTable*>(LEPUS_GetOpaque2(ctx, this_val, class_id()));
  if (!tbl) return LEPUS_EXCEPTION;
  if (!tbl->table_) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError,
                            "WebAssembly.Table.length",
                            "WebAssembly context is not active");
  }
  return LEPUS_NewInt32(ctx, static_cast<int32_t>(tbl->size()));
}

LEPUSValue QJSWasmTable::GetIndexCallback(LEPUSContext* ctx,
                                          LEPUSValueConst this_val, int argc,
                                          LEPUSValueConst* argv) {
  constexpr const char* code = "WebAssembly.Table.get()";

  auto* tbl =
      static_cast<QJSWasmTable*>(LEPUS_GetOpaque2(ctx, this_val, class_id()));
  if (!tbl) return LEPUS_EXCEPTION;
  if (!tbl->table_) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "WebAssembly context is not active");
  }
  if (argc < 1) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kInvalidArgs_1005);
  }

  int32_t index = 0;
  if (!JSValueGetInt32(ctx, argv[0], &index) || index < 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kInvalidArgs_1006);
  }

  if (wasm_unlikely(static_cast<uint32_t>(index) >= tbl->size())) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            ErrorMessages::kOutOfBoundOperation_1006);
  }

  wasm_ref_t* ref = wasm_table_get(tbl->table_, static_cast<uint32_t>(index));
  if (!ref) return LEPUS_NULL;
  wasm_func_t* func_ref = wasm_ref_as_func(ref);
  if (!func_ref) {
    wasm_ref_delete(ref);
    return LEPUS_NULL;
  }

  QJSEnv* env = QJSWebAssembly::GetEnvFromRoot(tbl->wasm_root());
  if (wasm_unlikely(!env)) {
    wasm_func_delete(func_ref);
    return ThrowIfException(ctx, ErrorTypes::kError, code,
                            "WebAssembly context is not active");
  }
  LEPUSValue wrapped = QJSWasmFunction::GetOrWrapOwnedFunc(ctx, env, func_ref);
  if (!LEPUS_IsException(wrapped) && LEPUS_IsObject(wrapped) &&
      tbl->HasKeepTokens()) {
    if (auto* fn = static_cast<QJSWasmFunction*>(
            LEPUS_GetOpaque(wrapped, QJSWasmFunction::class_id()))) {
      fn->MergeKeepSet(ctx, *tbl);
    }
  }
  return wrapped;
}

LEPUSValue QJSWasmTable::SetIndexCallback(LEPUSContext* ctx,
                                          LEPUSValueConst this_val, int argc,
                                          LEPUSValueConst* argv) {
  constexpr const char* code = "WebAssembly.Table.set()";

  auto* tbl =
      static_cast<QJSWasmTable*>(LEPUS_GetOpaque2(ctx, this_val, class_id()));
  if (!tbl) return LEPUS_EXCEPTION;
  if (!tbl->table_) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "WebAssembly context is not active");
  }
  if (argc < 2) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kInvalidArgs_1007);
  }

  int32_t index = 0;
  if (!JSValueGetInt32(ctx, argv[0], &index) || index < 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kInvalidArgs_1008);
  }

  if (wasm_unlikely(static_cast<uint32_t>(index) >= tbl->size())) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            ErrorMessages::kOutOfBoundOperation_1008);
  }

  LEPUSValue value_obj = argv[1];
  wasm_func_t* func_addr = nullptr;
  QJSWasmFunction* fn = nullptr;
  if (!LEPUS_IsNull(value_obj)) {
    if (!LEPUS_IsObject(value_obj) ||
        LEPUS_GetClassID(ctx, value_obj) != QJSWasmFunction::class_id()) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              ErrorMessages::kInvalidTableElem_1007);
    }
    fn = static_cast<QJSWasmFunction*>(
        LEPUS_GetOpaque(value_obj, QJSWasmFunction::class_id()));
    if (!fn || fn->store_owner() != tbl->store_owner()) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "Table value belongs to a different runtime");
    }
    func_addr = fn->function();
  }

  if (!wasm_table_set(tbl->table_, static_cast<uint32_t>(index),
                      func_addr ? wasm_func_as_ref(func_addr) : nullptr)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Unable to set WebAssembly.Table value");
  }
  if (fn && fn->HasKeepTokens()) {
    tbl->MergeKeepSet(ctx, *fn);
  }
  return LEPUS_UNDEFINED;
}

LEPUSValue QJSWasmTable::GrowCallback(LEPUSContext* ctx,
                                      LEPUSValueConst this_val, int argc,
                                      LEPUSValueConst* argv) {
  constexpr const char* code = "WebAssembly.Table.grow()";

  auto* tbl =
      static_cast<QJSWasmTable*>(LEPUS_GetOpaque2(ctx, this_val, class_id()));
  if (!tbl) return LEPUS_EXCEPTION;
  if (!tbl->table_) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "WebAssembly context is not active");
  }
  if (argc < 1) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1009);
  }

  int32_t delta = 0;
  if (!JSValueGetInt32(ctx, argv[0], &delta) || delta < 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1010);
  }

  const uint32_t old_size = tbl->size();
  if (static_cast<uint64_t>(old_size) + static_cast<uint64_t>(delta) >
      tbl->maximum_) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            ErrorMessages::kOutOfBoundOperation_1010);
  }
  if (!wasm_table_grow(tbl->table_, static_cast<uint32_t>(delta), nullptr)) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            ErrorMessages::kGrowFailed_1005);
  }
  return LEPUS_NewInt32(ctx, static_cast<int32_t>(old_size));
}

}  // namespace primjs::qjs
