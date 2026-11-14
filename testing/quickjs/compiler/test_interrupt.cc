// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <atomic>
#include <chrono>
#include <cstring>
#include <string>
#include <thread>

#include "gtest/gtest.h"
#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif

namespace interrupt_test {

// The interrupt handler runs once per JS_INTERRUPT_COUNTER_INIT polls, so a
// loop needs more iterations than that to reach it.
constexpr int kPollInterval = 10000;

struct HandlerState {
  int calls = 0;
  // The handler asks to interrupt from this call on; never if negative.
  int interrupt_at = -1;
  // Runs a collection on each call, to check that the interrupted frame keeps
  // its operands alive.
  bool collect = false;
};

static int InterruptHandler(LEPUSRuntime* rt, void* opaque) {
  auto* state = static_cast<HandlerState*>(opaque);
  ++state->calls;
  if (state->collect) LEPUS_RunGC(rt);
  return state->interrupt_at >= 0 && state->calls >= state->interrupt_at;
}

class InterruptTest : public ::testing::Test {
 protected:
  void SetUp() override {
    rt_ = LEPUS_NewRuntime();
    ctx_ = LEPUS_NewContext(rt_);
    LEPUS_SetInterruptHandler(rt_, InterruptHandler, &state_);
  }

  void TearDown() override {
    LEPUS_FreeContext(ctx_);
    LEPUS_FreeRuntime(rt_);
  }

  void Free(LEPUSValue value) {
    if (!LEPUS_IsGCMode(ctx_)) LEPUS_FreeValue(ctx_, value);
  }

  LEPUSValue Eval(const char* source) {
    return LEPUS_Eval(ctx_, source, strlen(source), "interrupt.js",
                      LEPUS_EVAL_TYPE_GLOBAL);
  }

  // Returns the pending exception as a string, or "" if the script completed.
  std::string EvalException(const char* source) {
    LEPUSValue result = Eval(source);
    if (!LEPUS_IsException(result)) {
      Free(result);
      return "";
    }
    LEPUSValue exception = LEPUS_GetException(ctx_);
    const char* str = LEPUS_ToCString(ctx_, exception);
    std::string message = str ? str : "<no message>";
    if (str && !LEPUS_IsGCMode(ctx_)) LEPUS_FreeCString(ctx_, str);
    Free(exception);
    return message;
  }

  std::string EvalToString(const char* source) {
    LEPUSValue result = Eval(source);
    if (LEPUS_IsException(result)) {
      Free(LEPUS_GetException(ctx_));
      return "<exception>";
    }
    const char* str = LEPUS_ToCString(ctx_, result);
    std::string text = str ? str : "<no string>";
    if (str && !LEPUS_IsGCMode(ctx_)) LEPUS_FreeCString(ctx_, str);
    Free(result);
    return text;
  }

  void ExpectInterrupted(const char* source) {
    state_.calls = 0;
    state_.interrupt_at = 2;
    EXPECT_EQ(EvalException(source), "InternalError: interrupted") << source;
    state_.interrupt_at = -1;
  }

