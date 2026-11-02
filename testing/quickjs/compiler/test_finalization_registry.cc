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

namespace finalization_registry_test {

class FinalizationRegistryTest : public ::testing::Test {
 protected:
  FinalizationRegistryTest() = default;
  ~FinalizationRegistryTest() override = default;

  void SetUp() override {
    rt_ = LEPUS_NewRuntime();
    ctx_ = LEPUS_NewContext(rt_);
  }

  void TearDown() override {
    LEPUS_FreeContext(ctx_);
    LEPUS_FreeRuntime(rt_);
  }

  void DrainJobs() {
    LEPUSContext* job_ctx;
    while (LEPUS_ExecutePendingJob(rt_, &job_ctx) > 0) {
    }
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
  if (count == 0) return result;
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

TEST_F(FinalizationRegistryTest, WrongParamTest) {
  const char* filename =
      TEST_CASE_DIR "finalization_registry_test/wrong_param_fg_test.js";
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
    std::string true_result =
        R"(TypeError: FinalizationRegistry: cleanup must be callable
    at <eval> ()" TEST_CASE_DIR
        R"(finalization_registry_test/wrong_param_fg_test.js:6:43))";
    true_result += "\n";

    // std::cout << "result: " << result << std::endl;
    ASSERT_TRUE(result == true_result);
  } else {
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
    ASSERT_TRUE(false);
  }
}

TEST_F(FinalizationRegistryTest, ClearWeakRefsBeforeCycleCleanupCallback) {
  if (LEPUS_IsGCMode(ctx_)) GTEST_SKIP();

  const char* source = R"(
    globalThis.cleanupCalled = false;
    globalThis.cleanupResult = "pending";
    var weakRef;
    var registry = new FinalizationRegistry(function() {
      var object = weakRef.deref();
      cleanupCalled = true;
      cleanupResult = object && object.ref && object.ref.name;
    });

    (function() {
      var first = { name: "first" };
      var second = { name: "second" };
      first.ref = second;
      second.ref = first;
      weakRef = new WeakRef(second);
      registry.register(first, "held value");
    })();
  )";

  LEPUSValue result = LEPUS_Eval(ctx_, source, strlen(source), "test.js",
                                 LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(result));
  LEPUS_FreeValue(ctx_, result);

  LEPUS_RunGC(rt_);
  DrainJobs();

  const char* check = "cleanupCalled === true && cleanupResult === undefined";
  result =
      LEPUS_Eval(ctx_, check, strlen(check), "test.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(result));
  EXPECT_TRUE(LEPUS_ToBool(ctx_, result));
  LEPUS_FreeValue(ctx_, result);
}

static LEPUSValue js_force_gc(LEPUSContext* ctx, LEPUSValueConst this_val,
                              int argc, LEPUSValueConst* argv) {
  LEPUS_RunGC(ctx->rt);
  return LEPUS_UNDEFINED;
}

class CollectionCleanupTest : public FinalizationRegistryTest {
 protected:
  void SetUp() override {
    FinalizationRegistryTest::SetUp();
    LEPUSValue global = LEPUS_GetGlobalObject(ctx_);
    ASSERT_EQ(1, LEPUS_SetPropertyStr(
                     ctx_, global, "forceGC",
                     LEPUS_NewCFunction(ctx_, js_force_gc, "forceGC", 0)));
    if (!LEPUS_IsGCMode(ctx_)) LEPUS_FreeValue(ctx_, global);
  }

