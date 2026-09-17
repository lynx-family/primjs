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

  const char* check = "cleanupCalled === true && cleanupResult === undefined";
  result =
      LEPUS_Eval(ctx_, check, strlen(check), "test.js", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(result));
  EXPECT_TRUE(LEPUS_ToBool(ctx_, result));
  LEPUS_FreeValue(ctx_, result);
}

TEST_F(FinalizationRegistryTest, DefinePropertyCommitsFlagsBeforeCleanup) {
  if (LEPUS_IsGCMode(ctx_)) GTEST_SKIP();

  // Only inspect property names in the callback, not the retiring value.
  // This detects the old ordering without accessing invalid object storage.
  const char* source = R"(
    (function() {
      var receiver = { slot: {} };
      var calls = 0;
      var sawCommittedFlags = false;
      var registry = new FinalizationRegistry(function() {
        calls++;
        sawCommittedFlags = Object.keys(receiver).indexOf('slot') === -1;
      });
      registry.register(receiver.slot, 0);
      Object.defineProperty(receiver, 'slot', {
        value: 42, writable: false, enumerable: false, configurable: false
      });
      var descriptor = Object.getOwnPropertyDescriptor(receiver, 'slot');
      return calls === 1 && sawCommittedFlags && descriptor.value === 42 &&
             !descriptor.writable && !descriptor.enumerable &&
             !descriptor.configurable;
    })()
  )";
  LEPUSValue result = LEPUS_Eval(ctx_, source, strlen(source), "test.js",
                                 LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(result)) << js_get_exception_string(ctx_);
  EXPECT_TRUE(LEPUS_ToBool(ctx_, result));
  LEPUS_FreeValue(ctx_, result);
}

class DefinePropertyCleanupTest : public FinalizationRegistryTest {
 protected:
  void Check(const char* source) {
    LEPUSValue result = LEPUS_Eval(ctx_, source, strlen(source), "test.js",
                                   LEPUS_EVAL_TYPE_GLOBAL);
    ASSERT_FALSE(LEPUS_IsException(result)) << js_get_exception_string(ctx_);
    EXPECT_TRUE(LEPUS_ToBool(ctx_, result));
    LEPUS_FreeValue(ctx_, result);
  }
};

TEST_F(DefinePropertyCleanupTest, ReceiverMutationAfterCommit) {
  if (LEPUS_IsGCMode(ctx_)) GTEST_SKIP();
  Check(R"(
    (function() {
      for (var action = 0; action < 3; action++) {
        var receiver = { slot: {} };
        var calls = 0;
        var consistent = false;
        var registry = new FinalizationRegistry(function() {
          calls++;
          var d = Object.getOwnPropertyDescriptor(receiver, 'slot');
          consistent = d.value === 42 && !d.writable && !d.enumerable &&
                       d.configurable;
          // Exercise ordinary growth only; no heap reclamation or forged data.
          for (var i = 0; i < 64; i++) receiver['field' + i] = i;
          if (action === 1) delete receiver.slot;
          if (action === 2)
            Object.defineProperty(receiver, 'slot', {
              get: function() { return 73; }, configurable: true
            });
        });
        registry.register(receiver.slot, 0);
        Object.defineProperty(receiver, 'slot', {
          value: 42, writable: false, enumerable: false, configurable: true
        });
        if (calls !== 1 || !consistent || receiver.field63 !== 63) return false;
        if (action === 0 && receiver.slot !== 42) return false;
        if (action === 1 && Object.prototype.hasOwnProperty.call(receiver, 'slot'))
          return false;
        if (action === 2 && receiver.slot !== 73) return false;
      }
      return true;
    })()
  )");
}

