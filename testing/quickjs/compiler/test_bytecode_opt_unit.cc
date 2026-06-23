// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>

#include "gtest/gtest.h"
#include "quickjs/include/quickjs-inner.h"
#include "quickjs/include/quickjs-opt-bytecode.h"
#include "quickjs/include/quickjs.h"

// Unit tests for bytecode optimization passes.
// These tests directly invoke optimization functions with hand-crafted
// bytecode to verify each pass works correctly in isolation.

namespace {

class BytecodeOptUnit : public ::testing::Test {
 protected:
  void SetUp() override {
    rt_ = LEPUS_NewRuntime();
    LEPUS_SetRuntimeInfo(rt_, "Lynx_LepusNG");
    LEPUS_SetOptLepusNGPackageSize(rt_, 1);
    ctx_ = LEPUS_NewContext(rt_);
  }

  void TearDown() override {
    for (LEPUSValue val : pinned_functions_) {
      LEPUS_FreeValue(ctx_, val);
    }
    pinned_functions_.clear();
    LEPUS_FreeContext(ctx_);
    LEPUS_FreeRuntime(rt_);
  }

  // Helper: compile a JS function and return its bytecode.
  // The caller must not free the returned data (owned by the context).
  bool CompileFunction(const std::string& js_code,
                       LEPUSFunctionBytecode** out_fb,
                       JSFunctionDef** out_fd = nullptr) {
    LEPUSValue val = LEPUS_Eval(ctx_, js_code.c_str(), js_code.size(),
                                "<unit_test>", LEPUS_EVAL_TYPE_GLOBAL);
    if (LEPUS_IsException(val)) {
      LEPUS_FreeValue(ctx_, LEPUS_GetException(ctx_));
      return false;
    }
    if (!LEPUS_IsFunction(ctx_, val)) {
      LEPUS_FreeValue(ctx_, val);
      return false;
    }
    LEPUSObject* obj = LEPUS_VALUE_GET_OBJ(val);
    if (obj->class_id != JS_CLASS_BYTECODE_FUNCTION) {
      LEPUS_FreeValue(ctx_, val);
      return false;
    }
    *out_fb = obj->u.func.function_bytecode;
    // Keep the function alive for the duration of the test, then release it
    // explicitly in TearDown so LSan does not report retained bytecode trees.
    pinned_functions_.push_back(val);
    return true;
  }

  // Helper: check if bytecode contains a specific opcode sequence
  bool BytecodeContains(const uint8_t* bc, int len, const uint8_t* pattern,
                        int pattern_len) {
    for (int i = 0; i <= len - pattern_len; i++) {
      bool match = true;
      for (int j = 0; j < pattern_len; j++) {
        if (bc[i + j] != pattern[j]) {
          match = false;
          break;
        }
      }
      if (match) return true;
    }
    return false;
  }

  // Helper: count occurrences of an opcode in bytecode
  int CountOpcode(const uint8_t* bc, int len, uint8_t op) {
    int count = 0;
    int pos = 0;
    while (pos < len) {
      if (bc[pos] == op) count++;
      int sz = short_opcode_info(bc[pos]).size;
      if (sz <= 0) break;
      pos += sz;
    }
    return count;
  }

  LEPUSRuntime* rt_;
  LEPUSContext* ctx_;
  std::vector<LEPUSValue> pinned_functions_;
};

// ==========================================================================
// Constant folding helper tests
// ==========================================================================

TEST_F(BytecodeOptUnit, ConstFoldShiftLeftUsesUnsignedSemantics) {
  int32_t result = 0;

  ASSERT_TRUE(opt_const_fold_try_binary(OP_shl, 1, 31, &result));
  EXPECT_EQ(result, static_cast<int32_t>(0x80000000u));

  ASSERT_TRUE(opt_const_fold_try_binary(OP_shl, 0x40000000, 1, &result));
  EXPECT_EQ(result, static_cast<int32_t>(0x80000000u));

  ASSERT_TRUE(opt_const_fold_try_binary(OP_shl, -1, 1, &result));
  EXPECT_EQ(result, -2);

  ASSERT_TRUE(opt_const_fold_try_binary(OP_sar, -8, 1, &result));
  EXPECT_EQ(result, -4);

  ASSERT_TRUE(opt_const_fold_try_binary(OP_sar, -1, 31, &result));
  EXPECT_EQ(result, -1);
}

// ==========================================================================
// opt_nop_strip tests
// ==========================================================================

// Verify that NOPs are stripped from the bytecode.
// We test indirectly: a function with obvious dead code (return + unreachable
// code) should have fewer NOPs after optimization.
TEST_F(BytecodeOptUnit, NopStrip_DeadCodeAfterReturn) {
  // Function with dead code after return — optimizer should NOP it out
  // and then nop_strip should remove those NOPs.
  const char* code =
      "(function() {\n"
      "  let x = 1;\n"
      "  return x;\n"
      "  x = 2; x = 3; x = 4; x = 5;\n"  // dead code
      "})";
  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code, &fb));
  ASSERT_NE(fb, nullptr);
  ASSERT_GT(fb->byte_code_len, 0);

  // After DCE + nop_strip, there should be zero NOPs in the bytecode.
  // (All dead code should have been converted to NOPs and then stripped.)
  int nop_count = CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_nop);
  EXPECT_EQ(nop_count, 0) << "Expected zero NOPs after nop_strip pass";
}

// Verify that with many NOPs (from large dead code region), the bytecode
// is properly compacted and still contains the live instructions.
TEST_F(BytecodeOptUnit, NopStrip_LargeDeadRegion) {
  // Generate a function with lots of dead code after return
  std::string code = "(function() {\n  let x = 1;\n  return x;\n";
  for (int i = 0; i < 50; i++) {
    code += "  let v" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  code += "})";

  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code.c_str(), &fb));
  ASSERT_NE(fb, nullptr);

  // No NOPs should remain
  int nop_count = CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_nop);
  EXPECT_EQ(nop_count, 0);

  // Bytecode should contain return
  uint8_t ret_op = (uint8_t)OP_return;
  bool has_return =
      BytecodeContains(fb->byte_code_buf, fb->byte_code_len, &ret_op, 1);
  EXPECT_TRUE(has_return);
}

// ==========================================================================
// opt_dead_slu_elim tests
// ==========================================================================

// Verify that set_loc_uninitialized for a variable with no TDZ reads
// is eliminated.
TEST_F(BytecodeOptUnit, DeadSLUElim_SimpleLet) {
  // A let variable that is written before any read should have its
  // set_loc_uninitialized eliminated.
  const char* code =
      "(function() {\n"
      "  let x;\n"
      "  x = 42;\n"    // write before read
      "  return x;\n"  // read after write
      "})";
  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code, &fb));
  ASSERT_NE(fb, nullptr);

  // After SLU elimination, there should be no set_loc_uninitialized
  int slu_count = CountOpcode(fb->byte_code_buf, fb->byte_code_len,
                              OP_set_loc_uninitialized);
  EXPECT_EQ(slu_count, 0)
      << "Expected zero set_loc_uninitialized after SLU elimination";
}

// Verify that set_loc_uninitialized is NOT eliminated when there's a
// TDZ read before the let declaration (correctness test).
TEST_F(BytecodeOptUnit, DeadSLUElim_TDZReadPreservesSLU) {
  // Reading a let variable before its declaration must throw TDZ.
  // If SLU was incorrectly eliminated, the read would return undefined.
  const char* code =
      "(function() {\n"
      "  try { return x; } catch(e) { return 1; }\n"  // TDZ read → throw →
                                                      // catch returns 1
      "  let x = 42;\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // If TDZ is preserved, we catch the error and return 1.
  // If SLU was incorrectly eliminated, x would be undefined → 0.
  EXPECT_EQ(result, 1);
}

// Verify multiple let variables: some dead-SLU, some not.
TEST_F(BytecodeOptUnit, DeadSLUElim_MultipleVars) {
  const char* code =
      "(function() {\n"
      "  let a = 1;\n"  // written at declaration, SLU can be eliminated
      "  let b = 2;\n"  // written at declaration, SLU can be eliminated
      "  let c;\n"      // not written before first read? depends on usage
      "  c = a + b;\n"  // c is written before any read of c
      "  return c;\n"
      "})";
  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code, &fb));
  ASSERT_NE(fb, nullptr);

  // All three variables have writes before reads, so all SLUs should be gone
  int slu_count = CountOpcode(fb->byte_code_buf, fb->byte_code_len,
                              OP_set_loc_uninitialized);
  EXPECT_EQ(slu_count, 0);
}

// ==========================================================================
// opt_reorder_local_vars tests
// ==========================================================================

// Verify that with many variables, the most frequently accessed ones
// get low indices (which use shorter encodings).
TEST_F(BytecodeOptUnit, ReorderLocalVars_HotVarsGetLowIndices) {
  // Create a function with many variables, where a few high-index variables
  // are accessed very frequently. After reordering, those hot variables
  // should be remapped to low indices (0-3), which means we should see
  // get_loc0-3 / put_loc0-3 (1-byte opcode, no index) instead of the
  // 3-byte form for high indices.
  std::string code = "(function() {\n";
  // Declare 100 variables (all let, so they have TDZ)
  for (int i = 0; i < 100; i++) {
    code += "  let v" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  // Access the last variable (originally high index) many times
  code += "  let sum = 0;\n";
  for (int i = 0; i < 20; i++) {
    code += "  sum += v99;\n";
  }
  code += "  return sum;\n})";

  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code.c_str(), &fb));
  ASSERT_NE(fb, nullptr);

  // After reordering, v99 (hot) should have a low index (0-3).
  // We verify this by checking that 1-byte local variable load opcodes
  // (get_loc0, get_loc1, get_loc2, get_loc3) appear frequently, since
  // the hot variable will use the 1-byte form after being remapped to
  // a low index.
  int get_loc_short_count =
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_get_loc0) +
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_get_loc1) +
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_get_loc2) +
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_get_loc3);
  int get_loc_count =
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_get_loc);
  // With 100 variables and one hot var accessed 20 times, the hot var
  // should be remapped to index 0-3, giving us at least some short-form
  // get_loc operations.
  EXPECT_GT(get_loc_short_count + get_loc_count, 0)
      << "Expected at least some get_loc operations";
  // At least some reads should use short form (1-byte opcode) after reordering
  EXPECT_GT(get_loc_short_count, 0)
      << "Expected short-form get_loc (index 0-3) after variable reordering";
}

// Verify that variable reordering doesn't break correctness.
TEST_F(BytecodeOptUnit, ReorderLocalVars_Correctness) {
  // Run a function with many variables and complex access patterns,
  // verify the result is correct.
  std::string code = "(function() {\n";
  for (int i = 0; i < 50; i++) {
    code +=
        "  let v" + std::to_string(i) + " = " + std::to_string(i * 2) + ";\n";
  }
  code += "  let result = 0;\n";
  // Access variables in reverse order (high indices first)
  for (int i = 49; i >= 0; i--) {
    code += "  result += v" + std::to_string(i) + ";\n";
  }
  code += "  return result;\n})()";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // Expected: sum of 0, 2, 4, ..., 98 = 2 * (0+1+...+49) = 2 * 1225 = 2450
  EXPECT_EQ(result, 2450);
}

