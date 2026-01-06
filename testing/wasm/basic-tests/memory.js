// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// import the mjsunit module for assertXXX
require('../test/mjsunit.js');

if (typeof read === 'undefined') {
  console.log('This is a nodejs environment');
  const path = require('path');
  const fs = require('fs');
  const currentFilePath = __dirname;
  const mjsunit_text = fs.readFileSync(path.resolve(currentFilePath, '../test/mjsunit.js'), 'utf8');
  eval(mjsunit_text);
}

assertTrue(WebAssembly.Memory instanceof Function);

console.log(WebAssembly.Memory.name);
assertEquals(WebAssembly.Memory.name, 'Memory');

console.log(typeof WebAssembly.Memory);
assertEquals(typeof WebAssembly.Memory, 'function');

console.log(WebAssembly.Memory.hasOwnProperty('name'));
assertEquals(WebAssembly.Memory.hasOwnProperty('name'), true);

console.log(WebAssembly.Memory);
console.log(WebAssembly.Memory.buffer);

var mem = new WebAssembly.Memory({ initial: 10, maximum: 100, shared: true });
assertTrue(mem instanceof WebAssembly.Memory);

console.log(mem.hasOwnProperty('buffer'));
console.log(mem.__proto__.hasOwnProperty('buffer'));
console.log(mem.__proto__.hasOwnProperty('grow'));

console.log(mem.__proto__.__proto__.hasOwnProperty('buffer'));
console.log(mem.__proto__.__proto__.hasOwnProperty('grow'));

console.log('mem.buffer');
let buffer = mem.buffer;
console.log(buffer);

console.log('mem.grow(4)');
let pre_size = mem.grow(4);
assertEquals(pre_size, 10);
console.log(pre_size);

assertThrows(() => {
  console.log('mem.grow(87)');
  let pre_size = mem.grow(87);
}, RangeError);

console.log('basic-tests: memory.js passed');
