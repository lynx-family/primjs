// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// Array.prototype.slice and splice copy or move the elements of a dense
// array in one pass. Compare them with a property-by-property reference on
// generated inputs, then check the cases that must leave that path.

function same(a, b) {
  if (a.length !== b.length) return false;
  for (let i = 0; i < a.length; i++) {
    if ((i in a) !== (i in b) || a[i] !== b[i]) return false;
  }
  return true;
}

function check(name, actual, expected) {
  const a = JSON.stringify(actual);
  const e = JSON.stringify(expected);
  if (a !== e) throw new Error(`${name}: got ${a}, expected ${e}`);
}

function errorName(f) {
  try {
    f();
  } catch (e) {
    return e.name;
  }
  return "none";
}

function relativeIndex(value, len) {
  const n = Math.trunc(Number(value)) || 0;
  return n < 0 ? Math.max(len + n, 0) : Math.min(n, len);
}

function referenceSplice(o, args) {
  const len = o.length;
  const start = args.length > 0 ? relativeIndex(args[0], len) : 0;
  let itemCount = 0;
  let deleteCount = 0;
  if (args.length === 1) {
    deleteCount = len - start;
  } else if (args.length > 1) {
    itemCount = args.length - 2;
    const d = Math.trunc(Number(args[1])) || 0;
    deleteCount = Math.min(Math.max(d, 0), len - start);
  }
  // A hole stays a hole in the removed elements and in the moved tail.
  const removed = [];
  for (let k = 0; k < deleteCount; k++) {
    if (start + k in o) removed[k] = o[start + k];
  }
  removed.length = deleteCount;
  const tail = [];
  const tailStart = start + deleteCount;
  for (let k = tailStart; k < len; k++) {
    if (k in o) tail[k - tailStart] = o[k];
  }
  tail.length = len - tailStart;
  o.length = start;
  for (let k = 0; k < itemCount; k++) o.push(args[k + 2]);
  const base = start + itemCount;
  for (let k = 0; k < tail.length; k++) {
    if (k in tail) o[base + k] = tail[k];
  }
  o.length = base + tail.length;
  return removed;
}

let seed = 12345;
function random(n) {
  seed = (seed * 1103515245 + 12345) & 0x7fffffff;
  return seed % n;
}

for (let round = 0; round < 5000; round++) {
  const n = random(40);
  const a = [];
  for (let i = 0; i < n; i++) a.push(random(3) === 0 ? { id: i } : i + round);
  const b = [];
  for (let i = 0; i < n; i++) b.push(a[i]);

  const s = random(50) - 5;
  const e = random(50) - 5;
  const from = relativeIndex(s, n);
  const to = relativeIndex(e, n);
  const expected = [];
  for (let k = from; k < to; k++) expected.push(a[k]);
  if (!same(a.slice(s, e), expected)) {
    throw new Error(`slice(${s}, ${e}) of ${n} elements`);
  }

  const args = [];
  const argc = random(8);
  if (argc > 0) args.push(random(50) - 5);
  if (argc > 1) args.push(random(30) - 2);
  for (let i = 2; i < argc; i++) args.push("new" + i);
  const r1 = a.splice(...args);
  const r2 = referenceSplice(b, args);
  if (!same(a, b) || !same(r1, r2)) {
    throw new Error(`splice(${JSON.stringify(args)}) of ${n} elements`);
  }
}

