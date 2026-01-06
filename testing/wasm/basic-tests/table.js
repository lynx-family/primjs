// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

require('../test/mjsunit.js');

if (typeof read === 'undefined') {
  console.log('This is a nodejs environment');
  const path = require('path');
  const fs = require('fs');
  const currentFilePath = __dirname;
  const mjsunit_text = fs.readFileSync(path.resolve(currentFilePath, '../test/mjsunit.js'), 'utf8');
  eval(mjsunit_text);
}

assertTrue(WebAssembly.Table instanceof Function);

console.log(WebAssembly.Table.name);
assertEquals(WebAssembly.Table.name, 'Table');

console.log(typeof WebAssembly.Table);
assertEquals('function', typeof WebAssembly.Table);

console.log(WebAssembly.Table.hasOwnProperty('name'));
assertEquals(WebAssembly.Table.hasOwnProperty('name'), true);

console.log(WebAssembly.Table);

var tbl = new WebAssembly.Table({ initial: 1, maximum: 3, element: 'anyfunc' });
assertTrue(tbl instanceof WebAssembly.Table);
assertFalse(tbl instanceof WebAssembly.Memory);

console.log(tbl.hasOwnProperty('length'));
console.log(tbl.__proto__.hasOwnProperty('length'));
console.log(tbl.__proto__.hasOwnProperty('get'));
console.log(tbl.__proto__.hasOwnProperty('set'));
console.log(tbl.__proto__.hasOwnProperty('grow'));

console.log(tbl.__proto__.__proto__.hasOwnProperty('length'));
console.log(tbl.__proto__.__proto__.hasOwnProperty('get'));
console.log(tbl.__proto__.__proto__.hasOwnProperty('set'));
console.log(tbl.__proto__.__proto__.hasOwnProperty('grow'));

console.log('table.length = ' + tbl.length);

// Wasm Runtime do not create an actual independent WebAssembly.Table instance,
// so that the following calls raise exceptions.
// TODO(wasm): provide valid implementation for independent tables.
try {
  console.log('tbl.get(0)');
  let ref = tbl.get(0);
} catch (err) {
  console.log('table.get excption ' + err);
}

try {
  console.log('tbl.set(0)');
  tbl.set(0, null);
} catch (err) {
  console.log('table.set exception ' + err);
}

console.log('tbl.grow(4)');
try {
  let pre_size = tbl.grow(4);
  assertEquals(2, pre_size);
  console.log(pre_size);
} catch (err) {
  console.log('table.grow excption ' + err);
}

assertThrows(() => {
  const test = () => {
    return 'ABCD';
  };
  tbl.set(0, test);
}, TypeError);

console.log('basic-tests: table.js passed');
