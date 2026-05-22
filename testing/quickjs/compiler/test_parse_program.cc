// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>
#include <memory>
#include <string>

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

TEST(QjsCompiler, ParseBinaryExpressionIterative) {
  const char *src = R"(
    (64 / 4 / 2) +
    (10 - 3 - 2) +
    (1 + 2 * 3 << 1 | 1) +
    (('x' in { x: 1 }) ? 100 : 0);
  )";

  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "binary_parser.js", 0);
  ASSERT_FALSE(LEPUS_IsException(ret));

  int32_t value = 0;
  ASSERT_EQ(0, LEPUS_ToInt32(ctx, &value, ret));
  ASSERT_EQ(128, value);

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCompiler, ParseLogicalExpressionIterative) {
  const char *src = R"(
    let x = 0;
    function mark(bit, value) {
      x = x * 10 + bit;
      return value;
    }
    let r = mark(1, false) && mark(2, true) ||
            mark(3, true) && mark(4, 9);
    x * 10 + r;
  )";

  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "logical_parser.js", 0);
  ASSERT_FALSE(LEPUS_IsException(ret));

  int32_t value = 0;
  ASSERT_EQ(0, LEPUS_ToInt32(ctx, &value, ret));
  ASSERT_EQ(1349, value);

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCompiler, ParseNullishExpressionIterative) {
  const char *src = R"(
    let x = 0;
    function mark(bit, value) {
      x = x * 10 + bit;
      return value;
    }
    let a = mark(1, undefined) ?? mark(2, 7) ?? mark(3, 8);
    let b = mark(4, 0) ?? mark(5, 9);
    x * 100 + a * 10 + b;
  )";

  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "nullish_parser.js", 0);
  ASSERT_FALSE(LEPUS_IsException(ret));

  int32_t value = 0;
  ASSERT_EQ(0, LEPUS_ToInt32(ctx, &value, ret));
  ASSERT_EQ(12470, value);

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCompiler, ParseNullishLogicalMixingError) {
  const char *srcs[] = {
      "true || false ?? true;",
      "true && false ?? true;",
      "undefined ?? false || true;",
      "undefined ?? true && false;",
  };

  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  for (const char *src : srcs) {
    LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "nullish_mixing.js", 0);
    ASSERT_TRUE(LEPUS_IsException(ret));
    LEPUSValue exception = LEPUS_GetException(ctx);
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, exception);
  }

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCompiler, ParseAssignmentExpressionIterative) {
  const char *src = R"(
    let a = 0, b = 0, c = 0, d = 0;
    a = b = c = d = 5;
    a += b += c += 1;
    a * 1000 + b * 100 + c * 10 + d;
  )";

  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "assign_parser.js", 0);
  ASSERT_FALSE(LEPUS_IsException(ret));

  int32_t value = 0;
  ASSERT_EQ(0, LEPUS_ToInt32(ctx, &value, ret));
  ASSERT_EQ(17165, value);

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCompiler, ParseUnaryExpressionIterative) {
  const char *src = R"(
    let x = 2;
    let a = ++x ** 2;
    let b = 2 ** 3 ** 2;
    let c = typeof missing === 'undefined' ? 10 : 0;
    a + b + c;
  )";

  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "unary_parser.js", 0);
  ASSERT_FALSE(LEPUS_IsException(ret));

  int32_t value = 0;
  ASSERT_EQ(0, LEPUS_ToInt32(ctx, &value, ret));
  ASSERT_EQ(531, value);

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCompiler, ParseUnaryPowSyntaxError) {
  const char *src = "-2 ** 2;";

  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "unary_pow_error.js", 0);
  ASSERT_TRUE(LEPUS_IsException(ret));
  LEPUSValue exception = LEPUS_GetException(ctx);
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, exception);

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCompiler, ParseYieldExpressionIterative) {
  const char *src = R"(
    function *g() {
      let a = 0;
      a = yield yield 3;
      return a;
    }
    let it = g();
    let r1 = it.next().value;
    let r2 = it.next(4).value;
    let r3 = it.next(5).value;
    r1 * 100 + r2 * 10 + r3;
  )";

  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "yield_parser.js", 0);
  ASSERT_FALSE(LEPUS_IsException(ret));

  int32_t value = 0;
  ASSERT_EQ(0, LEPUS_ToInt32(ctx, &value, ret));
  ASSERT_EQ(345, value);

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