// The same comparison on arrays with holes: the length is larger than the
// number of stored elements, or an element is deleted.
for (let round = 0; round < 3000; round++) {
  const n = random(20);
  const a = [];
  const b = [];
  for (let i = 0; i < n; i++) {
    a.push(i + round);
    b.push(i + round);
  }
  const extra = random(4);
  a.length += extra;
  b.length += extra;
  if (n > 0 && random(2) === 0) {
    const hole = random(3) === 0 ? n - 1 : random(n);
    delete a[hole];
    delete b[hole];
  }
  const len = a.length;

  const s = random(30) - 5;
  const e = random(30) - 5;
  const from = relativeIndex(s, len);
  const to = relativeIndex(e, len);
  const expected = [];
  for (let k = from; k < to; k++) {
    if (k in b) expected[k - from] = b[k];
  }
  expected.length = Math.max(to - from, 0);
  if (!same(a.slice(s, e), expected)) {
    throw new Error(`sparse slice(${s}, ${e}) of ${n}+${extra} elements`);
  }

  const args = [];
  const argc = random(6);
  if (argc > 0) args.push(random(30) - 5);
  if (argc > 1) args.push(random(20) - 2);
  for (let i = 2; i < argc; i++) args.push("new" + i);
  const r1 = a.splice(...args);
  const r2 = referenceSplice(b, args);
  if (!same(a, b) || !same(r1, r2)) {
    throw new Error(
        `sparse splice(${JSON.stringify(args)}) of ${n}+${extra} elements`);
  }
}

// Moving the tail over a hole deletes the destination element.
(() => {
  const dump = (a) => {
    const r = [];
    for (let i = 0; i < a.length; i++) r.push(i in a ? a[i] : "hole");
    return r;
  };
  const a = [1, 2, 3, 4, 5];
  delete a[4];
  check("splice after deleting the last element", [a.splice(-4, 2), dump(a)],
        [[2, 3], [1, 4, "hole"]]);
  const b = [1, 2, 3];
  b.length = 5;
  check("splice with a longer length", [b.splice(0, 1), dump(b)],
        [[1], [2, 3, "hole", "hole"]]);
  const c = [1, 2, 3];
  c.length = 5;
  check("splice insert with a longer length",
        [c.splice(1, 1, "x", "y", "z"), dump(c)],
        [[2], [1, "x", "y", "z", 3, "hole", "hole"]]);
  const d = [1, 2, 3];
  d.length = 5;
  check("shift with a longer length", [d.shift(), dump(d)],
        [1, [2, 3, "hole", "hole"]]);
  const e = [1, 2, 3];
  e.length = 5;
  check("unshift with a longer length", [e.unshift(0), dump(e)],
        [6, [0, 1, 2, 3, "hole", "hole"]]);
  const f = [1, 2, 3, 4, 5];
  delete f[4];
  check("copyWithin over a hole", dump(f.copyWithin(0, 3)),
        [4, "hole", 3, 4, "hole"]);
  // An inherited element is copied, the hole after it is not.
  Array.prototype[3] = "proto";
  try {
    const g = [1, 2, 3];
    g.length = 5;
    g.splice(0, 1);
    const own = (i) => Object.prototype.hasOwnProperty.call(g, i);
    check("splice with an inherited element",
          [g.length, g[0], g[1], g[2], own(2), own(3)],
          [4, 2, 3, "proto", true, false]);
  } finally {
    delete Array.prototype[3];
  }
})();

// Large arrays, so that the storage is reallocated.
(() => {
  const a = [];
  for (let i = 0; i < 5000; i++) a.push(i);
  const s = a.slice(10, 4990);
  const removed = a.splice(100, 4000);
  check("large",
        [s.length, s[0], s[4979], removed.length, removed[0], removed[3999],
         a.length, a[99], a[100], a[999]],
        [4980, 10, 4989, 4000, 100, 4099, 1000, 99, 4100, 4999]);
  const items = [];
  for (let i = 0; i < 3000; i++) items.push(-i);
  a.splice(500, 0, ...items);
  check("large insert", [a.length, a[499], a[500], a[3499], a[3500], a[3999]],
        [4000, 4499, 0, -2999, 4500, 4999]);
})();

// The removed elements keep their identity.
(() => {
  const o1 = {};
  const o2 = {};
  const a = [o1, o2, 3];
  const r = a.splice(0, 2);
  check("identity", [r[0] === o1, r[1] === o2, a.length, a[0]],
        [true, true, 1, 3]);
})();

