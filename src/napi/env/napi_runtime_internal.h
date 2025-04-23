/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */

// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_NAPI_ENV_NAPI_RUNTIME_INTERNAL_H_
#define SRC_NAPI_ENV_NAPI_RUNTIME_INTERNAL_H_

#include "js_native_api.h"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

napi_status napi_get_threadsafe_function_context_internal(
    napi_threadsafe_function func, void** result);

napi_status napi_call_threadsafe_function_internal(
    napi_threadsafe_function func, void* data,
    napi_threadsafe_function_call_mode is_blocking);

napi_status napi_delete_threadsafe_function_internal(
    napi_threadsafe_function func);

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif
#endif  // SRC_NAPI_ENV_NAPI_RUNTIME_INTERNAL_H_
