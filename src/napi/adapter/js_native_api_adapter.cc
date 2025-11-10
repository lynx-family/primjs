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

#include <cstddef>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <string>

#include "js_native_api_types.h"
#include "napi_runtime.h"

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

EXTERN_C_START

napi_status napi_get_version(napi_env env, uint32_t* result) {
  return env->napi_get_version(env, result);
}

napi_status napi_get_undefined(napi_env env, napi_value* result) {
  return env->napi_get_undefined(env, result);
}

napi_status napi_get_null(napi_env env, napi_value* result) {
  return env->napi_get_null(env, result);
}

napi_status napi_get_global(napi_env env, napi_value* result) {
  return env->napi_get_global(env, result);
}

napi_status napi_get_boolean(napi_env env, bool value, napi_value* result) {
  return env->napi_get_boolean(env, value, result);
}

napi_status napi_create_object(napi_env env, napi_value* result) {
  return env->napi_create_object(env, result);
}

napi_status napi_create_array(napi_env env, napi_value* result) {
  return env->napi_create_array(env, result);
}

napi_status napi_create_array_with_length(napi_env env, size_t length,
                                          napi_value* result) {
  return env->napi_create_array_with_length(env, length, result);
}

napi_status napi_create_double(napi_env env, double value, napi_value* result) {
  return env->napi_create_double(env, value, result);
}

napi_status napi_create_int32(napi_env env, int32_t value, napi_value* result) {
  return env->napi_create_int32(env, value, result);
}

napi_status napi_create_uint32(napi_env env, uint32_t value,
                               napi_value* result) {
  return env->napi_create_uint32(env, value, result);
}

napi_status napi_create_int64(napi_env env, int64_t value, napi_value* result) {
  return env->napi_create_int64(env, value, result);
}

napi_status napi_create_string_latin1(napi_env env, const char* str,
                                      size_t length, napi_value* result) {
  return env->napi_create_string_latin1(env, str, length, result);
}

napi_status napi_create_string_utf8(napi_env env, const char* str,
                                    size_t length, napi_value* result) {
  return env->napi_create_string_utf8(env, str, length, result);
}

napi_status napi_create_string_utf16(napi_env env, const char16_t* str,
                                     size_t length, napi_value* result) {
  return env->napi_create_string_utf16(env, str, length, result);
}

napi_status napi_create_symbol(napi_env env, napi_value description,
                               napi_value* result) {
  return env->napi_create_symbol(env, description, result);
}

napi_status napi_create_function(napi_env env, const char* utf8name,
                                 size_t length, napi_callback cb, void* data,
                                 napi_value* result) {
  return env->napi_create_function(env, utf8name, length, cb, data, result);
}

napi_status napi_create_error(napi_env env, napi_value code, napi_value msg,
                              napi_value* result) {
  return env->napi_create_error(env, code, msg, result);
}

napi_status napi_create_type_error(napi_env env, napi_value code,
                                   napi_value msg, napi_value* result) {
  return env->napi_create_type_error(env, code, msg, result);
}

napi_status napi_create_range_error(napi_env env, napi_value code,
                                    napi_value msg, napi_value* result) {
  return env->napi_create_range_error(env, code, msg, result);
}

napi_status napi_adjust_external_memory(napi_env env, int64_t change_in_bytes,
                                        int64_t* adjusted_value) {
  return env->napi_adjust_external_memory(env, change_in_bytes, adjusted_value);
}

napi_status napi_typeof(napi_env env, napi_value value,
                        napi_valuetype* result) {
  return env->napi_typeof(env, value, result);
}

napi_status napi_get_value_double(napi_env env, napi_value value,
                                  double* result) {
  return env->napi_get_value_double(env, value, result);
}

napi_status napi_get_value_int32(napi_env env, napi_value value,
                                 int32_t* result) {
  return env->napi_get_value_int32(env, value, result);
}

napi_status napi_get_value_uint32(napi_env env, napi_value value,
                                  uint32_t* result) {
  return env->napi_get_value_uint32(env, value, result);
}

napi_status napi_get_value_int64(napi_env env, napi_value value,
                                 int64_t* result) {
  return env->napi_get_value_int64(env, value, result);
}

