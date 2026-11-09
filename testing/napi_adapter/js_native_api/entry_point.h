// Copyright 2024-2026 The Lynx Authors. All rights reserved.
// Portions of this file are derived from Node.js test suites
// (test/js-native-api, test/node-api), which are licensed under the MIT
// License. See THIRD-PARTY-NOTICES.md and licenses/nodejs.MIT for details.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef TESTING_NAPI_ADAPTER_JS_NATIVE_API_ENTRY_POINT_H_
#define TESTING_NAPI_ADAPTER_JS_NATIVE_API_ENTRY_POINT_H_

#include "include/node_api.h"
#include "include/weak_napi_defines.h"

EXTERN_C_START
static napi_value Init(napi_env env, napi_value exports);
EXTERN_C_END

#define NAPI_C_CTOR_TEST(fn)                  \
  void fn(void) __attribute__((constructor)); \
  void fn(void)

#define NAPI_MODULE_TEST(modname, regfunc)                                   \
  EXTERN_C_START                                                             \
  static struct napi_module _module = {                                      \
      NAPI_MODULE_VERSION, 0, __FILE__, regfunc, #modname, 0, {0, 0, 0, 0}}; \
  NAPI_C_CTOR_TEST(_napi_module_register_##modname) {                        \
    napi_module_register(&_module);                                          \
  }                                                                          \
  EXTERN_C_END

#define NAPI_MODULE_HELPER(name, init) NAPI_MODULE_TEST(name, init)

NAPI_MODULE_HELPER(NAPI_MODULE_NAME, Init)

#endif  // TESTING_NAPI_ADAPTER_JS_NATIVE_API_ENTRY_POINT_H_

#include "include/weak_napi_undefs.h"
