# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

# quickjs library was built by Project "app"
set(Quickjs_FOUND false)

set(WASM_ANDROID_ROOT ${CMAKE_CURRENT_LIST_DIR}/..)

set(PRIMJS_LIBRARY ${WASM_ANDROID_ROOT}/libs/${ANDROID_ABI}/libquick.so)

add_library(quickjs-lib SHARED IMPORTED GLOBAL)
set_property(TARGET quickjs-lib PROPERTY IMPORTED_LOCATION ${PRIMJS_LIBRARY})
set(Quickjs_FOUND true)