napi_status napi_get_value_bool(napi_env env, napi_value value, bool* result) {
  return env->napi_get_value_bool(env, value, result);
}

napi_status napi_get_value_string_latin1(napi_env env, napi_value value,
                                         char* buf, size_t bufsize,
                                         size_t* result) {
  return env->napi_get_value_string_latin1(env, value, buf, bufsize, result);
}

napi_status napi_get_value_string_utf8(napi_env env, napi_value value,
                                       char* buf, size_t bufsize,
                                       size_t* result) {
  return env->napi_get_value_string_utf8(env, value, buf, bufsize, result);
}

napi_status napi_get_value_string_utf16(napi_env env, napi_value value,
                                        char16_t* buf, size_t bufsize,
                                        size_t* result) {
  return env->napi_get_value_string_utf16(env, value, buf, bufsize, result);
}

napi_status napi_coerce_to_bool(napi_env env, napi_value value,
                                napi_value* result) {
  return env->napi_coerce_to_bool(env, value, result);
}

napi_status napi_coerce_to_number(napi_env env, napi_value value,
                                  napi_value* result) {
  return env->napi_coerce_to_number(env, value, result);
}

napi_status napi_coerce_to_object(napi_env env, napi_value value,
                                  napi_value* result) {
  return env->napi_coerce_to_object(env, value, result);
}

napi_status napi_coerce_to_string(napi_env env, napi_value value,
                                  napi_value* result) {
  return env->napi_coerce_to_string(env, value, result);
}

napi_status napi_get_prototype(napi_env env, napi_value object,
                               napi_value* result) {
  return env->napi_get_prototype(env, object, result);
}

napi_status napi_get_property_names(napi_env env, napi_value object,
                                    napi_value* result) {
  return env->napi_get_property_names(env, object, result);
}

napi_status napi_set_property(napi_env env, napi_value object, napi_value key,
                              napi_value value) {
  return env->napi_set_property(env, object, key, value);
}

napi_status napi_has_property(napi_env env, napi_value object, napi_value key,
                              bool* result) {
  return env->napi_has_property(env, object, key, result);
}

napi_status napi_get_property(napi_env env, napi_value object, napi_value key,
                              napi_value* result) {
  return env->napi_get_property(env, object, key, result);
}

napi_status napi_delete_property(napi_env env, napi_value object,
                                 napi_value key, bool* result) {
  return env->napi_delete_property(env, object, key, result);
}

napi_status napi_has_own_property(napi_env env, napi_value object,
                                  napi_value key, bool* result) {
  return env->napi_has_own_property(env, object, key, result);
}

napi_status napi_set_named_property(napi_env env, napi_value object,
                                    const char* utf8name, napi_value value) {
  return env->napi_set_named_property(env, object, utf8name, value);
}

napi_status napi_has_named_property(napi_env env, napi_value object,
                                    const char* utf8name, bool* result) {
  return env->napi_has_named_property(env, object, utf8name, result);
}

napi_status napi_get_named_property(napi_env env, napi_value object,
                                    const char* utf8name, napi_value* result) {
  return env->napi_get_named_property(env, object, utf8name, result);
}

napi_status napi_set_element(napi_env env, napi_value object, uint32_t index,
                             napi_value value) {
  return env->napi_set_element(env, object, index, value);
}

napi_status napi_has_element(napi_env env, napi_value object, uint32_t index,
                             bool* result) {
  return env->napi_has_element(env, object, index, result);
}

napi_status napi_get_element(napi_env env, napi_value object, uint32_t index,
                             napi_value* result) {
  return env->napi_get_element(env, object, index, result);
}

napi_status napi_delete_element(napi_env env, napi_value object, uint32_t index,
                                bool* result) {
  return env->napi_delete_element(env, object, index, result);
}

napi_status napi_define_properties(napi_env env, napi_value object,
                                   size_t property_count,
                                   const napi_property_descriptor* properties) {
  return env->napi_define_properties(env, object, property_count, properties);
}

napi_status napi_is_array(napi_env env, napi_value value, bool* result) {
  return env->napi_is_array(env, value, result);
}

