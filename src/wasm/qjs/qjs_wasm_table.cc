// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm_table.h"

#include <cmath>
#include <cstddef>
#include <limits>
#include <utility>

#include "common/interop_runtime.h"
#include "common/js_type.h"
#include "common/messages.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/js_env_qjs.h"
#include "qjs/qjs_ext_api.h"
#include "qjs/qjs_wasm_function.h"
#include "runtime/prism/wasm_function.h"
#include "runtime/wasm3/wasm_function.h"

namespace primjs::qjs {
namespace {
bool ToPrismTableFunction(LEPUSContext* ctx, QJSEnv* js_env,
                          LEPUSValueConst value, PrismRuntime* expected_runtime,
                          wasm_func_t** result, const char* code) {
  *result = nullptr;
  if (js_env->IsNull(value)) return true;
  if (!js_env->IsWasmFunction(value)) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     "Table value must be null or a Prism function");
    return false;
  }
  auto function_opaque = static_cast<QJSWasmFunction*>(
      LEPUS_GetOpaque(value, QJSWasmFunction::class_id()));
  if (!function_opaque || !function_opaque->function().is<PrismFunction*>()) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     "Table value must be a Prism function");
    return false;
  }
  auto prism_function = function_opaque->function().get<PrismFunction*>();
  if (prism_function->runtime() != expected_runtime) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     "Table value belongs to a different Prism runtime");
    return false;
  }
  *result = prism_function->function();
  return true;
}
}  // namespace

QJSWasmTable::QJSWasmTable(WasmTableRef table, InteropRuntime* interop)
    : table_(std::move(table)) {
  WLOGD("Running QJSWasmTable::%s...", __func__);
  interop_runtime_ = interop;
  InteropRuntime::IncreaseRefCount(interop_runtime_);
}

