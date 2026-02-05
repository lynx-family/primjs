/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */

// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "js_native_api_adapter.h"

#include <climits>
#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <string>

#include "js_native_api_types.h"
#include "napi_runtime.h"
#include "napi_state.h"

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

#define CHECK_ENV(env)         \
  do {                         \
    if ((env) == nullptr) {    \
      return napi_invalid_arg; \
    }                          \
  } while (0)

#define RETURN_STATUS_IF_FALSE(env, condition, status) \
  do {                                                 \
    if (!(condition)) {                                \
      return napi_set_last_error((env), (status));     \
    }                                                  \
  } while (0)

#define CHECK_ARG(env, arg) \
  RETURN_STATUS_IF_FALSE((env), ((arg) != nullptr), napi_invalid_arg)

#define CHECK_NAPI(expr)                  \
  do {                                    \
    napi_status status = (expr);          \
    if (status != napi_ok) return status; \
  } while (0)

#define CHECK_TO_TYPE(env, object, expected_type, expected_error)           \
  do {                                                                      \
    napi_valuetype obj_type = napi_undefined;                               \
    CHECK_NAPI(env->napi_typeof(env, object, &obj_type));                   \
    RETURN_STATUS_IF_FALSE(env, obj_type == expected_type, expected_error); \
  } while (0)

#define CHECK_TO_OBJECT(env, object, expected_error)               \
  do {                                                             \
    napi_valuetype obj_type = napi_undefined;                      \
    CHECK_NAPI(env->napi_typeof(env, object, &obj_type));          \
    RETURN_STATUS_IF_FALSE(                                        \
        env, obj_type == napi_object || obj_type == napi_function, \
        expected_error);                                           \
  } while (0)

#define CHECK_TO_ARRAYBUFFER(env, arraybuffer, expected_error)               \
  do {                                                                       \
    bool is_arraybuffer = false;                                             \
    CHECK_NAPI(env->napi_is_arraybuffer(env, arraybuffer, &is_arraybuffer)); \
    RETURN_STATUS_IF_FALSE(env, is_arraybuffer, expected_error);             \
  } while (0)

#define CHECK_TO_TYPEARRAY(env, typearray, expected_error)              \
  do {                                                                  \
    bool is_typearray = false;                                          \
    CHECK_NAPI(env->napi_is_typedarray(env, typearray, &is_typearray)); \
    RETURN_STATUS_IF_FALSE(env, is_typearray, expected_error);          \
  } while (0)

#define CHECK_TO_DATAVIEW(env, dataview, expected_error)            \
  do {                                                              \
    bool is_dataview = false;                                       \
    CHECK_NAPI(env->napi_is_dataview(env, dataview, &is_dataview)); \
    RETURN_STATUS_IF_FALSE(env, is_dataview, expected_error);       \
  } while (0)

#define CHECK_TO_ARRAY(env, array, expected_error)         \
  do {                                                     \
    bool is_array = false;                                 \
    CHECK_NAPI(env->napi_is_array(env, array, &is_array)); \
    RETURN_STATUS_IF_FALSE(env, is_array, expected_error); \
  } while (0)

EXTERN_C_START

napi_status napi_get_version_primjs(napi_env env, uint32_t* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_get_version(env, result);
}

napi_status napi_get_undefined_primjs(napi_env env, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_get_undefined(env, result);
}

napi_status napi_get_null_primjs(napi_env env, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_get_null(env, result);
}

napi_status napi_get_global_primjs(napi_env env, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_get_global(env, result);
}

napi_status napi_get_boolean_primjs(napi_env env, bool value,
                                    napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_get_boolean(env, value, result);
}

napi_status napi_create_object_primjs(napi_env env, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_object(env, result);
}

napi_status napi_create_array_primjs(napi_env env, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_array(env, result);
}

napi_status napi_create_array_with_length_primjs(napi_env env, size_t length,
                                                 napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_array_with_length(env, length, result);
}

napi_status napi_create_double_primjs(napi_env env, double value,
                                      napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_double(env, value, result);
}

napi_status napi_create_int32_primjs(napi_env env, int32_t value,
                                     napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_int32(env, value, result);
}

napi_status napi_create_uint32_primjs(napi_env env, uint32_t value,
                                      napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_uint32(env, value, result);
}

napi_status napi_create_int64_primjs(napi_env env, int64_t value,
                                     napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_int64(env, value, result);
}

napi_status napi_create_string_latin1_primjs(napi_env env, const char* str,
                                             size_t length,
                                             napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  RETURN_STATUS_IF_FALSE(env, (length == NAPI_AUTO_LENGTH) || length <= INT_MAX,
                         napi_invalid_arg);
  return env->napi_create_string_latin1(env, str, length, result);
}

