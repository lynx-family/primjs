/*
Derived from weak-node-api@0.1.1 (npm package maintained in
callstackincubator/react-native-node-api). Local modifications include symbol
renaming via weak_napi_defines.h/weak_napi_undefs.h and include/path
adjustments. See NOTICE.md for upstream attribution and licensing details.
*/

/**
 * @file NodeApiHost.hpp
 * @brief NodeApiHost struct.
 *
 * This header provides a struct of Node-API functions implemented by a host to
 * inject its implementations.
 *
 * @note This file is generated - don't edit it directly
 */

#pragma once

#include "../headers/node_api.h"
#if defined(USE_WEAK_SUFFIX_NAPI)
#include "../headers/weak_napi_defines.h"
#endif

// Ideally we would have just used NAPI_NO_RETURN, but
// __declspec(noreturn) (when building with Microsoft Visual C++) cannot be used
// on members of a struct
// TODO: If we targeted C++23 we could use std::unreachable()

#if defined(__GNUC__)
#define WEAK_NODE_API_UNREACHABLE __builtin_unreachable()
#else
#define WEAK_NODE_API_UNREACHABLE __assume(0)
#endif

// Generate the struct of function pointers
struct NodeApiHost {
  napi_status (*napi_get_last_error_info)(node_api_basic_env,
                                          const napi_extended_error_info **);
  napi_status (*napi_get_undefined)(napi_env, napi_value *);
  napi_status (*napi_get_null)(napi_env, napi_value *);
  napi_status (*napi_get_global)(napi_env, napi_value *);
  napi_status (*napi_get_boolean)(napi_env, bool, napi_value *);
  napi_status (*napi_create_object)(napi_env, napi_value *);
  napi_status (*napi_create_array)(napi_env, napi_value *);
  napi_status (*napi_create_array_with_length)(napi_env, size_t, napi_value *);
  napi_status (*napi_create_double)(napi_env, double, napi_value *);
  napi_status (*napi_create_int32)(napi_env, int32_t, napi_value *);
  napi_status (*napi_create_uint32)(napi_env, uint32_t, napi_value *);
  napi_status (*napi_create_int64)(napi_env, int64_t, napi_value *);
  napi_status (*napi_create_string_latin1)(napi_env, const char *, size_t,
                                           napi_value *);
  napi_status (*napi_create_string_utf8)(napi_env, const char *, size_t,
                                         napi_value *);
  napi_status (*napi_create_string_utf16)(napi_env, const char16_t *, size_t,
                                          napi_value *);
  napi_status (*napi_create_symbol)(napi_env, napi_value, napi_value *);
  napi_status (*napi_create_function)(napi_env, const char *, size_t,
                                      napi_callback, void *, napi_value *);
  napi_status (*napi_create_error)(napi_env, napi_value, napi_value,
                                   napi_value *);
  napi_status (*napi_create_type_error)(napi_env, napi_value, napi_value,
                                        napi_value *);
  napi_status (*napi_create_range_error)(napi_env, napi_value, napi_value,
                                         napi_value *);
  napi_status (*napi_typeof)(napi_env, napi_value, napi_valuetype *);
  napi_status (*napi_get_value_double)(napi_env, napi_value, double *);
  napi_status (*napi_get_value_int32)(napi_env, napi_value, int32_t *);
  napi_status (*napi_get_value_uint32)(napi_env, napi_value, uint32_t *);
  napi_status (*napi_get_value_int64)(napi_env, napi_value, int64_t *);
  napi_status (*napi_get_value_bool)(napi_env, napi_value, bool *);
  napi_status (*napi_get_value_string_latin1)(napi_env, napi_value, char *,
                                              size_t, size_t *);
  napi_status (*napi_get_value_string_utf8)(napi_env, napi_value, char *,
                                            size_t, size_t *);
  napi_status (*napi_get_value_string_utf16)(napi_env, napi_value, char16_t *,
                                             size_t, size_t *);
  napi_status (*napi_coerce_to_bool)(napi_env, napi_value, napi_value *);
  napi_status (*napi_coerce_to_number)(napi_env, napi_value, napi_value *);
  napi_status (*napi_coerce_to_object)(napi_env, napi_value, napi_value *);
  napi_status (*napi_coerce_to_string)(napi_env, napi_value, napi_value *);
  napi_status (*napi_get_prototype)(napi_env, napi_value, napi_value *);
  napi_status (*napi_get_property_names)(napi_env, napi_value, napi_value *);
  napi_status (*napi_set_property)(napi_env, napi_value, napi_value,
                                   napi_value);
  napi_status (*napi_has_property)(napi_env, napi_value, napi_value, bool *);
  napi_status (*napi_get_property)(napi_env, napi_value, napi_value,
                                   napi_value *);
  napi_status (*napi_delete_property)(napi_env, napi_value, napi_value, bool *);
  napi_status (*napi_has_own_property)(napi_env, napi_value, napi_value,
                                       bool *);
  napi_status (*napi_set_named_property)(napi_env, napi_value, const char *,
                                         napi_value);
  napi_status (*napi_has_named_property)(napi_env, napi_value, const char *,
                                         bool *);
  napi_status (*napi_get_named_property)(napi_env, napi_value, const char *,
                                         napi_value *);
  napi_status (*napi_set_element)(napi_env, napi_value, uint32_t, napi_value);
  napi_status (*napi_has_element)(napi_env, napi_value, uint32_t, bool *);
  napi_status (*napi_get_element)(napi_env, napi_value, uint32_t, napi_value *);
  napi_status (*napi_delete_element)(napi_env, napi_value, uint32_t, bool *);
  napi_status (*napi_define_properties)(napi_env, napi_value, size_t,
                                        const napi_property_descriptor *);
  napi_status (*napi_is_array)(napi_env, napi_value, bool *);
  napi_status (*napi_get_array_length)(napi_env, napi_value, uint32_t *);
  napi_status (*napi_strict_equals)(napi_env, napi_value, napi_value, bool *);
  napi_status (*napi_call_function)(napi_env, napi_value, napi_value, size_t,
                                    const napi_value *, napi_value *);
  napi_status (*napi_new_instance)(napi_env, napi_value, size_t,
                                   const napi_value *, napi_value *);
  napi_status (*napi_instanceof)(napi_env, napi_value, napi_value, bool *);
  napi_status (*napi_get_cb_info)(napi_env, napi_callback_info, size_t *,
                                  napi_value *, napi_value *, void **);
  napi_status (*napi_get_new_target)(napi_env, napi_callback_info,
                                     napi_value *);
  napi_status (*napi_define_class)(napi_env, const char *, size_t,
                                   napi_callback, void *, size_t,
                                   const napi_property_descriptor *,
                                   napi_value *);
  napi_status (*napi_wrap)(napi_env, napi_value, void *,
                           node_api_basic_finalize, void *, napi_ref *);
  napi_status (*napi_unwrap)(napi_env, napi_value, void **);
  napi_status (*napi_remove_wrap)(napi_env, napi_value, void **);
  napi_status (*napi_create_external)(napi_env, void *, node_api_basic_finalize,
                                      void *, napi_value *);
  napi_status (*napi_get_value_external)(napi_env, napi_value, void **);
  napi_status (*napi_create_reference)(napi_env, napi_value, uint32_t,
                                       napi_ref *);
  napi_status (*napi_delete_reference)(napi_env, napi_ref);
  napi_status (*napi_reference_ref)(napi_env, napi_ref, uint32_t *);
  napi_status (*napi_reference_unref)(napi_env, napi_ref, uint32_t *);
  napi_status (*napi_get_reference_value)(napi_env, napi_ref, napi_value *);
  napi_status (*napi_open_handle_scope)(napi_env, napi_handle_scope *);
  napi_status (*napi_close_handle_scope)(napi_env, napi_handle_scope);
  napi_status (*napi_open_escapable_handle_scope)(
      napi_env, napi_escapable_handle_scope *);
  napi_status (*napi_close_escapable_handle_scope)(napi_env,
                                                   napi_escapable_handle_scope);
  napi_status (*napi_escape_handle)(napi_env, napi_escapable_handle_scope,
                                    napi_value, napi_value *);
  napi_status (*napi_throw)(napi_env, napi_value);
  napi_status (*napi_throw_error)(napi_env, const char *, const char *);
  napi_status (*napi_throw_type_error)(napi_env, const char *, const char *);
  napi_status (*napi_throw_range_error)(napi_env, const char *, const char *);
  napi_status (*napi_is_error)(napi_env, napi_value, bool *);
  napi_status (*napi_is_exception_pending)(napi_env, bool *);
  napi_status (*napi_get_and_clear_last_exception)(napi_env, napi_value *);
  napi_status (*napi_is_arraybuffer)(napi_env, napi_value, bool *);
  napi_status (*napi_create_arraybuffer)(napi_env, size_t, void **,
                                         napi_value *);
  napi_status (*napi_create_external_arraybuffer)(napi_env, void *, size_t,
                                                  node_api_basic_finalize,
                                                  void *, napi_value *);
  napi_status (*napi_get_arraybuffer_info)(napi_env, napi_value, void **,
                                           size_t *);
  napi_status (*napi_is_typedarray)(napi_env, napi_value, bool *);
  napi_status (*napi_create_typedarray)(napi_env, napi_typedarray_type, size_t,
                                        napi_value, size_t, napi_value *);
  napi_status (*napi_get_typedarray_info)(napi_env, napi_value,
                                          napi_typedarray_type *, size_t *,
                                          void **, napi_value *, size_t *);
  napi_status (*napi_create_dataview)(napi_env, size_t, napi_value, size_t,
                                      napi_value *);
  napi_status (*napi_is_dataview)(napi_env, napi_value, bool *);
  napi_status (*napi_get_dataview_info)(napi_env, napi_value, size_t *, void **,
                                        napi_value *, size_t *);
  napi_status (*napi_get_version)(node_api_basic_env, uint32_t *);
  napi_status (*napi_create_promise)(napi_env, napi_deferred *, napi_value *);
  napi_status (*napi_resolve_deferred)(napi_env, napi_deferred, napi_value);
  napi_status (*napi_reject_deferred)(napi_env, napi_deferred, napi_value);
  napi_status (*napi_is_promise)(napi_env, napi_value, bool *);
  napi_status (*napi_run_script)(napi_env, napi_value, napi_value *);
  napi_status (*napi_adjust_external_memory)(node_api_basic_env, int64_t,
                                             int64_t *);
  napi_status (*napi_create_date)(napi_env, double, napi_value *);
  napi_status (*napi_is_date)(napi_env, napi_value, bool *);
  napi_status (*napi_get_date_value)(napi_env, napi_value, double *);
  napi_status (*napi_add_finalizer)(napi_env, napi_value, void *,
                                    node_api_basic_finalize, void *,
                                    napi_ref *);
  napi_status (*napi_create_bigint_int64)(napi_env, int64_t, napi_value *);
  napi_status (*napi_create_bigint_uint64)(napi_env, uint64_t, napi_value *);
  napi_status (*napi_create_bigint_words)(napi_env, int, size_t,
                                          const uint64_t *, napi_value *);
  napi_status (*napi_get_value_bigint_int64)(napi_env, napi_value, int64_t *,
                                             bool *);
  napi_status (*napi_get_value_bigint_uint64)(napi_env, napi_value, uint64_t *,
                                              bool *);
  napi_status (*napi_get_value_bigint_words)(napi_env, napi_value, int *,
                                             size_t *, uint64_t *);
  napi_status (*napi_get_all_property_names)(napi_env, napi_value,
                                             napi_key_collection_mode,
                                             napi_key_filter,
                                             napi_key_conversion, napi_value *);
  napi_status (*napi_set_instance_data)(node_api_basic_env, void *,
                                        napi_finalize, void *);
  napi_status (*napi_get_instance_data)(node_api_basic_env, void **);
  napi_status (*napi_detach_arraybuffer)(napi_env, napi_value);
  napi_status (*napi_is_detached_arraybuffer)(napi_env, napi_value, bool *);
  napi_status (*napi_type_tag_object)(napi_env, napi_value,
                                      const napi_type_tag *);
  napi_status (*napi_check_object_type_tag)(napi_env, napi_value,
                                            const napi_type_tag *, bool *);
  napi_status (*napi_object_freeze)(napi_env, napi_value);
  napi_status (*napi_object_seal)(napi_env, napi_value);
  void (*napi_module_register)(napi_module *);
  void (*napi_fatal_error)(const char *, size_t, const char *, size_t);
  napi_status (*napi_async_init)(napi_env, napi_value, napi_value,
                                 napi_async_context *);
  napi_status (*napi_async_destroy)(napi_env, napi_async_context);
  napi_status (*napi_make_callback)(napi_env, napi_async_context, napi_value,
                                    napi_value, size_t, const napi_value *,
                                    napi_value *);
  napi_status (*napi_create_buffer)(napi_env, size_t, void **, napi_value *);
  napi_status (*napi_create_external_buffer)(napi_env, size_t, void *,
                                             node_api_basic_finalize, void *,
                                             napi_value *);
  napi_status (*napi_create_buffer_copy)(napi_env, size_t, const void *,
                                         void **, napi_value *);
  napi_status (*napi_is_buffer)(napi_env, napi_value, bool *);
  napi_status (*napi_get_buffer_info)(napi_env, napi_value, void **, size_t *);
  napi_status (*napi_create_async_work)(napi_env, napi_value, napi_value,
                                        napi_async_execute_callback,
                                        napi_async_complete_callback, void *,
                                        napi_async_work *);
  napi_status (*napi_delete_async_work)(napi_env, napi_async_work);
  napi_status (*napi_queue_async_work)(node_api_basic_env, napi_async_work);
  napi_status (*napi_cancel_async_work)(node_api_basic_env, napi_async_work);
  napi_status (*napi_get_node_version)(node_api_basic_env,
                                       const napi_node_version **);
  napi_status (*napi_get_uv_event_loop)(node_api_basic_env,
                                        struct uv_loop_s **);
  napi_status (*napi_fatal_exception)(napi_env, napi_value);
  napi_status (*napi_add_env_cleanup_hook)(node_api_basic_env,
                                           napi_cleanup_hook, void *);
  napi_status (*napi_remove_env_cleanup_hook)(node_api_basic_env,
                                              napi_cleanup_hook, void *);
  napi_status (*napi_open_callback_scope)(napi_env, napi_value,
                                          napi_async_context,
                                          napi_callback_scope *);
  napi_status (*napi_close_callback_scope)(napi_env, napi_callback_scope);
  napi_status (*napi_create_threadsafe_function)(
      napi_env, napi_value, napi_value, napi_value, size_t, size_t, void *,
      napi_finalize, void *, napi_threadsafe_function_call_js,
      napi_threadsafe_function *);
  napi_status (*napi_get_threadsafe_function_context)(napi_threadsafe_function,
                                                      void **);
  napi_status (*napi_call_threadsafe_function)(
      napi_threadsafe_function, void *, napi_threadsafe_function_call_mode);
  napi_status (*napi_acquire_threadsafe_function)(napi_threadsafe_function);
  napi_status (*napi_release_threadsafe_function)(
      napi_threadsafe_function, napi_threadsafe_function_release_mode);
  napi_status (*napi_unref_threadsafe_function)(node_api_basic_env,
                                                napi_threadsafe_function);
  napi_status (*napi_ref_threadsafe_function)(node_api_basic_env,
                                              napi_threadsafe_function);
  napi_status (*napi_add_async_cleanup_hook)(node_api_basic_env,
                                             napi_async_cleanup_hook, void *,
                                             napi_async_cleanup_hook_handle *);
  napi_status (*napi_remove_async_cleanup_hook)(napi_async_cleanup_hook_handle);
  napi_module *(*napi_find_module_weak)(const char *name);
};

#if defined(USE_WEAK_SUFFIX_NAPI)
#include "../headers/weak_napi_undefs.h"
#endif
