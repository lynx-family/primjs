// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

var toString = Object.prototype.toString;
function Assert(arg) {
    if (!arg) throw new TypeError('assertion failed');
}
function isFunction(obj) {
    return toString.call(obj) === '[object Function]'
}

function eq(a, b, aStack, bStack) {

    if (a === b) return a !== 0 || 1 / a === 1 / b;

    if (a == null || b == null) return false;

    if (a !== a) return b !== b;

    var type = typeof a;
    if (type !== 'function' && type !== 'object' && typeof b != 'object') {
        return false;
    }

    return deepEq(a, b, aStack, bStack);
};

function deepEq(a, b, aStack, bStack) {

    var className = toString.call(a);
    if (className !== toString.call(b)) return false;

    switch (className) {
        case '[object RegExp]':
        case '[object String]':
            return '' + a === '' + b;
        case '[object Number]':
            if (+a !== +a) return +b !== +b;
            return +a === 0 ? 1 / +a === 1 / b : +a === +b;
        case '[object Date]':
        case '[object Boolean]':
            return +a === +b;
    }

    var areArrays = className === '[object Array]';
    if (!areArrays) {
        if (typeof a != 'object' || typeof b != 'object') return false;

        var aCtor = a.constructor,
            bCtor = b.constructor;
        if (aCtor !== bCtor && !(isFunction(aCtor) && aCtor instanceof aCtor && isFunction(bCtor) && bCtor instanceof bCtor) && ('constructor' in a && 'constructor' in b)) {
            return false;
        }
    }


    aStack = aStack || [];
    bStack = bStack || [];
    var length = aStack.length;

    while (length--) {
        if (aStack[length] === a) {
            return bStack[length] === b;
        }
    }

    aStack.push(a);
    bStack.push(b);

    if (areArrays) {

        length = a.length;
        if (length !== b.length) return false;

        while (length--) {
            if (!eq(a[length], b[length], aStack, bStack)) return false;
        }
    }
    else {

        var keys = Object.keys(a),
            key;
        length = keys.length;

        if (Object.keys(b).length !== length) return false;
        while (length--) {

            key = keys[length];
            if (!(b.hasOwnProperty(key) && eq(a[key], b[key], aStack, bStack))) return false;
        }
    }

    aStack.pop();
    bStack.pop();
    return true;

}

function check(a) {
    return eq(structuredClone(a), a);
}



const original = { name: "TEST" };
original.itself = original;


Assert(check(original) === true);//this one should be false:   err.name:="Error" after clone
const clone = structuredClone(original);

Assert(clone !== original); // the objects are not the same (not same identity)
Assert(clone.name === "TEST"); // they do have the same values
Assert(clone.itself === clone); // and the circular reference is preserved
Assert(clone.itself != original.itself)

Assert(structuredClone(undefined) === undefined); //ok undefined 
let failed = 0;
try {
    structuredClone(1, 1);//ok more arguments will cause error
} catch {
    failed = 1;
}
Assert(failed == 0);

// Create an object with a value and a circular reference to itself.
let obj = {
    arr: [],
    boolean: true,
    number: 123,
    string: '',
    undefined: void 0,
    null: null,
    int: new Uint32Array([1, 2, 3]),
    Bool: new Boolean(false),
    Num: new Number(0),
    Str: new String('structuredCloneString'),
    date: new Date(),
    fast_array: [],
    slow_array: []
};

obj.fast_array = [1, 2, 3, 4]
obj.slow_array.length = 5;
obj.slow_array[1] = "slow_array_ele_1";
Assert(check(obj));
cloned = structuredClone(obj);

Assert(cloned.fast_array.length == 4)

for (let i = 0; i < cloned.fast_array.length; ++i) {
    Assert(cloned.fast_array[i] == i + 1);
}
Assert(cloned.slow_array.length == 5)
Assert(cloned.slow_array[0] == undefined)
Assert(cloned.slow_array[1] == "slow_array_ele_1")
Assert(cloned.Str.length == 'structuredCloneString'.length)
Assert(cloned.Str == "structuredCloneString")

Assert(JSON.stringify(cloned) == JSON.stringify(obj))

// Test BytedArray And Buffer

let buffer = new ArrayBuffer(16);
let buffer2 = new ArrayBuffer(32);

let ta1 = new Uint16Array(buffer);
let ta2 = new Uint32Array(buffer2);
let ta3 = new Uint16Array(ta1)
let ta4 = new Uint32Array(ta2);



let subobj = {
    a: 10,
    b: 20
};


obj = {
    a: buffer,
    b: buffer2,
    c: buffer,
    d: buffer2,
    e: ta1,
    f: ta2,
    g: ta3,
    h: ta4,
    i: ta2,
    aa: subobj,
    bb: subobj
};
let res = structuredClone(obj);

Assert(obj != res)

Assert(obj.a != res.a)

Assert(res.a == res.c)
Assert(res.b == res.d)
Assert(res.aa == res.bb)
Assert(res.f == res.i)

Assert(res.h != obj.h)

Assert(res.e.buffer == res.a)

Assert(res.h.buffer != res.d)

Assert(res.i != res.h)

Assert(res.h.buffer != res.i.buffer)

