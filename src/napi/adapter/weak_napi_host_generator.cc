// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "js_native_api_adapter.h"
#include "primjs_weak_node_api_provider.h"
#include "weak_node_api_host.h"

extern "C" const void* PrimJSGetWeakNodeApiRawPtrHost(void) {
  static PrimJSNodeApiRawPtrHost* sWeakRawPtrHost = []() {
    auto* host = new PrimJSNodeApiRawPtrHost();
    host->napi_get_undefined_rawptr =
        reinterpret_cast<void*>(napi_get_undefined_primjs);
    host->napi_get_null_rawptr = reinterpret_cast<void*>(napi_get_null_primjs);
    host->napi_get_global_rawptr =
        reinterpret_cast<void*>(napi_get_global_primjs);
    host->napi_get_boolean_rawptr =
        reinterpret_cast<void*>(napi_get_boolean_primjs);
    host->napi_create_object_rawptr =
        reinterpret_cast<void*>(napi_create_object_primjs);
    host->napi_create_array_rawptr =
        reinterpret_cast<void*>(napi_create_array_primjs);
    host->napi_create_array_with_length_rawptr =
        reinterpret_cast<void*>(napi_create_array_with_length_primjs);
    host->napi_create_double_rawptr =
        reinterpret_cast<void*>(napi_create_double_primjs);
    host->napi_create_int32_rawptr =
        reinterpret_cast<void*>(napi_create_int32_primjs);
    host->napi_create_uint32_rawptr =
        reinterpret_cast<void*>(napi_create_uint32_primjs);
    host->napi_create_int64_rawptr =
        reinterpret_cast<void*>(napi_create_int64_primjs);
    host->napi_create_string_latin1_rawptr =
        reinterpret_cast<void*>(napi_create_string_latin1_primjs);
    host->napi_create_string_utf8_rawptr =
        reinterpret_cast<void*>(napi_create_string_utf8_primjs);
    host->napi_create_string_utf16_rawptr =
        reinterpret_cast<void*>(napi_create_string_utf16_primjs);
    host->napi_create_symbol_rawptr =
        reinterpret_cast<void*>(napi_create_symbol_primjs);
    host->napi_create_function_rawptr =
        reinterpret_cast<void*>(napi_create_function_primjs);
    host->napi_create_error_rawptr =
        reinterpret_cast<void*>(napi_create_error_primjs);
    host->napi_create_type_error_rawptr =
        reinterpret_cast<void*>(napi_create_type_error_primjs);
    host->napi_create_range_error_rawptr =
        reinterpret_cast<void*>(napi_create_range_error_primjs);
    host->napi_typeof_rawptr = reinterpret_cast<void*>(napi_typeof_primjs);
    host->napi_get_value_double_rawptr =
        reinterpret_cast<void*>(napi_get_value_double_primjs);
    host->napi_get_value_int32_rawptr =
        reinterpret_cast<void*>(napi_get_value_int32_primjs);
    host->napi_get_value_uint32_rawptr =
        reinterpret_cast<void*>(napi_get_value_uint32_primjs);
    host->napi_get_value_int64_rawptr =
        reinterpret_cast<void*>(napi_get_value_int64_primjs);
    host->napi_get_value_bool_rawptr =
        reinterpret_cast<void*>(napi_get_value_bool_primjs);
    host->napi_get_value_string_latin1_rawptr =
        reinterpret_cast<void*>(napi_get_value_string_latin1_primjs);
    host->napi_get_value_string_utf8_rawptr =
        reinterpret_cast<void*>(napi_get_value_string_utf8_primjs);
    host->napi_get_value_string_utf16_rawptr =
        reinterpret_cast<void*>(napi_get_value_string_utf16_primjs);
    host->napi_coerce_to_bool_rawptr =
        reinterpret_cast<void*>(napi_coerce_to_bool_primjs);
    host->napi_coerce_to_number_rawptr =
        reinterpret_cast<void*>(napi_coerce_to_number_primjs);
    host->napi_coerce_to_object_rawptr =
        reinterpret_cast<void*>(napi_coerce_to_object_primjs);
    host->napi_coerce_to_string_rawptr =
        reinterpret_cast<void*>(napi_coerce_to_string_primjs);
    host->napi_get_prototype_rawptr =
        reinterpret_cast<void*>(napi_get_prototype_primjs);
    host->napi_get_property_names_rawptr =
        reinterpret_cast<void*>(napi_get_property_names_primjs);
    host->napi_set_property_rawptr =
        reinterpret_cast<void*>(napi_set_property_primjs);
    host->napi_has_property_rawptr =
        reinterpret_cast<void*>(napi_has_property_primjs);
    host->napi_get_property_rawptr =
        reinterpret_cast<void*>(napi_get_property_primjs);
    host->napi_delete_property_rawptr =
        reinterpret_cast<void*>(napi_delete_property_primjs);
    host->napi_has_own_property_rawptr =
        reinterpret_cast<void*>(napi_has_own_property_primjs);
    host->napi_set_named_property_rawptr =
        reinterpret_cast<void*>(napi_set_named_property_primjs);
    host->napi_has_named_property_rawptr =
        reinterpret_cast<void*>(napi_has_named_property_primjs);
    host->napi_get_named_property_rawptr =
        reinterpret_cast<void*>(napi_get_named_property_primjs);
    host->napi_set_element_rawptr =
        reinterpret_cast<void*>(napi_set_element_primjs);
    host->napi_has_element_rawptr =
        reinterpret_cast<void*>(napi_has_element_primjs);
    host->napi_get_element_rawptr =
        reinterpret_cast<void*>(napi_get_element_primjs);
    host->napi_delete_element_rawptr =
        reinterpret_cast<void*>(napi_delete_element_primjs);
    host->napi_define_properties_rawptr =
        reinterpret_cast<void*>(napi_define_properties_primjs);
    host->napi_is_array_rawptr = reinterpret_cast<void*>(napi_is_array_primjs);
    host->napi_get_array_length_rawptr =
        reinterpret_cast<void*>(napi_get_array_length_primjs);
    host->napi_strict_equals_rawptr =
        reinterpret_cast<void*>(napi_strict_equals_primjs);
    host->napi_call_function_rawptr =
        reinterpret_cast<void*>(napi_call_function_primjs);
    host->napi_new_instance_rawptr =
        reinterpret_cast<void*>(napi_new_instance_primjs);
    host->napi_instanceof_rawptr =
        reinterpret_cast<void*>(napi_instanceof_primjs);
    host->napi_get_cb_info_rawptr =
        reinterpret_cast<void*>(napi_get_cb_info_primjs);
    host->napi_get_new_target_rawptr =
        reinterpret_cast<void*>(napi_get_new_target_primjs);
    host->napi_define_class_rawptr =
        reinterpret_cast<void*>(napi_define_class_primjs);
    host->napi_wrap_rawptr = reinterpret_cast<void*>(napi_wrap_primjs);
    host->napi_unwrap_rawptr = reinterpret_cast<void*>(napi_unwrap_primjs);
    host->napi_remove_wrap_rawptr =
        reinterpret_cast<void*>(napi_remove_wrap_primjs);
    host->napi_create_external_rawptr =
        reinterpret_cast<void*>(napi_create_external_primjs);
    host->napi_get_value_external_rawptr =
        reinterpret_cast<void*>(napi_get_value_external_primjs);
    host->napi_create_reference_rawptr =
        reinterpret_cast<void*>(napi_create_reference_primjs);
    host->napi_delete_reference_rawptr =
        reinterpret_cast<void*>(napi_delete_reference_primjs);
    host->napi_reference_ref_rawptr =
        reinterpret_cast<void*>(napi_reference_ref_primjs);
    host->napi_reference_unref_rawptr =
        reinterpret_cast<void*>(napi_reference_unref_primjs);
    host->napi_get_reference_value_rawptr =
        reinterpret_cast<void*>(napi_get_reference_value_primjs);
    host->napi_open_handle_scope_rawptr =
        reinterpret_cast<void*>(napi_open_handle_scope_primjs);
    host->napi_close_handle_scope_rawptr =
        reinterpret_cast<void*>(napi_close_handle_scope_primjs);
    host->napi_open_escapable_handle_scope_rawptr =
        reinterpret_cast<void*>(napi_open_escapable_handle_scope_primjs);
    host->napi_close_escapable_handle_scope_rawptr =
        reinterpret_cast<void*>(napi_close_escapable_handle_scope_primjs);
    host->napi_escape_handle_rawptr =
        reinterpret_cast<void*>(napi_escape_handle_primjs);
    host->napi_throw_rawptr = reinterpret_cast<void*>(napi_throw_primjs);
    host->napi_throw_error_rawptr =
        reinterpret_cast<void*>(napi_throw_error_primjs);
    host->napi_throw_type_error_rawptr =
        reinterpret_cast<void*>(napi_throw_type_error_primjs);
    host->napi_throw_range_error_rawptr =
        reinterpret_cast<void*>(napi_throw_range_error_primjs);
    host->napi_is_error_rawptr = reinterpret_cast<void*>(napi_is_error_primjs);
    host->napi_is_exception_pending_rawptr =
        reinterpret_cast<void*>(napi_is_exception_pending_primjs);
    host->napi_get_and_clear_last_exception_rawptr =
        reinterpret_cast<void*>(napi_get_and_clear_last_exception_primjs);
    host->napi_get_last_error_info_rawptr =
        reinterpret_cast<void*>(napi_get_last_error_info_primjs);
    host->napi_is_arraybuffer_rawptr =
        reinterpret_cast<void*>(napi_is_arraybuffer_primjs);
    host->napi_create_arraybuffer_rawptr =
        reinterpret_cast<void*>(napi_create_arraybuffer_primjs);
    host->napi_create_external_arraybuffer_rawptr =
        reinterpret_cast<void*>(napi_create_external_arraybuffer_primjs);
    host->napi_get_arraybuffer_info_rawptr =
        reinterpret_cast<void*>(napi_get_arraybuffer_info_primjs);
    host->napi_detach_arraybuffer_rawptr =
        reinterpret_cast<void*>(napi_detach_arraybuffer_primjs);
    host->napi_is_typedarray_rawptr =
        reinterpret_cast<void*>(napi_is_typedarray_primjs);
    host->napi_create_typedarray_rawptr =
        reinterpret_cast<void*>(napi_create_typedarray_primjs);
    host->napi_get_typedarray_info_rawptr =
        reinterpret_cast<void*>(napi_get_typedarray_info_primjs);
    host->napi_create_dataview_rawptr =
        reinterpret_cast<void*>(napi_create_dataview_primjs);
    host->napi_is_dataview_rawptr =
        reinterpret_cast<void*>(napi_is_dataview_primjs);
    host->napi_get_dataview_info_rawptr =
        reinterpret_cast<void*>(napi_get_dataview_info_primjs);
    host->napi_create_promise_rawptr =
        reinterpret_cast<void*>(napi_create_promise_primjs);
    host->napi_is_promise_rawptr =
        reinterpret_cast<void*>(napi_is_promise_primjs);
    host->napi_resolve_deferred_rawptr =
        reinterpret_cast<void*>(napi_resolve_deferred_primjs);
    host->napi_reject_deferred_rawptr =
        reinterpret_cast<void*>(napi_reject_deferred_primjs);
    host->napi_run_script_rawptr =
        reinterpret_cast<void*>(napi_run_script_primjs);
    host->napi_adjust_external_memory_rawptr =
        reinterpret_cast<void*>(napi_adjust_external_memory_primjs);
    host->napi_add_finalizer_rawptr =
        reinterpret_cast<void*>(napi_add_finalizer_primjs);
    host->napi_set_instance_data_rawptr =
        reinterpret_cast<void*>(napi_set_instance_data_primjs);
    host->napi_get_instance_data_rawptr =
        reinterpret_cast<void*>(napi_get_instance_data_primjs);
    host->napi_add_env_cleanup_hook_rawptr =
        reinterpret_cast<void*>(napi_add_env_cleanup_hook_primjs);
    host->napi_remove_env_cleanup_hook_rawptr =
        reinterpret_cast<void*>(napi_remove_env_cleanup_hook_primjs);
    host->napi_create_async_work_rawptr =
        reinterpret_cast<void*>(napi_create_async_work_primjs);
    host->napi_delete_async_work_rawptr =
        reinterpret_cast<void*>(napi_delete_async_work_primjs);
    host->napi_queue_async_work_rawptr =
        reinterpret_cast<void*>(napi_queue_async_work_primjs);
    host->napi_cancel_async_work_rawptr =
        reinterpret_cast<void*>(napi_cancel_async_work_primjs);
    host->napi_create_threadsafe_function_rawptr =
        reinterpret_cast<void*>(napi_create_threadsafe_function_primjs);
    host->napi_get_threadsafe_function_context_rawptr =
        reinterpret_cast<void*>(napi_get_threadsafe_function_context_primjs);
    host->napi_call_threadsafe_function_rawptr =
        reinterpret_cast<void*>(napi_call_threadsafe_function_primjs);
    host->napi_acquire_threadsafe_function_rawptr =
        reinterpret_cast<void*>(napi_acquire_threadsafe_function_primjs);
    host->napi_release_threadsafe_function_rawptr =
        reinterpret_cast<void*>(napi_release_threadsafe_function_primjs);
    host->napi_unref_threadsafe_function_rawptr =
        reinterpret_cast<void*>(napi_unref_threadsafe_function_primjs);
    host->napi_ref_threadsafe_function_rawptr =
        reinterpret_cast<void*>(napi_ref_threadsafe_function_primjs);
    host->napi_create_date_rawptr =
        reinterpret_cast<void*>(napi_create_date_primjs);
    host->napi_is_date_rawptr = reinterpret_cast<void*>(napi_is_date_primjs);
    host->napi_get_date_value_rawptr =
        reinterpret_cast<void*>(napi_get_date_value_primjs);
    host->napi_module_register_rawptr =
        reinterpret_cast<void*>(napi_module_register_primjs);
    host->napi_fatal_error_rawptr =
        reinterpret_cast<void*>(napi_fatal_error_primjs);
    host->napi_get_all_property_names_rawptr =
        reinterpret_cast<void*>(napi_get_all_property_names_primjs);
    host->napi_create_bigint_int64_rawptr =
        reinterpret_cast<void*>(napi_create_bigint_int64_primjs);
    host->napi_create_bigint_uint64_rawptr =
        reinterpret_cast<void*>(napi_create_bigint_uint64_primjs);
    host->napi_create_bigint_words_rawptr =
        reinterpret_cast<void*>(napi_create_bigint_words_primjs);
    host->napi_get_value_bigint_int64_rawptr =
        reinterpret_cast<void*>(napi_get_value_bigint_int64_primjs);
    host->napi_get_value_bigint_uint64_rawptr =
        reinterpret_cast<void*>(napi_get_value_bigint_uint64_primjs);
    host->napi_get_value_bigint_words_rawptr =
        reinterpret_cast<void*>(napi_get_value_bigint_words_primjs);
    host->napi_get_version_rawptr =
        reinterpret_cast<void*>(napi_get_version_primjs);
    host->napi_find_module_rawptr =
        reinterpret_cast<void*>(napi_find_module_primjs);
    return host;
  }();
  return reinterpret_cast<const void*>(sWeakRawPtrHost);
}