// ==========================================================================
// opt_reorder_cpool tests
// ==========================================================================

// Verify that constant pool reordering doesn't break correctness.
// We create a function with many unique numeric constants (>256 to trigger
// cpool reordering) and verify the result is correct.
TEST_F(BytecodeOptUnit, ReorderCpool_LargeCpool) {
  // Generate a function with 300 unique numeric constants that are
  // summed up. After cpool reordering, the result should still be correct.
  std::string code = "(function() {\n";
  code += "  let sum = 0;\n";
  // Use many unique float constants to populate the cpool
  for (int i = 0; i < 300; i++) {
    code += "  sum += " + std::to_string(i * 1.5) + ";\n";
  }
  code += "  return sum;\n})()";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  // Verify result is correct: sum of 0, 1.5, 3.0, ..., 299*1.5
  // = 1.5 * (0+1+2+...+299) = 1.5 * (299*300/2) = 1.5 * 44850 = 67275
  double result = 0;
  LEPUS_ToFloat64(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_DOUBLE_EQ(result, 67275.0);
}

// ==========================================================================
// Combined optimization correctness tests
// ==========================================================================

// Test that all optimizations combined produce correct results for
// a function with many variables, closures, and dead code.
TEST_F(BytecodeOptUnit, Combined_OptimizationsCorrect) {
  const char* code =
      "(function(n) {\n"
      "  let a = 1, b = 2, c = 3, d = 4, e = 5;\n"
      "  let f = 6, g = 7, h = 8, i = 9, j = 10;\n"
      "  if (n > 0) {\n"
      "    return a + b + c + d + e;\n"  // early return, rest is dead
      "  } else {\n"
      "    return f + g + h + i + j;\n"
      "  }\n"
      "  // dead code below\n"
      "  let x = 100, y = 200, z = 300;\n"
      "  return x + y + z;\n"
      "})(5)";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 15);  // 1+2+3+4+5 = 15
}

// Test TDZ correctness with all optimizations enabled.
TEST_F(BytecodeOptUnit, Combined_TDZCorrectness) {
  const char* code =
      "(function() {\n"
      "  try {\n"
      "    console.log(x);\n"  // should throw TDZ
      "    return 0;\n"
      "  } catch(e) {\n"
      "    return 1;\n"
      "  }\n"
      "  let x = 42;\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // TDZ error should be caught, returning 1 from catch
  EXPECT_EQ(result, 1);
}

// ==========================================================================
// TDZ correctness with variable reordering (regression test for atomicity bug)
// ==========================================================================

