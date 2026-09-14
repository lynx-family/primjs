// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

'use strict';

(function () {
  function assert(condition, message) {
    if (!condition) {
      throw new Error(message);
    }
  }

  function assertEqual(actual, expected, message) {
    assert(actual === expected, `${message}: expected=${expected}, actual=${actual}`);
  }

  function assertCircularComparisonThrows(left, right, message) {
    try {
      isDirectOrDeepEqual(left, right);
    } catch (error) {
      assert(error instanceof TypeError, `${message}: expected TypeError`);
      assert(
        String(error).includes('Cannot compare circular structures'),
        `${message}: unexpected error message`,
      );
      return;
    }
    throw new Error(`${message}: expected comparison to throw`);
  }

  assertEqual(isDirectOrDeepEqual(), true, 'missing arguments');
  assertEqual(isDirectOrDeepEqual(undefined, null), false, 'undefined/null');
  assertEqual(isDirectOrDeepEqual(true, true), true, 'equal booleans');
  assertEqual(isDirectOrDeepEqual(true, false), false, 'different booleans');
  assertEqual(isDirectOrDeepEqual(1, 1.0), true, 'int/float equality');
  assertEqual(isDirectOrDeepEqual(-0, 0), true, 'signed zero');
  assertEqual(isDirectOrDeepEqual(NaN, NaN), false, 'NaN');
  assertEqual(isDirectOrDeepEqual(Infinity, Infinity), true, 'Infinity');
  assertEqual(
    isDirectOrDeepEqual('deep', ['de', 'ep'].join('')),
    true,
    'equal string contents',
  );
  assertEqual(isDirectOrDeepEqual(1n, 1n), true, 'equal BigInts');
  assertEqual(isDirectOrDeepEqual(1n, 2n), false, 'different BigInts');
  assertEqual(
    isDirectOrDeepEqual(Symbol.for('key'), Symbol.for('key')),
    true,
    'registered symbols',
  );
  assertEqual(
    isDirectOrDeepEqual(Symbol('key'), Symbol('key')),
    false,
    'distinct symbols',
  );

  const sameFunction = function () {};
  assertEqual(
    isDirectOrDeepEqual(sameFunction, sameFunction),
    true,
    'same function',
  );
  assertEqual(
    isDirectOrDeepEqual(function () {}, function () {}),
    false,
    'distinct functions',
  );

  assertEqual(
    isDirectOrDeepEqual(
      {a: {value: 1}, b: [2, 3]},
      {b: [2, 3], a: {value: 1}},
    ),
    true,
    'deep equality ignores key order',
  );
  assertEqual(
    isDirectOrDeepEqual({a: undefined}, {b: undefined}),
    false,
    'undefined values with different keys',
  );
  assertEqual(
    isDirectOrDeepEqual({a: [1, 2]}, {a: [1, 3]}),
    false,
    'nested array difference',
  );

  const symbolKey = Symbol('ignored');
  const symbolLeft = {value: 1};
  const symbolRight = {value: 1};
  symbolLeft[symbolKey] = 2;
  symbolRight[symbolKey] = 3;
  assertEqual(
    isDirectOrDeepEqual(symbolLeft, symbolRight),
    true,
    'symbol keys are not enumerable string keys',
  );

  const shared = {value: 1};
  assertEqual(
    isDirectOrDeepEqual(
      {first: shared, second: shared},
      {first: {value: 1}, second: {value: 1}},
    ),
    true,
    'shared references are not circular',
  );

  const circular = {};
  circular.self = circular;
  assertEqual(
    isDirectOrDeepEqual(circular, circular),
    true,
    'same circular root uses direct equality',
  );
  assertCircularComparisonThrows(circular, {}, 'new-side circular object');

  const circularChild = {};
  circularChild.self = circularChild;
  assertCircularComparisonThrows(
    {different: true, child: circularChild},
    {},
    'circularity is checked after an earlier mismatch',
  );

  const oldCircular = {};
  oldCircular.self = oldCircular;
  assertEqual(
    isDirectOrDeepEqual({self: 1}, oldCircular),
    false,
    'old-side circularity is not traversed',
  );

  return true;
})();