QJSWasmTable::~QJSWasmTable() {
  WLOGD("Running QJSWasmTable::%s...", __func__);
  if (table_.is<Wasm3Table*>()) {
    delete table_.get<Wasm3Table*>();
  } else {
    delete table_.get<PrismTable*>();
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

void QJSWasmTable::Finalize(LEPUSRuntime* rt, LEPUSValue obj) {
  WLOGD("Running QJSWasmTable::%s...", __func__);

  auto table = static_cast<QJSWasmTable*>(LEPUS_GetOpaque(obj, class_id()));
  delete table;
  LEPUS_SetOpaque(obj, nullptr);
}

LEPUSValue QJSWasmTable::CreatePrototype(LEPUSContext* ctx,
                                         LEPUSClassID class_id) {
  LEPUSClassDef def = {.class_name = "WebAssembly.Table",
                       .finalizer = Finalize};

  if (JSSafeNewClass(ctx, class_id, &def) != 0) {
    WLOGE("New Class for WebAssembly.Table failed!");
    return LEPUS_EXCEPTION;
  }
  // function list should be static to keep alive
  // All methods on an instance are declared here.
  static const LEPUSCFunctionListEntry table_func_list[] = {
      LEPUS_CFUNC_DEF("set", 2, SetIndexCallback),
      LEPUS_CFUNC_DEF("get", 1, GetIndexCallback),
      LEPUS_CFUNC_DEF("grow", 1, GrowCallback),
      LEPUS_CGETSET_DEF("length", GetLengthCallback, NULL),
  };

  LEPUSValue prototype = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &prototype, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyFunctionList(ctx, prototype, table_func_list,
                                countof(table_func_list));

  LEPUS_SetClassProto(ctx, class_id, prototype);
  return prototype;
}

LEPUSValue QJSWasmTable::CreateConstructor(LEPUSContext* ctx,
                                           LEPUSValue wasm_root) {
  LEPUSValue proto = CreatePrototype(ctx, class_id());
  HandleScope func_scope(ctx, &proto, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue ctor =
      InitConstructor(ctx, wasm_root, "Table", CallAsConstructor, 1, proto);
  return ctor;
}

LEPUSValue QJSWasmTable::CreateJSObject(LEPUSContext* ctx,
                                        InteropRuntime* interop,
                                        const WasmTableRef& table) {
  LEPUSValue obj = LEPUS_NewObjectClass(ctx, class_id());
  if (LEPUS_IsException(obj)) {
    return LEPUS_EXCEPTION;
  }
  HandleScope func_scope(ctx, &obj, HANDLE_TYPE_LEPUS_VALUE);
  if (interop->wasm_runtime().is<PrismRuntime*>() &&
      !RetainWasmRoot(ctx, obj, interop->js_env<QJSEnv*>()->wasm_root())) {
    if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, obj);
    return LEPUS_EXCEPTION;
  }

  auto table_data = new QJSWasmTable(table, interop);
  LEPUS_SetOpaque(obj, table_data);

  return obj;
}

LEPUSValue QJSWasmTable::CallAsConstructor(LEPUSContext* ctx,
                                           LEPUSValueConst constructor,
                                           int argc, LEPUSValueConst* argv) {
  WLOGD("Running QJSWasmTable::%s...", __func__);

  auto interop =
      static_cast<InteropRuntime*>(JSGetPrivateData(ctx, constructor));
  bool is_prism = interop->wasm_runtime().is<PrismRuntime*>();
  if (argc != 1 || !LEPUS_IsObject(argv[0])) {
    return LEPUS_ThrowTypeError(ctx, "new Table without TableDescriptor!");
  }

  LEPUSValue table_desc = argv[0];
  if (is_prism) {
    auto read_size = [&](LEPUSValue value, int32_t* result) {
      double number = 0;
      if (LEPUS_ToFloat64(ctx, &number, value) < 0) return false;
      if (!std::isfinite(number) ||
          number > std::numeric_limits<int32_t>::max() ||
          number < std::numeric_limits<int32_t>::min()) {
        LEPUS_ThrowTypeError(ctx, "table size is not a valid int32");
        return false;
      }
      *result = static_cast<int32_t>(number);
      return true;
    };

    ScopedPrismProperty initial_value(ctx, table_desc, "initial");
    if (initial_value.IsException()) return LEPUS_EXCEPTION;
    int32_t initial = 0;
    if (!read_size(initial_value.value(), &initial)) return LEPUS_EXCEPTION;
    if (initial < 0) {
      return LEPUS_ThrowTypeError(ctx, ErrorMessages::kInvalidInitialSize_1001);
    }

    ScopedPrismProperty max_value(ctx, table_desc, "maximum");
    if (max_value.IsException()) return LEPUS_EXCEPTION;
    int32_t maximum = MaxSaneTableSize;
    if (!LEPUS_IsUndefined(max_value.value())) {
      if (!read_size(max_value.value(), &maximum)) return LEPUS_EXCEPTION;
      if (maximum < 0) {
        return LEPUS_ThrowTypeError(ctx,
                                    ErrorMessages::kInvalidTableLimits_1001);
      }
      if (maximum > MaxSaneTableSize) maximum = MaxSaneTableSize;
    }
    if (initial > maximum) {
      return LEPUS_ThrowRangeError(ctx,
                                   ErrorMessages::kInvalidTableLimits_1002);
    }

    ScopedPrismProperty elem_type(ctx, table_desc, "element");
    if (elem_type.IsException()) return LEPUS_EXCEPTION;
    const char* type_str = LEPUS_ToCString(ctx, elem_type.value());
    HandleScope string_scope(ctx, &type_str, HANDLE_TYPE_CSTRING);
    if (!type_str) return LEPUS_EXCEPTION;
    bool supported = strcmp(type_str, "anyfunc") == 0;
    if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeCString(ctx, type_str);
    if (!supported) {
      return LEPUS_ThrowTypeError(ctx,
                                  ErrorMessages::kUnsupportedElemType_1002);
    }

    WasmTableRef table =
        interop->CreatePrismTable(initial, maximum, TableElemType::kFuncRef);
    if (table == nullptr) {
      return LEPUS_ThrowRangeError(ctx, "Unable to create Prism table");
    }
    return CreateJSObject(ctx, interop, table);
  }

  // get the initial page size
  LEPUSValue initial_value = JSGetPropertyStrFree(ctx, table_desc, "initial");
  int32_t initial = 0;
  if (!JSValueGetInt32(ctx, initial_value, &initial) || initial < 0) {
    return LEPUS_ThrowTypeError(ctx, ErrorMessages::kInvalidInitialSize_1001);
  }

  // get the maximum page size
  LEPUSValue max_value = JSGetPropertyStrFree(ctx, table_desc, "maximum");
  int32_t maximum;
  if (LEPUS_IsUndefined(max_value)) {
    maximum = MaxSaneTableSize;
  } else if (!JSValueGetInt32(ctx, max_value, &maximum) || maximum < 0) {
    return LEPUS_ThrowTypeError(ctx, ErrorMessages::kInvalidTableLimits_1001);
  }
  if (maximum > MaxSaneTableSize) {
    maximum = MaxSaneTableSize;
  }

  WLOGD("table size: %d %d", initial, maximum);

  if (initial > maximum) {
    return LEPUS_ThrowRangeError(ctx, ErrorMessages::kInvalidTableLimits_1002);
  }

  // get the element type, only support "anyfunc" now
  LEPUSValue elem_type = JSGetPropertyStrFree(ctx, table_desc, "element");
  const char* type_str = LEPUS_ToCString(ctx, elem_type);
  HandleScope func_scope(ctx, &type_str, HANDLE_TYPE_LEPUS_VALUE);
  if (strcmp(type_str, "anyfunc") != 0) {
    // TODO(wasm): support externref
    if (!LEPUS_IsGCMode(ctx)) {
      LEPUS_FreeCString(ctx, type_str);
    }
    return LEPUS_ThrowTypeError(ctx, ErrorMessages::kUnsupportedElemType_1002);
  }
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeCString(ctx, type_str);
  }

  // create wasm table with table desc
  WasmTableRef table =
      interop->CreateWasmTable(initial, maximum, TableElemType::kFuncRef);

  return CreateJSObject(ctx, interop, table);
}

LEPUSValue QJSWasmTable::GetLengthCallback(LEPUSContext* ctx,
                                           LEPUSValueConst this_val) {
  constexpr const char* code = "WebAssembly.Table.length";
  WLOGD("Running QJSWasmTable::%s...", __func__);

  if (LEPUS_GetClassID(ctx, this_val) != class_id()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Not a WebAssembly.Table instance");
  }

  auto table =
      static_cast<QJSWasmTable*>(LEPUS_GetOpaque(this_val, class_id()));
  WASM_DCHECK(table != nullptr);

  uint32_t length = 0;

  if (table->table_.is<Wasm3Table*>()) {
    WASM_DCHECK(table->table_.get<Wasm3Table*>() != nullptr);
    length = table->table_.get<Wasm3Table*>()->size();
  } else {
    WASM_DCHECK(table->table_.get<PrismTable*>() != nullptr);
    length = table->table_.get<PrismTable*>()->size();
  }

  return LEPUS_NewInt32(ctx, static_cast<int32_t>(length));
}

LEPUSValue QJSWasmTable::GetIndexCallback(LEPUSContext* ctx,
                                          LEPUSValueConst this_val, int argc,
                                          LEPUSValueConst* argv) {
  WLOGD("Running QJSWasmTable::%s...", __func__);
  constexpr const char* code = "WebAssembly.Table.get()";

  if (LEPUS_GetClassID(ctx, this_val) != class_id()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Not a WebAssembly.Table instance");
  }

  auto table =
      static_cast<QJSWasmTable*>(LEPUS_GetOpaque(this_val, class_id()));
  WASM_DCHECK(table != nullptr);
  auto interop_runtime = static_cast<InteropRuntime*>(table->interop_runtime_);
  if (!table || argc < 1) {
    WLOGE("table.get() without valid index argument!");
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kInvalidArgs_1005);
  }

  int32_t index = 0;
  if (!JSValueGetInt32(ctx, argv[0], &index) || index < 0) {
    WLOGE("Get table with invalid index: %d", index);
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kInvalidArgs_1006);
  }

  uint32_t length = 0;
  LEPUSValue func_value = LEPUS_UNDEFINED;

  auto js_env = interop_runtime->js_env<QJSEnv*>();

  if (table->table_.is<Wasm3Table*>()) {
    WASM_DCHECK(table->table_.get<Wasm3Table*>() != nullptr);
    auto wasm_table = table->table_.get<Wasm3Table*>();
    length = table->table_.get<Wasm3Table*>()->size();
    if (length <= index) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kOutOfBoundOperation_1005);
    }

    auto func_ref = wasm_table->get(index);
    if (!func_ref) return QJSEnv::ToQJS(js_env->MakeNull());

    auto& func_cache = js_env->wasm_func_cache();
    uintptr_t ptr = reinterpret_cast<uintptr_t>(func_ref);
    if (func_cache.count(ptr)) {
      if (!js_env->IsWasmFunction(func_cache[ptr])) {
        // here func_cache[ptr] do not need LEPUS_DupValue
        auto func_data =
            new Wasm3Function(func_cache[ptr], wasm_table->runtime(),
                              wasm_table->instance(), func_ref);
        func_cache[ptr] =
            js_env->MakeWasmFunction(interop_runtime, nullptr, func_data);
      }
      func_value = func_cache[ptr].Get();
    } else {
      auto func_data = new Wasm3Function(func_ref, wasm_table->runtime(),
                                         wasm_table->instance());
      func_value =
          js_env->MakeWasmFunction(interop_runtime, nullptr, func_data).Get();
      func_cache[ptr] = func_value;
    }
  } else {
    WASM_DCHECK(table->table_.get<PrismTable*>() != nullptr);
    auto wasm_table = table->table_.get<PrismTable*>();
    length = table->table_.get<PrismTable*>()->size();
    if (wasm_unlikely(length <= index)) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kOutOfBoundOperation_1006);
    }

    uintptr_t ptr = wasm_table->function_identity(index);
    if (wasm_unlikely(!ptr)) return QJSEnv::ToQJS(js_env->MakeNull());
    QJSEnv::JSObject cached_func;
    if (wasm_table->runtime()->GetExportFunctionObject<QJSEnv>(ptr,
                                                               &cached_func) &&
        js_env->IsWasmFunction(cached_func)) {
      func_value = cached_func.Get();
    } else {
      auto& func_cache = js_env->wasm_func_cache();
      if (!func_cache.count(ptr) || !js_env->IsWasmFunction(func_cache[ptr])) {
        wasm_func_t* func_ref = wasm_table->get(index);
        if (wasm_unlikely(!func_ref)) {
          return QJSEnv::ToQJS(js_env->MakeNull());
        }
        auto func_data = new PrismFunction(func_ref, wasm_table->runtime(),
                                           wasm_table->instance(), false);
        func_cache[ptr] =
            js_env->MakeWasmFunction(interop_runtime, nullptr, func_data);
      }
      wasm_table->runtime()->CacheExportFunctionObject<QJSEnv>(ptr,
                                                               func_cache[ptr]);
      func_value = func_cache[ptr].Get();
    }
  }

  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_DupValue(ctx, func_value);
  }
  return func_value;
}