// Verify that TDZ semantics are preserved after local variable reordering.
// This tests that loc_initialized array is correctly remapped along with
// variable indices, so TDZ checks use the right variable.
// Regression test: loc_initialized remap used to allocate a separate buffer
// at the end of opt_reorder_local_vars; on OOM it would silently fail,
// leaving loc_initialized with stale indices while vars/bytecode were
// already remapped, causing incorrect TDZ downgrades.
TEST_F(BytecodeOptUnit, ReorderLocalVars_TDZCorrectness) {
  // Create a function with many let variables (all have TDZ), where some
  // variables are accessed many times (hot, get remapped to low indices)
  // and another variable is read before initialization (TDZ violation).
  // If loc_initialized is not properly remapped, the TDZ check would
  // query the wrong index and might incorrectly skip the check.
  std::string code = "(function() {\n";
  // Declare many let variables (ensures reorder is triggered: var_count > 4)
  for (int i = 0; i < 20; i++) {
    code += "  let v" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  // Make v19 "hot" by accessing it many times (should get remapped to low idx)
  code += "  let sum = 0;\n";
  for (int i = 0; i < 30; i++) {
    code += "  sum += v19;\n";
  }
  // Now declare another let variable and read it before init (TDZ violation)
  code += "  try {\n";
  code += "    return tdz_var;  // TDZ read — must throw\n";
  code += "  } catch(e) {\n";
  code += "    return sum;  // TDZ caught, return the sum\n";
  code += "  }\n";
  code += "  let tdz_var = 999;\n";
  code += "})()";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // If TDZ is working correctly: catch returns sum = v19 * 30 = 19 * 30 = 570
  // If TDZ is broken (loc_initialized stale): tdz_var read as undefined → NaN/0
  EXPECT_EQ(result, 570);
}

// Test TDZ correctness with multiple TDZ variables at different positions.
// Ensures that reordering doesn't mix up TDZ state of different variables.
TEST_F(BytecodeOptUnit, ReorderLocalVars_MultipleTDZVariables) {
  std::string code = "(function() {\n";
  // 15 let variables — some used heavily, some in TDZ state
  for (int i = 0; i < 15; i++) {
    code +=
        "  let a" + std::to_string(i) + " = " + std::to_string(i * 10) + ";\n";
  }
  // Make a14 very hot (gets remapped to index 0-3)
  code += "  let total = 0;\n";
  for (int i = 0; i < 50; i++) {
    code += "  total += a14;\n";
  }
  // Two TDZ variables at different scopes
  code += "  let caught = 0;\n";
  code += "  try { return tdz1; } catch(e) { caught++; }\n";
  code += "  let tdz1 = 1;\n";
  code += "  try { return tdz2; } catch(e) { caught++; }\n";
  code += "  let tdz2 = 2;\n";
  code += "  return total + caught;\n";
  code += "})()";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // total = a14 * 50 = 140 * 50 = 7000, caught = 2 (both TDZ throws caught)
  EXPECT_EQ(result, 7002);
}

// ==========================================================================
// fold_const_truthy + pos_next regression tests
//
// NOTE: fold_const_truthy is an emission-time peephole optimization that runs
// during Phase 2 (main emission loop in resolve_labels()), NOT one of the 12
// numbered post-passes (P5–P12). It folds constant truthiness + OP_lnot
// cascades + conditional branches at emit time. Tests here are regression
// tests for bugs discovered in that emission-time logic.
// ==========================================================================

// Regression test for the pos_next reset bug in fold_const_truthy.
//
// Bug: When fold_const_truthy consumed extra instructions (e.g., lnot +
// if_false/if_true) and returned a branch opcode (OP_goto), the emission
// loop incorrectly reset pos_next = pos + opcode_info[new_op].size, which
// pointed into the middle of the already-consumed instructions. This caused
// skip_dead_code to read garbage bytes as opcodes/atoms, leading to a crash
// (LEPUS_FreeAtom on an invalid atom).
//
// Trigger pattern: push_const_truthy + OP_lnot + OP_if_false/OP_if_true
// e.g., `if (!(true)) { dead } else { live }`
//
// This test should CRASH (segfault/ASAN error) without the fix and PASS
// with the fix.
TEST_F(BytecodeOptUnit, FoldConstTruthy_PosNextRegression) {
  // Pattern: !(true) → push_true + lnot + if_false
  // fold_const_truthy folds this into OP_goto (always branch to else),
  // consuming 3 instructions. Without the fix, pos_next is wrong and
  // skip_dead_code reads garbage.
  const char* code =
      "(function() {\n"
      "  if (!(true)) {\n"
      "    return 'dead';\n"
      "  } else {\n"
      "    return 'live';\n"
      "  }\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  // The else branch should always execute
  const char* str = LEPUS_ToCString(ctx_, val);
  ASSERT_NE(str, nullptr);
  EXPECT_STREQ(str, "live");
  LEPUS_FreeCString(ctx_, str);
  LEPUS_FreeValue(ctx_, val);
}

// Same regression but with if_true (inverted branch).
TEST_F(BytecodeOptUnit, FoldConstTruthy_PosNextRegression_IfTrue) {
  const char* code =
      "(function() {\n"
      "  if (!!(false)) {\n"
      "    return 'dead';\n"
      "  } else {\n"
      "    return 'live';\n"
      "  }\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  const char* str = LEPUS_ToCString(ctx_, val);
  ASSERT_NE(str, nullptr);
  EXPECT_STREQ(str, "live");
  LEPUS_FreeCString(ctx_, str);
  LEPUS_FreeValue(ctx_, val);
}

// Regression test with more complex dead code after the folded branch.
// This triggers deeper skip_dead_code traversal which is more likely to
// crash on invalid atoms if pos_next is wrong.
TEST_F(BytecodeOptUnit, FoldConstTruthy_PosNextRegression_ComplexDead) {
  const char* code =
      "(function() {\n"
      "  let result = 0;\n"
      "  if (!(true)) {\n"
      "    let x = 'hello';\n"
      "    let y = x + ' world';\n"
      "    let z = y.length;\n"
      "    result = z * 100;\n"
      "  } else {\n"
      "    result = 42;\n"
      "  }\n"
      "  return result;\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 42);
}

// Test that fold_const_truthy works correctly with string constants.
// String constants also trigger the truthy fold path (non-empty strings
// are truthy, empty strings are falsy).
TEST_F(BytecodeOptUnit, FoldConstTruthy_PosNextRegression_StringConst) {
  const char* code =
      "(function() {\n"
      "  if (!('non-empty')) {\n"
      "    return 'dead';\n"
      "  }\n"
      "  return 'alive';\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  const char* str = LEPUS_ToCString(ctx_, val);
  ASSERT_NE(str, nullptr);
  EXPECT_STREQ(str, "alive");
  LEPUS_FreeCString(ctx_, str);
  LEPUS_FreeValue(ctx_, val);
}

// Test the OP_get_var → OP_undefined folding path.
// When fold_const_truthy converts get_var("undefined") to OP_undefined,
// pos_next must not be reset either, and the non-branch opcode must not
// incorrectly jump to has_label.
TEST_F(BytecodeOptUnit, FoldConstTruthy_GetVarUndefined) {
  // `undefined` triggers get_var("undefined") → OP_undefined folding
  const char* code =
      "(function() {\n"
      "  let x = undefined;\n"
      "  if (!x) {\n"
      "    return 'x is falsy';\n"
      "  }\n"
      "  return 'x is truthy';\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  const char* str = LEPUS_ToCString(ctx_, val);
  ASSERT_NE(str, nullptr);
  EXPECT_STREQ(str, "x is falsy");
  LEPUS_FreeCString(ctx_, str);
  LEPUS_FreeValue(ctx_, val);
}

TEST_F(BytecodeOptUnit, PostPassNopAtomInstructionReleasesAtom) {
  JSFunctionDef fd = {};
  DynBuf bc_out;
  dbuf_init2(&bc_out, ctx_->rt,
             reinterpret_cast<DynBufReallocFunc*>(lepus_dbuf_realloc_rt));

  JSAtom atom = LEPUS_NewAtom(ctx_, "atom-drop-release-regression");
  ASSERT_NE(atom, JS_ATOM_NULL);
  if (!ctx_->gc_enable) LEPUS_DupAtom(ctx_, atom);
  uint32_t old_ref_count = ctx_->rt->atom_array[atom]->header.ref_count;

  dbuf_putc(&bc_out, OP_push_atom_value);
  dbuf_put_u32(&bc_out, atom);
  dbuf_putc(&bc_out, OP_drop);

  fd.ctx = ctx_;
  fd.byte_code = bc_out;

  opt_final_dce(ctx_, &fd, &bc_out);

  if (!ctx_->gc_enable) {
    EXPECT_EQ(ctx_->rt->atom_array[atom]->header.ref_count, old_ref_count - 1);
  }

  dbuf_free(&bc_out);
  if (!ctx_->gc_enable) LEPUS_FreeAtom(ctx_, atom);
}

// ==========================================================================
// Edge case tests
// ==========================================================================

// Test that an empty function compiles and runs correctly with optimizations.
TEST_F(BytecodeOptUnit, EdgeCase_EmptyFunction) {
  const char* code = "(function() {})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  // Empty function returns undefined
  EXPECT_TRUE(LEPUS_IsUndefined(val));
  LEPUS_FreeValue(ctx_, val);
}

// Test that a function with a single let variable and TDZ read works correctly.
// This does NOT trigger variable reordering (var_count <= 4), but tests the
// TDZ base path with optimizations enabled.
TEST_F(BytecodeOptUnit, EdgeCase_SingleLetTDZ) {
  const char* code =
      "(function() {\n"
      "  try { return x; } catch(e) { return 42; }\n"
      "  let x = 10;\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 42);  // TDZ error caught
}

// Test function with many variables but no TDZ — reordering should not
// affect correctness when all variables are initialized before use.
TEST_F(BytecodeOptUnit, ReorderLocalVars_NoTDZCorrectness) {
  std::string code = "(function() {\n";
  // 30 var variables (no TDZ) — all initialized before any use
  for (int i = 0; i < 30; i++) {
    code += "  var x" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  // Access them in reverse order (different from declaration order)
  code += "  let sum = 0;\n";
  for (int i = 29; i >= 0; i--) {
    code += "  sum += x" + std::to_string(i) + ";\n";
  }
  code += "  return sum;\n";
  code += "})()";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // sum = 0+1+2+...+29 = 435
  EXPECT_EQ(result, 435);
}

// ==========================================================================
// A/B comparison tests (optimization ON vs OFF)
// ==========================================================================

// Helper: compile a function with opt enabled or disabled and return bytecode
// size. Returns -1 on failure. NOTE: must set opt on runtime BEFORE creating
// context, because context inherits opt_lepusng_size at creation time.
static int CompileGetBytecodeSize(LEPUSRuntime* rt, const char* code,
                                  bool opt_enabled) {
  LEPUS_SetOptLepusNGPackageSize(rt, opt_enabled ? 1 : 0);
  LEPUSContext* ctx = LEPUS_NewContext(rt);
  if (!ctx) return -1;

  LEPUSValue val =
      LEPUS_Eval(ctx, code, strlen(code), "<ab_test>", LEPUS_EVAL_TYPE_GLOBAL);
  if (LEPUS_IsException(val)) {
    LEPUS_FreeValue(ctx, LEPUS_GetException(ctx));
    LEPUS_FreeContext(ctx);
    return -1;
  }
  if (!LEPUS_IsFunction(ctx, val)) {
    LEPUS_FreeValue(ctx, val);
    LEPUS_FreeContext(ctx);
    return -1;
  }
  LEPUSObject* obj = LEPUS_VALUE_GET_OBJ(val);
  int size = 0;
  if (obj->class_id == JS_CLASS_BYTECODE_FUNCTION) {
    size = obj->u.func.function_bytecode->byte_code_len;
  }
  LEPUS_FreeValue(ctx, val);
  LEPUS_FreeContext(ctx);
  return size;
}

static bool EvalIntWithOpt(const char* code, bool opt_enabled,
                           int32_t* result) {
  LEPUSRuntime* rt = LEPUS_NewRuntime();
  if (!rt) return false;
  LEPUS_SetRuntimeInfo(rt, "Lynx_LepusNG");
  LEPUS_SetOptLepusNGPackageSize(rt, opt_enabled ? 1 : 0);

  LEPUSContext* ctx = LEPUS_NewContext(rt);
  if (!ctx) {
    LEPUS_FreeRuntime(rt);
    return false;
  }

  LEPUSValue val =
      LEPUS_Eval(ctx, code, strlen(code), "<ab_test>", LEPUS_EVAL_TYPE_GLOBAL);
  if (LEPUS_IsException(val)) {
    LEPUS_FreeValue(ctx, LEPUS_GetException(ctx));
    LEPUS_FreeContext(ctx);
    LEPUS_FreeRuntime(rt);
    return false;
  }

  bool ok = (LEPUS_ToInt32(ctx, result, val) == 0);
  LEPUS_FreeValue(ctx, val);
  LEPUS_FreeContext(ctx);
  LEPUS_FreeRuntime(rt);
  return ok;
}

static int CompileGetBytecodeSizeWithExistingContext(LEPUSContext* ctx,
                                                     const char* code) {
  LEPUSValue val =
      LEPUS_Eval(ctx, code, strlen(code), "<ab_test>", LEPUS_EVAL_TYPE_GLOBAL);
  if (LEPUS_IsException(val)) {
    LEPUS_FreeValue(ctx, LEPUS_GetException(ctx));
    return -1;
  }
  if (!LEPUS_IsFunction(ctx, val)) {
    LEPUS_FreeValue(ctx, val);
    return -1;
  }
  LEPUSObject* obj = LEPUS_VALUE_GET_OBJ(val);
  int size = 0;
  if (obj->class_id == JS_CLASS_BYTECODE_FUNCTION) {
    size = obj->u.func.function_bytecode->byte_code_len;
  }
  LEPUS_FreeValue(ctx, val);
  return size;
}

// Verify that optimization reduces bytecode size for a small function.
TEST_F(BytecodeOptUnit, ABCompare_BytecodeSizeSmallFunc) {
  const char* code =
      "(function(a, b) {\n"
      "  let x = a + b;\n"
      "  let y = x * 2;\n"
      "  return y;\n"
      "})";
  int size_on = CompileGetBytecodeSize(rt_, code, true);
  int size_off = CompileGetBytecodeSize(rt_, code, false);
  ASSERT_GT(size_on, 0);
  ASSERT_GT(size_off, 0);
  // Small function may have minimal savings, but should not be larger with opt
  EXPECT_LE(size_on, size_off);
}

// Verify that optimization reduces bytecode size for a function with
// many variables (triggers reordering + short opcode savings).
TEST_F(BytecodeOptUnit, ABCompare_BytecodeSizeLargeFunc) {
  std::string code = "(function() {\n";
  code += "  let result = 0;\n";
  for (int i = 0; i < 30; i++) {
    code += "  let v" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  // Make first few variables "hot" so reorder helps
  for (int i = 0; i < 50; i++) {
    code += "  result += v0 + v1 + v2;\n";
  }
  code += "  return result;\n})";

  int size_on = CompileGetBytecodeSize(rt_, code.c_str(), true);
  int size_off = CompileGetBytecodeSize(rt_, code.c_str(), false);
  ASSERT_GT(size_on, 0);
  ASSERT_GT(size_off, 0);
  // With many variables and hot vars, reordering should produce smaller code
  EXPECT_LT(size_on, size_off);
}

// Verify that dead code elimination reduces bytecode size significantly
// when there is unreachable code.
TEST_F(BytecodeOptUnit, ABCompare_DeadCodeElim) {
  const char* code =
      "(function(n) {\n"
      "  if (n > 0) return 1;\n"
      "  else return 2;\n"
      "  // dead code below - should be eliminated\n"
      "  let a = 10, b = 20, c = 30, d = 40, e = 50;\n"
      "  let f = 60, g = 70, h = 80, i = 90, j = 100;\n"
      "  return a + b + c + d + e + f + g + h + i + j;\n"
      "})";
  int size_on = CompileGetBytecodeSize(rt_, code, true);
  int size_off = CompileGetBytecodeSize(rt_, code, false);
  ASSERT_GT(size_on, 0);
  ASSERT_GT(size_off, 0);
  // DCE should reduce size noticeably
  EXPECT_LT(size_on, size_off);
}

TEST_F(BytecodeOptUnit, ABCompare_GlobalAccessorAssignmentReadback) {
  const char* code =
      "Object.defineProperty(this, 'x', {\n"
      "  configurable: true,\n"
      "  set: function(v) {},\n"
      "  get: function() { return 7; }\n"
      "});\n"
      "(function() { x = 1; return x; })();";

  int32_t result_off = 0;
  int32_t result_on = 0;
  ASSERT_TRUE(EvalIntWithOpt(code, false, &result_off));
  ASSERT_TRUE(EvalIntWithOpt(code, true, &result_on));
  EXPECT_EQ(result_off, 7);
  EXPECT_EQ(result_on, result_off);
}

TEST_F(BytecodeOptUnit, ConstLnotBranchFold_AllBooleanResultsHandled) {
  struct Case {
    const char* code;
    int32_t expected;
  } cases[] = {
      {"(function(){ if (!!0) return 1; return 2; })()", 2},
      {"(function(){ if (!1) return 1; return 2; })()", 2},
      {"(function(){ if (!!1) return 1; return 2; })()", 1},
      {"(function(){ if (!0) return 1; return 2; })()", 1},
  };

  for (const auto& test_case : cases) {
    int32_t result_off = 0;
    int32_t result_on = 0;
    ASSERT_TRUE(EvalIntWithOpt(test_case.code, false, &result_off))
        << test_case.code;
    ASSERT_TRUE(EvalIntWithOpt(test_case.code, true, &result_on))
        << test_case.code;
    EXPECT_EQ(result_off, test_case.expected) << test_case.code;
    EXPECT_EQ(result_on, result_off) << test_case.code;
  }
}

TEST_F(BytecodeOptUnit, ABCompare_ClosureTDZCallBeforeAndAfterInitialization) {
  const char* code =
      "(function(){\n"
      "  let caught = 0;\n"
      "  function readX() { return x; }\n"
      "  try { readX(); } catch(e) { caught += 1; }\n"
      "  let x = 41;\n"
      "  return caught * 100 + readX();\n"
      "})()";

  int32_t result_off = 0;
  int32_t result_on = 0;
  ASSERT_TRUE(EvalIntWithOpt(code, false, &result_off));
  ASSERT_TRUE(EvalIntWithOpt(code, true, &result_on));
  EXPECT_EQ(result_off, 141);
  EXPECT_EQ(result_on, result_off);
}

TEST_F(BytecodeOptUnit, ABCompare_ClosureTDZSeparateClosuresSameName) {
  const char* code =
      "(function(){\n"
      "  let first = function() { return x; };\n"
      "  let firstCaught = 0;\n"
      "  try { first(); } catch(e) { firstCaught = 1; }\n"
      "  let x = 7;\n"
      "  let second = function() { let x = 11; return function() { return x; "
      "}; };\n"
      "  return firstCaught * 100 + first() + second()();\n"
      "})()";

  int32_t result_off = 0;
  int32_t result_on = 0;
  ASSERT_TRUE(EvalIntWithOpt(code, false, &result_off));
  ASSERT_TRUE(EvalIntWithOpt(code, true, &result_on));
  EXPECT_EQ(result_off, 118);
  EXPECT_EQ(result_on, result_off);
}

TEST_F(BytecodeOptUnit, ABCompare_PrivateFieldClosureCaptured) {
  const char* code =
      "(function(){\n"
      "  class A {\n"
      "    #x = 37;\n"
      "    read() {\n"
      "      const f = () => this.#x;\n"
      "      return f();\n"
      "    }\n"
      "  }\n"
      "  return new A().read();\n"
      "})()";

  int32_t result_off = 0;
  int32_t result_on = 0;
  ASSERT_TRUE(EvalIntWithOpt(code, false, &result_off));
  ASSERT_TRUE(EvalIntWithOpt(code, true, &result_on));
  EXPECT_EQ(result_off, 37);
  EXPECT_EQ(result_on, result_off);
}

TEST_F(BytecodeOptUnit, RuntimeFlagChangeUpdatesExistingContext) {
  const char* code =
      "(function(){\n"
      "  var sum = 0;\n"
      "  var x0=0,x1=1,x2=2,x3=3,x4=4,x5=5,x6=6,x7=7,x8=8,x9=9;\n"
      "  for (var i = 0; i < 20; i++) { sum += x9 + x8 + x7 + x6; }\n"
      "  return sum;\n"
      "})";

  LEPUSRuntime* rt_off = LEPUS_NewRuntime();
  ASSERT_NE(rt_off, nullptr);
  LEPUS_SetRuntimeInfo(rt_off, "Lynx_LepusNG");
  LEPUS_SetOptLepusNGPackageSize(rt_off, 0);
  LEPUSContext* ctx_off = LEPUS_NewContext(rt_off);
  ASSERT_NE(ctx_off, nullptr);
  int size_ctx_off_rt_off =
      CompileGetBytecodeSizeWithExistingContext(ctx_off, code);
  LEPUS_SetOptLepusNGPackageSize(rt_off, 1);
  int size_ctx_off_rt_on =
      CompileGetBytecodeSizeWithExistingContext(ctx_off, code);
  LEPUS_FreeContext(ctx_off);
  LEPUS_FreeRuntime(rt_off);

  LEPUSRuntime* rt_on = LEPUS_NewRuntime();
  ASSERT_NE(rt_on, nullptr);
  LEPUS_SetRuntimeInfo(rt_on, "Lynx_LepusNG");
  LEPUS_SetOptLepusNGPackageSize(rt_on, 1);
  LEPUSContext* ctx_on = LEPUS_NewContext(rt_on);
  ASSERT_NE(ctx_on, nullptr);
  int size_ctx_on_rt_on =
      CompileGetBytecodeSizeWithExistingContext(ctx_on, code);
  LEPUS_SetOptLepusNGPackageSize(rt_on, 0);
  int size_ctx_on_rt_off =
      CompileGetBytecodeSizeWithExistingContext(ctx_on, code);
  LEPUS_FreeContext(ctx_on);
  LEPUS_FreeRuntime(rt_on);

  ASSERT_GT(size_ctx_off_rt_off, 0);
  ASSERT_GT(size_ctx_off_rt_on, 0);
  ASSERT_GT(size_ctx_on_rt_on, 0);
  ASSERT_GT(size_ctx_on_rt_off, 0);
  EXPECT_EQ(size_ctx_off_rt_on, size_ctx_on_rt_on);
  EXPECT_EQ(size_ctx_on_rt_off, size_ctx_off_rt_off);
  EXPECT_LT(size_ctx_off_rt_on, size_ctx_off_rt_off);
  EXPECT_LT(size_ctx_on_rt_on, size_ctx_off_rt_off);
}

TEST_F(BytecodeOptUnit, PackageSizeFlagDoesNotEnableNonLepusNGContext) {
  const char* code =
      "(function(){\n"
      "  var sum = 0;\n"
      "  var x0=0,x1=1,x2=2,x3=3,x4=4,x5=5,x6=6,x7=7,x8=8,x9=9;\n"
      "  for (var i = 0; i < 20; i++) { sum += x9 + x8 + x7 + x6; }\n"
      "  return sum;\n"
      "})";

  LEPUSRuntime* rt_off = LEPUS_NewRuntime();
  ASSERT_NE(rt_off, nullptr);
  LEPUS_SetOptLepusNGPackageSize(rt_off, 0);
  LEPUSContext* ctx_off = LEPUS_NewContext(rt_off);
  ASSERT_NE(ctx_off, nullptr);
  int size_non_lepusng_off =
      CompileGetBytecodeSizeWithExistingContext(ctx_off, code);
  LEPUS_FreeContext(ctx_off);
  LEPUS_FreeRuntime(rt_off);

  LEPUSRuntime* rt_on = LEPUS_NewRuntime();
  ASSERT_NE(rt_on, nullptr);
  LEPUS_SetOptLepusNGPackageSize(rt_on, 1);
  LEPUSContext* ctx_on = LEPUS_NewContext(rt_on);
  ASSERT_NE(ctx_on, nullptr);
  int size_non_lepusng_on =
      CompileGetBytecodeSizeWithExistingContext(ctx_on, code);
  LEPUS_FreeContext(ctx_on);
  LEPUS_FreeRuntime(rt_on);

  ASSERT_GT(size_non_lepusng_off, 0);
  ASSERT_GT(size_non_lepusng_on, 0);
  EXPECT_EQ(size_non_lepusng_on, size_non_lepusng_off);
}

// ==========================================================================
// Per-pass effect verification tests
// ==========================================================================

// Verify that goto chain following replaces goto→return patterns.
// We construct a function where many if-statements all branch to a common
// label that eventually reaches a return. After goto chain following,
// gotos that target a return (possibly via a chain) are replaced with
// return instructions, reducing the goto count.
TEST_F(BytecodeOptUnit, GotoChainFollow_ReducesGotoCount) {
  // A function with multiple early returns creates gotos that jump past
  // remaining code. Some of these gotos target labels that are immediately
  // followed by a return (e.g., the final return statement label), so
  // goto chain following can replace them with return instructions.
  const char* code =
      "(function(x) {\n"
      "  if (x > 10) return 1;\n"
      "  if (x > 5) return 2;\n"
      "  if (x > 0) return 3;\n"
      "  if (x > -5) return 4;\n"
      "  return 5;\n"
      "})";
  int size_on = CompileGetBytecodeSize(rt_, code, true);
  int size_off = CompileGetBytecodeSize(rt_, code, false);
  ASSERT_GT(size_on, 0);
  ASSERT_GT(size_off, 0);
  // With goto chain following + branch inversion + DCE + peephole,
  // size should be smaller or equal (never larger)
  EXPECT_LE(size_on, size_off);
}

// Verify that branch inversion reduces bytecode size.
// A common pattern "if (!cond) { ... return }" generates
// if_true + goto, which branch inversion can optimize to if_false.
TEST_F(BytecodeOptUnit, BranchInversion_ReducesSize) {
  const char* code =
      "(function(x, y) {\n"
      "  if (!x) {\n"
      "    return y;\n"
      "  }\n"
      "  return x + y;\n"
      "})";
  int size_on = CompileGetBytecodeSize(rt_, code, true);
  int size_off = CompileGetBytecodeSize(rt_, code, false);
  ASSERT_GT(size_on, 0);
  ASSERT_GT(size_off, 0);
  EXPECT_LT(size_on, size_off);
}

// Verify that dead value elimination works on short-circuit expressions
// whose result is unused. We test by checking that the optimized bytecode
// is not larger than the unoptimized version and that correctness is
// preserved.
TEST_F(BytecodeOptUnit, DeadValueElim_UnusedShortCircuit) {
  // Short-circuit expression whose result is discarded.
  // Dead value elimination should remove the value production + drop.
  const char* code =
      "(function(x) {\n"
      "  x > 0 && x < 100;  // result unused\n"
      "  return x;\n"
      "})";
  int size_on = CompileGetBytecodeSize(rt_, code, true);
  int size_off = CompileGetBytecodeSize(rt_, code, false);
  ASSERT_GT(size_on, 0);
  ASSERT_GT(size_off, 0);
  // Optimization should never increase size
  EXPECT_LE(size_on, size_off);
  // Verify correctness: short-circuit with side effects still works
  const char* code_side_effect =
      "(function(x) {\n"
      "  let y = 0;\n"
      "  (x > 0 && (y = 1));\n"  // y=1 has side effect, must not be eliminated
      "  return y;\n"
      "})(5)";
  LEPUSValue val = LEPUS_Eval(ctx_, code_side_effect, strlen(code_side_effect),
                              "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 1);  // side effect of y=1 must be preserved
}

// Verify that jump shrinking produces smaller bytecode for functions
// with many jumps. When optimization is enabled, jump_shrink reduces
// goto32 to goto16/goto8 where the offset fits in fewer bytes.
TEST_F(BytecodeOptUnit, JumpShrink_SmallerThanUnoptimized) {
  // Create a function with many short forward jumps that should benefit
  // from jump shrinking and other optimizations.
  std::string code = "(function(x) {\n";
  for (int i = 0; i < 20; i++) {
    code += "  if (x == " + std::to_string(i) + ") return " +
            std::to_string(i * 10) + ";\n";
  }
  code += "  return -1;\n})";

  int size_on = CompileGetBytecodeSize(rt_, code.c_str(), true);
  int size_off = CompileGetBytecodeSize(rt_, code.c_str(), false);
  ASSERT_GT(size_on, 0);
  ASSERT_GT(size_off, 0);
  // Optimization should never increase size
  EXPECT_LE(size_on, size_off);

  // Also verify correctness: the function returns the right value
  std::string code_call = code + "(5)";
  LEPUSValue val = LEPUS_Eval(ctx_, code_call.c_str(), code_call.size(),
                              "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 50);  // 5 * 10 = 50
}

// Verify that the optimization pipeline produces correct results
// for a function with all optimization-triggering patterns combined.
TEST_F(BytecodeOptUnit, FullPipeline_Correctness) {
  const char* code =
      "(function(n) {\n"
      "  let a = 1, b = 2, c = 3, d = 4, e = 5;\n"
      "  let f = 6, g = 7, h = 8, i = 9, j = 10;\n"
      "  if (!n) return 0;\n"
      "  if (n > 0) {\n"
      "    n > 5 && (a = a + b);\n"
      "    return a + c + e;\n"
      "  }\n"
      "  let x = f + g + h + i + j;\n"
      "  return x;\n"
      "})(3)";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // n=3>0, so return a+c+e = 1+3+5 = 9
  EXPECT_EQ(result, 9);
}

// ==========================================================================
// opt_post_peephole per-pattern tests
// ==========================================================================

// Pattern 20c: dup put_loc8(n) → set_loc8(n)
// This tests the case where a value assignment expression result is used.
// e.g., y = (x = value) generates dup + put_loc for x, leaving value for y.
// With many variables (index >= 4), put_loc8 is used.
TEST_F(BytecodeOptUnit, Peephole_DupPutLoc8_ToSetLoc8) {
  // Create many variables so that target variable uses put_loc8 (index >= 4).
  // The expression `result = (v10 = 99)` generates: push_i8(99) dup
  // put_loc8(v10) which should become: push_i8(99) set_loc8(v10) (saving 1
  // byte).
  std::string code = "(function() {\n";
  for (int i = 0; i < 20; i++) {
    code += "  let v" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  // Assignment expression where the result is used (generates dup + put_loc8)
  code += "  let result = (v10 = 99);\n";
  code += "  return result + v10;\n";
  code += "})()";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // result = 99, v10 = 99, so return 99 + 99 = 198
  EXPECT_EQ(result, 198);
}

// Pattern 20c adjacent case: dup immediately followed by put_loc8 (no NOP gap).
// This is the potentially buggy case where nr == p+1.
TEST_F(BytecodeOptUnit, Peephole_DupPutLoc8_Adjacent) {
  // Multiple chained assignment expressions force adjacent dup+put_loc8.
  std::string code = "(function() {\n";
  for (int i = 0; i < 20; i++) {
    code += "  let v" + std::to_string(i) + " = 0;\n";
  }
  // Chain: v19 = v18 = v17 = 42 generates multiple dup+put_loc8 sequences
  code += "  v19 = v18 = v17 = 42;\n";
  code += "  return v17 + v18 + v19;\n";
  code += "})()";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // All three = 42, sum = 126
  EXPECT_EQ(result, 126);
}

// Pattern 25: swap nip → drop
// swap+nip is generated in certain destructuring or comma-expression patterns.
// Verify that the optimization produces correct results.
TEST_F(BytecodeOptUnit, Peephole_SwapNip_ToDrop) {
  // Comma expression where first value is discarded can generate swap+nip.
  // The expression `(a, b)` evaluates a, then b, and discards a.
  const char* code =
      "(function() {\n"
      "  let x = 10;\n"
      "  let y = 20;\n"
      "  // Object property assignment with value discard patterns\n"
      "  let obj = {};\n"
      "  obj.a = x;\n"
      "  obj.b = y;\n"
      "  return obj.a + obj.b;\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 30);
}

// Pattern 28: undefined return → return_undef
// An explicit `return undefined` should be optimized to return_undef (1 byte
// instead of 2 bytes).
TEST_F(BytecodeOptUnit, Peephole_UndefinedReturn_ToReturnUndef) {
  const char* code =
      "(function() {\n"
      "  return undefined;\n"
      "})";
  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code, &fb));
  ASSERT_NE(fb, nullptr);

  // Should contain return_undef (combined), not separate undefined + return
  int ret_undef_count =
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_return_undef);
  // The explicit return undefined should be optimized to return_undef
  EXPECT_GT(ret_undef_count, 0)
      << "Expected return_undef after undefined+return peephole";

  // Verify correctness
  const char* code_call = "(function() { return undefined; })()";
  LEPUSValue val = LEPUS_Eval(ctx_, code_call, strlen(code_call), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  EXPECT_TRUE(LEPUS_IsUndefined(val));
  LEPUS_FreeValue(ctx_, val);
}

// Pattern 30: undefined strict_eq → is_undefined
// `x === undefined` should be folded to is_undefined(x).
TEST_F(BytecodeOptUnit, Peephole_UndefinedStrictEq_ToIsUndefined) {
  // Verify correctness for both truthy and falsy cases
  const char* code_true =
      "(function(x) {\n"
      "  return x === undefined;\n"
      "})(undefined)";
  LEPUSValue val = LEPUS_Eval(ctx_, code_true, strlen(code_true), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  EXPECT_TRUE(LEPUS_ToBool(ctx_, val));
  LEPUS_FreeValue(ctx_, val);

  const char* code_false =
      "(function(x) {\n"
      "  return x === undefined;\n"
      "})(42)";
  val = LEPUS_Eval(ctx_, code_false, strlen(code_false), "<test>",
                   LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  EXPECT_FALSE(LEPUS_ToBool(ctx_, val));
  LEPUS_FreeValue(ctx_, val);

  // null !== undefined (strict)
  const char* code_null =
      "(function(x) {\n"
      "  return x === undefined;\n"
      "})(null)";
  val = LEPUS_Eval(ctx_, code_null, strlen(code_null), "<test>",
                   LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  EXPECT_FALSE(LEPUS_ToBool(ctx_, val));
  LEPUS_FreeValue(ctx_, val);
}

// Pattern 29: null strict_eq → is_null
TEST_F(BytecodeOptUnit, Peephole_NullStrictEq_ToIsNull) {
  const char* code_true =
      "(function(x) {\n"
      "  return x === null;\n"
      "})(null)";
  LEPUSValue val = LEPUS_Eval(ctx_, code_true, strlen(code_true), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  EXPECT_TRUE(LEPUS_ToBool(ctx_, val));
  LEPUS_FreeValue(ctx_, val);

  const char* code_false =
      "(function(x) {\n"
      "  return x === null;\n"
      "})(0)";
  val = LEPUS_Eval(ctx_, code_false, strlen(code_false), "<test>",
                   LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  EXPECT_FALSE(LEPUS_ToBool(ctx_, val));
  LEPUS_FreeValue(ctx_, val);

  // undefined !== null (strict)
  const char* code_undef =
      "(function(x) {\n"
      "  return x === null;\n"
      "})(undefined)";
  val = LEPUS_Eval(ctx_, code_undef, strlen(code_undef), "<test>",
                   LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  EXPECT_FALSE(LEPUS_ToBool(ctx_, val));
  LEPUS_FreeValue(ctx_, val);
}

// Pattern 24: swap swap → nop nop (identity)
// Two consecutive swaps cancel each other out.
TEST_F(BytecodeOptUnit, Peephole_SwapSwap_Identity) {
  // Array destructuring can generate swap patterns
  const char* code =
      "(function() {\n"
      "  let a = 1, b = 2;\n"
      "  // This generates swap operations in certain bytecode patterns\n"
      "  [a, b] = [b, a];\n"
      "  return a * 10 + b;\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // a=2, b=1 after swap, return 2*10 + 1 = 21
  EXPECT_EQ(result, 21);
}

// ==========================================================================
// opt_goto_chain_follow depth boundary tests
// ==========================================================================

// Test goto chain depth=10 (maximum allowed hops).
// Create a function with deeply nested if/else that produces a long goto chain.
// The optimizer follows up to 10 hops — this should still work.
TEST_F(BytecodeOptUnit, GotoChainFollow_MaxDepth) {
  // Generate nested if/else structure that creates cascading gotos.
  // Each else branch generates a goto that targets another goto.
  std::string code = "(function(x) {\n";
  // 12 nested conditions — some gotos will chain through multiple labels
  for (int i = 0; i < 12; i++) {
    code += "  if (x == " + std::to_string(i) + ") {\n";
    code += "    return " + std::to_string(i * 100) + ";\n";
    code += "  } else ";
  }
  code += "{\n    return -1;\n  }\n";
  code += "})(5)";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 500);  // x==5, return 5*100=500
}

// Test with even deeper nesting to ensure the optimizer doesn't crash
// when the chain exceeds 10 hops (should safely bail out).
TEST_F(BytecodeOptUnit, GotoChainFollow_ExceedsMaxDepth) {
  // 20+ nested conditions — goto chains will exceed the 10-hop limit.
  // The optimizer should bail out gracefully without crash.
  std::string code = "(function(x) {\n";
  for (int i = 0; i < 20; i++) {
    code += "  if (x == " + std::to_string(i) + ") {\n";
    code += "    return " + std::to_string(i) + ";\n";
    code += "  } else ";
  }
  code += "{\n    return -1;\n  }\n";
  code += "})(15)";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 15);
}

// Verify goto chain following with a loop-break pattern that creates
// goto→goto chains (break inside nested loops).
TEST_F(BytecodeOptUnit, GotoChainFollow_NestedBreak) {
  const char* code =
      "(function() {\n"
      "  let result = 0;\n"
      "  outer: for (let i = 0; i < 10; i++) {\n"
      "    for (let j = 0; j < 10; j++) {\n"
      "      if (j == 5) break outer;\n"
      "      result += 1;\n"
      "    }\n"
      "  }\n"
      "  return result;\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // i=0, j=0..4 → 5 iterations before break
  EXPECT_EQ(result, 5);
}

// ==========================================================================
// opt_branch_inversion 8-bit offset overflow tests
// ==========================================================================

// When branch inversion tries to use an 8-bit if instruction to target
// a label that is >127 bytes away, it must bail out (the offset doesn't fit).
// Verify correctness when the branch target is far away.
TEST_F(BytecodeOptUnit, BranchInversion_LargeOffset_Correctness) {
  // Generate a function where `if (!cond) { large_block }` has a large
  // true-branch body (>127 bytes). The optimizer should either use a wider
  // branch or correctly bail out of 8-bit inversion.
  std::string code = "(function(x) {\n";
  code += "  if (!x) {\n";
  // Generate a large block (>127 bytes of bytecode)
  for (int i = 0; i < 50; i++) {
    code += "    let v" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  code += "    return -1;\n";
  code += "  }\n";
  code += "  return 42;\n";
  code += "})(1)";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // x=1 (truthy), so !x is false, skip the block, return 42
  EXPECT_EQ(result, 42);
}

// Same test but taking the branch (x=0, falsy)
TEST_F(BytecodeOptUnit, BranchInversion_LargeOffset_TakesBranch) {
  std::string code = "(function(x) {\n";
  code += "  if (!x) {\n";
  for (int i = 0; i < 50; i++) {
    code += "    let v" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  // Use the last variable to ensure it's not all dead code
  code += "    return v49;\n";
  code += "  }\n";
  code += "  return 0;\n";
  code += "})(0)";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // x=0 (falsy), !x is true, enter block, return v49=49
  EXPECT_EQ(result, 49);
}

// Test branch inversion with multiple negated conditions and large offsets.
// This stresses the interaction between lnot+if inversion and jump-slot
// retargeting when some inversions succeed and others must bail out.
TEST_F(BytecodeOptUnit, BranchInversion_MixedOffsets) {
  std::string code = "(function(a, b, c) {\n";
  code += "  let sum = 0;\n";
  // Short branch (should invert successfully)
  code += "  if (!a) { sum += 1; }\n";
  // Long branch (>127 bytes, 8-bit inversion must bail)
  code += "  if (!b) {\n";
  for (int i = 0; i < 40; i++) {
    code += "    sum += " + std::to_string(i + 1) + ";\n";
  }
  code += "  }\n";
  // Short branch again
  code += "  if (!c) { sum += 1000; }\n";
  code += "  return sum;\n";
  code += "})(1, 1, 0)";  // a=truthy, b=truthy, c=falsy

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // a=1 (truthy): skip first if (!a)
  // b=1 (truthy): skip second if (!b)
  // c=0 (falsy): enter if (!c), sum += 1000
  EXPECT_EQ(result, 1000);
}

// ==========================================================================
// opt_dead_value_elim fall-through boundary tests
// ==========================================================================

// Test dead value elimination where a live label exists immediately before
// the target drop label. The optimizer must not eliminate the drop if there
// is potential fall-through from code reached via the live label.
TEST_F(BytecodeOptUnit, DeadValueElim_LiveLabelBeforeDrop) {
  // Pattern: goto(L1); L2: <code>; L1: drop
  // If L2 has live references and falls through to L1, the drop at L1
  // cannot be eliminated because L2's code may leave a value on stack.
  const char* code =
      "(function(x) {\n"
      "  let result;\n"
      "  // The || operator generates: dup if_true(L) drop <rhs> L: ...\n"
      "  // If there's a fall-through from another label before L,\n"
      "  // the drop must be preserved.\n"
      "  result = x || 'default';\n"
      "  return result;\n"
      "})(0)";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  const char* str = LEPUS_ToCString(ctx_, val);
  ASSERT_NE(str, nullptr);
  EXPECT_STREQ(str, "default");  // x=0 is falsy, so || returns 'default'
  LEPUS_FreeCString(ctx_, str);
  LEPUS_FreeValue(ctx_, val);
}

// Test with multiple short-circuit expressions that share labels.
TEST_F(BytecodeOptUnit, DeadValueElim_MultipleShortCircuit) {
  const char* code =
      "(function(a, b, c) {\n"
      "  let r1 = a || 'A';\n"
      "  let r2 = b && 'B';\n"
      "  let r3 = c || (a && 'C');\n"
      "  return r1 + r2 + r3;\n"
      "})('x', 'y', '')";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  const char* str = LEPUS_ToCString(ctx_, val);
  ASSERT_NE(str, nullptr);
  // r1 = 'x' (truthy, short-circuits)
  // r2 = 'B' (b='y' truthy, so evaluate and return 'B')
  // r3 = c='' falsy, so evaluate a && 'C' → a='x' truthy → 'C'
  EXPECT_STREQ(str, "xBC");
  LEPUS_FreeCString(ctx_, str);
  LEPUS_FreeValue(ctx_, val);
}

// Test dead value elimination with unused short-circuit in a loop.
// The loop creates backward labels that interact with the drop labels.
TEST_F(BytecodeOptUnit, DeadValueElim_ShortCircuitInLoop) {
  const char* code =
      "(function() {\n"
      "  let count = 0;\n"
      "  for (let i = 0; i < 10; i++) {\n"
      "    i > 3 && i < 7;  // unused short-circuit, result dropped\n"
      "    count++;\n"
      "  }\n"
      "  return count;\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 10);
}

// Test that dead value elimination preserves side effects.
// The optimizer must not eliminate value-producing code that has side effects.
TEST_F(BytecodeOptUnit, DeadValueElim_PreservesSideEffects) {
  const char* code =
      "(function() {\n"
      "  let x = 0;\n"
      "  // The assignment (x = 5) has a side effect\n"
      "  true && (x = 5);  // result unused but side effect must execute\n"
      "  return x;\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 5);  // side effect preserved
}

// ==========================================================================
// Edge case: all passes handle minimal/unusual input safely
// ==========================================================================

// Test that a function with only a return statement compiles correctly.
TEST_F(BytecodeOptUnit, EdgeCase_OnlyReturn) {
  const char* code = "(function() { return 77; })()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 77);
}

// Test a function that only throws (no normal return path).
TEST_F(BytecodeOptUnit, EdgeCase_OnlyThrow) {
  const char* code =
      "(function() {\n"
      "  try {\n"
      "    (function() { throw 42; })();\n"
      "  } catch(e) {\n"
      "    return e;\n"
      "  }\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 42);
}

// Test a function with a single variable and no reads (pure dead store).
// All passes should handle this without crash.
TEST_F(BytecodeOptUnit, EdgeCase_DeadStoreOnly) {
  const char* code =
      "(function() {\n"
      "  let x = 42;\n"
      "  // x is never read — pure dead store\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  EXPECT_TRUE(LEPUS_IsUndefined(val));
  LEPUS_FreeValue(ctx_, val);
}

// Test an immediately-invoked arrow function (different function structure).
TEST_F(BytecodeOptUnit, EdgeCase_ArrowFunction) {
  const char* code =
      "((x) => {\n"
      "  let a = x * 2;\n"
      "  let b = a + 1;\n"
      "  return b;\n"
      "})(10)";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 21);
}

// Test a generator-like pattern with many yield points (try/finally).
// This creates complex control flow with many labels and goto chains.
TEST_F(BytecodeOptUnit, EdgeCase_TryFinallyComplex) {
  const char* code =
      "(function() {\n"
      "  let log = 0;\n"
      "  try {\n"
      "    log += 1;\n"
      "    try {\n"
      "      log += 2;\n"
      "      return log;\n"
      "    } finally {\n"
      "      log += 4;\n"
      "    }\n"
      "  } finally {\n"
      "    log += 8;\n"
      "  }\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // return captures log=3, but finally blocks still execute (modifying log).
  // The return value is captured before finally runs, so result = 1+2 = 3
  EXPECT_EQ(result, 3);
}

// Test with many arguments (argument variable reordering).
TEST_F(BytecodeOptUnit, EdgeCase_ManyArguments) {
  std::string code = "(function(";
  for (int i = 0; i < 20; i++) {
    if (i > 0) code += ", ";
    code += "a" + std::to_string(i);
  }
  code += ") {\n";
  code += "  let sum = 0;\n";
  // Access some arguments frequently
  for (int i = 0; i < 30; i++) {
    code += "  sum += a19;\n";
  }
  code += "  return sum;\n";
  code += "})(";
  for (int i = 0; i < 20; i++) {
    if (i > 0) code += ", ";
    code += std::to_string(i);
  }
  code += ")";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // a19 = 19, accessed 30 times, sum = 19*30 = 570
  EXPECT_EQ(result, 570);
}

// Test a function with zero variables but many constants (cpool-only).
TEST_F(BytecodeOptUnit, EdgeCase_NoVarsManyCpool) {
  std::string code = "(function() {\n  return ";
  // Build a long expression with many unique constants
  for (int i = 0; i < 50; i++) {
    if (i > 0) code += " + ";
    code += std::to_string(i * 3 + 1) + ".5";
  }
  code += ";\n})()";

  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  double result = 0;
  LEPUS_ToFloat64(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // Sum of (3i+1.5) for i=0..49 = sum(3i+1) + 50*0.5
  // = 3*(0+1+...+49) + 50 + 25 = 3*1225 + 75 = 3675 + 75 = 3750
  double expected = 0;
  for (int i = 0; i < 50; i++) expected += i * 3 + 1.5;
  EXPECT_DOUBLE_EQ(result, expected);
}

// ==========================================================================
// Peephole pattern: put_loc(n) + get_loc(n) → set_loc(n) across NOP gaps
// ==========================================================================

// Test that put_loc + get_loc (same index) across NOP gaps is correctly
// merged into set_loc, preserving the value on stack.
TEST_F(BytecodeOptUnit, Peephole_PutLocGetLoc_ToSetLoc) {
  // A pattern like: x = expr; use(x) — where x is stored then immediately
  // loaded — should be optimized to set_loc (store + keep on stack).
  const char* code =
      "(function() {\n"
      "  let a = 0, b = 0, c = 0, d = 0, e = 0;\n"  // 5 vars for loc8
      "  let x = 0;\n"
      "  // Assign then immediately use: put_loc(x) + get_loc(x) → set_loc(x)\n"
      "  x = 100;\n"
      "  return x + 1;\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 101);
}

// ==========================================================================
// Peephole pattern: dup get_field → get_field2
// ==========================================================================

// Test that dup + get_field is merged to get_field2.
// This pattern appears in method calls: obj.method() → dup get_field("method")
TEST_F(BytecodeOptUnit, Peephole_DupGetField_ToGetField2) {
  const char* code =
      "(function() {\n"
      "  let obj = { value: 42, get: function() { return this.value; } };\n"
      "  return obj.get();\n"
      "})()";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 42);
}

// ==========================================================================
// opt_reorder_closure_vars tests
// ==========================================================================

// Verify that hot closure variables get short-form opcodes (get_var_ref0..3).
TEST_F(BytecodeOptUnit, ReorderClosureVars_HotVarsGetLowIndices) {
  // Outer function declares 20 closure vars using 'var' (no TDZ check);
  // inner function heavily uses c19 so reorder should put it at index 0.
  std::string code = "(function() {\n";
  for (int i = 0; i < 20; i++) {
    code += "  var c" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  // Inner function: access c19 many times (hottest), c18 a few times
  code += "  return function() {\n";
  code += "    var sum = 0;\n";
  for (int i = 0; i < 30; i++) {
    code += "    sum += c19;\n";
  }
  for (int i = 0; i < 5; i++) {
    code += "    sum += c18;\n";
  }
  code += "    sum += c0;\n";
  code += "    return sum;\n";
  code += "  };\n";
  code += "})()";

  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code, &fb));
  ASSERT_NE(fb, nullptr);

  // After reorder, c19 (hottest) should be remapped to index 0,
  // so get_var_ref0 should appear frequently.
  int short_count = 0;
  short_count +=
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_get_var_ref0);
  short_count +=
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_get_var_ref1);
  // With 30 accesses to c19, most should use short-form
  EXPECT_GE(short_count, 25);
}

// Verify that closure variable reordering preserves execution correctness.
TEST_F(BytecodeOptUnit, ReorderClosureVars_Correctness) {
  std::string code = "(function() {\n";
  for (int i = 0; i < 20; i++) {
    code += "  let c" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  // Inner function reads from multiple closure vars with varying frequencies
  code += "  let inner = function() {\n";
  code += "    let sum = 0;\n";
  // c19 is hottest
  for (int i = 0; i < 10; i++) {
    code += "    sum += c19;\n";
  }
  // c5 accessed a few times
  for (int i = 0; i < 3; i++) {
    code += "    sum += c5;\n";
  }
  code += "    sum += c0 + c10;\n";
  code += "    return sum;\n";
  code += "  };\n";
  code += "  return inner();\n";
  code += "})()";

  // Expected: 10*19 + 3*5 + 0 + 10 = 190 + 15 + 10 = 215
  LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<test>",
                              LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 215);
}

// Verify TDZ semantics are preserved after closure variable reordering.
TEST_F(BytecodeOptUnit, ReorderClosureVars_TDZPreserved) {
  // Access a let-declared closure var before initialization
  const char* code =
      "(function() {\n"
      "  let c0 = 0, c1 = 1, c2 = 2, c3 = 3, c4 = 4;\n"
      "  let c5 = 5, c6 = 6, c7 = 7, c8 = 8, c9 = 9;\n"
      "  let inner = function() {\n"
      "    // Access c9 many times to make it hot\n"
      "    let s = c9 + c9 + c9 + c9 + c9;\n"
      "    // Access tdz_var before it's initialized in outer scope\n"
      "    try { return tdz_var; } catch(e) { return -1; }\n"
      "  };\n"
      "  let caught = inner();\n"
      "  let tdz_var = 999;\n"
      "  return caught;\n"
      "})()";

  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // TDZ violation should be caught, returning -1
  EXPECT_EQ(result, -1);
}

// A/B comparison: closure variable reordering should reduce bytecode size.
// Note: CompileGetBytecodeSize returns the outermost function bytecode size,
// so we structure the test with all closure accesses in the outer function
// itself.
TEST_F(BytecodeOptUnit, ReorderClosureVars_ABCompare) {
  // Use eval-style: a function that creates closure vars captured by a nested
  // arrow, but the hot accesses are in the outer function body itself via the
  // inner call. Instead, use a flat pattern: outer creates vars, returns inner
  // which accesses them. We compare inner function sizes directly by getting
  // the returned function.
  std::string code = "(function() {\n";
  for (int i = 0; i < 20; i++) {
    code += "  var c" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  code += "  return function() {\n";
  code += "    var sum = 0;\n";
  // Hot access to high-index vars — reordering should convert to short opcodes
  for (int i = 0; i < 20; i++) {
    code += "    sum += c19 + c18 + c17;\n";
  }
  code += "    return sum;\n";
  code += "  };\n";
  code += "})";

  // Compare the outer function bytecode size (which includes inner function
  // code in cpool)
  int size_on = CompileGetBytecodeSize(rt_, code.c_str(), true);
  int size_off = CompileGetBytecodeSize(rt_, code.c_str(), false);
  ASSERT_GT(size_on, 0);
  ASSERT_GT(size_off, 0);
  // Reordering high-index vars to short opcodes saves bytes in the inner
  // function
  EXPECT_LE(size_on, size_off);
}

// ==========================================================================
// opt_prescan_tdz_dse tests
// ==========================================================================

// Verify TDZ check downgrade works for variables provably initialized.
// The prescan identifies variables with only one set_loc_uninitialized that
// are written before the first backward label; subsequent reads can skip TDZ
// check.
TEST_F(BytecodeOptUnit, PrescanTDZ_DeadSLUAfterUnconditionalWrite) {
  // Function with multiple let vars, some provably initialized in straight-line
  // code. Compare TDZ check counts: with optimization, some checks should be
  // eliminated.
  const char* code_on =
      "(function(a) {\n"
      "  let x = a + 1;\n"
      "  let y = x + 2;\n"
      "  return y;\n"
      "})";

  // Compile with optimization ON
  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code_on, &fb));
  ASSERT_NE(fb, nullptr);
  int check_count_on =
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_get_loc_check);

  // Compile same code with optimization OFF
  LEPUS_SetOptLepusNGPackageSize(rt_, 0);
  LEPUSContext* ctx_off = LEPUS_NewContext(rt_);
  ASSERT_NE(ctx_off, nullptr);
  LEPUSValue val_off = LEPUS_Eval(ctx_off, code_on, strlen(code_on), "<test>",
                                  LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val_off));
  ASSERT_TRUE(LEPUS_IsFunction(ctx_off, val_off));
  LEPUSObject* obj_off = LEPUS_VALUE_GET_OBJ(val_off);
  LEPUSFunctionBytecode* fb_off = obj_off->u.func.function_bytecode;
  int check_count_off = CountOpcode(fb_off->byte_code_buf,
                                    fb_off->byte_code_len, OP_get_loc_check);
  LEPUS_FreeValue(ctx_off, val_off);
  LEPUS_FreeContext(ctx_off);
  LEPUS_SetOptLepusNGPackageSize(rt_, 1);

  // Optimization should reduce (or not increase) get_loc_check count
  EXPECT_LE(check_count_on, check_count_off);
}

// Verify TDZ is preserved when variable may be accessed before initialization.
// The conditional early return can read x before the let initializer executes.
TEST_F(BytecodeOptUnit, PrescanTDZ_PreserveSLUWhenConditionalWrite) {
  const char* code =
      "(function(cond) {\n"
      "  if (cond) return x;\n"
      "  let x = 1;\n"
      "  return x;\n"
      "})";
  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code, &fb));
  ASSERT_NE(fb, nullptr);

  // x is read (return x) before its let declaration may execute when cond=true,
  // so TDZ enforcement must be preserved.
  int slu_count = CountOpcode(fb->byte_code_buf, fb->byte_code_len,
                              OP_set_loc_uninitialized);
  int check_count =
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_get_loc_check);
  int put_check_count =
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_put_loc_check);
  int put_check_init_count =
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_put_loc_check_init);
  // At least one TDZ-related instruction should remain
  EXPECT_GT(slu_count + check_count + put_check_count + put_check_init_count,
            0);
}

