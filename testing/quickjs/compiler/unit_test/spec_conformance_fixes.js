// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// Regression cases for a group of parser and builtin fixes. Every case
// compares against the result required by ECMAScript.

function check(name, actual, expected) {
  const a = JSON.stringify(actual);
  const e = JSON.stringify(expected);
  if (a !== e) throw new Error(`${name}: got ${a}, expected ${e}`);
}

function errorName(f) {
  try {
    f();
  } catch (e) {
    return e.name;
  }
  return "none";
}

function syntax(src) {
  try {
    (0, eval)(src);
  } catch (e) {
    return e.name;
  }
  return "ok";
}

// Object spread copies the own properties of a primitive wrapper.
check("spread string", { ..."ab" }, { 0: "a", 1: "b" });
check("spread mixed", { ...5, ...true, ..."x", ...null, ...undefined },
      { 0: "x" });
check("rest of string", (() => { const { a, ...r } = "xyz"; return r; })(),
      { 0: "x", 1: "y", 2: "z" });

// A negative BigInt compared with a negative Number.
check("bigint < float",
      [-0.5 < -1n, -1n > -0.5, -2147483648 < -1n, -1e30 < -1n,
       -(2n ** 200n) < -1e30, -1.5 < -1n, -1n < -0.5, 0.5 < 1n],
      [false, false, true, true, true, true, true, true]);

// Member access on a non decimal literal.
check("0x10.toString()", eval("0x10.toString()"), "16");
check("0b11.toString()", eval("0b11.toString()"), "3");
check("0o17.valueOf()", eval("0o17.valueOf()"), 15);
check("0x1.a", String(eval("0x1.a")), "undefined");
check("1.5e2", eval("1.5e2"), 150);
check("0x1p3", syntax("0x1p3"), "SyntaxError");

// The well-known symbol methods are only read from objects.
(() => {
  const proto = Number.prototype;
  proto[Symbol.replace] = proto[Symbol.split] = proto[Symbol.match] =
      () => "X";
  try {
    check("replace(1)", "a1b".replace(1, "Z"), "aZb");
    check("split(1)", "a1b".split(1), ["a", "b"]);
    check("match(1)", "a1b".match(1)[0], "1");
  } finally {
    delete proto[Symbol.replace];
    delete proto[Symbol.split];
    delete proto[Symbol.match];
  }
  check("replace(obj)",
        "a".replace({ [Symbol.replace]() { return "obj"; } }, ""), "obj");
})();

// A '/' after a template or a private name is a division when the parser
// looks ahead for an arrow function.
check("div after template",
      eval('var f1 = (a = `x` / 2, b = ")") => b; f1()'), ")");
check("div after template tail",
      eval('var f2 = (a = `q${1}w` / 2, b = ")") => b; f2()'), ")");
check("regexp in template",
      eval('var f3 = (a = `p${/[)]/.test(")")}q${6 / 3}r`, b = "(") => ' +
           'a + b; f3()'),
      "ptrueq2r(");
check("div after private name",
      eval('class P { #x = 4; m() { return ((a = this.#x / 2, b = ")") => ' +
           'a + b)(); } }; new P().m()'),
      "2)");

// "get" and "set" as class field names.
check("get/set fields",
      eval("class A { get\n *x() { yield 1; } }\n" +
           "class B { set\n *x() {} }\n" +
           "class C { get = 3; set; }\n" +
           "var c = new C();" +
           "[typeof new A().x, 'get' in new A(), typeof new B().x, c.get, " +
           "'set' in c]"),
      ["function", true, "function", 3, true]);
check("accessors still work",
      eval("class D { get x() { return 7; } set x(v) {} get() { return 8; } }" +
           "; [new D().x, new D().get()]"),
      [7, 8]);

// Completion value of try statements.
check("empty catch",
      [eval("1; try { 2; throw 1 } catch (e) {}"),
       eval("1; try { 2; throw 1 } catch {}"),
       eval("1; try { 2 } catch (e) {}"),
       eval("1; try { 2; throw 1 } catch (e) { 3 }"),
       eval("1; try { 2; throw 1 } catch (e) {} finally { 4 }"),
       eval("1; try {} catch (e) {}")].map(String),
      ["undefined", "undefined", "2", "3", "undefined", "undefined"]);

// "\x" takes exactly two hexadecimal digits.
check("\\x{N} unicode", errorName(() => new RegExp("\\x{41}", "u")),
      "SyntaxError");
check("\\x in string", syntax('"\\x{41}"'), "SyntaxError");
check("valid escapes",
      [/\x41/.test("A"), /\x41/u.test("A"), /\u{41}/u.test("A"),
       /A/.test("A"), "\x41\u{42}C", /\x{2}/.test("xx")],
      [true, true, true, true, "ABC", true]);

