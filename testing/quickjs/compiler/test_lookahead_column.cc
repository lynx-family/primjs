// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>
#include <string>

#include "gtest/gtest.h"

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif
#include "inspector/interface.h"
#include "quickjs/include/quickjs-inner.h"

class LookaheadColumnTest : public ::testing::Test {
 protected:
  void SetUp() override {
    rt_ = LEPUS_NewRuntime();
    ctx_ = LEPUS_NewContext(rt_);
    SetDebugInfoOutside(ctx_, true);
  }

  void TearDown() override {
    LEPUS_FreeContext(ctx_);
    LEPUS_FreeRuntime(rt_);
  }

  int64_t FirstColumnOfArrow(const std::string& src) {
    LEPUSValue top =
        LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                   LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL);
    EXPECT_FALSE(LEPUS_IsException(top));
    uint32_t count = 0;
    LEPUSFunctionBytecode** functions =
        GetDebuggerAllFunction(ctx_, top, &count);
    int64_t first = -1;
    for (uint32_t i = 0; i < count; ++i) {
      const char* own = GetFunctionDebugSource(ctx_, functions[i]);
      if (!own || strncmp(own, "(a,b", 4) != 0) continue;
      size_t size = 0;
      int64_t* line_cols = GetFunctionLineNums(ctx_, functions[i], &size);
      for (size_t k = 0; k < size; ++k) {
        int32_t line = -1;
        int64_t column = -1;
        ComputeLineCol(line_cols[k], &line, &column);
        if (first < 0 || column + 1 < first) first = column + 1;
      }
      if (!LEPUS_IsGCMode(ctx_)) lepus_free(ctx_, line_cols);
    }
    if (!LEPUS_IsGCMode(ctx_)) lepus_free(ctx_, functions);
    LEPUS_FreeValue(ctx_, top);
    return first;
  }

  LEPUSRuntime* rt_ = nullptr;
  LEPUSContext* ctx_ = nullptr;
};

// The arrow-function lookahead scans past the whole parameter list, so the
// token pointers end up far ahead of the body that is parsed after the parser
// seeks back. Columns recorded for the body must not keep that scan position.
TEST_F(LookaheadColumnTest, BodyColumnsSurviveTheArrowLookahead) {
  std::string src = "var g=1;var f=(a,b/*" + std::string(200, 'z') +
                    "*/)=>(a+b);function foo(){return g}\n";
  size_t body = src.find("=>(") + 3;

  EXPECT_EQ(FirstColumnOfArrow(src), static_cast<int64_t>(body) + 1);
}

TEST_F(LookaheadColumnTest, ShortLookaheadKeepsWorking) {
  std::string src = "var g=1;var f=(a,b)=>(a+b);function foo(){return g}\n";
  size_t body = src.find("=>(") + 3;

  EXPECT_EQ(FirstColumnOfArrow(src), static_cast<int64_t>(body) + 1);
}
