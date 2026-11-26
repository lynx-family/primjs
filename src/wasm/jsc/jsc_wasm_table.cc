// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/jsc_wasm_table.h"

#include <cmath>
#include <limits>

#include "common/messages.h"
#include "common/wasm_utils.h"
#include "jsc/js_env_jsc.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_ext_api.h"
#include "jsc/jsc_wasm_function.h"

namespace primjs::jsc {

JSClassRef JSCWasmTable::class_ref() {
  static JSClassRef ref = InitClassRef();
  return ref;
}

JSClassRef JSCWasmTable::prototype_class_ref() {
  static JSClassRef ref = InitProtoClassRef();
  return ref;
}

JSClassRef JSCWasmTable::constructor_class_ref() {
  static JSClassRef ref = InitCtorClassRef();
  return ref;
}

JSClassRef JSCWasmTable::InitClassRef() {
  JSClassDefinition def = JSClassCreator::GetClassDefinition("Table", Finalize);
  return JSClassCreate(&def);
}

JSClassRef JSCWasmTable::InitProtoClassRef() {
  JSClassDefinition def =
      JSClassCreator::GetClassDefinition("Table.Prototype", nullptr);
  const JSPropertyAttributes default_attr = JSClassCreator::DefaultAttr();
  static const JSStaticFunction static_funcs[] = {
      {"get", GetIndexCallback, default_attr},
      {"set", SetIndexCallback, default_attr},
      {"grow", GrowCallback, default_attr},
      {nullptr, nullptr, 0}};
  def.staticFunctions = static_funcs;
  return JSClassCreate(&def);
}

JSClassRef JSCWasmTable::InitCtorClassRef() {
  JSClassDefinition def = JSClassCreator::GetClassDefinition(
      "WebAssembly.Table", nullptr, CallAsConstructor);
  return JSClassCreate(&def);
}

void JSCWasmTable::ReleaseClassRef() {
  JSClassRelease(prototype_class_ref());
  JSClassRelease(constructor_class_ref());
  JSClassRelease(class_ref());
}

JSCWasmTable::JSCWasmTable(JSCEnv* env, wasm_table_t* table, uint32_t maximum,
                           JSObjectRef js_obj)
    : store_owner_(env->store_owner()),
      table_(table),
      maximum_(maximum),
      js_obj_(js_obj) {
  wasm::WasmStoreOwner::Retain(store_owner_);
  store_owner_->LinkHandle(&tracked_, this, DetachOnExit);
  wasm_table_set_host_info(table_, this);
}

JSCWasmTable::~JSCWasmTable() {
  if (store_owner_) {
    store_owner_->UnlinkHandle(&tracked_);
  }
  DetachWasmTable();
}

void JSCWasmTable::DetachWasmTable() {
  if (table_) {
    if (Of(table_) == this) {
      wasm_table_set_host_info(table_, nullptr);
    }
    wasm_table_delete(table_);
    table_ = nullptr;
  }
  wasm::WasmStoreOwner::Release(store_owner_);
}

void JSCWasmTable::DetachOnExit(wasm::WasmTrackedHandle* handle,
                                void* exit_ctx) {
  (void)exit_ctx;
  auto* self = static_cast<JSCWasmTable*>(handle->owner_object);
  self->DetachWasmTable();
}

void JSCWasmTable::Finalize(JSObjectRef object) {
  auto* tbl = static_cast<JSCWasmTable*>(JSObjectGetPrivate(object));
  delete tbl;
}

JSObjectRef JSCWasmTable::CreatePrototype(JSContextRef ctx,
                                          JSValueRef* exception) {
  JSObjectRef prototype = JSObjectMake(ctx, prototype_class_ref(), nullptr);
  PropertyDescriptor instance_values[] = {
      {"length", GetLengthCallback, nullptr, PropertyAttributes::None},
      {nullptr, nullptr, nullptr, PropertyAttributes::None}};
  DefineProperties(ctx, prototype, instance_values, exception);
  return prototype;
}

JSObjectRef JSCWasmTable::CreateConstructor(JSContextRef ctx, JSCEnv* env,
                                            JSValueRef* exception) {
  JSObjectRef ctor = JSObjectMake(ctx, constructor_class_ref(), env);
  JSObjectRef prototype = CreatePrototype(ctx, exception);
  InitConstructor(ctx, ctor, "Table", prototype, exception);
  env->SetTableConstructor(ctor);
  return ctor;
}

bool JSCWasmTable::IsJSCWasmTable(JSContextRef ctx, JSValueRef target) {
  if (!target || !JSValueIsObjectOfClass(ctx, target, class_ref())) {
    return false;
  }
  auto* tbl = static_cast<JSCWasmTable*>(
      JSObjectGetPrivate(JSValueToObject(ctx, target, nullptr)));
  return tbl != nullptr && tbl->table_ != nullptr;
}

JSObjectRef JSCWasmTable::WrapOwnedTable(JSContextRef ctx, JSCEnv* env,
                                         wasm_table_t* table, uint32_t maximum,
                                         JSValueRef* exception) {
  JSObjectRef ctor = env->js_table_constructor();
  if (wasm_unlikely(!ctor)) return nullptr;
  JSValueRef maybe_proto = JSObjectGetProperty(
      ctx, ctor, JSCBuiltinObjects::PrototypeStr(), exception);
  if (exception && *exception) return nullptr;
  JSObjectRef prototype = JSValueToObject(ctx, maybe_proto, exception);
  if ((exception && *exception) || !prototype) return nullptr;

  JSObjectRef obj = JSObjectMake(ctx, class_ref(), nullptr);
  if (!RetainWasmRootOnJSCObject(ctx, obj, env->wasm_root(), exception)) {
    return nullptr;
  }
  JSObjectSetPrototype(ctx, obj, prototype);
  auto* table_data = new JSCWasmTable(env, table, maximum, obj);
  WASM_CHECK(JSObjectSetPrivate(obj, table_data));
  return obj;
}

JSObjectRef JSCWasmTable::GetOrWrapOwnedTable(JSContextRef ctx, JSCEnv* env,
                                              wasm_table_t* table,
                                              JSValueRef* exception) {
  if (!table) return nullptr;
  if (JSCWasmTable* existing = Of(table)) {
    JSObjectRef obj = existing->js_object();
    wasm_table_delete(table);
    return obj;
  }
  uint32_t maximum = wasm_limits_max_default;
  if (wasm_tabletype_t* ttype = wasm_table_type(table)) {
    if (const wasm_limits_t* limits = wasm_tabletype_limits(ttype)) {
      maximum = limits->max;
    }
    wasm_tabletype_delete(ttype);
  }
  JSObjectRef wrapped = WrapOwnedTable(ctx, env, table, maximum, exception);
  if (!wrapped) {
    wasm_table_delete(table);
  }
  return wrapped;
}

JSObjectRef JSCWasmTable::CallAsConstructor(JSContextRef ctx,
                                            JSObjectRef constructor,
                                            size_t argc,
                                            const JSValueRef argv[],
                                            JSValueRef* exception) {
  constexpr const char* code = "WebAssembly.Table()";

  auto* env = static_cast<JSCEnv*>(JSObjectGetPrivate(constructor));
  if (!env || !env->wasm_store()) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "WebAssembly context is not active", exception);
  }
  if (argc < 1 || !JSValueIsObject(ctx, argv[0])) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kDescriptorNeeded_1003, exception);
  }

  JSObjectRef table_desc = JSValueToObject(ctx, argv[0], exception);
  if ((exception && *exception) || !table_desc) return nullptr;

  auto read_size = [&](JSValueRef value, int32_t* result) {
    double number = JSValueToNumber(ctx, value, exception);
    if ((exception && *exception) || !std::isfinite(number) ||
        number > std::numeric_limits<int32_t>::max() ||
        number < std::numeric_limits<int32_t>::min()) {
      if (!exception || !*exception) {
        ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                         "Table size must be a finite int32", exception);
      }
      return false;
    }
    *result = static_cast<int32_t>(number);
    return true;
  };

  JSValueRef init_value =
      JSObjectGetProperty(ctx, table_desc, JSString("initial"), exception);
  if (exception && *exception) return nullptr;
  if (JSValueIsUndefined(ctx, init_value)) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Property 'initial' is required", exception);
  }
  int32_t init_num = 0;
  if (!read_size(init_value, &init_num)) return nullptr;
  if (init_num < 0) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kNoNegative_1001, exception);
  }
  if (init_num > kMaxSaneTableSize) {
    return ThrowIfException(
        ctx, ErrorTypes::kRangeError, code,
        "Property 'initial' is above the upper bound 100000", exception);
  }

  JSValueRef max_value =
      JSObjectGetProperty(ctx, table_desc, JSString("maximum"), exception);
  if (exception && *exception) return nullptr;
  int32_t max_num = kMaxSaneTableSize;
  if (!JSValueIsUndefined(ctx, max_value)) {
    if (!read_size(max_value, &max_num)) return nullptr;
    if (max_num < 0) {
      return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                              ErrorMessages::kNoNegative_1002, exception);
    }
  }
  if (init_num > max_num) {
    return ThrowIfException(
        ctx, ErrorTypes::kRangeError, code,
        "Property 'maximum' is below the lower bound 'initial'", exception);
  }
  if (max_num > kMaxSaneTableSize) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            "Property 'maximum' must be within 100000",
                            exception);
  }

  JSValueRef elem_val =
      JSObjectGetProperty(ctx, table_desc, JSString("element"), exception);
  if (exception && *exception) return nullptr;
  JSStringRef elem_str = JSValueToStringCopy(ctx, elem_val, exception);
  if ((exception && *exception) || !elem_str) return nullptr;
  const bool supported = JSStringIsEqualToUTF8CString(elem_str, "anyfunc") ||
                         JSStringIsEqualToUTF8CString(elem_str, "funcref");
  JSStringRelease(elem_str);
  if (!supported) {
    return ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                            ErrorMessages::kUnsupportedElemType_1001,
                            exception);
  }

  wasm_limits_t limits = {static_cast<uint32_t>(init_num),
                          static_cast<uint32_t>(max_num)};
  wasm_valtype_t* elem_type = wasm_valtype_new(WASM_FUNCREF);
  if (wasm_unlikely(!elem_type)) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            "Unable to create WebAssembly.Table", exception);
  }
  wasm_tabletype_t* ttype = wasm_tabletype_new(elem_type, &limits);
  if (wasm_unlikely(!ttype)) {
    wasm_valtype_delete(elem_type);
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            "Unable to create WebAssembly.Table", exception);
  }
  wasm_table_t* table = wasm_table_new(env->wasm_store(), ttype, nullptr);
  wasm_tabletype_delete(ttype);
  if (wasm_unlikely(!table)) {
    return ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                            "Unable to create WebAssembly.Table", exception);
  }

  JSObjectRef wrapped = WrapOwnedTable(
      ctx, env, table, static_cast<uint32_t>(max_num), exception);
  if (!wrapped) {
    wasm_table_delete(table);
  }
  return wrapped;
}

