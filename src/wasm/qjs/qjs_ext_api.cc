// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "qjs/qjs_ext_api.h"

#include <cmath>
#include <limits>

#include "common/interop_runtime.h"
#include "gc/trace-gc.h"

namespace primjs::qjs {

bool JSSafeNewClass(LEPUSContext *ctx, LEPUSClassID class_id,
                    const LEPUSClassDef *class_def) {
  LEPUSRuntime *rt = LEPUS_GetRuntime(ctx);
  if (!LEPUS_IsRegisteredClass(rt, class_id)) {
    return LEPUS_NewClass(rt, class_id, class_def) != 0;
  }
  return false;
}

LEPUSValueConst InitConstructor(LEPUSContext *ctx, LEPUSValueConst wasm_root,
                                const char *name, LEPUSCFunction *ctor_func,
                                int length, LEPUSValueConst proto) {
  LEPUSValue ctor_obj = LEPUS_NewCFunction2(ctx, ctor_func, name, length,
                                            LEPUS_CFUNC_constructor, 0);
  HandleScope func_scope(ctx, &ctor_obj, HANDLE_TYPE_LEPUS_VALUE);
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_DupValue(ctx, proto);
    LEPUS_DupValue(ctx, ctor_obj);
  }
  LEPUS_DefinePropertyValueStr(ctx, ctor_obj, "prototype", proto,
                               LEPUS_PROP_WRITABLE | LEPUS_PROP_CONFIGURABLE);
  LEPUS_DefinePropertyValueStr(ctx, proto, "constructor", ctor_obj,
                               LEPUS_PROP_WRITABLE | LEPUS_PROP_CONFIGURABLE);

  LEPUSClassID wasm_class_id = LEPUS_GetClassID(ctx, wasm_root);
  auto interop_runtime =
      static_cast<InteropRuntime *>(LEPUS_GetOpaque(wasm_root, wasm_class_id));

  LEPUSValue ptr = LEPUS_MKPTR(LEPUS_TAG_LEPUS_CPOINTER, interop_runtime);
  LEPUS_DefinePropertyValueStr(ctx, ctor_obj, private_name, ptr, 0);

  return ctor_obj;
}

void *JSGetPrivateData(LEPUSContext *ctx, LEPUSValueConst target) {
  LEPUSValue rt_ptr = LEPUS_GetPropertyStr(ctx, target, private_name);
  return LEPUS_VALUE_GET_PTR(rt_ptr);
}

int Attach(LEPUSContext *ctx, LEPUSValue target, const char *name,
           LEPUSValue obj, int flags) {
  if (LEPUS_IsException(obj)) {
    return 1;
  }
  LEPUS_DefinePropertyValueStr(ctx, target, name, obj, flags);
  return 0;
}

bool JSValueGetInt32(LEPUSContext *ctx, LEPUSValue js_val, int32_t *res) {
  double ret;
  if (LEPUS_ToFloat64(ctx, &ret, js_val) || !std::isfinite(ret) ||
      ret > std::numeric_limits<int32_t>::max()) {
    return false;
  }
  *res = static_cast<int32_t>(ret);
  return true;
}

}  // namespace primjs::qjs
