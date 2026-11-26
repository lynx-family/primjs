# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

set(JSB_WASM_SOURCE_ROOT ${CMAKE_CURRENT_LIST_DIR})
set(JSB_WASM_HEADER_DIR ${JSB_WASM_SOURCE_ROOT})

set(JSB_WASM_COMMON_SRC
  "${JSB_WASM_SOURCE_ROOT}/common/js_type.h"
  "${JSB_WASM_SOURCE_ROOT}/common/messages.h"
  "${JSB_WASM_SOURCE_ROOT}/common/wasm_c_api_dispatch.cc"
  "${JSB_WASM_SOURCE_ROOT}/common/wasm_c_api_dispatch.h"
  "${JSB_WASM_SOURCE_ROOT}/common/wasm_log.h"
  "${JSB_WASM_SOURCE_ROOT}/common/wasm_store_owner.h"
  "${JSB_WASM_SOURCE_ROOT}/common/wasm_type.h"
  "${JSB_WASM_SOURCE_ROOT}/common/wasm_utils.h"
)

set(JSB_WASM_JSC_SRC
  "${JSB_WASM_SOURCE_ROOT}/jsc/js_env_jsc.cc"
  "${JSB_WASM_SOURCE_ROOT}/jsc/js_env_jsc.h"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_builtin_objects.cc"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_builtin_objects.h"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_class_creator.cc"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_class_creator.h"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_ext_api.cc"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_ext_api.h"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm.cc"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm.h"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm_function.cc"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm_function.h"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm_instance.cc"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm_instance.h"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm_memory.cc"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm_memory.h"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm_module.cc"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm_module.h"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm_table.cc"
  "${JSB_WASM_SOURCE_ROOT}/jsc/jsc_wasm_table.h"
)

set(JSB_WASM_QJS_SRC
  "${JSB_WASM_SOURCE_ROOT}/qjs/js_env_qjs.cc"
  "${JSB_WASM_SOURCE_ROOT}/qjs/js_env_qjs.h"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_ext_api.cc"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_ext_api.h"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm.cc"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm.h"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm_function.cc"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm_function.h"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm_instance.cc"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm_instance.h"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm_memory.cc"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm_memory.h"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm_module.cc"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm_module.h"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm_table.cc"
  "${JSB_WASM_SOURCE_ROOT}/qjs/qjs_wasm_table.h"
)

set(JSC_PRISM_SOURCES
  ${JSB_WASM_COMMON_SRC}
  ${JSB_WASM_JSC_SRC}
)

set(QJS_PRISM_SOURCES
  ${JSB_WASM_COMMON_SRC}
  ${JSB_WASM_QJS_SRC}
)
