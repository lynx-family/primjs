# Copyright 2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

include_directories(${VM_ROOT_DIR}/src ${VM_ROOT_DIR}/src/interpreter
                    ${VM_ROOT_DIR}/ ${VM_ROOT_DIR}/../)

file(GLOB SRC "${CMAKE_CURRENT_SOURCE_DIR}/*.cc")

add_library(primjs_static STATIC ${SRC})

if(ENABLE_PRIMJS_HARMONY OR CMAKE_SYSTEM_NAME STREQUAL "Android"
   OR CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(PRIMJS_EMBEDDED_PLATFORM android)
elseif(CMAKE_SYSTEM_NAME STREQUAL "iOS"
       OR CMAKE_OSX_SYSROOT MATCHES "[iI][pP]hone")
  set(PRIMJS_EMBEDDED_PLATFORM ios)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Darwin")
  set(PRIMJS_EMBEDDED_PLATFORM mac)
else()
  message(
    FATAL_ERROR
      "primjs_static does not support target platform: ${CMAKE_SYSTEM_NAME}")
endif()

if(ENABLE_QUICKJS_DEBUGGER)
  set(PRIMJS_EMBEDDED_FILE embedded-inspector.S)
else()
  set(PRIMJS_EMBEDDED_FILE embedded.S)
endif()

target_sources(
  primjs_static
  PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/${PRIMJS_EMBEDDED_PLATFORM}/${PRIMJS_EMBEDDED_FILE}"
)

target_link_libraries(primjs_static quick_static)
