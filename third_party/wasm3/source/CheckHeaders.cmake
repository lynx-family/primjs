# Copyright 2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

# The runtime includes wasm3/*.h. Check the actual include root supplied
# to consumers, including after CMake installation. Android build trees may
# use a directory symlink; distributable install trees must contain real files.
function(wasm3_check_headers source_dir include_root require_copies)
  file(GLOB source_headers RELATIVE "${source_dir}" "${source_dir}/*.h")
  file(GLOB exported_headers RELATIVE "${include_root}/wasm3"
       "${include_root}/wasm3/*.h")
  list(SORT source_headers)
  list(SORT exported_headers)
  if(NOT EXISTS "${source_dir}/wasm3.h" OR NOT EXISTS "${source_dir}/m3_env.h")
    message(FATAL_ERROR "wasm3 source headers are missing: ${source_dir}")
  endif()
  if(NOT "${source_headers}" STREQUAL "${exported_headers}")
    message(FATAL_ERROR "Incomplete wasm3 header namespace: ${include_root}/wasm3")
  endif()
  if(require_copies AND IS_SYMLINK "${include_root}/wasm3")
    message(FATAL_ERROR "Packaged wasm3 headers must be regular copies")
  endif()
  foreach(header IN LISTS source_headers)
    set(exported "${include_root}/wasm3/${header}")
    if(require_copies AND IS_SYMLINK "${exported}")
      message(FATAL_ERROR "Packaged wasm3 header must be a regular copy: ${header}")
    endif()
    file(SHA256 "${source_dir}/${header}" source_hash)
    file(SHA256 "${exported}" exported_hash)
    if(NOT source_hash STREQUAL exported_hash)
      message(FATAL_ERROR "Mismatched wasm3 header: ${header}")
    endif()
  endforeach()
endfunction()

if(DEFINED WASM3_SOURCE_DIR AND DEFINED WASM3_INCLUDE_ROOT)
  wasm3_check_headers("${WASM3_SOURCE_DIR}" "${WASM3_INCLUDE_ROOT}" TRUE)
endif()
