// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

(function() {
  function check(actual, expected) {
    if (actual !== expected) throw new Error("rope content mismatch");
  }

  // Exercise shallow ropes, the inline capacity boundary, and deep ropes.
  for (const depth of [1, 2, 7, 8, 9, 64, 257, 1024]) {
    for (const unit of ["a", "\u00e9", "\u4e2d", "\ud83d\ude00"]) {
      let left = "", right = "", shared = [];
      for (let i = 0; i < depth; i++) {
        left = left + unit;
        right = unit + right;
        if (i % 3 === 0) shared.push(left);
      }
      const expected = unit.repeat(depth);
      check(left.length, expected.length);
      check(right.length, expected.length);
      check(left.charCodeAt(left.length - 1),
            expected.charCodeAt(expected.length - 1));
      check(left, expected);
      check(right, expected);
      // Reuse flattened nodes and retain shared, unflattened subtrees.
      check(left + right, expected + expected);
      for (let i = 0; i < shared.length; i++) {
        check(shared[i], unit.repeat(i * 3 + 1));
      }
    }
  }

  for (let i = 0; i < 100; i++) {
    // Drop trees without first flattening them, including shared children.
    let a = "a", b = "\u4e2d";
    for (let j = 0; j < 10; j++) {
      a = a + a;
      b = b + b;
    }
    check(a.length, 1024);
    check(b.length, 1024);
  }
})();
