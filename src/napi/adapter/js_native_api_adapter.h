/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */

// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_NAPI_JS_NATIVE_API_ADAPTER_H_
#define SRC_NAPI_JS_NATIVE_API_ADAPTER_H_

#include "js_native_api.h"
#include "napi_module.h"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

// This adaptor converts the primjs NAPI interface into a standard NAPI
// interface, facilitating the integration of external libraries.

EXTERN_C_START

typedef void (*napi_threadsafe_function_call_js_original)(
    napi_env env, napi_value js_callback, void* context, void* data);

NAPI_EXTERN napi_status napi_get_version(napi_env env, uint32_t* result);

// ENGINE CALL
// Getters for defined singletons
NAPI_EXTERN napi_status napi_get_undefined(napi_env env, napi_value* result);
NAPI_EXTERN napi_status napi_get_null(napi_env env, napi_value* result);
NAPI_EXTERN napi_status napi_get_global(napi_env env, napi_value* result);
NAPI_EXTERN napi_status napi_get_boolean(napi_env env, bool value,
                                         napi_value* result);

// Primitive types/Objects
NAPI_EXTERN napi_status napi_create_object(napi_env env, napi_value* result);
NAPI_EXTERN napi_status napi_create_array(napi_env env, napi_value* result);
NAPI_EXTERN napi_status napi_create_array_with_length(napi_env env,
                                                      size_t length,
                                                      napi_value* result);
NAPI_EXTERN napi_status napi_create_double(napi_env env, double value,
                                           napi_value* result);
NAPI_EXTERN napi_status napi_create_int32(napi_env env, int32_t value,
                                          napi_value* result);
NAPI_EXTERN napi_status napi_create_uint32(napi_env env, uint32_t value,
                                           napi_value* result);
NAPI_EXTERN napi_status napi_create_int64(napi_env env, int64_t value,
                                          napi_value* result);
NAPI_EXTERN napi_status napi_create_string_latin1(napi_env env, const char* str,
                                                  size_t length,
                                                  napi_value* result);
NAPI_EXTERN napi_status napi_create_string_utf8(napi_env env, const char* str,
                                                size_t length,
                                                napi_value* result);
NAPI_EXTERN napi_status napi_create_string_utf16(napi_env env,
                                                 const char16_t* str,
                                                 size_t length,
                                                 napi_value* result);
NAPI_EXTERN napi_status napi_create_symbol(napi_env env, napi_value description,
                                           napi_value* result);
NAPI_EXTERN napi_status napi_create_function(napi_env env, const char* utf8name,
                                             size_t length, napi_callback cb,
                                             void* data, napi_value* result);
NAPI_EXTERN napi_status napi_create_error(napi_env env, napi_value code,
                                          napi_value msg, napi_value* result);
NAPI_EXTERN napi_status napi_create_type_error(napi_env env, napi_value code,
                                               napi_value msg,
                                               napi_value* result);
NAPI_EXTERN napi_status napi_create_range_error(napi_env env, napi_value code,
                                                napi_value msg,
                                                napi_value* result);

NAPI_EXTERN napi_status napi_adjust_external_memory(napi_env env,
                                                    int64_t change_in_bytes,
                                                    int64_t* adjusted_value);

// Value type operations
NAPI_EXTERN napi_status napi_typeof(napi_env env, napi_value value,
                                    napi_valuetype* result);
NAPI_EXTERN napi_status napi_get_value_double(napi_env env, napi_value value,
                                              double* result);
NAPI_EXTERN napi_status napi_get_value_int32(napi_env env, napi_value value,
                                             int32_t* result);
NAPI_EXTERN napi_status napi_get_value_uint32(napi_env env, napi_value value,
                                              uint32_t* result);
NAPI_EXTERN napi_status napi_get_value_int64(napi_env env, napi_value value,
                                             int64_t* result);
NAPI_EXTERN napi_status napi_get_value_bool(napi_env env, napi_value value,
                                            bool* result);

// String operations
NAPI_EXTERN napi_status napi_get_value_string_latin1(napi_env env,
                                                     napi_value value,
                                                     char* buf, size_t bufsize,
                                                     size_t* result);
NAPI_EXTERN napi_status napi_get_value_string_utf8(napi_env env,
                                                   napi_value value, char* buf,
                                                   size_t bufsize,
                                                   size_t* result);
NAPI_EXTERN napi_status napi_get_value_string_utf16(napi_env env,
                                                    napi_value value,
                                                    char16_t* buf,
                                                    size_t bufsize,
                                                    size_t* result);

// Coercion methods
NAPI_EXTERN napi_status napi_coerce_to_bool(napi_env env, napi_value value,
                                            napi_value* result);