  void Check(const char* source) {
    LEPUSValue result = LEPUS_Eval(ctx_, source, strlen(source), "test.js",
                                   LEPUS_EVAL_TYPE_GLOBAL);
    ASSERT_FALSE(LEPUS_IsException(result)) << js_get_exception_string(ctx_);
    EXPECT_TRUE(LEPUS_ToBool(ctx_, result));
    if (!LEPUS_IsGCMode(ctx_)) LEPUS_FreeValue(ctx_, result);
  }
};

// These releases used to run cleanup synchronously, letting it reshape objects
// whose storage the releasing code was still using.
TEST_F(CollectionCleanupTest, CleanupRunsOnlyFromJobQueue) {
  Check(R"(
    var calls = 0;
    var receiver = {};
    var registry = new FinalizationRegistry(function() {
      calls++;
      for (var i = 0; i < 64; i++) receiver['field' + i] = i;
    });
    function tracked() {
      var target = {};
      registry.register(target, 0);
      return target;
    }
    receiver.slot = tracked();
    delete receiver.slot;
    receiver.slot = tracked();
    Object.defineProperty(receiver, 'slot', { value: 0 });
    var map = new Map([[0, tracked()]]);
    map.delete(0);
    var array = [tracked()];
    array.length = 0;
    forceGC();
    calls === 0
  )");
  // Tracing GC does not promise to collect every target in one cycle.
  if (LEPUS_IsGCMode(ctx_)) return;
  DrainJobs();
  Check("calls === 4 && Object.keys(receiver).length === 65");
}

TEST_F(CollectionCleanupTest, FreeContextDropsQueuedCleanup) {
  Check(R"(
    var registry = new FinalizationRegistry(function() {});
    (function() { registry.register({}, 0); })();
    forceGC();
    true
  )");
  LEPUS_FreeContext(ctx_);
  ctx_ = LEPUS_NewContext(rt_);
  EXPECT_FALSE(LEPUS_IsJobPending(rt_));
}

// The target and the registry die in the same cycle sweep, in either order.
TEST_F(CollectionCleanupTest, CycleSweepSkipsDyingCallback) {
  if (LEPUS_IsGCMode(ctx_)) GTEST_SKIP();
  Check(R"(
    var calls = 0;
    function makeCycles(callbackFirst) {
      var callback = callbackFirst ? function() { calls++; } : null;
      var target = {};
      target.self = target;
      callback = callback || function() { calls++; };
      var registry = new FinalizationRegistry(callback);
      callback.registry = registry;
      registry.register(target, 0);
    }
    makeCycles(true);
    makeCycles(false);
    forceGC();
    true
  )");
  DrainJobs();
  Check("calls === 0");
}

TEST_F(CollectionCleanupTest, CleanupTerminationReachesJobLoop) {
  if (LEPUS_IsGCMode(ctx_)) GTEST_SKIP();
  Check(R"(
    var registry = new FinalizationRegistry(function() { for (;;) {} });
    (function() { registry.register({}, 0); })();
    true
  )");
  LEPUS_SetInterruptHandler(
      rt_, [](LEPUSRuntime*, void*) { return 1; }, nullptr);
  LEPUSContext* job_ctx;
  EXPECT_EQ(-1, LEPUS_ExecutePendingJob(rt_, &job_ctx));
  LEPUS_SetInterruptHandler(rt_, nullptr, nullptr);
  LEPUS_FreeValue(ctx_, LEPUS_GetException(ctx_));
}

TEST_F(CollectionCleanupTest, EnqueueFailureKeepsPendingException) {
  if (LEPUS_IsGCMode(ctx_)) GTEST_SKIP();
  Check(R"(
    var registry = new FinalizationRegistry(function() {});
    globalThis.target = {};
    registry.register(target, 0);
    true
  )");
  LEPUSValue global = LEPUS_GetGlobalObject(ctx_);
  LEPUSValue target = LEPUS_GetPropertyStr(ctx_, global, "target");
  LEPUS_SetPropertyStr(ctx_, global, "target", LEPUS_UNDEFINED);
  LEPUS_FreeValue(ctx_, global);
  LEPUS_Throw(ctx_, LEPUS_NewInt32(ctx_, 123));
  size_t saved_limit = rt_->malloc_state.malloc_limit;
  LEPUS_SetMemoryLimit(rt_, 0);
  LEPUS_FreeValue(ctx_, target);  // last reference: queues cleanup
  LEPUS_SetMemoryLimit(rt_, saved_limit);
  int32_t exception = 0;
  LEPUS_ToInt32(ctx_, &exception, LEPUS_GetException(ctx_));
  EXPECT_EQ(123, exception);
  EXPECT_FALSE(LEPUS_IsJobPending(rt_));
}

class DefinePropertyCleanupTest : public FinalizationRegistryTest {};

TEST_F(DefinePropertyCleanupTest, ShapeAllocationFailurePreservesDataProperty) {
  if (LEPUS_IsGCMode(ctx_)) GTEST_SKIP();
  LEPUSValue receiver = LEPUS_NewObject(ctx_);
  LEPUSValue sibling = LEPUS_NewObject(ctx_);
  LEPUSValue old_value = LEPUS_NewObject(ctx_);
  ASSERT_EQ(1, LEPUS_DefinePropertyValueStr(ctx_, receiver, "slot",
                                            LEPUS_DupValue(ctx_, old_value),
                                            LEPUS_PROP_C_W_E));
  ASSERT_EQ(
      1, LEPUS_DefinePropertyValueStr(
             ctx_, sibling, "slot", LEPUS_NewInt32(ctx_, 1), LEPUS_PROP_C_W_E));
  ASSERT_EQ(LEPUS_VALUE_GET_OBJ(receiver)->shape,
            LEPUS_VALUE_GET_OBJ(sibling)->shape);
  JSAtom atom = LEPUS_NewAtom(ctx_, "slot");
  size_t saved_limit = rt_->malloc_state.malloc_limit;
  LEPUS_SetMemoryLimit(rt_, 0);
  int result = LEPUS_DefineProperty(
      ctx_, receiver, atom, LEPUS_NewInt32(ctx_, 42), LEPUS_UNDEFINED,
      LEPUS_UNDEFINED, LEPUS_PROP_HAS_VALUE | LEPUS_PROP_HAS_ENUMERABLE);
  LEPUS_SetMemoryLimit(rt_, saved_limit);
  EXPECT_EQ(-1, result);
  LEPUS_FreeValue(ctx_, LEPUS_GetException(ctx_));
  LEPUSPropertyDescriptor descriptor;
  ASSERT_EQ(1, LEPUS_GetOwnProperty(ctx_, &descriptor, receiver, atom));
  EXPECT_EQ(LEPUS_VALUE_GET_PTR(old_value),
            LEPUS_VALUE_GET_PTR(descriptor.value));
  EXPECT_EQ(LEPUS_PROP_C_W_E, descriptor.flags & LEPUS_PROP_C_W_E);
  LEPUS_FreeValue(ctx_, descriptor.value);
  LEPUS_FreeValue(ctx_, descriptor.getter);
  LEPUS_FreeValue(ctx_, descriptor.setter);
  LEPUS_FreeAtom(ctx_, atom);
  LEPUS_FreeValue(ctx_, old_value);
  LEPUS_FreeValue(ctx_, receiver);
  LEPUS_FreeValue(ctx_, sibling);
}

}  // namespace finalization_registry_test
