// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

function assertEq(actual, expected, message) {
  if (actual !== expected) {
    throw new Error(
      message + ": expected " + expected + ", got " + actual);
  }
}

function checkAsUintN(bits, x) {
  const modulus = 2n ** BigInt(bits);
  const expected = ((x % modulus) + modulus) % modulus;
  assertEq(BigInt.asUintN(bits, x), expected,
           "BigInt.asUintN(" + bits + ", " + x + ")");
}

function checkAsIntN(bits, x) {
  const modulus = 2n ** BigInt(bits);
  let expected = ((x % modulus) + modulus) % modulus;
  if (expected >= modulus / 2n) expected -= modulus;
  assertEq(BigInt.asIntN(bits, x), expected,
           "BigInt.asIntN(" + bits + ", " + x + ")");
}

assertEq(BigInt.asUintN(64, -1n), 18446744073709551615n, "asUintN(64, -1n)");
assertEq(BigInt.asUintN(64, -2n), 18446744073709551614n, "asUintN(64, -2n)");
assertEq(BigInt.asUintN(65, -1n), 36893488147419103231n, "asUintN(65, -1n)");
assertEq(BigInt.asUintN(128, -1n), 2n ** 128n - 1n, "asUintN(128, -1n)");
assertEq(BigInt.asUintN(64, 2n ** 64n - 1n), 2n ** 64n - 1n,
         "asUintN(64, 2n ** 64n - 1n)");

const bitsList = [1, 31, 32, 33, 63, 64, 65, 96, 127, 128, 129, 200];
const values = [
  0n, 1n, -1n, -2n, 2n ** 31n, -(2n ** 31n), 2n ** 63n - 1n, -(2n ** 63n),
  2n ** 63n, -(2n ** 63n) - 1n, 2n ** 64n - 1n, 2n ** 64n, -(2n ** 64n),
  2n ** 64n + 1n, -(2n ** 64n) - 1n, 2n ** 127n, -(2n ** 127n),
  -(2n ** 128n) + 12345n, 0x123456789abcdef0123456789abcdefn,
  -0x123456789abcdef0123456789abcdefn,
];
for (const bits of bitsList) {
  for (const x of values) {
    checkAsUintN(bits, x);
    checkAsIntN(bits, x);
  }
}

let threw = false;
try {
  BigInt.asUintN(2 ** 53 - 1, -1n);
} catch (e) {
  threw = e instanceof RangeError;
}
assertEq(threw, true, "asUintN with a huge bit count throws RangeError");
assertEq(BigInt.asUintN(2 ** 53 - 1, 5n), 5n, "asUintN(2 ** 53 - 1, 5n)");
assertEq(BigInt.asIntN(2 ** 53 - 1, -5n), -5n, "asIntN(2 ** 53 - 1, -5n)");

console.log("bigint_as_uint_n passed");
