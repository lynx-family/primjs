// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <climits>
#include <sstream>
#include <string>

#include "gtest/gtest.h"
#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif

// Stress tests for bytecode optimization passes.
// Each test generates JS code that exercises edge cases in the optimizer,
// compiles and executes it, then verifies correctness.

class BytecodeOptStress : public ::testing::Test {
 protected:
  void SetUp() override {
    rt_ = LEPUS_NewRuntime();
    LEPUS_SetRuntimeInfo(rt_, "Lynx_LepusNG");
    LEPUS_SetOptLepusNGPackageSize(rt_, 1);
    ctx_ = LEPUS_NewContext(rt_);
  }

  void TearDown() override {
    LEPUS_FreeContext(ctx_);
    LEPUS_FreeRuntime(rt_);
  }

  // Evaluate JS code and return integer result (or INT_MIN on error)
  int EvalInt(const std::string& code) {
    LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<stress>",
                                LEPUS_EVAL_TYPE_GLOBAL);
    if (LEPUS_IsException(val)) {
      LEPUS_FreeValue(ctx_, LEPUS_GetException(ctx_));
      return INT_MIN;
    }
    int result = 0;
    LEPUS_ToInt32(ctx_, &result, val);
    LEPUS_FreeValue(ctx_, val);
    return result;
  }

  // Evaluate JS code and expect no crash (result doesn't matter)
  bool EvalNoThrow(const std::string& code) {
    LEPUSValue val = LEPUS_Eval(ctx_, code.c_str(), code.size(), "<stress>",
                                LEPUS_EVAL_TYPE_GLOBAL);
    if (LEPUS_IsException(val)) {
      LEPUS_FreeValue(ctx_, LEPUS_GetException(ctx_));
      return false;
    }
    LEPUS_FreeValue(ctx_, val);
    return true;
  }

  LEPUSRuntime* rt_;
  LEPUSContext* ctx_;
};

// Test local variable reordering with 256+ locals
TEST_F(BytecodeOptStress, ManyLocals256) {
  std::ostringstream oss;
  oss << "(function() {\n";
  for (int i = 0; i < 300; i++) {
    oss << "  let v" << i << " = " << i << ";\n";
  }
  // Access some high-index vars frequently to trigger reordering
  oss << "  let sum = 0;\n";
  for (int i = 0; i < 50; i++) {
    oss << "  sum += v299;\n";
    oss << "  sum += v0;\n";
  }
  oss << "  return sum;\n";
  oss << "})()";
  EXPECT_EQ(EvalInt(oss.str()), 50 * 299 + 50 * 0);
}

// Test closure variable reordering with many captured vars
TEST_F(BytecodeOptStress, ManyClosureVars) {
  std::ostringstream oss;
  oss << "(function() {\n";
  for (int i = 0; i < 300; i++) {
    oss << "  let c" << i << " = " << i << ";\n";
  }
  oss << "  return function() {\n";
  oss << "    let sum = 0;\n";
  // Access high-index closure vars frequently
  for (int i = 0; i < 20; i++) {
    oss << "    sum += c299;\n";
    oss << "    sum += c150;\n";
  }
  oss << "    return sum;\n";
  oss << "  };\n";
  oss << "})()()";
  EXPECT_EQ(EvalInt(oss.str()), 20 * 299 + 20 * 150);
}

// Test constant pool reordering with >256 string literals
TEST_F(BytecodeOptStress, LargeCpool) {
  std::ostringstream oss;
  oss << "(function() {\n";
  oss << "  var obj = {};\n";
  for (int i = 0; i < 300; i++) {
    oss << "  obj['key" << i << "'] = " << i << ";\n";
  }
  // Access some keys frequently to trigger reordering
  oss << "  let sum = 0;\n";
  for (int i = 0; i < 30; i++) {
    oss << "  sum += obj['key299'];\n";
  }
  oss << "  return sum;\n";
  oss << "})()";
  EXPECT_EQ(EvalInt(oss.str()), 30 * 299);
}

