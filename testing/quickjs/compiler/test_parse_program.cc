// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>
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

TEST(QjsCompiler, ParserZoneAllocator) {
  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  ASSERT_EQ(0, js_parse_zone_unit_test(ctx));
  ASSERT_EQ(0, js_parse_zone_dynbuf_unit_test(ctx));
  ASSERT_EQ(0, js_parse_zone_gc_unit_test(ctx));

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCompiler, DebuggerStatementParse) {
  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  {
    const char *src = "debugger;";
    LEPUSValue ret =
        LEPUS_Eval(ctx, src, strlen(src), "", LEPUS_EVAL_FLAG_COMPILE_ONLY);
    ASSERT_FALSE(LEPUS_IsException(ret));
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  }

  {
    const char *src = "debugger\nlet x = 1;";
    LEPUSValue ret =
        LEPUS_Eval(ctx, src, strlen(src), "", LEPUS_EVAL_FLAG_COMPILE_ONLY);
    ASSERT_FALSE(LEPUS_IsException(ret));
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  }

  {
    const char *src = "debugger 1;";
    LEPUSValue ret =
        LEPUS_Eval(ctx, src, strlen(src), "", LEPUS_EVAL_FLAG_COMPILE_ONLY);
    ASSERT_TRUE(LEPUS_IsException(ret));
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  }

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}