napi_status napi_create_string_utf8_primjs(napi_env env, const char* str,
                                           size_t length, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  RETURN_STATUS_IF_FALSE(env, (length == NAPI_AUTO_LENGTH) || length <= INT_MAX,
                         napi_invalid_arg);
  return env->napi_create_string_utf8(env, str, length, result);
}

napi_status napi_create_string_utf16_primjs(napi_env env, const char16_t* str,
                                            size_t length, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  RETURN_STATUS_IF_FALSE(env, (length == NAPI_AUTO_LENGTH) || length <= INT_MAX,
                         napi_invalid_arg);
  return env->napi_create_string_utf16(env, str, length, result);
}

napi_status napi_create_symbol_primjs(napi_env env, napi_value description,
                                      napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_symbol(env, description, result);
}

napi_status napi_create_function_primjs(napi_env env, const char* utf8name,
                                        size_t length, napi_callback cb,
                                        void* data, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  CHECK_ARG(env, cb);
  if (utf8name) {
    RETURN_STATUS_IF_FALSE(env, length == NAPI_AUTO_LENGTH || length <= INT_MAX,
                           napi_invalid_arg);
  }
  return env->napi_create_function(env, utf8name, length, cb, data, result);
}

napi_status napi_create_error_primjs(napi_env env, napi_value code,
                                     napi_value msg, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, msg);
  CHECK_ARG(env, result);
  return env->napi_create_error(env, code, msg, result);
}

napi_status napi_create_type_error_primjs(napi_env env, napi_value code,
                                          napi_value msg, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, msg);
  CHECK_ARG(env, result);
  return env->napi_create_type_error(env, code, msg, result);
}

napi_status napi_create_range_error_primjs(napi_env env, napi_value code,
                                           napi_value msg, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, msg);
  CHECK_ARG(env, result);
  return env->napi_create_range_error(env, code, msg, result);
}

napi_status napi_typeof_primjs(napi_env env, napi_value value,
                               napi_valuetype* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_typeof(env, value, result);
}

napi_status napi_get_value_double_primjs(napi_env env, napi_value value,
                                         double* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  CHECK_TO_TYPE(env, value, napi_number, napi_number_expected);
  return env->napi_get_value_double(env, value, result);
}

napi_status napi_get_value_int32_primjs(napi_env env, napi_value value,
                                        int32_t* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  CHECK_TO_TYPE(env, value, napi_number, napi_number_expected);
  return env->napi_get_value_int32(env, value, result);
}

napi_status napi_get_value_uint32_primjs(napi_env env, napi_value value,
                                         uint32_t* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  CHECK_TO_TYPE(env, value, napi_number, napi_number_expected);
  return env->napi_get_value_uint32(env, value, result);
}

napi_status napi_get_value_int64_primjs(napi_env env, napi_value value,
                                        int64_t* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  CHECK_TO_TYPE(env, value, napi_number, napi_number_expected);
  return env->napi_get_value_int64(env, value, result);
}

napi_status napi_get_value_bool_primjs(napi_env env, napi_value value,
                                       bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  CHECK_TO_TYPE(env, value, napi_boolean, napi_boolean_expected);
  return env->napi_get_value_bool(env, value, result);
}

napi_status napi_get_value_string_latin1_primjs(napi_env env, napi_value value,
                                                char* buf, size_t bufsize,
                                                size_t* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_TO_TYPE(env, value, napi_string, napi_string_expected);
  return env->napi_get_value_string_latin1(env, value, buf, bufsize, result);
}

napi_status napi_get_value_string_utf8_primjs(napi_env env, napi_value value,
                                              char* buf, size_t bufsize,
                                              size_t* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_TO_TYPE(env, value, napi_string, napi_string_expected);
  return env->napi_get_value_string_utf8(env, value, buf, bufsize, result);
}

napi_status napi_get_value_string_utf16_primjs(napi_env env, napi_value value,
                                               char16_t* buf, size_t bufsize,
                                               size_t* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_TO_TYPE(env, value, napi_string, napi_string_expected);
  return env->napi_get_value_string_utf16(env, value, buf, bufsize, result);
}

napi_status napi_coerce_to_bool_primjs(napi_env env, napi_value value,
                                       napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_coerce_to_bool(env, value, result);
}

napi_status napi_coerce_to_number_primjs(napi_env env, napi_value value,
                                         napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_coerce_to_number(env, value, result);
}

napi_status napi_coerce_to_object_primjs(napi_env env, napi_value value,
                                         napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_coerce_to_object(env, value, result);
}

napi_status napi_coerce_to_string_primjs(napi_env env, napi_value value,
                                         napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_coerce_to_string(env, value, result);
}

napi_status napi_get_prototype_primjs(napi_env env, napi_value object,
                                      napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, result);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  return env->napi_get_prototype(env, object, result);
}

