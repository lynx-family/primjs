// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <memory>

#include "gtest/gtest.h"

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs-libc.h"
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif
#include "quickjs/include/quickjs-inner.h"

TEST(QjsCompiler, Parse) {
  std::string src = R"(let arr = [1, 2, 3];
    arr.length = 10;
    console.log(arr.splice(1, 1));
    console.log(arr);
  )";

  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  LEPUSValue ret = LEPUS_Eval(ctx, src.c_str(), src.length(), "",
                              LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_TRUE(LEPUS_VALUE_GET_TAG(ret) != LEPUS_TAG_EXCEPTION);

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}
