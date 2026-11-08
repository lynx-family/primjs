// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// Each WeakMap entry links a record into its key's weak reference list. These
// cases mix maps that die, grow, or delete entries with keys that are shared
// by many maps or die first, and check every surviving entry after a GC.

function check(condition, message) {
  if (!condition) throw new Error(message);
}

function testSharedKeysAcrossDeadMaps() {
  const keys = [];
  for (let i = 0; i < 64; i++) keys.push({i});
  const live = [];
  for (let j = 0; j < 200; j++) {
    // Growing to 64 entries rebuilds the table several times.
    const map = new WeakMap();
    for (let i = 0; i < keys.length; i++) map.set(keys[i], i + j);
    if (j % 10 === 0) live.push([map, j]);
  }
  gc();
  for (const [map, j] of live) {
    for (let i = 0; i < keys.length; i++) {
      check(map.get(keys[i]) === i + j, `map ${j} lost key ${i}`);
    }
  }
  for (const [map] of live) {
    for (let i = 0; i < keys.length; i += 2) {
      check(map.delete(keys[i]), `delete of key ${i} failed`);
    }
  }
  gc();
  for (const [map, j] of live) {
    for (let i = 0; i < keys.length; i++) {
      check(map.has(keys[i]) === (i % 2 === 1), `map ${j} key ${i} state`);
    }
  }
}

function testKeysDieWhileMapsLive() {
  const maps = [new WeakMap(), new WeakMap(), new WeakMap()];
  (function() {
    for (let i = 0; i < 100; i++) {
      const key = {i};
      for (const map of maps) map.set(key, i);
    }
  })();
  gc();
  const keys = [];
  for (let i = 0; i < 100; i++) {
    const key = {i};
    keys.push(key);
    for (const map of maps) map.set(key, -i);
  }
  gc();
  for (const map of maps) {
    for (let i = 0; i < keys.length; i++) {
      check(map.get(keys[i]) === -i, `key ${i} lost after other keys died`);
    }
  }
}

function testMixedRecordsOnOneKey() {
  const key = {};
  const maps = [];
  const refs = [];
  const registry = new FinalizationRegistry(() => {});
  const tokens = [];
  for (let i = 0; i < 20; i++) {
    const map = new WeakMap();
    map.set(key, i);
    maps.push(map);
    refs.push(new WeakRef(key));
    const token = {};
    registry.register(key, i, token);
    tokens.push(token);
  }
  maps.length = 10;
  refs.length = 10;
  for (let i = 0; i < 20; i += 2) registry.unregister(tokens[i]);
  gc();
  for (let i = 0; i < 10; i++) {
    check(maps[i].get(key) === i, `map ${i} lost the key`);
    check(refs[i].deref() === key, `WeakRef ${i} lost the key`);
  }
  for (let i = 0; i < 10; i += 3) check(maps[i].delete(key), `delete ${i}`);
  for (let i = 1; i < 20; i += 2) registry.unregister(tokens[i]);
  gc();
  for (let i = 0; i < 10; i++) {
    check(maps[i].has(key) === (i % 3 !== 0), `map ${i} state after delete`);
  }
}

testSharedKeysAcrossDeadMaps();
testKeysDieWhileMapsLive();
testMixedRecordsOnOneKey();