JSValueRef JSCWasmTable::GetLengthCallback(JSContextRef ctx,
                                           JSObjectRef function,
                                           JSObjectRef thisObject, size_t argc,
                                           const JSValueRef argv[],
                                           JSValueRef* exception) {
  (void)function;
  (void)argc;
  (void)argv;
  constexpr const char* code = "WebAssembly.Table.length";

  if (!JSValueIsObjectOfClass(ctx, thisObject, class_ref())) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kIllegalInvocation_1001, exception);
    return JSValueMakeUndefined(ctx);
  }
  auto* tbl = static_cast<JSCWasmTable*>(JSObjectGetPrivate(thisObject));
  if (!tbl || !tbl->table_) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kIllegalInvocation_1001, exception);
    return JSValueMakeUndefined(ctx);
  }
  return JSValueMakeNumber(ctx, tbl->size());
}

JSValueRef JSCWasmTable::GetIndexCallback(JSContextRef ctx,
                                          JSObjectRef function,
                                          JSObjectRef thisObject, size_t argc,
                                          const JSValueRef argv[],
                                          JSValueRef* exception) {
  (void)function;
  constexpr const char* code = "WebAssembly.Table.get()";

  if (!JSValueIsObjectOfClass(ctx, thisObject, class_ref())) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kIllegalInvocation_1001, exception);
    return JSValueMakeUndefined(ctx);
  }
  auto* tbl = static_cast<JSCWasmTable*>(JSObjectGetPrivate(thisObject));
  JSCEnv* env =
      tbl && tbl->store_owner_ ? tbl->store_owner_->active_jsc_env() : nullptr;
  if (!tbl || !tbl->table_ || !env || argc < 1) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kInvalidArgs_1002, exception);
    return JSValueMakeUndefined(ctx);
  }

  int32_t index = 0;
  if (!JSValueGetInt32(ctx, argv[0], &index, exception) || index < 0) {
    if (!exception || !*exception) {
      ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                       ErrorMessages::kInvalidTableIndex_1001, exception);
    }
    return JSValueMakeUndefined(ctx);
  }

  if (wasm_unlikely(static_cast<uint32_t>(index) >= tbl->size())) {
    ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                     ErrorMessages::kOutOfBoundOperation_1001, exception);
    return JSValueMakeUndefined(ctx);
  }

  wasm_ref_t* ref = wasm_table_get(tbl->table_, static_cast<uint32_t>(index));
  if (!ref) return JSValueMakeNull(ctx);
  wasm_func_t* func_ref = wasm_ref_as_func(ref);
  if (!func_ref) {
    wasm_ref_delete(ref);
    return JSValueMakeNull(ctx);
  }

  JSObjectRef wrapped = JSCWasmFunction::GetOrWrapOwnedFunc(ctx, env, func_ref,
                                                            nullptr, exception);
  if (wrapped && !tbl->keep_set().empty()) {
    if (auto* fn = static_cast<JSCWasmFunction*>(JSObjectGetPrivate(wrapped))) {
      if (!fn->keep_set().MergeFrom(env, wrapped, tbl->keep_set(), exception)) {
        return JSValueMakeUndefined(ctx);
      }
    }
  }
  return wrapped ? static_cast<JSValueRef>(wrapped) : JSValueMakeUndefined(ctx);
}

