// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

require('../test/mjsunit.js');

var t = 10;
var importObject = {
  imports: {
    imported_func: function (arg) {
      console.log(arg + '  -- from wasm --');
      t = arg;
    },
  },
};

/*
Counterpart in WebAssembly Text format:
(module
  (func $i (import "imports" "imported_func") (param i32))
  (func (export "exported_func")
    i32.const 42
    call $i))
*/
var callback_bytes = new Uint8Array([
  0x00, 0x61, 0x73, 0x6d, 0x01, 0x00, 0x00, 0x00, 0x01, 0x08, 0x02, 0x60, 0x01, 0x7f, 0x00, 0x60, 0x00, 0x00,
  0x02, 0x19, 0x01, 0x07, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74, 0x73, 0x0d, 0x69, 0x6d, 0x70, 0x6f, 0x72, 0x74,
  0x65, 0x64, 0x5f, 0x66, 0x75, 0x6e, 0x63, 0x00, 0x00, 0x03, 0x02, 0x01, 0x01, 0x07, 0x11, 0x01, 0x0d, 0x65,
  0x78, 0x70, 0x6f, 0x72, 0x74, 0x65, 0x64, 0x5f, 0x66, 0x75, 0x6e, 0x63, 0x00, 0x01, 0x0a, 0x08, 0x01, 0x06,
  0x00, 0x41, 0x2a, 0x10, 0x00, 0x0b,
]);

var cb_mod = new WebAssembly.Module(callback_bytes);

var cb_inst = new WebAssembly.Instance(cb_mod, importObject);

let imports = undefined;

assertThrows(() => {
  imports = WebAssembly.Module.imports(cb_mod);
});

if (imports != undefined) {
  var import_one = imports[0];
  assertEquals('imported_func', import_one.name);
  assertEquals('imports', import_one.module);
  assertEquals('function', import_one.kind);
}

var exports = WebAssembly.Module.exports(cb_mod);
if (exports != undefined) {
  console.log(exports);
  console.log(typeof exports);
  var export_one = exports[0];
  assertEquals('exported_func', export_one.name);
  assertEquals('function', export_one.kind);
}

cb_inst.exports.exported_func();
assertEquals(42, t);
