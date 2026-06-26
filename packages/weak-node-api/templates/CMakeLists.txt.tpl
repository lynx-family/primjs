cmake_minimum_required(VERSION 3.22)
project(__PROJECT_NAME__ LANGUAGES C CXX)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
option(USE_WEAK_SUFFIX_NAPI "Enable weak suffix remapping for Node-API" OFF)
set(LYNX_ADDON_DIST_DIR "${CMAKE_CURRENT_LIST_DIR}/dist" CACHE PATH
    "Output directory for packaged addon artifacts")
set(_WEAK_NODE_API_CONFIG "${CMAKE_CURRENT_LIST_DIR}/node_modules/@lynx-js/weak-node-api/weak-node-api-config.cmake")
if(NOT EXISTS "${_WEAK_NODE_API_CONFIG}")
  message(FATAL_ERROR "weak-node-api-config.cmake not found: ${_WEAK_NODE_API_CONFIG}. Run npm install first.")
endif()
include("${_WEAK_NODE_API_CONFIG}")

function(_lynx_set_output_dir target property value)
  set_target_properties(${target} PROPERTIES ${property} "${value}")
  foreach(_cfg Debug Release RelWithDebInfo MinSizeRel)
    string(TOUPPER "${_cfg}" _cfg_upper)
    set_target_properties(${target} PROPERTIES ${property}_${_cfg_upper} "${value}")
  endforeach()
endfunction()

set(_LYNX_ADDON_LIBRARY_TYPE SHARED)
if(APPLE)
  set(_LYNX_ADDON_LIBRARY_TYPE STATIC)
endif()
add_library(__PROJECT_NAME__ ${_LYNX_ADDON_LIBRARY_TYPE} src/addon.cc src/addon.h src/addon_use.h)
target_include_directories(__PROJECT_NAME__ PUBLIC "${CMAKE_CURRENT_LIST_DIR}/src")
target_link_libraries(__PROJECT_NAME__ PUBLIC weak-node-api-headers)
target_compile_definitions(__PROJECT_NAME__ PRIVATE NAPI_VERSION=8)
set(_LYNX_ENABLE_WEAK_SUFFIX ${USE_WEAK_SUFFIX_NAPI})
if(CMAKE_SYSTEM_NAME STREQUAL "OHOS")
  set(_LYNX_ENABLE_WEAK_SUFFIX ON)
endif()
if(APPLE AND NOT CMAKE_SYSTEM_NAME STREQUAL "iOS" AND NOT CMAKE_OSX_SYSROOT MATCHES "iphone")
  set(_LYNX_ENABLE_WEAK_SUFFIX ON)
endif()
if(_LYNX_ENABLE_WEAK_SUFFIX)
  target_compile_definitions(__PROJECT_NAME__ PRIVATE USE_WEAK_SUFFIX_NAPI)
