// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

foo = () => {
  return new Promise((_, reject) => {
    reject("NO");
  });
};

foo();

console.log("first");

bar = () => {
  return new Promise((_, reject) => reject(new Error("woops"))).then(() => {
    console.log("fufill");
  });
};

bar();

console.log("second");