napi_status napi_get_array_length(napi_env env, napi_value value,
                                  uint32_t* result) {
  return env->napi_get_array_length(env, value, result);
}

napi_status napi_strict_equals(napi_env env, napi_value lhs, napi_value rhs,
                               bool* result) {
  return env->napi_strict_equals(env, lhs, rhs, result);
}

napi_status napi_call_function(napi_env env, napi_value recv, napi_value func,
                               size_t argc, const napi_value* argv,
                               napi_value* result) {
  return env->napi_call_function(env, recv, func, argc, argv, result);
}

napi_status napi_new_instance(napi_env env, napi_value constructor, size_t argc,
                              const napi_value* argv, napi_value* result) {
  return env->napi_new_instance(env, constructor, argc, argv, result);
}

napi_status napi_instanceof(napi_env env, napi_value object,
                            napi_value constructor, bool* result) {
  return env->napi_instanceof(env, object, constructor, result);
}

napi_status napi_get_cb_info(napi_env env, napi_callback_info cbinfo,
                             size_t* argc, napi_value* argv,
                             napi_value* this_arg, void** data) {
  return env->napi_get_cb_info(env, cbinfo, argc, argv, this_arg, data);
}

napi_status napi_get_new_target(napi_env env, napi_callback_info cbinfo,
                                napi_value* result) {
  return env->napi_get_new_target(env, cbinfo, result);
}

void DeleteClass(napi_env env, void* finalize_data, void* finalize_hint) {
  env->napi_release_class(env, static_cast<napi_class>(finalize_data));
}

napi_status napi_define_class(napi_env env, const char* utf8name, size_t length,
                              napi_callback constructor, void* data,
                              size_t property_count,
                              const napi_property_descriptor* properties,
                              napi_value* result) {
  napi_class class_result = nullptr;
  napi_status status = env->napi_define_class(
      env, utf8name, length, constructor, data, property_count, properties,
      nullptr, &class_result);
  if (!class_result || status != napi_ok) {
    return status;
  }
  status = env->napi_class_get_function(env, class_result, result);
  if (status != napi_ok) {
    return status;
  }
  return env->napi_add_finalizer(env, *result, class_result, DeleteClass,
                                 nullptr, nullptr);
}

napi_status napi_wrap(napi_env env, napi_value js_object, void* native_object,
                      napi_finalize finalize_cb, void* finalize_hint,
                      napi_ref* result) {
  return env->napi_wrap(env, js_object, native_object, finalize_cb,
                        finalize_hint, result);
}

napi_status napi_unwrap(napi_env env, napi_value js_object, void** result) {
  return env->napi_unwrap(env, js_object, result);
}

napi_status napi_remove_wrap(napi_env env, napi_value js_object,
                             void** result) {
  return env->napi_remove_wrap(env, js_object, result);
}

napi_status napi_create_external(napi_env env, void* data,
                                 napi_finalize finalize_cb, void* finalize_hint,
                                 napi_value* result) {
  return env->napi_create_external(env, data, finalize_cb, finalize_hint,
                                   result);
}

napi_status napi_get_value_external(napi_env env, napi_value value,
                                    void** result) {
  return env->napi_get_value_external(env, value, result);
}

napi_status napi_create_reference(napi_env env, napi_value value,
                                  uint32_t initial_refcount, napi_ref* result) {
  return env->napi_create_reference(env, value, initial_refcount, result);
}

napi_status napi_delete_reference(napi_env env, napi_ref ref) {
  return env->napi_delete_reference(env, ref);
}

napi_status napi_reference_ref(napi_env env, napi_ref ref, uint32_t* result) {
  return env->napi_reference_ref(env, ref, result);
}

napi_status napi_reference_unref(napi_env env, napi_ref ref, uint32_t* result) {
  return env->napi_reference_unref(env, ref, result);
}

napi_status napi_get_reference_value(napi_env env, napi_ref ref,
                                     napi_value* result) {
  return env->napi_get_reference_value(env, ref, result);
}

napi_status napi_open_handle_scope(napi_env env, napi_handle_scope* result) {
  return env->napi_open_handle_scope(env, result);
}

