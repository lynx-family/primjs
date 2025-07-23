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

NAPI_EXTERN napi_status napi_get_version_primjs(napi_env env, uint32_t* result);

// ENGINE CALL
// Getters for defined singletons
NAPI_EXTERN napi_status napi_get_undefined_primjs(napi_env env,
                                                  napi_value* result);
NAPI_EXTERN napi_status napi_get_null_primjs(napi_env env, napi_value* result);
NAPI_EXTERN napi_status napi_get_global_primjs(napi_env env,
                                               napi_value* result);
NAPI_EXTERN napi_status napi_get_boolean_primjs(napi_env env, bool value,
                                                napi_value* result);

// Primitive types/Objects
NAPI_EXTERN napi_status napi_create_object_primjs(napi_env env,
                                                  napi_value* result);
NAPI_EXTERN napi_status napi_create_array_primjs(napi_env env,
                                                 napi_value* result);
NAPI_EXTERN napi_status napi_create_array_with_length_primjs(
    napi_env env, size_t length, napi_value* result);
NAPI_EXTERN napi_status napi_create_double_primjs(napi_env env, double value,
                                                  napi_value* result);
NAPI_EXTERN napi_status napi_create_int32_primjs(napi_env env, int32_t value,
                                                 napi_value* result);
NAPI_EXTERN napi_status napi_create_uint32_primjs(napi_env env, uint32_t value,
                                                  napi_value* result);
NAPI_EXTERN napi_status napi_create_int64_primjs(napi_env env, int64_t value,
                                                 napi_value* result);
NAPI_EXTERN napi_status napi_create_string_latin1_primjs(napi_env env,
                                                         const char* str,
                                                         size_t length,
                                                         napi_value* result);
NAPI_EXTERN napi_status napi_create_string_utf8_primjs(napi_env env,
                                                       const char* str,
                                                       size_t length,
                                                       napi_value* result);
NAPI_EXTERN napi_status napi_create_string_utf16_primjs(napi_env env,
                                                        const char16_t* str,
                                                        size_t length,
                                                        napi_value* result);
NAPI_EXTERN napi_status napi_create_symbol_primjs(napi_env env,
                                                  napi_value description,
                                                  napi_value* result);
NAPI_EXTERN napi_status
napi_create_function_primjs(napi_env env, const char* utf8name, size_t length,
                            napi_callback cb, void* data, napi_value* result);
NAPI_EXTERN napi_status napi_create_error_primjs(napi_env env, napi_value code,
                                                 napi_value msg,
                                                 napi_value* result);
NAPI_EXTERN napi_status napi_create_type_error_primjs(napi_env env,
                                                      napi_value code,
                                                      napi_value msg,
                                                      napi_value* result);
NAPI_EXTERN napi_status napi_create_range_error_primjs(napi_env env,
                                                       napi_value code,
                                                       napi_value msg,
                                                       napi_value* result);

// Value type operations
NAPI_EXTERN napi_status napi_typeof_primjs(napi_env env, napi_value value,
                                           napi_valuetype* result);
NAPI_EXTERN napi_status napi_get_value_double_primjs(napi_env env,
                                                     napi_value value,
                                                     double* result);
NAPI_EXTERN napi_status napi_get_value_int32_primjs(napi_env env,
                                                    napi_value value,
                                                    int32_t* result);
NAPI_EXTERN napi_status napi_get_value_uint32_primjs(napi_env env,
                                                     napi_value value,
                                                     uint32_t* result);
NAPI_EXTERN napi_status napi_get_value_int64_primjs(napi_env env,
                                                    napi_value value,
                                                    int64_t* result);
NAPI_EXTERN napi_status napi_get_value_bool_primjs(napi_env env,
                                                   napi_value value,
                                                   bool* result);

// String operations
NAPI_EXTERN napi_status napi_get_value_string_latin1_primjs(
    napi_env env, napi_value value, char* buf, size_t bufsize, size_t* result);
NAPI_EXTERN napi_status napi_get_value_string_utf8_primjs(
    napi_env env, napi_value value, char* buf, size_t bufsize, size_t* result);