napi_status napi_get_property_names_primjs(napi_env env, napi_value object,
                                           napi_value* result) {
  CHECK_ENV(env);
  return env->napi_get_all_property_names(
      env, object, napi_key_include_prototypes,
      static_cast<napi_key_filter>(napi_key_enumerable | napi_key_skip_symbols),
      napi_key_numbers_to_strings, result);
}

napi_status napi_set_property_primjs(napi_env env, napi_value object,
                                     napi_value key, napi_value value) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, key);
  CHECK_ARG(env, value);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  return env->napi_set_property(env, object, key, value);
}

napi_status napi_has_property_primjs(napi_env env, napi_value object,
                                     napi_value key, bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, result);
  CHECK_ARG(env, key);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  return env->napi_has_property(env, object, key, result);
}

napi_status napi_get_property_primjs(napi_env env, napi_value object,
                                     napi_value key, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, key);
  CHECK_ARG(env, result);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  return env->napi_get_property(env, object, key, result);
}

napi_status napi_delete_property_primjs(napi_env env, napi_value object,
                                        napi_value key, bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, key);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  return env->napi_delete_property(env, object, key, result);
}

napi_status napi_has_own_property_primjs(napi_env env, napi_value object,
                                         napi_value key, bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, key);
  CHECK_ARG(env, result);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  napi_valuetype key_type = napi_undefined;
  env->napi_typeof(env, key, &key_type);
  RETURN_STATUS_IF_FALSE(env,
                         key_type == napi_string || key_type == napi_symbol,
                         napi_name_expected);

  return env->napi_has_own_property(env, object, key, result);
}

napi_status napi_set_named_property_primjs(napi_env env, napi_value object,
                                           const char* utf8name,
                                           napi_value value) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, value);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  CHECK_ARG(env, utf8name);
  return env->napi_set_named_property(env, object, utf8name, value);
}

napi_status napi_has_named_property_primjs(napi_env env, napi_value object,
                                           const char* utf8name, bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, result);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  CHECK_ARG(env, utf8name);
  return env->napi_has_named_property(env, object, utf8name, result);
}

napi_status napi_get_named_property_primjs(napi_env env, napi_value object,
                                           const char* utf8name,
                                           napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, result);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  CHECK_ARG(env, utf8name);
  return env->napi_get_named_property(env, object, utf8name, result);
}

napi_status napi_set_element_primjs(napi_env env, napi_value object,
                                    uint32_t index, napi_value value) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, value);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  return env->napi_set_element(env, object, index, value);
}

napi_status napi_has_element_primjs(napi_env env, napi_value object,
                                    uint32_t index, bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, result);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  return env->napi_has_element(env, object, index, result);
}

napi_status napi_get_element_primjs(napi_env env, napi_value object,
                                    uint32_t index, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, result);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  return env->napi_get_element(env, object, index, result);
}

napi_status napi_delete_element_primjs(napi_env env, napi_value object,
                                       uint32_t index, bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  return env->napi_delete_element(env, object, index, result);
}

napi_status napi_define_properties_primjs(
    napi_env env, napi_value object, size_t property_count,
    const napi_property_descriptor* properties) {
  CHECK_ENV(env);
  if (property_count > 0) {
    CHECK_ARG(env, properties);
  }
  CHECK_ARG(env, object);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  return env->napi_define_properties_spec_compliant(env, object, property_count,
                                                    properties);
}

napi_status napi_is_array_primjs(napi_env env, napi_value value, bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_is_array(env, value, result);
}

napi_status napi_get_array_length_primjs(napi_env env, napi_value value,
                                         uint32_t* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_get_array_length(env, value, result);
}

napi_status napi_strict_equals_primjs(napi_env env, napi_value lhs,
                                      napi_value rhs, bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, lhs);
  CHECK_ARG(env, rhs);
  CHECK_ARG(env, result);
  return env->napi_strict_equals(env, lhs, rhs, result);
}

napi_status napi_call_function_primjs(napi_env env, napi_value recv,
                                      napi_value func, size_t argc,
                                      const napi_value* argv,
                                      napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, recv);
  if (argc > 0) {
    CHECK_ARG(env, argv);
  }
  CHECK_ARG(env, func);
  CHECK_TO_TYPE(env, func, napi_function, napi_invalid_arg);
  return env->napi_call_function_spec_compliant(env, recv, func, argc, argv,
                                                result);
}

napi_status napi_new_instance_primjs(napi_env env, napi_value constructor,
                                     size_t argc, const napi_value* argv,
                                     napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, constructor);
  if (argc > 0) {
    CHECK_ARG(env, argv);
  }
  CHECK_ARG(env, result);
  CHECK_TO_TYPE(env, constructor, napi_function, napi_invalid_arg);
  return env->napi_new_instance(env, constructor, argc, argv, result);
}

