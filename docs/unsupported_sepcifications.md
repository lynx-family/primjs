# Specifications not supported by PrimJS

| specials              | supported               |
| --------------------- | ----------------------- |
| BigInt                | NO                      |
| Atomic                | NO                      |
| RegExp.$0..9          | NO                      |
| Html comment          | NO                      |
| DataView              | Partial supported       |
| Realm                 | NO                      |
| import.meta           | NO                      |
| import                | Partially not supported |
| [[IsHTMLDDA]]         | Partially not supported |
| async/promise         | Partially not supported |
| super long identifier | Partially not supported |
| special unicode       | Partially not supported |
| emoji                 | Partially not supported |

##  Special unsupported specification Or use cases that can go wrong

### call escape/unescape on null/undefined

```js
escape(null);
unescape(undefined);
```

### Syntax error caused by parameter redefinition of catch block

```js
try {
  throw null;
} catch (err) {
  eval('for (var err of []) {}'); // Syntax error
}
```

### Redefining a function causes a syntax error

```js
let x;
switch (x) {
  case 1:
    function a() {}
  case 2:
    function a() {} // Syntax error
}
```

### When assigning a value or defineProperty, the timing of casting or inspecting the assigned property is not compliant with the specification

```js
var date = new Date(NaN);
date.setDate(arg); // Specification: Convert args to numbers first; QJS: Determine whether date is NaN first instead of checking arg first
```

```js
Object.defineProperty([], 'length', { configurable: true, value: -1 });
// spec: Determine that -1 cannot be the length of an array and raise "RangeError"
// qjs: Determine that the configurable attribute of the length attribute descriptors is false, and raise "TypeError"
```

### Operating on the DetachedArrayBuffer may cause an exception to be thrown incorrectly

```js
// arr is a detached array buffer
console.log(arr.byteLength); //spec: the result is 0; Qjs: throw an exception
// Any operation made to the arr may cause an exception to be thrown, and these operations may be silently ignored in the specification
```

### Error cannot be correctly thrown when toString is executed on Number, Boolean, String and Symbol value;

```js
// v = 1, false, 'string', Symbol()
Error.prototype.toString.call(v);
// Failed to throw an error correctly
```

### In some cases, the length value of the function produced by bind() may be incorrect.

```js
function foo() {}
Object.defineProperty(foo, 'length', { value: Symbol('1') });
console.log(foo.bind(null, 1).length); // The default output should be 0, but qjs generates errors;

Object.defineProperty(foo, 'length', { value: Infinity });
console.log(fn.bind().length); // qjs cannot print Infinity correctly;
```

### Function.prototype.caller's get and set properties are not correctly identified as the same function.

```js
var f = Function.prototype;
var d = Object.getOwnPropertyDescriptor(f, 'caller');
Object.is(d.set, d.get);
// Should print true, but qjs outputs false.
```

### When the space parameter of JSON.stringify is not empty, the first line does not add spaces correctly.

```js
var obj = {a1: [1]};
console.log(JSON.stringify(obj, null, '  '));
// expected:
{
  "a1": [
    1
  ]
}
// actual:
{
"a1": [  // no space before "a1"
  1
]
}
```

### Proxy containing a key of type symbol may cause an error

```js
var target = {};
var sym = Symbol();
target[sym] = 1;

var getOwnKeys = [];
var proxy = new Proxy(target, {
  getOwnPropertyDescriptor: function (_target, key) {
    getOwnKeys.push(key);
  },
});

Object.defineProperties({}, proxy);
// getOwnKeys is empty, because the symbol type key was not passed to the Proxy correctly;
```

### `Proxy.ownKeys` cannot correctly throw an error when it's redefined so that an array of keys of a particular type is not returned.

```js
var target = {};
var symbol = Symbol(); // It has the same effect if it's a string or a non-numerable key
Object.defineProperty(target, symbol, {
  value: 1,
  writable: true,
  enumerable: true,
  configurable: false,
});

var proxy = new Proxy(target, {
  ownKeys: function () {
    return [];
  },
});

Object.getOwnPropertyNames(proxy);
// Because the return value of ownKeys is not canonical, an error should be thrown here; QJS does not recognize it correctly, so it is thrown without error
```

### When `[[preventExtensions]]` is false, Object.freeze/seal/preventExtensions cannot raise an error correctly.

```js
const p = new Proxy(
  {},
  {
    preventExtensions() {
      return false;
    },
  },
);

// Any of the following should throw an exception, and QJS failed to correctly recognize and throw an exception
Object.freeze(p);
Object.seal(p);
Object.preventExtensions(p);
```

### The `name` property of some special functions/constructor function/anonymous function may be undefined and causes error.

```js
var rejectFunction;
new Promise(function (resolve, reject) {
  rejectFunction = reject; // Promise has the same effect
});

// The following values of name should be defined as empty strings.
// Qjs does not define them, so an error may be thrown;
rejectFunction.name;
Object.getOwnPropertyDescriptor(function () {}, 'name');
Object.getOwnPropertyDescriptor(() => {}, 'name');
```

### `Reflect.apply()` cannot correctly throw an exception when the argument is void/null/undefined.

```js
// None of the following cannot raise TypeError correctly.
Reflect.apply(fn, null /* empty */);
Reflect.apply(fn, null, null);
Reflect.apply(fn, null, undefined);
```

