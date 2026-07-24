// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>
#include <string>
#include <vector>

#include "gtest/gtest.h"
#include "inspector/debugger/debugger.h"

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs-libc.h"
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif
#include "inspector/interface.h"
#include "quickjs/include/quickjs-inner.h"

class VarInfoOutsideTest : public ::testing::Test {
 protected:
  void SetUp() override {
    rt_ = LEPUS_NewRuntime();
    LEPUS_SetRuntimeInfo(rt_, "Lynx_LepusNG");
    ctx_ = LEPUS_NewContext(rt_);
  }

  void TearDown() override {
    LEPUS_FreeContext(ctx_);
    LEPUS_FreeRuntime(rt_);
  }

  // Enable varinfo stripping: debuginfo_outside=1 + version >= 4.1
  void EnableVarInfoStrip() {
    ctx_->debuginfo_outside = 1;
    SetLynxTargetSdkVersion(ctx_, "4.1");
  }

  // Compile source to bytecode object (compile-only, not executed)
  LEPUSValue CompileOnly(const char *src) {
    return LEPUS_Eval(ctx_, src, strlen(src), "test.js",
                      LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL);
  }

  // Serialize compiled bytecode to binary buffer
  uint8_t *Serialize(LEPUSValue obj, size_t *out_len) {
    return LEPUS_WriteObject(ctx_, out_len, obj, LEPUS_WRITE_OBJ_BYTECODE);
  }

  // Deserialize binary buffer to value (on a fresh context to simulate reader)
  LEPUSValue Deserialize(const uint8_t *buf, size_t len) {
    return LEPUS_ReadObject(ctx_, buf, len, LEPUS_READ_OBJ_BYTECODE);
  }

  // Find the first inner function bytecode in a top-level bytecode's cpool
  LEPUSFunctionBytecode *FindInnerFunction(LEPUSFunctionBytecode *top) {
    for (int i = 0; i < top->cpool_count; i++) {
      if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(top->cpool[i])) {
        return (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(top->cpool[i]);
      }
    }
    return nullptr;
  }

  void CollectFunctionBytecodes(LEPUSFunctionBytecode *b,
                                std::vector<LEPUSFunctionBytecode *> *out) {
    if (!b) return;
    out->push_back(b);
    for (int i = 0; i < b->cpool_count; i++) {
      if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(b->cpool[i])) {
        CollectFunctionBytecodes(
            (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(b->cpool[i]), out);
      }
    }
  }

  LEPUSFunctionBytecode *FindFunctionBySource(
      const std::vector<LEPUSFunctionBytecode *> &functions,
      const std::string &source) {
    for (LEPUSFunctionBytecode *function : functions) {
      if (!function || !function->has_debug || !function->debug.source) {
        continue;
      }
      if (std::string(function->debug.source, function->debug.source_len) ==
          source) {
        return function;
      }
    }
    return nullptr;
  }

  void ExpectFunctionSourceOffset(
      const std::string &root_source,
      const std::vector<LEPUSFunctionBytecode *> &functions,
      const std::string &function_source) {
    SCOPED_TRACE(function_source);
    auto function_offset = root_source.find(function_source);
    ASSERT_NE(function_offset, std::string::npos);
    LEPUSFunctionBytecode *function =
        FindFunctionBySource(functions, function_source);
    ASSERT_NE(function, nullptr);
    EXPECT_EQ(function->debug.source_offset,
              static_cast<int32_t>(function_offset));
    EXPECT_EQ(function->debug.source_len,
              static_cast<int32_t>(function_source.length()));
    EXPECT_EQ(root_source.substr(function->debug.source_offset,
                                 function->debug.source_len),
              function_source);
  }

  LEPUSRuntime *rt_;
  LEPUSContext *ctx_;
};