// Test deeply nested loops (jump/label handling)
TEST_F(BytecodeOptStress, DeeplyNestedLoops) {
  std::ostringstream oss;
  oss << "(function() {\n";
  oss << "  let count = 0;\n";
  // 30 nested loops (each iterating 2 times = 2^30 too many, use 1 iter)
  int depth = 15;
  for (int i = 0; i < depth; i++) {
    oss << std::string(i * 2 + 2, ' ') << "for (let i" << i << " = 0; i" << i
        << " < 2; i" << i << "++) {\n";
  }
  oss << std::string(depth * 2 + 2, ' ') << "count++;\n";
  for (int i = depth - 1; i >= 0; i--) {
    oss << std::string(i * 2 + 2, ' ') << "}\n";
  }
  oss << "  return count;\n";
  oss << "})()";
  // 2^15 = 32768
  EXPECT_EQ(EvalInt(oss.str()), 32768);
}

// Test long function body (large bytecode buffer)
TEST_F(BytecodeOptStress, LongFunction) {
  std::ostringstream oss;
  oss << "(function() {\n";
  oss << "  let x = 0;\n";
  for (int i = 0; i < 5000; i++) {
    oss << "  x = x + 1;\n";
  }
  oss << "  return x;\n";
  oss << "})()";
  EXPECT_EQ(EvalInt(oss.str()), 5000);
}

// Test TDZ-heavy code with let/const in complex scoping
TEST_F(BytecodeOptStress, TDZHeavy) {
  std::ostringstream oss;
  oss << "(function() {\n";
  oss << "  let sum = 0;\n";
  for (int i = 0; i < 100; i++) {
    oss << "  { let x" << i << " = " << i << "; sum += x" << i << "; }\n";
  }
  oss << "  return sum;\n";
  oss << "})()";
  // sum of 0..99 = 4950
  EXPECT_EQ(EvalInt(oss.str()), 4950);
}

// Test many labels (switch with many cases)
TEST_F(BytecodeOptStress, ManyLabels) {
  std::ostringstream oss;
  oss << "(function() {\n";
  oss << "  let sum = 0;\n";
  oss << "  for (let i = 0; i < 200; i++) {\n";
  oss << "    switch(i % 50) {\n";
  for (int i = 0; i < 50; i++) {
    oss << "      case " << i << ": sum += " << (i + 1) << "; break;\n";
  }
  oss << "    }\n";
  oss << "  }\n";
  oss << "  return sum;\n";
  oss << "})()";
  // Each case i adds (i+1), sum of 1..50 = 1275, repeated 4 times = 5100
  EXPECT_EQ(EvalInt(oss.str()), 5100);
}

// Test dead code elimination with unreachable code after return
TEST_F(BytecodeOptStress, DeadCodeHeavy) {
  std::ostringstream oss;
  oss << "(function() {\n";
  oss << "  let x = 42;\n";
  oss << "  return x;\n";
  // 500 lines of dead code
  for (int i = 0; i < 500; i++) {
    oss << "  x = x + " << i << ";\n";
  }
  oss << "  return x;\n";
  oss << "})()";
  EXPECT_EQ(EvalInt(oss.str()), 42);
}

// Test empty function (boundary condition)
TEST_F(BytecodeOptStress, EmptyFunction) {
  std::string code = "(function() {})()";
  EXPECT_TRUE(EvalNoThrow(code));
}

// Test single instruction function
TEST_F(BytecodeOptStress, SingleInstruction) {
  EXPECT_EQ(EvalInt("(function() { return 7; })()"), 7);
}

// Test short-circuit patterns (&&, ||) heavily
TEST_F(BytecodeOptStress, ShortCircuitHeavy) {
  std::ostringstream oss;
  oss << "(function() {\n";
  oss << "  let count = 0;\n";
  for (int i = 0; i < 200; i++) {
    oss << "  if (" << (i % 2 == 0 ? "true" : "false") << " && "
        << (i % 3 == 0 ? "true" : "false") << ") count++;\n";
  }
  oss << "  return count;\n";
  oss << "})()";
  // true && true when i%2==0 && i%3==0 => i%6==0, count: 0,6,12,...,198 => 34
  int expected = 0;
  for (int i = 0; i < 200; i++) {
    if (i % 2 == 0 && i % 3 == 0) expected++;
  }
  EXPECT_EQ(EvalInt(oss.str()), expected);
}

