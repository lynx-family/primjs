// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

(function() {
    function check(input, oldValue, incremented, decremented) {
        // Property updates retain the postfix result and exercise both opcodes.
        var box = {value: input};
        var result = box.value++;
        if (!Object.is(result, oldValue) || !Object.is(box.value, incremented))
            throw new Error("postfix increment: " + String(input));
        box.value = input;
        result = box.value--;
        if (!Object.is(result, oldValue) || !Object.is(box.value, decremented))
            throw new Error("postfix decrement: " + String(input));
    }

    check(0, 0, 1, -1);
    check(-0, -0, 1, -1);
    check(41, 41, 42, 40);
    check(-41, -41, -40, -42);
    check(2147483647, 2147483647, 2147483648, 2147483646);
    check(-2147483648, -2147483648, -2147483647, -2147483649);
    check(1.5, 1.5, 2.5, 0.5);
    check(NaN, NaN, NaN, NaN);
    check(Infinity, Infinity, Infinity, Infinity);
    check("41", 41, 42, 40);
    check(true, 1, 2, 0);
    check(null, 0, 1, -1);
    check(undefined, NaN, NaN, NaN);
    check(41n, 41n, 42n, 40n);

    var calls = 0;
    check({valueOf: function() { calls++; return 41; }}, 41, 42, 40);
    if (calls !== 2) throw new Error("postfix conversion count");
    check({[Symbol.toPrimitive]: function() { return 41n; }}, 41n, 42n, 40n);

    var sentinel = {};
    for (var decrement of [false, true]) {
        var box = {value: {valueOf: function() { throw sentinel; }}};
        var original = box.value;
        try {
            if (decrement) box.value--; else box.value++;
            throw new Error("missing conversion exception");
        } catch (error) {
            if (error !== sentinel || box.value !== original) throw error;
        }
        box.value = Symbol();
        try {
            if (decrement) box.value--; else box.value++;
            throw new Error("missing Symbol TypeError");
        } catch (error) {
            if (!(error instanceof TypeError)) throw error;
        }
    }
})();
