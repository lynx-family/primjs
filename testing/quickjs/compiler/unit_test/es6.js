// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.


(function() {
    var proxied = function () {
    };
    var passed = false;
    new new Proxy(proxied, {
        construct: function (t, args) {
            passed = t === proxied && args + "" === "foo,bar";
            return {};
        }
    })("foo", "bar");
    Assert(passed);
})();


(function() {
    var passed = false;
    new Proxy({}, {});
// A Proxy exotic object only has a [[Construct]] internal method if the
// initial value of its [[ProxyTarget]] internal slot is an object
// that has a [[Construct]] internal method.
    try {
        new new Proxy({}, {
            construct: function (t, args) {
                return {};
            }
        })();
        Assert(false);
    } catch (e) {
        Assert(true);
    }
})();

// The result of [[Construct]] must be an Object.
(function() {
    var passed = false;
    try {
        new new Proxy(function () {
        }, {
            construct: function (t, args) {
                passed = true;
                return 5;
            }
        })();
    } catch (e) {
    }
    Assert(passed);
})();

Assert(Math.hypot() === 0 &&
    Math.hypot(1) === 1 &&
    Math.hypot(9, 12, 20) === 25 &&
    Math.hypot(27, 36, 60, 100) === 125);


var a = [...[,,]];
Assert("0" in a && "1" in a && '' + a[0] + a[1] === "undefinedundefined");



function correctProtoBound(proto) {
    var f = function(){};
    Object.setPrototypeOf(f, proto);
    var boundF = Function.prototype.bind.call(f, null);
    //console.log(boundF);
    return Object.getPrototypeOf(boundF) === proto;
  }
  Assert(correctProtoBound(Function.prototype)
  && correctProtoBound({})
  && correctProtoBound(null));
  
  
  
  function correctProtoBound1(proto) {
    var f = function*(){};
    if (Object.setPrototypeOf) {
      Object.setPrototypeOf(f, proto);
    } else {
      f.__proto__ = proto;
    }
    var boundF = Function.prototype.bind.call(f, null);
    return Object.getPrototypeOf(boundF) === proto;
  }
  Assert(correctProtoBound1(Function.prototype)
      && correctProtoBound1({})
      && correctProtoBound1(null));
  
  function correctProtoBound2(proto) {
    var f = ()=>5;
    if (Object.setPrototypeOf) {
      Object.setPrototypeOf(f, proto);
    } else {
      f.__proto__ = proto;
    }
    var boundF = Function.prototype.bind.call(f, null);
    return Object.getPrototypeOf(boundF) === proto;
  }
  Assert(correctProtoBound2(Function.prototype)
      && correctProtoBound2({})
      && correctProtoBound2(null));
  
  
  function correctProtoBound3(proto) {
    class C {}
    if (Object.setPrototypeOf) {
      Object.setPrototypeOf(C, proto);
    } else {
      C.__proto__ = proto;
    }
    var boundF = Function.prototype.bind.call(C, null);
    return Object.getPrototypeOf(boundF) === proto;
  }
  Assert(correctProtoBound3(Function.prototype)
      && correctProtoBound3({})
      && correctProtoBound3(null));
  
  function correctProtoBound4(superclass) {
    class C extends superclass {
      constructor() {
        return Object.create(null);
      }
    }
    var boundF = Function.prototype.bind.call(C, null);
    return Object.getPrototypeOf(boundF) === Object.getPrototypeOf(C);
  }
  Assert(correctProtoBound4(function(){})
      && correctProtoBound4(Array)
      && correctProtoBound4(null));


Assert(/x{1/.exec("x{1")[0] === "x{1" && /x]1/.exec("x]1")[0] === "x]1");