napi_status napi_close_handle_scope(napi_env env, napi_handle_scope scope) {
  return env->napi_close_handle_scope(env, scope);
}

napi_status napi_open_escapable_handle_scope(
    napi_env env, napi_escapable_handle_scope* result) {
  return env->napi_open_escapable_handle_scope(env, result);
}

napi_status napi_close_escapable_handle_scope(
    napi_env env, napi_escapable_handle_scope scope) {
  return env->napi_close_escapable_handle_scope(env, scope);
}

napi_status napi_escape_handle(napi_env env, napi_escapable_handle_scope scope,
                               napi_value escapee, napi_value* result) {
  return env->napi_escape_handle(env, scope, escapee, result);
}

napi_status napi_throw(napi_env env, napi_value error) {
  return env->napi_throw_(env, error);
}

napi_status napi_throw_error(napi_env env, const char* code, const char* msg) {
  return env->napi_throw_error(env, code, msg);
}

napi_status napi_throw_type_error(napi_env env, const char* code,
                                  const char* msg) {
  return env->napi_throw_type_error(env, code, msg);
}

napi_status napi_throw_range_error(napi_env env, const char* code,
                                   const char* msg) {
  return env->napi_throw_range_error(env, code, msg);
}

napi_status napi_is_error(napi_env env, napi_value value, bool* result) {
  return env->napi_is_error(env, value, result);
}

napi_status napi_is_exception_pending(napi_env env, bool* result) {
  return env->napi_is_exception_pending(env, result);
}

napi_status napi_get_and_clear_last_exception(napi_env env,
                                              napi_value* result) {
  return env->napi_get_and_clear_last_exception(env, result);
}

napi_status napi_is_arraybuffer(napi_env env, napi_value value, bool* result) {
  return env->napi_is_arraybuffer(env, value, result);
}
napi_status napi_create_arraybuffer(napi_env env, size_t byte_length,
                                    void** data, napi_value* result) {
  return env->napi_create_arraybuffer(env, byte_length, data, result);
}
napi_status napi_create_external_arraybuffer(napi_env env, void* external_data,
                                             size_t byte_length,
                                             napi_finalize finalize_cb,
                                             void* finalize_hint,
                                             napi_value* result) {
  return env->napi_create_external_arraybuffer(
      env, external_data, byte_length, finalize_cb, finalize_hint, result);
}
napi_status napi_get_arraybuffer_info(napi_env env, napi_value arraybuffer,
                                      void** data, size_t* byte_length) {
  return env->napi_get_arraybuffer_info(env, arraybuffer, data, byte_length);
}

napi_status napi_is_typedarray(napi_env env, napi_value value, bool* result) {
  return env->napi_is_typedarray(env, value, result);
}

napi_status napi_create_typedarray(napi_env env, napi_typedarray_type type,
                                   size_t length, napi_value arraybuffer,
                                   size_t byte_offset, napi_value* result) {
  return env->napi_create_typedarray(env, type, length, arraybuffer,
                                     byte_offset, result);
}

napi_status napi_get_typedarray_info(napi_env env, napi_value typedarray,
                                     napi_typedarray_type* type, size_t* length,
                                     void** data, napi_value* arraybuffer,
                                     size_t* byte_offset) {
  return env->napi_get_typedarray_info(env, typedarray, type, length, data,
                                       arraybuffer, byte_offset);
}

napi_status napi_create_dataview(napi_env env, size_t length,
                                 napi_value arraybuffer, size_t byte_offset,
                                 napi_value* result) {
  return env->napi_create_dataview(env, length, arraybuffer, byte_offset,
                                   result);
}

napi_status napi_is_dataview(napi_env env, napi_value value, bool* result) {
  return env->napi_is_dataview(env, value, result);
}

napi_status napi_get_dataview_info(napi_env env, napi_value dataview,
                                   size_t* bytelength, void** data,
                                   napi_value* arraybuffer,
                                   size_t* byte_offset) {
  return env->napi_get_dataview_info(env, dataview, bytelength, data,
                                     arraybuffer, byte_offset);
}

napi_status napi_create_promise(napi_env env, napi_deferred* deferred,
                                napi_value* promise) {
  return env->napi_create_promise(env, deferred, promise);
}