// Proxy ownKeys must return an object.
check("ownKeys primitive",
      [1, "abc", true].map(
          (v) => errorName(() => Object.keys(new Proxy({}, {
            ownKeys() { return v; }
          })))),
      ["TypeError", "TypeError", "TypeError"]);

// Array.prototype.sort writes every element back and always calls the
// comparison function.
check("sort frozen", errorName(() => Object.freeze([1, 2]).sort()),
      "TypeError");
check("sort string", errorName(() => Array.prototype.sort.call("aa")),
      "TypeError");
(() => {
  const log = [];
  const p = new Proxy([1, 1, 1], {
    set(t, k, v) { log.push(k); t[k] = v; return true; }
  });
  Array.prototype.sort.call(p);
  check("sort writes back", log, ["0", "1", "2"]);
  let calls = 0;
  const o = {};
  [o, o, o].sort(() => { calls++; return 0; });
  check("sort same value", calls >= 2, true);
  check("sort result", [5, 1, 5, 3, 1].sort((a, b) => a - b), [1, 1, 3, 5, 5]);
  check("sort holes", String([3, , 1, undefined, 2].sort()), "1,2,3,,");
})();

// A failed definition does not change the length of a non extensible array.
(() => {
  const o = [1, , 3];
  Object.preventExtensions(o);
  const f = [1, 2];
  Object.preventExtensions(f);
  check("defineProperty non extensible",
        [Reflect.defineProperty(o, 7, { value: 1 }), o.length,
         Reflect.defineProperty(f, 2, { value: 1 }), f.length],
        [false, 3, false, 2]);
})();

// Spread reads @@iterator once.
(() => {
  let count = 0;
  const o = {
    get [Symbol.iterator]() {
      count++;
      return function* () { yield 1; yield 2; };
    }
  };
  check("spread", [[...o], [0, ...o], count], [[1, 2], [0, 1, 2], 2]);
  check("spread non iterable", errorName(() => [...{}]), "TypeError");
})();

// String.prototype.repeat.
(() => {
  const empty = (v) => errorName(() => "".repeat(v));
  const len = (v) => {
    try {
      return "ab".repeat(v).length;
    } catch (e) {
      return e.name;
    }
  };
  check("repeat empty",
        [empty(Infinity), empty(-Infinity), empty(-1), empty(2 ** 40),
         empty(2147483648), empty(NaN)],
        ["RangeError", "RangeError", "RangeError", "none", "none", "none"]);
  check("repeat", [len(3), len(0), len(undefined), len("2"), len(1.9)],
        [6, 0, 0, 4, 2]);
  check("repeat too long", len(2 ** 40) !== 2 ** 41, true);
  check("repeat infinity", len(Infinity), "RangeError");
})();

// Function name inference in a for-in initializer.
check("for-in initializer name",
      eval("var g1, k1, a1;" +
           "for (var g1 = function() {} in {});" +
           "for (var k1 = class {} in {});" +
           "for (var a1 = () => {} in {});" +
           "[g1.name, k1.name, a1.name]"),
      ["g1", "k1", "a1"]);

// TypedArray.prototype.sort works on a copy of the elements.
(() => {
  const a = new Uint8Array([3, 2, 1, 5, 4]);
  a.sort((x, y) => { a[0] = 99; a[4] = 77; return x - y; });
  check("typed array sort", Array.from(a), [1, 2, 3, 4, 5]);
  check("typed array sort desc",
        Array.from(new Float64Array([3, 1, 2]).sort((x, y) => y - x)),
        [3, 2, 1]);
  check("typed array sort stable",
        Array.from(new Uint32Array([2, 1, 2, 1]).sort(() => 0)), [2, 1, 2, 1]);
  check("typed array sort throws",
        errorName(() => new Uint8Array([2, 1]).sort(() => {
          throw new RangeError("x");
        })),
        "RangeError");
})();

// Template literal substitutions are converted in order, without calling
// String.prototype.concat.
(() => {
  const log = [];
  const o = { toString() { log.push("o"); return "O"; } };
  check("template order", [`${o}${(log.push("next"), "n")}`, log],
        ["On", ["o", "next"]]);
  const c = { n: 0, toString() { return String(this.n); } };
  check("template side effect", `${c} ${c.n++}`, "0 0");
  const concat = String.prototype.concat;
  String.prototype.concat = () => "concat";
  try {
    check("template concat", `a${1}b${2}`, "a1b2");
  } finally {
    String.prototype.concat = concat;
  }
  check("template values",
        [`${1}${2}`, `a${null}b${undefined}c${true}`, `${1.5}x${10n}`,
         `${[1, 2]}|${{}}`, ``, `x`, `${"only"}`, `pre${1}`, `${1}post`,
         `${`in${1}ner`}!`],
        ["12", "anullbundefinedctrue", "1.5x10", "1,2|[object Object]", "",
         "x", "only", "pre1", "1post", "in1ner!"]);
  check("template symbol", errorName(() => `${Symbol("s")}`), "TypeError");
  check("template hint", `${{ [Symbol.toPrimitive](h) { return h; } }}`,
        "string");
  const tag = (s, ...v) => s.raw.join("|") + v.join(",");
  check("tagged template", tag`a${1}b${2}c`, "a|b|c1,2");
})();

