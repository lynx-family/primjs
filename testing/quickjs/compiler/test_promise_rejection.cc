// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "gtest/gtest.h"
#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs-libc.h"
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"
namespace promise_test {

class PromiseRejectionTest : public ::testing::Test {
 protected:
  PromiseRejectionTest() = default;
  ~PromiseRejectionTest() override = default;

  void SetUp() override {
    rt_ = LEPUS_NewRuntime();
    ctx_ = LEPUS_NewContext(rt_);
  }

  void TearDown() override {
    LEPUS_FreeContext(ctx_);
    LEPUS_FreeRuntime(rt_);
  }

  LEPUSContext* ctx_;
  LEPUSRuntime* rt_;
};

static void js_print(LEPUSContext* ctx, LEPUSValueConst this_val, int argc,
                     LEPUSValueConst* argv, std::string& result) {
  int i;
  const char* str;
  for (i = 0; i < argc; i++) {
    if (i != 0) result += ' ';
    str = LEPUS_ToCString(ctx, argv[i]);
    result += str;
    if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, str);
  }
  result += "\n";
}

static std::string js_get_exception_string(LEPUSContext* ctx) {
  std::string result = "";
  LEPUSValue exception_val, val;
  const char* stack;
  uint8_t is_error;

  exception_val = LEPUS_GetException(ctx);
  HandleScope func_scope(ctx, &exception_val, HANDLE_TYPE_LEPUS_VALUE);
  is_error = LEPUS_IsError(ctx, exception_val);
  if (!is_error) result += "Throw: ";

  js_print(ctx, LEPUS_NULL, 1, (LEPUSValueConst*)&exception_val, result);
  if (is_error) {
    val = LEPUS_GetPropertyStr(ctx, exception_val, "stack");
    if (!LEPUS_IsUndefined(val)) {
      stack = LEPUS_ToCString(ctx, val);
      result += stack;
      // result += "\n";
      if (!ctx->rt->gc_enable) LEPUS_FreeCString(ctx, stack);
    }
    if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, val);
  }
  if (!ctx->rt->gc_enable) LEPUS_FreeValue(ctx, exception_val);
  return result;
}

static std::string js_dump_unhandled_rejection(LEPUSContext* ctx) {
  std::string result = "";
  int count = 0;
  while (LEPUS_MoveUnhandledRejectionToException(ctx)) {
    result += js_get_exception_string(ctx);
    count++;
  }
  // if (count == 0) return result;
  return result;
}

static bool js_run(LEPUSContext* ctx, const char* filename, LEPUSValue& ret) {
  uint8_t* buf;
  int eval_flags;
  size_t buf_len;
  buf = lepus_load_file(ctx, &buf_len, filename);
  if (!buf) {
    ret = LEPUS_UNDEFINED;
    return false;
  }
  eval_flags = LEPUS_EVAL_TYPE_GLOBAL;
  ret = LEPUS_Eval(ctx, (const char*)buf, buf_len, filename, eval_flags);
  free(buf);
  return true;
}

TEST_F(PromiseRejectionTest, AsyncStackTraceTest) {
  const char* filename = TEST_CASE_DIR "unit_test/async_stack_trace_test.js";
  LEPUSValue val;
  bool res = js_run(ctx_, filename, val);
  if (res) {
    std::string result = "";
    if (LEPUS_IsException(val)) {
      result += js_get_exception_string(ctx_);
    }
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);

    lepus_std_loop(ctx_);
    result += js_dump_unhandled_rejection(ctx_);
    ASSERT_TRUE(result == "");
  } else {
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
    ASSERT_TRUE(false);
  }
}

TEST_F(PromiseRejectionTest, RejectionReasonObjectTest) {
  const char* filename = TEST_CASE_DIR "unit_test/rejection_reason_object.js";
  LEPUSValue val;
  bool res = js_run(ctx_, filename, val);
  if (res) {
    std::string result = "";
    if (LEPUS_IsException(val)) {
      result += js_get_exception_string(ctx_);
    }
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);

    lepus_std_loop(ctx_);
    result += js_dump_unhandled_rejection(ctx_);
    ASSERT_TRUE(result == "");
  } else {
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
    ASSERT_TRUE(false);
  }
}

}  // namespace promise_test
