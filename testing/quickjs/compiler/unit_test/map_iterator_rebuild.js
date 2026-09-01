// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

function assertArrayEquals(actual, expected) {
  if (actual.length !== expected.length) {
    throw new Error(
        `length mismatch: ${actual.length} !== ${expected.length}`);
  }
  for (let i = 0; i < actual.length; i++) {
    if (actual[i] !== expected[i]) {
      throw new Error(
          `element ${i} mismatch: ${actual[i]} !== ${expected[i]}`);
    }
  }
}

function createFullMap() {
  return new Map([
    ["a", 1],
    ["b", 2],
    ["c", 3],
    ["d", 4],
  ]);
}

function testIteratorAfterRebuild() {
  const map = createFullMap();
  const iterator = map.keys();

  if (iterator.next().value !== "a") {
    throw new Error("unexpected first iterator value");
  }

  // The table is full. Removing an already visited entry and then appending a
  // new one rebuilds and compacts the table, invalidating the saved entry index.
  map.delete("a");
  map.set("e", 5);

  assertArrayEquals(Array.from(iterator), ["b", "c", "d", "e"]);
}

function testForEachAfterRebuild() {
  const map = createFullMap();
  const visited = [];

  map.forEach((value, key) => {
    visited.push(key);
    if (key === "a") {
      map.delete("a");
      map.set("e", 5);
    }
  });

  assertArrayEquals(visited, ["a", "b", "c", "d", "e"]);
}

function testUndefinedKeyIsNotATombstone() {
  const map = new Map([[undefined, 1], ["a", 2], ["b", 3], ["c", 4]]);
  if (!map.has(undefined) || map.get(undefined) !== 1) {
    throw new Error("undefined key is missing");
  }

  map.delete("a");
  map.set("d", 5);
  assertArrayEquals(Array.from(map.keys()), [undefined, "b", "c", "d"]);
}

function testIteratorAcrossMultipleRebuilds() {
  const map = createFullMap();
  const iterator = map.keys();

  if (iterator.next().value !== "a") {
    throw new Error("unexpected first iterator value");
  }

  map.delete("a");
  map.set("e", 5);
  map.delete("b");
  map.set("f", 6);
  map.set("g", 7);
  map.set("h", 8);
  map.delete("c");
  map.set("i", 9);

  assertArrayEquals(Array.from(iterator), ["d", "e", "f", "g", "h", "i"]);
}

function testIteratorAfterClearAndRebuild() {
  const map = createFullMap();
  const iterator = map.keys();

  if (iterator.next().value !== "a") {
    throw new Error("unexpected first iterator value");
  }

  map.clear();
  map.set("e", 5);
  map.set("f", 6);

  assertArrayEquals(Array.from(iterator), ["e", "f"]);
}

function testWeakMapAfterRebuildAndGC() {
  const map = new WeakMap();
  const retained = [];
  for (let i = 0; i < 64; i++) {
    const key = {i};
    map.set(key, i);
    if ((i & 7) === 0) retained.push(key);
  }
  for (let i = 0; i < retained.length; i++) {
    if (map.get(retained[i]) !== i * 8) {
      throw new Error("weak map entry was lost");
    }
  }
}

function testIteratorAcrossShrink() {
  const map = new Map();
  for (let i = 0; i < 64; i++) map.set(i, i);
  const iterator = map.keys();
  if (iterator.next().value !== 0) {
    throw new Error("unexpected first iterator value before shrink");
  }

  for (let i = 0; i < 56; i++) map.delete(i);
  assertArrayEquals(Array.from(iterator), [56, 57, 58, 59, 60, 61, 62, 63]);
}

testIteratorAfterRebuild();
testForEachAfterRebuild();
testUndefinedKeyIsNotATombstone();
testIteratorAcrossMultipleRebuilds();
testIteratorAfterClearAndRebuild();
testWeakMapAfterRebuildAndGC();
testIteratorAcrossShrink();
