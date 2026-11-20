// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <string>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

class RegExpUnicodeSetsTest : public ::testing::Test {
 protected:
  void SetUp() override {
    runtime_ = LEPUS_NewRuntime();
    ASSERT_NE(runtime_, nullptr);
    context_ = LEPUS_NewContext(runtime_);
    ASSERT_NE(context_, nullptr);
    RecordProperty("memory_mode", runtime_->gc_enable ? "gc" : "rc");
    LEPUSValue global = LEPUS_GetGlobalObject(context_);
    const int installed = LEPUS_SetPropertyStr(
        context_, global, "collect",
        LEPUS_NewCFunction(context_, Collect, "collect", 0));
    Release(global);
    ASSERT_GE(installed, 0);
  }
  void TearDown() override {
    if (context_) LEPUS_FreeContext(context_);
    if (runtime_) LEPUS_FreeRuntime(runtime_);
  }
  static LEPUSValue Collect(LEPUSContext* context, LEPUSValueConst, int,
                            LEPUSValueConst*) {
    LEPUS_RunGC(context->rt);
    return LEPUS_UNDEFINED;
  }
  void Release(LEPUSValue value) {
    if (!runtime_->gc_enable) LEPUS_FreeValue(context_, value);
  }
  void Check(const char* body) {
    const std::string source = std::string(R"JS((function() {
      'use strict';
      function same(value, expected) {
        if (!Object.is(value, expected)) {
          throw new Error('got ' + String(value) + ', expected ' +
                          String(expected));
        }
      }
      function throws(operation, constructor) {
        try { operation(); } catch (error) {
          if (error instanceof constructor) return;
          throw error;
        }
        throw new Error('missing exception');
      }
    )JS") + body + "\nreturn true; })()";
    LEPUSValue result =
        LEPUS_Eval(context_, source.c_str(), source.size(),
                   "<regexp-unicode-sets>", LEPUS_EVAL_TYPE_GLOBAL);
    std::string error;
    if (LEPUS_IsException(result)) {
      LEPUSValue exception = LEPUS_GetException(context_);
      HandleScope scope(context_, &exception, HANDLE_TYPE_LEPUS_VALUE);
      const char* text = LEPUS_ToCString(context_, exception);
      if (text) {
        error = text;
        if (!runtime_->gc_enable) LEPUS_FreeCString(context_, text);
      }
      Release(exception);
    }
    EXPECT_FALSE(LEPUS_IsException(result)) << error;
    if (!LEPUS_IsException(result))
      EXPECT_EQ(LEPUS_ToBool(context_, result), 1);
    Release(result);
  }
  LEPUSRuntime* runtime_ = nullptr;
  LEPUSContext* context_ = nullptr;
};

TEST_F(RegExpUnicodeSetsTest, ReportsTheFlagAndRejectsItWithUnicode) {
  Check(R"JS(
    same(/a/v.flags, 'v');
    same(/a/v.unicodeSets, true);
    same(/a/v.unicode, false);
    same(/a/u.unicodeSets, false);
    same(/a/u.unicode, true);
    same(/a/.unicodeSets, false);
    same(new RegExp('a', 'yvsmig').flags, 'gimsvy');
    same(String(new RegExp('[a--b]', 'v')), '/[a--b]/v');
    same(new RegExp(/a/v).flags, 'v');
    same(new RegExp(/a/v, 'g').unicodeSets, false);
    throws(() => new RegExp('a', 'uv'), SyntaxError);
    throws(() => new RegExp('a', 'vu'), SyntaxError);
    throws(() => new RegExp('a', 'vv'), SyntaxError);
    same(RegExp.prototype.unicodeSets, undefined);
    const descriptor =
        Object.getOwnPropertyDescriptor(RegExp.prototype, 'unicodeSets');
    same(typeof descriptor.get, 'function');
    same(descriptor.set, undefined);
    same(descriptor.enumerable, false);
    same(descriptor.configurable, true);
    throws(() => descriptor.get.call({}), TypeError);
    throws(() => descriptor.get.call(1), TypeError);
    const flags = Object.getOwnPropertyDescriptor(RegExp.prototype, 'flags').get;
    same(flags.call({ global: 1, unicodeSets: 1, sticky: 1, unicode: 0 }),
         'gvy');
    const order = [];
    flags.call(new Proxy({}, {
      get(target, key) { order.push(key); return false; }
    }));
    same(order.join(','),
         'global,ignoreCase,multiline,dotAll,unicode,unicodeSets,sticky');
  )JS");
}