napi_status napi_release_deferred(napi_env env, napi_deferred deferred,
                                  napi_value resolution,
                                  napi_deferred_release_mode mode) {
  return env->napi_release_deferred(env, deferred, resolution, mode);
}

napi_status napi_is_promise(napi_env env, napi_value value, bool* is_promise) {
  return env->napi_is_promise(env, value, is_promise);
}

napi_status napi_run_script(napi_env env, const char* script, size_t length,
                            const char* filename, napi_value* result) {
  return env->napi_run_script(env, script, length, filename, result);
}

napi_status napi_add_finalizer(napi_env env, napi_value js_object,
                               void* native_object, napi_finalize finalize_cb,
                               void* finalize_hint, napi_ref* result) {
  return env->napi_add_finalizer(env, js_object, native_object, finalize_cb,
                                 finalize_hint, result);
}

napi_status napi_set_instance_data(napi_env env, uint64_t key, void* data,
                                   napi_finalize finalize_cb,
                                   void* finalize_hint) {
  return env->napi_set_instance_data(env, key, data, finalize_cb,
                                     finalize_hint);
}

napi_status napi_get_instance_data(napi_env env, uint64_t key, void** data) {
  return env->napi_get_instance_data(env, key, data);
}

napi_status napi_get_last_error_info(napi_env env,
                                     const napi_extended_error_info** result) {
  return env->napi_get_last_error_info(env, result);
}

napi_status napi_add_env_cleanup_hook(napi_env env, void (*fun)(void* arg),
                                      void* arg) {
  return env->napi_add_env_cleanup_hook(env, fun, arg);
}

napi_status napi_remove_env_cleanup_hook(napi_env env, void (*fun)(void* arg),
                                         void* arg) {
  return env->napi_remove_env_cleanup_hook(env, fun, arg);
}

class ThreadSafeFunctionAdaptor {
 public:
  ThreadSafeFunctionAdaptor(
      napi_env env, napi_value func, void* thread_finalize_data,
      napi_finalize thread_finalize_cb, void* context,
      napi_threadsafe_function_call_js_original call_js_cb)
      : env_(env),
        thread_finalize_data_(thread_finalize_data),
        thread_finalize_cb_(thread_finalize_cb),
        context_(context),
        call_js_cb_(call_js_cb) {
    env->napi_create_reference(env, func, 1, &func_ref_);
  }
  ~ThreadSafeFunctionAdaptor() {
    if (thread_finalize_cb_) {
      thread_finalize_cb_(env_, thread_finalize_data_, thread_finalize_data_);
    }
    env_->napi_delete_reference(env_, func_ref_);
  }

  static void Call(napi_env env, void* context, void* data) {
    ThreadSafeFunctionAdaptor* adaptor =
        static_cast<ThreadSafeFunctionAdaptor*>(context);
    if (adaptor->call_js_cb_) {
      napi_value func{nullptr};
      env->napi_get_reference_value(env, adaptor->func_ref_, &func);
      adaptor->call_js_cb_(env, func, adaptor->context_, data);
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
  napi_threadsafe_function_call_js_original call_js_cb_{nullptr};
};

napi_status napi_create_threadsafe_function(
    napi_env env, napi_value func, napi_value async_resource,
    napi_value async_resource_name, size_t max_queue_size,
    size_t initial_thread_count, void* thread_finalize_data,
    napi_finalize thread_finalize_cb, void* context,
    napi_threadsafe_function_call_js_original call_js_cb,
    napi_threadsafe_function* result) {
  ThreadSafeFunctionAdaptor* adaptor = new ThreadSafeFunctionAdaptor(
      env, func, thread_finalize_data, thread_finalize_cb, context, call_js_cb);
  return env->napi_create_threadsafe_function(
      env, adaptor, ThreadSafeFunctionAdaptor::Finalize, adaptor,
      ThreadSafeFunctionAdaptor::Call, result);
}

napi_status napi_call_threadsafe_function(
    napi_threadsafe_function func, void* data,
    napi_threadsafe_function_call_mode is_blocking) {
  return napi_runtime_call_threadsafe_function(func, data, is_blocking);
}

napi_status napi_release_threadsafe_function(napi_threadsafe_function func) {
  return napi_runtime_delete_threadsafe_function(func);
}

napi_status napi_get_threadsafe_function_context(napi_threadsafe_function func,
                                                 void** result) {
  return napi_runtime_get_threadsafe_function_context(func, result);
}

// unimplemented API

// NODE_VERSION 1

void napi_fatal_error(const char* location, size_t location_len,
                      const char* message, size_t message_len) {
  if (location && location_len > 0) {
    std::printf("Fatal error location: %.*s\n", static_cast<int>(location_len),
                location);
  }

  if (message && message_len > 0) {
    std::printf("Fatal error message: %.*s\n", static_cast<int>(message_len),
                message);
  }

  std::abort();
}

void napi_module_register(napi_module* mod) { napi_module_register_xx(mod); }

// Unimplemented API

// NAPI_VERSION 1
napi_status napi_resolve_deferred(napi_env env, napi_deferred deferred,
                                  napi_value resolution) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_resolve_deferred is not implemented.\n");
  return napi_pending_exception;
}

napi_status napi_reject_deferred(napi_env env, napi_deferred deferred,
                                 napi_value rejection) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_reject_deferred is not implemented.\n");
  return napi_pending_exception;
}

