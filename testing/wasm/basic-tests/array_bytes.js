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

// This test case is used to check whether a correct
// raw data pointer and a correct bytes length are
// obtained to create a valid WebAssembly.Module instance.
const wasm_bytes = new Uint8Array([
  0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
  // Valid data begins from the next bytes.
  0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x01, 0x06, 0x01, 0x60, 0x01, 0x7f, 0x01, 0x7f, 0x03, 0x02,
  0x01, 0x00, 0x07, 0x0a, 0x01, 0x06, 0x73, 0x65, 0x6c, 0x65, 0x63, 0x74, 0x00, 0x00, 0x0a, 0x06, 0x01, 0x04,
  0x00, 0x20, 0x00, 0x0b, 0x00, 0x10, 0x04, 0x6e, 0x61, 0x6d, 0x65, 0x01, 0x09, 0x01, 0x00, 0x06, 0x73, 0x65,
  0x6c, 0x65, 0x63, 0x74,
]);

var buf = wasm_bytes.buffer;

var real_bytes = new Uint8Array(buf, 8);

let mdl = new WebAssembly.Module(real_bytes);
let instance = new WebAssembly.Instance(mdl, {});
console.log(instance.exports);

assertEquals(-1, instance.exports.select(-1));
assertThrows(() => {
  new WebAssembly.Module(real_bytes.buffer);
});

console.log('basic-tests: array_bytes.js passed');
