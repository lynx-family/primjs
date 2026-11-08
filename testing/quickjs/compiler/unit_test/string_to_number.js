// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// Short decimal strings take a fast path in ToNumber. Check the boundaries
// of that path against the general parser's results.

const cases = [
  ["", 0], ["0", 0], ["-0", -0], ["00", 0], ["007", 7], ["-007", -7],
  ["123456789", 123456789], ["-123456789", -123456789],
  ["999999999", 999999999], ["1234567890", 1234567890],
  ["-1234567890", -1234567890], ["2147483648", 2147483648],
  ["-2147483649", -2147483649], ["000000000", 0], ["0000000001", 1],
  ["-000000000", -0], ["+5", 5], [" 5", 5], ["5 ", 5], ["\t5\n", 5],
  ["5a", NaN], ["-", NaN], ["--1", NaN], ["- 1", NaN], ["0x10", 16],
  ["0b11", 3], ["0o17", 15], ["1e3", 1000], ["1.5", 1.5],
  ["١٢", NaN], ["５", NaN], ["5\u0000", NaN],
];

for (const [input, expected] of cases) {
  for (const actual of [Number(input), +input, input - 0, input * 1]) {
    if (!Object.is(actual, expected)) {
      throw new Error(`${JSON.stringify(input)}: ${actual} !== ${expected}`);
    }
  }
  const int32 = expected | 0;
  if ((input | 0) !== int32) {
    throw new Error(`${JSON.stringify(input)} | 0: ${input | 0} !== ${int32}`);
  }
}