// Arrays that cannot be modified.
(() => {
  const frozen = Object.freeze([1, 2, 3]);
  const fixedLength = [1, 2, 3];
  Object.defineProperty(fixedLength, "length", { writable: false });
  const sealed = Object.seal([1, 2, 3]);
  const nonExtensible = [1, 2, 3];
  Object.preventExtensions(nonExtensible);
  check("read only",
        [errorName(() => frozen.splice(0, 1)),
         errorName(() => fixedLength.splice(0, 1)),
         errorName(() => sealed.splice(0, 1)),
         errorName(() => nonExtensible.splice(1, 0, 9)),
         nonExtensible.splice(1, 1), nonExtensible, frozen.slice(1)],
        ["TypeError", "TypeError", "TypeError", "TypeError", [2], [1, 3],
         [2, 3]]);
})();

// Species constructors.
(() => {
  class M extends Array {}
  const m = M.from([1, 2, 3, 4]);
  const r = m.splice(1, 2);
  check("subclass", [r instanceof M, r, m, m instanceof M, m.slice(1) instanceof M],
        [true, [2, 3], [1, 4], true, true]);
  const a = [1, 2, 3];
  a.constructor = {
    [Symbol.species]: function() { return { length: 0, tag: "custom" }; }
  };
  const r2 = a.splice(0, 2);
  check("custom species", [r2.tag, r2[0], r2[1], r2.length, a],
        ["custom", 1, 2, 2, [3]]);
  // The constructor changes the array being spliced.
  const b = [1, 2, 3];
  b.constructor = {
    [Symbol.species]: function() { b.length = 1; return []; }
  };
  const r3 = b.splice(0, 3);
  check("species shrinks source", [r3.length, r3[0], b.length], [3, 1, 0]);
})();

// A setter in the prototype chain is called for a new index.
(() => {
  const log = [];
  Object.defineProperty(Array.prototype, 5, {
    set(v) { log.push("set"); },
    get() { return "proto"; },
    configurable: true
  });
  try {
    const a = [0, 1, 2, 3, 4];
    a.splice(1, 0, "x");
    check("prototype setter",
          [a.length, a[5], log, Object.prototype.hasOwnProperty.call(a, 5)],
          [6, "proto", ["set"], false]);
  } finally {
    delete Array.prototype[5];
  }
})();

// Array-like receivers.
(() => {
  const o = { length: 3, 0: "a", 1: "b", 2: "c" };
  const r = Array.prototype.splice.call(o, 1, 1, "X", "Y");
  check("array-like splice", [r, o],
        [["b"], { 0: "a", 1: "X", 2: "Y", 3: "c", length: 4 }]);
  const args = (function() {
    return Array.prototype.slice.call(arguments, 1);
  })(1, 2, 3);
  check("array-like slice",
        [args, Array.prototype.slice.call("abc", 1),
         Array.prototype.slice.call({ length: 2, 0: 1, 1: 2 })],
        [[2, 3], ["b", "c"], [1, 2]]);
})();

// A sparse result keeps its holes.
(() => {
  const a = [1, 2, 3];
  a.length = 5;
  const s = a.slice();
  check("holes", [s.length, 3 in s, 4 in s, a.slice(3).length, 0 in a.slice(3)],
        [5, false, false, 2, false]);
})();

// String.prototype.concat.
(() => {
  const o = { toString() { return "O"; } };
  check("concat",
        ["a".concat(), "a".concat("b"),
         "a".concat("b", "c", 1, null, undefined, o, [1, 2]),
         "中".concat("a", "文"), String.prototype.concat.call(5, 6, 7),
         "".concat("", "", "x")],
        ["a", "ab", "abc1nullundefinedO1,2", "中a文", "567", "x"]);
  check("concat errors",
        [errorName(() => "a".concat("b", {
          toString() { throw new RangeError("x"); }
        }, "c")),
         errorName(() => "a".concat("b", Symbol("s"))),
         errorName(() => String.prototype.concat.call(null, "a", "b"))],
        ["RangeError", "TypeError", "TypeError"]);
})();
