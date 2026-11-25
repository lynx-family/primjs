// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

function check(what, actual, expected) {
  const a = JSON.stringify(actual), e = JSON.stringify(expected);
  if (a !== e) throw new Error(`${what}: ${a} !== ${e}`);
}

function checkExec(re, str, expected) {
  check(`${re}.exec(${JSON.stringify(str)})`, re.exec(str), expected);
}

// An iteration of a quantifier that matches the empty string fails, except
// the mandatory ones, so its captures are dropped and the atom backtracks.
checkExec(/(?:(?=(abc)))?a/, "abc", ["a", null]);
checkExec(/(?:(?=(abc))){0,1}a/, "abc", ["a", null]);
checkExec(/(?:(?=(abc))){0,3}a/, "abc", ["a", null]);
checkExec(/(?:(?=(abc)))*a/, "abc", ["a", null]);
checkExec(/(?:(?=(abc)))??a/, "abc", ["a", null]);
checkExec(/(?:(?=(abc)))+a/, "abc", ["a", "abc"]);
checkExec(/(?:(?=(abc))){1,3}a/, "abc", ["a", "abc"]);
checkExec(/(?:(?=(abc))){2}a/, "abc", ["a", "abc"]);
checkExec(/(a*)?/, "b", ["", null]);
checkExec(/(a*){0,2}/, "b", ["", null]);
checkExec(/(a*)*/, "b", ["", null]);
checkExec(/(a*)+/, "b", ["", ""]);
checkExec(/(a*){2,}/, "b", ["", ""]);
checkExec(/(a?b??)*/, "ab", ["ab", "b"]);
checkExec(/(a?b??)+/, "ab", ["ab", "b"]);
checkExec(/(a?b??){0,5}/, "ab", ["ab", "b"]);
checkExec(/(a?b??){1,5}/, "ab", ["ab", "b"]);
checkExec(/(a?b??){1,2}/, "ab", ["ab", "b"]);
checkExec(/(?:|a)*/, "aaa", ["aaa"]);
checkExec(/(?:|a)+/, "aaa", ["aaa"]);
checkExec(/(a*?)*/, "aaa", ["aaa", "a"]);
checkExec(/^(|ab)*c/, "ababc", ["ababc", "ab"]);
checkExec(/(?:\1|(a))*x/, "aax", ["aax", "a"]);

// Lazy quantifiers stop on such an iteration too.
for (const re of [
  /(?:a?)*?c/, /(?:a*)*?c/, /(?:)*?c/, /(a?)+?c/, /(?:a?){0,}?c/,
  /(?:a?){2,}?c/, /(?:(?=a))*?c/, /(?:a|b|)*?c/, /(?:\1)*?c()/,
]) {
  checkExec(re, "ab", null);
}
checkExec(/(a?)*?c/, "aac", ["aac", "a"]);
checkExec(/(?:a??)*?b/, "aab", ["aab"]);

// Every iteration starts with the captures of the atom reset.
checkExec(/(?:(a)|b)+/, "ab", ["ab", null]);
checkExec(/(?:(a)|b)*/, "ab", ["ab", null]);
checkExec(/(?:(a)|b)*?$/, "ab", ["ab", null]);
checkExec(/(?:(a)|b){2}/, "ab", ["ab", null]);
checkExec(/(?:(a)|b){0,2}/, "ab", ["ab", null]);
checkExec(/(?:(a)|b){1,2}/, "ab", ["ab", null]);
checkExec(/(?:(a)|(b)|(c))+/, "abc", ["abc", null, null, "c"]);
checkExec(/(?:(a)?b)+/, "abb", ["abb", null]);
checkExec(/(?:(?:(a))?b)+/, "abb", ["abb", null]);
checkExec(/(?:(?:(a)|b)*c)+/, "acbc", ["acbc", null]);
checkExec(/(z)((a+)?(b+)?(c))*/, "zaacbbbcac",
          ["zaacbbbcac", "z", "ac", "a", null, "c"]);
checkExec(/(?:(?=(a))a|b)+/, "ab", ["ab", null]);
checkExec(/(?<=(?:(a)|b)+)c/, "bac", ["c", null]);
checkExec(/^(?:(a)|b)+\1$/, "ab", ["ab", null]);
checkExec(/^(?:(a)|b\1)+$/, "ab", ["ab", null]);
checkExec(/(?:(a)b)+/, "abab", ["abab", "a"]);
checkExec(/(?:(a+)(b?))+/, "aabaa", ["aabaa", "aa", ""]);
check("named group", /(?:(?<x>a)|b)+/.exec("ab").groups.x, undefined);
check("replace", "ab".replace(/(?:(a)|b)+/, "[$1]"), "[]");

