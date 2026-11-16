# Copyright 2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

# The standalone CMake runner validates the PrimJS backend. GN also runs V8
# and, on macOS, JavaScriptCore.
if(NOT DEFINED NAPI_ADAPTER_GTEST_SOURCE_DIR)
  set(NAPI_ADAPTER_GTEST_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../../third_party/googletest")
  if(NOT EXISTS "${NAPI_ADAPTER_GTEST_SOURCE_DIR}/CMakeLists.txt")
    set(NAPI_ADAPTER_GTEST_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../third_party/googletest")
  endif()
endif()
add_subdirectory("${NAPI_ADAPTER_GTEST_SOURCE_DIR}" "${CMAKE_CURRENT_BINARY_DIR}/googletest")
find_package(Threads REQUIRED)

set(adapter_test_sources
  napi_adapter_unittests.cc
  js_native_api/2_function_arguments/binding.cc
  js_native_api/3_callbacks/binding.cc
  js_native_api/3_callbacks_primjs_extra_tests/binding.cc
  js_native_api/4_object_factory/binding.cc
  js_native_api/5_function_factory/binding.cc
  js_native_api/6_object_wrap/myobject.cc
  js_native_api/7_factory_wrap/binding.cc
  js_native_api/7_factory_wrap/myobject.cc
  js_native_api/8_passing_wrapped/binding.cc
  js_native_api/8_passing_wrapped/myobject.cc
  js_native_api/common.c
  js_native_api/test_array/test_array.cc
  js_native_api/test_bigint/test_bigint.c
  js_native_api/test_class_inheritance/test_class_inheritance.c
  js_native_api/test_constructor/test_constructor.c
  js_native_api/test_conversions/test_conversions.c
  js_native_api/test_conversions/test_null.c
  js_native_api/test_dataview/test_dataview.c
  js_native_api/test_date/test_date.c
  js_native_api/test_error/test_error.c
  js_native_api/test_exception/test_exception.c
  js_native_api/test_function/test_function.c
  js_native_api/test_general/test_general.c
  js_native_api/test_handle_scope/test_handle_scope.c
  js_native_api/test_instance_data/test_instance_data.c
  js_native_api/test_new_target/binding.cc
  js_native_api/test_number/test_number.c
  js_native_api/test_object/test_object.c
  js_native_api/test_object/test_null.c
  js_native_api/test_promise/test_promise.c
  js_native_api/test_properties/test_properties.c
  js_native_api/test_reference/test_reference.c
  js_native_api/test_string/test_string.c
  js_native_api/test_symbol/test_symbol.c
  js_native_api/test_threadsafe_function/test_threadsafe_function.cc
  js_native_api/test_typedarray/test_typedarray.c
)
foreach(source IN LISTS adapter_test_sources)
  get_filename_component(module_dir "${source}" DIRECTORY)
  get_filename_component(module_name "${module_dir}" NAME)
  if(NOT module_dir STREQUAL "")
    set_source_files_properties("${source}" PROPERTIES COMPILE_DEFINITIONS "NAPI_MODULE_NAME=${module_name}")
  endif()
endforeach()
add_executable(napi_adapter_unittest ${adapter_test_sources}
  ../../src/napi/adapter/js_native_api_adapter.cc
  ../../src/napi/adapter/weak_napi_host_generator.cc
  ../../src/napi/adapter/weak_napi_host_injector.cc
  ../../packages/weak-node-api/generated/weak_node_api.cpp
  ../../src/basic/log/primjs_logging.cc)
target_compile_definitions(napi_adapter_unittest PRIVATE JS_ENGINE_QJS USE_WEAK_SUFFIX_NAPI
  NAPI_ADAPTER_TEST_ROOT="${CMAKE_CURRENT_SOURCE_DIR}/js_native_api")
target_include_directories(napi_adapter_unittest PRIVATE
  ../../src ../../src/interpreter ../../src/napi ../../src/napi/adapter
  ../../src/napi/env ../../src/napi/internal ../../src/napi/common
  ../../packages/weak-node-api ../../packages/weak-node-api/headers
  ../../packages/weak-node-api/generated ../../packages/weak-node-api/shim
  ../../packages/weak-node-api/defs_header)
target_link_libraries(napi_adapter_unittest PRIVATE napi_static quickjs gtest_main Threads::Threads ${CMAKE_DL_LIBS})
set_target_properties(napi_adapter_unittest PROPERTIES RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")
