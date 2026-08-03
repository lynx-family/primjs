// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>
#include <string>

#include "gtest/gtest.h"

extern "C" {
#include "quickjs/include/quickjs.h"
}

namespace {

std::string CoverageFunctionRecord(const std::string& dump,
                                   const char* function_name) {
  std::string prefix = "\"functionName\":\"";
  prefix += function_name;
  prefix += "\"";
  size_t start = dump.find(prefix);
  if (start == std::string::npos) return "";
  size_t end = dump.find("],\"isBlockCoverage\":true}", start);
  if (end == std::string::npos) return "";
  return dump.substr(start, end - start);
}

std::string CoverageDump(LEPUSContext* ctx, int32_t runtime_id = -1) {
  size_t dump_length = 0;
  const char* dump_string =
      JS_GetCoverageDumpString(ctx, runtime_id, &dump_length);
  EXPECT_NE(dump_string, nullptr);
  if (!dump_string) return "";

  std::string dump(dump_string, dump_length);
  JS_FreeCoverageDumpString(dump_string);
  return dump;
}

size_t CoverageRangeCountStartingAt(const std::string& function_record,
                                    size_t start_offset) {
  const std::string prefix = "[" + std::to_string(start_offset) + ",";
  size_t count = 0;
  size_t position = 0;
  while ((position = function_record.find(prefix, position)) !=
         std::string::npos) {
    ++count;
    position += prefix.size();
  }
  return count;
}

int CoverageCountStartingAt(const std::string& function_record,
                            size_t start_offset) {
  const std::string prefix = "[" + std::to_string(start_offset) + ",";
  size_t position = function_record.find(prefix);
  if (position == std::string::npos) return -1;

  const size_t end_offset_end =
      function_record.find(',', position + prefix.size());
  if (end_offset_end == std::string::npos) return -1;
  const size_t count_end = function_record.find(']', end_offset_end + 1);
  if (count_end == std::string::npos) return -1;
  return std::stoi(function_record.substr(end_offset_end + 1,
                                          count_end - end_offset_end - 1));
}

bool CoverageRecordHasCount(const std::string& function_record, int count) {
  return function_record.find("," + std::to_string(count) + "]") !=
         std::string::npos;
}

TEST(QjsCoverage, CoverageCompileOnlyCannotGenerateCodeCache) {
  constexpr int32_t kRuntimeId = 101;
  constexpr char kSource[] = "function covered() { return 1; }";

  LEPUSRuntime* rt = LEPUS_NewRuntime();
  ASSERT_NE(rt, nullptr);
  LEPUSContext* ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);

  LEPUSValue compiled = LEPUS_Eval_WITH_COVERAGE(
      ctx, kSource, strlen(kSource), "coverage_codecache.js",
      LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL, 0, kRuntimeId);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  size_t bytecode_length = 1;
  uint8_t* bytecode = LEPUS_WriteObject(ctx, &bytecode_length, compiled,
                                        LEPUS_WRITE_OBJ_BYTECODE);
  EXPECT_EQ(bytecode, nullptr);
  EXPECT_EQ(bytecode_length, 0u);