NAPI_EXTERN napi_status napi_get_value_string_utf16_primjs(napi_env env,
                                                           napi_value value,
                                                           char16_t* buf,
                                                           size_t bufsize,
                                                           size_t* result);

// Coercion methods
NAPI_EXTERN napi_status napi_coerce_to_bool_primjs(napi_env env,
                                                   napi_value value,
                                                   napi_value* result);
NAPI_EXTERN napi_status napi_coerce_to_number_primjs(napi_env env,
                                                     napi_value value,
                                                     napi_value* result);
NAPI_EXTERN napi_status napi_coerce_to_object_primjs(napi_env env,
                                                     napi_value value,
                                                     napi_value* result);
NAPI_EXTERN napi_status napi_coerce_to_string_primjs(napi_env env,
                                                     napi_value value,
                                                     napi_value* result);

// Object operations
NAPI_EXTERN napi_status napi_get_prototype_primjs(napi_env env,
                                                  napi_value object,
                                                  napi_value* result);
NAPI_EXTERN napi_status napi_get_property_names_primjs(napi_env env,
                                                       napi_value object,
                                                       napi_value* result);
NAPI_EXTERN napi_status napi_set_property_primjs(napi_env env,
                                                 napi_value object,
                                                 napi_value key,
                                                 napi_value value);
NAPI_EXTERN napi_status napi_has_property_primjs(napi_env env,
                                                 napi_value object,
                                                 napi_value key, bool* result);
NAPI_EXTERN napi_status napi_get_property_primjs(napi_env env,
                                                 napi_value object,
                                                 napi_value key,
                                                 napi_value* result);
NAPI_EXTERN napi_status napi_delete_property_primjs(napi_env env,
                                                    napi_value object,
                                                    napi_value key,
                                                    bool* result);
NAPI_EXTERN napi_status napi_has_own_property_primjs(napi_env env,
                                                     napi_value object,
                                                     napi_value key,
                                                     bool* result);
NAPI_EXTERN napi_status napi_set_named_property_primjs(napi_env env,
                                                       napi_value object,
                                                       const char* utf8name,
                                                       napi_value value);
NAPI_EXTERN napi_status napi_has_named_property_primjs(napi_env env,
                                                       napi_value object,
                                                       const char* utf8name,
                                                       bool* result);
NAPI_EXTERN napi_status napi_get_named_property_primjs(napi_env env,
                                                       napi_value object,
                                                       const char* utf8name,
                                                       napi_value* result);
NAPI_EXTERN napi_status napi_set_element_primjs(napi_env env, napi_value object,
                                                uint32_t index,
                                                napi_value value);
NAPI_EXTERN napi_status napi_has_element_primjs(napi_env env, napi_value object,
                                                uint32_t index, bool* result);
NAPI_EXTERN napi_status napi_get_element_primjs(napi_env env, napi_value object,
                                                uint32_t index,
                                                napi_value* result);
NAPI_EXTERN napi_status napi_delete_element_primjs(napi_env env,
                                                   napi_value object,
                                                   uint32_t index,
                                                   bool* result);
NAPI_EXTERN napi_status napi_define_properties_primjs(
    napi_env env, napi_value object, size_t property_count,
    const napi_property_descriptor* properties);

// Array APIs
NAPI_EXTERN napi_status napi_is_array_primjs(napi_env env, napi_value value,
                                             bool* result);
NAPI_EXTERN napi_status napi_get_array_length_primjs(napi_env env,
                                                     napi_value value,
                                                     uint32_t* result);

// Value comparison
NAPI_EXTERN napi_status napi_strict_equals_primjs(napi_env env, napi_value lhs,
                                                  napi_value rhs, bool* result);

// Function APIs
NAPI_EXTERN napi_status napi_call_function_primjs(napi_env env, napi_value recv,
                                                  napi_value func, size_t argc,
                                                  const napi_value* argv,
                                                  napi_value* result);
NAPI_EXTERN napi_status napi_new_instance_primjs(napi_env env,
                                                 napi_value constructor,
                                                 size_t argc,
                                                 const napi_value* argv,
                                                 napi_value* result);
NAPI_EXTERN napi_status napi_instanceof_primjs(napi_env env, napi_value object,
                                               napi_value constructor,
                                               bool* result);