// Test combined optimizations: all passes working together
TEST_F(BytecodeOptStress, CombinedOptimizations) {
  std::string code = R"(
    (function() {
      // TDZ + closure + large cpool + dead code + loops
      let result = 0;
      for (let i = 0; i < 100; i++) {
        let x = i * 2;
        let unused = 999;  // dead store
        if (false) { result = -1; }  // dead code
        let fn = function() { return x; };  // closure
        result += fn();
        if (true) { result += 0; }  // constant condition
      }
      return result;
    })()
  )";
  // sum of i*2 for i=0..99 = 2*(0+1+...+99) = 2*4950 = 9900
  EXPECT_EQ(EvalInt(code), 9900);
}

// ============================================================
// TDZ (Temporal Dead Zone) correctness tests for bytecode optimizer.
// These verify that the optimizer preserves TDZ semantics —
// variables must throw ReferenceError when accessed before initialization.
// ============================================================

// Basic: assign to let variable before declaration must throw
TEST_F(BytecodeOptStress, TDZ_PutBeforeLetDecl) {
  std::string code = R"(
    (function() {
      try { x = 1; } catch(e) { return 1; }
      let x = 10;
      return 0;
    })()
  )";
  EXPECT_EQ(EvalInt(code), 1);
}

// Basic: read let variable before declaration must throw
TEST_F(BytecodeOptStress, TDZ_GetBeforeLetDecl) {
  std::string code = R"(
    (function() {
      try { return x; } catch(e) { return 1; }
      let x = 10;
      return 0;
    })()
  )";
  EXPECT_EQ(EvalInt(code), 1);
}

// Basic: assign to const before declaration must throw
TEST_F(BytecodeOptStress, TDZ_PutBeforeConstDecl) {
  std::string code = R"(
    (function() {
      try { x = 1; } catch(e) { return 1; }
      const x = 10;
      return 0;
    })()
  )";
  EXPECT_EQ(EvalInt(code), 1);
}

// Const reassignment after initialization must throw TypeError
TEST_F(BytecodeOptStress, TDZ_ConstReassign) {
  std::string code = R"(
    (function() {
      const x = 10;
      try { x = 20; } catch(e) { return 1; }
      return 0;
    })()
  )";
  EXPECT_EQ(EvalInt(code), 1);
}

// TDZ in conditional branch: variable initialized only on one path
TEST_F(BytecodeOptStress, TDZ_ConditionalInit) {
  std::string code = R"(
    (function() {
      let flag = false;
      let result = 0;
      {
        if (flag) {
          // x is NOT initialized on this path
        } else {
          var y = 1;
        }
      }
      // Verify no crash with conditional dead stores
      return 42;
    })()
  )";
  EXPECT_EQ(EvalInt(code), 42);
}

// TDZ with typeof: typeof on TDZ variable must still throw
TEST_F(BytecodeOptStress, TDZ_TypeofBeforeInit) {
  std::string code = R"(
    (function() {
      try { var t = typeof x; } catch(e) { return 1; }
      let x = 10;
      return 0;
    })()
  )";
  EXPECT_EQ(EvalInt(code), 1);
}

// TDZ in loop body: each iteration re-enters TDZ for block-scoped let
TEST_F(BytecodeOptStress, TDZ_LoopReentry) {
  std::string code = R"(
    (function() {
      let count = 0;
      for (let i = 0; i < 5; i++) {
        // Each iteration, x should be in TDZ until initialized
        let x = i;
        count += x;
      }
      return count;
    })()
  )";
  // 0+1+2+3+4 = 10
  EXPECT_EQ(EvalInt(code), 10);
}

// TDZ: function call between set_loc_uninitialized and put_loc_check
// Tests that extended scan doesn't look past function calls
TEST_F(BytecodeOptStress, TDZ_FunctionCallInTDZWindow) {
  std::string code = R"(
    (function() {
      let threw = 0;
      function inner() {
        try { x = 1; } catch(e) { threw = 1; }
      }
      inner();
      let x = 10;
      return threw;
    })()
  )";
  // inner() tries to assign to x which is in TDZ (captured by closure)
  // This should throw because x is captured and in TDZ
  EXPECT_EQ(EvalInt(code), 1);
}