  LEPUSValue exception = LEPUS_GetException(ctx);
  const char* exception_string = LEPUS_ToCString(ctx, exception);
  ASSERT_NE(exception_string, nullptr);
  EXPECT_NE(std::string(exception_string)
                .find("cannot serialize coverage-instrumented bytecode"),
            std::string::npos);

  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeCString(ctx, exception_string);
    LEPUS_FreeValue(ctx, exception);
    LEPUS_FreeValue(ctx, compiled);
    lepus_free(ctx, bytecode);
  }
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCoverage, DumpFiltersByRuntimeId) {
  constexpr int32_t kFirstRuntimeId = 101;
  constexpr int32_t kSecondRuntimeId = 202;
  constexpr char kFirstSource[] = R"(
    (function first() {
      return 1;
    })();
  )";
  constexpr char kSecondSource[] = R"(
    (function second() {
      return 2;
    })();
  )";

  LEPUSRuntime* rt = LEPUS_NewRuntime();
  ASSERT_NE(rt, nullptr);
  LEPUSContext* ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);

  LEPUSValue result = LEPUS_Eval_WITH_COVERAGE(
      ctx, kFirstSource, strlen(kFirstSource), "coverage_first.js",
      LEPUS_EVAL_TYPE_GLOBAL, 0, kFirstRuntimeId);
  ASSERT_FALSE(LEPUS_IsException(result));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, result);
  result = LEPUS_Eval_WITH_COVERAGE(
      ctx, kSecondSource, strlen(kSecondSource), "coverage_second.js",
      LEPUS_EVAL_TYPE_GLOBAL, 0, kSecondRuntimeId);
  ASSERT_FALSE(LEPUS_IsException(result));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, result);

  std::string dump = CoverageDump(ctx, kFirstRuntimeId);
  EXPECT_NE(dump.find("\"scriptId\":\"101\""), std::string::npos);
  EXPECT_NE(dump.find("\"url\":\"coverage_first.js\""), std::string::npos);
  EXPECT_EQ(dump.find("coverage_second.js"), std::string::npos);
  EXPECT_NE(dump.find("\"ranges\":[["), std::string::npos);
  EXPECT_EQ(dump.find("\"startOffset\""), std::string::npos);
  EXPECT_EQ(dump.find("\"endOffset\""), std::string::npos);
  EXPECT_EQ(dump.find("\"count\""), std::string::npos);
  EXPECT_FALSE(CoverageFunctionRecord(dump, "first").empty());
  EXPECT_TRUE(CoverageFunctionRecord(dump, "second").empty());

  dump = CoverageDump(ctx, kSecondRuntimeId);
  EXPECT_NE(dump.find("\"scriptId\":\"202\""), std::string::npos);
  EXPECT_EQ(dump.find("coverage_first.js"), std::string::npos);
  EXPECT_NE(dump.find("\"url\":\"coverage_second.js\""), std::string::npos);
  EXPECT_TRUE(CoverageFunctionRecord(dump, "first").empty());
  EXPECT_FALSE(CoverageFunctionRecord(dump, "second").empty());

  EXPECT_EQ(CoverageDump(ctx, 12345), "{\"result\":[]}");

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCoverage, DumpBufferSurvivesGC) {
  constexpr int32_t kRuntimeId = 103;
  constexpr char kSource[] = R"(
    function survivesGC() {
      return 1;
    }
    survivesGC();
  )";

  LEPUSRuntime* rt = LEPUS_NewRuntime();
  ASSERT_NE(rt, nullptr);
  LEPUSContext* ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);

  LEPUSValue result = LEPUS_Eval_WITH_COVERAGE(
      ctx, kSource, strlen(kSource), "coverage_dump_buffer.js",
      LEPUS_EVAL_TYPE_GLOBAL, 0, kRuntimeId);
  ASSERT_FALSE(LEPUS_IsException(result));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, result);

  size_t dump_length = 0;
  const char* dump = JS_GetCoverageDumpString(ctx, kRuntimeId, &dump_length);
  ASSERT_NE(dump, nullptr);

  LEPUS_RunGC(rt);

  const std::string dump_copy(dump, dump_length);
  EXPECT_NE(dump_copy.find("\"scriptId\":\"103\""), std::string::npos);
  EXPECT_FALSE(CoverageFunctionRecord(dump_copy, "survivesGC").empty());
  JS_FreeCoverageDumpString(dump);

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCoverage, NonPositiveRuntimeIdDoesNotEnableCoverage) {
  constexpr char kZeroRuntimeSource[] = R"(
    (function zeroRuntime() {
      return 1;
    })();
  )";
  constexpr char kNegativeRuntimeSource[] = R"(
    (function negativeRuntime() {
      return 2;
    })();
  )";

  LEPUSRuntime* rt = LEPUS_NewRuntime();
  ASSERT_NE(rt, nullptr);
  LEPUSContext* ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);

  LEPUSValue result = LEPUS_Eval_WITH_COVERAGE(
      ctx, kZeroRuntimeSource, strlen(kZeroRuntimeSource),
      "coverage_zero_runtime.js", LEPUS_EVAL_TYPE_GLOBAL, 0, 0);
  ASSERT_FALSE(LEPUS_IsException(result));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, result);
  result = LEPUS_Eval_WITH_COVERAGE(
      ctx, kNegativeRuntimeSource, strlen(kNegativeRuntimeSource),
      "coverage_negative_runtime.js", LEPUS_EVAL_TYPE_GLOBAL, 0, -1);
  ASSERT_FALSE(LEPUS_IsException(result));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, result);

  EXPECT_EQ(CoverageDump(ctx, -1), "{\"result\":[]}");

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCoverage, PositiveRuntimeIdAutomaticallyCollectsCoverage) {
  constexpr int32_t kRuntimeId = 101;
  constexpr char kSkippedSource[] = R"(
    function skipped() {
      return 1;
    }
    skipped();
  )";
  constexpr char kTrackedSource[] = R"(
    function tracked() {
      return 2;
    }
    tracked();
  )";

  LEPUSRuntime* rt = LEPUS_NewRuntime();
  ASSERT_NE(rt, nullptr);
  LEPUSContext* ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);

  LEPUSValue result =
      LEPUS_Eval(ctx, kSkippedSource, strlen(kSkippedSource),
                 "coverage_without_runtime_id.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(result));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, result);
  EXPECT_EQ(CoverageDump(ctx, kRuntimeId), "{\"result\":[]}");

  result = LEPUS_Eval_WITH_COVERAGE(ctx, kTrackedSource, strlen(kTrackedSource),
                                    "coverage_positive_runtime.js",
                                    LEPUS_EVAL_TYPE_GLOBAL, 0, kRuntimeId);
  ASSERT_FALSE(LEPUS_IsException(result));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, result);

  std::string dump = CoverageDump(ctx, kRuntimeId);
  EXPECT_TRUE(CoverageFunctionRecord(dump, "skipped").empty());
  std::string tracked = CoverageFunctionRecord(dump, "tracked");
  EXPECT_FALSE(tracked.empty());
  EXPECT_TRUE(CoverageRecordHasCount(tracked, 1));

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCoverage, CoverageCountersContinueAfterEval) {
  constexpr int32_t kRuntimeId = 102;
  constexpr char kSource[] = R"(
    function hit() {
      return 1;
    }
  )";

  LEPUSRuntime* rt = LEPUS_NewRuntime();
  ASSERT_NE(rt, nullptr);
  LEPUSContext* ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);

  LEPUSValue result = LEPUS_Eval_WITH_COVERAGE(
      ctx, kSource, strlen(kSource), "coverage_continues_after_eval.js",
      LEPUS_EVAL_TYPE_GLOBAL, 0, kRuntimeId);
  ASSERT_FALSE(LEPUS_IsException(result));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, result);

  std::string hit =
      CoverageFunctionRecord(CoverageDump(ctx, kRuntimeId), "hit");
  ASSERT_FALSE(hit.empty());
  EXPECT_FALSE(CoverageRecordHasCount(hit, 1));

  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  LEPUSValue hit_function = LEPUS_GetPropertyStr(ctx, global, "hit");
  ASSERT_TRUE(LEPUS_IsFunction(ctx, hit_function));
  LEPUSValue call_result =
      LEPUS_Call(ctx, hit_function, LEPUS_UNDEFINED, 0, nullptr);
  ASSERT_FALSE(LEPUS_IsException(call_result));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, call_result);

  std::string hit_after_first_call =
      CoverageFunctionRecord(CoverageDump(ctx, kRuntimeId), "hit");
  EXPECT_TRUE(CoverageRecordHasCount(hit_after_first_call, 1));

  call_result = LEPUS_Call(ctx, hit_function, LEPUS_UNDEFINED, 0, nullptr);
  ASSERT_FALSE(LEPUS_IsException(call_result));

  hit = CoverageFunctionRecord(CoverageDump(ctx, kRuntimeId), "hit");
  EXPECT_TRUE(CoverageRecordHasCount(hit, 2));

  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, call_result);
    LEPUS_FreeValue(ctx, hit_function);
    LEPUS_FreeValue(ctx, global);
  }
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCoverage, PrimjsCountersSurviveGC) {
  constexpr int32_t kRuntimeId = 103;
  constexpr char kSource[] = R"(
    (function hit(value) {
      if (value) {
        return 1;
      } else {
        return 2;
      }
    })(true);
    (function neverCalled() {
      return 3;
    });
  )";

  LEPUSRuntime* rt = LEPUS_NewRuntime();
  ASSERT_NE(rt, nullptr);
  LEPUSContext* ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);

  LEPUSValue result = LEPUS_Eval_WITH_COVERAGE(
      ctx, kSource, strlen(kSource), "coverage_test.js", LEPUS_EVAL_TYPE_GLOBAL,
      0, kRuntimeId);
  ASSERT_FALSE(LEPUS_IsException(result));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, result);

  LEPUS_RunGC(rt);

  std::string dump = CoverageDump(ctx, kRuntimeId);

  std::string hit = CoverageFunctionRecord(dump, "hit");
  std::string never_called = CoverageFunctionRecord(dump, "neverCalled");
  EXPECT_FALSE(hit.empty());
  EXPECT_TRUE(CoverageRecordHasCount(hit, 1));
  EXPECT_FALSE(never_called.empty());
  EXPECT_TRUE(CoverageRecordHasCount(never_called, 0));
  EXPECT_FALSE(CoverageRecordHasCount(never_called, 1));

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