// Callback info
NAPI_EXTERN napi_status napi_get_cb_info_primjs(napi_env env,
                                                napi_callback_info cbinfo,
                                                size_t* argc, napi_value* argv,
                                                napi_value* this_arg,
                                                void** data);
NAPI_EXTERN napi_status napi_get_new_target_primjs(napi_env env,
                                                   napi_callback_info cbinfo,
                                                   napi_value* result);

// Class APIs
NAPI_EXTERN napi_status napi_define_class_primjs(
    napi_env env, const char* utf8name, size_t length,
    napi_callback constructor, void* data, size_t property_count,
    const napi_property_descriptor* properties, napi_value* result);

// Wrapping APIs
NAPI_EXTERN napi_status napi_wrap_primjs(napi_env env, napi_value js_object,
                                         void* native_object,
                                         napi_finalize finalize_cb,
                                         void* finalize_hint, napi_ref* result);
NAPI_EXTERN napi_status napi_unwrap_primjs(napi_env env, napi_value js_object,
                                           void** result);
NAPI_EXTERN napi_status napi_remove_wrap_primjs(napi_env env,
                                                napi_value js_object,
                                                void** result);

// External object APIs
NAPI_EXTERN napi_status napi_create_external_primjs(napi_env env, void* data,
                                                    napi_finalize finalize_cb,
                                                    void* finalize_hint,
                                                    napi_value* result);
NAPI_EXTERN napi_status napi_get_value_external_primjs(napi_env env,
                                                       napi_value value,
                                                       void** result);

// Reference APIs
NAPI_EXTERN napi_status napi_create_reference_primjs(napi_env env,
                                                     napi_value value,
                                                     uint32_t initial_refcount,
                                                     napi_ref* result);
NAPI_EXTERN napi_status napi_delete_reference_primjs(napi_env env,
                                                     napi_ref ref);
NAPI_EXTERN napi_status napi_reference_ref_primjs(napi_env env, napi_ref ref,
                                                  uint32_t* result);
NAPI_EXTERN napi_status napi_reference_unref_primjs(napi_env env, napi_ref ref,
                                                    uint32_t* result);
NAPI_EXTERN napi_status napi_get_reference_value_primjs(napi_env env,
                                                        napi_ref ref,
                                                        napi_value* result);

// Handle scope APIs
NAPI_EXTERN napi_status
napi_open_handle_scope_primjs(napi_env env, napi_handle_scope* result);
NAPI_EXTERN napi_status napi_close_handle_scope_primjs(napi_env env,
                                                       napi_handle_scope scope);
NAPI_EXTERN napi_status napi_open_escapable_handle_scope_primjs(
    napi_env env, napi_escapable_handle_scope* result);
NAPI_EXTERN napi_status napi_close_escapable_handle_scope_primjs(
    napi_env env, napi_escapable_handle_scope scope);
NAPI_EXTERN napi_status
napi_escape_handle_primjs(napi_env env, napi_escapable_handle_scope scope,
                          napi_value escapee, napi_value* result);

// Error handling
NAPI_EXTERN napi_status napi_throw_primjs(napi_env env, napi_value error);
NAPI_EXTERN napi_status napi_throw_error_primjs(napi_env env, const char* code,
                                                const char* msg);
NAPI_EXTERN napi_status napi_throw_type_error_primjs(napi_env env,
                                                     const char* code,
                                                     const char* msg);
NAPI_EXTERN napi_status napi_throw_range_error_primjs(napi_env env,
                                                      const char* code,
                                                      const char* msg);
NAPI_EXTERN napi_status napi_is_error_primjs(napi_env env, napi_value value,
                                             bool* result);

// Exception handling
NAPI_EXTERN napi_status napi_is_exception_pending_primjs(napi_env env,
                                                         bool* result);
NAPI_EXTERN napi_status
napi_get_and_clear_last_exception_primjs(napi_env env, napi_value* result);

NAPI_EXTERN napi_status napi_is_arraybuffer_primjs(napi_env env,
                                                   napi_value value,
                                                   bool* result);
