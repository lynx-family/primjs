// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

(function() {
    function check(value, expected) {
        if (String(value) !== expected || "" + value !== expected ||
            `${value}` !== expected)
            throw new Error("integer string conversion: " + expected);
        var object = {};
        object[value] = 42;
        if (Object.keys(object)[0] !== expected || object[expected] !== 42)
            throw new Error("integer property key: " + expected);
    }

    var cases = [
        [0, "0"], [-0, "0"], [1, "1"], [-1, "-1"],
        [9, "9"], [10, "10"], [99, "99"], [100, "100"],
        [999, "999"], [1000, "1000"], [9999, "9999"],
        [10000, "10000"], [99999, "99999"], [100000, "100000"],
        [999999, "999999"], [1000000, "1000000"],
        [9999999, "9999999"], [10000000, "10000000"],
        [99999999, "99999999"], [100000000, "100000000"],
        [999999999, "999999999"], [1000000000, "1000000000"],
        [2147483647, "2147483647"], [-2147483648, "-2147483648"],
        [2147483648, "2147483648"], [-2147483649, "-2147483649"]
    ];
    for (var entry of cases) {
        check(entry[0], entry[1]);
        if (entry[0] > 0) check(-entry[0], "-" + entry[1]);
    }

    var state = 123456789;
    for (var i = 0; i < 2000; i++) {
        state = (Math.imul(state, 1664525) + 1013904223) | 0;
        var text = String(state);
        if (Number(text) !== state || text !== state.toString(10))
            throw new Error("int32 decimal round trip");
    }

    check(1.5, "1.5");
    check(NaN, "NaN");
    check(Infinity, "Infinity");
    check(-Infinity, "-Infinity");
    check(2147483647n, "2147483647");
    var calls = 0;
    if (String({toString: function() { calls++; return -2147483648; }}) !==
            "-2147483648" || calls !== 1)
        throw new Error("object primitive conversion");
})();