TEST_F(RegExpUnicodeSetsTest, CombinesNestedClassesWithSetOperations) {
  Check(R"JS(
    const re = source => new RegExp(source, 'v');
    const letters = re('[\\p{L}--[a]]');
    same(letters.test('b'), true); same(letters.test('a'), false);
    same(letters.test('1'), false); same(letters.test('é'), true);
    same(re('^[[a-c][x-z]0]+$').test('abcxyz0'), true);
    same(re('^[[a-c][x-z]0]+$').test('abd'), false);
    const vowels = re('^[[a-z]&&[aeiou]]+$');
    same(vowels.test('aeiou'), true); same(vowels.test('ab'), false);
    const consonants = re('^[[a-z]--[aeiou]]+$');
    same(consonants.test('bcd'), true); same(consonants.test('bad'), false);
    const chained = re('^[[a-z]--[aeiou]--[x-z]]+$');
    same(chained.test('bcd'), true); same(chained.test('y'), false);
    const triple = re('^[\\w&&[^\\d]&&[^_]]+$');
    same(triple.test('abcXYZ'), true); same(triple.test('a1'), false);
    same(triple.test('a_'), false);
    same(re('^[\\w--\\d]+$').test('ab_'), true);
    same(re('^[\\w--\\d]+$').test('a1'), false);
    same(re('^[\\p{L}&&\\p{ASCII}]+$').test('abcZ'), true);
    same(re('^[\\p{L}&&\\p{ASCII}]+$').test('é'), false);
    same(re('^[^[a-z]--[aeiou]]$').test('a'), true);
    same(re('^[^[a-z]--[aeiou]]$').test('b'), false);
    same(re('^[[^a]&&[a-c]]+$').test('bc'), true);
    same(re('^[[^a]&&[a-c]]+$').test('a'), false);
    same(re('^[a--a]?$').test(''), true); same(re('[a--a]').test('a'), false);
    same(re('[x&&x]').test('x'), true); same(re('[x&&y]').test('x'), false);
    same(re('[]').test('a'), false); same(re('^[^]$').test('\n'), true);
    same(re('^[[[[[a]]]]]$').test('a'), true);
    same(/^[[0-9]--[4-6]]+$/v.test('0123789'), true);
    same(/[[0-9]--[4-6]]/v.test('5'), false);
  )JS");
}

TEST_F(RegExpUnicodeSetsTest, ParsesClassSetCharactersAndEscapes) {
  Check(R"JS(
    const re = source => new RegExp(source, 'v');
    const all = "&-!#%,:;<=>@`~";
    for (const character of all) {
      same(re('^[\\' + character + ']$').test(character), true);
    }
    same(re('^[\\[\\]\\{\\}\\(\\)\\|\\/\\\\]+$').test('[]{}()|/\\'), true);
    same(re('^[\\b]$').test('\b'), true);
    same(re('^[\\n\\t\\x41\\u0042\\u{1F600}]+$').test('\n\tAB\u{1F600}'), true);
    same(re('^[\\d\\s]+$').test('1 2'), true);
    same(re('^[\\P{L}]+$').test('1 2'), true);
    same(re('^[a\\-z]+$').test('a-z'), true); same(re('[a\\-z]').test('b'), false);
    same(re('^[&!#]+$').test('&!#'), true);
    same(re('^[^^]$').test('a'), true); same(re('^[^^]$').test('^'), false);
    same(re('^[a&b]+$').test('a&b'), true);
    same(re('^[\u{1F600}-\u{1F64F}]$').test('\u{1F603}'), true);
    same(re('[\u{1F600}]').test('\ud83d'), false);
    same(re('^.$').test('\u{1F600}'), true);
    for (const source of [
      '[a&&&b]', '[a&&b--c]', '[a--b&&c]', '[ab&&c]', '[a-z&&b]', '[a-z--b]',
      '[a&&b c]', '[a&&]', '[&&a]', '[a--]', '[--a]', '[(]', '[)]', '[{]',
      '[}]', '[/]', '[|]', '[-a]', '[a-]', '[a-\\d]', '[\\d-a]', '[z-a]',
      '[a!!b]', '[##]', '[a..b]', '[**]', '[a~~b]', '[^^^]', '[a', '[[a]',
      '[\\q{a]', '[^\\q{ab}]', '[^[\\q{ab}]]', '[^\\q{}]', '\\q{a}', '[\\q]',
      '[\\k]', '[\\-', '\\-', '[\\q{\\d}]', '[a-[b]]', '[[a]-b]',
    ]) {
      try {
        re(source);
      } catch (error) {
        if (error instanceof SyntaxError) continue;
        throw error;
      }
      throw new Error('no SyntaxError: ' + source);
    }
    let nested = 'a';
    for (let depth = 0; depth < 20; ++depth) nested = '[' + nested + ']';
    same(re('^' + nested + '$').test('a'), true);
    for (let depth = 0; depth < 80; ++depth) nested = '[' + nested + ']';
    throws(() => re(nested), SyntaxError);
  )JS");
}