NAPI_EXTERN napi_status napi_create_arraybuffer_primjs(napi_env env,
                                                       size_t byte_length,
                                                       void** data,
                                                       napi_value* result);
NAPI_EXTERN napi_status napi_create_external_arraybuffer_primjs(
    napi_env env, void* external_data, size_t byte_length,
    napi_finalize finalize_cb, void* finalize_hint, napi_value* result);
NAPI_EXTERN napi_status napi_get_arraybuffer_info_primjs(napi_env env,
                                                         napi_value arraybuffer,
                                                         void** data,
                                                         size_t* byte_length);

// TypedArray APIs
NAPI_EXTERN napi_status napi_is_typedarray_primjs(napi_env env,
                                                  napi_value value,
                                                  bool* result);
NAPI_EXTERN napi_status napi_create_typedarray_primjs(
    napi_env env, napi_typedarray_type type, size_t length,
    napi_value arraybuffer, size_t byte_offset, napi_value* result);
NAPI_EXTERN napi_status napi_is_typedarray_of_primjs(napi_env env,
                                                     napi_value typedarray,
                                                     napi_typedarray_type type,
                                                     bool* result);
NAPI_EXTERN napi_status napi_get_typedarray_info_primjs(
    napi_env env, napi_value typedarray, napi_typedarray_type* type,
    size_t* length, void** data, napi_value* arraybuffer, size_t* byte_offset);

// DataView APIs
NAPI_EXTERN napi_status napi_create_dataview_primjs(napi_env env, size_t length,
                                                    napi_value arraybuffer,
                                                    size_t byte_offset,
                                                    napi_value* result);
NAPI_EXTERN napi_status napi_is_dataview_primjs(napi_env env, napi_value value,
                                                bool* result);
NAPI_EXTERN napi_status napi_get_dataview_info_primjs(
    napi_env env, napi_value dataview, size_t* bytelength, void** data,
    napi_value* arraybuffer, size_t* byte_offset);

// Promise APIs
NAPI_EXTERN napi_status napi_create_promise_primjs(napi_env env,
                                                   napi_deferred* deferred,
                                                   napi_value* promise);
NAPI_EXTERN napi_status napi_release_deferred_primjs(
    napi_env env, napi_deferred deferred, napi_value resolution,
    napi_deferred_release_mode mode);
NAPI_EXTERN napi_status napi_is_promise_primjs(napi_env env, napi_value value,
                                               bool* is_promise);

// Script execution
NAPI_EXTERN napi_status napi_run_script_primjs(napi_env env, const char* script,
                                               size_t length,
                                               const char* filename,
                                               napi_value* result);

// Memory management
NAPI_EXTERN napi_status napi_adjust_external_memory_primjs(
    napi_env env, int64_t change_in_bytes, int64_t* adjusted_value);

// Finalizer APIs
NAPI_EXTERN napi_status napi_add_finalizer_primjs(
    napi_env env, napi_value js_object, void* native_object,
    napi_finalize finalize_cb, void* finalize_hint, napi_ref* result);

// Instance data
NAPI_EXTERN napi_status napi_set_instance_data_primjs(napi_env env,
                                                      uint64_t key, void* data,
                                                      napi_finalize finalize_cb,
                                                      void* finalize_hint);
NAPI_EXTERN napi_status napi_get_instance_data_primjs(napi_env env,
                                                      uint64_t key,
                                                      void** data);

// Error information
NAPI_EXTERN napi_status napi_get_last_error_info_primjs(
    napi_env env, const napi_extended_error_info** result);

// Environment lifecycle
NAPI_EXTERN napi_status napi_add_env_cleanup_hook_primjs(napi_env env,
                                                         void (*fun)(void* arg),
                                                         void* arg);
NAPI_EXTERN napi_status napi_remove_env_cleanup_hook_primjs(
    napi_env env, void (*fun)(void* arg), void* arg);

// Async work APIs
NAPI_EXTERN napi_status napi_create_async_work_primjs(
    napi_env env, napi_value async_resource, napi_value async_resource_name,
    napi_async_execute_callback execute, napi_async_complete_callback complete,
    void* data, napi_async_work* result);