endif()
if(ANDROID)
  set(_LYNX_PLATFORM_OUT_DIR "${LYNX_ADDON_DIST_DIR}/android/${ANDROID_ABI}")
  add_custom_target(fetch_napi_adapter ALL
    COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_CURRENT_LIST_DIR}/vendor/android"
    COMMAND node "${CMAKE_CURRENT_LIST_DIR}/scripts/fetch-libs.mjs" --platform android --out "${CMAKE_CURRENT_LIST_DIR}/vendor/android"
    BYPRODUCTS "${CMAKE_CURRENT_LIST_DIR}/vendor/android/libnapi_adapter.so"
    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
  )
  add_library(napi_adapter SHARED IMPORTED)
  set_target_properties(napi_adapter PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/vendor/android/libnapi_adapter.so")
  add_dependencies(__PROJECT_NAME__ fetch_napi_adapter)
  target_link_libraries(__PROJECT_NAME__ PRIVATE napi_adapter)
  set_target_properties(__PROJECT_NAME__ PROPERTIES PREFIX "lib" SUFFIX ".so")
  _lynx_set_output_dir(__PROJECT_NAME__ LIBRARY_OUTPUT_DIRECTORY "${_LYNX_PLATFORM_OUT_DIR}")
  _lynx_set_output_dir(__PROJECT_NAME__ RUNTIME_OUTPUT_DIRECTORY "${_LYNX_PLATFORM_OUT_DIR}")
elseif(CMAKE_SYSTEM_NAME STREQUAL "OHOS")
  set(_LYNX_OHOS_ARCH "${OHOS_ARCH}")
  if(NOT _LYNX_OHOS_ARCH)
    set(_LYNX_OHOS_ARCH "unknown")
  endif()
  set(_LYNX_PLATFORM_OUT_DIR "${LYNX_ADDON_DIST_DIR}/harmony/${_LYNX_OHOS_ARCH}")
  add_custom_target(fetch_napi_adapter ALL
    COMMAND ${CMAKE_COMMAND} -E make_directory "${CMAKE_CURRENT_LIST_DIR}/vendor/harmony"
    COMMAND node "${CMAKE_CURRENT_LIST_DIR}/scripts/fetch-libs.mjs" --platform harmony --out "${CMAKE_CURRENT_LIST_DIR}/vendor/harmony"
    BYPRODUCTS "${CMAKE_CURRENT_LIST_DIR}/vendor/harmony/libnapi_adapter.so"
    WORKING_DIRECTORY "${CMAKE_CURRENT_LIST_DIR}"
  )
  add_library(napi_adapter SHARED IMPORTED)
  set_target_properties(napi_adapter PROPERTIES IMPORTED_LOCATION "${CMAKE_CURRENT_LIST_DIR}/vendor/harmony/libnapi_adapter.so")
  add_dependencies(__PROJECT_NAME__ fetch_napi_adapter)
  target_link_libraries(__PROJECT_NAME__ PRIVATE napi_adapter)
  set_target_properties(__PROJECT_NAME__ PROPERTIES PREFIX "lib" SUFFIX ".so")
  _lynx_set_output_dir(__PROJECT_NAME__ LIBRARY_OUTPUT_DIRECTORY "${_LYNX_PLATFORM_OUT_DIR}")
  _lynx_set_output_dir(__PROJECT_NAME__ RUNTIME_OUTPUT_DIRECTORY "${_LYNX_PLATFORM_OUT_DIR}")
elseif(WIN32)
  message(FATAL_ERROR "Windows support is coming soon.")
elseif(APPLE)
  if(CMAKE_SYSTEM_NAME STREQUAL "iOS" OR CMAKE_OSX_SYSROOT MATCHES "iphone")
    set(_LYNX_APPLE_PLATFORM "ios")
    if(CMAKE_OSX_SYSROOT MATCHES "simulator")
      set(_LYNX_APPLE_VARIANT "iphonesimulator")
    else()
      set(_LYNX_APPLE_VARIANT "iphoneos")
    endif()
  else()
    set(_LYNX_APPLE_PLATFORM "macos")
    set(_LYNX_APPLE_VARIANT "macosx")
  endif()
  set(_LYNX_PLATFORM_OUT_DIR "${LYNX_ADDON_DIST_DIR}/${_LYNX_APPLE_PLATFORM}/${_LYNX_APPLE_VARIANT}")
  _lynx_set_output_dir(__PROJECT_NAME__ ARCHIVE_OUTPUT_DIRECTORY "${_LYNX_PLATFORM_OUT_DIR}")
  add_custom_command(TARGET __PROJECT_NAME__ POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E make_directory "${_LYNX_PLATFORM_OUT_DIR}/include"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_LIST_DIR}/src/addon.h"
            "${_LYNX_PLATFORM_OUT_DIR}/include/addon.h"
    COMMAND ${CMAKE_COMMAND} -E copy_if_different
            "${CMAKE_CURRENT_LIST_DIR}/src/addon_use.h"
            "${_LYNX_PLATFORM_OUT_DIR}/include/addon_use.h"
  )
else()
  message(FATAL_ERROR "Unsupported platform for this scaffold. Use Android, OHOS, iOS, or macOS toolchains. Windows support is coming soon.")
endif()

message(STATUS "Addon artifacts will be written under: ${_LYNX_PLATFORM_OUT_DIR}")
