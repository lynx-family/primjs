// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

function test_force_gc() {
  for (var t = 0; i < 10000; i++) {
    var ab = new Int8Array(32 * 1024 * 1024);
    for (var i = 0; i < 32 * 1024 * 1024; i++) {
        ab[i] = i;
    }
  }
}

test_force_gc();