NAPI_EXTERN napi_status napi_delete_async_work_primjs(napi_env env,
                                                      napi_async_work work);
NAPI_EXTERN napi_status napi_queue_async_work_primjs(napi_env env,
                                                     napi_async_work work);
NAPI_EXTERN napi_status napi_cancel_async_work_primjs(napi_env env,
                                                      napi_async_work work);

// Thread-safe function APIs
NAPI_EXTERN napi_status napi_create_threadsafe_function_primjs(
    napi_env env, napi_value func, napi_value async_resource,
    napi_value async_resource_name, size_t max_queue_size,
    size_t initial_thread_count, void* thread_finalize_data,
    napi_finalize thread_finalize_cb, void* context,
    napi_threadsafe_function_call_js_original call_js_cb,
    napi_threadsafe_function* result);

NAPI_EXTERN napi_status napi_call_threadsafe_function_primjs(
    napi_threadsafe_function func, void* data,
    napi_threadsafe_function_call_mode is_blocking);
NAPI_EXTERN napi_status
napi_release_threadsafe_function_primjs(napi_threadsafe_function func);

NAPI_EXTERN napi_status napi_get_threadsafe_function_context_primjs(
    napi_threadsafe_function func, void** result);

// Loader API
NAPI_EXTERN napi_status napi_get_loader_primjs(napi_env env,
                                               napi_value* result);

// Context scope APIs
NAPI_EXTERN napi_status
napi_open_context_scope_primjs(napi_env env, napi_context_scope* result);
NAPI_EXTERN napi_status
napi_close_context_scope_primjs(napi_env env, napi_context_scope scope);

// Error scope APIs
NAPI_EXTERN napi_status napi_open_error_scope_primjs(napi_env env,
                                                     napi_error_scope* result);
NAPI_EXTERN napi_status napi_close_error_scope_primjs(napi_env env,
                                                      napi_error_scope scope);

// Value comparison
NAPI_EXTERN napi_status napi_equals_primjs(napi_env env, napi_value lhs,
                                           napi_value rhs, bool* result);

// Promise utilities
NAPI_EXTERN napi_status
napi_get_unhandled_rejection_exception_primjs(napi_env env, napi_value* result);

// Property descriptor
NAPI_EXTERN napi_status napi_get_own_property_descriptor_primjs(
    napi_env env, napi_value obj, napi_value prop, napi_value* result);

// no implementation apis

NAPI_EXTERN NAPI_DEPRECATED napi_status napi_unref_threadsafe_function_primjs(
    napi_env env, napi_threadsafe_function func);
NAPI_EXTERN NAPI_DEPRECATED napi_status napi_ref_threadsafe_function_primjs(
    napi_env env, napi_threadsafe_function func);

NAPI_EXTERN napi_status napi_create_buffer_primjs(napi_env env, size_t length,
                                                  void** data,
                                                  napi_value* result);

NAPI_EXTERN napi_status napi_create_external_buffer_primjs(
    napi_env env, size_t length, void* data, void* finalize_cb,
    void* finalize_hint, napi_value* result);

NAPI_EXTERN napi_status napi_create_buffer_copy_primjs(napi_env env,
                                                       size_t length,
                                                       const void* data,
                                                       void** result_data,
                                                       napi_value* result);

NAPI_EXTERN napi_status napi_is_buffer_primjs(napi_env env, napi_value value,
                                              bool* result);
NAPI_EXTERN napi_status napi_get_buffer_info_primjs(napi_env env,
                                                    napi_value value,
                                                    void** data,
                                                    size_t* length);

NAPI_EXTERN napi_status napi_fatal_exception_primjs(napi_env env,
                                                    napi_value err);

NAPI_EXTERN void napi_fatal_error_primjs(const char* location,
                                         size_t location_len,
                                         const char* message,
                                         size_t message_len);

NAPI_EXTERN napi_status napi_create_date_primjs(napi_env env, double time,
                                                napi_value* result);

NAPI_EXTERN napi_status napi_is_date_primjs(napi_env env, napi_value value,
                                            bool* is_date);

NAPI_EXTERN napi_status napi_get_date_value_primjs(napi_env env,
                                                   napi_value value,
                                                   double* result);

