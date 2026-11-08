// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// RegExp objects and exec results start from precomputed shapes. Check that
// they have the same properties, attributes and order as objects built one
// property at a time, and that changing one object does not affect others.

function describe(obj) {
  return Object.getOwnPropertyNames(obj).map((key) => {
    const d = Object.getOwnPropertyDescriptor(obj, key);
    return key + ':' + JSON.stringify(d.value) + (d.writable ? 'w' : '') +
        (d.enumerable ? 'e' : '') + (d.configurable ? 'c' : '');
  }).join('|');
}

function expect(actual, expected, what) {
  if (actual !== expected) {
    throw new Error(`${what}: ${actual} !== ${expected}`);
  }
}

expect(describe(/a/g), 'lastIndex:0w', 'literal');
expect(describe(new RegExp('a')), 'lastIndex:0w', 'new RegExp');
expect(describe(RegExp('a')), 'lastIndex:0w', 'RegExp call');

class SubRegExp extends RegExp {}
const sub = new SubRegExp('a(b)', 'g');
expect(Object.getPrototypeOf(sub), SubRegExp.prototype, 'subclass prototype');
expect(describe(sub), 'lastIndex:0w', 'subclass');

const match = /(a)(b)?/g.exec('xab');
expect(Array.isArray(match), true, 'result is an array');
expect(Object.getPrototypeOf(match), Array.prototype, 'result prototype');
expect(
    describe(match),
    '0:"ab"wec|1:"a"wec|2:"b"wec|length:3w|groups:undefinedwec|' +
        'index:1wec|input:"xab"wec',
    'result');

const named = /(?<y>\d{4})-(?<m>\d\d)/.exec('on 2024-05');
expect(named.index, 3, 'named index');
expect(JSON.stringify(named.groups), '{"y":"2024","m":"05"}', 'groups');

const changed = /(\w)/.exec('hi');
changed.extra = 1;
changed.index = 9;
delete changed.input;
changed.push('z');
expect(
    describe(changed),
    '0:"h"wec|1:"h"wec|2:"z"wec|length:3w|groups:undefinedwec|' +
        'index:9wec|extra:1wec',
    'changed result');
expect(
    describe(/(\w)/.exec('ok')),
    '0:"o"wec|1:"o"wec|length:2w|groups:undefinedwec|index:0wec|' +
        'input:"ok"wec',
    'next result');

const literals = [];
for (let i = 0; i < 2; i++) literals.push(/l/g);
literals[0].lastIndex = 5;
literals[0].foo = 1;
expect(describe(literals[0]), 'lastIndex:5w|foo:1wec', 'changed literal');
expect(describe(literals[1]), 'lastIndex:0w', 'other literal');