JSValueRef JSCWasmTable::SetIndexCallback(JSContextRef ctx,
                                          JSObjectRef function,
                                          JSObjectRef thisObject, size_t argc,
                                          const JSValueRef argv[],
                                          JSValueRef* exception) {
  (void)function;
  constexpr const char* code = "WebAssembly.Table.set()";

  if (!JSValueIsObjectOfClass(ctx, thisObject, class_ref())) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kIllegalInvocation_1001, exception);
    return JSValueMakeUndefined(ctx);
  }
  auto* tbl = static_cast<JSCWasmTable*>(JSObjectGetPrivate(thisObject));
  JSCEnv* env =
      tbl && tbl->store_owner_ ? tbl->store_owner_->active_jsc_env() : nullptr;
  if (!tbl || !tbl->table_ || !env || argc < 2) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kInvalidArgs_1003, exception);
    return JSValueMakeUndefined(ctx);
  }

  int32_t index = 0;
  if (!JSValueGetInt32(ctx, argv[0], &index, exception) || index < 0) {
    if (!exception || !*exception) {
      ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                       ErrorMessages::kInvalidTableIndex_1002, exception);
    }
    return JSValueMakeUndefined(ctx);
  }

  if (wasm_unlikely(static_cast<uint32_t>(index) >= tbl->size())) {
    ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                     ErrorMessages::kOutOfBoundOperation_1002, exception);
    return JSValueMakeUndefined(ctx);
  }

  JSValueRef value_val = argv[1];
  wasm_func_t* func_addr = nullptr;
  JSCWasmFunction* fn = nullptr;
  if (!JSValueIsNull(ctx, value_val)) {
    if (!JSCWasmFunction::IsWasmFunction(ctx, value_val)) {
      ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                       ErrorMessages::kInvalidTableElem_1001, exception);
      return JSValueMakeUndefined(ctx);
    }
    JSObjectRef fn_obj = JSValueToObject(ctx, value_val, nullptr);
    fn = static_cast<JSCWasmFunction*>(JSObjectGetPrivate(fn_obj));
    if (!fn || fn->store_owner() != tbl->store_owner_) {
      ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                       "Table value belongs to a different runtime", exception);
      return JSValueMakeUndefined(ctx);
    }
    func_addr = fn->function();
  }

  if (!wasm_table_set(tbl->table_, static_cast<uint32_t>(index),
                      func_addr ? wasm_func_as_ref(func_addr) : nullptr)) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     "Unable to set WebAssembly.Table value", exception);
  } else if (fn && !fn->keep_set().empty()) {
    tbl->keep_set().MergeFrom(env, thisObject, fn->keep_set(), exception);
  }
  return JSValueMakeUndefined(ctx);
}