// Proxy getOwnPropertyDescriptor invariants on values and accessors.
(() => {
  const t = {};
  Object.defineProperty(t, "x", { value: 1 });
  const trap = (d) => new Proxy(t, { getOwnPropertyDescriptor: () => d });
  const frozen = { configurable: false, writable: false };
  check("gopd other value",
        errorName(() => Object.getOwnPropertyDescriptor(
                      trap({ value: 2, ...frozen }), "x")),
        "TypeError");
  check("gopd same value",
        Object.getOwnPropertyDescriptor(trap({ value: 1, ...frozen }), "x")
            .value,
        1);
  const t2 = {};
  const getter = () => 5;
  Object.defineProperty(t2, "x", { get: getter });
  check("gopd other getter",
        errorName(() => Object.getOwnPropertyDescriptor(
                      new Proxy(t2, {
                        getOwnPropertyDescriptor: () =>
                            ({ get() {}, configurable: false })
                      }),
                      "x")),
        "TypeError");
  check("gopd same getter",
        errorName(() => Object.getOwnPropertyDescriptor(
                      new Proxy(t2, {
                        getOwnPropertyDescriptor: () =>
                            ({ get: getter, set: undefined, configurable: false })
                      }),
                      "x")),
        "none");
  // An accessor descriptor returned by the trap stays an accessor descriptor.
  const t3 = {};
  const setter = (v) => {};
  Object.defineProperty(t3, "x", { get: getter, configurable: true });
  Object.defineProperty(t3, "y", { get: getter, set: setter });
  const accessors = new Proxy(t3, {
    getOwnPropertyDescriptor: (o, k) =>
        k === "x" ? { get: getter, configurable: true } :
        k === "z" ? { set: setter, enumerable: true, configurable: true } :
                    { get: getter, configurable: false }
  });
  const dx = Object.getOwnPropertyDescriptor(accessors, "x");
  const dz = Reflect.getOwnPropertyDescriptor(accessors, "z");
  check("gopd accessor result",
        [Object.keys(dx), dx.get === getter, dx.set === undefined,
         dx.enumerable, dx.configurable, Object.keys(dz),
         dz.get === undefined, dz.set === setter, dz.enumerable],
        [["get", "set", "enumerable", "configurable"], true, true, false,
         true, ["get", "set", "enumerable", "configurable"], true, true,
         true]);
  // A missing "set" is undefined, which differs from the target's setter.
  check("gopd missing setter",
        errorName(() => Object.getOwnPropertyDescriptor(accessors, "y")),
        "TypeError");
})();

// Object.defineProperties reads all the descriptors before defining.
(() => {
  const log = [];
  const props = new Proxy({ a: { value: 1, enumerable: true }, b: { value: 2 } }, {
    ownKeys(t) { log.push("ownKeys"); return Reflect.ownKeys(t); },
    getOwnPropertyDescriptor(t, k) {
      log.push("gopd " + k);
      return Reflect.getOwnPropertyDescriptor(t, k);
    },
    get(t, k) { log.push("get " + k); return t[k]; }
  });
  const target = new Proxy({}, {
    defineProperty(t, k, d) {
      log.push("def " + k);
      return Reflect.defineProperty(t, k, d);
    }
  });
  Object.defineProperties(target, props);
  check("defineProperties order", log.join(),
        "ownKeys,gopd a,get a,gopd b,get b,def a,def b");
  const hidden = {};
  Object.defineProperty(hidden, "h", { value: { value: 9 } });
  hidden.v = { value: 8, enumerable: true };
  const made = Object.create(null, hidden);
  check("defineProperties enumerable only", ["h" in made, made.v], [false, 8]);
  // An invalid descriptor is found before anything is defined.
  const partial = {};
  check("defineProperties bad descriptor",
        [errorName(() => Object.defineProperties(partial,
                                                 { a: { value: 1 }, b: 1 })),
         "a" in partial],
        ["TypeError", false]);
  // The fields of all the descriptors are read before the first definition.
  const fields = [];
  const logged = (name, value) =>
      ({ get value() { fields.push(name + ".value"); return value; } });
  const defined = new Proxy({}, {
    defineProperty(t, k, d) {
      fields.push("define " + k);
      return Reflect.defineProperty(t, k, d);
    }
  });
  Object.defineProperties(defined, { x: logged("d1", 1), y: logged("d2", 2) });
  check("defineProperties field order", fields,
        ["d1.value", "d2.value", "define x", "define y"]);
  check("defineProperties accessors",
        (() => {
          const o = Object.defineProperties({}, {
            v: { value: 1, writable: true, enumerable: true },
            g: { get() { return 2; }, configurable: true }
          });
          const dv = Object.getOwnPropertyDescriptor(o, "v");
          const dg = Object.getOwnPropertyDescriptor(o, "g");
          return [o.v, o.g, dv.writable, dv.enumerable, dv.configurable,
                  typeof dg.get, dg.set, dg.configurable];
        })(),
        [1, 2, true, true, false, "function", undefined, true]);
})();

