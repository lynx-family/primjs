// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

var toString = Object.prototype.toString;
function Assert(arg) {
    if(!arg)throw 'assertion failed';
}
function isFunction(obj) {
    return toString.call(obj) === '[object Function]'
}

function eq(a, b, aStack, bStack) {

    if (a === b) return a !== 0 || 1 / a === 1 / b;

    if (a == null || b == null) return false;

    if (a !== a) return b !== b;

    var type = typeof a;
    if (type !== 'function' && type !== 'object' && typeof b != 'object') return false;

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

function check(a)
{
  return eq(structuredClone(a),a);
}

// Create an object with a value and a circular reference to itself.
const obj = {
  arr: [],
  boolean: true,
  number: 123,
  string: '',
  undefined: void 0,
  null: null,
  int: new Uint32Array([1, 2, 3]),
  map: new Map([['a', 123]]),
  set: new Set(['a', 'b']),
  Bool: new Boolean(false),
  Num: new Number(0),
  Str: new String(''),
  re: new RegExp('test', 'gim'),
  error: new Error('test'),
  date: new Date()
};
const original = { name: "TEST" };
// original.itself = original;
original.err=new Error();
original.err.name=1;

Assert(check(original)===false);//this one should be false:   err.name:="Error" after clone

const clone = structuredClone(original);

Assert(clone !== original); // the objects are not the same (not same identity)
Assert(clone.name === "TEST"); // they do have the same values
// Assert(clone.itself === clone); // and the circular reference is preserved current not supported
Assert(clone.err.name==="Error");
Assert(structuredClone()===undefined); //ok undefined 
let failed =0;
try{
structuredClone(1,1);//ok more arguments will cause error
}catch{
  failed =1;
}
Assert(failed==1);
Assert(check(obj));
cloned=structuredClone(obj);


