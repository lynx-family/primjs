// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_EXT_API_H_
#define SRC_WASM_QJS_QJS_WASM_EXT_API_H_

#include "common/js_type.h"
#include "common/wasm_utils.h"
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs::qjs {
constexpr const char *const private_name = "__WASM_PRIVATE__";

bool JSSafeNewClass(LEPUSContext *ctx, LEPUSClassID class_id,
                    const LEPUSClassDef *class_def);

LEPUSValueConst InitConstructor(LEPUSContext *ctx, LEPUSValueConst wasm_root,
                                const char *name, LEPUSCFunction *func,
                                int length, LEPUSValueConst proto);

void *JSGetPrivateData(LEPUSContext *ctx, LEPUSValueConst target);
int Attach(LEPUSContext *ctx, LEPUSValue target, const char *name,
           LEPUSValue obj, int flags);

FORCE_INLINE LEPUSValue JSGetPropertyStrFree(LEPUSContext *ctx,
                                             LEPUSValueConst this_obj,
                                             const char *prop) {
  LEPUSValue prop_value = LEPUS_GetPropertyStr(ctx, this_obj, prop);
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, prop_value);
  }
  return prop_value;
}

FORCE_INLINE void *JSObjectGetPrivate(LEPUSContext *ctx,
                                      LEPUSValueConst target) {
  LEPUSClassID class_id = LEPUS_GetClassID(ctx, target);
  return LEPUS_GetOpaque(target, class_id);
}

FORCE_INLINE void JSObjectSetPrivate(LEPUSValue obj, void *opaque) {
  LEPUS_SetOpaque(obj, opaque);
}

bool JSValueGetInt32(LEPUSContext *ctx, LEPUSValue js_val, int32_t *res);

FORCE_INLINE LEPUSValue ThrowError(LEPUSContext *ctx, const char *fmt, ...) {
  LEPUSValue val;
  va_list ap;

  va_start(ap, fmt);
  char buf[256];
  vsnprintf(buf, sizeof(buf), fmt, ap);
  LEPUSValue str = LEPUS_NewString(ctx, buf);
  HandleScope(ctx, &str, HANDLE_TYPE_LEPUS_VALUE);
  val = LEPUS_Throw(ctx, str);
  va_end(ap);

  return val;
}

constexpr decltype(&ThrowError) ThrowFuncs[] = {
    ThrowError, LEPUS_ThrowTypeError, LEPUS_ThrowRangeError};

FORCE_INLINE LEPUSValue ThrowIfException(LEPUSContext *ctx, ErrorTypes err,
                                         const char *code, const char *msg,
                                         LEPUSValue *exception = nullptr) {
  uint32_t err_idx = static_cast<uint32_t>(err);
  WLOGE("%s: %s: %s", kErrorStrings[err_idx], code, msg);
  LEPUSValue value = ThrowFuncs[err_idx](ctx, "%s: %s", code, msg);
  if (exception) *exception = value;
  return value;
}

}  // namespace primjs::qjs

#endif  // SRC_WASM_QJS_QJS_WASM_EXT_API_H_
