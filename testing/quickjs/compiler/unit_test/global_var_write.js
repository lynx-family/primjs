// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// Writes to writable global data properties take a fast path. Check that
// every other kind of global binding still behaves as before.

function run(f) {
  try {
    return 'ok ' + String(f());
  } catch (e) {
    return e.name;
  }
}

function expect(actual, expected, what) {
  if (actual !== expected) {
    throw new Error(`${what}: ${actual} !== ${expected}`);
  }
}

var globalVar = 1;
let globalLet = 1;
const globalConst = 1;
Object.defineProperty(
    globalThis, 'readOnly', {value: 1, writable: false, configurable: true});
let setterSum = 0;
Object.defineProperty(globalThis, 'accessor', {
  get() {
    return 42;
  },
  set(v) {
    setterSum += v;
  },
  configurable: true,
});

expect(run(() => (globalVar = 2, globalVar)), 'ok 2', 'var');
expect(run(() => (globalLet = 3, globalLet)), 'ok 3', 'let');
expect(run(() => (globalConst = 4)), 'TypeError', 'const');
expect(run(() => (readOnly = 5, readOnly)), 'ok 1', 'read-only sloppy');
expect(run(() => {
  'use strict';
  readOnly = 5;
}), 'TypeError', 'read-only strict');
expect(
    run(() => (accessor = 7, accessor = 8, setterSum + '/' + accessor)),
    'ok 15/42', 'accessor');
expect(run(() => (undeclared1 = 9, undeclared1)), 'ok 9', 'undeclared');
expect(run(() => {
  'use strict';
  undeclared2 = 9;
}), 'ReferenceError', 'undeclared strict');
expect(run(() => {
  delete globalThis.undeclared1;
  undeclared1 = 2;
  return undeclared1;
}), 'ok 2', 'deleted');
expect(run(() => {
  Object.defineProperty(globalThis, 'globalVar', {writable: false});
  globalVar = 10;
  return globalVar;
}), 'ok 2', 'made read-only');
expect(run(() => (lateLet = 1)), 'ReferenceError', 'TDZ');
expect(
    run(() => {
      'use strict';
      lateLet = 1;
    }),
    'ReferenceError', 'TDZ strict');
expect(
    run(() => {
      'use strict';
      globalLet = 11;
      undeclared1 = 12;
      return globalLet + '/' + undeclared1;
    }),
    'ok 11/12', 'strict');
expect(
    run(() => {
      'use strict';
      globalLet += 2;
      undeclared1++;
      [globalLet, undeclared1] = [globalLet * 10, undeclared1 * 10];
      return globalLet + '/' + undeclared1;
    }),
    'ok 130/130', 'strict compound');
expect(
    run(() => {
      'use strict';
      undeclared3 += 1;
    }),
    'ReferenceError', 'strict compound undeclared');
expect(
    run(() => {
      'use strict';
      globalConst += 1;
    }),
    'TypeError', 'strict compound const');

// Stored objects must stay reachable: the stores need the GC write barrier.
var heldVar = null;
let heldLet = null;
function storeObjects(strict) {
  const store = strict ? function(i) {
    'use strict';
    heldVar = {i};
    heldLet = [i];
  } : function(i) {
    heldVar = {i};
    heldLet = [i];
  };
  for (let i = 0; i < 20000; i++) {
    store(i);
    const garbage = new Array(16).fill(i);
    if (i % 5000 === 0) gc();
  }
  gc();
  expect(heldVar.i + '/' + heldLet[0], '19999/19999', 'held objects');
}
storeObjects(false);
storeObjects(true);

let lateLet = 0;