// TDZ preserved across if/else branches with early return on one branch
TEST_F(BytecodeOptStress, TDZ_BranchWithReturn) {
  std::string code = R"(
    (function() {
      let cond = false;
      if (cond) {
        return 99;
      }
      // After the if, TDZ for x must still be in effect
      try { x = 1; } catch(e) { return 1; }
      let x = 10;
      return 0;
    })()
  )";
  EXPECT_EQ(EvalInt(code), 1);
}

// TDZ: variable used only in put_loc_check (DSE must not eliminate TDZ marker)
// This directly tests the bug where var_is_read didn't count put_loc_check
TEST_F(BytecodeOptStress, TDZ_OnlyWriteNeverRead) {
  std::string code = R"(
    (function() {
      try {
        x = 1;
        let x;
        return 0;
      } catch(e) {
        return 1;
      }
    })()
  )";
  EXPECT_EQ(EvalInt(code), 1);
}

// TDZ: multiple let variables, only some accessed before init
TEST_F(BytecodeOptStress, TDZ_MultipleVars) {
  std::string code = R"(
    (function() {
      let errors = 0;
      try { a = 1; } catch(e) { errors++; }
      let a = 10;
      let b = 20;
      let c = a + b;
      try { d = 1; } catch(e) { errors++; }
      let d = 40;
      return errors * 100 + c;
    })()
  )";
  // errors = 2 (a and d), c = 30
  EXPECT_EQ(EvalInt(code), 230);
}

// TDZ in switch/case: access before init inside switch
TEST_F(BytecodeOptStress, TDZ_Switch) {
  std::string code = R"(
    (function() {
      let val = 1;
      let result = 0;
      switch(val) {
        case 0:
          let x = 10;
          result = x;
          break;
        case 1:
          // x is in TDZ here (same block scope as case 0's let)
          try { x = 5; } catch(e) { result = 99; }
          break;
      }
      return result;
    })()
  )";
  EXPECT_EQ(EvalInt(code), 99);
}

// TDZ: verify normal let/const initialization works after optimization
TEST_F(BytecodeOptStress, TDZ_NormalInitWorks) {
  std::string code = R"(
    (function() {
      let a = 1;
      const b = 2;
      let c = a + b;
      const d = c * 2;
      let e;
      e = d + 1;
      return e;
    })()
  )";
  EXPECT_EQ(EvalInt(code), 7);
}

// TDZ: for-loop let variable with closure capture
TEST_F(BytecodeOptStress, TDZ_ForLoopClosure) {
  std::string code = R"(
    (function() {
      let fns = [];
      for (let i = 0; i < 5; i++) {
        fns.push(function() { return i; });
      }
      let sum = 0;
      for (let j = 0; j < 5; j++) {
        sum += fns[j]();
      }
      return sum;
    })()
  )";
  // Each closure captures its own i: 0+1+2+3+4 = 10
  EXPECT_EQ(EvalInt(code), 10);
}

// TDZ: nested block scopes with same variable name
TEST_F(BytecodeOptStress, TDZ_NestedSameNameBlocks) {
  std::string code = R"(
    (function() {
      let sum = 0;
      {
        let x = 1;
        sum += x;
        {
          let x = 2;
          sum += x;
          {
            let x = 3;
            sum += x;
          }
        }
      }
      return sum;
    })()
  )";
  EXPECT_EQ(EvalInt(code), 6);
}

// TDZ: try/catch with TDZ violation inside try block
TEST_F(BytecodeOptStress, TDZ_TryCatch) {
  std::string code = R"(
    (function() {
      try {
        let y = x;
        let x = 5;
        return 0;
      } catch(e) {
        return 1;
      }
    })()
  )";
  EXPECT_EQ(EvalInt(code), 1);
}

// TDZ: stress test with many TDZ violations in sequence
TEST_F(BytecodeOptStress, TDZ_ManyViolations) {
  std::ostringstream oss;
  oss << "(function() {\n";
  oss << "  let errors = 0;\n";
  for (int i = 0; i < 50; i++) {
    oss << "  try { v" << i << " = " << i << "; } catch(e) { errors++; }\n";
    oss << "  let v" << i << " = " << i << ";\n";
  }
  oss << "  return errors;\n";
  oss << "})()";
  EXPECT_EQ(EvalInt(oss.str()), 50);
}