TEST_F(RegExpUnicodeSetsTest, MatchesClassStringsLongestFirst) {
  Check(R"JS(
    const re = (source, flags = '') => new RegExp(source, 'v' + flags);
    const mixed = re('^[\\q{abc|d|}]$');
    same(mixed.test('abc'), true); same(mixed.test('d'), true);
    same(mixed.test(''), true); same(mixed.test('ab'), false);
    same(re('[\\q{ab|abc}]').exec('abcd')[0], 'abc');
    same(re('[\\q{abc|ab}x]').exec('abx')[0], 'ab');
    same(re('[\\q{ab}a]').exec('ac')[0], 'a');
    same(re('^[\\q{ab|c}]+$').test('ababcab'), true);
    same(re('^[\\q{ab|c}]+$').test('aba'), false);
    same(re('^[\\q{ab|c}]{2}$').test('abc'), true);
    same(re('^[\\q{a|b}c]+$').test('abc'), true);
    same(re('^[^\\q{a|b}]$').test('c'), true);
    same(re('^[^\\q{a|b}]$').test('a'), false);
    const minus = re('^[[\\q{ab|cd|e}]--[\\q{cd}]]$');
    same(minus.test('ab'), true); same(minus.test('e'), true);
    same(minus.test('cd'), false);
    const both = re('^[[\\q{ab|cd|x}]&&[\\q{cd|ef|x}]]$');
    same(both.test('cd'), true); same(both.test('x'), true);
    same(both.test('ab'), false); same(both.test('ef'), false);
    const united = re('^[[\\q{ab}][\\q{ab|cd}]z]$');
    same(united.test('ab'), true); same(united.test('cd'), true);
    same(united.test('z'), true);
    same(re('(?<=[\\q{ab}x])c').test('abc'), true);
    same(re('(?<=[\\q{ab}x])c').test('xc'), true);
    same(re('(?<=[\\q{ab}x])c').test('bc'), false);
    same(re('(?<![\\q{ab}])c').test('abc'), false);
    same(re('^[\\q{AB|c}]+$', 'i').test('abCAb'), true);
    const family = '\u{1F468}‍\u{1F469}‍\u{1F467}';
    const flag = '\u{1F1EB}\u{1F1F7}';
    const emoji = re('^[\\q{' + family + '|' + flag + '}\u{1F600}]$');
    same(emoji.test(family), true); same(emoji.test(flag), true);
    same(emoji.test('\u{1F600}'), true); same(emoji.test('\u{1F1EB}'), false);
    same(re('[\\q{}]').exec('abc')[0], '');
    same(re('^(?:[\\q{}a])*$').test('aaa'), true);
  )JS");
}

TEST_F(RegExpUnicodeSetsTest, FoldsCaseInEveryOperand) {
  Check(R"JS(
    const re = source => new RegExp(source, 'vi');
    same(re('[A-Z]').test('a'), true);
    same(re('[a-z]').test('A'), true);
    same(re('[^A]').test('a'), false);
    same(re('[^a]').test('A'), false);
    same(re('^[[a-z]--[aeiou]]$').test('E'), false);
    same(re('^[[a-z]--[aeiou]]$').test('B'), true);
    same(re('^[[A-Z]&&[a-f]]$').test('C'), true);
    same(re('^[[A-Z]&&[a-f]]$').test('g'), false);
    same(re('^[[^a]&&[A]]$').test('A'), false);
    same(re('^[\\p{Lu}&&\\p{ASCII}]$').test('a'), true);
    same(re('^[\\p{Lu}&&\\p{ASCII}]$').test('1'), false);
    same(re('^[É]$').test('é'), true);
    same(re('^[\\q{É}x]$').test('é'), true);
    same(new RegExp('[A-Z]', 'v').test('a'), false);
  )JS");
}

TEST_F(RegExpUnicodeSetsTest, MatchesByCodePointLikeUnicodeMode) {
  Check(R"JS(
    const face = '\u{1F600}';
    same(face.replace(/(?:)/gv, '-'), '-' + face + '-');
    same(face.match(/(?:)/gv).length, 2);
    same(('a' + face).split(/(?:)/v).join('|'), 'a|' + face);
    same([...face.matchAll(/(?:)/gv)].length, 2);
    same(face.replace(/./gv, 'x'), 'x');
    const sticky = /[\p{L}--[q]]/gv;
    same(sticky.test('qé'), true); same(sticky.lastIndex, 2);
    same(/\p{L}+/v.exec('été 1')[0], 'été');
    throws(() => new RegExp('\\-', 'v'), SyntaxError);
    throws(() => new RegExp('a{', 'v'), SyntaxError);
    throws(() => new RegExp('\\u{110000}', 'v'), SyntaxError);
    same(/[\p{L}--[a]]/v.test('b'), true);
    same(new RegExp('[\\p{L}--[a]]', 'v').test('b'), true);
  )JS");
}

TEST_F(RegExpUnicodeSetsTest, SurvivesCollectionWhileCompilingAndMatching) {
  Check(R"JS(
    let source = '[';
    for (let i = 0; i < 300; ++i) {
      source += '[\\u{' + (0x4e00 + i * 3).toString(16) + '}-\\u{' +
                (0x4e01 + i * 3).toString(16) + '}]';
    }
    source += '\\q{' + 'ab'.repeat(40) + '|cd}]';
    let matched = 0;
    for (let round = 0; round < 60; ++round) {
      const pattern = new RegExp('^' + source + '+$', 'v');
      if (round % 20 === 0) collect();
      if (pattern.test('一丄cd' + 'ab'.repeat(40))) ++matched;
      if (pattern.test('丂')) --matched;
    }
    collect();
    same(matched, 60);
  )JS");
}