  LEPUSRuntime* rt_ = nullptr;
  LEPUSContext* ctx_ = nullptr;
  HandlerState state_;
};

TEST_F(InterruptTest, HandlerIsPolledWithoutInterrupting) {
  EXPECT_EQ(EvalToString(R"(
    var sum = 0;
    for (var i = 0; i < 300000; i++) sum += i;
    sum;
  )"),
            "44999850000");
  // One call per kPollInterval polls. Each iteration polls at its back edge,
  // and the bytecode interpreter also at the loop test.
  EXPECT_GE(state_.calls, 300000 / kPollInterval - 1);
  EXPECT_LE(state_.calls, 2 * 300000 / kPollInterval + 2);
}

TEST_F(InterruptTest, InterruptsLoops) {
  ExpectInterrupted("while (true) {}");
  ExpectInterrupted("for (;;) {}");
  ExpectInterrupted("do {} while (true);");
  ExpectInterrupted("var i = 0; do { i++; } while (i >= 0);");
  ExpectInterrupted("var n = 0; for (;;) { if (n++ & 1) continue; }");
  ExpectInterrupted("outer: for (;;) { for (;;) { continue outer; } }");
  ExpectInterrupted("var o = {a: 1}; for (;;) { for (var k in o) {} }");
  ExpectInterrupted("for (;;) { for (var v of [1, 2]) {} }");
  ExpectInterrupted("for (;;) { try { throw 1; } catch (e) {} }");
  ExpectInterrupted("for (;;) { try { continue; } finally {} }");
  ExpectInterrupted("(function () { for (;;) {} })();");
  ExpectInterrupted("(() => { var x = 1; while (x) x = x || 2; })();");
  ExpectInterrupted("function* g() { for (;;) {} } g().next();");
  ExpectInterrupted(
      "function* g() { for (;;) yield 1; } for (var v of g()) {}");
  ExpectInterrupted("[1].forEach(function () { for (;;) {} });");
  ExpectInterrupted("new (class { constructor() { for (;;) {} } })();");
  ExpectInterrupted("({ get x() { for (;;) {} } }).x;");
  ExpectInterrupted("eval('for (;;) {}');");
}

// Without a back edge, only the poll at function entry can stop these.
TEST_F(InterruptTest, InterruptsCallsWithoutLoops) {
  // Catching the stack overflow keeps the recursion going.
  ExpectInterrupted("function f() { try { f(); } catch (e) { f(); } } f();");
  ExpectInterrupted(R"(
    function A() { try { new A(); } catch (e) { new A(); } }
    new A();
  )");
  // Calls from native code.
  ExpectInterrupted("Array.from({ length: 1e9 }, function () {});");
  ExpectInterrupted(R"(
    var o = { get x() { return 1; } };
    Array.from({ length: 1e9 }, () => o.x);
  )");
  ExpectInterrupted(R"(
    function chain() { Promise.resolve().then(chain); }
    chain();
    Array.from({ length: 1e9 }, chain);
  )");
}

TEST_F(InterruptTest, InterruptIsNotCatchable) {
  ExpectInterrupted(R"(
    var caught = false, finalized = false;
    try {
      try { for (;;) {} } catch (e) { caught = true; }
    } finally {
      finalized = true;
    }
  )");
  EXPECT_EQ(EvalToString("String(caught) + ',' + String(finalized)"),
            "false,false");

  ExpectInterrupted(R"(
    var caught_in_callee = false;
    function spin() { for (;;) {} }
    function guard() {
      try { spin(); } catch (e) { caught_in_callee = true; }
    }
    try { guard(); } catch (e) { caught_in_callee = true; }
  )");
  EXPECT_EQ(EvalToString("String(caught_in_callee)"), "false");
}

// The backtrace of the error tells the embedder where the script was stuck.
TEST_F(InterruptTest, InterruptReportsStuckFunction) {
  state_.interrupt_at = 2;
  LEPUSValue result = Eval(R"(
    function spin() {
      for (;;) {}
    }
    function outer() { spin(); }
    outer();
  )");
  ASSERT_TRUE(LEPUS_IsException(result));
  LEPUSValue exception = LEPUS_GetException(ctx_);
  LEPUSValue stack = LEPUS_GetPropertyStr(ctx_, exception, "stack");
  const char* str = LEPUS_ToCString(ctx_, stack);
  ASSERT_NE(str, nullptr);
  std::string backtrace = str;
  if (!LEPUS_IsGCMode(ctx_)) LEPUS_FreeCString(ctx_, str);
  Free(stack);
  Free(exception);
  size_t spin = backtrace.find("at spin (interrupt.js:");
  size_t outer = backtrace.find("at outer (interrupt.js:5:");
  EXPECT_NE(spin, std::string::npos) << backtrace;
  EXPECT_NE(outer, std::string::npos) << backtrace;
  EXPECT_LT(spin, outer) << backtrace;
}

TEST_F(InterruptTest, ContextIsUsableAfterInterrupt) {
  ExpectInterrupted("var before = 41; for (;;) {}");
  EXPECT_EQ(EvalToString(R"(
    var total = before + 1;
    for (var i = 0; i < 50000; i++) total += 0;
    total;
  )"),
            "42");
}

// The poll must leave the operand stack of the interrupted frame intact,
// whichever stack values the handlers hold in registers at the back edge.
TEST_F(InterruptTest, PollKeepsOperandsAcrossBackEdges) {
  state_.collect = true;
  EXPECT_EQ(EvalToString(R"(
    function make(i) { return { v: i, s: 'k' + i }; }
    var checks = 0;
    // The call keeps the callee, 'this' and arguments on the operand stack
    // while the loops in its argument list run.
    function loopInArguments(n) {
      return [make(1), make(2)].concat(
          (() => { var a = []; for (var i = 0; i < n; i++) a = make(i); return a; })(),
          make(3)).length;
    }
    checks += loopInArguments(40000);
    // Conditional and logical operators branch with values still stacked.
    var acc = make(0);
    for (var i = 0; i < 40000; i++) {
      acc = (i & 1 ? acc : make(i)) || make(-1);
      acc.v = (acc.v > 0 && i % 3) ? acc.v : i;
    }
    checks += acc.v;
    // do-while and for-of keep their test value or iterator on the stack.
    var j = 0, last = null;
    do { last = make(j); } while (++j < 40000);
    checks += last.v;
    var seen = 0;
    for (var item of [make(1), make(2), make(3)]) {
      for (var k = 0; k < 15000; k++) seen += item.v;
    }
    checks += seen;
    // Template and string building across iterations.
    var text = '';
    for (var m = 0; m < 30000; m++) text = `${make(m).s}`;
    checks + ':' + text;
  )"),
            "170002:k29999");
  EXPECT_GT(state_.calls, 10);
}

TEST_F(InterruptTest, TerminateExecutionFromAnotherThread) {
  EXPECT_FALSE(LEPUS_IsExecutionTerminating(rt_));
  std::atomic<bool> running{false};
  std::thread watchdog([&] {
    while (!running.load()) std::this_thread::yield();
    std::this_thread::sleep_for(std::chrono::milliseconds(50));
    LEPUS_TerminateExecution(rt_);
  });
  running.store(true);
  EXPECT_EQ(EvalException("var spins = 0; for (;;) spins++;"),
            "InternalError: interrupted");
  watchdog.join();
  EXPECT_TRUE(LEPUS_IsExecutionTerminating(rt_));
  // The handler never asked for the interrupt.
  EXPECT_EQ(state_.interrupt_at, -1);

  // The request stays active until it is cancelled.
  EXPECT_EQ(EvalException("for (var i = 0; i < 100000; i++) {}"),
            "InternalError: interrupted");

  LEPUS_CancelTerminateExecution(rt_);
  EXPECT_FALSE(LEPUS_IsExecutionTerminating(rt_));
  EXPECT_EQ(EvalToString(R"(
    var count = 0;
    for (var i = 0; i < 100000; i++) count++;
    count;
  )"),
            "100000");
}

TEST_F(InterruptTest, TerminateExecutionWithoutHandler) {
  LEPUS_SetInterruptHandler(rt_, nullptr, nullptr);
  LEPUS_TerminateExecution(rt_);
  EXPECT_EQ(EvalException("for (;;) {}"), "InternalError: interrupted");
  LEPUS_CancelTerminateExecution(rt_);
  EXPECT_EQ(EvalToString("1 + 1"), "2");
}

}  // namespace interrupt_test