napi_status napi_instanceof_primjs(napi_env env, napi_value object,
                                   napi_value constructor, bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, object);
  CHECK_ARG(env, result);
  CHECK_TO_OBJECT(env, object, napi_object_expected);
  return env->napi_instanceof(env, object, constructor, result);
}

napi_status napi_get_cb_info_primjs(napi_env env, napi_callback_info cbinfo,
                                    size_t* argc, napi_value* argv,
                                    napi_value* this_arg, void** data) {
  CHECK_ENV(env);
  CHECK_ARG(env, cbinfo);
  return env->napi_get_cb_info(env, cbinfo, argc, argv, this_arg, data);
}

napi_status napi_get_new_target_primjs(napi_env env, napi_callback_info cbinfo,
                                       napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, cbinfo);
  CHECK_ARG(env, result);
  return env->napi_get_new_target(env, cbinfo, result);
}

napi_status napi_define_class_primjs(napi_env env, const char* utf8name,
                                     size_t length, napi_callback constructor,
                                     void* data, size_t property_count,
                                     const napi_property_descriptor* properties,
                                     napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  CHECK_ARG(env, constructor);

  if (property_count > 0) {
    CHECK_ARG(env, properties);
  }
  RETURN_STATUS_IF_FALSE(
      env, utf8name && (length == NAPI_AUTO_LENGTH || length <= INT_MAX),
      napi_invalid_arg);
  napi_class class_result = nullptr;
  napi_status status = env->napi_define_class_spec_compliant(
      env, utf8name, length, constructor, data, property_count, properties,
      nullptr, &class_result);
  if (!class_result) {
    return status;
  }
  if (status != napi_ok) {
    env->napi_release_class(env, class_result);
    return status;
  }
  status = env->napi_class_get_function(env, class_result, result);
  env->napi_release_class(env, class_result);
  return status;
}

napi_status napi_wrap_primjs(napi_env env, napi_value js_object,
                             void* native_object, napi_finalize finalize_cb,
                             void* finalize_hint, napi_ref* result) {
  CHECK_ENV(env);
  return env->napi_wrap_spec_compliant(env, js_object, native_object,
                                       finalize_cb, finalize_hint, result);
}

napi_status napi_unwrap_primjs(napi_env env, napi_value js_object,
                               void** result) {
  CHECK_ENV(env);
  return env->napi_unwrap_spec_compliant(env, js_object, result);
}

napi_status napi_remove_wrap_primjs(napi_env env, napi_value js_object,
                                    void** result) {
  CHECK_ENV(env);
  return env->napi_remove_wrap_spec_compliant(env, js_object, result);
}

napi_status napi_create_external_primjs(napi_env env, void* data,
                                        napi_finalize finalize_cb,
                                        void* finalize_hint,
                                        napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_external(env, data, finalize_cb, finalize_hint,
                                   result);
}

napi_status napi_get_value_external_primjs(napi_env env, napi_value value,
                                           void** result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  CHECK_TO_TYPE(env, value, napi_external, napi_invalid_arg);
  return env->napi_get_value_external(env, value, result);
}

napi_status napi_create_reference_primjs(napi_env env, napi_value value,
                                         uint32_t initial_refcount,
                                         napi_ref* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_create_reference(env, value, initial_refcount, result);
}

napi_status napi_delete_reference_primjs(napi_env env, napi_ref ref) {
  CHECK_ENV(env);
  CHECK_ARG(env, ref);
  return env->napi_delete_reference(env, ref);
}

napi_status napi_reference_ref_primjs(napi_env env, napi_ref ref,
                                      uint32_t* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, ref);
  return env->napi_reference_ref(env, ref, result);
}

napi_status napi_reference_unref_primjs(napi_env env, napi_ref ref,
                                        uint32_t* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, ref);
  return env->napi_reference_unref(env, ref, result);
}

napi_status napi_get_reference_value_primjs(napi_env env, napi_ref ref,
                                            napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, ref);
  CHECK_ARG(env, result);
  return env->napi_get_reference_value(env, ref, result);
}

napi_status napi_open_handle_scope_primjs(napi_env env,
                                          napi_handle_scope* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_open_handle_scope(env, result);
}

napi_status napi_close_handle_scope_primjs(napi_env env,
                                           napi_handle_scope scope) {
  CHECK_ENV(env);
  CHECK_ARG(env, scope);
  return env->napi_close_handle_scope(env, scope);
}

napi_status napi_open_escapable_handle_scope_primjs(
    napi_env env, napi_escapable_handle_scope* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_open_escapable_handle_scope(env, result);
}

napi_status napi_close_escapable_handle_scope_primjs(
    napi_env env, napi_escapable_handle_scope scope) {
  CHECK_ENV(env);
  CHECK_ARG(env, scope);
  return env->napi_close_escapable_handle_scope(env, scope);
}

