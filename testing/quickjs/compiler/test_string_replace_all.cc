// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <string>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

class StringReplaceAllTest : public ::testing::Test {
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
                   "<string-replace-all>", LEPUS_EVAL_TYPE_GLOBAL);
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

TEST_F(StringReplaceAllTest, ReplacesEveryOccurrenceOfAString) {
  Check(R"JS(
    same('aa'.replaceAll('a', 'b'), 'bb');
    same('abcabc'.replaceAll('bc', 'X'), 'aXaX');
    same('aaaa'.replaceAll('aa', 'b'), 'bb');
    same('aaa'.replaceAll('aa', 'b'), 'ba');
    same('abc'.replaceAll('z', 'y'), 'abc');
    same('abc'.replaceAll('abc', ''), '');
    same('a.b.c'.replaceAll('.', '-'), 'a-b-c');
    same('日本日本'.replaceAll('日', '月'),
         '月本月本');
    same('a😀b😀'.replaceAll('😀', '!'), 'a!b!');
    same('aa'.replace('a', 'b'), 'ba');
  )JS");
}

TEST_F(StringReplaceAllTest, EmptySearchMatchesBetweenCodeUnits) {
  Check(R"JS(
    same('abc'.replaceAll('', '-'), '-a-b-c-');
    same(''.replaceAll('', 'x'), 'x');
    same('😀'.replaceAll('', '_'), '_\ud83d_\ude00_');
    const positions = [];
    same('ab'.replaceAll('', (match, position) => {
      positions.push(position); return '';
    }), 'ab');
    same(positions.join(','), '0,1,2');
  )JS");
}

TEST_F(StringReplaceAllTest, ExpandsReplacementPatternsForEachMatch) {
  Check(R"JS(
    same('a-b-c'.replaceAll('-', '[$&]'), 'a[-]b[-]c');
    same('a-b-c'.replaceAll('-', '$$'), 'a$b$c');
    same('a-b-c'.replaceAll('-', '<$`>'), 'a<a>b<a-b>c');
    same('a-b-c'.replaceAll('-', "<$'>"), 'a<b-c>b<c>c');
    same('a-b'.replaceAll('-', '$1$<x>'), 'a$1$<x>b');
  )JS");
}

TEST_F(StringReplaceAllTest, CallsAReplacerFunctionForEachMatch) {
  Check(R"JS(
    const calls = [];
    const result = 'xax'.replaceAll('x', function(match, position, string) {
      calls.push([this, match, position, string, arguments.length].join('|'));
      return position;
    });
    same(result, '0a2');
    same(calls.join(';'), '|x|0|xax|3;|x|2|xax|3');
    same('aba'.replaceAll('a', () => '$&'), '$&b$&');
    same('aba'.replaceAll('a', () => ({ toString() { return 'c'; } })), 'cbc');
    const sentinel = {};
    let seen = 0;
    try {
      'aaa'.replaceAll('a', () => { if (++seen === 2) throw sentinel; });
    } catch (error) { same(error, sentinel); }
    same(seen, 2);
  )JS");
}

TEST_F(StringReplaceAllTest, RequiresTheGlobalFlagOnRegularExpressions) {
  Check(R"JS(
    same('aXbxc'.replaceAll(/x/gi, '-'), 'a-b-c');
    same('a1b22'.replaceAll(/(\d)/g, '<$1>'), 'a<1>b<2><2>');
    throws(() => 'a'.replaceAll(/a/, 'b'), TypeError);
    throws(() => 'a'.replaceAll(/a/i, 'b'), TypeError);
    const trace = [];
    const searcher = {
      get [Symbol.match]() { trace.push('match'); return true; },
      get flags() { trace.push('flags'); return 'g'; },
      get [Symbol.replace]() {
        trace.push('replace');
        return function(string, replacement) {
          trace.push(this === searcher, string, replacement);
          return 'done';
        };
      },
    };
    same('text'.replaceAll(searcher, 'value'), 'done');
    same(trace.join(','), 'match,flags,replace,true,text,value');
    throws(() => 'a'.replaceAll({ [Symbol.match]: true, flags: 'i' }, 'b'),
           TypeError);
    throws(() => 'a'.replaceAll({ [Symbol.match]: true, flags: undefined },
                                'b'), TypeError);
    throws(() => 'a'.replaceAll({ [Symbol.match]: true, flags: null }, 'b'),
           TypeError);
    same('a'.replaceAll({ [Symbol.match]: false, flags: 'i',
                          toString() { return 'a'; } }, 'b'), 'b');
  )JS");
}

TEST_F(StringReplaceAllTest, ConvertsOperandsInOrderAndValidatesTheReceiver) {
  Check(R"JS(
    throws(() => String.prototype.replaceAll.call(null, 'a', 'b'), TypeError);
    throws(() => String.prototype.replaceAll.call(undefined, 'a', 'b'),
           TypeError);
    throws(() => 'a'.replaceAll(Symbol(), 'b'), TypeError);
    throws(() => 'a'.replaceAll('a', Symbol()), TypeError);
    const trace = [];
    const named = name => ({ toString() { trace.push(name); return name; } });
    same(String.prototype.replaceAll.call(named('this'), named('search'),
                                          named('value')), 'this');
    same(trace.join(','), 'this,search,value');
    same(String.prototype.replaceAll.call(1221, 2, 3), '1331');
    same('a null b'.replaceAll(null, undefined), 'a undefined b');
    same('undefined'.replaceAll(), 'undefined');
  )JS");
}

TEST_F(StringReplaceAllTest, IsAnOrdinaryPrototypeMethod) {
  Check(R"JS(
    const descriptor =
        Object.getOwnPropertyDescriptor(String.prototype, 'replaceAll');
    same(typeof descriptor.value, 'function');
    same(descriptor.writable, true);
    same(descriptor.enumerable, false);
    same(descriptor.configurable, true);
    same(String.prototype.replaceAll.length, 2);
    same(String.prototype.replaceAll.name, 'replaceAll');
    throws(() => new String.prototype.replaceAll('a', 'b'), TypeError);
  )JS");
}

TEST_F(StringReplaceAllTest, SurvivesCollectionInsideTheReplacer) {
  Check(R"JS(
    const text = 'ab'.repeat(2000);
    let count = 0;
    const result = text.replaceAll('a', (match, position) => {
      if (++count % 500 === 0) collect();
      return String.fromCharCode(0x4e00 + (position & 7));
    });
    same(count, 2000);
    same(result.length, 4000);
    same(result.charCodeAt(0), 0x4e00);
    same(result.charCodeAt(2), 0x4e02);
    same(result.replaceAll('b', '').length, 2000);
  )JS");
}
