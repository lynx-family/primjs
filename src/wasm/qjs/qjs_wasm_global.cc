// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_wasm_global.h"

#include <utility>

#include "common/interop_runtime.h"
#include "common/js_type.h"
#include "common/messages.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "qjs/qjs_ext_api.h"
#include "qjs/qjs_wasm.h"

namespace primjs::qjs {
QJSWasmGlobal::QJSWasmGlobal(WasmGlobalRef global, InteropRuntime* interop)
    : global_(std::move(global)) {
  WLOGD("Running QJSWasmGlobal::%s...", __func__);
  interop_runtime_ = interop;
  InteropRuntime::IncreaseRefCount(interop_runtime_);
}

QJSWasmGlobal::~QJSWasmGlobal() {
  WLOGD("Running QJSWasmGlobal::%s...", __func__);
  if (global_.is<Wasm3Global*>()) {
    delete global_.get<Wasm3Global*>();
  } else {
    delete global_.get<PrismGlobal*>();
  }
  InteropRuntime::DecreaseRefCount(interop_runtime_);
}

void QJSWasmGlobal::Finalize(LEPUSRuntime* rt, LEPUSValue obj) {
  WLOGD("Running QJSWasmGlobal::%s...", __func__);
  auto global = static_cast<QJSWasmGlobal*>(LEPUS_GetOpaque(obj, class_id()));
  delete global;
  LEPUS_SetOpaque(obj, nullptr);
}

LEPUSValue QJSWasmGlobal::CreateJSObject(LEPUSContext* ctx,
                                         InteropRuntime* interop,
                                         WasmGlobalRef global) {
  LEPUSValue obj = LEPUS_NewObjectClass(ctx, class_id());
  if (LEPUS_IsException(obj)) {
    return LEPUS_EXCEPTION;
  }
  HandleScope func_scope(ctx, &obj, HANDLE_TYPE_LEPUS_VALUE);
  auto global_data = new QJSWasmGlobal(global, interop);
  LEPUS_SetOpaque(obj, global_data);
  return obj;
}

LEPUSValue QJSWasmGlobal::CallAsConstructor(LEPUSContext* ctx,
                                            LEPUSValueConst constructor,
                                            int argc, LEPUSValueConst* argv) {
  WLOGD("Running QJSWasmGlobal::%s...", __func__);

  constexpr const char* code = "WebAssembly.Global()";

  if (argc == 0 || argc > 2 || !LEPUS_IsObject(argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kDescriptorNeeded_1004);
  }

  LEPUSValue descriptor = argv[0];
  LEPUSValue v = argc == 2 ? argv[1] : LEPUS_UNDEFINED;

  // 1. Let mutable be descriptor["mutable"].
  LEPUSValue desc_mutable = JSGetPropertyStrFree(ctx, descriptor, "mutable");

  // 2. Let valuetype be ToValueType(descriptor["value"]).
  const char* err_msg =
      "Descriptor property 'value' must be a WebAssembly type";
  LEPUSValue value_type = JSGetPropertyStrFree(ctx, descriptor, "value");
  if (LEPUS_IsUndefined(value_type)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
  }
  HandleScope func_scope(ctx, &value_type, HANDLE_TYPE_LEPUS_VALUE);

  char* value_type_str = (char*)LEPUS_ToCString(ctx, value_type);
  func_scope.PushHandle(&value_type_str, HANDLE_TYPE_CSTRING);

  ValueType type = StrToType(value_type_str);

  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeCString(ctx, value_type_str);
  }
  // 3. If valuetype is v128, Throw a TypeError exception.
  if (type == ValueType::kTypeV128) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
  }

  // If v is missing, Let value be DefaultValue(valuetype).
  double value = 0;
  if (!LEPUS_IsUndefined(v) &&
      LEPUS_IsException(JsToValue(ctx, &value, v, type))) {
    return LEPUS_EXCEPTION;
  }

  // create wasm global with global desc
  auto interop =
      static_cast<InteropRuntime*>(JSGetPrivateData(ctx, constructor));
  WasmGlobalRef global =
      interop->CreateWasmGlobal(type, LEPUS_ToBool(ctx, desc_mutable), value);

  return CreateJSObject(ctx, interop, global);
}

LEPUSValue QJSWasmGlobal::CreatePrototype(LEPUSContext* ctx,
                                          LEPUSClassID class_id) {
  LEPUSClassDef def = {.class_name = "WebAssembly.Global",
                       .finalizer = Finalize};
  if (JSSafeNewClass(ctx, class_id, &def) != 0) {
    WLOGE("New Class for WebAssembly.Global failed!");
    return LEPUS_EXCEPTION;
  }
  // function list should be static to keep alive
  // All methods on an instance are declared here.
  static const LEPUSCFunctionListEntry memory_func_list[] = {
      LEPUS_CFUNC_DEF("valueOf", 1, ValueOfCallback),
      LEPUS_CGETSET_DEF("value", GetValueCallback, SetValueCallback),
  };

  LEPUSValue prototype = LEPUS_NewObject(ctx);
  HandleScope func_scope(ctx, &prototype, HANDLE_TYPE_LEPUS_VALUE);
  LEPUS_SetPropertyFunctionList(ctx, prototype, memory_func_list,
                                countof(memory_func_list));

  LEPUS_SetClassProto(ctx, class_id, prototype);
  return prototype;
}