napi_status napi_escape_handle_primjs(napi_env env,
                                      napi_escapable_handle_scope scope,
                                      napi_value escapee, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, scope);
  CHECK_ARG(env, escapee);
  CHECK_ARG(env, result);
  return env->napi_escape_handle(env, scope, escapee, result);
}

napi_status napi_throw_primjs(napi_env env, napi_value error) {
  CHECK_ENV(env);
  CHECK_ARG(env, error);
  return env->napi_throw_(env, error);
}

napi_status napi_throw_error_primjs(napi_env env, const char* code,
                                    const char* msg) {
  CHECK_ENV(env);
  CHECK_ARG(env, msg);
  return env->napi_throw_error(env, code, msg);
}

napi_status napi_throw_type_error_primjs(napi_env env, const char* code,
                                         const char* msg) {
  CHECK_ENV(env);
  CHECK_ARG(env, msg);
  return env->napi_throw_type_error(env, code, msg);
}

napi_status napi_throw_range_error_primjs(napi_env env, const char* code,
                                          const char* msg) {
  CHECK_ENV(env);
  CHECK_ARG(env, msg);
  return env->napi_throw_range_error(env, code, msg);
}

napi_status napi_is_error_primjs(napi_env env, napi_value value, bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_is_error(env, value, result);
}

napi_status napi_is_exception_pending_primjs(napi_env env, bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_is_exception_pending(env, result);
}

napi_status napi_get_and_clear_last_exception_primjs(napi_env env,
                                                     napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_get_and_clear_last_exception(env, result);
}

napi_status napi_is_arraybuffer_primjs(napi_env env, napi_value value,
                                       bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_is_arraybuffer(env, value, result);
}
napi_status napi_create_arraybuffer_primjs(napi_env env, size_t byte_length,
                                           void** data, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_arraybuffer(env, byte_length, data, result);
}
napi_status napi_create_external_arraybuffer_primjs(
    napi_env env, void* external_data, size_t byte_length,
    napi_finalize finalize_cb, void* finalize_hint, napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_external_arraybuffer(
      env, external_data, byte_length, finalize_cb, finalize_hint, result);
}
napi_status napi_get_arraybuffer_info_primjs(napi_env env,
                                             napi_value arraybuffer,
                                             void** data, size_t* byte_length) {
  CHECK_ENV(env);
  CHECK_ARG(env, arraybuffer);
  CHECK_TO_ARRAYBUFFER(env, arraybuffer, napi_invalid_arg);
  return env->napi_get_arraybuffer_info(env, arraybuffer, data, byte_length);
}

napi_status napi_is_typedarray_primjs(napi_env env, napi_value value,
                                      bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_is_typedarray(env, value, result);
}

napi_status napi_create_typedarray_primjs(napi_env env,
                                          napi_typedarray_type type,
                                          size_t length, napi_value arraybuffer,
                                          size_t byte_offset,
                                          napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, arraybuffer);
  CHECK_ARG(env, result);
  CHECK_TO_ARRAYBUFFER(env, arraybuffer, napi_invalid_arg);
  return env->napi_create_typedarray(env, type, length, arraybuffer,
                                     byte_offset, result);
}

napi_status napi_get_typedarray_info_primjs(napi_env env, napi_value typedarray,
                                            napi_typedarray_type* type,
                                            size_t* length, void** data,
                                            napi_value* arraybuffer,
                                            size_t* byte_offset) {
  CHECK_ENV(env);
  CHECK_TO_TYPEARRAY(env, typedarray, napi_invalid_arg);
  return env->napi_get_typedarray_info(env, typedarray, type, length, data,
                                       arraybuffer, byte_offset);
}

napi_status napi_create_dataview_primjs(napi_env env, size_t length,
                                        napi_value arraybuffer,
                                        size_t byte_offset,
                                        napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, arraybuffer);
  CHECK_ARG(env, result);
  CHECK_TO_ARRAYBUFFER(env, arraybuffer, napi_invalid_arg);
  return env->napi_create_dataview(env, length, arraybuffer, byte_offset,
                                   result);
}

napi_status napi_is_dataview_primjs(napi_env env, napi_value value,
                                    bool* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  return env->napi_is_dataview(env, value, result);
}

napi_status napi_get_dataview_info_primjs(napi_env env, napi_value dataview,
                                          size_t* bytelength, void** data,
                                          napi_value* arraybuffer,
                                          size_t* byte_offset) {
  CHECK_ENV(env);
  CHECK_ARG(env, dataview);
  CHECK_TO_DATAVIEW(env, dataview, napi_invalid_arg);
  return env->napi_get_dataview_info(env, dataview, bytelength, data,
                                     arraybuffer, byte_offset);
}

