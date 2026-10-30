// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// Doubling a string by concatenation builds ropes without copying, so it
// reaches the maximum string length (2^30 - 1) after a few steps. Every
// concatenation path must reject the over-long result instead of wrapping its
// length.

const kMaxLength = (1 << 30) - 1;

function expectTooLong(name, concat) {
  let length = 0;
  try {
    length = concat();
  } catch (e) {
    if (!(e instanceof InternalError) || e.message !== "string too long") {
      throw new Error(`${name}: unexpected error ${e}`);
    }
    return;
  }
  throw new Error(`${name}: no error, length ${length}`);
}

// OP_add.
function doubleWithAdd(seed) {
  let s = seed;
  while (s.length <= kMaxLength) {
    const next = s + s;
    if (next.length !== s.length * 2) {
      throw new Error(`add: length ${next.length} after ${s.length}`);
    }
    s = next;
  }
  return s.length;
}

// OP_add_loc.
function doubleWithAddLoc(seed) {
  let s = seed;
  for (;;) {
    const before = s.length;
    s += s;
    if (s.length !== before * 2) {
      throw new Error(`add_loc: length ${s.length} after ${before}`);
    }
  }
}

expectTooLong("add 8-bit", () => doubleWithAdd("ab"));
expectTooLong("add wide", () => doubleWithAdd("中文"));
expectTooLong("add_loc 8-bit", () => doubleWithAddLoc("ab"));
expectTooLong("add_loc wide", () => doubleWithAddLoc("中文"));

// The longest allowed rope is still accepted.
let longest = "a".repeat(1 << 20);
for (let i = 0; i < 9; i++) longest = longest + longest;
if (longest.length !== 1 << 29) {
  throw new Error(`unexpected length ${longest.length}`);
}
