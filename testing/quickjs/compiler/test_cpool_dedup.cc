// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>

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

// Helper: count how many times a given string appears in a function bytecode's
// cpool.
static int count_cpool_string(LEPUSContext *ctx, LEPUSFunctionBytecode *b,
                              const char *target) {
  int count = 0;
  for (int i = 0; i < b->cpool_count; i++) {
    if (LEPUS_VALUE_IS_STRING(b->cpool[i])) {
      const char *str = LEPUS_ToCString(ctx, b->cpool[i]);
      if (str && strcmp(str, target) == 0) {
        count++;
      }
      if (!ctx->gc_enable) LEPUS_FreeCString(ctx, str);
    }
  }
  return count;
}

// Test: multiple "debugger;" statements in the same function should produce
// only one "debugger" entry in cpool.
TEST(CpoolDedup, DebuggerKeywordDedup) {
  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  // Source with 3 debugger statements in the same function scope
  const char *src =
      "function foo() {\n"
      "  debugger;\n"
      "  let x = 1;\n"
      "  debugger;\n"
      "  let y = 2;\n"
      "  debugger;\n"
      "}\n";

  LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "test.js",
                              LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_FALSE(LEPUS_IsException(ret));
  ASSERT_TRUE(LEPUS_VALUE_IS_FUNCTION_BYTECODE(ret));

  // The top-level compiled result is a function bytecode. The inner function
  // "foo" is in its cpool. Find it.
  auto *top_b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(ret);

  LEPUSFunctionBytecode *foo_b = nullptr;
  for (int i = 0; i < top_b->cpool_count; i++) {
    if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(top_b->cpool[i])) {
      foo_b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(top_b->cpool[i]);
      break;
    }
  }
  ASSERT_NE(foo_b, nullptr);

  // "debugger" should appear at most once in foo's cpool
  int debugger_count = count_cpool_string(ctx, foo_b, "debugger");
  EXPECT_EQ(debugger_count, 1)
      << "Expected exactly 1 'debugger' in cpool, got " << debugger_count;

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

// Test: multiple statements in debugger_mode should produce only one
// "statement" entry in cpool.
TEST(CpoolDedup, DebuggerStatementDedup) {
  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  // Enable debugger_mode so js_gen_debugger_statement is called
  ctx->debugger_mode = 1;

  // Source with multiple statements that each trigger js_gen_debugger_statement
  // (every statement in debugger_mode generates a "statement" push)
  const char *src =
      "let a = 1;\n"
      "let b = 2;\n"
      "let c = 3;\n"
      "let d = 4;\n"
      "let e = 5;\n";

  LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "test.js",
                              LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_FALSE(LEPUS_IsException(ret));
  ASSERT_TRUE(LEPUS_VALUE_IS_FUNCTION_BYTECODE(ret));

  auto *b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(ret);

  // "statement" should appear at most once in the cpool
  int statement_count = count_cpool_string(ctx, b, "statement");
  EXPECT_EQ(statement_count, 1)
      << "Expected exactly 1 'statement' in cpool, got " << statement_count;

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

// Test: a single debugger statement still works correctly (no regression).
TEST(CpoolDedup, SingleDebuggerStatement) {
  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  const char *src = "debugger;";
  LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "test.js",
                              LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_FALSE(LEPUS_IsException(ret));
  ASSERT_TRUE(LEPUS_VALUE_IS_FUNCTION_BYTECODE(ret));

  auto *b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(ret);
  int debugger_count = count_cpool_string(ctx, b, "debugger");
  EXPECT_EQ(debugger_count, 1);

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

// Test: different functions each have their own cpool entry (no cross-function
// sharing issue).
TEST(CpoolDedup, SeparateFunctionsIndependent) {
  auto *rt = LEPUS_NewRuntime();
  auto *ctx = LEPUS_NewContext(rt);

  const char *src =
      "function foo() { debugger; debugger; }\n"
      "function bar() { debugger; debugger; debugger; }\n";

  LEPUSValue ret = LEPUS_Eval(ctx, src, strlen(src), "test.js",
                              LEPUS_EVAL_FLAG_COMPILE_ONLY);
  ASSERT_FALSE(LEPUS_IsException(ret));
  ASSERT_TRUE(LEPUS_VALUE_IS_FUNCTION_BYTECODE(ret));

  auto *top_b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(ret);

  // Find both inner functions
  int func_count = 0;
  for (int i = 0; i < top_b->cpool_count; i++) {
    if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(top_b->cpool[i])) {
      auto *inner_b =
          (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(top_b->cpool[i]);
      int debugger_count = count_cpool_string(ctx, inner_b, "debugger");
      EXPECT_EQ(debugger_count, 1)
          << "Function " << func_count
          << " should have exactly 1 'debugger' in cpool";
      func_count++;
    }
  }
  EXPECT_EQ(func_count, 2) << "Expected 2 inner functions";

  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, ret);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}