NAPI_EXTERN napi_status napi_coerce_to_number(napi_env env, napi_value value,
                                              napi_value* result);
NAPI_EXTERN napi_status napi_coerce_to_object(napi_env env, napi_value value,
                                              napi_value* result);
NAPI_EXTERN napi_status napi_coerce_to_string(napi_env env, napi_value value,
                                              napi_value* result);

// Object operations
NAPI_EXTERN napi_status napi_get_prototype(napi_env env, napi_value object,
                                           napi_value* result);
NAPI_EXTERN napi_status napi_get_property_names(napi_env env, napi_value object,
                                                napi_value* result);
NAPI_EXTERN napi_status napi_set_property(napi_env env, napi_value object,
                                          napi_value key, napi_value value);
NAPI_EXTERN napi_status napi_has_property(napi_env env, napi_value object,
                                          napi_value key, bool* result);
NAPI_EXTERN napi_status napi_get_property(napi_env env, napi_value object,
                                          napi_value key, napi_value* result);
NAPI_EXTERN napi_status napi_delete_property(napi_env env, napi_value object,
                                             napi_value key, bool* result);
NAPI_EXTERN napi_status napi_has_own_property(napi_env env, napi_value object,
                                              napi_value key, bool* result);
NAPI_EXTERN napi_status napi_set_named_property(napi_env env, napi_value object,
                                                const char* utf8name,
                                                napi_value value);
NAPI_EXTERN napi_status napi_has_named_property(napi_env env, napi_value object,
                                                const char* utf8name,
                                                bool* result);
NAPI_EXTERN napi_status napi_get_named_property(napi_env env, napi_value object,
                                                const char* utf8name,
                                                napi_value* result);
NAPI_EXTERN napi_status napi_set_element(napi_env env, napi_value object,
                                         uint32_t index, napi_value value);
NAPI_EXTERN napi_status napi_has_element(napi_env env, napi_value object,
                                         uint32_t index, bool* result);
NAPI_EXTERN napi_status napi_get_element(napi_env env, napi_value object,
                                         uint32_t index, napi_value* result);
NAPI_EXTERN napi_status napi_delete_element(napi_env env, napi_value object,
                                            uint32_t index, bool* result);
NAPI_EXTERN napi_status
napi_define_properties(napi_env env, napi_value object, size_t property_count,
                       const napi_property_descriptor* properties);

// Array APIs
NAPI_EXTERN napi_status napi_is_array(napi_env env, napi_value value,
                                      bool* result);
NAPI_EXTERN napi_status napi_get_array_length(napi_env env, napi_value value,
                                              uint32_t* result);

// Value comparison
NAPI_EXTERN napi_status napi_strict_equals(napi_env env, napi_value lhs,
                                           napi_value rhs, bool* result);

// Function APIs
NAPI_EXTERN napi_status napi_call_function(napi_env env, napi_value recv,
                                           napi_value func, size_t argc,
                                           const napi_value* argv,
                                           napi_value* result);
NAPI_EXTERN napi_status napi_new_instance(napi_env env, napi_value constructor,
                                          size_t argc, const napi_value* argv,
                                          napi_value* result);
NAPI_EXTERN napi_status napi_instanceof(napi_env env, napi_value object,
                                        napi_value constructor, bool* result);

// Callback info
NAPI_EXTERN napi_status napi_get_cb_info(napi_env env,
                                         napi_callback_info cbinfo,
                                         size_t* argc, napi_value* argv,
                                         napi_value* this_arg, void** data);
NAPI_EXTERN napi_status napi_get_new_target(napi_env env,
                                            napi_callback_info cbinfo,
                                            napi_value* result);

// Class APIs
NAPI_EXTERN napi_status napi_define_class(
    napi_env env, const char* utf8name, size_t length,
    napi_callback constructor, void* data, size_t property_count,
    const napi_property_descriptor* properties, napi_value* result);

// Wrapping APIs
NAPI_EXTERN napi_status napi_wrap(napi_env env, napi_value js_object,
                                  void* native_object,
                                  napi_finalize finalize_cb,
                                  void* finalize_hint, napi_ref* result);
NAPI_EXTERN napi_status napi_unwrap(napi_env env, napi_value js_object,
                                    void** result);
NAPI_EXTERN napi_status napi_remove_wrap(napi_env env, napi_value js_object,
                                         void** result);

// External object APIs
NAPI_EXTERN napi_status napi_create_external(napi_env env, void* data,
                                             napi_finalize finalize_cb,
                                             void* finalize_hint,
                                             napi_value* result);
NAPI_EXTERN napi_status napi_get_value_external(napi_env env, napi_value value,
                                                void** result);

