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

let f = null;
async function closure_call(val) {
  let closure_val = [];
  function foo1(val) {
    closure_val.push(val);
  }
  return foo1;
}

function top_level() {
  async function inner_top_level(val) {
    const result = await closure_call(val);
    f = result;
  }
  inner_top_level();
}

top_level();

async function resolveAfter2Seconds() {
  // console.log("resolveAfter2Seconds");
}

async function asyncCall() {
  const result = await resolveAfter2Seconds();
  lepusng_gc();
  f(2);
}

asyncCall();