// Verify that dead variables (never read) are detected by prescan and
// reordered to high indices, allowing live hot vars to use short opcodes.
TEST_F(BytecodeOptUnit, PrescanTDZ_DeadVarNeverRead_ABCompare) {
  // 20 dead variables + hot live variable. With var_is_read info,
  // reorder should push dead vars to high indices and hot vars to low.
  std::string code = "(function() {\n";
  // Hot variable used many times
  code += "  var used = 0;\n";
  // Dead variables only written, never read
  for (int i = 0; i < 20; i++) {
    code +=
        "  var dead" + std::to_string(i) + " = " + std::to_string(i) + ";\n";
  }
  // Make 'used' hot
  for (int i = 0; i < 30; i++) {
    code += "  used += 1;\n";
  }
  code += "  return used;\n";
  code += "})";

  int size_on = CompileGetBytecodeSize(rt_, code.c_str(), true);
  int size_off = CompileGetBytecodeSize(rt_, code.c_str(), false);
  ASSERT_GT(size_on, 0);
  ASSERT_GT(size_off, 0);
  // With optimization, 'used' gets a low index (short opcode),
  // resulting in smaller bytecode than unoptimized
  EXPECT_LE(size_on, size_off);
}

// ==========================================================================
// opt_final_dce (P10) — dedicated unit tests
//
// opt_final_dce is the last label-stable post-pass. It combines:
//   - Unreachable code elimination (after return/throw/goto until next label)
//   - goto→return chain collapsing
//   - undefined + return → return_undef folding
//   - set_xxx + drop → put_xxx conversion
//   - pure_op + drop → NOP (dead value elimination)
//   - Redundant load elimination (put_xxx + get_xxx → dup + put_xxx)
// ==========================================================================