napi_status napi_create_promise_primjs(napi_env env, napi_deferred* deferred,
                                       napi_value* promise) {
  CHECK_ENV(env);
  CHECK_ARG(env, deferred);
  CHECK_ARG(env, promise);
  return env->napi_create_promise(env, deferred, promise);
}

napi_status napi_is_promise_primjs(napi_env env, napi_value value,
                                   bool* is_promise) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, is_promise);
  return env->napi_is_promise(env, value, is_promise);
}

napi_status napi_resolve_deferred_primjs(napi_env env, napi_deferred deferred,
                                         napi_value resolution) {
  CHECK_ENV(env);
  CHECK_ARG(env, deferred);
  CHECK_ARG(env, resolution);
  return env->napi_release_deferred(env, deferred, resolution,
                                    napi_deferred_resolve);
}

napi_status napi_reject_deferred_primjs(napi_env env, napi_deferred deferred,
                                        napi_value rejection) {
  CHECK_ENV(env);
  CHECK_ARG(env, deferred);
  CHECK_ARG(env, rejection);
  return env->napi_release_deferred(env, deferred, rejection,
                                    napi_deferred_reject);
}

napi_status napi_run_script_primjs(napi_env env, napi_value script,
                                   napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, script);
  CHECK_ARG(env, result);
  CHECK_TO_TYPE(env, script, napi_string, napi_string_expected);

  size_t length = 0;
  CHECK_NAPI(env->napi_get_value_string_utf8(env, script, nullptr, 0, &length));
  std::string script_str(length + 1, 0);
  CHECK_NAPI(env->napi_get_value_string_utf8(env, script, script_str.data(),
                                             length, &length));

  return env->napi_run_script(env, script_str.data(), length, nullptr, result);
}

napi_status napi_adjust_external_memory_primjs(napi_env env,
                                               int64_t change_in_bytes,
                                               int64_t* adjusted_value) {
  CHECK_ENV(env);
  CHECK_ARG(env, adjusted_value);
  return env->napi_adjust_external_memory(env, change_in_bytes, adjusted_value);
}

napi_status napi_add_finalizer_primjs(napi_env env, napi_value js_object,
                                      void* native_object,
                                      napi_finalize finalize_cb,
                                      void* finalize_hint, napi_ref* result) {
  CHECK_ENV(env);
  return env->napi_add_finalizer(env, js_object, native_object, finalize_cb,
                                 finalize_hint, result);
}

static const uint64_t kNapiAdapterInstanceDataKey =
    reinterpret_cast<uint64_t>(&kNapiAdapterInstanceDataKey);
napi_status napi_set_instance_data_primjs(napi_env env, void* data,
                                          napi_finalize finalize_cb,
                                          void* finalize_hint) {
  CHECK_ENV(env);
  return env->napi_set_instance_data_spec_compliant(
      env, kNapiAdapterInstanceDataKey, data, finalize_cb, finalize_hint);
}

napi_status napi_get_instance_data_primjs(napi_env env, void** data) {
  CHECK_ENV(env);
  CHECK_ARG(env, data);
  return env->napi_get_instance_data(env, kNapiAdapterInstanceDataKey, data);
}

napi_status napi_get_last_error_info_primjs(
    napi_env env, const napi_extended_error_info** result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_get_last_error_info(env, result);
}

napi_status napi_add_env_cleanup_hook_primjs(napi_env env,
                                             void (*fun)(void* arg),
                                             void* arg) {
  CHECK_ENV(env);
  CHECK_ARG(env, fun);
  return env->napi_add_env_cleanup_hook(env, fun, arg);
}

napi_status napi_remove_env_cleanup_hook_primjs(napi_env env,
                                                void (*fun)(void* arg),
                                                void* arg) {
  CHECK_ENV(env);
  CHECK_ARG(env, fun);
  return env->napi_remove_env_cleanup_hook(env, fun, arg);
}

napi_status napi_create_async_work_primjs(napi_env env,
                                          napi_value async_resource,
                                          napi_value async_resource_name,
                                          napi_async_execute_callback execute,
                                          napi_async_complete_callback complete,
                                          void* data, napi_async_work* result) {
  return env->napi_create_async_work(env, async_resource, async_resource_name,
                                     execute, complete, data, result);
}

napi_status napi_delete_async_work_primjs(napi_env env, napi_async_work work) {
  return env->napi_delete_async_work(env, work);
}

napi_status napi_queue_async_work_primjs(napi_env env, napi_async_work work) {
  return env->napi_queue_async_work(env, work);
}

napi_status napi_cancel_async_work_primjs(napi_env env, napi_async_work work) {
  return env->napi_cancel_async_work(env, work);
}

