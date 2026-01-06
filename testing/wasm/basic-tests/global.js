// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// import the mjsunit module for assertXXX
require('../test/mjsunit.js');
// assertEquals = function() {}

// throw exception
// WebAssembly.Global();

assertTrue(WebAssembly.Global instanceof Function);

console.log(WebAssembly.Global.name);
assertEquals(WebAssembly.Global.name, 'Global');

console.log(typeof WebAssembly.Global);
assertEquals(typeof WebAssembly.Global, 'function');

console.log(WebAssembly.Global.hasOwnProperty('name'));
assertEquals(WebAssembly.Global.hasOwnProperty('name'), true);

var gbl = new WebAssembly.Global({ value: 'i32', mutable: true }, 23);
assertTrue(gbl instanceof WebAssembly.Global);
assertFalse(gbl instanceof WebAssembly.Module);

console.log(gbl.hasOwnProperty('value'));
console.log(gbl.__proto__.hasOwnProperty('value'));
console.log(gbl.__proto__.hasOwnProperty('valueOf'));

console.log(gbl.__proto__.__proto__.hasOwnProperty('value'));
console.log(gbl.__proto__.__proto__.hasOwnProperty('valueOf'));

let value = gbl.valueOf();
console.log(value);
assertEquals(value, 23);

gbl.value = 42;
console.log(gbl.value);
assertEquals(gbl.value, 42);

let value1 = gbl.valueOf();
console.log(value1);
assertEquals(value1, 42);

console.log('basic-tests: global.js passed');