// Reference APIs
NAPI_EXTERN napi_status napi_create_reference(napi_env env, napi_value value,
                                              uint32_t initial_refcount,
                                              napi_ref* result);
NAPI_EXTERN napi_status napi_delete_reference(napi_env env, napi_ref ref);
NAPI_EXTERN napi_status napi_reference_ref(napi_env env, napi_ref ref,
                                           uint32_t* result);
NAPI_EXTERN napi_status napi_reference_unref(napi_env env, napi_ref ref,
                                             uint32_t* result);
NAPI_EXTERN napi_status napi_get_reference_value(napi_env env, napi_ref ref,
                                                 napi_value* result);

// Handle scope APIs
NAPI_EXTERN napi_status napi_open_handle_scope(napi_env env,
                                               napi_handle_scope* result);
NAPI_EXTERN napi_status napi_close_handle_scope(napi_env env,
                                                napi_handle_scope scope);
NAPI_EXTERN napi_status napi_open_escapable_handle_scope(
    napi_env env, napi_escapable_handle_scope* result);
NAPI_EXTERN napi_status napi_close_escapable_handle_scope(
    napi_env env, napi_escapable_handle_scope scope);
NAPI_EXTERN napi_status napi_escape_handle(napi_env env,
                                           napi_escapable_handle_scope scope,
                                           napi_value escapee,
                                           napi_value* result);

// Error handling
NAPI_EXTERN napi_status napi_throw(napi_env env, napi_value error);
NAPI_EXTERN napi_status napi_throw_error(napi_env env, const char* code,
                                         const char* msg);
NAPI_EXTERN napi_status napi_throw_type_error(napi_env env, const char* code,
                                              const char* msg);
NAPI_EXTERN napi_status napi_throw_range_error(napi_env env, const char* code,
                                               const char* msg);
NAPI_EXTERN napi_status napi_is_error(napi_env env, napi_value value,
                                      bool* result);

// Exception handling
NAPI_EXTERN napi_status napi_is_exception_pending(napi_env env, bool* result);
NAPI_EXTERN napi_status napi_get_and_clear_last_exception(napi_env env,
                                                          napi_value* result);

NAPI_EXTERN napi_status napi_is_arraybuffer(napi_env env, napi_value value,
                                            bool* result);
NAPI_EXTERN napi_status napi_create_arraybuffer(napi_env env,
                                                size_t byte_length, void** data,
                                                napi_value* result);
NAPI_EXTERN napi_status napi_create_external_arraybuffer(
    napi_env env, void* external_data, size_t byte_length,
    napi_finalize finalize_cb, void* finalize_hint, napi_value* result);
NAPI_EXTERN napi_status napi_get_arraybuffer_info(napi_env env,
                                                  napi_value arraybuffer,
                                                  void** data,
                                                  size_t* byte_length);

// TypedArray APIs
NAPI_EXTERN napi_status napi_is_typedarray(napi_env env, napi_value value,
                                           bool* result);
NAPI_EXTERN napi_status napi_create_typedarray(
    napi_env env, napi_typedarray_type type, size_t length,
    napi_value arraybuffer, size_t byte_offset, napi_value* result);

NAPI_EXTERN napi_status napi_get_typedarray_info(
    napi_env env, napi_value typedarray, napi_typedarray_type* type,
    size_t* length, void** data, napi_value* arraybuffer, size_t* byte_offset);

// DataView APIs
NAPI_EXTERN napi_status napi_create_dataview(napi_env env, size_t length,
                                             napi_value arraybuffer,
                                             size_t byte_offset,
                                             napi_value* result);
NAPI_EXTERN napi_status napi_is_dataview(napi_env env, napi_value value,
                                         bool* result);
NAPI_EXTERN napi_status napi_get_dataview_info(napi_env env,
                                               napi_value dataview,
                                               size_t* bytelength, void** data,
                                               napi_value* arraybuffer,
                                               size_t* byte_offset);

// Promise APIs
NAPI_EXTERN napi_status napi_create_promise(napi_env env,
                                            napi_deferred* deferred,
                                            napi_value* promise);
NAPI_EXTERN napi_status napi_release_deferred(napi_env env,
                                              napi_deferred deferred,
                                              napi_value resolution,
                                              napi_deferred_release_mode mode);
NAPI_EXTERN napi_status napi_is_promise(napi_env env, napi_value value,
                                        bool* is_promise);

// Script execution
NAPI_EXTERN napi_status napi_run_script(napi_env env, const char* script,
                                        size_t length, const char* filename,
                                        napi_value* result);