napi_status napi_fatal_exception(napi_env env, napi_value err) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_fatal_exception is not implemented.\n");
  return napi_pending_exception;
}

/// NAPI VERSION 4
napi_status napi_unref_threadsafe_function(napi_env env,
                                           napi_threadsafe_function func) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_unref_threadsafe_function is not implemented.\n");
  return napi_pending_exception;
}
napi_status napi_ref_threadsafe_function(napi_env env,
                                         napi_threadsafe_function func) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_ref_threadsafe_function is not implemented.\n");
  return napi_pending_exception;
}

napi_status napi_acquire_threadsafe_function(napi_threadsafe_function func) {
  return napi_generic_failure;
}

// NAPI VERSION 5
napi_status napi_create_date(napi_env env, double time, napi_value* result) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_create_date is not implemented.\n");
  return napi_pending_exception;
}

napi_status napi_is_date(napi_env env, napi_value value, bool* is_date) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_is_date is not implemented.\n");
  return napi_pending_exception;
}

napi_status napi_get_date_value(napi_env env, napi_value value,
                                double* result) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_get_date_value is not implemented.\n");
  return napi_pending_exception;
}

napi_status napi_create_bigint_int64(napi_env env, int64_t value,
                                     napi_value* result) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_create_bigint_int64 is not implemented.\n");
  return napi_pending_exception;
}
napi_status napi_create_bigint_uint64(napi_env env, uint64_t value,
                                      napi_value* result) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_create_bigint_uint64 is not implemented.\n");
  return napi_pending_exception;
}

napi_status napi_create_bigint_words(napi_env env, int sign_bit,
                                     size_t word_count, const uint64_t* words,
                                     napi_value* result) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_create_bigint_words is not implemented.\n");
  return napi_pending_exception;
}
napi_status napi_get_value_bigint_int64(napi_env env, napi_value value,
                                        int64_t* result, bool* lossless) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_get_value_bigint_int64 is not implemented.\n");
  return napi_pending_exception;
}
napi_status napi_get_value_bigint_uint64(napi_env env, napi_value value,
                                         uint64_t* result, bool* lossless) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_get_value_bigint_uint64 is not implemented.\n");
  return napi_pending_exception;
}
napi_status napi_get_value_bigint_words(napi_env env, napi_value value,
                                        int* sign_bit, size_t* word_count,
                                        uint64_t* words) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_get_value_bigint_words is not implemented.\n");
  return napi_pending_exception;
}

napi_status napi_get_all_property_names(napi_env env, napi_value object,
                                        napi_key_collection_mode key_mode,
                                        napi_key_filter key_filter,
                                        napi_key_conversion key_conversion,
                                        napi_value* result) {
  env->napi_throw_error(env, "no implementation error",
                        "napi_get_all_property_names is not implemented.\n");
  return napi_pending_exception;
}
EXTERN_C_END
