// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <string>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

class ArrayFindLastTest : public ::testing::Test {
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
    LEPUSValue result = LEPUS_Eval(context_, source.c_str(), source.size(),
                                   "<array-find-last>", LEPUS_EVAL_TYPE_GLOBAL);
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

TEST_F(ArrayFindLastTest, SearchesFromTheLastElement) {
  Check(R"JS(
    same([1, 2, 3].findLast(x => x < 3), 2);
    same([1, 2, 3].findLastIndex(x => x < 3), 1);
    same([1, 2, 3].findLast(x => x > 3), undefined);
    same([1, 2, 3].findLastIndex(x => x > 3), -1);
    same([].findLast(() => true), undefined);
    same([].findLastIndex(() => true), -1);
    const visited = [];
    same([4, 5, 6].findLast((value, index) => {
      visited.push(index + ':' + value); return false;
    }), undefined);
    same(visited.join(','), '2:6,1:5,0:4');
    same([NaN, 0, -0].findLastIndex(x => Object.is(x, 0)), 1);
    same([1, 2, 3].find(x => x > 1), 2);
    same([1, 2, 3].findIndex(x => x > 1), 1);
  )JS");
}

TEST_F(ArrayFindLastTest, PassesValueIndexAndReceiverToThePredicate) {
  Check(R"JS(
    const array = ['a', 'b'];
    const receiver = {};
    const calls = [];
    array.findLast(function(value, index, object) {
      calls.push([this === receiver, value, index, object === array,
                  arguments.length].join('|'));
    }, receiver);
    same(calls.join(';'), 'true|b|1|true|3;true|a|0|true|3');
    let strictThis = null;
    [1].findLastIndex(function() { strictThis = this; });
    same(strictThis, undefined);
    same([0, 1, 2].findLast(x => ({})), 2);
    same([0, 1, 2].findLastIndex(x => 'yes'), 2);
    same([0, 1, 2].findLastIndex(x => ''), -1);
  )JS");
}

TEST_F(ArrayFindLastTest, VisitsHolesAndReadsEachElementOnce) {
  Check(R"JS(
    const sparse = [1, , 3];
    const seen = [];
    sparse.findLast((value, index) => { seen.push(index in sparse); });
    same(seen.join(','), 'true,false,true');
    same([, , ].findLastIndex(value => value === undefined), 1);
    const inherited = Object.create(Array.prototype);
    inherited[1] = 'parent';
    const holes = [, , 'own'];
    Object.setPrototypeOf(holes, inherited);
    same(holes.findLast(value => value === 'parent'), 'parent');
    const reads = [];
    const proxy = new Proxy({ length: 3, 0: 'a', 1: 'b', 2: 'c' }, {
      get(target, key) { reads.push(String(key)); return target[key]; }
    });
    same(Array.prototype.findLast.call(proxy, value => value === 'b'), 'b');
    same(reads.join(','), 'length,2,1');
  )JS");
}

TEST_F(ArrayFindLastTest, ReadsTheLengthOnceAndSeesLaterChanges) {
  Check(R"JS(
    const shrinking = [1, 2, 3, 4];
    const values = [];
    shrinking.findLast((value, index) => {
      if (index === 3) shrinking.length = 1;
      values.push(value);
    });
    same(values.join(','), '4,,,1');
    const growing = [1, 2];
    let calls = 0;
    growing.findLastIndex(() => { growing.push(0); ++calls; });
    same(calls, 2);
    const changed = [1, 2, 3];
    same(changed.findLast((value, index) => {
      if (index === 2) changed[0] = 'new';
      return value === 'new';
    }), 'new');
  )JS");
}

TEST_F(ArrayFindLastTest, WorksOnArrayLikesAndValidatesItsArguments) {
  Check(R"JS(
    const like = { length: 3, 0: 'x', 1: 'y', 2: 'z' };
    same(Array.prototype.findLast.call(like, value => value < 'z'), 'y');
    same(Array.prototype.findLastIndex.call(like, value => value < 'z'), 1);
    same(Array.prototype.findLast.call('abc', value => value < 'c'), 'b');
    same(Array.prototype.findLastIndex.call({ length: -1 }, () => true), -1);
    same(Array.prototype.findLast.call({ length: 2.9, 1: 'last' },
                                       () => true), 'last');
    throws(() => Array.prototype.findLast.call(null, () => true), TypeError);
    throws(() => Array.prototype.findLastIndex.call(undefined, () => true),
           TypeError);
    throws(() => [1].findLast(), TypeError);
    throws(() => [1].findLastIndex({}), TypeError);
    throws(() => [].findLast(null), TypeError);
    const order = [];
    throws(() => Array.prototype.findLast.call(
        { get length() { order.push('length'); return 1; } }, 'no'),
        TypeError);
    same(order.join(','), 'length');
    const sentinel = {};
    try {
      [1, 2].findLast(() => { throw sentinel; });
      throw new Error('missing exception');
    } catch (error) { same(error, sentinel); }
    try {
      Array.prototype.findLastIndex.call(
          { length: 1, get 0() { throw sentinel; } }, () => true);
      throw new Error('missing exception');
    } catch (error) { same(error, sentinel); }
  )JS");
}

TEST_F(ArrayFindLastTest, AreOrdinaryPrototypeMethods) {
  Check(R"JS(
    for (const name of ['findLast', 'findLastIndex']) {
      const descriptor =
          Object.getOwnPropertyDescriptor(Array.prototype, name);
      same(typeof descriptor.value, 'function');
      same(descriptor.writable, true);
      same(descriptor.enumerable, false);
      same(descriptor.configurable, true);
      same(Array.prototype[name].length, 1);
      same(Array.prototype[name].name, name);
      same(Array.prototype[Symbol.unscopables][name], true);
      throws(() => new Array.prototype[name](() => true), TypeError);
    }
  )JS");
}

TEST_F(ArrayFindLastTest, SurvivesCollectionInsideThePredicate) {
  Check(R"JS(
    const items = [];
    for (let i = 0; i < 3000; ++i) items.push({ id: i, text: 'item' + i });
    let calls = 0;
    const found = items.findLast(item => {
      if (++calls % 700 === 0) collect();
      return item.id === 5;
    });
    same(found.text, 'item5');
    same(calls, 2995);
    same(items.findLastIndex(item => { collect(); return item.id === 2998; }),
         2998);
  )JS");
}
