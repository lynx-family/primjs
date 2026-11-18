// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <cstring>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

namespace {

// Deep enough that the stack text is a real allocation of its own. A
// constructed error owns its object while the stack is built. A runtime error
// does not: the stack is built on the pending exception, which a failed
// allocation replaces.
constexpr const char* kThrowingScripts[] = {
    "function constructed(depth) {\n"
    "  if (depth === 0) throw new Error('at the bottom');\n"
    "  return constructed(depth - 1);\n"
    "}\n"
    "constructed(64);\n",
    "function runtime(depth) {\n"
    "  if (depth === 0) return null.missing;\n"
    "  return runtime(depth - 1);\n"
    "}\n"
    "runtime(64);\n",
};

// Failures that reach the backtrace lie just below the smallest working limit.
// Every byte counts: a window this narrow falls between coarser steps.
constexpr size_t kSweepBytes = 32 * 1024;
constexpr size_t kUnlimited = static_cast<size_t>(-1);

class AllocationFailureSweep : public ::testing::Test {
 protected:
  void SetUp() override {
    runtime_ = LEPUS_NewRuntime();
    ASSERT_NE(runtime_, nullptr);
    context_ = LEPUS_NewContext(runtime_);
    ASSERT_NE(context_, nullptr);
  }
  void TearDown() override {
    if (!runtime_) return;
    LEPUS_SetMemoryLimit(runtime_, kUnlimited);
    LEPUS_FreeContext(context_);
    LEPUS_FreeRuntime(runtime_);
  }
  void Release(LEPUSValue value) {
    if (!context_->rt->gc_enable) LEPUS_FreeValue(context_, value);
  }
  // Runs one failure point. Whatever failed, the result must be an exception
  // the embedder can take and a runtime that still works. True when the stack
  // was built, which only a run with enough memory reaches.
  bool Throw(const char* script, size_t limit) {
    // Compiled with no limit: this sweep is about running, not compiling.
    LEPUSValue compiled =
        LEPUS_Eval(context_, script, std::strlen(script), "<sweep>",
                   LEPUS_EVAL_TYPE_GLOBAL | LEPUS_EVAL_FLAG_COMPILE_ONLY);
    EXPECT_FALSE(LEPUS_IsException(compiled));
    LEPUS_SetMemoryLimit(runtime_, limit);
    LEPUSValue result = LEPUS_EvalFunction(context_, compiled, LEPUS_UNDEFINED);
    LEPUS_SetMemoryLimit(runtime_, kUnlimited);
    EXPECT_TRUE(LEPUS_IsException(result));
    LEPUSValue error = LEPUS_GetException(context_);
    EXPECT_FALSE(LEPUS_IsException(error));
    bool built = false;
    if (LEPUS_IsObject(error)) {
      LEPUSValue stack = LEPUS_GetPropertyStr(context_, error, "stack");
      EXPECT_FALSE(LEPUS_IsException(stack));
      built = LEPUS_IsString(stack);
      Release(stack);
    }
    Release(error);
    LEPUS_ResetUncatchableError(context_);
    return built;
  }
  // The smallest limit that gets the whole way through, near enough.
  size_t WorkingLimit(const char* script) {
    size_t low = 0;
    size_t high = 1024 * 1024;
    while (!Throw(script, high)) {
      low = high;
      high *= 2;
    }
    while (high - low > 1) {
      const size_t middle = low + (high - low) / 2;
      (Throw(script, middle) ? high : low) = middle;
    }
    return high;
  }
  LEPUSRuntime* runtime_ = nullptr;
  LEPUSContext* context_ = nullptr;
};

TEST_F(AllocationFailureSweep, BacktraceSurvivesEveryFailurePoint) {
  // The tracing heap grows in large steps, so a limit cannot pick an
  // allocation.
  if (runtime_->gc_enable) GTEST_SKIP() << "Needs byte-accurate limits";
  for (const char* script : kThrowingScripts) {
    // Running once warms atoms and shapes, so the sweep sees what a later throw
    // allocates.
    ASSERT_TRUE(Throw(script, kUnlimited));
    const size_t working = WorkingLimit(script);
    size_t failed = 0;
    size_t built = 0;
    for (size_t limit = working - kSweepBytes; limit <= working; ++limit) {
      (Throw(script, limit) ? built : failed) += 1;
    }
    // A sweep that saw only one outcome tested nothing.
    EXPECT_GT(failed, 0u);
    EXPECT_GT(built, 0u);
  }
  LEPUSValue value =
      LEPUS_Eval(context_, "6 * 7", 5, "<after>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(value));
  int32_t result = 0;
  EXPECT_EQ(LEPUS_ToInt32(context_, &result, value), 0);
  EXPECT_EQ(result, 42);
  Release(value);
}

}  // namespace
