// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <string>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

class ArrayCopyMethodsTest : public ::testing::Test {
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
                   "<array-copy-methods>", LEPUS_EVAL_TYPE_GLOBAL);
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

TEST_F(ArrayCopyMethodsTest, ToReversedCopiesInReverseOrder) {
  Check(R"JS(
    const source = [1, 2, 3];
    const reversed = source.toReversed();
    same(reversed.join(','), '3,2,1');
    same(source.join(','), '1,2,3');
    same(reversed === source, false);
    same([].toReversed().length, 0);
    const sparse = [1, , 3].toReversed();
    same(sparse.length, 3); same(1 in sparse, true); same(sparse[1], undefined);
    same(Array.prototype.toReversed.call('abc').join(''), 'cba');
    same(Array.prototype.toReversed.call({ length: 2, 0: 'a', 1: 'b' })
             .join(''), 'ba');
    const reads = [];
    Array.prototype.toReversed.call(new Proxy({ length: 3 }, {
      get(target, key) { reads.push(String(key)); return target[key]; }
    }));
    same(reads.join(','), 'length,2,1,0');
    class Derived extends Array {}
    same(Derived.from([1, 2]).toReversed() instanceof Derived, false);
    throws(() => Array.prototype.toReversed.call(null), TypeError);
    throws(() => Array.prototype.toReversed.call({ length: 2 ** 32 }),
           RangeError);
  )JS");
}

TEST_F(ArrayCopyMethodsTest, WithReplacesOneElementOfTheCopy) {
  Check(R"JS(
    const source = [1, 2, 3];
    same(source.with(1, 'x').join(','), '1,x,3');
    same(source.with(-1, 'last').join(','), '1,2,last');
    same(source.with(-3, 'first').join(','), 'first,2,3');
    same(source.join(','), '1,2,3');
    same(source.with(1.9, 'x')[1], 'x');
    same(source.with('2', 'x')[2], 'x');
    same(source.with(undefined, 'x')[0], 'x');
    same(source.with(0)[0], undefined);
    throws(() => source.with(3, 0), RangeError);
    throws(() => source.with(-4, 0), RangeError);
    throws(() => source.with(Infinity, 0), RangeError);
    throws(() => [].with(0, 0), RangeError);
    throws(() => Array.prototype.with.call(null, 0, 0), TypeError);
    const order = [];
    const index = { valueOf() { order.push('index'); return 0; } };
    Array.prototype.with.call(new Proxy({ length: 2 }, {
      get(target, key) { order.push(String(key)); return target[key]; }
    }), index, 'v');
    same(order.join(','), 'length,index,1');
    const holes = [, 'b'].with(1, 'c');
    same(0 in holes, true); same(holes[0], undefined);
    same(Array.prototype.with.call('abc', 1, 'X').join(''), 'aXc');
  )JS");
}

TEST_F(ArrayCopyMethodsTest, ToSplicedRemovesAndInsertsInTheCopy) {
  Check(R"JS(
    const source = [1, 2, 3, 4, 5];
    same(source.toSpliced().join(','), '1,2,3,4,5');
    same(source.toSpliced(2).join(','), '1,2');
    same(source.toSpliced(1, 2).join(','), '1,4,5');
    same(source.toSpliced(1, 2, 'a', 'b', 'c').join(','), '1,a,b,c,4,5');
    same(source.toSpliced(-2, 1, 'x').join(','), '1,2,3,x,5');
    same(source.toSpliced(10, 1, 'end').join(','), '1,2,3,4,5,end');
    same(source.toSpliced(0, -5, 'start').join(','), 'start,1,2,3,4,5');
    same(source.toSpliced(1, 100).join(','), '1');
    same(source.toSpliced(undefined, undefined, 'u').join(','), 'u,1,2,3,4,5');
    same(source.toSpliced(1, undefined).join(','), '1,2,3,4,5');
    same(source.join(','), '1,2,3,4,5');
    const sparse = [1, , 3].toSpliced(0, 0);
    same(1 in sparse, true); same(sparse[1], undefined);
    same(Array.prototype.toSpliced.call('abc', 1, 1, 'X').join(''), 'aXc');
    same(Array.prototype.toSpliced.call({ length: 2, 0: 'a', 1: 'b' }, 1, 0,
                                        'm').join(''), 'amb');
    throws(() => Array.prototype.toSpliced.call(null), TypeError);
    throws(() => Array.prototype.toSpliced.call(
        { length: 2 ** 53 - 1 }, 0, 0, 'x'), TypeError);
    throws(() => Array.prototype.toSpliced.call({ length: 2 ** 32 }, 0, 0),
           RangeError);
    const order = [];
    const number = name => ({ valueOf() { order.push(name); return 1; } });
    [1, 2, 3].toSpliced(number('start'), number('skip'));
    same(order.join(','), 'start,skip');
  )JS");
}

TEST_F(ArrayCopyMethodsTest, AreOrdinaryPrototypeMethods) {
  Check(R"JS(
    for (const [name, length] of [['toReversed', 0], ['toSpliced', 2],
                                  ['with', 2]]) {
      const descriptor =
          Object.getOwnPropertyDescriptor(Array.prototype, name);
      same(typeof descriptor.value, 'function');
      same(descriptor.writable, true);
      same(descriptor.enumerable, false);
      same(descriptor.configurable, true);
      same(Array.prototype[name].length, length);
      same(Array.prototype[name].name, name);
      throws(() => new Array.prototype[name](), TypeError);
    }
    same(Array.prototype[Symbol.unscopables].toReversed, true);
    same(Array.prototype[Symbol.unscopables].toSpliced, true);
    same(Array.prototype[Symbol.unscopables].with, undefined);
  )JS");
}

TEST_F(ArrayCopyMethodsTest, SurvivesCollectionWhileCopying) {
  Check(R"JS(
    const items = [];
    for (let i = 0; i < 4000; ++i) items.push({ id: i });
    let reads = 0;
    const observed = new Proxy(items, {
      get(target, key) {
        if (++reads % 1500 === 0) collect();
        return target[key];
      }
    });
    const reversed = Array.prototype.toReversed.call(observed);
    const replaced = Array.prototype.with.call(observed, 7, { id: 'new' });
    const spliced = Array.prototype.toSpliced.call(observed, 1, 3998, {});
    collect();
    same(reversed.length, 4000); same(reversed[0].id, 3999);
    same(replaced[7].id, 'new'); same(replaced[3999].id, 3999);
    same(spliced.length, 3); same(spliced[2].id, 3999);
  )JS");
}