// Verify that code after an unconditional return is eliminated.
TEST_F(BytecodeOptUnit, FinalDCE_UnreachableAfterReturn) {
  const char* code =
      "(function(x) {\n"
      "  return x + 1;\n"
      "  let a = 10, b = 20, c = 30;\n"
      "  return a + b + c;\n"
      "})";
  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code, &fb));
  ASSERT_NE(fb, nullptr);

  // After DCE + nop_strip, no NOPs should remain (dead code fully removed)
  int nop_count = CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_nop);
  EXPECT_EQ(nop_count, 0);

  // Should have exactly one return (the live one)
  int ret_count = CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_return);
  EXPECT_EQ(ret_count, 1);
}

// Verify that code after throw is eliminated.
// NOTE: The basic dead-code-after-terminator removal is done at emit time
// (Phase 2 skip_dead_code), so opt_final_dce may not further reduce size.
// We verify the optimization pipeline as a whole produces compact bytecode.
TEST_F(BytecodeOptUnit, FinalDCE_UnreachableAfterThrow) {
  const char* code =
      "(function() {\n"
      "  throw new Error('x');\n"
      "  let a = 1, b = 2, c = 3, d = 4, e = 5;\n"
      "  return a + b + c + d + e;\n"
      "})";

  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code, &fb));
  ASSERT_NE(fb, nullptr);

  // After dead code removal (emit-time + DCE), no NOPs should remain
  int nop_count = CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_nop);
  EXPECT_EQ(nop_count, 0);

  // The dead return after throw should not appear in final bytecode
  int ret_count = CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_return);
  EXPECT_EQ(ret_count, 0);
}

