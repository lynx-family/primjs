// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <string>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

class ArrayToSortedTest : public ::testing::Test {
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
                                   "<array-to-sorted>", LEPUS_EVAL_TYPE_GLOBAL);
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

TEST_F(ArrayToSortedTest, ReturnsASortedCopyAndKeepsTheReceiver) {
  Check(R"JS(
    const source = [3, 1, 2];
    const sorted = source.toSorted();
    same(sorted.join(','), '1,2,3');
    same(source.join(','), '3,1,2');
    same(sorted === source, false);
    same(Array.isArray(sorted), true);
    same(Object.getPrototypeOf(sorted), Array.prototype);
    same([2, 1].toSorted()[0], 1);
    same([10, 9, 1].toSorted().join(','), '1,10,9');
    same(['b', undefined, 'a'].toSorted().length, 3);
    same(String(['b', undefined, 'a'].toSorted()[2]), 'undefined');
    same([].toSorted().length, 0);
    same([1, 2, 3].sort((a, b) => b - a).join(','), '3,2,1');
  )JS");
}

TEST_F(ArrayToSortedTest, UsesTheComparatorAndStaysStable) {
  Check(R"JS(
    same([1, 10, 9].toSorted((a, b) => a - b).join(','), '1,9,10');
    same([1, 10, 9].toSorted((a, b) => b - a).join(','), '10,9,1');
    const records = [];
    for (let i = 0; i < 64; ++i) records.push({ key: i % 4, order: i });
    const sorted = records.toSorted((a, b) => a.key - b.key);
    for (let i = 1; i < sorted.length; ++i) {
      const previous = sorted[i - 1], current = sorted[i];
      if (previous.key > current.key ||
          (previous.key === current.key && previous.order > current.order)) {
        throw new Error('unstable or unsorted at ' + i);
      }
    }
    let strictThis = null;
    [2, 1].toSorted(function(a, b) { strictThis = this; return a - b; });
    same(strictThis, undefined);
    const sentinel = {};
    const original = [3, 2, 1];
    try {
      original.toSorted(() => { throw sentinel; });
      throw new Error('missing exception');
    } catch (error) { same(error, sentinel); }
    same(original.join(','), '3,2,1');
  )JS");
}

TEST_F(ArrayToSortedTest, ReadsThroughHolesIntoADenseCopy) {
  Check(R"JS(
    const sparse = [3, , 1];
    const sorted = sparse.toSorted();
    same(sorted.length, 3);
    same(1 in sorted, true);
    same(2 in sorted, true);
    same(sorted[0], 1); same(sorted[1], 3); same(sorted[2], undefined);
    same(1 in sparse, false);
    const inherited = Object.create(Array.prototype);
    inherited[1] = 0;
    const holes = [5, , 4];
    Object.setPrototypeOf(holes, inherited);
    same(holes.toSorted().join(','), '0,4,5');
    same(holes.hasOwnProperty(1), false);
    const descriptor = Object.getOwnPropertyDescriptor([7].toSorted(), '0');
    same(descriptor.writable && descriptor.enumerable &&
         descriptor.configurable, true);
  )JS");
}

TEST_F(ArrayToSortedTest, CopiesArrayLikesWithoutUsingSpecies) {
  Check(R"JS(
    const like = { length: 3, 0: 'c', 1: 'a', 2: 'b' };
    const sorted = Array.prototype.toSorted.call(like);
    same(Array.isArray(sorted), true);
    same(sorted.join(''), 'abc');
    same(like[0], 'c');
    same(Array.prototype.toSorted.call('cab').join(''), 'abc');
    same(Array.prototype.toSorted.call({ length: -2 }).length, 0);
    same(Array.prototype.toSorted.call(7).length, 0);
    class Derived extends Array {
      static get [Symbol.species]() { throw new Error('species used'); }
    }
    const derived = Derived.from([2, 1]);
    const copy = derived.toSorted();
    same(copy instanceof Derived, false);
    same(copy.join(','), '1,2');
    const reads = [];
    const proxy = new Proxy({ length: 2, 0: 'b', 1: 'a' }, {
      get(target, key) { reads.push(String(key)); return target[key]; }
    });
    same(Array.prototype.toSorted.call(proxy).join(''), 'ab');
    same(reads.join(','), 'length,0,1');
  )JS");
}

TEST_F(ArrayToSortedTest, ValidatesTheComparatorBeforeTheReceiver) {
  Check(R"JS(
    throws(() => [1].toSorted(null), TypeError);
    throws(() => [1].toSorted({}), TypeError);
    throws(() => [1].toSorted('compare'), TypeError);
    throws(() => Array.prototype.toSorted.call(null), TypeError);
    throws(() => Array.prototype.toSorted.call(undefined), TypeError);
    let lengthRead = false;
    throws(() => Array.prototype.toSorted.call(
        { get length() { lengthRead = true; return 0; } }, 1), TypeError);
    same(lengthRead, false);
    throws(() => Array.prototype.toSorted.call({ length: 2 ** 32 }),
           RangeError);
    const sentinel = {};
    try {
      Array.prototype.toSorted.call({ length: 1, get 0() { throw sentinel; } });
      throw new Error('missing exception');
    } catch (error) { same(error, sentinel); }
    same([2, 1].toSorted(undefined).join(','), '1,2');
  )JS");
}

TEST_F(ArrayToSortedTest, IsAnOrdinaryPrototypeMethod) {
  Check(R"JS(
    const descriptor =
        Object.getOwnPropertyDescriptor(Array.prototype, 'toSorted');
    same(typeof descriptor.value, 'function');
    same(descriptor.writable, true);
    same(descriptor.enumerable, false);
    same(descriptor.configurable, true);
    same(Array.prototype.toSorted.length, 1);
    same(Array.prototype.toSorted.name, 'toSorted');
    same(Array.prototype[Symbol.unscopables].toSorted, true);
    throws(() => new Array.prototype.toSorted(), TypeError);
  )JS");
}

TEST_F(ArrayToSortedTest, SurvivesCollectionInsideTheComparator) {
  Check(R"JS(
    const items = [];
    for (let i = 0; i < 2000; ++i) {
      items.push({ rank: (i * 7919) % 2000, label: 'item' + i });
    }
    let calls = 0;
    const sorted = items.toSorted((a, b) => {
      if (++calls % 4000 === 0) collect();
      return a.rank - b.rank;
    });
    same(sorted.length, 2000);
    for (let i = 0; i < sorted.length; ++i) same(sorted[i].rank, i);
    same(items[1].rank, 1919);
    collect();
    same(sorted[1999].label.startsWith('item'), true);
  )JS");
}
