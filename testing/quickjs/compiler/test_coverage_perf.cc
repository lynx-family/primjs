// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// Micro-benchmark that isolates the JS-coverage overhead of compilation,
// execution, and dump serialization:
//
//   * compile  : parser registers coverage slots and emits OP_inc_coverage.
//                Isolated with LEPUS_EVAL_FLAG_COMPILE_ONLY so no user code
//                actually runs.
//   * execute  : the extra OP_inc_coverage opcodes are dispatched and bump the
//                per-slot counter on every hit.
//   * dump     : archived coverage ranges are serialized to the upload format.
//
// For each phase we measure a baseline (coverage fully off) against a coverage
// run and print `(coverage - baseline) / baseline`.

#include <algorithm>
#include <chrono>
#include <cstdio>
#include <cstring>
#include <iomanip>
#include <iostream>
#include <string>
#include <vector>

#include "gtest/gtest.h"

extern "C" {
#include "quickjs/include/quickjs.h"
}

namespace {

// Repetitions of the whole measured loop; we keep the fastest run to shed
// scheduler / cache noise.
constexpr int kTrials = 7;

double MinSeconds(const std::vector<double>& samples) {
  double best = samples.front();
  for (double s : samples) best = std::min(best, s);
  return best;
}

// Builds a source string with many small functions, each with branches and a
// loop, so the parser has a large amount of coverage slots to register.
std::string MakeCompileWorkload(int function_count) {
  std::string src;
  src.reserve(function_count * 256);
  for (int i = 0; i < function_count; ++i) {
    char name[32];
    std::snprintf(name, sizeof(name), "f%d", i);
    src += "function ";
    src += name;
    src += "(a, b) {\n";
    src += "  var total = 0;\n";
    src += "  for (var k = 0; k < a; k++) {\n";
    src += "    if ((k & 1) === 0) {\n";
    src += "      total += k * b;\n";
    src += "    } else if (k % 3 === 0) {\n";
    src += "      total -= k;\n";
    src += "    } else {\n";
    src += "      total += 1;\n";
    src += "    }\n";
    src += "  }\n";
    src += "  return total > 0 ? total : -total;\n";
    src += "}\n";
  }
  return src;
}

// A single hot function whose body is dominated by coverage-instrumented
// branches and loop iterations, so execution overhead is easy to observe.
constexpr char kExecuteWorkload[] = R"(
  function work(rounds) {
    var acc = 0;
    for (var i = 0; i < rounds; i++) {
      if ((i & 1) === 0) {
        acc += i;
      } else if (i % 5 === 0) {
        acc -= i;
      } else {
        acc += (i % 7);
      }
      for (var j = 0; j < 8; j++) {
        acc += j > 4 ? j : -j;
      }
    }
    return acc;
  }
)";

// Compile `source` `iterations` times (compile-only, result discarded) and
// return the elapsed seconds for the whole loop.
double CompilePassSeconds(const std::string& source, int iterations,
                          bool coverage) {
  constexpr int32_t kRuntimeId = 301;
  LEPUSRuntime* rt = LEPUS_NewRuntime();
  LEPUSContext* ctx = LEPUS_NewContext(rt);

  auto begin = std::chrono::steady_clock::now();
  for (int i = 0; i < iterations; ++i) {
    LEPUSValue fn =
        coverage
            ? LEPUS_Eval_WITH_COVERAGE(
                  ctx, source.c_str(), source.size(),
                  "coverage_perf_compile.js",
                  LEPUS_EVAL_TYPE_GLOBAL | LEPUS_EVAL_FLAG_COMPILE_ONLY, 0,
                  kRuntimeId)
            : LEPUS_Eval2(ctx, source.c_str(), source.size(),
                          "coverage_perf_compile.js",
                          LEPUS_EVAL_TYPE_GLOBAL | LEPUS_EVAL_FLAG_COMPILE_ONLY,
                          0);
    EXPECT_FALSE(LEPUS_IsException(fn));
    if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, fn);
  }
  auto end = std::chrono::steady_clock::now();

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
  return std::chrono::duration<double>(end - begin).count();
}

// Compile the workload once, then call work(rounds) `iterations` times and
// return the loop's elapsed seconds. A positive runtime ID inserts coverage
// opcodes and makes every hit bump its counter.
double ExecutePassSeconds(int iterations, int rounds, bool coverage) {
  constexpr int32_t kRuntimeId = 302;
  LEPUSRuntime* rt = LEPUS_NewRuntime();
  LEPUSContext* ctx = LEPUS_NewContext(rt);

  LEPUSValue script =
      coverage ? LEPUS_Eval_WITH_COVERAGE(ctx, kExecuteWorkload,
                                          strlen(kExecuteWorkload),
                                          "coverage_perf_execute.js",
                                          LEPUS_EVAL_TYPE_GLOBAL, 0, kRuntimeId)
               : LEPUS_Eval(ctx, kExecuteWorkload, strlen(kExecuteWorkload),
                            "coverage_perf_execute.js", LEPUS_EVAL_TYPE_GLOBAL);
  EXPECT_FALSE(LEPUS_IsException(script));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, script);

  LEPUSValue global = LEPUS_GetGlobalObject(ctx);
  LEPUSValue work = LEPUS_GetPropertyStr(ctx, global, "work");
  EXPECT_TRUE(LEPUS_IsFunction(ctx, work));
  LEPUSValue arg = LEPUS_NewInt32(ctx, rounds);

  // Warm up so the first call's lazy work is not charged to the measurement.
  LEPUSValue warm = LEPUS_Call(ctx, work, LEPUS_UNDEFINED, 1, &arg);
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, warm);

  auto begin = std::chrono::steady_clock::now();
  for (int i = 0; i < iterations; ++i) {
    LEPUSValue r = LEPUS_Call(ctx, work, LEPUS_UNDEFINED, 1, &arg);
    if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, r);
  }
  auto end = std::chrono::steady_clock::now();

  if (!LEPUS_IsGCMode(ctx)) {
    LEPUS_FreeValue(ctx, work);
    LEPUS_FreeValue(ctx, global);
  }
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
  return std::chrono::duration<double>(end - begin).count();
}