void CheckFinalDCEClearsDeadJumpSlot(LEPUSContext* ctx, uint8_t dead_op,
                                     int jump_pos_offset, JSAtom atom) {
  ASSERT_TRUE(dead_op == OP_with_get_var || dead_op == OP_goto);

  JSFunctionDef fd = {};
  DynBuf bc_out;
  dbuf_init2(&bc_out, ctx->rt,
             reinterpret_cast<DynBufReallocFunc*>(lepus_dbuf_realloc_rt));

  // Bytecode layout for OP_with_get_var:
  //   0:  return_undef
  //   1:  with_get_var atom, label, is_with   (dead, owns jump slot)
  //   11: label target
  //   11: push_1
  //
  // Bytecode layout for OP_goto:
  //   0:  return_undef
  //   1:  goto label                         (dead, owns jump slot)
  //   6:  label target
  //   6:  push_1
  dbuf_putc(&bc_out, OP_return_undef);
  int dead_pos = bc_out.size;
  dbuf_putc(&bc_out, dead_op);
  if (dead_op == OP_with_get_var) {
    dbuf_put_u32(&bc_out, atom);
    dbuf_put_u32(&bc_out, 11 - (dead_pos + jump_pos_offset));
    dbuf_putc(&bc_out, 0);
  } else {
    dbuf_put_u32(&bc_out, 6 - (dead_pos + jump_pos_offset));
  }
  int label_addr = bc_out.size;
  dbuf_putc(&bc_out, OP_push_1);

  LabelSlot label_slot = {};
  label_slot.addr = label_addr;
  label_slot.ref_count = 1;
  JumpSlot jump_slot = {};
  jump_slot.op = dead_op;
  jump_slot.size = 4;
  jump_slot.pos = dead_pos + jump_pos_offset;
  jump_slot.label = 0;

  fd.ctx = ctx;
  fd.label_slots = &label_slot;
  fd.label_count = 1;
  fd.jump_slots = &jump_slot;
  fd.jump_count = 1;

  opt_final_dce(ctx, &fd, &bc_out);

  EXPECT_EQ(jump_slot.size, 0);
  EXPECT_EQ(jump_slot.op, OP_nop);
  EXPECT_EQ(jump_slot.pos, -1);
  EXPECT_EQ(label_slot.ref_count, 0);

  opt_nop_strip(ctx, &fd, &bc_out);

  ASSERT_EQ(bc_out.size, 2u);
  EXPECT_EQ(bc_out.buf[0], OP_return_undef);
  EXPECT_EQ(bc_out.buf[1], OP_push_1);

  dbuf_free(&bc_out);
}

