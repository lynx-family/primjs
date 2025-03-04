/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "napi.h"

////////////////////////////////////////////////////////////////////////////////
// N-API C++ Wrapper Classes
//
// Inline header-only implementations for "N-API" ABI-stable C APIs for Node.js.
////////////////////////////////////////////////////////////////////////////////

// Note: Do not include this file directly! Include "napi.h" instead.

#include "napi/common/napi_state.h"
#include "napi_module.h"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

namespace Napi {

static NAPI_NO_RETURN void Fatal(const char* message) { ::abort(); }

static void CheckStatus(napi_env env, napi_status status, const char* message) {
  if (status != napi_ok) {
    std::string msg_str =
        std::string(message) + ", napi status" + std::to_string(status);
    Napi::Error::New(env, msg_str.c_str()).ThrowAsJavaScriptException();
  }
}

void NAPI::FromJustIsNothing() { Fatal("FromJust is Nothing"); }

void NAPI::ToValueEmpty() { Fatal("ToValueEmpty is Nothing"); }

napi_ref NAPI::CreateReference(napi_env env, napi_value value,
                               uint32_t refcount) {
  napi_ref result;
  napi_status status =
      NAPI_ENV_CALL(create_reference, env, value, refcount, &result);
  CheckStatus(env, status, "failed to call napi_create_reference");
  return result;
}

void NAPI::DeleteReference(napi_env env, napi_ref ref) {
  napi_status status = NAPI_ENV_CALL(delete_reference, env, ref);
  CheckStatus(env, status, "failed to call napi_delete_reference");
}

napi_value NAPI::GetReferenceValue(napi_env env, napi_ref ref) {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(get_reference_value, env, ref, &value);
  CheckStatus(env, status, "failed to call napi_get_reference_value");
  return value;
}

uint32_t NAPI::ReferenceRef(napi_env env, napi_ref ref) {
  uint32_t result;
  napi_status status = NAPI_ENV_CALL(reference_ref, env, ref, &result);
  CheckStatus(env, status, "failed to call napi_reference_ref");
  return result;
}

uint32_t NAPI::ReferenceUnRef(napi_env env, napi_ref ref) {
  uint32_t result;
  napi_status status = NAPI_ENV_CALL(reference_unref, env, ref, &result);
  CheckStatus(env, status, "failed to call napi_reference_unref");
  return result;
}

void* NAPI::Unwrap(napi_env env, napi_value obj) {
  void* result;
  napi_status status = NAPI_ENV_CALL(unwrap, env, obj, &result);
  CheckStatus(env, status, "failed to call napi_unwrap");
  return result;
}

napi_ref NAPI::Wrap(napi_env env, napi_value obj, void* data,
                    napi_finalize finalize_cb, void* hint) {
  napi_ref result;
  napi_status status =
      NAPI_ENV_CALL(wrap, env, obj, data, finalize_cb, hint, &result);
  CheckStatus(env, status, "failed to call napi_wrap");
  return result;
}

napi_class NAPI::DefineClass(napi_env env, const char* utf8name,
                             napi_callback ctor, size_t props_count,
                             const napi_property_descriptor* descriptors,
                             void* data, napi_class super_class) {
  napi_class result;
  napi_status status =
      NAPI_ENV_CALL(define_class, env, utf8name, NAPI_AUTO_LENGTH, ctor, data,
                    props_count, descriptors, super_class, &result);
  CheckStatus(env, status, "failed to call napi_wrap");
  return result;
}

// Helpers to handle functions exposed from C++.
namespace details {

struct CallbackData {
  static napi_value Wrapper(napi_env env, napi_callback_info info) {
    CallbackInfo callbackInfo(env, info);
    CallbackData* callbackData =
        static_cast<CallbackData*>(callbackInfo.Data());
    callbackInfo.SetData(callbackData->data);
    return callbackData->callback(callbackInfo);
  }

  Napi::Function::Callback callback;
  void* data;
};

struct AccessorCallbackData {
  static napi_value GetterWrapper(napi_env env, napi_callback_info info) {
    CallbackInfo callbackInfo(env, info);
    AccessorCallbackData* callbackData =
        static_cast<AccessorCallbackData*>(callbackInfo.Data());
    callbackInfo.SetData(callbackData->data);
    return callbackData->getterCallback(callbackInfo);
  }

  static napi_value SetterWrapper(napi_env env, napi_callback_info info) {
    CallbackInfo callbackInfo(env, info);
    AccessorCallbackData* callbackData =
        static_cast<AccessorCallbackData*>(callbackInfo.Data());
    callbackInfo.SetData(callbackData->data);
    callbackData->setterCallback(callbackInfo, callbackInfo[0]);
    return nullptr;
  }

