// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// ENABLE_JSVM=OFF keeps the same exports as JSVM builds, so libraries linked
// against these APIs still load and see the backend as unavailable.

#include "harmony/napi_env_harmony.h"
#include "js_native_api.h"
#include "js_native_api_types.h"
#include "napi_state.h"

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

#include "basic/log/logging.h"

EXTERN_C_START

bool napi_is_harmony_available(void) { return false; }

napi_status napi_try_attach_harmony(napi_env env, JSVM_Env js_env) {
  if (!env) {
    return napi_invalid_arg;
  }
  if (!js_env || env->ctx) {
    return napi_set_last_error(env, napi_invalid_arg);
  }
  return napi_set_last_error(env, napi_generic_failure);
}

void napi_attach_harmony(napi_env env, JSVM_Env js_env) {
  if (napi_try_attach_harmony(env, js_env) != napi_ok) {
    LOGE("Unable to attach JSVM: built with ENABLE_JSVM=OFF");
  }
}

void napi_detach_harmony(napi_env env) {}

EXTERN_C_END

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif
