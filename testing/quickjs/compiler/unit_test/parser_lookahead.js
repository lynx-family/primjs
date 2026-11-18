// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

function check(source, expected) {
  const actual = (0, eval)(source);
  if (actual !== expected) {
    throw new Error(source + ": expected " + expected + ", got " + actual);
  }
}

function syntaxError(source) {
  try {
    (0, eval)(source);
  } catch (error) {
    if (error instanceof SyntaxError) return;
    throw error;
  }
  throw new Error("Expected SyntaxError for " + source);
}

check("(1 + 2)", 3);
check("(1 + 2)\r\n;", 3);
check("([{x: [3, {text: ')],}'}]}])[0].x[0]", 3);
check("({text: 'a\\'b\\\\c'}).text", "a'b\\c");
check("((x) => x + 1)(2)", 3);
check("((x) /* before arrow */ => x + 1)(2)", 3);
check("((x = 3) => x)()", 3);
check("(() => { let x; [x] /* before assign */ = [3]; return x; })()", 3);
check("(() => { let x; ({x} = {x: 3}); return x; })()", 3);
check("(() => { let x, rest; [x, ...rest] = [1, 2, 3]; return x + rest.length; })()", 3);
check("([6 / 2, /[)\\]]/.test(']')])[0]", 3);
check("([1 /* ] */ + 2])[0]", 3);
check("({text: `x${1 + 2}]`}).text", "x3]");
check("({caf\u00e9: '\\u0041'}).caf\u00e9", "A");
check("({\\u0078: 3}).x", 3);
check("({x: 3})\u00a0.x", 3);
check("(function(){ return [1, 2, 3]; })().length", 3);
check("(".repeat(70) + "3" + ")".repeat(70), 3);
check("({x: 3})<!-- }\n.x", 3);
syntaxError("(x)\n=> x");
syntaxError("([)]");
syntaxError("({x: 'unterminated})");
syntaxError("(1 + 2) = 3");
syntaxError("[1, 2] = [3, 4]");

// Delimiters followed by tokens that still need the full lookahead.
check("(() => { let a = 1; (a) += 2; return a; })()", 3);
check("(() => { const o = {}; [o][0].x = 3; return o.x; })()", 3);
check("(() => { let n = 0; for ([n] of [[3]]); return n; })()", 3);
check("(() => { let k; for ({k} of [{k: 3}]); return k; })()", 3);
check("(() => { const o = {y: 3}; return (o)?.y; })()", 3);
check("(async (x) => x, 3)", 3);
check("(() => { let a, b; [a, b] = [1, 2]; return a + b; })()", 3);
check("((x) => { return x; })([1, 2, 3]).length", 3);
syntaxError("(() => {}) = 0");

// Wrapper prefixes only bypass the outer lookahead.
check("(function(){ return /[)]/.test(')') ? 3 : 0; })()", 3);
check("(() => { const s = `value=${3}`; return +s.slice(-1); })()", 3);
check("(functionality => functionality)(3)", 3);
check("((x = (function(){ return 3; })()) => x)()", 3);
check("(() /* no line break */ => 3)()", 3);
syntaxError("(function(){}) => 0");
syntaxError("(() => {}) => 0");
syntaxError("(()\n=> 3)()");

// The full parser still reads names, strings, and context-sensitive tokens.
check("({text: 'plain ASCII', match: /plain/}).match.test('plain ASCII')", true);
check("({name: 'plain ASCII', n: 6 / 2, tag: `n=${3}`}).n", 3);
check("(function*(){ yield /[)]/.test(')'); })().next().value", true);
check("(() => { let n = 0; for (const a of [3]) n += a; return n; })()", 3);
syntaxError("({name: 'unterminated, match: /plain/})");

// Source columns with the setting on and off are checked per runtime in
// test_parser_lookahead.cc.