### Deleting `prototype[Symbol.iterator]` may not perform as well as expected.

```js
delete Array.prototype[Symbol.iterator];
for (let i = 0; i < 5; ++i) {
  Object.defineProperty(Array.prototype, i, {
    get: function () {
      // Expect no output, actually qjs has output
      console.log(i + 'Getter should be unreachable');
    },
    set: function (_value) {
      console.log(i + ' setter should be unreachable.'); // Same as above
    },
  });
}
console.log(/a/[Symbol.replace]('1a2', '$`b')); // expected output: 11b2
```

### The sorting algorithm is unstable.

```js
var array = [1, 2, 3, 4];
const compare = (a, b) => ((a / 4) | 0) - ((b / 4) | 0);
array.sort(); // The result may not be [1, 2, 3, 4]
```

### `Reflect` returns an incorrect value when using `Reflect.set` special subscripts on `TypedArray`.

```js
var sample = new TA([42]);
Reflect.set(sample, '-1', 1); //-0 and double have same effect.
// The specification should place the value at the default subscript 0 and return true; Qjs correctly places the value at 0, but returns false.
```

### Redefining variable/function/class/array/asynchronous function within a block doesn't correctly determine syntax errors;

```js
{
  {
    var f;
  }
  const f = 0;
}
{
  {
    var f;
  }
  class f {}
}
{
  {
    var f;
  }
  async function f() {}
}
// None of the above can correctly determin syntax error.
```

### Function.length may return an error value when an array/class parameter is passed.

```js
console.log((([a, b]) => {}).length); // expected output is 1, qjs's output is 0.
console.log((({ a, b }) => {}).length); // expected output is 1, qjs's output is 0.
```

### In strict mode, various operations on variables or properties of the same name in different scopes (especially global this) can be confused.

```js
'use strict';
var count = 0;
Object.defineProperty(this, 'x', {
  // global this
  configurable: true,
  get: function () {
    delete this.x; // (*)
    return 2;
  },
});

// Each of the following operations should throw an exception (x is removed at the line of code marked *),
// Qjs failed to throw an exception and obfuscates the variable name.
x += 1;
x++;
++x;
x = 3;
```

### The '=' expression at both ends of the assignment-statement is executed in a noncanonical order.

```js
var base = null;
var prop = {
  toString: function () {
    console.log('prop');
  },
};
var expr = function () {
  console.log('expr');
};

base[prop] = expr();
// According to the specification, in this case, expr() should be executed before prop's check; But Qjs Checks prop first.
// The same out-of-order problem can occur with other assignment statements
```

### Syntax-errors cannot be correctly determined when a function or generator internally defines a variable with the same name as a parameter.

```js
function f(a) {
  let a;
} // Qjs fails to determine syntax error.
```

### The static function/assignment-statement in the class may be executed at the wrong time.

```js
var className;
var C = class {
  static f = (className = this.name);
};
console.log(className); // Qjs outputs "undefined" instead of "C"
```

### Syntax errors cannot be correctly determined when inheriting an anonymous class or a class with a private name

```js
var C = class extends () => {} {};  //Qjs fails to determine syntax error.
```

### Exceptions cannot be thrown correctly when delete null/undefined property.

```js
var base = null;
delete base[0];
delete base.happy;
var base = undefined;
delete base[0][0];
// None of the above deletes correctly raise TypeError.
```

### The returned value is incorrect when non-reference is removed.

```js
delete 'Test262'[100]; // Except to return true, but qjs returns false.
```

### An exception cannot be thrown correctly when a subclass removes a base class property.

```js
class X {
  another() {
    console.log('!');
  }
  method() {
    return this;
  }
}
class Y extends X {
  method() {
    delete super.another;
  }
}
const y = new Y();
y.method(); // no exception be raised
y.another(); // qjs has outputs here.
```

### When Proxy is called, proxy.get may not be called in the proper order

```js
var dontEnumKeys = ['dontEnumString', '0'];
var enumerableKeys = ['enumerableString', '1'];
var ownKeysResult = [...dontEnumKeys, ...enumerableKeys];

var getKeys = [];
var proxy = new Proxy(
  {},
  {
    getOwnPropertyDescriptor: function (_target, key) {
      var isEnumerable = enumerableKeys.indexOf(key) !== -1;
      return {
        value: VALUE,
        writable: false,
        enumerable: isEnumerable,
        configurable: true,
      };
    },
    get: function (_target, key) {
      getKeys.push(key);
      return VALUE_GET;
    },
    ownKeys: function () {
      return ownKeysResult;
    },
  },
);

var { ...rest } = proxy; // call proxy
console.log(getKeys);
// The output order (that is, the order in which get is called) is reversed from the correct order.
```

### A number separator followed by a decimal point cannot be correctly identified as a syntax error.

```js
10._1; // Qjs cannot correctly judge Syntax Error.
```

### The getter and the setter have different static attributes and the syntax error cannot be correctly determined.

```js
class C {
  static set #f(v) {}
  get #f() {}
}
//  Qjs cannot correctly judge Syntax Error.
```

### Asynchronous functions and generators may escape the local environment created by the switch.

```js
switch (0) {
  default:
    function* x() {}
} // The async function has the same effect.
x; // Qjs cannot correctly raise a Reference-Error, which means that objects created in the switch env are beging used by the outside  scope.
```
