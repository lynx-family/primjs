/*
Derived from weak-node-api@0.1.1 (npm package maintained in
callstackincubator/react-native-node-api). Local modifications include symbol
renaming via weak_napi_defines.h/weak_napi_undefs.h and include/path
adjustments. See NOTICE.md for upstream attribution and licensing details.
*/

/**
 * @file weak_node_api.cpp
 * @brief Weak Node-API host injection implementation.
 *
 * Provides the implementation for deferring Node-API function calls from addons
 * into a Node-API host.
 *
 * @note This file is generated - don't edit it directly
 */

#include "weak_node_api.hpp"
#if defined(USE_WEAK_SUFFIX_NAPI)
#include "../headers/weak_napi_defines.h"
#endif

/**
 * @brief Global instance of the injected Node-API host.
 *
 * This variable holds the function table for Node-API calls.
 * It is set via inject_weak_node_api_host() before any Node-API function is
 * dispatched. All Node-API calls are routed through this host.
 */
NodeApiHost g_host;
void inject_weak_node_api_host(const NodeApiHost &host) { g_host = host; };

// Generate function calling into the host

extern "C" napi_status napi_get_last_error_info(
    node_api_basic_env arg0, const napi_extended_error_info **arg1) {
  if (g_host.napi_get_last_error_info == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_last_error_info' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_get_last_error_info(arg0, arg1);
};

extern "C" napi_status napi_get_undefined(napi_env arg0, napi_value *arg1) {
  if (g_host.napi_get_undefined == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_undefined' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_get_undefined(arg0, arg1);
};

extern "C" napi_status napi_get_null(napi_env arg0, napi_value *arg1) {
  if (g_host.napi_get_null == nullptr) {
    fprintf(
        stderr,
        "Node-API function 'napi_get_null' called before it was injected!\n");
    abort();
  }
  return g_host.napi_get_null(arg0, arg1);
};

extern "C" napi_status napi_get_global(napi_env arg0, napi_value *arg1) {
  if (g_host.napi_get_global == nullptr) {
    fprintf(
        stderr,
        "Node-API function 'napi_get_global' called before it was injected!\n");
    abort();
  }
  return g_host.napi_get_global(arg0, arg1);
};

extern "C" napi_status napi_get_boolean(napi_env arg0, bool arg1,
                                        napi_value *arg2) {
  if (g_host.napi_get_boolean == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_boolean' called before it was "
            "injected!\n");
    abort();
  }
  return g_host.napi_get_boolean(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_object(napi_env arg0, napi_value *arg1) {
  if (g_host.napi_create_object == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_object' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_object(arg0, arg1);
};

extern "C" napi_status napi_create_array(napi_env arg0, napi_value *arg1) {
  if (g_host.napi_create_array == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_array' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_array(arg0, arg1);
};

extern "C" napi_status napi_create_array_with_length(napi_env arg0, size_t arg1,
                                                     napi_value *arg2) {
  if (g_host.napi_create_array_with_length == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_array_with_length' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_create_array_with_length(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_double(napi_env arg0, double arg1,
                                          napi_value *arg2) {
  if (g_host.napi_create_double == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_double' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_double(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_int32(napi_env arg0, int32_t arg1,
                                         napi_value *arg2) {
  if (g_host.napi_create_int32 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_int32' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_int32(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_uint32(napi_env arg0, uint32_t arg1,
                                          napi_value *arg2) {
  if (g_host.napi_create_uint32 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_uint32' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_uint32(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_int64(napi_env arg0, int64_t arg1,
                                         napi_value *arg2) {
  if (g_host.napi_create_int64 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_int64' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_int64(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_string_latin1(napi_env arg0,
                                                 const char *arg1, size_t arg2,
                                                 napi_value *arg3) {
  if (g_host.napi_create_string_latin1 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_string_latin1' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_create_string_latin1(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_create_string_utf8(napi_env arg0, const char *arg1,
                                               size_t arg2, napi_value *arg3) {
  if (g_host.napi_create_string_utf8 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_string_utf8' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_create_string_utf8(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_create_string_utf16(napi_env arg0,
                                                const char16_t *arg1,
                                                size_t arg2, napi_value *arg3) {
  if (g_host.napi_create_string_utf16 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_string_utf16' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_create_string_utf16(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_create_symbol(napi_env arg0, napi_value arg1,
                                          napi_value *arg2) {
  if (g_host.napi_create_symbol == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_symbol' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_symbol(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_function(napi_env arg0, const char *arg1,
                                            size_t arg2, napi_callback arg3,
                                            void *arg4, napi_value *arg5) {
  if (g_host.napi_create_function == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_function' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_function(arg0, arg1, arg2, arg3, arg4, arg5);
};

extern "C" napi_status napi_create_error(napi_env arg0, napi_value arg1,
                                         napi_value arg2, napi_value *arg3) {
  if (g_host.napi_create_error == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_error' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_error(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_create_type_error(napi_env arg0, napi_value arg1,
                                              napi_value arg2,
                                              napi_value *arg3) {
  if (g_host.napi_create_type_error == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_type_error' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_create_type_error(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_create_range_error(napi_env arg0, napi_value arg1,
                                               napi_value arg2,
                                               napi_value *arg3) {
  if (g_host.napi_create_range_error == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_range_error' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_create_range_error(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_typeof(napi_env arg0, napi_value arg1,
                                   napi_valuetype *arg2) {
  if (g_host.napi_typeof == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_typeof' called before it was injected!\n");
    abort();
  }
  return g_host.napi_typeof(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_value_double(napi_env arg0, napi_value arg1,
                                             double *arg2) {
  if (g_host.napi_get_value_double == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_double' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_get_value_double(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_value_int32(napi_env arg0, napi_value arg1,
                                            int32_t *arg2) {
  if (g_host.napi_get_value_int32 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_int32' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_get_value_int32(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_value_uint32(napi_env arg0, napi_value arg1,
                                             uint32_t *arg2) {
  if (g_host.napi_get_value_uint32 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_uint32' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_get_value_uint32(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_value_int64(napi_env arg0, napi_value arg1,
                                            int64_t *arg2) {
  if (g_host.napi_get_value_int64 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_int64' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_get_value_int64(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_value_bool(napi_env arg0, napi_value arg1,
                                           bool *arg2) {
  if (g_host.napi_get_value_bool == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_bool' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_get_value_bool(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_value_string_latin1(napi_env arg0,
                                                    napi_value arg1, char *arg2,
                                                    size_t arg3, size_t *arg4) {
  if (g_host.napi_get_value_string_latin1 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_string_latin1' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_get_value_string_latin1(arg0, arg1, arg2, arg3, arg4);
};

extern "C" napi_status napi_get_value_string_utf8(napi_env arg0,
                                                  napi_value arg1, char *arg2,
                                                  size_t arg3, size_t *arg4) {
  if (g_host.napi_get_value_string_utf8 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_string_utf8' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_get_value_string_utf8(arg0, arg1, arg2, arg3, arg4);
};

extern "C" napi_status napi_get_value_string_utf16(napi_env arg0,
                                                   napi_value arg1,
                                                   char16_t *arg2, size_t arg3,
                                                   size_t *arg4) {
  if (g_host.napi_get_value_string_utf16 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_string_utf16' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_get_value_string_utf16(arg0, arg1, arg2, arg3, arg4);
};

extern "C" napi_status napi_coerce_to_bool(napi_env arg0, napi_value arg1,
                                           napi_value *arg2) {
  if (g_host.napi_coerce_to_bool == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_coerce_to_bool' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_coerce_to_bool(arg0, arg1, arg2);
};

extern "C" napi_status napi_coerce_to_number(napi_env arg0, napi_value arg1,
                                             napi_value *arg2) {
  if (g_host.napi_coerce_to_number == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_coerce_to_number' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_coerce_to_number(arg0, arg1, arg2);
};

extern "C" napi_status napi_coerce_to_object(napi_env arg0, napi_value arg1,
                                             napi_value *arg2) {
  if (g_host.napi_coerce_to_object == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_coerce_to_object' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_coerce_to_object(arg0, arg1, arg2);
};

extern "C" napi_status napi_coerce_to_string(napi_env arg0, napi_value arg1,
                                             napi_value *arg2) {
  if (g_host.napi_coerce_to_string == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_coerce_to_string' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_coerce_to_string(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_prototype(napi_env arg0, napi_value arg1,
                                          napi_value *arg2) {
  if (g_host.napi_get_prototype == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_prototype' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_get_prototype(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_property_names(napi_env arg0, napi_value arg1,
                                               napi_value *arg2) {
  if (g_host.napi_get_property_names == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_property_names' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_get_property_names(arg0, arg1, arg2);
};

extern "C" napi_status napi_set_property(napi_env arg0, napi_value arg1,
                                         napi_value arg2, napi_value arg3) {
  if (g_host.napi_set_property == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_set_property' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_set_property(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_has_property(napi_env arg0, napi_value arg1,
                                         napi_value arg2, bool *arg3) {
  if (g_host.napi_has_property == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_has_property' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_has_property(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_get_property(napi_env arg0, napi_value arg1,
                                         napi_value arg2, napi_value *arg3) {
  if (g_host.napi_get_property == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_property' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_get_property(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_delete_property(napi_env arg0, napi_value arg1,
                                            napi_value arg2, bool *arg3) {
  if (g_host.napi_delete_property == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_delete_property' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_delete_property(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_has_own_property(napi_env arg0, napi_value arg1,
                                             napi_value arg2, bool *arg3) {
  if (g_host.napi_has_own_property == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_has_own_property' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_has_own_property(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_set_named_property(napi_env arg0, napi_value arg1,
                                               const char *arg2,
                                               napi_value arg3) {
  if (g_host.napi_set_named_property == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_set_named_property' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_set_named_property(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_has_named_property(napi_env arg0, napi_value arg1,
                                               const char *arg2, bool *arg3) {
  if (g_host.napi_has_named_property == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_has_named_property' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_has_named_property(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_get_named_property(napi_env arg0, napi_value arg1,
                                               const char *arg2,
                                               napi_value *arg3) {
  if (g_host.napi_get_named_property == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_named_property' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_get_named_property(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_set_element(napi_env arg0, napi_value arg1,
                                        uint32_t arg2, napi_value arg3) {
  if (g_host.napi_set_element == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_set_element' called before it was "
            "injected!\n");
    abort();
  }
  return g_host.napi_set_element(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_has_element(napi_env arg0, napi_value arg1,
                                        uint32_t arg2, bool *arg3) {
  if (g_host.napi_has_element == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_has_element' called before it was "
            "injected!\n");
    abort();
  }
  return g_host.napi_has_element(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_get_element(napi_env arg0, napi_value arg1,
                                        uint32_t arg2, napi_value *arg3) {
  if (g_host.napi_get_element == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_element' called before it was "
            "injected!\n");
    abort();
  }
  return g_host.napi_get_element(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_delete_element(napi_env arg0, napi_value arg1,
                                           uint32_t arg2, bool *arg3) {
  if (g_host.napi_delete_element == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_delete_element' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_delete_element(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_define_properties(
    napi_env arg0, napi_value arg1, size_t arg2,
    const napi_property_descriptor *arg3) {
  if (g_host.napi_define_properties == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_define_properties' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_define_properties(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_is_array(napi_env arg0, napi_value arg1,
                                     bool *arg2) {
  if (g_host.napi_is_array == nullptr) {
    fprintf(
        stderr,
        "Node-API function 'napi_is_array' called before it was injected!\n");
    abort();
  }
  return g_host.napi_is_array(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_array_length(napi_env arg0, napi_value arg1,
                                             uint32_t *arg2) {
  if (g_host.napi_get_array_length == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_array_length' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_get_array_length(arg0, arg1, arg2);
};

extern "C" napi_status napi_strict_equals(napi_env arg0, napi_value arg1,
                                          napi_value arg2, bool *arg3) {
  if (g_host.napi_strict_equals == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_strict_equals' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_strict_equals(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_call_function(napi_env arg0, napi_value arg1,
                                          napi_value arg2, size_t arg3,
                                          const napi_value *arg4,
                                          napi_value *arg5) {
  if (g_host.napi_call_function == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_call_function' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_call_function(arg0, arg1, arg2, arg3, arg4, arg5);
};

extern "C" napi_status napi_new_instance(napi_env arg0, napi_value arg1,
                                         size_t arg2, const napi_value *arg3,
                                         napi_value *arg4) {
  if (g_host.napi_new_instance == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_new_instance' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_new_instance(arg0, arg1, arg2, arg3, arg4);
};

extern "C" napi_status napi_instanceof(napi_env arg0, napi_value arg1,
                                       napi_value arg2, bool *arg3) {
  if (g_host.napi_instanceof == nullptr) {
    fprintf(
        stderr,
        "Node-API function 'napi_instanceof' called before it was injected!\n");
    abort();
  }
  return g_host.napi_instanceof(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_get_cb_info(napi_env arg0, napi_callback_info arg1,
                                        size_t *arg2, napi_value *arg3,
                                        napi_value *arg4, void **arg5) {
  if (g_host.napi_get_cb_info == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_cb_info' called before it was "
            "injected!\n");
    abort();
  }
  return g_host.napi_get_cb_info(arg0, arg1, arg2, arg3, arg4, arg5);
};

extern "C" napi_status napi_get_new_target(napi_env arg0,
                                           napi_callback_info arg1,
                                           napi_value *arg2) {
  if (g_host.napi_get_new_target == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_new_target' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_get_new_target(arg0, arg1, arg2);
};

extern "C" napi_status napi_define_class(napi_env arg0, const char *arg1,
                                         size_t arg2, napi_callback arg3,
                                         void *arg4, size_t arg5,
                                         const napi_property_descriptor *arg6,
                                         napi_value *arg7) {
  if (g_host.napi_define_class == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_define_class' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_define_class(arg0, arg1, arg2, arg3, arg4, arg5, arg6,
                                  arg7);
};

extern "C" napi_status napi_wrap(napi_env arg0, napi_value arg1, void *arg2,
                                 node_api_basic_finalize arg3, void *arg4,
                                 napi_ref *arg5) {
  if (g_host.napi_wrap == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_wrap' called before it was injected!\n");
    abort();
  }
  return g_host.napi_wrap(arg0, arg1, arg2, arg3, arg4, arg5);
};

extern "C" napi_status napi_unwrap(napi_env arg0, napi_value arg1,
                                   void **arg2) {
  if (g_host.napi_unwrap == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_unwrap' called before it was injected!\n");
    abort();
  }
  return g_host.napi_unwrap(arg0, arg1, arg2);
};

extern "C" napi_status napi_remove_wrap(napi_env arg0, napi_value arg1,
                                        void **arg2) {
  if (g_host.napi_remove_wrap == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_remove_wrap' called before it was "
            "injected!\n");
    abort();
  }
  return g_host.napi_remove_wrap(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_external(napi_env arg0, void *arg1,
                                            node_api_basic_finalize arg2,
                                            void *arg3, napi_value *arg4) {
  if (g_host.napi_create_external == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_external' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_external(arg0, arg1, arg2, arg3, arg4);
};

extern "C" napi_status napi_get_value_external(napi_env arg0, napi_value arg1,
                                               void **arg2) {
  if (g_host.napi_get_value_external == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_external' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_get_value_external(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_reference(napi_env arg0, napi_value arg1,
                                             uint32_t arg2, napi_ref *arg3) {
  if (g_host.napi_create_reference == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_reference' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_create_reference(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_delete_reference(napi_env arg0, napi_ref arg1) {
  if (g_host.napi_delete_reference == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_delete_reference' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_delete_reference(arg0, arg1);
};

extern "C" napi_status napi_reference_ref(napi_env arg0, napi_ref arg1,
                                          uint32_t *arg2) {
  if (g_host.napi_reference_ref == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_reference_ref' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_reference_ref(arg0, arg1, arg2);
};

extern "C" napi_status napi_reference_unref(napi_env arg0, napi_ref arg1,
                                            uint32_t *arg2) {
  if (g_host.napi_reference_unref == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_reference_unref' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_reference_unref(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_reference_value(napi_env arg0, napi_ref arg1,
                                                napi_value *arg2) {
  if (g_host.napi_get_reference_value == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_reference_value' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_get_reference_value(arg0, arg1, arg2);
};

extern "C" napi_status napi_open_handle_scope(napi_env arg0,
                                              napi_handle_scope *arg1) {
  if (g_host.napi_open_handle_scope == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_open_handle_scope' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_open_handle_scope(arg0, arg1);
};

extern "C" napi_status napi_close_handle_scope(napi_env arg0,
                                               napi_handle_scope arg1) {
  if (g_host.napi_close_handle_scope == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_close_handle_scope' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_close_handle_scope(arg0, arg1);
};

extern "C" napi_status napi_open_escapable_handle_scope(
    napi_env arg0, napi_escapable_handle_scope *arg1) {
  if (g_host.napi_open_escapable_handle_scope == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_open_escapable_handle_scope' "
            "called before it was injected!\n");
    abort();
  }
  return g_host.napi_open_escapable_handle_scope(arg0, arg1);
};

extern "C" napi_status napi_close_escapable_handle_scope(
    napi_env arg0, napi_escapable_handle_scope arg1) {
  if (g_host.napi_close_escapable_handle_scope == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_close_escapable_handle_scope' "
            "called before it was injected!\n");
    abort();
  }
  return g_host.napi_close_escapable_handle_scope(arg0, arg1);
};

extern "C" napi_status napi_escape_handle(napi_env arg0,
                                          napi_escapable_handle_scope arg1,
                                          napi_value arg2, napi_value *arg3) {
  if (g_host.napi_escape_handle == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_escape_handle' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_escape_handle(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_throw(napi_env arg0, napi_value arg1) {
  if (g_host.napi_throw == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_throw' called before it was injected!\n");
    abort();
  }
  return g_host.napi_throw(arg0, arg1);
};

extern "C" napi_status napi_throw_error(napi_env arg0, const char *arg1,
                                        const char *arg2) {
  if (g_host.napi_throw_error == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_throw_error' called before it was "
            "injected!\n");
    abort();
  }
  return g_host.napi_throw_error(arg0, arg1, arg2);
};

extern "C" napi_status napi_throw_type_error(napi_env arg0, const char *arg1,
                                             const char *arg2) {
  if (g_host.napi_throw_type_error == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_throw_type_error' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_throw_type_error(arg0, arg1, arg2);
};

extern "C" napi_status napi_throw_range_error(napi_env arg0, const char *arg1,
                                              const char *arg2) {
  if (g_host.napi_throw_range_error == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_throw_range_error' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_throw_range_error(arg0, arg1, arg2);
};

extern "C" napi_status napi_is_error(napi_env arg0, napi_value arg1,
                                     bool *arg2) {
  if (g_host.napi_is_error == nullptr) {
    fprintf(
        stderr,
        "Node-API function 'napi_is_error' called before it was injected!\n");
    abort();
  }
  return g_host.napi_is_error(arg0, arg1, arg2);
};

extern "C" napi_status napi_is_exception_pending(napi_env arg0, bool *arg1) {
  if (g_host.napi_is_exception_pending == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_is_exception_pending' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_is_exception_pending(arg0, arg1);
};

extern "C" napi_status napi_get_and_clear_last_exception(napi_env arg0,
                                                         napi_value *arg1) {
  if (g_host.napi_get_and_clear_last_exception == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_and_clear_last_exception' "
            "called before it was injected!\n");
    abort();
  }
  return g_host.napi_get_and_clear_last_exception(arg0, arg1);
};

extern "C" napi_status napi_is_arraybuffer(napi_env arg0, napi_value arg1,
                                           bool *arg2) {
  if (g_host.napi_is_arraybuffer == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_is_arraybuffer' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_is_arraybuffer(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_arraybuffer(napi_env arg0, size_t arg1,
                                               void **arg2, napi_value *arg3) {
  if (g_host.napi_create_arraybuffer == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_arraybuffer' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_create_arraybuffer(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_create_external_arraybuffer(
    napi_env arg0, void *arg1, size_t arg2, node_api_basic_finalize arg3,
    void *arg4, napi_value *arg5) {
  if (g_host.napi_create_external_arraybuffer == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_external_arraybuffer' "
            "called before it was injected!\n");
    abort();
  }
  return g_host.napi_create_external_arraybuffer(arg0, arg1, arg2, arg3, arg4,
                                                 arg5);
};

extern "C" napi_status napi_get_arraybuffer_info(napi_env arg0, napi_value arg1,
                                                 void **arg2, size_t *arg3) {
  if (g_host.napi_get_arraybuffer_info == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_arraybuffer_info' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_get_arraybuffer_info(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_is_typedarray(napi_env arg0, napi_value arg1,
                                          bool *arg2) {
  if (g_host.napi_is_typedarray == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_is_typedarray' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_is_typedarray(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_typedarray(napi_env arg0,
                                              napi_typedarray_type arg1,
                                              size_t arg2, napi_value arg3,
                                              size_t arg4, napi_value *arg5) {
  if (g_host.napi_create_typedarray == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_typedarray' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_create_typedarray(arg0, arg1, arg2, arg3, arg4, arg5);
};

extern "C" napi_status napi_get_typedarray_info(napi_env arg0, napi_value arg1,
                                                napi_typedarray_type *arg2,
                                                size_t *arg3, void **arg4,
                                                napi_value *arg5,
                                                size_t *arg6) {
  if (g_host.napi_get_typedarray_info == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_typedarray_info' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_get_typedarray_info(arg0, arg1, arg2, arg3, arg4, arg5,
                                         arg6);
};

extern "C" napi_status napi_create_dataview(napi_env arg0, size_t arg1,
                                            napi_value arg2, size_t arg3,
                                            napi_value *arg4) {
  if (g_host.napi_create_dataview == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_dataview' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_dataview(arg0, arg1, arg2, arg3, arg4);
};

extern "C" napi_status napi_is_dataview(napi_env arg0, napi_value arg1,
                                        bool *arg2) {
  if (g_host.napi_is_dataview == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_is_dataview' called before it was "
            "injected!\n");
    abort();
  }
  return g_host.napi_is_dataview(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_dataview_info(napi_env arg0, napi_value arg1,
                                              size_t *arg2, void **arg3,
                                              napi_value *arg4, size_t *arg5) {
  if (g_host.napi_get_dataview_info == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_dataview_info' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_get_dataview_info(arg0, arg1, arg2, arg3, arg4, arg5);
};

extern "C" napi_status napi_get_version(node_api_basic_env arg0,
                                        uint32_t *arg1) {
  if (g_host.napi_get_version == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_version' called before it was "
            "injected!\n");
    abort();
  }
  return g_host.napi_get_version(arg0, arg1);
};

extern "C" napi_status napi_create_promise(napi_env arg0, napi_deferred *arg1,
                                           napi_value *arg2) {
  if (g_host.napi_create_promise == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_promise' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_promise(arg0, arg1, arg2);
};

extern "C" napi_status napi_resolve_deferred(napi_env arg0, napi_deferred arg1,
                                             napi_value arg2) {
  if (g_host.napi_resolve_deferred == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_resolve_deferred' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_resolve_deferred(arg0, arg1, arg2);
};

extern "C" napi_status napi_reject_deferred(napi_env arg0, napi_deferred arg1,
                                            napi_value arg2) {
  if (g_host.napi_reject_deferred == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_reject_deferred' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_reject_deferred(arg0, arg1, arg2);
};

extern "C" napi_status napi_is_promise(napi_env arg0, napi_value arg1,
                                       bool *arg2) {
  if (g_host.napi_is_promise == nullptr) {
    fprintf(
        stderr,
        "Node-API function 'napi_is_promise' called before it was injected!\n");
    abort();
  }
  return g_host.napi_is_promise(arg0, arg1, arg2);
};

extern "C" napi_status napi_run_script(napi_env arg0, napi_value arg1,
                                       napi_value *arg2) {
  if (g_host.napi_run_script == nullptr) {
    fprintf(
        stderr,
        "Node-API function 'napi_run_script' called before it was injected!\n");
    abort();
  }
  return g_host.napi_run_script(arg0, arg1, arg2);
};

extern "C" napi_status napi_adjust_external_memory(node_api_basic_env arg0,
                                                   int64_t arg1,
                                                   int64_t *arg2) {
  if (g_host.napi_adjust_external_memory == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_adjust_external_memory' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_adjust_external_memory(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_date(napi_env arg0, double arg1,
                                        napi_value *arg2) {
  if (g_host.napi_create_date == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_date' called before it was "
            "injected!\n");
    abort();
  }
  return g_host.napi_create_date(arg0, arg1, arg2);
};

extern "C" napi_status napi_is_date(napi_env arg0, napi_value arg1,
                                    bool *arg2) {
  if (g_host.napi_is_date == nullptr) {
    fprintf(
        stderr,
        "Node-API function 'napi_is_date' called before it was injected!\n");
    abort();
  }
  return g_host.napi_is_date(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_date_value(napi_env arg0, napi_value arg1,
                                           double *arg2) {
  if (g_host.napi_get_date_value == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_date_value' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_get_date_value(arg0, arg1, arg2);
};

extern "C" napi_status napi_add_finalizer(napi_env arg0, napi_value arg1,
                                          void *arg2,
                                          node_api_basic_finalize arg3,
                                          void *arg4, napi_ref *arg5) {
  if (g_host.napi_add_finalizer == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_add_finalizer' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_add_finalizer(arg0, arg1, arg2, arg3, arg4, arg5);
};

extern "C" napi_status napi_create_bigint_int64(napi_env arg0, int64_t arg1,
                                                napi_value *arg2) {
  if (g_host.napi_create_bigint_int64 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_bigint_int64' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_create_bigint_int64(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_bigint_uint64(napi_env arg0, uint64_t arg1,
                                                 napi_value *arg2) {
  if (g_host.napi_create_bigint_uint64 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_bigint_uint64' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_create_bigint_uint64(arg0, arg1, arg2);
};

extern "C" napi_status napi_create_bigint_words(napi_env arg0, int arg1,
                                                size_t arg2,
                                                const uint64_t *arg3,
                                                napi_value *arg4) {
  if (g_host.napi_create_bigint_words == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_bigint_words' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_create_bigint_words(arg0, arg1, arg2, arg3, arg4);
};

extern "C" napi_status napi_get_value_bigint_int64(napi_env arg0,
                                                   napi_value arg1,
                                                   int64_t *arg2, bool *arg3) {
  if (g_host.napi_get_value_bigint_int64 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_bigint_int64' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_get_value_bigint_int64(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_get_value_bigint_uint64(napi_env arg0,
                                                    napi_value arg1,
                                                    uint64_t *arg2,
                                                    bool *arg3) {
  if (g_host.napi_get_value_bigint_uint64 == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_bigint_uint64' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_get_value_bigint_uint64(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_get_value_bigint_words(napi_env arg0,
                                                   napi_value arg1, int *arg2,
                                                   size_t *arg3,
                                                   uint64_t *arg4) {
  if (g_host.napi_get_value_bigint_words == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_value_bigint_words' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_get_value_bigint_words(arg0, arg1, arg2, arg3, arg4);
};

extern "C" napi_status napi_get_all_property_names(
    napi_env arg0, napi_value arg1, napi_key_collection_mode arg2,
    napi_key_filter arg3, napi_key_conversion arg4, napi_value *arg5) {
  if (g_host.napi_get_all_property_names == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_all_property_names' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_get_all_property_names(arg0, arg1, arg2, arg3, arg4, arg5);
};

extern "C" napi_status napi_set_instance_data(node_api_basic_env arg0,
                                              void *arg1, napi_finalize arg2,
                                              void *arg3) {
  if (g_host.napi_set_instance_data == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_set_instance_data' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_set_instance_data(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_get_instance_data(node_api_basic_env arg0,
                                              void **arg1) {
  if (g_host.napi_get_instance_data == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_instance_data' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_get_instance_data(arg0, arg1);
};

extern "C" napi_status napi_detach_arraybuffer(napi_env arg0, napi_value arg1) {
  if (g_host.napi_detach_arraybuffer == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_detach_arraybuffer' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_detach_arraybuffer(arg0, arg1);
};

extern "C" napi_status napi_is_detached_arraybuffer(napi_env arg0,
                                                    napi_value arg1,
                                                    bool *arg2) {
  if (g_host.napi_is_detached_arraybuffer == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_is_detached_arraybuffer' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_is_detached_arraybuffer(arg0, arg1, arg2);
};

extern "C" napi_status napi_type_tag_object(napi_env arg0, napi_value arg1,
                                            const napi_type_tag *arg2) {
  if (g_host.napi_type_tag_object == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_type_tag_object' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_type_tag_object(arg0, arg1, arg2);
};

extern "C" napi_status napi_check_object_type_tag(napi_env arg0,
                                                  napi_value arg1,
                                                  const napi_type_tag *arg2,
                                                  bool *arg3) {
  if (g_host.napi_check_object_type_tag == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_check_object_type_tag' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_check_object_type_tag(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_object_freeze(napi_env arg0, napi_value arg1) {
  if (g_host.napi_object_freeze == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_object_freeze' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_object_freeze(arg0, arg1);
};

extern "C" napi_status napi_object_seal(napi_env arg0, napi_value arg1) {
  if (g_host.napi_object_seal == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_object_seal' called before it was "
            "injected!\n");
    abort();
  }
  return g_host.napi_object_seal(arg0, arg1);
};

extern "C" void napi_module_register(napi_module *arg0) {
  if (g_host.napi_module_register == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_module_register' called before it "
            "was injected!\n");
    abort();
  }
  g_host.napi_module_register(arg0);
};

extern "C" void napi_fatal_error(const char *arg0, size_t arg1,
                                 const char *arg2, size_t arg3) {
  if (g_host.napi_fatal_error == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_fatal_error' called before it was "
            "injected!\n");
    abort();
  }
  g_host.napi_fatal_error(arg0, arg1, arg2, arg3);
  WEAK_NODE_API_UNREACHABLE;
};

extern "C" napi_status napi_async_init(napi_env arg0, napi_value arg1,
                                       napi_value arg2,
                                       napi_async_context *arg3) {
  if (g_host.napi_async_init == nullptr) {
    fprintf(
        stderr,
        "Node-API function 'napi_async_init' called before it was injected!\n");
    abort();
  }
  return g_host.napi_async_init(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_async_destroy(napi_env arg0,
                                          napi_async_context arg1) {
  if (g_host.napi_async_destroy == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_async_destroy' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_async_destroy(arg0, arg1);
};

extern "C" napi_status napi_make_callback(napi_env arg0,
                                          napi_async_context arg1,
                                          napi_value arg2, napi_value arg3,
                                          size_t arg4, const napi_value *arg5,
                                          napi_value *arg6) {
  if (g_host.napi_make_callback == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_make_callback' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_make_callback(arg0, arg1, arg2, arg3, arg4, arg5, arg6);
};

extern "C" napi_status napi_create_buffer(napi_env arg0, size_t arg1,
                                          void **arg2, napi_value *arg3) {
  if (g_host.napi_create_buffer == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_buffer' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_create_buffer(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_create_external_buffer(napi_env arg0, size_t arg1,
                                                   void *arg2,
                                                   node_api_basic_finalize arg3,
                                                   void *arg4,
                                                   napi_value *arg5) {
  if (g_host.napi_create_external_buffer == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_external_buffer' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_create_external_buffer(arg0, arg1, arg2, arg3, arg4, arg5);
};

extern "C" napi_status napi_create_buffer_copy(napi_env arg0, size_t arg1,
                                               const void *arg2, void **arg3,
                                               napi_value *arg4) {
  if (g_host.napi_create_buffer_copy == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_buffer_copy' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_create_buffer_copy(arg0, arg1, arg2, arg3, arg4);
};

extern "C" napi_status napi_is_buffer(napi_env arg0, napi_value arg1,
                                      bool *arg2) {
  if (g_host.napi_is_buffer == nullptr) {
    fprintf(
        stderr,
        "Node-API function 'napi_is_buffer' called before it was injected!\n");
    abort();
  }
  return g_host.napi_is_buffer(arg0, arg1, arg2);
};

extern "C" napi_status napi_get_buffer_info(napi_env arg0, napi_value arg1,
                                            void **arg2, size_t *arg3) {
  if (g_host.napi_get_buffer_info == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_buffer_info' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_get_buffer_info(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_create_async_work(napi_env arg0, napi_value arg1,
                                              napi_value arg2,
                                              napi_async_execute_callback arg3,
                                              napi_async_complete_callback arg4,
                                              void *arg5,
                                              napi_async_work *arg6) {
  if (g_host.napi_create_async_work == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_async_work' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_create_async_work(arg0, arg1, arg2, arg3, arg4, arg5,
                                       arg6);
};

extern "C" napi_status napi_delete_async_work(napi_env arg0,
                                              napi_async_work arg1) {
  if (g_host.napi_delete_async_work == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_delete_async_work' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_delete_async_work(arg0, arg1);
};

extern "C" napi_status napi_queue_async_work(node_api_basic_env arg0,
                                             napi_async_work arg1) {
  if (g_host.napi_queue_async_work == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_queue_async_work' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_queue_async_work(arg0, arg1);
};

extern "C" napi_status napi_cancel_async_work(node_api_basic_env arg0,
                                              napi_async_work arg1) {
  if (g_host.napi_cancel_async_work == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_cancel_async_work' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_cancel_async_work(arg0, arg1);
};

extern "C" napi_status napi_get_node_version(node_api_basic_env arg0,
                                             const napi_node_version **arg1) {
  if (g_host.napi_get_node_version == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_node_version' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_get_node_version(arg0, arg1);
};

extern "C" napi_status napi_get_uv_event_loop(node_api_basic_env arg0,
                                              struct uv_loop_s **arg1) {
  if (g_host.napi_get_uv_event_loop == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_uv_event_loop' called before "
            "it was injected!\n");
    abort();
  }
  return g_host.napi_get_uv_event_loop(arg0, arg1);
};

extern "C" napi_status napi_fatal_exception(napi_env arg0, napi_value arg1) {
  if (g_host.napi_fatal_exception == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_fatal_exception' called before it "
            "was injected!\n");
    abort();
  }
  return g_host.napi_fatal_exception(arg0, arg1);
};

extern "C" napi_status napi_add_env_cleanup_hook(node_api_basic_env arg0,
                                                 napi_cleanup_hook arg1,
                                                 void *arg2) {
  if (g_host.napi_add_env_cleanup_hook == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_add_env_cleanup_hook' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_add_env_cleanup_hook(arg0, arg1, arg2);
};

extern "C" napi_status napi_remove_env_cleanup_hook(node_api_basic_env arg0,
                                                    napi_cleanup_hook arg1,
                                                    void *arg2) {
  if (g_host.napi_remove_env_cleanup_hook == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_remove_env_cleanup_hook' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_remove_env_cleanup_hook(arg0, arg1, arg2);
};

extern "C" napi_status napi_open_callback_scope(napi_env arg0, napi_value arg1,
                                                napi_async_context arg2,
                                                napi_callback_scope *arg3) {
  if (g_host.napi_open_callback_scope == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_open_callback_scope' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_open_callback_scope(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_close_callback_scope(napi_env arg0,
                                                 napi_callback_scope arg1) {
  if (g_host.napi_close_callback_scope == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_close_callback_scope' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_close_callback_scope(arg0, arg1);
};

extern "C" napi_status napi_create_threadsafe_function(
    napi_env arg0, napi_value arg1, napi_value arg2, napi_value arg3,
    size_t arg4, size_t arg5, void *arg6, napi_finalize arg7, void *arg8,
    napi_threadsafe_function_call_js arg9, napi_threadsafe_function *arg10) {
  if (g_host.napi_create_threadsafe_function == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_create_threadsafe_function' "
            "called before it was injected!\n");
    abort();
  }
  return g_host.napi_create_threadsafe_function(
      arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10);
};

extern "C" napi_status napi_get_threadsafe_function_context(
    napi_threadsafe_function arg0, void **arg1) {
  if (g_host.napi_get_threadsafe_function_context == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_get_threadsafe_function_context' "
            "called before it was injected!\n");
    abort();
  }
  return g_host.napi_get_threadsafe_function_context(arg0, arg1);
};

extern "C" napi_status napi_call_threadsafe_function(
    napi_threadsafe_function arg0, void *arg1,
    napi_threadsafe_function_call_mode arg2) {
  if (g_host.napi_call_threadsafe_function == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_call_threadsafe_function' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_call_threadsafe_function(arg0, arg1, arg2);
};

extern "C" napi_status napi_acquire_threadsafe_function(
    napi_threadsafe_function arg0) {
  if (g_host.napi_acquire_threadsafe_function == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_acquire_threadsafe_function' "
            "called before it was injected!\n");
    abort();
  }
  return g_host.napi_acquire_threadsafe_function(arg0);
};

extern "C" napi_status napi_release_threadsafe_function(
    napi_threadsafe_function arg0, napi_threadsafe_function_release_mode arg1) {
  if (g_host.napi_release_threadsafe_function == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_release_threadsafe_function' "
            "called before it was injected!\n");
    abort();
  }
  return g_host.napi_release_threadsafe_function(arg0, arg1);
};

extern "C" napi_status napi_unref_threadsafe_function(
    node_api_basic_env arg0, napi_threadsafe_function arg1) {
  if (g_host.napi_unref_threadsafe_function == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_unref_threadsafe_function' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_unref_threadsafe_function(arg0, arg1);
};

extern "C" napi_status napi_ref_threadsafe_function(
    node_api_basic_env arg0, napi_threadsafe_function arg1) {
  if (g_host.napi_ref_threadsafe_function == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_ref_threadsafe_function' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_ref_threadsafe_function(arg0, arg1);
};

extern "C" napi_status napi_add_async_cleanup_hook(
    node_api_basic_env arg0, napi_async_cleanup_hook arg1, void *arg2,
    napi_async_cleanup_hook_handle *arg3) {
  if (g_host.napi_add_async_cleanup_hook == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_add_async_cleanup_hook' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_add_async_cleanup_hook(arg0, arg1, arg2, arg3);
};

extern "C" napi_status napi_remove_async_cleanup_hook(
    napi_async_cleanup_hook_handle arg0) {
  if (g_host.napi_remove_async_cleanup_hook == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_remove_async_cleanup_hook' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_remove_async_cleanup_hook(arg0);
};

extern "C" napi_module *napi_find_module_weak(const char *name) {
  if (g_host.napi_find_module_weak == nullptr) {
    fprintf(stderr,
            "Node-API function 'napi_find_module_weak' called "
            "before it was injected!\n");
    abort();
  }
  return g_host.napi_find_module_weak(name);
};

#if defined(USE_WEAK_SUFFIX_NAPI)
#include "../headers/weak_napi_undefs.h"
#endif