// Case insensitive classes match the characters with the same folding.
function checkTest(re, str, expected) {
  check(`${re}.test(${JSON.stringify(str)})`, re.test(str), expected);
}
for (const [re, matched, unmatched] of [
  [/[A-Z]/i, "azAZ", "1_ſK"],
  [/[A-Z]/iu, "azAZſK", "1_é"],
  [/[a-z]/iu, "azAZſK", "1_é"],
  [/[^A-Z]/iu, "1_é", "azAZſK"],
  [/[é]/i, "éÉ", "eè"],
  [/[É]/i, "éÉ", "eÈ"],
  [/[É]/iu, "éÉ", "eÈ"],
  [/[^é]/i, "eè", "éÉ"],
  [/[а-яё]/i, "жЖёЁ", "ђЂ"],
  [/[А-ЯЁ]/iu, "жЖёЁ", "ђЂ"],
  [/[σ]/i, "σςΣ", "τ"],
  [/[µ]/i, "µμΜ", "ν"],
  [/[ß]/i, "ß", "sSẞ"],
  [/[ß]/iu, "ßẞ", "sS"],
  [/[ı]/i, "ı", "iIİ"],
  [/[\u{10428}]/iu, "\u{10428}\u{10400}", "\u{10429}"],
  [/[\u{10400}]/iu, "\u{10428}\u{10400}", "\u{10401}"],
  [/[ΐ]/iu, "ΐΐ", "ΰ"],
  [/[ΰ]/iu, "ΰΰ", "ΐ"],
  [/[^ﬅ]/iu, "ΐ", "ﬅﬆ"],
  [/[ΐ]/i, "ΐ", "ΐ"],
  [/ΐ/iu, "ΐΐ", "ΰ"],
  [/ΐ/iu, "ΐΐ", "ΰ"],
  [/ΰ/iu, "ΰΰ", "ΐ"],
  [/ﬅ/iu, "ﬅﬆ", "st"],
  [/ﬆ/iu, "ﬅﬆ", "st"],
  [/ﬅ/i, "ﬅ", "ﬆ"],
  [/\p{Lu}/iu, "aAéЖж", "1_"],
  [/\p{Ll}/iu, "aAéЖж", "1_"],
  [/\P{Lu}/iu, "aA1_", ""],
  [/[^\P{Lu}]/iu, "", "aA1_"],
  [/\w/iu, "sSkK_0ſK", " é"],
  [/\W/iu, " é", "sSkK_0ſK"],
  [/[\w]/iu, "sSkK_0ſK", " é"],
  [/[\W]/iu, " é", "sSkK_0ſK"],
  [/[^\w]/iu, " é", "sSkK_0ſK"],
  [/[^\W]/iu, "sSkK_0ſK", " é"],
  [/\w/i, "sSkK_0", "ſK"],
  [/[\W]/i, "ſK", "sSkK_0"],
]) {
  for (const c of matched) checkTest(re, c, true);
  for (const c of unmatched) checkTest(re, c, false);
}
check("ranges", "Привет".match(
    /[а-я]+/i)[0], "Привет");
checkTest(/^(ﬅ)\1$/iu, "ﬅﬆ", true);
checkTest(/^(ΐ)\1$/iu, "ΐΐ", true);
checkTest(/^(ΐ)\1$/i, "ΐΐ", false);
checkTest(/^(a)\1$/iu, "a\0", false);
checkTest(/(?<=\1(ΰ))$/iu, "ΰΰ", true);

// U+017F and U+212A are word characters with the u and i flags.
for (const c of ["ſ", "K"]) {
  checkTest(/\b/iu, c, true);
  checkTest(/\B/iu, c, false);
  checkTest(/x\b/iu, "x" + c, false);
  checkTest(/\b./iu, c, true);
  checkTest(/\b/i, c, false);
  checkTest(/\b/u, c, false);
  checkTest(/x\b/i, "x" + c, true);
}