// Test: vardefs should be stripped when all conditions are met.
TEST_F(VarInfoOutsideTest, VarDefsStrippedWhenConditionsMet) {
  EnableVarInfoStrip();

  const char *src =
      "function foo(a, b) {\n"
      "  var x = 1;\n"
      "  let y = 2;\n"
      "  return a + b + x + y;\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  // Before serialization, vardefs should exist
  auto *top_b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(compiled);
  auto *foo_b = FindInnerFunction(top_b);
  ASSERT_NE(foo_b, nullptr);
  ASSERT_NE(foo_b->vardefs, nullptr);

  // Serialize — vardefs should be stripped in output
  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  // Deserialize on fresh context to verify vardefs are absent
  LEPUSContext *read_ctx = LEPUS_NewContext(rt_);
  LEPUSValue read_val =
      LEPUS_ReadObject(read_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  LEPUSFunctionBytecode *read_foo = nullptr;
  for (int i = 0; i < read_top->cpool_count; i++) {
    if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(read_top->cpool[i])) {
      read_foo =
          (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_top->cpool[i]);
      break;
    }
  }
  ASSERT_NE(read_foo, nullptr);
  // After deserialization with strip, vardefs should be null
  EXPECT_EQ(read_foo->vardefs, nullptr);
  // varinfo_outside flag should be set on the reading context
  EXPECT_EQ(read_ctx->varinfo_outside, 1);

  if (!read_ctx->rt->gc_enable) LEPUS_FreeValue(read_ctx, read_val);
  LEPUS_FreeContext(read_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: vardefs should NOT be stripped for functions containing eval().
TEST_F(VarInfoOutsideTest, VarDefsPreservedForEval) {
  EnableVarInfoStrip();

  // Function uses eval(), so vardefs must be preserved for runtime resolution
  const char *src =
      "function foo(a) {\n"
      "  var x = 10;\n"
      "  return eval('x + a');\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  auto *top_b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(compiled);
  auto *foo_b = FindInnerFunction(top_b);
  ASSERT_NE(foo_b, nullptr);
  // has_eval_call should be set
  EXPECT_EQ(foo_b->has_eval_call, 1);
  ASSERT_NE(foo_b->vardefs, nullptr);

  // Serialize — vardefs should NOT be stripped because has_eval_call
  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  // Deserialize and verify vardefs are preserved
  LEPUSContext *read_ctx = LEPUS_NewContext(rt_);
  LEPUSValue read_val =
      LEPUS_ReadObject(read_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  LEPUSFunctionBytecode *read_foo = nullptr;
  for (int i = 0; i < read_top->cpool_count; i++) {
    if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(read_top->cpool[i])) {
      read_foo =
          (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_top->cpool[i]);
      break;
    }
  }
  ASSERT_NE(read_foo, nullptr);
  // Vardefs should be preserved for eval functions
  EXPECT_NE(read_foo->vardefs, nullptr);

  if (!read_ctx->rt->gc_enable) LEPUS_FreeValue(read_ctx, read_val);
  LEPUS_FreeContext(read_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: vardefs should NOT be stripped when is_lepusng is false.
TEST_F(VarInfoOutsideTest, VarDefsPreservedWhenNotLepusNG) {
  // Create a non-lepusng runtime
  LEPUSRuntime *plain_rt = LEPUS_NewRuntime();
  // Do NOT call LEPUS_SetRuntimeInfo — is_lepusng stays false
  LEPUSContext *plain_ctx = LEPUS_NewContext(plain_rt);
  plain_ctx->debuginfo_outside = 1;
  SetLynxTargetSdkVersion(plain_ctx, "4.1");

  const char *src =
      "function foo(a) {\n"
      "  var x = 1;\n"
      "  return a + x;\n"
      "}\n";

  LEPUSValue compiled =
      LEPUS_Eval(plain_ctx, src, strlen(src), "test.js",
                 LEPUS_EVAL_FLAG_COMPILE_ONLY | LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  size_t bc_len;
  uint8_t *bc =
      LEPUS_WriteObject(plain_ctx, &bc_len, compiled, LEPUS_WRITE_OBJ_BYTECODE);
  ASSERT_NE(bc, nullptr);

  // Deserialize and verify vardefs are still present
  LEPUSValue read_val =
      LEPUS_ReadObject(plain_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  LEPUSFunctionBytecode *read_foo = nullptr;
  for (int i = 0; i < read_top->cpool_count; i++) {
    if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(read_top->cpool[i])) {
      read_foo =
          (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_top->cpool[i]);
      break;
    }
  }
  ASSERT_NE(read_foo, nullptr);
  // Vardefs should NOT be stripped in non-lepusng mode
  EXPECT_NE(read_foo->vardefs, nullptr);
  // varinfo_outside should NOT be set
  EXPECT_EQ(plain_ctx->varinfo_outside, 0);

  if (!plain_ctx->rt->gc_enable) LEPUS_FreeValue(plain_ctx, read_val);
  if (!plain_ctx->rt->gc_enable) lepus_free(plain_ctx, bc);
  if (!plain_ctx->rt->gc_enable) LEPUS_FreeValue(plain_ctx, compiled);
  LEPUS_FreeContext(plain_ctx);
  LEPUS_FreeRuntime(plain_rt);
}

// Test: vardefs should NOT be stripped when version < 4.1.
TEST_F(VarInfoOutsideTest, VarDefsPreservedWhenVersionTooLow) {
  ctx_->debuginfo_outside = 1;
  SetLynxTargetSdkVersion(ctx_, "3.9");

  const char *src =
      "function foo(a) {\n"
      "  var x = 1;\n"
      "  return a + x;\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  LEPUSContext *read_ctx = LEPUS_NewContext(rt_);
  LEPUSValue read_val =
      LEPUS_ReadObject(read_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  LEPUSFunctionBytecode *read_foo = nullptr;
  for (int i = 0; i < read_top->cpool_count; i++) {
    if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(read_top->cpool[i])) {
      read_foo =
          (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_top->cpool[i]);
      break;
    }
  }
  ASSERT_NE(read_foo, nullptr);
  EXPECT_NE(read_foo->vardefs, nullptr);

  if (!read_ctx->rt->gc_enable) LEPUS_FreeValue(read_ctx, read_val);
  LEPUS_FreeContext(read_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: bytecode size is smaller when varinfo is stripped.
TEST_F(VarInfoOutsideTest, BytecodeSmallerWithStrip) {
  const char *src =
      "function foo(a, b, c, d, e) {\n"
      "  var longVariableName1 = 1;\n"
      "  var longVariableName2 = 2;\n"
      "  var longVariableName3 = 3;\n"
      "  return a + b + c + d + e + longVariableName1 + longVariableName2 + "
      "longVariableName3;\n"
      "}\n";

  // Compile without stripping
  ctx_->debuginfo_outside = 1;
  SetLynxTargetSdkVersion(ctx_, "3.0");  // below threshold

  LEPUSValue compiled1 = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled1));
  size_t len_no_strip;
  uint8_t *bc1 = Serialize(compiled1, &len_no_strip);
  ASSERT_NE(bc1, nullptr);

  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc1);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled1);

  // Compile with stripping
  SetLynxTargetSdkVersion(ctx_, "4.1");  // at threshold

  LEPUSValue compiled2 = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled2));
  size_t len_with_strip;
  uint8_t *bc2 = Serialize(compiled2, &len_with_strip);
  ASSERT_NE(bc2, nullptr);

  // Stripped version should be smaller
  EXPECT_LT(len_with_strip, len_no_strip)
      << "Stripped bytecode (" << len_with_strip
      << " bytes) should be smaller than non-stripped (" << len_no_strip
      << " bytes)";

  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc2);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled2);
}

