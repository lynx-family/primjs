# Copyright (c) 2025 The Lynx Authors.
# Licensed under the Apache License Version 2.0 that can be found in the LICENSE file in the root directory of this source tree.
# Derived work includes upstream generated headers/content; see NOTICE.md for details.

cmake_minimum_required(VERSION 3.25)
project(weak-node-api)

# Read version from package.json
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/package.json" PACKAGE_JSON)
string(JSON PACKAGE_VERSION GET ${PACKAGE_JSON} version)

# Enable export of all symbols on Windows when not using explicit __declspec(dllexport)
if (WIN32)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

add_library(${PROJECT_NAME} SHARED)

set(INCLUDE_DIR "include")
set(GENERATED_SOURCE_DIR "generated")

# Public headers and generated sources
# WeakNodeAPI is a shared library; headers are exposed via FILE_SET for downstream usage.
target_sources(${PROJECT_NAME}
  PUBLIC
    ${GENERATED_SOURCE_DIR}/weak_node_api.cpp
  PUBLIC FILE_SET HEADERS
  BASE_DIRS ${GENERATED_SOURCE_DIR} ${INCLUDE_DIR} FILES
    ${GENERATED_SOURCE_DIR}/weak_node_api.hpp
    ${GENERATED_SOURCE_DIR}/NodeApiHost.hpp
    ${INCLUDE_DIR}/js_native_api_types.h
    ${INCLUDE_DIR}/js_native_api.h
    ${INCLUDE_DIR}/node_api_types.h
    ${INCLUDE_DIR}/node_api.h
    ${INCLUDE_DIR}/napi.h
    ${INCLUDE_DIR}/napi-inl.h
    ${INCLUDE_DIR}/napi-inl.deprecated.h
    ${INCLUDE_DIR}/weak_napi_defines.h
    ${INCLUDE_DIR}/weak_napi_undefs.h
)

# Include directories for consumers
# Public so that downstream projects can consume headers directly
# (especially when adding this directory via add_subdirectory).
target_include_directories(${PROJECT_NAME}
  PUBLIC
    ${INCLUDE_DIR}
    ${GENERATED_SOURCE_DIR}
)

# Apple (macOS) framework configuration
if(APPLE)
  # Produce a Framework bundle with public headers
  get_target_property(PUBLIC_HEADER_FILES ${PROJECT_NAME} HEADER_SET)
  set_target_properties(${PROJECT_NAME} PROPERTIES
    FRAMEWORK TRUE
    MACOSX_FRAMEWORK_IDENTIFIER com.lynx.${PROJECT_NAME}
    MACOSX_FRAMEWORK_SHORT_VERSION_STRING ${PACKAGE_VERSION}
    MACOSX_FRAMEWORK_BUNDLE_VERSION ${PACKAGE_VERSION}
    VERSION ${PACKAGE_VERSION}
    XCODE_ATTRIBUTE_SKIP_INSTALL NO
    PUBLIC_HEADER "${PUBLIC_HEADER_FILES}"
  )
endif()

# Windows (MSVC x64) specific settings
if(WIN32)
  # Name the outputs explicitly and configure per-config output directories
  set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME "WeakNodeAPI"
    RUNTIME_OUTPUT_DIRECTORY_DEBUG   "${CMAKE_CURRENT_SOURCE_DIR}/build/win/x64/Debug"
    RUNTIME_OUTPUT_DIRECTORY_RELEASE "${CMAKE_CURRENT_SOURCE_DIR}/build/win/x64/Release"
    LIBRARY_OUTPUT_DIRECTORY_DEBUG   "${CMAKE_CURRENT_SOURCE_DIR}/build/win/x64/Debug"
    LIBRARY_OUTPUT_DIRECTORY_RELEASE "${CMAKE_CURRENT_SOURCE_DIR}/build/win/x64/Release"
    ARCHIVE_OUTPUT_DIRECTORY_DEBUG   "${CMAKE_CURRENT_SOURCE_DIR}/build/win/x64/Debug"
    ARCHIVE_OUTPUT_DIRECTORY_RELEASE "${CMAKE_CURRENT_SOURCE_DIR}/build/win/x64/Release"
  )

  # Common Windows compile definitions to minimize header bloat/conflicts
  target_compile_definitions(${PROJECT_NAME} PRIVATE
    WIN32_LEAN_AND_MEAN
    NOMINMAX
  )
endif()

# C++ standard and PIC
set_property(TARGET ${PROJECT_NAME} PROPERTY POSITION_INDEPENDENT_CODE ON)
# C++20 is needed to use designated initializers
target_compile_features(${PROJECT_NAME} PRIVATE cxx_std_20)

# Node-API version selection
target_compile_definitions(${PROJECT_NAME} PRIVATE NAPI_VERSION=8)

# Compiler options (warnings as errors)
target_compile_options(${PROJECT_NAME} PRIVATE
  $<$<CXX_COMPILER_ID:MSVC>:/W4 /WX>
  $<$<NOT:$<CXX_COMPILER_ID:MSVC>>:-Wall -Wextra -Werror>
)

option(BUILD_TESTS "Build the tests" OFF)
if(BUILD_TESTS)
  enable_testing()
  add_subdirectory(tests)
endif()