/* Stress tests for the iterative parser: ensure that deeply nested
   expressions which used to drive js_parse_unary / js_parse_assign_expr /
   js_parse_expr_binary / js_parse_logical_*_expr / js_parse_cond_expr into
   thousands of recursive C frames now run without stack overflow. Each
   shape exercises a different iterative loop in the parser. Note: shapes
   that go through js_parse_postfix_expr / js_parse_expression (e.g. deep
   parens) are intentionally NOT exercised here because those code paths
   are still recursive and out of scope of this patch. */
TEST(QjsCompiler, ParseDeeplyNestedExpression) {
  constexpr int kDepth = 2000;

  auto run = [](const std::string &src) {
    auto *rt = LEPUS_NewRuntime();
    auto *ctx = LEPUS_NewContext(rt);
    LEPUSValue ret =
        LEPUS_Eval(ctx, src.c_str(), src.length(), "deeply_nested.js",
                   LEPUS_EVAL_FLAG_COMPILE_ONLY);
    ASSERT_FALSE(LEPUS_IsException(ret));
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
    LEPUS_FreeContext(ctx);
    LEPUS_FreeRuntime(rt);
  };

  {
    /* Long left-associative additive chain: drives js_parse_expr_binary. */
    std::string src = "0";
    src.reserve(kDepth * 2 + 4);
    for (int i = 0; i < kDepth; ++i) src.append("+1");
    src.push_back(';');
    run(src);
  }

  {
    /* Long right-associative '**' chain: drives the iterative pow loop
       inside js_parse_unary. */
    std::string src;
    src.reserve(kDepth * 4 + 4);
    for (int i = 0; i < kDepth; ++i) src.append("1**");
    src.push_back('1');
    src.push_back(';');
    run(src);
  }

  {
    /* Long prefix '!' chain: drives the prefix-collection inner loop. */
    std::string src;
    src.reserve(kDepth + 8);
    for (int i = 0; i < kDepth; ++i) src.push_back('!');
    src.append("true;");
    run(src);
  }

  {
    /* Long right-associative assignment chain: drives js_parse_assign_expr
       frame stack. */
    std::string src = "let ";
    for (int i = 0; i < kDepth; ++i) {
      if (i) src.push_back(',');
      src.append("a");
      src.append(std::to_string(i));
    }
    src.append(";\n");
    for (int i = 0; i < kDepth - 1; ++i) {
      src.append("a");
      src.append(std::to_string(i));
      src.push_back('=');
    }
    src.append("a");
    src.append(std::to_string(kDepth - 1));
    src.push_back(';');
    run(src);
  }

  {
    /* Long '&&' chain: drives js_parse_logical_and_expr iterative loop. */
    std::string src = "true";
    src.reserve(kDepth * 7 + 8);
    for (int i = 0; i < kDepth; ++i) src.append("&&true");
    src.push_back(';');
    run(src);
  }

  {
    /* Long '??' chain: drives js_parse_cond_expr iterative loop. */
    std::string src = "null";
    src.reserve(kDepth * 7 + 8);
    for (int i = 0; i < kDepth; ++i) src.append("??null");
    src.push_back(';');
    run(src);
  }
}

/* Lock the error message produced when '??' is mixed with '&&' or '||'
   without parentheses. The new iterative js_parse_cond_expr /
   js_parse_logical_*_expr report this explicitly rather than letting it
   surface as a generic unexpected-token error. */
TEST(QjsCompiler, ParseNullishLogicalMixingErrorMessage) {
  const char *srcs[] = {
      "true || false ?? true;",
      "true && false ?? true;",
      "undefined ?? false || true;",
      "undefined ?? true && false;",
  };

  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  for (const char *src : srcs) {
    LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "nullish_mixing_msg.js",
                                LEPUS_EVAL_FLAG_COMPILE_ONLY);
    ASSERT_TRUE(LEPUS_IsException(ret));
    LEPUSValue exception = LEPUS_GetException(ctx);
    const char *cstr = LEPUS_ToCString(ctx, exception);
    ASSERT_NE(nullptr, cstr);
    ASSERT_NE(nullptr, strstr(cstr, "cannot mix ?? with && or ||"));
    LEPUS_FreeCString(ctx, cstr);
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, exception);
  }

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
