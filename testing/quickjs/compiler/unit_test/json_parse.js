// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

try {
    let str = "¢";
    let str1 = "\"" + str;
    JSON.parse(str1); 
} catch(e) {
    console.log(e);
}