struct DumpPassResult {
  double seconds;
  size_t bytes;
};

DumpPassResult DumpPassSeconds(const std::string& source, int iterations) {
  constexpr int32_t kRuntimeId = 303;
  LEPUSRuntime* rt = LEPUS_NewRuntime();
  LEPUSContext* ctx = LEPUS_NewContext(rt);

  LEPUSValue script = LEPUS_Eval_WITH_COVERAGE(
      ctx, source.c_str(), source.size(), "coverage_perf_dump.js",
      LEPUS_EVAL_TYPE_GLOBAL, 0, kRuntimeId);
  EXPECT_FALSE(LEPUS_IsException(script));
  if (!LEPUS_IsGCMode(ctx)) LEPUS_FreeValue(ctx, script);

  size_t dump_size = 0;
  const char* warm_string =
      JS_GetCoverageDumpString(ctx, kRuntimeId, &dump_size);
  EXPECT_NE(warm_string, nullptr);
  JS_FreeCoverageDumpString(warm_string);

  auto begin = std::chrono::steady_clock::now();
  for (int i = 0; i < iterations; ++i) {
    size_t length = 0;
    const char* dump = JS_GetCoverageDumpString(ctx, kRuntimeId, &length);
    EXPECT_NE(dump, nullptr);
    JS_FreeCoverageDumpString(dump);
  }
  auto end = std::chrono::steady_clock::now();

  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
  return {std::chrono::duration<double>(end - begin).count(), dump_size};
}

TEST(QjsCoveragePerf, CompileAndExecuteDegradationRatio) {
  // ---- compile phase -----------------------------------------------------
  constexpr int kCompileFunctions = 200;
  constexpr int kCompileIterations = 400;
  const std::string compile_src = MakeCompileWorkload(kCompileFunctions);

  std::vector<double> compile_baseline, compile_coverage;
  for (int t = 0; t < kTrials; ++t) {
    compile_baseline.push_back(
        CompilePassSeconds(compile_src, kCompileIterations, false));
    compile_coverage.push_back(
        CompilePassSeconds(compile_src, kCompileIterations, true));
  }
  double compile_base = MinSeconds(compile_baseline);
  double compile_cov = MinSeconds(compile_coverage);
  double compile_ratio = (compile_cov - compile_base) / compile_base;

  // ---- execute phase -----------------------------------------------------
  constexpr int kExecuteIterations = 2000;
  constexpr int kExecuteRounds = 2000;

  std::vector<double> exec_baseline, exec_coverage;
  for (int t = 0; t < kTrials; ++t) {
    exec_baseline.push_back(
        ExecutePassSeconds(kExecuteIterations, kExecuteRounds, false));
    exec_coverage.push_back(
        ExecutePassSeconds(kExecuteIterations, kExecuteRounds, true));
  }
  double exec_base = MinSeconds(exec_baseline);
  double exec_cov = MinSeconds(exec_coverage);
  double exec_ratio = (exec_cov - exec_base) / exec_base;

  std::cout << std::fixed << std::setprecision(3)
            << "\n[coverage-perf] compile phase: baseline="
            << compile_base * 1e3 << " ms  coverage=" << compile_cov * 1e3
            << " ms  degradation=" << std::setprecision(2)
            << compile_ratio * 100.0 << "%\n"
            << std::setprecision(3)
            << "[coverage-perf] execute phase: baseline=" << exec_base * 1e3
            << " ms  coverage=" << exec_cov * 1e3 << " ms\n"
            << std::setprecision(2)
            << "[coverage-perf]   -> total degradation=" << exec_ratio * 100.0
            << "%" << std::endl;

  // Enabling coverage must never make either phase faster; a negative ratio
  // would signal a broken measurement rather than a real speed-up.
  EXPECT_GT(compile_cov, 0.0);
  EXPECT_GT(exec_cov, 0.0);
  EXPECT_GE(compile_ratio, -0.05);
  EXPECT_GE(exec_ratio, -0.05);
}

TEST(QjsCoveragePerf, DumpSerialization) {
  constexpr int kDumpFunctions = 500;
  constexpr int kDumpIterations = 30;
  const std::string source = MakeCompileWorkload(kDumpFunctions);

  std::vector<double> samples;
  size_t dump_size = 0;
  for (int t = 0; t < kTrials; ++t) {
    DumpPassResult result = DumpPassSeconds(source, kDumpIterations);
    samples.push_back(result.seconds);
    dump_size = result.bytes;
  }

  const double seconds_per_dump =
      MinSeconds(samples) / static_cast<double>(kDumpIterations);
  std::cout << std::fixed << std::setprecision(3)
            << "\n[coverage-perf] dump phase: size=" << dump_size
            << " bytes  time=" << seconds_per_dump * 1e3 << " ms/dump"
            << std::endl;

  EXPECT_GT(dump_size, 0u);
  EXPECT_GT(seconds_per_dump, 0.0);
}

}  // namespace