// RegExp.prototype[@@match] and [@@replace] read rx.flags only.
{
  const re = /a/g;
  Object.defineProperty(re, "flags", { value: "" });
  check("replace", "aa".replace(re, "b"), "ba");
  re.lastIndex = 0;
  check("match", "aa".match(re), ["a"]);
}
{
  const re = /a/g;
  Object.defineProperty(re, "global", { value: false });
  check("flags", re.flags, "");
  check("replace", "aa".replace(re, "b"), "ba");
}
for (const [method, args] of [["match", ["a"]], ["replace", ["a", "b"]]]) {
  const log = [];
  const rx = {
    get flags() { log.push("flags"); return { toString() {
      log.push("toString"); return "gu"; } }; },
    get global() { log.push("global"); return true; },
    get unicode() { log.push("unicode"); return true; },
    set lastIndex(v) { log.push("lastIndex=" + v); },
    exec() { log.push("exec"); return null; },
  };
  RegExp.prototype[Symbol[method]].apply(rx, args);
  check(method, log, ["flags", "toString", "lastIndex=0", "exec"]);

  const throwing = /a/;
  Object.defineProperty(throwing, "flags", { get() { throw "flags"; } });
  let error;
  try {
    RegExp.prototype[Symbol[method]].apply(throwing, args);
  } catch (e) {
    error = e;
  }
  check(method + " exception", error, "flags");
  for (const value of [Symbol(), null, undefined, 1, true]) {
    const re = /a/;
    Object.defineProperty(re, "flags", { value });
    let name = "ok";
    try {
      RegExp.prototype[Symbol[method]].apply(re, args);
    } catch (e) {
      name = e.name;
    }
    check(method, name, typeof value === "symbol" ? "TypeError" : "ok");
  }
}
{
  // the u flag is also taken from rx.flags
  const advance = (flags) => {
    const re = /(?:)/g, indexes = [];
    Object.defineProperty(re, "flags", { value: flags });
    "\u{1f600}".replace(re, (m, index) => { indexes.push(index); return ""; });
    re.lastIndex = 0;
    return [indexes, "\u{1f600}".match(re).length];
  };
  check("advance", advance("g"), [[0, 1, 2], 3]);
  check("advance", advance("gu"), [[0, 2], 2]);
  check("advance", advance("gv"), [[0, 2], 2]);
  check("literal replace", "\u{1f600}".replace(/(?:)/gu, "-").length, 4);
  check("literal replace", "\u{1f600}".replace(/(?:)/g, "-").length, 5);
}
// The flag getters of RegExp.prototype are called once they are replaced.
for (const name of ["flags", "global", "ignoreCase", "multiline", "dotAll",
                    "unicode", "sticky"]) {
  const desc = Object.getOwnPropertyDescriptor(RegExp.prototype, name);
  for (const change of [
    (get) => ({ get, configurable: true }),
    (get) => ({ value: get(), configurable: true }),
  ]) {
    let count = 0;
    Object.defineProperty(RegExp.prototype, name, change(function() {
      count++;
      return name === "flags" ? "g" : true;
    }));
    const before = count;
    const matched = "aa".match(/a/g);
    const replaced = "aa".replace(/a/g, "b");
    const called = count - before;
    Object.defineProperty(RegExp.prototype, name, desc);
    check(name + " calls", called, before ? 0 : 2);
    check(name, [matched, replaced], [["a", "a"], "bb"]);
  }
}
// They still work once they are deleted and added again.
for (const name of ["global", "ignoreCase", "multiline", "dotAll", "unicode",
                    "sticky", "flags"]) {
  const desc = Object.getOwnPropertyDescriptor(RegExp.prototype, name);
  const deleted = delete RegExp.prototype[name];
  const matched = "aa".match(/a/g);
  Object.defineProperty(RegExp.prototype, name, desc);
  check(name + " deleted", [deleted, matched],
        [true, name === "flags" || name === "global" ? ["a"] : ["a", "a"]]);
  check(name + " restored", "aa".match(/a/g), ["a", "a"]);
}
// The original getters may also be moved to other names.
{
  const names = ["flags", "global", "ignoreCase", "multiline", "dotAll",
                 "unicode", "sticky"];
  const descs = Object.getOwnPropertyDescriptors(RegExp.prototype);
  for (const renamed of names.slice(1)) {
    for (const name of names) delete RegExp.prototype[name];
    const added = ["flags", "placeholder", ...names.slice(1).map(
        (name) => name === renamed ? "renamed" : name)];
    for (const name of added) {
      Object.defineProperty(RegExp.prototype, name,
                            name === "renamed" ? descs[renamed] :
                            descs[name] || { value: 0, configurable: true });
    }
    const global = renamed !== "global";
    let called = 0;
    Object.defineProperty(RegExp.prototype, renamed, {
      get() { called++; return false; }, configurable: true,
    });
    check(`${renamed} renamed`, ["aa".replace(/a/g, "b"), "aa".match(/a/g)],
          global ? ["bb", ["a", "a"]] : ["ba", ["a"]]);
    check(`${renamed} calls`, called, 2);
    for (const name of added) delete RegExp.prototype[name];
    delete RegExp.prototype[renamed];
    for (const name of names) {
      Object.defineProperty(RegExp.prototype, name, descs[name]);
    }
    check(`${renamed} restored`, "aa".replace(/a/g, "b"), "bb");
  }
}
{
  class SubRegExp extends RegExp {
    get flags() { return super.flags.replace("g", ""); }
  }
  check("subclass", "aa".replace(new SubRegExp("a", "g"), "b"), "ba");
  const re = /a/g;
  re.extra = 1;
  check("own property", "aa".replace(re, "b"), "bb");
  const other = /a/;
  other.compile("b", "g");
  check("compile", "bb".replace(other, "a"), "aa");
}
