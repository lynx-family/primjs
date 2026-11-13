/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_NAPI_ENV_NAPI_ENV_H_
#define SRC_NAPI_ENV_NAPI_ENV_H_

#include "js_native_api.h"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

EXTERN_C_START

NAPI_EXTERN napi_env napi_new_env();

// Register a standard C adapter hook without changing legacy registrations.
NAPI_EXTERN napi_status napi_add_adapter_cleanup_hook(napi_env env,
                                                      void (*fun)(void* arg),
                                                      void* arg);

// Engine detachers drain only standard C adapter hooks before clearing the
// context's references. Legacy hooks remain pending until free-env.
// Returns false for recursive cleanup or a failed scope open/close. The caller
// must keep the context alive in that case.
NAPI_EXTERN bool napi_run_adapter_cleanup_hooks(napi_env env);

NAPI_EXTERN void napi_free_env(napi_env);

NAPI_EXTERN void napi_setup_loader(napi_env env, const char* name);

EXTERN_C_END

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif

#endif  // SRC_NAPI_ENV_NAPI_ENV_H_