LEPUSValue QJSWasmTable::SetIndexCallback(LEPUSContext* ctx,
                                          LEPUSValueConst this_val, int argc,
                                          LEPUSValueConst* argv) {
  WLOGD("Running QJSWasmTable::%s...", __func__);
  constexpr const char* code = "WebAssembly.Table.set()";

  if (LEPUS_GetClassID(ctx, this_val) != class_id()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Not a WebAssembly.Table instance");
  }

  auto table =
      static_cast<QJSWasmTable*>(LEPUS_GetOpaque(this_val, class_id()));
  WASM_DCHECK(table != nullptr);
  auto interop_runtime = static_cast<InteropRuntime*>(table->interop_runtime_);
  // TODO(wasm): Support default value when just providing 1 argument.
  if (!table || argc < 2) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kInvalidArgs_1007);
  }

  LEPUSValue value_obj = argv[1];

  int32_t index = 0;
  if (!JSValueGetInt32(ctx, argv[0], &index) || index < 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kInvalidArgs_1008);
  }

  uint32_t length = 0;
  auto js_env = interop_runtime->js_env<QJSEnv*>();

  if (table->table_.is<Wasm3Table*>()) {
    WASM_DCHECK(table->table_.get<Wasm3Table*>() != nullptr);
    auto wasm3_table = table->table_.get<Wasm3Table*>();
    length = wasm3_table->size();
    if (length <= index) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kOutOfBoundOperation_1007);
    }

    Wasm3Function* wasm3_function = nullptr;
    if (js_env->IsWasmFunction(value_obj)) {
      auto function_opaque = static_cast<QJSWasmFunction*>(
          LEPUS_GetOpaque(value_obj, QJSWasmFunction::class_id()));
      WasmFunctionRef wasm_function = function_opaque->function();
      if (wasm_function.is<Wasm3Function*>()) {
        wasm3_function = wasm_function.get<Wasm3Function*>();
      } else {
        return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                                ErrorMessages::kInvalidTableElem_1006);
      }
    } else if (!js_env->IsNull(value_obj)) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              ErrorMessages::kInvalidTableElem_1007);
    }

    IM3Function func_addr = nullptr;
    if (wasm3_function) {
      func_addr = wasm3_function->function();
      auto& wasm_func_cache = js_env->wasm_func_cache();
      uintptr_t ptr = reinterpret_cast<uintptr_t>(func_addr);
      js_env->DupValue(value_obj);
      // Table.set allows only exported functions. Therefore, incoming function
      // is already in the function cache. Note that the object cache is now
      // stored in WasmTable instead of JS's agent.
      if (wasm_func_cache.count(ptr)) {
        js_env->FreeValue(wasm_func_cache[ptr]);
      }
      // Keep the GC storage cell associated with its owning runtime.
      wasm_func_cache[ptr].Reset(ctx, value_obj);
    }
    wasm3_table->set(index, func_addr);
  } else {
    WASM_DCHECK(table->table_.get<PrismTable*>() != nullptr);
    auto prism_table = table->table_.get<PrismTable*>();
    length = prism_table->size();

    if (wasm_unlikely(length <= index)) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kOutOfBoundOperation_1008);
    }

    wasm_func_t* func_addr = nullptr;
    if (!ToPrismTableFunction(ctx, js_env, value_obj, prism_table->runtime(),
                              &func_addr, code)) {
      return LEPUS_EXCEPTION;
    }
    if (!prism_table->set(index, func_addr)) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "Unable to set Prism table value");
    }
    if (func_addr) {
      auto& wasm_func_cache = js_env->wasm_func_cache();
      prism_func* func = prism_get_func(func_addr);
      uintptr_t ptr = reinterpret_cast<uintptr_t>(func);
      auto cached_func =
          js_env->DupValue(QJSEnv::FromQJS(value_obj, LEPUS_GetRuntime(ctx)));
      if (wasm_func_cache.count(ptr)) {
        js_env->FreeValue(wasm_func_cache[ptr]);
      }
      wasm_func_cache[ptr] = cached_func;
    }
  }

  return LEPUS_UNDEFINED;
}