TEST(QjsCoverage, ContinuationsOnlyMarkDistinctReachability) {
  constexpr int32_t kRuntimeId = 104;
  constexpr char kSource[] = R"(
    var sink = 0;
    function terminal() {
      return 1;
    }
    function afterIf(value) {
      if (value) {
        sink++;
      }
      sink++;
    }
    function expressionContinuation(flag) {
      return (flag ? fail() : 0) + tail();
    }
    function fail() {
      throw new Error("boom");
    }
    function tail() {
      return 7;
    }
    function* stalledGenerator() {
      return (yield 1) + tail();
    }
    function* resumedGenerator() {
      return (yield 1) + tail();
    }

    terminal();
    afterIf(true);
    afterIf(false);
    try {
      expressionContinuation(true);
    } catch (_) {}
    expressionContinuation(false);

    var stalled = stalledGenerator();
    stalled.next();
    var resumed = resumedGenerator();
    resumed.next();
    resumed.next(2);
  )";

  LEPUSRuntime* rt = LEPUS_NewRuntime();
  ASSERT_NE(rt, nullptr);
  LEPUSContext* ctx = LEPUS_NewContext(rt);
  ASSERT_NE(ctx, nullptr);

  LEPUSValue result = LEPUS_Eval_WITH_COVERAGE(
      ctx, kSource, strlen(kSource), "coverage_continuations.js",
      LEPUS_EVAL_TYPE_GLOBAL, 0, kRuntimeId);
  ASSERT_FALSE(LEPUS_IsException(result));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, result);

  const std::string dump = CoverageDump(ctx, kRuntimeId);

  const char* terminal_return = strstr(kSource, "return 1;");
  ASSERT_NE(terminal_return, nullptr);
  const char* terminal_end = strchr(terminal_return, '}');
  ASSERT_NE(terminal_end, nullptr);
  const std::string terminal = CoverageFunctionRecord(dump, "terminal");
  ASSERT_FALSE(terminal.empty());
  EXPECT_EQ(CoverageRangeCountStartingAt(
                terminal, static_cast<size_t>(terminal_end - kSource)),
            0u);

  const char* after_if_function = strstr(kSource, "function afterIf");
  ASSERT_NE(after_if_function, nullptr);
  const char* first_sink = strstr(after_if_function, "sink++;");
  ASSERT_NE(first_sink, nullptr);
  const char* after_if_sink = strstr(first_sink + 1, "sink++;");
  ASSERT_NE(after_if_sink, nullptr);
  const size_t after_if_sink_offset =
      static_cast<size_t>(after_if_sink - kSource);
  const std::string after_if = CoverageFunctionRecord(dump, "afterIf");
  ASSERT_FALSE(after_if.empty());
  EXPECT_EQ(CoverageRangeCountStartingAt(after_if, after_if_sink_offset), 1u);
  EXPECT_EQ(CoverageCountStartingAt(after_if, after_if_sink_offset), 2);

  const char* expression_function =
      strstr(kSource, "function expressionContinuation");
  ASSERT_NE(expression_function, nullptr);
  const char* expression_merge = strstr(expression_function, ") + tail();");
  ASSERT_NE(expression_merge, nullptr);
  const std::string expression =
      CoverageFunctionRecord(dump, "expressionContinuation");
  ASSERT_FALSE(expression.empty());
  EXPECT_EQ(CoverageCountStartingAt(
                expression, static_cast<size_t>(expression_merge - kSource)),
            1);

  const char* stalled_function = strstr(kSource, "function* stalledGenerator");
  ASSERT_NE(stalled_function, nullptr);
  const char* stalled_resume = strstr(stalled_function, ") + tail();");
  ASSERT_NE(stalled_resume, nullptr);
  const std::string stalled = CoverageFunctionRecord(dump, "stalledGenerator");
  ASSERT_FALSE(stalled.empty());
  EXPECT_EQ(CoverageCountStartingAt(
                stalled, static_cast<size_t>(stalled_resume - kSource)),
            0);

  const char* resumed_function = strstr(kSource, "function* resumedGenerator");
  ASSERT_NE(resumed_function, nullptr);
  const char* resumed_resume = strstr(resumed_function, ") + tail();");
  ASSERT_NE(resumed_resume, nullptr);
  const std::string resumed = CoverageFunctionRecord(dump, "resumedGenerator");
  ASSERT_FALSE(resumed.empty());
  EXPECT_EQ(CoverageCountStartingAt(
                resumed, static_cast<size_t>(resumed_resume - kSource)),
            1);

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
}

}  // namespace