void napi_fatal_error_primjs(const char* location, size_t location_len,
                             const char* message, size_t message_len) {
  if (location && location_len > 0) {
    int print_len =
        (location_len > INT_MAX) ? INT_MAX : static_cast<int>(location_len);
    std::fprintf(stderr, "Fatal error location: %.*s\n", print_len, location);
  }

  if (message && message_len > 0) {
    int message_print_len =
        (message_len > INT_MAX) ? INT_MAX : static_cast<int>(message_len);
    std::fprintf(stderr, "Fatal error message: %.*s\n", message_print_len,
                 message);
  }

  std::abort();
}

class ThreadSafeFunctionAdaptor {
 public:
  ThreadSafeFunctionAdaptor(
      napi_env env, napi_value func, void* thread_finalize_data,
      napi_finalize thread_finalize_cb, void* context,
      napi_threadsafe_function_call_js_spec_compl call_js_cb)
      : env_(env),
        thread_finalize_data_(thread_finalize_data),
        thread_finalize_cb_(thread_finalize_cb),
        context_(context),
        call_js_cb_(call_js_cb) {
    if (func) {
      napi_create_reference_primjs(env, func, 1, &func_ref_);
    }
  }
  ~ThreadSafeFunctionAdaptor() {
    if (thread_finalize_cb_) {
      thread_finalize_cb_(env_, thread_finalize_data_, context_);
    }
    if (func_ref_) {
      napi_delete_reference_primjs(env_, func_ref_);
    }
  }

  void* Context() { return context_; }

  static void Call(napi_env env, void* context, void* data) {
    ThreadSafeFunctionAdaptor* adaptor =
        static_cast<ThreadSafeFunctionAdaptor*>(context);
    napi_value func{nullptr};
    if (adaptor->func_ref_) {
      napi_get_reference_value_primjs(env, adaptor->func_ref_, &func);
    }
    if (adaptor->call_js_cb_) {
      adaptor->call_js_cb_(env, func, adaptor->context_, data);
    } else {
      napi_value recv;
      napi_status status;

      status = napi_get_undefined_primjs(env, &recv);
      if (status != napi_ok) {
        napi_throw_error_primjs(env, "ERR_NAPI_TSFN_GET_UNDEFINED",
                                "Failed to retrieve undefined value");
        return;
      }

      status = napi_call_function_primjs(env, recv, func, 0, nullptr, nullptr);
      if (status != napi_ok && status != napi_pending_exception) {
        napi_throw_error_primjs(env, "ERR_NAPI_TSFN_CALL_JS",
                                "Failed to call JS callback");
        return;
      }
    }
  }

  static void Finalize(napi_env env, void* finalize_data, void* finalize_hint) {
    ThreadSafeFunctionAdaptor* adaptor =
        static_cast<ThreadSafeFunctionAdaptor*>(finalize_data);
    delete adaptor;
  }

 private:
  napi_env env_{nullptr};
  napi_ref func_ref_{nullptr};
  void* thread_finalize_data_{nullptr};
  napi_finalize thread_finalize_cb_{nullptr};
  void* context_{nullptr};
  napi_threadsafe_function_call_js_spec_compl call_js_cb_{nullptr};
};

napi_status napi_create_threadsafe_function_primjs(
    napi_env env, napi_value func, napi_value async_resource,
    napi_value async_resource_name, size_t max_queue_size,
    size_t initial_thread_count, void* thread_finalize_data,
    napi_finalize thread_finalize_cb, void* context,
    napi_threadsafe_function_call_js_spec_compl call_js_cb,
    napi_threadsafe_function* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  if (func == nullptr) {
    CHECK_ARG(env, call_js_cb);
  } else {
    CHECK_TO_TYPE(env, func, napi_function, napi_invalid_arg);
  }

  ThreadSafeFunctionAdaptor* adaptor = new ThreadSafeFunctionAdaptor(
      env, func, thread_finalize_data, thread_finalize_cb, context, call_js_cb);
  return env->napi_create_threadsafe_function_spec_compliant(
      env, adaptor, ThreadSafeFunctionAdaptor::Finalize, adaptor,
      ThreadSafeFunctionAdaptor::Call, max_queue_size, initial_thread_count,
      result);
}

napi_status napi_call_threadsafe_function_primjs(
    napi_threadsafe_function func, void* data,
    napi_threadsafe_function_call_mode is_blocking) {
  if (func == nullptr) {
    return napi_invalid_arg;
  }

  return napi_runtime_call_threadsafe_function(func, data, is_blocking);
}

napi_status napi_release_threadsafe_function_primjs(
    napi_threadsafe_function func, napi_threadsafe_function_release_mode mode) {
  if (func == nullptr) {
    return napi_invalid_arg;
  }

  return napi_runtime_release_threadsafe_function(func, mode);
}

napi_status napi_acquire_threadsafe_function_primjs(
    napi_threadsafe_function func) {
  if (func == nullptr) {
    return napi_invalid_arg;
  }

  return napi_runtime_acquire_threadsafe_function(func);
}