// Finalizer APIs
NAPI_EXTERN napi_status napi_add_finalizer(napi_env env, napi_value js_object,
                                           void* native_object,
                                           napi_finalize finalize_cb,
                                           void* finalize_hint,
                                           napi_ref* result);

// Instance data
NAPI_EXTERN napi_status napi_set_instance_data(napi_env env, uint64_t key,
                                               void* data,
                                               napi_finalize finalize_cb,
                                               void* finalize_hint);
NAPI_EXTERN napi_status napi_get_instance_data(napi_env env, uint64_t key,
                                               void** data);

// Error information
NAPI_EXTERN napi_status
napi_get_last_error_info(napi_env env, const napi_extended_error_info** result);

// Environment lifecycle
NAPI_EXTERN napi_status napi_add_env_cleanup_hook(napi_env env,
                                                  void (*fun)(void* arg),
                                                  void* arg);
NAPI_EXTERN napi_status napi_remove_env_cleanup_hook(napi_env env,
                                                     void (*fun)(void* arg),
                                                     void* arg);

// Thread-safe function APIs
NAPI_EXTERN napi_status napi_create_threadsafe_function(
    napi_env env, napi_value func, napi_value async_resource,
    napi_value async_resource_name, size_t max_queue_size,
    size_t initial_thread_count, void* thread_finalize_data,
    napi_finalize thread_finalize_cb, void* context,
    napi_threadsafe_function_call_js_original call_js_cb,
    napi_threadsafe_function* result);

NAPI_EXTERN napi_status
napi_call_threadsafe_function(napi_threadsafe_function func, void* data,
                              napi_threadsafe_function_call_mode is_blocking);
NAPI_EXTERN napi_status
napi_release_threadsafe_function(napi_threadsafe_function func);

NAPI_EXTERN napi_status napi_get_threadsafe_function_context(
    napi_threadsafe_function func, void** result);

NAPI_EXTERN void napi_fatal_error(const char* location, size_t location_len,
                                  const char* message, size_t message_len);

NAPI_EXTERN void napi_module_register(napi_module* mod);

// Unimplemented API

// NAPI_VERSION 1
NAPI_EXTERN napi_status napi_resolve_deferred(napi_env env,
                                              napi_deferred deferred,
                                              napi_value resolution);
NAPI_EXTERN napi_status napi_reject_deferred(napi_env env,
                                             napi_deferred deferred,
                                             napi_value rejection);

// NAPI VERSION 3
NAPI_EXTERN napi_status napi_fatal_exception(napi_env env, napi_value err);
// napi_open_callback_scope
// napi_close_callback_scope

/// NAPI VERSION 4
NAPI_EXTERN napi_status
napi_unref_threadsafe_function(napi_env env, napi_threadsafe_function func);
NAPI_EXTERN napi_status
napi_ref_threadsafe_function(napi_env env, napi_threadsafe_function func);
NAPI_EXTERN napi_status
napi_acquire_threadsafe_function(napi_threadsafe_function func);

// NAPI VERSION 5
NAPI_EXTERN napi_status napi_create_date(napi_env env, double time,
                                         napi_value* result);

NAPI_EXTERN napi_status napi_is_date(napi_env env, napi_value value,
                                     bool* is_date);

NAPI_EXTERN napi_status napi_get_date_value(napi_env env, napi_value value,
                                            double* result);

// NAPI VERSION 6
NAPI_EXTERN napi_status napi_create_bigint_int64(napi_env env, int64_t value,
                                                 napi_value* result);
NAPI_EXTERN napi_status napi_create_bigint_uint64(napi_env env, uint64_t value,
                                                  napi_value* result);
NAPI_EXTERN napi_status napi_create_bigint_words(napi_env env, int sign_bit,
                                                 size_t word_count,
                                                 const uint64_t* words,
                                                 napi_value* result);
NAPI_EXTERN napi_status napi_get_value_bigint_int64(napi_env env,
                                                    napi_value value,
                                                    int64_t* result,
                                                    bool* lossless);
NAPI_EXTERN napi_status napi_get_value_bigint_uint64(napi_env env,
                                                     napi_value value,
                                                     uint64_t* result,
                                                     bool* lossless);
NAPI_EXTERN napi_status napi_get_value_bigint_words(napi_env env,
                                                    napi_value value,
                                                    int* sign_bit,
                                                    size_t* word_count,
                                                    uint64_t* words);

NAPI_EXTERN napi_status napi_get_all_property_names(
    napi_env env, napi_value object, napi_key_collection_mode key_mode,
    napi_key_filter key_filter, napi_key_conversion key_conversion,
    napi_value* result);

EXTERN_C_END

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif

#endif  // SRC_NAPI_JS_NATIVE_API_ADAPTER_H_
