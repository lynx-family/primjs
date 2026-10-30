// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <cstring>
#include <string>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/libunicode.h"
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

class UnicodeInterruptTest : public ::testing::Test {
 protected:
  void SetUp() override {
    runtime_ = LEPUS_NewRuntime();
    ASSERT_NE(runtime_, nullptr);
    context_ = LEPUS_NewContext(runtime_);
    ASSERT_NE(context_, nullptr);
  }
  void TearDown() override {
    LEPUS_SetInterruptHandler(runtime_, nullptr, nullptr);
    LEPUS_FreeContext(context_);
    LEPUS_FreeRuntime(runtime_);
  }
  LEPUSValue Evaluate(const char* source) {
    return LEPUS_Eval(context_, source, std::strlen(source), "<unicode-test>",
                      LEPUS_EVAL_TYPE_GLOBAL);
  }
  void Release(LEPUSValue value) {
    if (!context_->rt->gc_enable) LEPUS_FreeValue(context_, value);
  }
  static int Interrupt(LEPUSRuntime*, void* opaque) {
    auto* calls = static_cast<int*>(opaque);
    return ++*calls >= 3;
  }
  void CheckInterruption(const char* prepare, const char* operation) {
    LEPUSValue value = Evaluate(prepare);
    ASSERT_FALSE(LEPUS_IsException(value));
    Release(value);
    int polls = 0;
    context_->interrupt_counter = JS_INTERRUPT_COUNTER_INIT;
    LEPUS_SetInterruptHandler(runtime_, Interrupt, &polls);
    const std::string guarded =
        std::string("var unicodeCaught = false; try { ") + operation +
        " } catch (e) { unicodeCaught = true; }";
    value = Evaluate(guarded.c_str());
    EXPECT_TRUE(LEPUS_IsException(value));
    EXPECT_EQ(polls, 3);
    Release(value);
    LEPUS_SetInterruptHandler(runtime_, nullptr, nullptr);
    value = LEPUS_GetException(context_);
    Release(value);
    LEPUS_ResetUncatchableError(context_);
    value = Evaluate("unicodeCaught ? -1 : 42");
    int32_t result = 0;
    ASSERT_FALSE(LEPUS_IsException(value));
    EXPECT_EQ(LEPUS_ToInt32(context_, &result, value), 0);
    EXPECT_EQ(result, 42);
    Release(value);
  }
  LEPUSRuntime* runtime_ = nullptr;
  LEPUSContext* context_ = nullptr;
};

TEST_F(UnicodeInterruptTest, CaseMappingStopsAndLeavesRuntimeUsable) {
  CheckInterruption("var unicodeInput = 'aB'.repeat(262144)",
                    "unicodeInput.toUpperCase()");
  CheckInterruption("var unicodeInput = 'aB'.repeat(262144)",
                    "unicodeInput.toLowerCase()");
}

TEST_F(UnicodeInterruptTest, FinalSigmaScanStopsAndLeavesRuntimeUsable) {
  CheckInterruption("var unicodeInput = 'A\\u03a3' + '\\u0301'.repeat(262144)",
                    "unicodeInput.toLowerCase()");
}

#ifdef CONFIG_ALL_UNICODE
TEST_F(UnicodeInterruptTest, NormalizationStopsAndLeavesRuntimeUsable) {
  for (const char* form : {"NFC", "NFD", "NFKC", "NFKD"}) {
    SCOPED_TRACE(form);
    const std::string operation =
        std::string("unicodeInput.normalize('") + form + "')";
    CheckInterruption("var unicodeInput = 'aB'.repeat(262144)",
                      operation.c_str());
    CheckInterruption("var unicodeInput = 'A\\u0315\\u0300'.repeat(131072)",
                      operation.c_str());
  }
}
#endif

#ifdef CONFIG_ALL_UNICODE
TEST_F(UnicodeInterruptTest, CollectionDuringNormalizationPreservesWorkspace) {
  LEPUSValue value = Evaluate(
      "var unicodeInput = 'x' + '\\u0315\\u0300'.repeat(2048) + '\\ufb03'");
  ASSERT_FALSE(LEPUS_IsException(value));
  Release(value);
  int polls = 0;
  LEPUS_SetInterruptHandler(
      runtime_,
      [](LEPUSRuntime* rt, void* opaque) {
        ++*static_cast<int*>(opaque);
        LEPUS_RunGC(rt);
        return 0;
      },
      &polls);
  value = Evaluate(
      "var unicodeResult = unicodeInput.normalize('NFKD');"
      "unicodeResult.length === 4100 && "
      "unicodeResult.charCodeAt(1) === 0x0300 && "
      "unicodeResult.charCodeAt(2049) === 0x0315 && "
      "unicodeResult.slice(-3) === 'ffi'");
  LEPUS_SetInterruptHandler(runtime_, nullptr, nullptr);
  ASSERT_FALSE(LEPUS_IsException(value));
  EXPECT_EQ(LEPUS_ToBool(context_, value), 1);
  EXPECT_GE(polls, 3);
  Release(value);
}

#ifndef ENABLE_COMPATIBLE_MM
TEST_F(UnicodeInterruptTest, RuntimeAllocatorBoundsNormalizationWorkspace) {
  LEPUSValue value = Evaluate("var unicodeInput = '\\ufb03'.repeat(8192)");
  ASSERT_FALSE(LEPUS_IsException(value));
  Release(value);
  const size_t before = runtime_->malloc_state.malloc_size;
  // This admits the input conversion and ordinary result string, but not
  // unchecked compatibility-decomposition workspace outside the runtime.
  LEPUS_SetMemoryLimit(runtime_, before + 64 * 1024);
  value = Evaluate("unicodeInput.normalize('NFKD')");
  const bool rejected = LEPUS_IsException(value);
  LEPUS_SetMemoryLimit(runtime_, static_cast<size_t>(-1));
  EXPECT_TRUE(rejected);
  Release(value);
  value = LEPUS_GetException(context_);
  Release(value);
  value = Evaluate("'\\ufb03'.normalize('NFKD') === 'ffi'");
  ASSERT_FALSE(LEPUS_IsException(value));
  EXPECT_EQ(LEPUS_ToBool(context_, value), 1);
  Release(value);
}
#endif
#endif
