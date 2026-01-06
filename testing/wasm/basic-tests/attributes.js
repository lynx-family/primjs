// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

require('../test/mjsunit.js');

WebAssembly.Module = function () {
  return 1;
};

assertEquals(1, WebAssembly.Module());

delete globalThis.WebAssembly;

console.log('basic-tests: attributes.js passed');