// Regression test: unreachable atom_label_u8 instructions such as
// OP_with_get_var also own a JumpSlot at q + 5. When the instruction is NOPed,
// that JumpSlot must be cleared before opt_nop_strip rewrites jump offsets.
TEST_F(BytecodeOptUnit, FinalDCE_UnreachableWithOpcodeClearsJumpSlot) {
  JSAtom atom = LEPUS_NewAtom(ctx_, "dead_with_name");
  ASSERT_NE(atom, JS_ATOM_NULL);
  if (!ctx_->gc_enable) LEPUS_DupAtom(ctx_, atom);

  CheckFinalDCEClearsDeadJumpSlot(ctx_, OP_with_get_var, 5, atom);

  if (!ctx_->gc_enable) LEPUS_FreeAtom(ctx_, atom);
}

// Verify the same fast jump-slot lookup path preserves the old behavior for
// ordinary unreachable goto instructions whose jump operand is at q + 1.
TEST_F(BytecodeOptUnit, FinalDCE_UnreachableGotoClearsJumpSlot) {
  CheckFinalDCEClearsDeadJumpSlot(ctx_, OP_goto, 1, JS_ATOM_NULL);
}

// Verify goto→return chain collapsing: when a goto targets a label whose
// first live instruction is return, the goto is replaced with return directly.
TEST_F(BytecodeOptUnit, FinalDCE_GotoToReturn) {
  // Multiple if-else branches all eventually reach the final return.
  // Without optimization: goto → label → return_undef
  // With optimization: direct return_undef (fewer gotos)
  const char* code =
      "(function(x) {\n"
      "  if (x > 10) { let a = 1; }\n"
      "  else if (x > 5) { let b = 2; }\n"
      "  else if (x > 0) { let c = 3; }\n"
      "  else { let d = 4; }\n"
      "})";

  LEPUSFunctionBytecode* fb = nullptr;
  ASSERT_TRUE(CompileFunction(code, &fb));
  ASSERT_NE(fb, nullptr);

  // After goto→return, return_undef count should increase (gotos replaced)
  int ret_undef_count =
      CountOpcode(fb->byte_code_buf, fb->byte_code_len, OP_return_undef);
  // At least 2 return_undef: some gotos should have been collapsed to return
  EXPECT_GE(ret_undef_count, 2);
}

