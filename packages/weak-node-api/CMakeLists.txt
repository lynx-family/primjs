# Copyright (c) 2025 The Lynx Authors.
# Licensed under the Apache License Version 2.0 that can be found in the LICENSE file in the root directory of this source tree.
# Derived work includes upstream generated headers/content; see NOTICE.md for details.

cmake_minimum_required(VERSION 3.24)
project(weak-node-api)

# Read version from package.json
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/package.json" PACKAGE_JSON)
string(JSON PACKAGE_VERSION GET ${PACKAGE_JSON} version)

# Enable export of all symbols on Windows when not using explicit __declspec(dllexport)
if (WIN32)
  set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)
endif()

add_library(${PROJECT_NAME} SHARED)

set(INCLUDE_DIR "headers")
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
    shim
)

# Apple (macOS) shared library configuration (non-Framework)
if(APPLE)
  # Produce a dylib with an explicit output name and per-config output dirs
  # The actual file on disk will be "libweak-node-api.dylib" under the configured
  # output directories below. For single-arch builds, we let Xcode handle
  # output to its default location to avoid conflicts.
  set_target_properties(${PROJECT_NAME} PROPERTIES
    OUTPUT_NAME "libweak-node-api"
    PREFIX ""
    # macOS-specific dylib properties
    INSTALL_NAME_DIR "@rpath"
    MACOSX_RPATH TRUE
    BUILD_WITH_INSTALL_RPATH TRUE
  )
  
  # Add linker flags to ensure proper dylib exports and compatibility
  target_link_options(${PROJECT_NAME} PRIVATE
    "-Wl,-export_dynamic"
    "-Wl,-dead_strip_dylibs"
    "-Wl,-no_deduplicate"
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

# Weak suffix symbol compile-time gate. Headers default to weak suffix
# remapping; pass USE_WEAK_SUFFIX_NAPI=0 only for the legacy non-renamed
# variant.
option(USE_WEAK_SUFFIX_NAPI "Enable weak suffix symbol remapping when building weak-node-api" ON)
if(USE_WEAK_SUFFIX_NAPI)
  set(WEAK_NODE_API_USE_WEAK_SUFFIX_NAPI_VALUE 1)
else()
  set(WEAK_NODE_API_USE_WEAK_SUFFIX_NAPI_VALUE 0)
endif()
target_compile_definitions(${PROJECT_NAME} PUBLIC
  USE_WEAK_SUFFIX_NAPI=${WEAK_NODE_API_USE_WEAK_SUFFIX_NAPI_VALUE}
)

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
