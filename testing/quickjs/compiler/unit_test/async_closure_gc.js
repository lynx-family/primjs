// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

(async function run() {
  let obj = { test_prop: true };

  let done = () => {
    console.log("before obj");
    obj;
    console.log("after obj");
  };


  Promise.resolve().then(done);

  const p = new Promise(() => {});

  console.log("before await");
  await p;
  console.log("after await");
})();
// force gc
gc();