JSValueRef JSCWasmTable::GrowCallback(JSContextRef ctx, JSObjectRef function,
                                      JSObjectRef thisObject, size_t argc,
                                      const JSValueRef argv[],
                                      JSValueRef* exception) {
  (void)function;
  constexpr const char* code = "WebAssembly.Table.grow()";

  if (!JSValueIsObjectOfClass(ctx, thisObject, class_ref())) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kIllegalInvocation_1001, exception);
    return JSValueMakeUndefined(ctx);
  }
  auto* tbl = static_cast<JSCWasmTable*>(JSObjectGetPrivate(thisObject));
  if (!tbl || !tbl->table_ || argc < 1) {
    ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                     ErrorMessages::kNoConvertibleNum_1003, exception);
    return JSValueMakeUndefined(ctx);
  }

  int32_t delta = 0;
  if (!JSValueGetInt32(ctx, argv[0], &delta, exception) || delta < 0) {
    if (!exception || !*exception) {
      ThrowIfException(ctx, ErrorTypes::kTypeError, code,
                       ErrorMessages::kNoConvertibleNum_1004, exception);
    }
    return JSValueMakeUndefined(ctx);
  }

  const uint32_t old_size = tbl->size();
  if (static_cast<uint64_t>(old_size) + static_cast<uint64_t>(delta) >
      tbl->maximum_) {
    ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                     ErrorMessages::kOutOfBoundOperation_1003, exception);
    return JSValueMakeUndefined(ctx);
  }
  if (!wasm_table_grow(tbl->table_, static_cast<uint32_t>(delta), nullptr)) {
    ThrowIfException(ctx, ErrorTypes::kRangeError, code,
                     ErrorMessages::kGrowFailed_1002, exception);
    return JSValueMakeUndefined(ctx);
  }
  return JSValueMakeNumber(ctx, old_size);
}

}  // namespace primjs::jsc