// Test: SetFunctionVarDefs and GetFunctionVarDef* round-trip.
TEST_F(VarInfoOutsideTest, VarDefGetterSetterRoundTrip) {
  EnableVarInfoStrip();

  const char *src =
      "function foo(a) {\n"
      "  var x = 1;\n"
      "  let y = 2;\n"
      "  return a + x + y;\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  auto *top_b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(compiled);
  auto *foo_b = FindInnerFunction(top_b);
  ASSERT_NE(foo_b, nullptr);

  // Read original vardef info before serialization
  uint32_t count = GetFunctionVarDefCount(foo_b);
  ASSERT_GT(count, 0u);

  // Collect original vardef data
  std::vector<std::string> names(count);
  std::vector<int32_t> scope_levels(count);
  std::vector<int32_t> scope_nexts(count);
  std::vector<uint8_t> flags(count);

  for (uint32_t i = 0; i < count; i++) {
    const char *name = GetFunctionVarDefName(ctx_, foo_b, i);
    names[i] = name ? name : "";
    if (name && !ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, name);
    scope_levels[i] = GetFunctionVarDefScopeLevel(foo_b, i);
    scope_nexts[i] = GetFunctionVarDefScopeNext(foo_b, i);
    flags[i] = GetFunctionVarDefFlags(foo_b, i);
  }

  // Serialize (strips vardefs) and deserialize
  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  LEPUSContext *read_ctx = LEPUS_NewContext(rt_);
  LEPUSValue read_val =
      LEPUS_ReadObject(read_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  auto *read_foo = (LEPUSFunctionBytecode *)nullptr;
  for (int i = 0; i < read_top->cpool_count; i++) {
    if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(read_top->cpool[i])) {
      read_foo =
          (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_top->cpool[i]);
      break;
    }
  }
  ASSERT_NE(read_foo, nullptr);
  ASSERT_EQ(read_foo->vardefs, nullptr);  // stripped

  // Use SetFunctionVarDefs to inject back
  std::vector<const char *> c_names(count);
  for (uint32_t i = 0; i < count; i++) {
    c_names[i] = names[i].c_str();
  }
  SetFunctionVarDefs(read_ctx, read_foo, c_names.data(), scope_levels.data(),
                     scope_nexts.data(), flags.data(), count);

  // Verify vardefs were injected correctly
  ASSERT_NE(read_foo->vardefs, nullptr);
  EXPECT_EQ(GetFunctionVarDefCount(read_foo), count);

  for (uint32_t i = 0; i < count; i++) {
    const char *name = GetFunctionVarDefName(read_ctx, read_foo, i);
    EXPECT_STREQ(name, names[i].c_str());
    if (name && !read_ctx->rt->gc_enable) LEPUS_FreeCString(read_ctx, name);
    EXPECT_EQ(GetFunctionVarDefScopeLevel(read_foo, i), scope_levels[i]);
    EXPECT_EQ(GetFunctionVarDefScopeNext(read_foo, i), scope_nexts[i]);
    EXPECT_EQ(GetFunctionVarDefFlags(read_foo, i), flags[i]);
  }

  if (!read_ctx->rt->gc_enable) LEPUS_FreeValue(read_ctx, read_val);
  LEPUS_FreeContext(read_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: SetFunctionVarDefs is no-op when vardefs already exist.
TEST_F(VarInfoOutsideTest, SetVarDefsNoOpWhenAlreadyExists) {
  const char *src =
      "function foo(a) {\n"
      "  var x = 1;\n"
      "  return a + x;\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  auto *top_b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(compiled);
  auto *foo_b = FindInnerFunction(top_b);
  ASSERT_NE(foo_b, nullptr);
  ASSERT_NE(foo_b->vardefs, nullptr);

  // Try to overwrite — should be no-op
  JSVarDef *original_ptr = foo_b->vardefs;
  const char *names[] = {"fake"};
  int32_t levels[] = {0};
  int32_t nexts[] = {-1};
  uint8_t flags[] = {0};
  SetFunctionVarDefs(ctx_, foo_b, names, levels, nexts, flags, 1);

  // Pointer should not have changed
  EXPECT_EQ(foo_b->vardefs, original_ptr);

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: GetFunctionVarDef* with out-of-bounds index returns safe defaults.
TEST_F(VarInfoOutsideTest, GetVarDefOutOfBoundsReturnsSafe) {
  const char *src =
      "function foo(a) {\n"
      "  var x = 1;\n"
      "  return a + x;\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  auto *top_b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(compiled);
  auto *foo_b = FindInnerFunction(top_b);
  ASSERT_NE(foo_b, nullptr);

  uint32_t count = GetFunctionVarDefCount(foo_b);
  // Access out of bounds
  EXPECT_EQ(GetFunctionVarDefName(ctx_, foo_b, count + 10), nullptr);
  EXPECT_EQ(GetFunctionVarDefScopeLevel(foo_b, count + 10), -1);
  EXPECT_EQ(GetFunctionVarDefScopeNext(foo_b, count + 10), -1);
  EXPECT_EQ(GetFunctionVarDefFlags(foo_b, count + 10), 0u);

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: serialized bytecode with stripped varinfo can still be executed.
TEST_F(VarInfoOutsideTest, StrippedBytecodeStillExecutable) {
  EnableVarInfoStrip();

  const char *src =
      "function add(a, b) {\n"
      "  var result = a + b;\n"
      "  return result;\n"
      "}\n"
      "add(3, 4);\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  // Execute the deserialized bytecode
  LEPUSContext *exec_ctx = LEPUS_NewContext(rt_);
  LEPUSValue result = LEPUS_EvalBinary(exec_ctx, bc, bc_len, 0);
  ASSERT_FALSE(LEPUS_IsException(result));

  // The result of add(3, 4) should be 7
  int32_t int_result;
  ASSERT_EQ(LEPUS_ToInt32(exec_ctx, &int_result, result), 0);
  EXPECT_EQ(int_result, 7);

  if (!exec_ctx->rt->gc_enable) LEPUS_FreeValue(exec_ctx, result);
  LEPUS_FreeContext(exec_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: SetFunctionVarDefs sets the vardefs_ext flag.
TEST_F(VarInfoOutsideTest, SetVarDefsSetsExtFlag) {
  EnableVarInfoStrip();

  const char *src =
      "function foo(a) {\n"
      "  var x = 1;\n"
      "  return a + x;\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  LEPUSContext *read_ctx = LEPUS_NewContext(rt_);
  LEPUSValue read_val =
      LEPUS_ReadObject(read_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  auto *read_foo = FindInnerFunction(read_top);
  ASSERT_NE(read_foo, nullptr);
  ASSERT_EQ(read_foo->vardefs, nullptr);
  EXPECT_EQ(read_foo->vardefs_ext, 0u);

  // Inject vardefs
  const char *names[] = {"a", "x"};
  int32_t levels[] = {0, 0};
  int32_t nexts[] = {-1, -1};
  uint8_t flags[] = {0, 0};
  SetFunctionVarDefs(read_ctx, read_foo, names, levels, nexts, flags, 2);

  // vardefs_ext should be set to 1
  ASSERT_NE(read_foo->vardefs, nullptr);
  EXPECT_EQ(read_foo->vardefs_ext, 1u);

  if (!read_ctx->rt->gc_enable) LEPUS_FreeValue(read_ctx, read_val);
  LEPUS_FreeContext(read_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: externally-injected vardefs (vardefs_ext) survive GC collection.
// This verifies that VisitLEPUSFunctionBytecode correctly marks the
// separately-allocated vardefs array as reachable.
TEST_F(VarInfoOutsideTest, VarDefsExtSurvivesGC) {
  EnableVarInfoStrip();

  const char *src =
      "function foo(a, b) {\n"
      "  var x = 1;\n"
      "  let y = 2;\n"
      "  return a + b + x + y;\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  // Collect original vardef info
  auto *top_b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(compiled);
  auto *foo_b = FindInnerFunction(top_b);
  ASSERT_NE(foo_b, nullptr);

  uint32_t count = GetFunctionVarDefCount(foo_b);
  ASSERT_GT(count, 0u);

  std::vector<std::string> names(count);
  std::vector<int32_t> scope_levels(count);
  std::vector<int32_t> scope_nexts(count);
  std::vector<uint8_t> flags(count);

  for (uint32_t i = 0; i < count; i++) {
    const char *name = GetFunctionVarDefName(ctx_, foo_b, i);
    names[i] = name ? name : "";
    if (name && !ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, name);
    scope_levels[i] = GetFunctionVarDefScopeLevel(foo_b, i);
    scope_nexts[i] = GetFunctionVarDefScopeNext(foo_b, i);
    flags[i] = GetFunctionVarDefFlags(foo_b, i);
  }

  // Serialize (strip vardefs) and deserialize
  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  LEPUSContext *read_ctx = LEPUS_NewContext(rt_);
  LEPUSValue read_val =
      LEPUS_ReadObject(read_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  auto *read_foo = FindInnerFunction(read_top);
  ASSERT_NE(read_foo, nullptr);
  ASSERT_EQ(read_foo->vardefs, nullptr);

  // Inject vardefs back
  std::vector<const char *> c_names(count);
  for (uint32_t i = 0; i < count; i++) {
    c_names[i] = names[i].c_str();
  }
  SetFunctionVarDefs(read_ctx, read_foo, c_names.data(), scope_levels.data(),
                     scope_nexts.data(), flags.data(), count);

  ASSERT_NE(read_foo->vardefs, nullptr);
  EXPECT_EQ(read_foo->vardefs_ext, 1u);

  // Trigger GC — if vardefs is not properly marked as reachable by the
  // collector, it would be reclaimed and subsequent access would be UAF.
  LEPUS_RunGC(rt_);

  // After GC, vardefs should still be valid and accessible
  ASSERT_NE(read_foo->vardefs, nullptr);
  EXPECT_EQ(GetFunctionVarDefCount(read_foo), count);

  for (uint32_t i = 0; i < count; i++) {
    const char *name = GetFunctionVarDefName(read_ctx, read_foo, i);
    EXPECT_STREQ(name, names[i].c_str());
    if (name && !read_ctx->rt->gc_enable) LEPUS_FreeCString(read_ctx, name);
    EXPECT_EQ(GetFunctionVarDefScopeLevel(read_foo, i), scope_levels[i]);
    EXPECT_EQ(GetFunctionVarDefScopeNext(read_foo, i), scope_nexts[i]);
    EXPECT_EQ(GetFunctionVarDefFlags(read_foo, i), flags[i]);
  }

  if (!read_ctx->rt->gc_enable) LEPUS_FreeValue(read_ctx, read_val);
  LEPUS_FreeContext(read_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: inline vardefs (from eval-containing function, not stripped) also
// survive GC correctly, verifying the visitor still works for the non-ext path.
TEST_F(VarInfoOutsideTest, InlineVarDefsSurvivesGC) {
  EnableVarInfoStrip();

  // eval() forces vardefs to be preserved inline (not stripped)
  const char *src =
      "function foo(a) {\n"
      "  var x = 10;\n"
      "  return eval('x + a');\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  LEPUSContext *read_ctx = LEPUS_NewContext(rt_);
  LEPUSValue read_val =
      LEPUS_ReadObject(read_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  auto *read_foo = FindInnerFunction(read_top);
  ASSERT_NE(read_foo, nullptr);
  // eval function keeps vardefs inline (not ext)
  ASSERT_NE(read_foo->vardefs, nullptr);
  EXPECT_EQ(read_foo->vardefs_ext, 0u);

  uint32_t count = GetFunctionVarDefCount(read_foo);
  ASSERT_GT(count, 0u);

  // Trigger GC
  LEPUS_RunGC(rt_);

  // Inline vardefs should still be accessible after GC
  ASSERT_NE(read_foo->vardefs, nullptr);
  EXPECT_EQ(GetFunctionVarDefCount(read_foo), count);

  // Verify at least one name is readable
  const char *name = GetFunctionVarDefName(read_ctx, read_foo, 0);
  EXPECT_NE(name, nullptr);
  if (name && !read_ctx->rt->gc_enable) LEPUS_FreeCString(read_ctx, name);

  if (!read_ctx->rt->gc_enable) LEPUS_FreeValue(read_ctx, read_val);
  LEPUS_FreeContext(read_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

#ifdef ENABLE_QUICKJS_DEBUGGER

#include "inspector/debugger_inner.h"

// Native function that calls GetLocalVariables to inspect the caller's frame.
// stack_index=1 skips the C function frame (inspect itself) to reach the
// JS caller (foo).
static LEPUSValue js_inspect_locals(LEPUSContext *ctx, LEPUSValueConst this_val,
                                    int argc, LEPUSValueConst *argv) {
  return GetLocalVariables(ctx, 1);
}

// Test: GetLocalVariables returns empty object when vardefs are null
// (stripped).
TEST_F(VarInfoOutsideTest, GetLocalVariablesEmptyWhenVarDefsStripped) {
  EnableVarInfoStrip();

  // foo() calls native inspect() which invokes GetLocalVariables(ctx, 0).
  // Since foo's vardefs are stripped, GetLocalVariables should return empty
  // obj.
  const char *src =
      "function foo(a) {\n"
      "  var x = 1;\n"
      "  return inspect();\n"
      "}\n"
      "foo(42);\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  // Set up execution context with the native inspect function
  LEPUSContext *exec_ctx = LEPUS_NewContext(rt_);
  LEPUSValue global = LEPUS_GetGlobalObject(exec_ctx);
  LEPUSValue inspect_fn =
      LEPUS_NewCFunction(exec_ctx, js_inspect_locals, "inspect", 0);
  LEPUS_SetPropertyStr(exec_ctx, global, "inspect", inspect_fn);
  if (!exec_ctx->rt->gc_enable) LEPUS_FreeValue(exec_ctx, global);

  // Execute stripped bytecode — foo() calls inspect()
  LEPUSValue result = LEPUS_EvalBinary(exec_ctx, bc, bc_len, 0);
  ASSERT_FALSE(LEPUS_IsException(result));

  // Result is the object returned by GetLocalVariables.
  // With null vardefs it should be an empty object — no "a" or "x" properties.
  EXPECT_TRUE(LEPUS_IsObject(result));
  LEPUSValue val_a = LEPUS_GetPropertyStr(exec_ctx, result, "a");
  LEPUSValue val_x = LEPUS_GetPropertyStr(exec_ctx, result, "x");
  EXPECT_TRUE(LEPUS_IsUndefined(val_a));
  EXPECT_TRUE(LEPUS_IsUndefined(val_x));

  if (!exec_ctx->rt->gc_enable) LEPUS_FreeValue(exec_ctx, val_a);
  if (!exec_ctx->rt->gc_enable) LEPUS_FreeValue(exec_ctx, val_x);
  if (!exec_ctx->rt->gc_enable) LEPUS_FreeValue(exec_ctx, result);
  LEPUS_FreeContext(exec_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: Full round-trip — strip vardefs, inject them back via
// SetFunctionVarDefs, then verify GetLocalVariables returns correct variable
// names and values.
TEST_F(VarInfoOutsideTest, VarDefsInjectBackRestoresDebuggerInspection) {
  EnableVarInfoStrip();

  const char *src =
      "function foo(a) {\n"
      "  var x = a + 1;\n"
      "  return inspect();\n"
      "}\n"
      "foo(42);\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  // Read original vardefs from foo before serialization
  auto *top_b = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(compiled);
  auto *foo_b = FindInnerFunction(top_b);
  ASSERT_NE(foo_b, nullptr);
  ASSERT_NE(foo_b->vardefs, nullptr);

  uint32_t var_count = GetFunctionVarDefCount(foo_b);
  ASSERT_GT(var_count, 0u);

  std::vector<std::string> names(var_count);
  std::vector<int32_t> scope_levels(var_count);
  std::vector<int32_t> scope_nexts(var_count);
  std::vector<uint8_t> flags(var_count);

  for (uint32_t i = 0; i < var_count; i++) {
    const char *name = GetFunctionVarDefName(ctx_, foo_b, i);
    names[i] = name ? name : "";
    if (name && !ctx_->rt->gc_enable) LEPUS_FreeCString(ctx_, name);
    scope_levels[i] = GetFunctionVarDefScopeLevel(foo_b, i);
    scope_nexts[i] = GetFunctionVarDefScopeNext(foo_b, i);
    flags[i] = GetFunctionVarDefFlags(foo_b, i);
  }

  // Serialize — strips vardefs
  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  // Deserialize — vardefs are null
  LEPUSContext *exec_ctx = LEPUS_NewContext(rt_);
  LEPUSValue read_val =
      LEPUS_ReadObject(exec_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  // Find foo in deserialized bytecode and confirm vardefs are stripped
  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  LEPUSFunctionBytecode *read_foo = nullptr;
  for (int i = 0; i < read_top->cpool_count; i++) {
    if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(read_top->cpool[i])) {
      read_foo =
          (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_top->cpool[i]);
      break;
    }
  }
  ASSERT_NE(read_foo, nullptr);
  ASSERT_EQ(read_foo->vardefs, nullptr);

  // Inject vardefs back via SetFunctionVarDefs
  std::vector<const char *> c_names(var_count);
  for (uint32_t i = 0; i < var_count; i++) {
    c_names[i] = names[i].c_str();
  }
  SetFunctionVarDefs(exec_ctx, read_foo, c_names.data(), scope_levels.data(),
                     scope_nexts.data(), flags.data(), var_count);
  ASSERT_NE(read_foo->vardefs, nullptr);

  // Register native inspect function and execute
  LEPUSValue global = LEPUS_GetGlobalObject(exec_ctx);
  LEPUSValue inspect_fn =
      LEPUS_NewCFunction(exec_ctx, js_inspect_locals, "inspect", 0);
  LEPUS_SetPropertyStr(exec_ctx, global, "inspect", inspect_fn);

  LEPUSValue result = LEPUS_EvalFunction(exec_ctx, read_val, global);
  if (!exec_ctx->rt->gc_enable) LEPUS_FreeValue(exec_ctx, global);
  ASSERT_FALSE(LEPUS_IsException(result));

  // GetLocalVariables should now return the variables with correct values.
  // foo(42) sets a=42, x=42+1=43.
  EXPECT_TRUE(LEPUS_IsObject(result));

  LEPUSValue val_a = LEPUS_GetPropertyStr(exec_ctx, result, "a");
  EXPECT_FALSE(LEPUS_IsUndefined(val_a));
  int32_t int_a;
  EXPECT_EQ(LEPUS_ToInt32(exec_ctx, &int_a, val_a), 0);
  EXPECT_EQ(int_a, 42);

  LEPUSValue val_x = LEPUS_GetPropertyStr(exec_ctx, result, "x");
  EXPECT_FALSE(LEPUS_IsUndefined(val_x));
  int32_t int_x;
  EXPECT_EQ(LEPUS_ToInt32(exec_ctx, &int_x, val_x), 0);
  EXPECT_EQ(int_x, 43);

  if (!exec_ctx->rt->gc_enable) LEPUS_FreeValue(exec_ctx, val_a);
  if (!exec_ctx->rt->gc_enable) LEPUS_FreeValue(exec_ctx, val_x);
  if (!exec_ctx->rt->gc_enable) LEPUS_FreeValue(exec_ctx, result);
  LEPUS_FreeContext(exec_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Native function that simulates debugger evaluate-on-callframe.
// Calls DebuggerEvaluate("0", expression) on the current stack, which
// internally goes through JS_EvalInternal(debugger_eval=true) →
// add_closure_variables.  If vardefs is null and not guarded, this crashes.
static LEPUSValue js_debugger_eval(LEPUSContext *ctx, LEPUSValueConst this_val,
                                   int argc, LEPUSValueConst *argv) {
  if (argc < 1) return LEPUS_UNDEFINED;
  return DebuggerEvaluate(ctx, "0", argv[0]);
}

// Test: DebuggerEvaluate does not crash when vardefs are stripped.
// This exercises the add_closure_variables path with null vardefs.
TEST_F(VarInfoOutsideTest, DebuggerEvalSafeWhenVarDefsStripped) {
  EnableVarInfoStrip();

  // foo() has local variables but after strip vardefs will be null.
  // It calls dbg_eval("1 + 2") which triggers DebuggerEvaluate internally.
  const char *src =
      "function foo(a) {\n"
      "  var x = a + 1;\n"
      "  return dbg_eval('1 + 2');\n"
      "}\n"
      "foo(42);\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  // Set up execution context with the native dbg_eval function
  LEPUSContext *exec_ctx = LEPUS_NewContext(rt_);
  LEPUSValue global = LEPUS_GetGlobalObject(exec_ctx);
  LEPUSValue eval_fn =
      LEPUS_NewCFunction(exec_ctx, js_debugger_eval, "dbg_eval", 1);
  LEPUS_SetPropertyStr(exec_ctx, global, "dbg_eval", eval_fn);
  if (!exec_ctx->rt->gc_enable) LEPUS_FreeValue(exec_ctx, global);

  // Execute — should not crash.  The expression "1 + 2" doesn't reference
  // any of foo's locals, so it should succeed even without vardefs.
  // NOTE: DebuggerEvaluate wraps results in a RemoteObject, so we only
  // verify that execution completes without crashing (no SIGSEGV).
  LEPUSValue result = LEPUS_EvalBinary(exec_ctx, bc, bc_len, 0);
  EXPECT_FALSE(LEPUS_IsException(result))
      << "Should not crash or throw when vardefs are stripped";

  if (!exec_ctx->rt->gc_enable) LEPUS_FreeValue(exec_ctx, result);
  LEPUS_FreeContext(exec_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

#endif  // ENABLE_QUICKJS_DEBUGGER

// Test: LEPUS_SetOptLepusNGPackageSize API and propagation to Context.
TEST_F(VarInfoOutsideTest, SetOptLepusNGPackageSizeAPI) {
  // Default: opt_lepusng_package_size should be false (not explicitly set)
  LEPUSRuntime *test_rt = LEPUS_NewRuntime();
  EXPECT_FALSE(test_rt->opt_lepusng_package_size);

  // Enable
  LEPUS_SetOptLepusNGPackageSize(test_rt, 1);
  EXPECT_TRUE(test_rt->opt_lepusng_package_size);

  // Context should inherit from Runtime
  LEPUSContext *test_ctx = LEPUS_NewContext(test_rt);
  EXPECT_TRUE(test_ctx->opt_lepusng_package_size);
  LEPUS_FreeContext(test_ctx);

  // Disable
  LEPUS_SetOptLepusNGPackageSize(test_rt, 0);
  EXPECT_FALSE(test_rt->opt_lepusng_package_size);

  // Context created after disable should inherit false
  test_ctx = LEPUS_NewContext(test_rt);
  EXPECT_FALSE(test_ctx->opt_lepusng_package_size);
  LEPUS_FreeContext(test_ctx);

  LEPUS_FreeRuntime(test_rt);

  // Null safety — should not crash
  LEPUS_SetOptLepusNGPackageSize(nullptr, 1);
}

// Test: SetFunctionVarDefs boundary conditions — null var_names, zero count,
// and mismatched count should all be no-ops.
TEST_F(VarInfoOutsideTest, SetVarDefsBoundaryConditions) {
  EnableVarInfoStrip();

  const char *src =
      "function foo(a) {\n"
      "  var x = 1;\n"
      "  return a + x;\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  LEPUSContext *read_ctx = LEPUS_NewContext(rt_);
  LEPUSValue read_val =
      LEPUS_ReadObject(read_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  auto *read_foo = FindInnerFunction(read_top);
  ASSERT_NE(read_foo, nullptr);
  ASSERT_EQ(read_foo->vardefs, nullptr);  // stripped

  // Case 1: var_names == nullptr → no-op
  int32_t levels[] = {0, 0};
  int32_t nexts[] = {-1, -1};
  uint8_t flags[] = {0, 0};
  SetFunctionVarDefs(read_ctx, read_foo, nullptr, levels, nexts, flags, 2);
  EXPECT_EQ(read_foo->vardefs, nullptr);

  // Case 2: count == 0 → no-op
  const char *names[] = {"a", "x"};
  SetFunctionVarDefs(read_ctx, read_foo, names, levels, nexts, flags, 0);
  EXPECT_EQ(read_foo->vardefs, nullptr);

  // Case 3: count != arg_count + var_count → no-op
  SetFunctionVarDefs(read_ctx, read_foo, names, levels, nexts, flags, 999);
  EXPECT_EQ(read_foo->vardefs, nullptr);

  if (!read_ctx->rt->gc_enable) LEPUS_FreeValue(read_ctx, read_val);
  LEPUS_FreeContext(read_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: SetFunctionVarDefs with null optional arrays uses defaults.
TEST_F(VarInfoOutsideTest, SetVarDefsNullOptionalArraysUsesDefaults) {
  EnableVarInfoStrip();

  const char *src =
      "function foo(a) {\n"
      "  var x = 1;\n"
      "  return a + x;\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  LEPUSContext *read_ctx = LEPUS_NewContext(rt_);
  LEPUSValue read_val =
      LEPUS_ReadObject(read_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  auto *read_foo = FindInnerFunction(read_top);
  ASSERT_NE(read_foo, nullptr);
  ASSERT_EQ(read_foo->vardefs, nullptr);

  uint32_t count = read_foo->arg_count + read_foo->var_count;
  ASSERT_EQ(count, 2u);

  // Pass valid var_names but null for scope_levels, scope_nexts, flags
  const char *names[] = {"a", "x"};
  SetFunctionVarDefs(read_ctx, read_foo, names, nullptr, nullptr, nullptr,
                     count);
  ASSERT_NE(read_foo->vardefs, nullptr);

  // Verify defaults: scope_level=0, scope_next=-1, all flag bits=0
  for (uint32_t i = 0; i < count; i++) {
    EXPECT_EQ(GetFunctionVarDefScopeLevel(read_foo, i), 0);
    EXPECT_EQ(GetFunctionVarDefScopeNext(read_foo, i), -1);
    EXPECT_EQ(GetFunctionVarDefFlags(read_foo, i), 0u);
  }

  if (!read_ctx->rt->gc_enable) LEPUS_FreeValue(read_ctx, read_val);
  LEPUS_FreeContext(read_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

// Test: vardefs should NOT be stripped when debuginfo_outside is 0
// (even if is_lepusng=true and version >= 4.1).
TEST_F(VarInfoOutsideTest, VarDefsPreservedWhenDebugInfoOutsideDisabled) {
  // is_lepusng is already true from SetUp (runtime info = "Lynx_LepusNG")
  ctx_->debuginfo_outside = 0;
  SetLynxTargetSdkVersion(ctx_, "4.1");

  const char *src =
      "function foo(a) {\n"
      "  var x = 1;\n"
      "  return a + x;\n"
      "}\n";

  LEPUSValue compiled = CompileOnly(src);
  ASSERT_FALSE(LEPUS_IsException(compiled));

  size_t bc_len;
  uint8_t *bc = Serialize(compiled, &bc_len);
  ASSERT_NE(bc, nullptr);

  LEPUSContext *read_ctx = LEPUS_NewContext(rt_);
  LEPUSValue read_val =
      LEPUS_ReadObject(read_ctx, bc, bc_len, LEPUS_READ_OBJ_BYTECODE);
  ASSERT_FALSE(LEPUS_IsException(read_val));

  auto *read_top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_val);
  LEPUSFunctionBytecode *read_foo = nullptr;
  for (int i = 0; i < read_top->cpool_count; i++) {
    if (LEPUS_VALUE_IS_FUNCTION_BYTECODE(read_top->cpool[i])) {
      read_foo =
          (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(read_top->cpool[i]);
      break;
    }
  }
  ASSERT_NE(read_foo, nullptr);
  // Vardefs should NOT be stripped when debuginfo_outside=0
  EXPECT_NE(read_foo->vardefs, nullptr);
  // varinfo_outside should NOT be set
  EXPECT_EQ(read_ctx->varinfo_outside, 0);

  if (!read_ctx->rt->gc_enable) LEPUS_FreeValue(read_ctx, read_val);
  LEPUS_FreeContext(read_ctx);
  if (!ctx_->rt->gc_enable) lepus_free(ctx_, bc);
  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}

TEST_F(VarInfoOutsideTest, DebugSourceOffsetMatchesOriginalSourceSlice) {
  const std::string src =
      "const prefix = 1;\n"
      "class Base {}\n"
      "class Derived extends Base {}\n"
      "function outer(a) {\n"
      "  const arrow = (b) => b + a;\n"
      "  class Box {\n"
      "    constructor(value) {\n"
      "      this.value = value;\n"
      "    }\n"
      "    method(delta) {\n"
      "      return arrow(this.value + delta);\n"
      "    }\n"
      "  }\n"
      "  return new Box(prefix).method(2);\n"
      "}\n"
      "outer(3);\n";

  LEPUSValue compiled = CompileOnly(src.c_str());
  ASSERT_FALSE(LEPUS_IsException(compiled));

  auto *top = (LEPUSFunctionBytecode *)LEPUS_VALUE_GET_PTR(compiled);
  std::vector<LEPUSFunctionBytecode *> functions;
  CollectFunctionBytecodes(top, &functions);
  ASSERT_GE(functions.size(), 6u);

  bool checked_nested_function = false;
  size_t checked_function_count = 0;
  const size_t src_len = src.length();
  for (LEPUSFunctionBytecode *function : functions) {
    ASSERT_TRUE(function->has_debug);
    const char *debug_source = function->debug.source;
    int32_t source_len = function->debug.source_len;
    int32_t source_offset = function->debug.source_offset;

    if (!debug_source) continue;
    checked_function_count++;
    ASSERT_GE(source_len, 0);
    ASSERT_GE(source_offset, 0);
    ASSERT_LE(static_cast<size_t>(source_offset), src_len);
    ASSERT_LE(static_cast<size_t>(source_len), src_len);
    ASSERT_LE(
        static_cast<size_t>(source_offset) + static_cast<size_t>(source_len),
        src_len);

    std::string expected(src.c_str() + source_offset, source_len);
    EXPECT_EQ(expected, std::string(debug_source, source_len));
    if (source_offset > 0) checked_nested_function = true;
  }
  EXPECT_GT(checked_function_count, 0u);
  EXPECT_TRUE(checked_nested_function);

  ExpectFunctionSourceOffset(src, functions, "class Base {}");
  ExpectFunctionSourceOffset(src, functions, "class Derived extends Base {}");
  ExpectFunctionSourceOffset(src, functions,
                             "function outer(a) {\n"
                             "  const arrow = (b) => b + a;\n"
                             "  class Box {\n"
                             "    constructor(value) {\n"
                             "      this.value = value;\n"
                             "    }\n"
                             "    method(delta) {\n"
                             "      return arrow(this.value + delta);\n"
                             "    }\n"
                             "  }\n"
                             "  return new Box(prefix).method(2);\n"
                             "}");
  ExpectFunctionSourceOffset(src, functions, "(b) => b + a");
  ExpectFunctionSourceOffset(src, functions,
                             "class Box {\n"
                             "    constructor(value) {\n"
                             "      this.value = value;\n"
                             "    }\n"
                             "    method(delta) {\n"
                             "      return arrow(this.value + delta);\n"
                             "    }\n"
                             "  }");
  ExpectFunctionSourceOffset(src, functions,
                             "method(delta) {\n"
                             "      return arrow(this.value + delta);\n"
                             "    }");

  if (!ctx_->rt->gc_enable) LEPUS_FreeValue(ctx_, compiled);
}