// Array-like lengths of 2^32 and more.
(() => {
  const keys = Array.prototype.keys.call({ length: 2 ** 32 + 2 });
  keys.next();
  keys.next();
  check("keys beyond 2^32", keys.next(), { value: 2, done: false });
  check("values at 2^32",
        Array.prototype.values.call({ length: 2 ** 32, 0: "z" }).next(),
        { value: "z", done: false });
  check("iterators", [[...[1, 2, 3].keys()], [...[1, 2].entries()], [..."ab"],
                      [...new Uint8Array([7, 8])]],
        [[0, 1, 2], [[0, 1], [1, 2]], ["a", "b"], [7, 8]]);
  check("ownKeys too long",
        errorName(() => Reflect.ownKeys(new Proxy({}, {
          ownKeys: () => ({ length: 2 ** 32 + 1 })
        }))) !== "none",
        true);
  check("replace captures",
        ["abcabc".replace(/b(c)/g, "[$1]"),
         "abc".replace(/(b)/, (m, p, off) => p + off),
         "x-y".replace(/(?<a>-)/, "$<a>$<a>")],
        ["a[c]a[c]", "ab1c", "x--y"]);
})();

// The TypedArray constructor reads the prototype before the offset.
(() => {
  const log = [];
  const newTarget = new Proxy(function() {}, {
    get(t, k) {
      if (k === "prototype") log.push("proto");
      return Reflect.get(t, k);
    }
  });
  Reflect.construct(
      Uint8Array,
      [new ArrayBuffer(8), { valueOf() { log.push("offset"); return 0; } }],
      newTarget);
  check("typed array ctor order", log.join(), "proto,offset");
  const buffer = new ArrayBuffer(8);
  check("typed array ctor ranges",
        [errorName(() => new Uint16Array(buffer, 1)),
         errorName(() => new Uint16Array(buffer, 10)),
         errorName(() => new Uint16Array(new ArrayBuffer(7))),
         errorName(() => new Uint16Array(buffer, 2, 4)),
         errorName(() => new Uint8Array(-1)),
         new Uint16Array(buffer, 2).length, new Uint16Array(buffer, 2, 1).length,
         new Uint8Array(3).length, new Float32Array([1, 2]).length],
        ["RangeError", "RangeError", "RangeError", "RangeError", "RangeError",
         3, 1, 3, 2]);
})();

// "yield" and "await" as identifiers.
for (const src of [
  "async function f() { (a = (b = await/r/g) => {}) => {} }",
  "function* g() { (function* yield() {}) }",
  "async function f() { (async function await() {}) }",
  "function* g() { (yield = 1) => 1 }",
  "function* g() { ((a = yield) => 1) }",
  "async function f() { ((a = await 1) => 1) }",
  "function* g() { (yield) => 1 }",
  "'use strict'; (function yield() {})",
  "(function* yield() {})",
  "(async function await() {})",
  "async function f() { var h = async (await) => 1 }",
  "function* g() { function yield() {} }",
  "async function f() { function await() {} }",
]) {
  check(src, syntax(src), "SyntaxError");
}
for (const src of [
  "function* g() { (function yield() {}) }",
  "async function f() { (function await() {}) }",
  "var yield = (yield) => 1;",
  "function* g() { (function(yield) {}) }",
  "var await = 1; var f = await => await; (function yield() {});" +
      "(function await() {})",
  "function* g() { var o = { *yield() {}, yield: 1 }; yield 1; }",
  "async function f() { var g = async x => await x; await g(1); }",
  "function f() { function* yield() {}; async function await() {} }",
]) {
  check(src, syntax(src), "ok");
}