// BigInt
NAPI_EXTERN napi_status napi_create_bigint_int64_primjs(napi_env env,
                                                        int64_t value,
                                                        napi_value* result);
NAPI_EXTERN napi_status napi_create_bigint_uint64_primjs(napi_env env,
                                                         uint64_t value,
                                                         napi_value* result);
NAPI_EXTERN napi_status napi_create_bigint_words_primjs(napi_env env,
                                                        int sign_bit,
                                                        size_t word_count,
                                                        const uint64_t* words,
                                                        napi_value* result);
NAPI_EXTERN napi_status napi_get_value_bigint_int64_primjs(napi_env env,
                                                           napi_value value,
                                                           int64_t* result,
                                                           bool* lossless);
NAPI_EXTERN napi_status napi_get_value_bigint_uint64_primjs(napi_env env,
                                                            napi_value value,
                                                            uint64_t* result,
                                                            bool* lossless);
NAPI_EXTERN napi_status napi_get_value_bigint_words_primjs(napi_env env,
                                                           napi_value value,
                                                           int* sign_bit,
                                                           size_t* word_count,
                                                           uint64_t* words);

NAPI_EXTERN napi_status napi_detach_arraybuffer_primjs(napi_env env,
                                                       napi_value arraybuffer);

NAPI_EXTERN napi_status napi_is_detached_arraybuffer_primjs(napi_env env,
                                                            napi_value value,
                                                            bool* result);

NAPI_EXTERN napi_status napi_add_async_cleanup_hook_primjs(napi_env env,
                                                           void* hook,
                                                           void* arg,
                                                           void* remove_handle);

NAPI_EXTERN napi_status
napi_remove_async_cleanup_hook_primjs(void* remove_handle);

NAPI_EXTERN napi_status napi_object_freeze_primjs(napi_env env,
                                                  napi_value object);
NAPI_EXTERN napi_status napi_object_seal_primjs(napi_env env,
                                                napi_value object);

NAPI_EXTERN napi_status node_api_symbol_for_primjs(napi_env env,
                                                   const char* utf8description,
                                                   size_t length,
                                                   napi_value* result);

NAPI_EXTERN napi_status
node_api_get_module_file_name_primjs(napi_env env, const char** result);

NAPI_EXTERN napi_status node_api_create_syntax_error_primjs(napi_env env,
                                                            napi_value code,
                                                            napi_value msg,
                                                            napi_value* result);

NAPI_EXTERN napi_status node_api_throw_syntax_error_primjs(napi_env env,
                                                           const char* code,
                                                           const char* msg);

NAPI_EXTERN napi_status node_api_create_external_string_latin1_primjs(
    napi_env env, char* str, size_t length, void* finalize_callback,
    void* finalize_hint, napi_value* result, bool* copied);
NAPI_EXTERN napi_status node_api_create_external_string_utf16_primjs(
    napi_env env, char16_t* str, size_t length, void* finalize_callback,
    void* finalize_hint, napi_value* result, bool* copied);

NAPI_EXTERN napi_status napi_resolve_deferred_primjs(napi_env env,
                                                     napi_deferred deferred,
                                                     napi_value resolution);
NAPI_EXTERN napi_status napi_reject_deferred_primjs(napi_env env,
                                                    napi_deferred deferred,
                                                    napi_value rejection);

NAPI_EXTERN void napi_module_register_primjs(napi_module* mod);

NAPI_EXTERN napi_status napi_get_all_property_names_primjs(
    napi_env env, napi_value object, napi_key_collection_mode key_mode,
    napi_key_filter key_filter, napi_key_conversion key_conversion,
    napi_value* result);

struct uv_loop_s_primjs;
NAPI_EXTERN napi_status
napi_get_uv_event_loop_primjs(napi_env env, struct uv_loop_s_primjs** loop);

struct napi_node_version_primjs;
NAPI_EXTERN napi_status napi_get_node_version_primjs(
    napi_env env,
    const struct napi_node_version_primjs** version);  // forward declaration

EXTERN_C_END

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif

#endif  // SRC_NAPI_JS_NATIVE_API_ADAPTER_H_