// Verify dce_undefined_return: when the optimizer produces OP_undefined
// followed by OP_return (e.g., from dead code removal between them), it
// folds to OP_return_undef. Since `return undefined;` compiles as
// `get_var("undefined") + return` (not OP_undefined + return), we test
// indirectly: an implicit-return function should use return_undef, and
// a function with multiple branches ending in implicit return should have
// multiple return_undef after goto→return folding (which also applies
// dce_undefined_return).
TEST_F(BytecodeOptUnit, FinalDCE_UndefinedReturn_ToReturnUndef) {
  // An empty function should use return_undef (not undefined + return)
  const char* code1 = "(function() {})";
  LEPUSFunctionBytecode* fb1 = nullptr;
  ASSERT_TRUE(CompileFunction(code1, &fb1));
  ASSERT_NE(fb1, nullptr);

  int ret_undef =
      CountOpcode(fb1->byte_code_buf, fb1->byte_code_len, OP_return_undef);
  EXPECT_GE(ret_undef, 1);

  // A function with explicit `return;` (no value) also uses return_undef
  const char* code2 = "(function(x) { if (x) return; return; })";
  LEPUSFunctionBytecode* fb2 = nullptr;
  ASSERT_TRUE(CompileFunction(code2, &fb2));
  ASSERT_NE(fb2, nullptr);

  int ret_undef2 =
      CountOpcode(fb2->byte_code_buf, fb2->byte_code_len, OP_return_undef);
  EXPECT_GE(ret_undef2, 2);

  // Should NOT contain OP_undefined (would indicate missed folding)
  int undef_count =
      CountOpcode(fb2->byte_code_buf, fb2->byte_code_len, OP_undefined);
  EXPECT_EQ(undef_count, 0);
}

// Verify redundant load elimination: put_loc(X) + get_loc(X) → dup +
// put_loc(X). For `let` variables, the compiler emits `dup + put_loc_check +
// drop` for assignments in statement context. With `var` variables (no TDZ
// check), the compiler can generate simpler put_loc patterns that DCE can
// optimize. We verify via A/B size comparison that optimization reduces
// bytecode.
TEST_F(BytecodeOptUnit, FinalDCE_RedundantLoadElim) {
  // var variables avoid TDZ checks, allowing put_loc + get_loc patterns
  // that DCE can optimize to dup + put_loc.
  const char* code =
      "(function() {\n"
      "  var x = 0;\n"
      "  x = 1; var a = x;\n"  // put_loc(x) + get_loc(x) → dup + put_loc(x)
      "  x = 2; var b = x;\n"
      "  x = 3; var c = x;\n"
      "  x = 4; var d = x;\n"
      "  return a + b + c + d;\n"
      "})";

  int size_on = CompileGetBytecodeSize(rt_, code, true);
  int size_off = CompileGetBytecodeSize(rt_, code, false);
  ASSERT_GT(size_on, 0);
  ASSERT_GT(size_off, 0);
  // Optimization should produce same or smaller bytecode
  EXPECT_LE(size_on, size_off);
}

// Verify pure_op + drop elimination: the optimizer pipeline (including
// opt_final_dce and opt_dead_value_elim) should eliminate dead values.
// NOTE: Simple `42;` expressions are already optimized at emit time.
// We test with patterns where earlier passes create dead value opportunities
// that opt_final_dce then cleans up (e.g., unused short-circuit results).
TEST_F(BytecodeOptUnit, FinalDCE_PureOpDrop_Eliminated) {
  // Short-circuit expressions whose results are unused: `a && b;`
  // generates compare+branch+push patterns. When the result is dropped,
  // the optimizer should eliminate unnecessary stack operations.
  const char* code =
      "(function(a, b) {\n"
      "  a > 0 && b > 0;\n"  // unused short-circuit result → dead value
      "  a > 1 && b > 1;\n"
      "  a > 2 && b > 2;\n"
      "  a > 3 && b > 3;\n"
      "  a > 4 && b > 4;\n"
      "  return a + b;\n"
      "})";

  int size_on = CompileGetBytecodeSize(rt_, code, true);
  int size_off = CompileGetBytecodeSize(rt_, code, false);
  ASSERT_GT(size_on, 0);
  ASSERT_GT(size_off, 0);
  // Dead value elimination should reduce bytecode size for these patterns
  EXPECT_LE(size_on, size_off);
}

// Verify that instructions at label targets are NOT eliminated, even if they
// appear to be dead in a linear scan. Labels may be jump targets from branches.
TEST_F(BytecodeOptUnit, FinalDCE_LabelTargetPreserved) {
  // The else branch is a label target — it must not be eliminated.
  // We verify correctness by executing the function.
  const char* code =
      "(function(x) {\n"
      "  let result = 0;\n"
      "  if (x > 0) {\n"
      "    result = 100;\n"
      "  } else {\n"
      "    result = 200;\n"  // This is a label target — must survive DCE
      "  }\n"
      "  return result;\n"
      "})";

  // Test both branches to verify label targets preserved
  std::string code_true = std::string(code) + "(5)";
  std::string code_false = std::string(code) + "(-5)";

  LEPUSValue val1 = LEPUS_Eval(ctx_, code_true.c_str(), code_true.size(),
                               "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val1));
  int32_t r1 = 0;
  LEPUS_ToInt32(ctx_, &r1, val1);
  LEPUS_FreeValue(ctx_, val1);
  EXPECT_EQ(r1, 100);

  LEPUSValue val2 = LEPUS_Eval(ctx_, code_false.c_str(), code_false.size(),
                               "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val2));
  int32_t r2 = 0;
  LEPUS_ToInt32(ctx_, &r2, val2);
  LEPUS_FreeValue(ctx_, val2);
  EXPECT_EQ(r2, 200);
}

// Regression test for dce_peephole set+drop→put optimization:
// Verify that the optimizer does NOT skip over label targets when looking for
// the drop after a set_xxx instruction. If labels between set and drop are
// improperly skipped, stack imbalance would cause wrong results.
TEST_F(BytecodeOptUnit, FinalDCE_SetDropAcrossLabel_LoopCorrectness) {
  // A for-loop creates backward labels in the loop body.
  // Assignments (set_loc + drop) coexist with these labels.
  // If dce_peephole incorrectly removes a drop across a label boundary,
  // execution from the label path would have extra stack values.
  const char* code =
      "(function(n) {\n"
      "  var sum = 0;\n"
      "  var last = 0;\n"
      "  for (var i = 0; i < n; i++) {\n"
      "    last = i;\n"       // set_loc + drop, loop labels nearby
      "    sum = sum + i;\n"  // set_loc + drop
      "  }\n"
      "  return sum * 100 + last;\n"
      "})(10)";

  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // sum = 0+1+...+9 = 45, last = 9 → 45*100+9 = 4509
  EXPECT_EQ(result, 4509);
}

// Regression test: set+drop with if-else branch join labels.
// The join point after if-else is a label target; assignments in each branch
// generate set_loc+drop patterns adjacent to that label.
TEST_F(BytecodeOptUnit, FinalDCE_SetDropAcrossLabel_BranchCorrectness) {
  const char* code =
      "(function(x) {\n"
      "  var a = 0, b = 0, c = 0;\n"
      "  if (x > 5) {\n"
      "    a = x * 2;\n"  // set_loc + drop, else-label nearby
      "    b = x + 1;\n"
      "  } else {\n"
      "    a = x * 3;\n"  // set_loc + drop, join-label nearby
      "    b = x - 1;\n"
      "  }\n"
      "  c = a + b;\n"  // set_loc + drop at join point
      "  return c;\n"
      "})(7)";

  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // x=7: a=14, b=8, c=22
  EXPECT_EQ(result, 22);
}

// Regression test: nested loops with assignments across multiple label targets.
// This exercises dce_peephole and pure_op+drop elimination in the presence of
// multiple interleaved labels from nested control flow.
TEST_F(BytecodeOptUnit, FinalDCE_SetDropAcrossLabel_NestedLoops) {
  const char* code =
      "(function(m, n) {\n"
      "  var total = 0;\n"
      "  for (var i = 0; i < m; i++) {\n"
      "    var row = 0;\n"
      "    for (var j = 0; j < n; j++) {\n"
      "      row = row + j;\n"  // set+drop in inner loop
      "    }\n"
      "    total = total + row;\n"  // set+drop between inner/outer loop labels
      "  }\n"
      "  return total;\n"
      "})(4, 5)";

  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  // inner loop: row = 0+1+2+3+4 = 10 for each outer iteration
  // total = 10*4 = 40
  EXPECT_EQ(result, 40);
}

// ==========================================================================
// Interaction test: all optimizations combined with complex patterns
// ==========================================================================

// Test combining dead value elim + branch inversion + goto chain + peephole
// in a single function with real-world patterns.
TEST_F(BytecodeOptUnit, Combined_AllPassesInteraction) {
  const char* code =
      "(function(obj) {\n"
      "  let result = 0;\n"
      "  // Branch inversion: if (!obj) ...\n"
      "  if (!obj) return -1;\n"
      "  // Dead value: unused short-circuit\n"
      "  obj.x > 0 && obj.x < 100;\n"
      "  // Goto chain: nested early returns\n"
      "  if (obj.x === undefined) return -2;\n"
      "  if (obj.x === null) return -3;\n"
      "  // Peephole: undefined/null strict_eq → is_undefined/is_null\n"
      "  result = obj.x;\n"
      "  // Dead code after return\n"
      "  return result;\n"
      "  result = 999;\n"
      "})({x: 55})";
  LEPUSValue val =
      LEPUS_Eval(ctx_, code, strlen(code), "<test>", LEPUS_EVAL_TYPE_GLOBAL);
  ASSERT_FALSE(LEPUS_IsException(val));
  int32_t result = 0;
  LEPUS_ToInt32(ctx_, &result, val);
  LEPUS_FreeValue(ctx_, val);
  EXPECT_EQ(result, 55);
}

}  // namespace
