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

namespace weak_ref_test {

class WeakRefTest : public ::testing::Test {
 protected:
  WeakRefTest() = default;
  ~WeakRefTest() override = default;

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

TEST_F(WeakRefTest, ZeroParamTest) {
  const char* filename =
      TEST_CASE_DIR "weak_ref_test/zero_param_weakref_test.js";
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
        R"(TypeError: WeakRef: target must be an object
    at <eval> ()" TEST_CASE_DIR
        R"(weak_ref_test/zero_param_weakref_test.js:6:28))";
    true_result += "\n";

    // std::cout << "result: " << result << std::endl;
    ASSERT_TRUE(result == true_result);
  } else {
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
    ASSERT_TRUE(false);
  }
}

TEST_F(WeakRefTest, WrongParamsTest) {
  const char* filename =
      TEST_CASE_DIR "weak_ref_test/wrong_param_weakref_test.js";
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
        R"(TypeError: WeakRef: target must be an object
    at <eval> ()" TEST_CASE_DIR
        R"(weak_ref_test/wrong_param_weakref_test.js:6:31))";
    true_result += "\n";

    // std::cout << "result: " << result << std::endl;
    ASSERT_TRUE(result == true_result);
  } else {
    if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, val);
    ASSERT_TRUE(false);
  }
}

class WeakRefResetTest : public ::testing::Test {
 protected:
  WeakRefResetTest() = default;
  ~WeakRefResetTest() override = default;

  void SetUp() override {
    rt_ = LEPUS_NewRuntime();
    ctx_ = LEPUS_NewContext(rt_);
    lepus_std_add_helpers(ctx_, 0, NULL);
  }

  void TearDown() override {
    lepus_std_free_handlers(rt_);
    LEPUS_FreeContext(ctx_);
    LEPUS_FreeRuntime(rt_);
  }

  LEPUSContext* ctx_;
  LEPUSRuntime* rt_;
};

// Verify that reset_weak_ref correctly unlinks JSMapRecord from the
// WeakMap's internal records list and that the WeakMap remains structurally
// intact after key objects are freed via nested reference chains.
//
// NOTE on test coverage: The actual crash (double list_del on the same
// JSMapRecord) requires map_delete_record to be called on a record whose
// links are already NULL. Through pure JavaScript APIs this is unreachable
// because reset_weak_ref's first pass removes the record from both the
// hash table and records list before any callbacks fire. The real crash
// scenario involves complex C++ level object lifetime chains or GC
// finalizer ordering. The fix (mr->empty = TRUE) is validated by code
// inspection; these tests verify structural integrity and catch related
// regressions under ASAN/MSAN.
TEST_F(WeakRefResetTest, RecordUnlinkedAfterKeyFreed) {
  // Create a WeakMap with a key, verify internal record exists, then free
  // the key and verify the record was properly removed from the map.
  std::string src = R"(
    var wm = new WeakMap();
    var key = {x: 1};
    wm.set(key, "value");
  )";
  LEPUSValue ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test_unlink.js",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(ret));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Access internal JSMapState to verify record presence.
  LEPUSValue global = LEPUS_GetGlobalObject(ctx_);
  LEPUSValue wm_val = LEPUS_GetPropertyStr(ctx_, global, "wm");
  LEPUSObject* wm_obj = LEPUS_VALUE_GET_OBJ(wm_val);
  JSMapState* s = wm_obj->u.map_state;

  ASSERT_NE(s, nullptr);
  ASSERT_EQ(s->record_count, 1u);
  ASSERT_FALSE(list_empty(&s->records));

  // Free the key → triggers reset_weak_ref → first pass unlinks record.
  src = "key = null;";
  ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test_unlink2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(ret));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // After reset_weak_ref: the record has been unlinked from s->records
  // (via list_del in first pass) and freed (in second pass for RC mode).
  // In GC mode, cleanup is deferred until a GC cycle runs.
  if (!ctx_->rt->gc_enable) {
    EXPECT_TRUE(list_empty(&s->records));
  }

  // Verify WeakMap still functions correctly with new entries.
  src = R"(
    var key2 = {y: 2};
    wm.set(key2, "value2");
    wm.get(key2);
  )";
  ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test_unlink3.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(ret));
  const char* str = LEPUS_ToCString(ctx_, ret);
  EXPECT_STREQ(str, "value2");
  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeCString(ctx_, str);
    LEPUS_FreeValue(ctx_, ret);
    LEPUS_FreeValue(ctx_, wm_val);
    LEPUS_FreeValue(ctx_, global);
  }
}

// Test nested object freeing during reset_weak_ref: when a WeakMap value
// holds the only reference to another object that is also a key in the
// same WeakMap, freeing the first key triggers a chain of reset_weak_ref
// calls. This exercises concurrent list modifications on the same
// JSMapState and validates structural integrity under ASAN.
TEST_F(WeakRefResetTest, NestedResetWeakRefOnSameMap) {
  // key1's value in the WeakMap is key2 (the only strong ref to key2).
  // Freeing key1 → reset_weak_ref(key1) second pass frees value (key2)
  // → key2 refcount=0 → reset_weak_ref(key2) nested call on same map.
  std::string src = R"(
    var wm = new WeakMap();
    (function() {
      var key2 = {id: 2};
      var key1 = {id: 1};
      wm.set(key1, key2);  // key1's value = key2 (strong ref in map)
      wm.set(key2, "leaf_value");
      // Now: key1 and key2 are both keys in wm.
      // key2 is ONLY reachable via wm's value for key1.
      // Dropping key1 and key2 locals: key1 refcount=0 immediately,
      // key2 refcount held by mr_key1->value until second pass frees it.
    })();
  )";
  LEPUSValue ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test_nested.js",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(ret));
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, ret);

  // Both keys freed (nested reset_weak_ref). WeakMap must be structurally
  // intact with an empty records list.
  // In GC mode, cleanup is deferred until a GC cycle runs.
  LEPUSValue global = LEPUS_GetGlobalObject(ctx_);
  LEPUSValue wm_val = LEPUS_GetPropertyStr(ctx_, global, "wm");
  LEPUSObject* wm_obj = LEPUS_VALUE_GET_OBJ(wm_val);
  JSMapState* s = wm_obj->u.map_state;

  if (!ctx_->rt->gc_enable) {
    EXPECT_TRUE(list_empty(&s->records));
  }

  // WeakMap must still accept new entries without corruption.
  src = R"(
    var k = {id: 3};
    wm.set(k, "works");
    wm.get(k);
  )";
  ret = LEPUS_Eval(ctx_, src.c_str(), src.length(), "test_nested2.js",
                   LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(ret));
  const char* str = LEPUS_ToCString(ctx_, ret);
  EXPECT_STREQ(str, "works");
  if (!ctx_->rt->gc_enable) {
    LEPUS_FreeCString(ctx_, str);
    LEPUS_FreeValue(ctx_, ret);
    LEPUS_FreeValue(ctx_, wm_val);
    LEPUS_FreeValue(ctx_, global);
  }
}

}  // namespace weak_ref_test
