// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include <fstream>
#include <sstream>
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
#include "gc/trace-gc.h"
#include "quickjs/include/primjs_monitor.h"
#include "quickjs/include/quickjs-inner.h"
#include "quickjs/source/quickjs-parser-lookahead.h"

// Strong override of the weak stub in primjs_monitor.cc so the host settings
// path can be exercised. It returns 0 unless a test sets it, which matches the
// stub, so other tests linked into the same binary are unaffected.
static int g_test_settings_flag = 0;
int GetSettingsFlag() { return g_test_settings_flag; }

namespace parser_lookahead_test {

// Evaluates `src` (expected to throw) and returns the exception's stack.
static std::string EvalAndGetStack(LEPUSContext* ctx, const char* src) {
  LEPUSValue ret =
      LEPUS_Eval(ctx, src, strlen(src), "test.js", LEPUS_EVAL_TYPE_GLOBAL);
  EXPECT_TRUE(LEPUS_IsException(ret));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, ret);

  std::string result;
  LEPUSValue exception_val = LEPUS_GetException(ctx);
  HandleScope func_scope(ctx, &exception_val, HANDLE_TYPE_LEPUS_VALUE);
  LEPUSValue stack_val = LEPUS_GetPropertyStr(ctx, exception_val, "stack");
  if (!LEPUS_IsUndefined(stack_val)) {
    const char* stack = LEPUS_ToCString(ctx, stack_val);
    if (stack) result = stack;
    if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeCString(ctx, stack);
  }
  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, stack_val);
    LEPUS_FreeValue(ctx, exception_val);
  }
  return result;
}

static const char* kWrappedIdentifier =
    "function f(){\n  return (((missingValue))) + (5);\n}\nf();";
static const char* kNestedLiteral =
    "function f(){\n  return ({x: [1, 2, innermost]});\n}\nf();";
// The byte scan falls back to the full lexer for '/' and '`'.
static const char* kSlashFallback =
    "function f(){\n  return (1 / 2, missingValue);\n}\nf();";
static const char* kTemplateFallback =
    "function f(){\n  return ([`x`, 1]).length + missingValue;\n}\nf();";

class ParserLookaheadTest : public ::testing::Test {
 protected:
  struct Engine {
    LEPUSRuntime* rt = nullptr;
    LEPUSContext* ctx = nullptr;
  };

  static Engine Create(uint8_t flags) {
    Engine e;
    e.rt = LEPUS_NewRuntime();
    // Override whatever the host setting returned so the test is
    // deterministic.
    e.rt->parser_lookahead_flags = flags;
    e.ctx = LEPUS_NewContext(e.rt);
    return e;
  }

  static void Destroy(Engine& e) {
    LEPUS_FreeContext(e.ctx);
    LEPUS_FreeRuntime(e.rt);
  }
};

// A lookahead scan must not move the column of a later identifier on the
// same line, whether the scan is skipped, completes, or falls back.
TEST_F(ParserLookaheadTest, ColumnsDoNotDependOnSetting) {
  const struct {
    const char* src;
    const char* column;
  } cases[] = {
      {kWrappedIdentifier, ":2:13"},
      {kNestedLiteral, ":2:22"},
      {kSlashFallback, ":2:18"},
      {kTemplateFallback, ":2:30"},
  };
  for (uint8_t flags = 0; flags <= primjs::kAllLookaheadOptimizations;
       ++flags) {
    Engine e = Create(flags);
    for (const auto& c : cases) {
      const std::string stack = EvalAndGetStack(e.ctx, c.src);
      EXPECT_NE(stack.find(c.column), std::string::npos)
          << "parser_lookahead_flags=" << int(flags) << " stack=" << stack;
    }
    Destroy(e);
  }
}

// Runs the syntax cases in unit_test/parser_lookahead.js with each
// optimization alone, both, and neither. CI also runs that file through the
// qjs binary, but there the host setting is always 0, so only this test
// covers the optimized paths.
TEST_F(ParserLookaheadTest, SyntaxCasesWithEachSetting) {
  std::ifstream file(TEST_CASE_DIR "unit_test/parser_lookahead.js");
  ASSERT_TRUE(file.good());
  std::stringstream buffer;
  buffer << file.rdbuf();
  const std::string src = buffer.str();

  for (uint8_t flags = 0; flags <= primjs::kAllLookaheadOptimizations;
       ++flags) {
    Engine e = Create(flags);
    LEPUSValue ret = LEPUS_Eval(e.ctx, src.c_str(), src.length(),
                                "parser_lookahead.js", LEPUS_EVAL_TYPE_GLOBAL);
    const bool failed = LEPUS_IsException(ret);
    if (!LEPUS_IsGCMode(e.ctx)) LEPUS_FreeValue(e.ctx, ret);
    if (failed) lepus_std_dump_error(e.ctx);
    EXPECT_FALSE(failed) << "parser_lookahead_flags=" << int(flags);
    Destroy(e);
  }
}

// The host turns each optimization on with its own bit of GetSettingsFlag(),
// which is read when the runtime is created. A runtime keeps its value when
// later runtimes see a different setting.
TEST_F(ParserLookaheadTest, HostSettingsFlagIsReadPerRuntime) {
  const struct {
    int settings;
    uint8_t flags;
  } cases[] = {
      {0, 0},
      {PARSER_ASSIGNMENT_SCAN_ENABLE, primjs::kSkipAssignmentScan},
      {PARSER_WRAPPER_SHORTCUT_ENABLE, primjs::kSkipWrappedExpression},
      {PARSER_ASSIGNMENT_SCAN_ENABLE | PARSER_WRAPPER_SHORTCUT_ENABLE,
       primjs::kAllLookaheadOptimizations},
  };
  for (const auto& c : cases) {
    g_test_settings_flag = c.settings;
    LEPUSRuntime* rt = LEPUS_NewRuntime();
    LEPUSContext* ctx = LEPUS_NewContext(rt);
    EXPECT_EQ(rt->parser_lookahead_flags, c.flags) << "settings=" << c.settings;
    EXPECT_NE(EvalAndGetStack(ctx, kWrappedIdentifier).find(":2:13"),
              std::string::npos);
    LEPUS_FreeContext(ctx);
    LEPUS_FreeRuntime(rt);
  }

  g_test_settings_flag =
      PARSER_ASSIGNMENT_SCAN_ENABLE | PARSER_WRAPPER_SHORTCUT_ENABLE;
  LEPUSRuntime* on_rt = LEPUS_NewRuntime();
  g_test_settings_flag = 0;
  LEPUSRuntime* off_rt = LEPUS_NewRuntime();
  EXPECT_EQ(on_rt->parser_lookahead_flags, primjs::kAllLookaheadOptimizations);
  EXPECT_EQ(off_rt->parser_lookahead_flags, 0);
  LEPUS_FreeRuntime(off_rt);
  LEPUS_FreeRuntime(on_rt);
}

}  // namespace parser_lookahead_test