TEST_F(DefinePropertyCleanupTest, AccessorTransitions) {
  if (LEPUS_IsGCMode(ctx_)) GTEST_SKIP();
  Check(R"(
    (function() {
      // data -> accessor, accessor -> data, getter/setter replacements,
      // including releasing two references to the same function.
      for (var mode = 0; mode < 6; mode++) {
        var receiver = {};
        var newGet = function() { return 42; };
        var newSet = function(v) {};
        var calls = 0;
        var consistent = true;
        var registry = new FinalizationRegistry(function() {
          calls++;
          var d = Object.getOwnPropertyDescriptor(receiver, 'slot');
          if (mode === 1 || mode === 5)
            consistent = consistent && d.value === 42 && !d.writable;
          else
            consistent = consistent && d.get === newGet && d.set === newSet;
          consistent = consistent && !d.enumerable && d.configurable;
          for (var i = 0; i < 64; i++) receiver['field' + i] = i;
        });
        if (mode === 0) {
          receiver.slot = {};
          registry.register(receiver.slot, 0);
        } else {
          var oldGet = mode === 3 ? newGet : function() { return 1; };
          var oldSet = mode === 2 ? newSet : function(v) {};
          if (mode === 5) oldSet = oldGet;
          Object.defineProperty(receiver, 'slot', {
            get: oldGet, set: oldSet, enumerable: true, configurable: true
          });
          if (mode !== 3) registry.register(oldGet, 0);
          if (mode !== 2 && mode !== 5) registry.register(oldSet, 1);
          oldGet = null;
          oldSet = null;
        }
        if (mode === 1 || mode === 5)
          Object.defineProperty(receiver, 'slot', {
            value: 42, writable: false, enumerable: false
          });
        else if (mode === 2)
          Object.defineProperty(receiver, 'slot', {
            get: newGet, enumerable: false
          });
        else if (mode === 3)
          Object.defineProperty(receiver, 'slot', {
            set: newSet, enumerable: false
          });
        else
          Object.defineProperty(receiver, 'slot', {
            get: newGet, set: newSet, enumerable: false
          });
        var expectedCalls = mode === 1 || mode === 4 ? 2 : 1;
        if (!consistent || calls !== expectedCalls || receiver.slot !== 42)
          return false;
      }
      return true;
    })()
  )");
}

TEST_F(DefinePropertyCleanupTest, MappedArgumentsTransitions) {
  if (LEPUS_IsGCMode(ctx_)) GTEST_SKIP();
  Check(R"(
    (function() {
      for (var mode = 0; mode < 3; mode++) {
        var receiver;
        var calls = 0;
        var consistent = false;
        var newGet = function() { return 42; };
        var registry = new FinalizationRegistry(function() {
          calls++;
          var d = Object.getOwnPropertyDescriptor(receiver, '0');
          consistent = !d.enumerable && d.configurable &&
            (mode === 2 ? d.get === newGet :
             d.value === 42 && d.writable === (mode === 0));
          for (var i = 0; i < 64; i++) receiver['field' + i] = i;
        });
        (function(value) {
          registry.register(value, 0);
          receiver = arguments;
        })({});
        if (mode === 0)
          Object.defineProperty(receiver, '0', { value: 42, enumerable: false });
        else if (mode === 1)
          Object.defineProperty(receiver, '0', {
            value: 42, writable: false, enumerable: false
          });
        else
          Object.defineProperty(receiver, '0', { get: newGet, enumerable: false });
        if (calls !== 1 || !consistent || receiver[0] !== 42) return false;
      }
      return true;
    })()
  )");
}

TEST_F(DefinePropertyCleanupTest, SameValueRetainsOwnership) {
  if (LEPUS_IsGCMode(ctx_)) GTEST_SKIP();
  Check(R"(
    (function() {
      var calls = 0;
      var registry = new FinalizationRegistry(function() { calls++; });
      var receiver = { slot: {} };
      registry.register(receiver.slot, 0);
      Object.defineProperty(receiver, 'slot', { value: receiver.slot });
      if (calls !== 0) return false;
      delete receiver.slot;
      if (calls !== 1) return false;
      Object.defineProperty(receiver, 'slot', {
        get: function() { return 42; }, configurable: true
      });
      var getter = Object.getOwnPropertyDescriptor(receiver, 'slot').get;
      registry.register(getter, 0);
      Object.defineProperty(receiver, 'slot', { get: getter });
      getter = null;
      if (calls !== 1 || receiver.slot !== 42) return false;
      delete receiver.slot;
      return calls === 2;
    })()
  )");
}

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
