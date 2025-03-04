// Copyright 2018 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
function Assert(arg) {
  if(!arg)throw 'assertion failed';
}
function assertUnreachable(){
  Assert(false);
}

function assertMatches(a,b){
  Assert(b.match(a)!=null);
}

function assertEquals(a,b){
  Assert(a==b);
}

function assertPromiseResult(func){
  func;
}


// Basic test with an explicit throw.
(function() {
  async function one(x) {
    await two(x);
  }

  async function two(x) {
    await x;
    throw new Error();
  }

  async function test(f) {
    try {
      await f(1);
      assertUnreachable();
    } catch (e) {
      assertMatches(/at two.+at \(async\)one.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async () => {
    await test(one);
    await test(one);
  })());
})();

// Basic test with an implicit throw (via ToNumber on Symbol).
(function() {
  async function one(x) {
    return await two(x);
  }

  async function two(x) {
    await x;
    return +x;  // This will raise a TypeError.
  }

  async function test(f) {
    try {
      await f(Symbol());
      assertUnreachable();
    } catch (e) {
      assertMatches(/at two.+at \(async\)one.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async() => {
    await test(one);
    await test(one);
  })());
})();

// Basic test with throw in inlined function.
(function() {
  function throwError() {
    throw new Error();
  }

  async function one(x) {
    return await two(x);
  }

  async function two(x) {
    await x;
    return throwError();
  }

  async function test(f) {
    try {
      await f(1);
      assertUnreachable();
    } catch (e) {
      assertMatches(/at two.+at \(async\)one.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async() => {
    await test(one);
    await test(one);
  })());
})();

// Basic test with async function inlined into sync function.
(function() {
  function callOne(x) {
    return one(x);
  }

  function callTwo(x) {
    return two(x);
  }

  async function one(x) {
    return await callTwo(x);
  }

  async function two(x) {
    await x;
    throw new Error();
  }

  async function test(f) {
    try {
      await f(1);
      assertUnreachable();
    } catch (e) {
      assertMatches(/at two.+at \(async\)one.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async() => {
    await test(callOne);
    await test(callOne);
  })());
})();

// Basic test with async functions and promises chained via
// Promise.prototype.then(), which should still work following
// the generic chain upwards.
(function() {
  async function one(x) {
    return await two(x).then(x => x);
  }

  async function two(x) {
    await x.then(x => x);
    throw new Error();
  }

  async function test(f) {
    try {
      await f(Promise.resolve(1));
      assertUnreachable();
    } catch (e) {
      assertMatches(/at two.+at \(async\)one.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async() => {
    await test(one);
    await test(one);
  })());
})();

// Basic test for async generators called from async
// functions with an explicit throw.
(function() {
  async function one(x) {
    for await (const y of two(x)) {}
  }

  async function* two(x) {
    await x;
    throw new Error();
  }

  async function test(f) {
    try {
      await f(1);
      assertUnreachable();
    } catch (e) {
      assertMatches(/at two.+at \(async\)one.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async () => {
    await test(one);
    await test(one);
  })());
})();

// Basic test for async functions called from async
// generators with an explicit throw.
(function() {
  async function* one(x) {
    await two(x);
  }

  async function two(x) {
    await x;
    throw new Error();
  }

  async function test(f) {
    try {
      for await (const x of f(1)) {}
      assertUnreachable();
    } catch (e) {
      assertMatches(/at two.+at \(async\)one.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async () => {
    await test(one);
    await test(one);
  })());
})();

// Basic test for async functions called from async
// generators with an explicit throw (with yield).
(function() {
  async function* one(x) {
    yield two(x);
  }

  async function two(x) {
    await x;
    throw new Error();
  }

  async function test(f) {
    try {
      for await (const x of f(1)) {}
      assertUnreachable();
    } catch (e) {
      assertMatches(/at two.+at \(async\)one.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async () => {
    await test(one);
    await test(one);
  })());
})();

// Basic test to check that we also follow initial
// promise chains created via Promise#then().
(function() {
  async function one(p) {
    return await p.then(two);
  }

  function two() {
    throw new Error();
  }

  async function test(f) {
    try {
      await f(Promise.resolve());
      assertUnreachable();
    } catch (e) {
      assertMatches(/at two.+at \(async\)one.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async () => {
    await test(one);
  })());
})();

// Basic test for reject.
(function() {
  async function one(x) {
    await two(x);
  }

  async function two(x) {
    try {
      await Promise.reject(new Error());
      assertUnreachable();
    } catch (e) {
      throw new Error();
    }
  }

  async function test(f) {
    try {
      await f(1);
      assertUnreachable();
    } catch (e) {
      assertMatches(/at two.+at \(async\)one.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async () => {
    await test(one);
  })());
})();

(function() {
  async function fine() { }

  async function thrower() {
    await fine();
    throw new Error();
  }

  async function driver() {
    await Promise.all([fine(), fine(), thrower(), thrower()]);
  }

  async function test(f) {
    try {
      await f();
      assertUnreachable();
    } catch (e) {
      assertMatches(/at thrower.+at \(async\)Promise.all. +at \(async\)driver.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async () => {
    await test(driver);
    await test(driver);
  })());
})();

// Promise.all
(function() {
  async function fine() { }

  async function thrower() {
    await fine();
    throw new Error();
  }

  async function driver() {
    await Promise.all([fine(), fine(), thrower(), thrower()]);
  }

  async function test(f) {
    try {
      await f();
      assertUnreachable();
    } catch (e) {
      assertMatches(/at thrower.+at \(async\)Promise.all. +at \(async\)driver.+at \(async\)test/ms, e.stack);
    }
  }

  assertPromiseResult((async () => {
    await test(driver);
  })());
})();

// Basic test with Promise.any().
(function() {
  async function fine() { }

  async function thrower() {
    await fine();
    throw new Error();
  }

  async function driver() {
    await Promise.any([thrower(), thrower()]);
  }

  async function test(f) {
    try {
      await f();
      assertUnreachable();
    } catch (e) {
      assertEquals(2, e.errors.length);
      assertMatches(/at thrower.+at \(async\)Promise.any. +at \(async\)driver.+at \(async\)test/ms, e.errors[0].stack);
      assertMatches(/at thrower.+at \(async\)Promise.any. +at \(async\)driver.+at \(async\)test/ms, e.errors[1].stack);
    }
  }

  assertPromiseResult((async () => {
    await test(driver);
  })());
})();

// Basic test with Promise.allSettled().
(function() {
  async function fine() { }

  async function thrower() {
    await fine();
    throw new Error();
  }

  async function driver() {
    return await Promise.allSettled([fine(), fine(), thrower(), thrower()]);
  }

  async function test(f) {
    const results = await f();
    results.forEach((result, i) => {
      if (result.status === 'rejected') {
        const error = result.reason;
        assertMatches(/at thrower.+at \(async\)Promise.allSettled.+at \(async\)driver.+at \(async\)test/ms, error.stack);
      }
    });
  }

  assertPromiseResult((async () => {
    await test(driver);
  })());
})();