napi_status napi_get_threadsafe_function_context_primjs(
    napi_threadsafe_function func, void** result) {
  if (func == nullptr) {
    return napi_invalid_arg;
  }

  void* context = nullptr;
  napi_runtime_get_threadsafe_function_context(func, &context);
  if (context == nullptr) {
    return napi_invalid_arg;
  }
  ThreadSafeFunctionAdaptor* adaptor =
      static_cast<ThreadSafeFunctionAdaptor*>(context);
  *result = adaptor->Context();
  return napi_ok;
}

napi_status napi_unref_threadsafe_function_primjs(
    napi_env env, napi_threadsafe_function func) {
  return napi_ok;
}
napi_status napi_ref_threadsafe_function_primjs(napi_env env,
                                                napi_threadsafe_function func) {
  return napi_ok;
}

napi_status napi_create_date_primjs(napi_env env, double time,
                                    napi_value* result) {
  CHECK_ENV(env);
  return env->napi_create_date(env, time, result);
}

napi_status napi_is_date_primjs(napi_env env, napi_value value, bool* is_date) {
  CHECK_ENV(env);
  return env->napi_is_date(env, value, is_date);
}

napi_status napi_get_date_value_primjs(napi_env env, napi_value value,
                                       double* result) {
  CHECK_ENV(env);
  return env->napi_get_date_value(env, value, result);
}

napi_status napi_get_all_property_names_primjs(
    napi_env env, napi_value object, napi_key_collection_mode key_mode,
    napi_key_filter key_filter, napi_key_conversion key_conversion,
    napi_value* result) {
  CHECK_ENV(env);
  return env->napi_get_all_property_names(env, object, key_mode, key_filter,
                                          key_conversion, result);
}

void napi_module_register_primjs(napi_module_spec_compl* mod) {
  // Since napi_module_register_xx does not copy the contents of `napi_module`,
  // it only stores its pointer. To align with the NAPI standard, we copy the
  // contents of the napi module here. As napi module registration is global and
  // its lifetime follows that of the process, the newly created napi module
  // object here does not need to be explicitly freed.
  napi_module* internal_mod = new napi_module{
      .nm_version = mod->nm_version,
      .nm_filename = mod->nm_filename,
      .nm_register_func = mod->nm_register_func,
      .nm_modname = mod->nm_modname,
      .nm_link = nullptr,
  };

  napi_module_register_xx(internal_mod);
}

napi_module_spec_compl* napi_find_module_primjs(const char* name) {
  const napi_module* mod = napi_find_module(name);
  if (!mod) {
    return nullptr;
  }
  // The user is responsible for freeing the memory of this object
  return new napi_module_spec_compl{
      .nm_version = mod->nm_version,
      // The 'flags' field is lost when converting napi_module_spec_compl to
      // napi_module, so its value cannot be obtained here.
      .nm_flags = 0,
      .nm_filename = mod->nm_filename,
      .nm_register_func = mod->nm_register_func,
      .nm_modname = mod->nm_modname,
      .nm_link = nullptr,
  };
}

napi_status napi_create_bigint_int64_primjs(napi_env env, int64_t value,
                                            napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_bigint_int64(env, value, result);
}
napi_status napi_create_bigint_uint64_primjs(napi_env env, uint64_t value,
                                             napi_value* result) {
  CHECK_ENV(env);
  CHECK_ARG(env, result);
  return env->napi_create_bigint_uint64(env, value, result);
}

napi_status napi_create_bigint_words_primjs(napi_env env, int sign_bit,
                                            size_t word_count,
                                            const uint64_t* words,
                                            napi_value* result) {
  CHECK_ENV(env);
  return env->napi_create_bigint_words(env, sign_bit, word_count, words,
                                       result);
}
napi_status napi_get_value_bigint_int64_primjs(napi_env env, napi_value value,
                                               int64_t* result,
                                               bool* lossless) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  CHECK_ARG(env, lossless);
  CHECK_TO_TYPE(env, value, napi_bigint, napi_bigint_expected);
  return env->napi_get_value_bigint_int64(env, value, result, lossless);
}
napi_status napi_get_value_bigint_uint64_primjs(napi_env env, napi_value value,
                                                uint64_t* result,
                                                bool* lossless) {
  CHECK_ENV(env);
  CHECK_ARG(env, value);
  CHECK_ARG(env, result);
  CHECK_ARG(env, lossless);
  CHECK_TO_TYPE(env, value, napi_bigint, napi_bigint_expected);
  return env->napi_get_value_bigint_uint64(env, value, result, lossless);
}
napi_status napi_get_value_bigint_words_primjs(napi_env env, napi_value value,
                                               int* sign_bit,
                                               size_t* word_count,
                                               uint64_t* words) {
  CHECK_ENV(env);
  return env->napi_get_value_bigint_words(env, value, sign_bit, word_count,
                                          words);
}

EXTERN_C_END