  Napi::Function::Callback getterCallback;
  Napi::PropertyDescriptor::SetterCallback setterCallback;
  void* data;
};

}  // namespace details

////////////////////////////////////////////////////////////////////////////////
// Env class
////////////////////////////////////////////////////////////////////////////////

Object Env::Global() const {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(get_global, *this, &value);
  CheckStatus(_env, status, "failed to call napi_get_global");
  return Object(*this, value);
}

Value Env::Undefined() const {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(get_undefined, *this, &value);
  CheckStatus(_env, status, "failed to call napi_get_undefined");
  return Value(*this, value);
}

Value Env::Null() const {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(get_null, *this, &value);
  CheckStatus(_env, status, "failed to call napi_get_null");
  return Value(*this, value);
}

Object Env::Loader() const {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(get_loader, *this, &value);
  CheckStatus(_env, status, "failed to call napi_get_loader");
  return Object(*this, value);
}

bool Env::IsExceptionPending() const {
  bool result;
  napi_status status = NAPI_ENV_CALL(is_exception_pending, _env, &result);
  if (status != napi_ok)
    result = false;  // Checking for a pending exception shouldn't throw.
  return result;
}

Value Env::GetAndClearPendingException() {
  napi_value value;
  napi_status status =
      NAPI_ENV_CALL(get_and_clear_last_exception, _env, &value);
  if (status != napi_ok) {
    // Don't throw another exception when failing to get the exception!
    return Value();
  }
  return Value(_env, value);
}

Value Env::GetUnhandledRecjectionException() {
  napi_value value = nullptr;
  napi_status status =
      NAPI_ENV_CALL(get_unhandled_rejection_exception, _env, &value);
  if (status != napi_ok) {
    // Don't throw another exception when failing to get the exception!
    return Value();
  }
  return Value(_env, value);
}

#ifdef ENABLE_CODECACHE
void Env::InitCodeCache(int capacity, const std::string& filename,
                        std::function<void(bool)> callback) {
  NAPI_ENV_CALL(init_code_cache, _env, capacity, filename, std::move(callback));
}

void Env::OutputCodeCache() { NAPI_ENV_CALL(output_code_cache, _env, 0); }

void Env::DumpCacheStatus(std::vector<std::pair<std::string, int>>* dump_vec) {
#ifdef PROFILE_CODECACHE
  NAPI_ENV_CALL(dump_code_cache_status, _env, dump_vec);
#endif  // PROFILE_CODECACHE
}

Value Env::RunScriptCache(const char* utf8script, size_t length,
                          const char* filename) {
  napi_value result;
  napi_status status = NAPI_ENV_CALL(run_script_cache, _env, utf8script, length,
                                     filename, &result);
  if (status != napi_ok) {
    return Value();
  }
  return Value(_env, result);
}
#endif  // ENABLE_CODECACHE

Value Env::RunScript(const char* utf8script, size_t length,
                     const char* filename) {
  napi_value result;
  napi_status status =
      NAPI_ENV_CALL(run_script, _env, utf8script, length, filename, &result);
  if (status != napi_ok) {
    return Value();
  }
  return Value(_env, result);
}

void* Env::GetInstanceData(uint64_t key) {
  void* data = nullptr;

  napi_status status = NAPI_ENV_CALL(get_instance_data, _env, key, &data);
  CheckStatus(_env, status, "failed to call napi_get_instance_data");

  return data;
}

void Env::SetInstanceData(uint64_t key, void* data, napi_finalize finalize_cb,
                          void* hint) {
  napi_status status =
      NAPI_ENV_CALL(set_instance_data, _env, key, data, finalize_cb, hint);
  CheckStatus(_env, status, "failed to call napi_set_instance_data");
}

void Env::AddCleanupHook(void (*cb)(void*), void* data) {
  napi_status status = NAPI_ENV_CALL(add_env_cleanup_hook, _env, cb, data);
  CheckStatus(_env, status, "failed to call napi_add_env_cleanup_hook");
}

void Env::RemoveCleanupHook(void (*cb)(void*), void* data) {
  napi_status status = NAPI_ENV_CALL(remove_env_cleanup_hook, _env, cb, data);
  CheckStatus(_env, status, "failed to call napi_remove_env_cleanup_hook");
}

////////////////////////////////////////////////////////////////////////////////
// Value class
////////////////////////////////////////////////////////////////////////////////

bool Value::StrictEquals(const Value& other) const {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(strict_equals, _env, *this, other, &result);
  CheckStatus(_env, status, "failed to call napi_strict_equals");
  return result;
}

Maybe<bool> Value::Equals(const Value& other) const {
  bool result;
  napi_status status = NAPI_ENV_CALL(equals, _env, *this, other, &result);
  return status == napi_ok ? Just(result) : Nothing<bool>();
}

napi_valuetype Value::Type() const {
  if (IsEmpty()) {
    return napi_undefined;
  }
  napi_valuetype type;
  napi_status status = NAPI_ENV_CALL(typeof, _env, _value, &type);
  CheckStatus(_env, status, "failed to call napi_typeof");
  return type;
}

bool Value::IsUndefined() const { return Type() == napi_undefined; }

bool Value::IsNull() const { return Type() == napi_null; }

bool Value::IsBoolean() const { return Type() == napi_boolean; }

bool Value::IsNumber() const { return Type() == napi_number; }

bool Value::IsString() const { return Type() == napi_string; }

bool Value::IsSymbol() const { return Type() == napi_symbol; }

bool Value::IsArray() const {
  bool result;
  napi_status status = NAPI_ENV_CALL(is_array, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_is_array");
  return result;
}

bool Value::IsArrayBuffer() const {
  bool result;
  napi_status status = NAPI_ENV_CALL(is_arraybuffer, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_is_arraybuffer");
  return result;
}

bool Value::IsTypedArray() const {
  bool result;
  napi_status status = NAPI_ENV_CALL(is_typedarray, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_is_typedarray");
  return result;
}

bool Value::IsInt8Array() const {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(is_typedarray_of, _env, _value, napi_int8_array, &result);
  CheckStatus(_env, status, "failed to call napi_is_typedarray_of");
  return result;
}

bool Value::IsUint8Array() const {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(is_typedarray_of, _env, _value, napi_uint8_array, &result);
  CheckStatus(_env, status, "failed to call napi_is_typedarray_of");
  return result;
}

bool Value::IsUint8ClampedArray() const {
  bool result;
  napi_status status = NAPI_ENV_CALL(is_typedarray_of, _env, _value,
                                     napi_uint8_clamped_array, &result);
  CheckStatus(_env, status, "failed to call napi_is_typedarray_of");
  return result;
}

bool Value::IsInt16Array() const {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(is_typedarray_of, _env, _value, napi_int16_array, &result);
  CheckStatus(_env, status, "failed to call napi_is_typedarray_of");
  return result;
}

bool Value::IsUint16Array() const {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(is_typedarray_of, _env, _value, napi_uint16_array, &result);
  CheckStatus(_env, status, "failed to call napi_is_typedarray_of");
  return result;
}

bool Value::IsInt32Array() const {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(is_typedarray_of, _env, _value, napi_int32_array, &result);
  CheckStatus(_env, status, "failed to call napi_is_typedarray_of");
  return result;
}

bool Value::IsUint32Array() const {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(is_typedarray_of, _env, _value, napi_uint32_array, &result);
  CheckStatus(_env, status, "failed to call napi_is_typedarray_of");
  return result;
}

bool Value::IsFloat32Array() const {
  bool result;
  napi_status status = NAPI_ENV_CALL(is_typedarray_of, _env, _value,
                                     napi_float32_array, &result);
  CheckStatus(_env, status, "failed to call napi_is_typedarray_of");
  return result;
}

bool Value::IsFloat64Array() const {
  bool result;
  napi_status status = NAPI_ENV_CALL(is_typedarray_of, _env, _value,
                                     napi_float64_array, &result);
  CheckStatus(_env, status, "failed to call napi_is_typedarray_of");
  return result;
}

bool Value::IsObject() const { return Type() == napi_object || IsFunction(); }

bool Value::IsFunction() const { return Type() == napi_function; }

bool Value::IsPromise() const {
  bool result;
  napi_status status = NAPI_ENV_CALL(is_promise, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_is_promise");
  return result;
}

bool Value::IsDataView() const {
  bool result;
  napi_status status = NAPI_ENV_CALL(is_dataview, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_is_dataview");
  return result;
}

bool Value::IsExternal() const { return Type() == napi_external; }

Boolean Value::ToBoolean() const {
  napi_value result = nullptr;
  napi_status status = NAPI_ENV_CALL(coerce_to_bool, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_coerce_to_bool");
  return Boolean(_env, result);
}

Number Value::ToNumber() const {
  napi_value result;
  napi_status status = NAPI_ENV_CALL(coerce_to_number, _env, _value, &result);
  if (status != napi_ok) {
    return Number();
  }
  return Number(_env, result);
}

String Value::ToString() const {
  napi_value result;
  napi_status status = NAPI_ENV_CALL(coerce_to_string, _env, _value, &result);
  if (status != napi_ok) {
    return String();
  }
  return String(_env, result);
}

Object Value::ToObject() const {
  napi_value result;
  napi_status status = NAPI_ENV_CALL(coerce_to_object, _env, _value, &result);
  if (status != napi_ok) {
    return Object();
  }
  return Object(_env, result);
}

////////////////////////////////////////////////////////////////////////////////
// Boolean class
////////////////////////////////////////////////////////////////////////////////

Boolean Boolean::New(napi_env env, bool val) {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(get_boolean, env, val, &value);
  CheckStatus(env, status, "failed to call napi_get_boolean");
  return Boolean(env, value);
}

bool Boolean::Value() const {
  bool result;
  napi_status status = NAPI_ENV_CALL(get_value_bool, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_get_value_bool");
  return result;
}

////////////////////////////////////////////////////////////////////////////////
// Number class
////////////////////////////////////////////////////////////////////////////////

Number Number::New(napi_env env, double val) {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(create_double, env, val, &value);
  CheckStatus(env, status, "failed to call napi_create_double");
  return Number(env, value);
}

int32_t Number::Int32Value() const {
  int32_t result;
  napi_status status = NAPI_ENV_CALL(get_value_int32, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_get_value_int32");
  return result;
}

uint32_t Number::Uint32Value() const {
  uint32_t result;
  napi_status status = NAPI_ENV_CALL(get_value_uint32, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_get_value_uint32");
  return result;
}

int64_t Number::Int64Value() const {
  int64_t result;
  napi_status status = NAPI_ENV_CALL(get_value_int64, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_get_value_int64");
  return result;
}

float Number::FloatValue() const { return static_cast<float>(DoubleValue()); }

double Number::DoubleValue() const {
  double result;
  napi_status status = NAPI_ENV_CALL(get_value_double, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_get_value_double");
  return result;
}

////////////////////////////////////////////////////////////////////////////////
// String class
////////////////////////////////////////////////////////////////////////////////

String String::New(napi_env env, const char* val) {
  napi_value value;
  napi_status status =
      NAPI_ENV_CALL(create_string_utf8, env, val, std::strlen(val), &value);
  if (status != napi_ok) {
    return String();
  }
  return String(env, value);
}

String String::New(napi_env env, const char16_t* val) {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(create_string_utf16, env, val,
                                     std::u16string(val).size(), &value);
  if (status != napi_ok) {
    return String();
  }
  return String(env, value);
}

String String::New(napi_env env, const char* val, size_t length) {
  napi_value value;
  napi_status status =
      NAPI_ENV_CALL(create_string_utf8, env, val, length, &value);
  if (status != napi_ok) {
    return String();
  }
  return String(env, value);
}

String String::New(napi_env env, const char16_t* val, size_t length) {
  napi_value value;
  napi_status status =
      NAPI_ENV_CALL(create_string_utf16, env, val, length, &value);
  if (status != napi_ok) {
    return String();
  }
  return String(env, value);
}

std::string String::Utf8Value() const {
  size_t length;
  napi_status status =
      NAPI_ENV_CALL(get_value_string_utf8, _env, _value, nullptr, 0, &length);
  CheckStatus(_env, status, "failed to call napi_get_value_string_utf8");

  if (length == SIZE_MAX) {
    return "";
  }
  std::string value;

  value.reserve(length + 1);
  value.resize(length);
  status = NAPI_ENV_CALL(get_value_string_utf8, _env, _value, &value[0],
                         value.capacity(), nullptr);
  CheckStatus(_env, status, "failed to call napi_get_value_string_utf8");
  return value;
}

std::u16string String::Utf16Value() const {
  size_t length;
  napi_status status =
      NAPI_ENV_CALL(get_value_string_utf16, _env, _value, nullptr, 0, &length);
  CheckStatus(_env, status, "failed to call napi_get_value_string_utf16");

  std::u16string value;
  value.reserve(length + 1);
  value.resize(length);
  status = NAPI_ENV_CALL(get_value_string_utf16, _env, _value, &value[0],
                         value.capacity(), nullptr);
  CheckStatus(_env, status, "failed to call napi_get_value_string_utf16");
  return value;
}

////////////////////////////////////////////////////////////////////////////////
// Symbol class
////////////////////////////////////////////////////////////////////////////////

Symbol Symbol::New(napi_env env, const char* description) {
  napi_value descriptionValue = description != nullptr
                                    ? String::New(env, description)
                                    : static_cast<napi_value>(nullptr);
  return Symbol::New(env, descriptionValue);
}

Symbol Symbol::New(napi_env env, String description) {
  napi_value descriptionValue = description;
  return Symbol::New(env, descriptionValue);
}

Symbol Symbol::New(napi_env env, napi_value description) {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(create_symbol, env, description, &value);
  CheckStatus(env, status, "failed to call napi_create_symbol");
  return Symbol(env, value);
}

Symbol Symbol::WellKnown(napi_env env, const char* name) {
  return Napi::Env(env)
      .Global()
      .Get("Symbol")
      .As<Object>()
      .Get(name)
      .As<Symbol>();
}

////////////////////////////////////////////////////////////////////////////////
// Object class
////////////////////////////////////////////////////////////////////////////////

Object Object::New(napi_env env) {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(create_object, env, &value);
  CheckStatus(env, status, "failed to call napi_create_object");
  return Object(env, value);
}

Object Object::GetOwnPropertyDescriptor(napi_env env, Value obj, Value prop) {
  napi_value value = nullptr;
  napi_status status =
      NAPI_ENV_CALL(get_own_property_descriptor, env, obj, prop, &value);
  CheckStatus(env, status, "failed to call napi_get_own_property_descriptor");
  return Object(env, value);
}

Maybe<bool> Object::Has(napi_value key) const {
  bool result;
  napi_status status = NAPI_ENV_CALL(has_property, _env, _value, key, &result);
  return status == napi_ok ? Just(result) : Nothing<bool>();
}

Maybe<bool> Object::Has(const char* utf8name) const {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(has_named_property, _env, _value, utf8name, &result);
  return status == napi_ok ? Just(result) : Nothing<bool>();
}

Maybe<bool> Object::HasOwnProperty(napi_value key) const {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(has_own_property, _env, _value, key, &result);
  return status == napi_ok ? Just(result) : Nothing<bool>();
}

Maybe<bool> Object::HasOwnProperty(const char* utf8name) const {
  napi_value key;
  napi_status status = NAPI_ENV_CALL(create_string_utf8, _env, utf8name,
                                     std::strlen(utf8name), &key);
  if (status != napi_ok) {
    return Nothing<bool>();
  }
  return HasOwnProperty(key);
}

Value Object::Get(napi_value key) const {
  napi_value result;
  napi_status status = NAPI_ENV_CALL(get_property, _env, _value, key, &result);
  if (status != napi_ok) {
    return Value();
  }
  return Value(_env, result);
}

Value Object::Get(const char* utf8name) const {
  napi_value result;
  napi_status status =
      NAPI_ENV_CALL(get_named_property, _env, _value, utf8name, &result);
  if (status != napi_ok) {
    return Value();
  }
  return Value(_env, result);
}

Maybe<void> Object::Set(const char* utf8name, napi_value value) {
  napi_status status =
      NAPI_ENV_CALL(set_named_property, _env, _value, utf8name, value);
  return status == napi_ok ? JustVoid() : Nothing<void>();
}

Maybe<void> Object::Set(napi_value key, napi_value value) {
  napi_status status = NAPI_ENV_CALL(set_property, _env, _value, key, value);
  return status == napi_ok ? JustVoid() : Nothing<void>();
}

Maybe<bool> Object::Delete(napi_value key) {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(delete_property, _env, _value, key, &result);
  return status == napi_ok ? Just(result) : Nothing<bool>();
}

Maybe<bool> Object::Delete(const char* utf8name) {
  String key = String::New(_env, utf8name);
  return key.IsEmpty() ? Nothing<bool>() : Delete(key.operator napi_value());
}

Maybe<bool> Object::Has(uint32_t index) const {
  bool result;
  napi_status status = NAPI_ENV_CALL(has_element, _env, _value, index, &result);
  return status == napi_ok ? Just(result) : Nothing<bool>();
}

Value Object::Get(uint32_t index) const {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(get_element, _env, _value, index, &value);
  return status == napi_ok ? Value(_env, value) : Value();
}

Maybe<void> Object::Set(uint32_t index, napi_value value) {
  napi_status status = NAPI_ENV_CALL(set_element, _env, _value, index, value);
  return status == napi_ok ? JustVoid() : Nothing<void>();
}

Maybe<bool> Object::Delete(uint32_t index) {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(delete_element, _env, _value, index, &result);
  return status == napi_ok ? Just(result) : Nothing<bool>();
}

Array Object::GetPropertyNames() const {
  napi_value result;
  napi_status status = NAPI_ENV_CALL(get_property_names, _env, _value, &result);
  return status == napi_ok ? Array(_env, result) : Array();
}

Maybe<void> Object::DefineProperty(const PropertyDescriptor& property) {
  napi_status status = NAPI_ENV_CALL(
      define_properties, _env, _value, 1,
      reinterpret_cast<const napi_property_descriptor*>(&property));
  return status == napi_ok ? JustVoid() : Nothing<void>();
}

Maybe<void> Object::DefineProperties(
    const std::initializer_list<PropertyDescriptor>& properties) {
  napi_status status = NAPI_ENV_CALL(
      define_properties, _env, _value, properties.size(),
      reinterpret_cast<const napi_property_descriptor*>(properties.begin()));
  return status == napi_ok ? JustVoid() : Nothing<void>();
}

Maybe<void> Object::DefineProperties(
    const std::vector<PropertyDescriptor>& properties) {
  napi_status status = NAPI_ENV_CALL(
      define_properties, _env, _value, properties.size(),
      reinterpret_cast<const napi_property_descriptor*>(properties.data()));
  return status == napi_ok ? JustVoid() : Nothing<void>();
}

Maybe<bool> Object::InstanceOf(const Function& constructor) const {
  bool result;
  napi_status status =
      NAPI_ENV_CALL(instanceof, _env, _value, constructor, &result);
  return status == napi_ok ? Just(result) : Nothing<bool>();
}

void Object::AddFinalizer(void* data, napi_finalize cb, void* hint) {
  napi_status status =
      NAPI_ENV_CALL(add_finalizer, _env, _value, data, cb, hint, nullptr);
  CheckStatus(_env, status, "failed to call napi_add_finalizer");
}

////////////////////////////////////////////////////////////////////////////////
// Array class
////////////////////////////////////////////////////////////////////////////////

Array Array::New(napi_env env) {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(create_array, env, &value);
  CheckStatus(env, status, "failed to call napi_create_array");
  return Array(env, value);
}

Array Array::New(napi_env env, size_t length) {
  napi_value value;
  napi_status status =
      NAPI_ENV_CALL(create_array_with_length, env, length, &value);
  CheckStatus(env, status, "failed to call napi_create_array_with_length");
  return Array(env, value);
}

uint32_t Array::Length() const {
  uint32_t result;
  napi_status status = NAPI_ENV_CALL(get_array_length, _env, _value, &result);
  CheckStatus(_env, status, "failed to call napi_get_array_length");
  return result;
}

////////////////////////////////////////////////////////////////////////////////
// ArrayBuffer class
////////////////////////////////////////////////////////////////////////////////

ArrayBuffer ArrayBuffer::New(napi_env env, size_t byteLength) {
  napi_value value;
  void* data;
  napi_status status =
      NAPI_ENV_CALL(create_arraybuffer, env, byteLength, &data, &value);
  CheckStatus(env, status, "failed to call napi_create_arraybuffer");

  return ArrayBuffer(env, value);
}

ArrayBuffer ArrayBuffer::New(napi_env env, void* externalData,
                             size_t byteLength) {
  napi_value value;
  napi_status status =
      NAPI_ENV_CALL(create_external_arraybuffer, env, externalData, byteLength,
                    nullptr, nullptr, &value);
  CheckStatus(env, status, "failed to call napi_create_arraybuffer");

  return ArrayBuffer(env, value);
}

ArrayBuffer ArrayBuffer::New(napi_env env, void* externalData,
                             size_t byteLength, napi_finalize finalizeCallback,
                             void* finalizeHint) {
  napi_value value;
  napi_status status =
      NAPI_ENV_CALL(create_external_arraybuffer, env, externalData, byteLength,
                    finalizeCallback, finalizeHint, &value);
  CheckStatus(env, status, "failed to call napi_create_external_arraybuffer");

  return ArrayBuffer(env, value);
}

void* ArrayBuffer::Data() {
  void* data;
  napi_status status =
      NAPI_ENV_CALL(get_arraybuffer_info, _env, _value, &data, nullptr);
  CheckStatus(_env, status, "failed to call napi_get_arraybuffer_info");
  return data;
}

size_t ArrayBuffer::ByteLength() {
  size_t length;
  napi_status status =
      NAPI_ENV_CALL(get_arraybuffer_info, _env, _value, nullptr, &length);
  CheckStatus(_env, status, "failed to call napi_get_arraybuffer_info");
  return length;
}

////////////////////////////////////////////////////////////////////////////////
// DataView class
////////////////////////////////////////////////////////////////////////////////
DataView DataView::New(napi_env env, Napi::ArrayBuffer arrayBuffer) {
  return New(env, arrayBuffer, 0, arrayBuffer.ByteLength());
}

DataView DataView::New(napi_env env, Napi::ArrayBuffer arrayBuffer,
                       size_t byteOffset) {
  return New(env, arrayBuffer, byteOffset,
             arrayBuffer.ByteLength() - byteOffset);
}

DataView DataView::New(napi_env env, Napi::ArrayBuffer arrayBuffer,
                       size_t byteOffset, size_t byteLength) {
  napi_value value;
  napi_status status = NAPI_ENV_CALL(create_dataview, env, byteLength,
                                     arrayBuffer, byteOffset, &value);
  CheckStatus(env, status, "failed to call napi_create_dataview");
  return DataView(env, value);
}

DataView::DataView(napi_env env, napi_value value) : Object(env, value) {
  napi_status status = NAPI_ENV_CALL(
      get_dataview_info, _env, _value /* dataView */, &_length /* byteLength */,
      &_data /* data */, nullptr /* arrayBuffer */, nullptr /* byteOffset */);
  CheckStatus(_env, status, "failed to call napi_get_dataview_info");
}

Napi::ArrayBuffer DataView::ArrayBuffer() const {
  napi_value arrayBuffer;
  napi_status status =
      NAPI_ENV_CALL(get_dataview_info, _env, _value /* dataView */,
                    nullptr /* byteLength */, nullptr /* data */,
                    &arrayBuffer /* arrayBuffer */, nullptr /* byteOffset */);
  CheckStatus(_env, status, "failed to call napi_get_dataview_info");
  return Napi::ArrayBuffer(_env, arrayBuffer);
}

size_t DataView::ByteOffset() const {
  size_t byteOffset;
  napi_status status =
      NAPI_ENV_CALL(get_dataview_info, _env, _value /* dataView */,
                    nullptr /* byteLength */, nullptr /* data */,
                    nullptr /* arrayBuffer */, &byteOffset /* byteOffset */);
  CheckStatus(_env, status, "failed to call napi_get_dataview_info");
  return byteOffset;
}

////////////////////////////////////////////////////////////////////////////////
// TypedArray class
////////////////////////////////////////////////////////////////////////////////

napi_typedarray_type TypedArray::TypedArrayType() const {
  if (_type == TypedArray::unknown_array_type) {
    napi_status status = NAPI_ENV_CALL(get_typedarray_info, _env, _value,
                                       &const_cast<TypedArray*>(this)->_type,
                                       &const_cast<TypedArray*>(this)->_length,
                                       nullptr, nullptr, nullptr);
    CheckStatus(_env, status, "failed to call napi_get_typedarray_info");
  }

  return _type;
}

uint8_t TypedArray::ElementSize() const {
  switch (TypedArrayType()) {
    case napi_int8_array:
    case napi_uint8_array:
    case napi_uint8_clamped_array:
      return 1;
    case napi_int16_array:
    case napi_uint16_array:
      return 2;
    case napi_int32_array:
    case napi_uint32_array:
    case napi_float32_array:
      return 4;
    case napi_float64_array:
    case napi_bigint64_array:
    case napi_biguint64_array:
      return 8;
    default:
      return 0;
  }
}

size_t TypedArray::ElementLength() const {
  if (_type == TypedArray::unknown_array_type) {
    napi_status status = NAPI_ENV_CALL(get_typedarray_info, _env, _value,
                                       &const_cast<TypedArray*>(this)->_type,
                                       &const_cast<TypedArray*>(this)->_length,
                                       nullptr, nullptr, nullptr);
    CheckStatus(_env, status, "failed to call napi_get_typedarray_info");
  }

  return _length;
}

size_t TypedArray::ByteOffset() const {
  size_t byteOffset;
  napi_status status = NAPI_ENV_CALL(get_typedarray_info, _env, _value, nullptr,
                                     nullptr, nullptr, nullptr, &byteOffset);
  CheckStatus(_env, status, "failed to call napi_get_typedarray_info");
  return byteOffset;
}

size_t TypedArray::ByteLength() const {
  return ElementSize() * ElementLength();
}

Napi::ArrayBuffer TypedArray::ArrayBuffer() const {
  napi_value arrayBuffer;
  napi_status status = NAPI_ENV_CALL(get_typedarray_info, _env, _value, nullptr,
                                     nullptr, nullptr, &arrayBuffer, nullptr);
  CheckStatus(_env, status, "failed to call napi_get_typedarray_info");
  return Napi::ArrayBuffer(_env, arrayBuffer);
}

////////////////////////////////////////////////////////////////////////////////
// TypedArrayOf<T> class
////////////////////////////////////////////////////////////////////////////////

#define TypedArrayImpl(CLAZZ, NAPI_TYPE, C_TYPE)                             \
  CLAZZ CLAZZ::New(napi_env env, size_t elementLength) {                     \
    Napi::ArrayBuffer arrayBuffer =                                          \
        Napi::ArrayBuffer::New(env, elementLength * sizeof(C_TYPE));         \
    return New(env, elementLength, arrayBuffer, 0);                          \
  }                                                                          \
                                                                             \
  CLAZZ CLAZZ::New(napi_env env, size_t elementLength,                       \
                   Napi::ArrayBuffer arrayBuffer, size_t bufferOffset) {     \
    napi_value value;                                                        \
    napi_status status =                                                     \
        NAPI_ENV_CALL(create_typedarray, env, NAPI_TYPE, elementLength,      \
                      arrayBuffer, bufferOffset, &value);                    \
    CheckStatus(env, status, "failed to call napi_create_typedarray");       \
                                                                             \
    return CLAZZ(                                                            \
        env, value, elementLength,                                           \
        reinterpret_cast<C_TYPE*>(                                           \
            reinterpret_cast<uint8_t*>(arrayBuffer.Data()) + bufferOffset)); \
  }                                                                          \
                                                                             \
  CLAZZ::CLAZZ(napi_env env, napi_value value)                               \
      : TypedArray(env, value), _data(nullptr) {                             \
    _type = NAPI_TYPE;                                                       \
    napi_status status =                                                     \
        NAPI_ENV_CALL(get_typedarray_info, _env, _value, nullptr, &_length,  \
                      reinterpret_cast<void**>(&_data), nullptr, nullptr);   \
    CheckStatus(env, status, "failed to call napi_get_typedarray_info");     \
  }

NAPI_FOR_EACH_TYPED_ARRAY(TypedArrayImpl)

#undef TypedArrayImpl

////////////////////////////////////////////////////////////////////////////////
// Function class
////////////////////////////////////////////////////////////////////////////////

Function Function::New(napi_env env, Callback cb, const char* utf8name,
                       void* data) {
  auto callbackData = new details::CallbackData({cb, data});
  napi_value result = nullptr;
  napi_status status =
      NAPI_ENV_CALL(create_function, env, utf8name, NAPI_AUTO_LENGTH,
                    callbackData->Wrapper, callbackData, &result);
  if (status == napi_ok) {
    status = NAPI_ENV_CALL(
        add_finalizer, env, result, callbackData,
        [](napi_env, void* data, void*) {
          delete static_cast<details::CallbackData*>(data);
        },
        nullptr, nullptr);
  }
  CheckStatus(env, status, "failed to call napi_create_function");
  return Function(env, result);
}

Value Function::Call(size_t argc, const napi_value* args) const {
  return Call(Env().Undefined(), argc, args);
}

Value Function::Call(napi_value recv, size_t argc,
                     const napi_value* args) const {
  napi_value result;
  napi_status status =
      NAPI_ENV_CALL(call_function, _env, recv, _value, argc, args, &result);
  return status == napi_ok ? Value(_env, result) : Value();
}

Object Function::New(size_t argc, const napi_value* args) const {
  napi_value result;
  napi_status status =
      NAPI_ENV_CALL(new_instance, _env, _value, argc, args, &result);
  return status == napi_ok ? Object(_env, result) : Object();
}

////////////////////////////////////////////////////////////////////////////////
// Promise class
////////////////////////////////////////////////////////////////////////////////

Promise::Deferred Promise::Deferred::New(napi_env env) {
  return Promise::Deferred(env);
}

Promise::Deferred::Deferred(napi_env env) : _env(env) {
  NAPI_ENV_CALL(create_promise, _env, &_deferred, &_promise);
}

Promise::Deferred::~Deferred() {
  if (_deferred) {
    napi_status status = NAPI_ENV_CALL(release_deferred, _env, _deferred,
                                       nullptr, napi_deferred_delete);
    _deferred = nullptr;
    CheckStatus(_env, status, "failed to call napi_release_deferred");
  }
}

Maybe<void> Promise::Deferred::Resolve(napi_value value) {
  napi_status status = NAPI_ENV_CALL(release_deferred, _env, _deferred, value,
                                     napi_deferred_resolve);
  _deferred = nullptr;
  return status == napi_ok ? JustVoid() : Nothing<void>();
}

Maybe<void> Promise::Deferred::Reject(napi_value value) {
  napi_status status = NAPI_ENV_CALL(release_deferred, _env, _deferred, value,
                                     napi_deferred_reject);
  _deferred = nullptr;
  return status == napi_ok ? JustVoid() : Nothing<void>();
}

////////////////////////////////////////////////////////////////////////////////
// External class
////////////////////////////////////////////////////////////////////////////////

External External::New(napi_env env, void* data, napi_finalize finalize_cb,
                       void* hint) {
  napi_value value;
  napi_status status =
      NAPI_ENV_CALL(create_external, env, data, finalize_cb, hint, &value);
  CheckStatus(env, status, "failed to call napi_create_external");
  return External(env, value);
}

void* External::Data() const {
  void* data;
  napi_status status = NAPI_ENV_CALL(get_value_external, _env, _value, &data);
  CheckStatus(_env, status, "failed to call napi_get_value_external");
  return data;
}

////////////////////////////////////////////////////////////////////////////////
// Error class
////////////////////////////////////////////////////////////////////////////////

Error Error::New(napi_env env) { return Error::New(env, "unknown"); }

Error Error::New(napi_env env, const char* message) {
  return Error(env, Error::Create(env, message, std::strlen(message),
                                  env->napi_create_error));
}

void Error::ThrowAsJavaScriptException() const {
  HandleScope scope(_env);

  napi_status status = NAPI_ENV_CALL(throw_, _env, _value);
  status = napi_clear_last_error(_env);
  CheckStatus(_env, status, "failed to call napi_throw");
}

napi_value Error::Create(napi_env env, const char* message, size_t length,
                         create_error_fn create_error) {
  napi_value str;
  napi_status status =
      NAPI_ENV_CALL(create_string_utf8, env, message, length, &str);
  CheckStatus(env, status, "failed to call napi_create_string_utf8");

  napi_value error;
  status = create_error(env, nullptr, str, &error);
  CheckStatus(env, status, "failed to call napi_create_error");

  return error;
}

TypeError TypeError::New(napi_env env, const char* message) {
  return TypeError(env, Error::Create(env, message, std::strlen(message),
                                      env->napi_create_type_error));
}

RangeError RangeError::New(napi_env env, const char* message) {
  return RangeError(env, Error::Create(env, message, std::strlen(message),
                                       env->napi_create_range_error));
}

////////////////////////////////////////////////////////////////////////////////
// CallbackInfo class
////////////////////////////////////////////////////////////////////////////////

CallbackInfo::CallbackInfo(napi_env env, napi_callback_info info)
    : _env(env),
      _info(info),
      _this(nullptr),
      _dynamicArgs(nullptr),
      _data(nullptr) {
  _argc = _staticArgCount;
  _argv = _staticArgs;
  napi_status status =
      NAPI_ENV_CALL(get_cb_info, env, info, &_argc, _argv, &_this, &_data);
  CheckStatus(_env, status, "failed to call napi_get_cb_info");

  if (_argc > _staticArgCount) {
    // Use either a fixed-size array (on the stack) or a dynamically-allocated
    // array (on the heap) depending on the number of args.
    _dynamicArgs = new napi_value[_argc];
    _argv = _dynamicArgs;

    status =
        NAPI_ENV_CALL(get_cb_info, env, info, &_argc, _argv, nullptr, nullptr);
    CheckStatus(_env, status, "failed to call napi_get_cb_info");
  }
}

CallbackInfo::~CallbackInfo() {
  if (_dynamicArgs != nullptr) {
    delete[] _dynamicArgs;
  }
}

Value CallbackInfo::NewTarget() const {
  napi_value new_target;
  napi_status status = NAPI_ENV_CALL(get_new_target, _env, _info, &new_target);
  CheckStatus(_env, status, "failed to call napi_get_new_target");
  return new_target == nullptr ? Env().Undefined() : Value(_env, new_target);
}

bool CallbackInfo::IsConstructCall() const {
  return !NewTarget().IsUndefined();
}

////////////////////////////////////////////////////////////////////////////////
// PropertyDescriptor class
////////////////////////////////////////////////////////////////////////////////

PropertyDescriptor PropertyDescriptor::Accessor(
    Napi::Env env, Napi::Object obj, const char* utf8name,
    Function::Callback getter, SetterCallback setter,
    napi_property_attributes attributes, void* data) {
  auto callbackData = new details::AccessorCallbackData({getter, setter, data});

  obj.AddFinalizer(callbackData, [](napi_env, void* data, void*) {
    delete static_cast<details::AccessorCallbackData*>(data);
  });

  return PropertyDescriptor({
      utf8name,
      nullptr,
      nullptr,
      getter != nullptr ? callbackData->GetterWrapper : nullptr,
      setter != nullptr ? callbackData->SetterWrapper : nullptr,
      nullptr,
      attributes,
      callbackData,
  });
}

PropertyDescriptor PropertyDescriptor::Accessor(
    Napi::Env env, Napi::Object obj, Name name, Function::Callback getter,
    SetterCallback setter, napi_property_attributes attributes, void* data) {
  auto callbackData = new details::AccessorCallbackData({getter, setter, data});

  obj.AddFinalizer(callbackData, [](napi_env, void* data, void*) {
    delete static_cast<details::AccessorCallbackData*>(data);
  });

  return PropertyDescriptor(
      {nullptr, name, nullptr,
       getter != nullptr ? callbackData->GetterWrapper : nullptr,
       setter != nullptr ? callbackData->SetterWrapper : nullptr, nullptr,
       attributes, callbackData});
}  // namespace Napi

PropertyDescriptor PropertyDescriptor::Function(
    Napi::Env env, Napi::Object obj, const char* utf8name,
    Function::Callback cb, napi_property_attributes attributes, void* data) {
  auto callbackData = new details::CallbackData({cb, data});
  obj.AddFinalizer(callbackData, [](napi_env, void* data, void*) {
    delete static_cast<details::CallbackData*>(data);
  });
  return PropertyDescriptor({utf8name, nullptr, callbackData->Wrapper, nullptr,
                             nullptr, nullptr, attributes, callbackData});
}

PropertyDescriptor PropertyDescriptor::Function(
    Napi::Env env, Napi::Object obj, Name name, Function::Callback cb,
    napi_property_attributes attributes, void* data) {
  auto callbackData = new details::CallbackData({cb, data});
  obj.AddFinalizer(callbackData, [](napi_env, void* data, void*) {
    delete static_cast<details::CallbackData*>(data);
  });
  return PropertyDescriptor({nullptr, name, callbackData->Wrapper, nullptr,
                             nullptr, nullptr, attributes, callbackData});
}

PropertyDescriptor PropertyDescriptor::Value(
    const char* utf8name, napi_value value,
    napi_property_attributes attributes) {
  return PropertyDescriptor({utf8name, nullptr, nullptr, nullptr, nullptr,
                             value, attributes, nullptr});
}

PropertyDescriptor PropertyDescriptor::Value(
    napi_value name, napi_value value, napi_property_attributes attributes) {
  return PropertyDescriptor(
      {nullptr, name, nullptr, nullptr, nullptr, value, attributes, nullptr});
}

////////////////////////////////////////////////////////////////////////////////
// Class class
////////////////////////////////////////////////////////////////////////////////

Class::~Class() {
  if (_class != nullptr) {
    NAPI_ENV_CALL(release_class, _env, _class);
    _class = nullptr;
  }
}

Function Class::Get(napi_env env) {
  napi_value result;
  napi_status status = NAPI_ENV_CALL(class_get_function, env, _class, &result);
  CheckStatus(_env, status, "failed to call napi_class_get_function");
  return Function(env, result);
}

////////////////////////////////////////////////////////////////////////////////
// ScriptWrappable class
////////////////////////////////////////////////////////////////////////////////

ScriptWrappable::ScriptWrappable()
    : _isa(nullptr)
#ifdef NAPI_CPP_RTTI
      ,
      _isa_index(new std::type_index(typeid(void)))
#endif
{
}
ScriptWrappable::~ScriptWrappable() {
#ifdef NAPI_CPP_RTTI
  delete _isa_index;
#else
  // Suppress unused warning.
  (void)_isa;
  (void)_isa_index;
#endif
}

////////////////////////////////////////////////////////////////////////////////
// HandleScope class
////////////////////////////////////////////////////////////////////////////////

HandleScope::HandleScope(Napi::Env env) : _env(env) {
  napi_status status = NAPI_ENV_CALL(open_handle_scope, _env, &_scope);
  CheckStatus(_env, status, "failed to call napi_open_handle_scope");
}

HandleScope::~HandleScope() {
  napi_status status = NAPI_ENV_CALL(close_handle_scope, _env, _scope);
  CheckStatus(_env, status, "failed to call napi_close_handle_scope");
}

////////////////////////////////////////////////////////////////////////////////
// ContextScope class
////////////////////////////////////////////////////////////////////////////////

ContextScope::ContextScope(Napi::Env env) : _env(env) {
  napi_status status = NAPI_ENV_CALL(open_context_scope, _env, &_scope);
  CheckStatus(_env, status, "failed to call napi_open_context_scope");
}

ContextScope::~ContextScope() {
  napi_status status = NAPI_ENV_CALL(close_context_scope, _env, _scope);
  CheckStatus(_env, status, "failed to call napi_close_context_scope");
}

////////////////////////////////////////////////////////////////////////////////
// EscapableHandleScope class
////////////////////////////////////////////////////////////////////////////////

EscapableHandleScope::EscapableHandleScope(Napi::Env env) : _env(env) {
  napi_status status =
      NAPI_ENV_CALL(open_escapable_handle_scope, _env, &_scope);
  CheckStatus(_env, status, "failed to call napi_open_escapable_handle_scope");
}

EscapableHandleScope::~EscapableHandleScope() {
  napi_status status =
      NAPI_ENV_CALL(close_escapable_handle_scope, _env, _scope);
  CheckStatus(_env, status, "failed to call napi_close_escapable_handle_scope");
}

Value EscapableHandleScope::Escape(napi_value escapee) {
  napi_value result;
  napi_status status =
      NAPI_ENV_CALL(escape_handle, _env, _scope, escapee, &result);
  CheckStatus(_env, status, "failed to call napi_escape_handle");
  return Value(_env, result);
}

////////////////////////////////////////////////////////////////////////////////
// ErrorScope class
////////////////////////////////////////////////////////////////////////////////

ErrorScope::ErrorScope(Napi::Env env) : _env(env) {
  napi_status status = NAPI_ENV_CALL(open_error_scope, _env, &_scope);
  CheckStatus(_env, status, "failed to call napi_open_error_scope");
}

ErrorScope::~ErrorScope() {
  napi_status status = NAPI_ENV_CALL(close_error_scope, _env, _scope);
  CheckStatus(_env, status, "failed to call napi_close_error_scope");
}

////////////////////////////////////////////////////////////////////////////////
// AsyncWorker class
////////////////////////////////////////////////////////////////////////////////

AsyncWorker::AsyncWorker(Napi::Env env) : _env(env) {
  napi_status status = NAPI_ENV_CALL(
      create_async_work, _env, nullptr, nullptr,
      [](napi_env env, void* asyncworker) {
        AsyncWorker* self = static_cast<AsyncWorker*>(asyncworker);
        self->Execute();
      },
      [](napi_env env, napi_status status, void* asyncworker) {
        AsyncWorker* self = static_cast<AsyncWorker*>(asyncworker);
        self->OnWorkComplete(env, status);
      },
      this, &_work);
  CheckStatus(_env, status, "failed to call napi_create_async_work");
}

AsyncWorker::~AsyncWorker() {
  if (_work != nullptr) {
    NAPI_ENV_CALL(delete_async_work, _env, _work);
    _work = nullptr;
  }
}

void AsyncWorker::Queue() {
  napi_status status = NAPI_ENV_CALL(queue_async_work, _env, _work);
  CheckStatus(_env, status, "failed to call napi_queue_async_work");
}

void AsyncWorker::Cancel() {
  napi_status status = NAPI_ENV_CALL(cancel_async_work, _env, _work);
  CheckStatus(_env, status, "failed to call napi_cancel_async_work");
}

void AsyncWorker::OnWorkComplete(Napi::Env /*env*/, napi_status status) {
  if (status != napi_cancelled) {
    HandleScope scope(_env);
    OnOK();
  }
  delete this;
}

////////////////////////////////////////////////////////////////////////////////
// Memory Management class
////////////////////////////////////////////////////////////////////////////////

int64_t MemoryManagement::AdjustExternalMemory(Env env,
                                               int64_t change_in_bytes) {
  int64_t result;
  napi_status status =
      NAPI_ENV_CALL(adjust_external_memory, env, change_in_bytes, &result);
  CheckStatus(env, status, "failed to call napi_adjust_external_memory");
  return result;
}

////////////////////////////////////////////////////////////////////////////////
// Version Management class
////////////////////////////////////////////////////////////////////////////////

uint32_t VersionManagement::GetNapiVersion(Env env) {
  uint32_t result;
  napi_status status = NAPI_ENV_CALL(get_version, env, &result);
  CheckStatus(env, status, "failed to call napi_get_version");
  return result;
}
}  // namespace Napi
