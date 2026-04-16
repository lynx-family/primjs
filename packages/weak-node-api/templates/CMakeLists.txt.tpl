cmake_minimum_required(VERSION 3.22)
project(__PROJECT_NAME__ LANGUAGES C CXX)
set(CMAKE_POSITION_INDEPENDENT_CODE ON)
set(CMAKE_C_STANDARD 11)
set(CMAKE_CXX_STANDARD 17)
option(USE_WEAK_SUFFIX_NAPI "Enable weak suffix remapping for Node-API" __DEFAULT_USE_WEAK__)
set(_WEAK_NODE_API_CONFIG "${CMAKE_CURRENT_LIST_DIR}/node_modules/@lynx-js/weak-node-api/weak-node-api-config.cmake")
if(NOT EXISTS "${_WEAK_NODE_API_CONFIG}")
  message(FATAL_ERROR "weak-node-api-config.cmake not found: ${_WEAK_NODE_API_CONFIG}. Run npm install first.")
endif()
include("${_WEAK_NODE_API_CONFIG}")

add_library(__PROJECT_NAME__ SHARED src/addon.cc)
set(_LYNX_NAPI_ADDON_PREFIX "")
set(_LYNX_NAPI_ADDON_SUFFIX ".node")
if(ANDROID OR CMAKE_SYSTEM_NAME STREQUAL "OHOS")
  set(_LYNX_NAPI_ADDON_PREFIX "lib")
  set(_LYNX_NAPI_ADDON_SUFFIX ".so")
endif()
set_target_properties(__PROJECT_NAME__ PROPERTIES
  PREFIX "${_LYNX_NAPI_ADDON_PREFIX}"
  SUFFIX "${_LYNX_NAPI_ADDON_SUFFIX}"
)
target_link_libraries(__PROJECT_NAME__ PRIVATE weak-node-api-headers)
target_compile_definitions(__PROJECT_NAME__ PRIVATE NAPI_VERSION=8)
if(USE_WEAK_SUFFIX_NAPI)
  target_compile_definitions(__PROJECT_NAME__ PRIVATE USE_WEAK_SUFFIX_NAPI)
endif()
if(ANDROID)
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
elseif(CMAKE_SYSTEM_NAME STREQUAL "OHOS")
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
elseif(APPLE)
  target_link_options(__PROJECT_NAME__ PRIVATE "-Wl,-undefined,dynamic_lookup")

  # iOS builds created via the Xcode generator may require a DEVELOPMENT_TEAM by default.
  # For N-API addons we want to avoid forcing code signing; users can sign as needed.
  if(CMAKE_SYSTEM_NAME STREQUAL "iOS" OR CMAKE_OSX_SYSROOT MATCHES "iphone")
    set_target_properties(__PROJECT_NAME__ PROPERTIES
      XCODE_ATTRIBUTE_CODE_SIGNING_ALLOWED "NO"
      XCODE_ATTRIBUTE_CODE_SIGNING_REQUIRED "NO"
      XCODE_ATTRIBUTE_CODE_SIGN_IDENTITY ""
      XCODE_ATTRIBUTE_DEVELOPMENT_TEAM ""
      XCODE_ATTRIBUTE_PROVISIONING_PROFILE_SPECIFIER ""
    )
  endif()
endif()