LEPUSValue QJSWasmTable::GrowCallback(LEPUSContext* ctx,
                                      LEPUSValueConst this_val, int argc,
                                      LEPUSValueConst* argv) {
  WLOGD("Running QJSWasmTable::%s...", __func__);
  constexpr const char* code = "WebAssembly.Table.grow()";

  if (LEPUS_GetClassID(ctx, this_val) != class_id()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Not a WebAssembly.Table instance");
  }

  auto table =
      static_cast<QJSWasmTable*>(LEPUS_GetOpaque(this_val, class_id()));
  WASM_DCHECK(table != nullptr);
  if (!table || argc < 1) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1009);
  }

  int32_t num = 0;
  if (!JSValueGetInt32(ctx, argv[0], &num) || num < 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoConvertibleNum_1010);
  }

  // grow the table size
  size_t length = 0;
  if (table->table_.is<Wasm3Table*>()) {
    length = table->table_.get<Wasm3Table*>()->size();
    auto wasm3_table = table->table_.get<Wasm3Table*>();
    if (wasm3_table->OutOfBounds(num)) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kOutOfBoundOperation_1009);
    }
    if (wasm3_table->grow(num)) {
      return LEPUS_NewInt32(ctx, length);
    }
  } else {
    length = table->table_.get<PrismTable*>()->size();
    auto prism_table = table->table_.get<PrismTable*>();
    if (prism_table->OutOfBounds(num)) {
      return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                              ErrorMessages::kOutOfBoundOperation_1010);
    }
    if (prism_table->grow(num)) {
      return LEPUS_NewInt32(ctx, length);
    }
  }

  return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                          ErrorMessages::kGrowFailed_1005);
}

}  // namespace primjs::qjs