LEPUSValue QJSWasmGlobal::CreateConstructor(LEPUSContext* ctx,
                                            LEPUSValue wasm_root) {
  LEPUSValue proto = CreatePrototype(ctx, class_id());
  HandleScope func_scope(ctx, &proto, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue ctor =
      InitConstructor(ctx, wasm_root, "Global", CallAsConstructor, 1, proto);
  return ctor;
}

LEPUSValue QJSWasmGlobal::GetValueCallback(LEPUSContext* ctx,
                                           LEPUSValueConst this_val) {
  WLOGD("global.value @ %s", __func__);

  constexpr const char* code = "WebAssembly.Global::get()";

  if (LEPUS_GetClassID(ctx, this_val) != class_id()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Not a WebAssembly.Global instance");
  }

  auto global =
      static_cast<QJSWasmGlobal*>(LEPUS_GetOpaque(this_val, class_id()));
  if (!global) return LEPUS_UNDEFINED;

  auto interop_runtime = global->interop_runtime_;
  auto js_env = interop_runtime->js_env<QJSEnv*>();

  JSValue val = QJSEnv::FromQJS(LEPUS_UNDEFINED, LEPUS_GetRuntime(ctx));
  if (global->global_.is<Wasm3Global*>()) {
    auto wasm3_global = global->global_.get<Wasm3Global*>();
    M3TaggedValue tagged_value;
    wasm3_global->GetValue(&tagged_value);
    wasm3_global->runtime()->ToJSValue(js_env, &val, &tagged_value);
  } else {
    auto prism_global = global->global_.get<PrismGlobal*>();
    wasm_val_t wasm_value;
    prism_global->GetValue(&wasm_value);
    prism_global->runtime()->ToJSValue(js_env, &val, &wasm_value);
  }

  return val.Get();
}

LEPUSValue QJSWasmGlobal::SetValueCallback(LEPUSContext* ctx,
                                           LEPUSValueConst this_val,
                                           LEPUSValueConst val) {
  WLOGD("set global.value @ %s", __func__);

  constexpr const char* code = "WebAssembly.Global::set()";

  if (LEPUS_GetClassID(ctx, this_val) != class_id()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Not a WebAssembly.Global instance");
  }

  auto global =
      static_cast<QJSWasmGlobal*>(LEPUS_GetOpaque(this_val, class_id()));
  if (!global) {
    return ThrowIfException(ctx, ErrorTypes::kError, code,
                            ErrorMessages::kInvalidArgs_1004);
  }

  constexpr const char* err_msg = "Can't set the value of an immutable global";

  ValueType type = ValueType::kTypeNone;
  if (global->global_.is<Wasm3Global*>()) {
    auto wasm3_global = global->global_.get<Wasm3Global*>();
    if (!wasm3_global->mutability()) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
    }
    type = wasm3_global->GetType();
    if (type == ValueType::kTypeV128) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "Set global v128 value not supported!");
    }

    double value;
    if (LEPUS_IsException(JsToValue(ctx, &value, val, type))) {
      return LEPUS_EXCEPTION;
    }

    if (wasm3_global->SetValue(value)) {
      LEPUS_ThrowInternalError(ctx, "Global set failed.");
      return LEPUS_EXCEPTION;
    }
  } else {
    auto prism_global = global->global_.get<PrismGlobal*>();
    if (!prism_global->mutability()) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code, err_msg);
    }
    type = prism_global->GetType();
    if (type == ValueType::kTypeV128) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              "Set global v128 value not supported!");
    }

    double value;
    if (LEPUS_IsException(JsToValue(ctx, &value, val, type))) {
      return LEPUS_EXCEPTION;
    }

    if (prism_global->set_value(value)) {
      LEPUS_ThrowInternalError(ctx, "Global set failed.");
      return LEPUS_EXCEPTION;
    }
  }

  return LEPUS_UNDEFINED;
}

LEPUSValue QJSWasmGlobal::ValueOfCallback(LEPUSContext* ctx,
                                          LEPUSValueConst this_val, int argc,
                                          LEPUSValueConst* argv) {
  // Do not care about argv
  return GetValueCallback(ctx, this_val);
}

LEPUSValue QJSWasmGlobal::JsToValue(LEPUSContext* ctx, double* val,
                                    LEPUSValueConst js_val, ValueType type) {
  if (type == ValueType::kTypeI32) {
    int32_t num;
    if (LEPUS_ToInt32(ctx, &num, js_val)) {
      return LEPUS_ThrowTypeError(ctx, "Invalid value type converted to i32");
    }
    *val = (double)num;
  } else if (type == ValueType::kTypeI64) {
    int64_t num;
    if (LEPUS_IsUndefined(js_val) || LEPUS_IsNull(js_val)) {
      return LEPUS_ThrowTypeError(
          ctx, "Undefined or Null value cannot convert to i64");
    }
    if (LEPUS_ToInt64(ctx, &num, js_val)) {
      return LEPUS_ThrowTypeError(ctx, "Invalid value type converted to i64");
    }
    *val = (double)num;
  } else if (type == ValueType::kTypeF32 || type == ValueType::kTypeF64) {
    if (unlikely(LEPUS_ToFloat64(ctx, val, js_val))) {
      return LEPUS_ThrowTypeError(ctx,
                                  "Invalid value type converted to f32/f64");
    }
  }

  return LEPUS_UNDEFINED;
}

}  // namespace primjs::qjs
