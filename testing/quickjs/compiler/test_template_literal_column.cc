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

class TemplateLiteralColumnTest : public ::testing::Test {
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

  static int64_t CharColumn(const std::string& src, const char* needle) {
    size_t pos = src.find(needle);
    size_t line_begin = src.rfind('\n', pos);
    line_begin = line_begin == std::string::npos ? 0 : line_begin + 1;
    int64_t column = 0;
    for (size_t i = line_begin; i < pos; ++i) {
      if ((static_cast<unsigned char>(src[i]) & 0xC0) != 0x80) ++column;
    }
    return column;
  }

  int64_t FirstColumnOf(const std::string& src, const char* function_name) {
    LEPUSValue top =
        LEPUS_Eval(ctx_, src.c_str(), src.size(), "test.js",
                   LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL);
    EXPECT_FALSE(LEPUS_IsException(top));
    uint32_t count = 0;
    LEPUSFunctionBytecode** functions =
        GetDebuggerAllFunction(ctx_, top, &count);
    int64_t first = -1;
    for (uint32_t i = 0; i < count; ++i) {
      const char* name = GetFunctionName(ctx_, functions[i]);
      bool matched = name && strcmp(name, function_name) == 0;
      if (name && !LEPUS_IsGCMode(ctx_)) LEPUS_FreeCString(ctx_, name);
      if (!matched) continue;
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

  void ExpectDataColumn(const std::string& prefix) {
    std::string src =
        prefix + "function foo(e){var a=(void 0).data;return a}\nfoo();";
    EXPECT_EQ(FirstColumnOf(src, "foo"), CharColumn(src, ".data")) << src;
  }

  LEPUSRuntime* rt_ = nullptr;
  LEPUSContext* ctx_ = nullptr;
};

TEST_F(TemplateLiteralColumnTest, AsciiMultiLineTemplate) {
  ExpectDataColumn("var s=`abcd\nefgh`;");
}

TEST_F(TemplateLiteralColumnTest, MultiByteBeforeNewline) {
  ExpectDataColumn("var s=`中文中文\n中文中`;");
}

TEST_F(TemplateLiteralColumnTest, MultiByteOnEveryLine) {
  ExpectDataColumn("var s=`中文\n中文中文\n中`;");
}

TEST_F(TemplateLiteralColumnTest, MultiByteOnlyAfterNewline) {
  ExpectDataColumn("var s=`abcd\n中文中文`;");
}

TEST_F(TemplateLiteralColumnTest, TwoMultiLineTemplates) {
  ExpectDataColumn("var s=`中文\nx`,t=`中文中\ny`;");
}

TEST_F(TemplateLiteralColumnTest, SubstitutionBeforeNewline) {
  ExpectDataColumn("var s=`中文${1}中\n文中`;");
}

TEST_F(TemplateLiteralColumnTest, CarriageReturnNewline) {
  ExpectDataColumn("var s=`中文中文\r\n中文中`;");
}