// TDZ: variable in loop condition check (backward label interaction)
TEST_F(BytecodeOptStress, TDZ_LoopBackwardLabel) {
  std::string code = R"(
    (function() {
      let sum = 0;
      for (let i = 0; i < 10; i++) {
        let x = i * 2;
        sum += x;
      }
      return sum;
    })()
  )";
  // sum of i*2 for i=0..9 = 90
  EXPECT_EQ(EvalInt(code), 90);
}

// TDZ: put_loc_check_init semantics - const cannot be assigned twice
TEST_F(BytecodeOptStress, TDZ_ConstDoubleInit) {
  std::string code = R"(
    (function() {
      // This tests that const initialization works correctly after optimization
      const values = [];
      for (let i = 0; i < 5; i++) {
        const x = i;
        values.push(x);
      }
      let sum = 0;
      for (let i = 0; i < 5; i++) sum += values[i];
      return sum;
    })()
  )";
  EXPECT_EQ(EvalInt(code), 10);
}

// ============================================================
// Targeted test for issue #1: TDZ scan through dead code after goto.
// The optimizer's TDZ pre-scan may follow bytecode linearly past an
// unconditional goto, reaching dead code that contains a put_loc.
// This could incorrectly mark the variable as "permanently initialized",
// causing TDZ checks to be eliminated when they shouldn't be.
// ============================================================

// If the optimizer incorrectly scans past goto into dead code containing
// an assignment, it may think 'x' is always initialized and remove the
// TDZ check. The access to 'x' before initialization must still throw.
TEST_F(BytecodeOptStress, TDZ_ScanPastGotoDeadCode) {
  // This pattern generates: goto L1; put_loc(x) [dead code]; L1:
  // get_loc_check(x) The 'if(true)' generates a goto that skips the else
  // branch. The dead else branch contains an assignment to x (put_loc). After
  // L1, reading x should still trigger TDZ.
  std::string code = R"(
    (function() {
      try {
        if (true) {
          // goto past the else block (dead code containing put_loc(x))
        } else {
          x = 42;  // dead code: generates put_loc(x) in bytecode
        }
        // At this point x should still be in TDZ
        let tmp = x;  // get_loc_check(x) - must throw ReferenceError
        let x = 10;
        return 0;
      } catch(e) {
        return 1;
      }
    })()
  )";
  EXPECT_EQ(EvalInt(code), 1);
}

// Variant: unconditional jump via loop break creates goto over dead assignment
TEST_F(BytecodeOptStress, TDZ_ScanPastBreakDeadCode) {
  std::string code = R"(
    (function() {
      try {
        do {
          break;
          x = 99;  // dead code after break (unconditional goto)
        } while(false);
        let tmp = x;  // must throw - x is in TDZ
        let x = 10;
        return 0;
      } catch(e) {
        return 1;
      }
    })()
  )";
  EXPECT_EQ(EvalInt(code), 1);
}

// Variant: dead code in a never-taken branch with complex control flow
TEST_F(BytecodeOptStress, TDZ_ScanPastReturnDeadCode) {
  std::string code = R"(
    (function() {
      function helper(flag) {
        if (flag) {
          return 1;
          // Dead code after return - optimizer might scan linearly here
          x = 100;
        }
        try {
          let tmp = x;  // must throw - x in TDZ
          let x = 5;
          return 0;
        } catch(e) {
          return 2;
        }
      }
      return helper(false);
    })()
  )";
  EXPECT_EQ(EvalInt(code), 2);
}

// Direct pattern: conditional that always takes one branch,
// dead branch has the only write to a TDZ variable
TEST_F(BytecodeOptStress, TDZ_DeadBranchOnlyWrite) {
  std::string code = R"(
    (function() {
      try {
        var cond = true;
        if (cond) {
          // This branch taken - no write to x here
        } else {
          x = 1;  // Never executed, but bytecoded - put_loc(x)
        }
        // x is still in TDZ
        return x;
        let x = 10;
      } catch(e) {
        return 99;
      }
    })()
  )";
  EXPECT_EQ(EvalInt(code), 99);
}
