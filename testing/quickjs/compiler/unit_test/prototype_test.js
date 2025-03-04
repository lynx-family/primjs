// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

function b(e, t, r) {
    return t && k(e.prototype, t), r && k(e, r), Object.defineProperty(e, "prototype", {
	writable: 1,
    }), e
}

function y(e, t) {
    if (!(e instanceof t)) throw new TypeError("Cannot call a class as a function")
	console.log(e.prototype);
}

var gs = b((function e() {
    var t = this;
    y(this, e);
}));

var bs = new gs;