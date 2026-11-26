// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <cstring>
#include <string>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

class RelativeIndexingTest : public ::testing::Test {
 protected:
  void SetUp() override {
    runtime_ = LEPUS_NewRuntime();
    ASSERT_NE(runtime_, nullptr);
    context_ = LEPUS_NewContext(runtime_);
    ASSERT_NE(context_, nullptr);
    RecordProperty("memory_mode", runtime_->gc_enable ? "gc" : "rc");
    LEPUSValue global = LEPUS_GetGlobalObject(context_);
    const int installed = LEPUS_SetPropertyStr(
        context_, global, "collectRelativeIndexing",
        LEPUS_NewCFunction(context_, Collect, "collectRelativeIndexing", 0));
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
        if (!Object.is(value, expected)) throw new Error('different values');
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
                   "<relative-indexing>", LEPUS_EVAL_TYPE_GLOBAL);
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

TEST_F(RelativeIndexingTest, ArrayRelativeBoundsAndSparseInheritance) {
  Check(R"JS(
    const a = [10, , 30];
    same(a.at(), 10); same(a.at(-0), 10); same(a.at(NaN), 10);
    same(a.at(1), undefined); same(a.at(-1), 30); same(a.at(-3), 10);
    same(a.at(3), undefined); same(a.at(-4), undefined);
    same(a.at(1.9), undefined); same(a.at(-1.9), 30);
    same(a.at(Infinity), undefined); same(a.at(-Infinity), undefined);
    const inherited = Object.create(Array.prototype); inherited[1] = 'parent';
    Object.setPrototypeOf(a, inherited); same(a.at(1), 'parent');
    same(Array.prototype.at.call('xy', -1), 'y');
  )JS");
}

TEST_F(RelativeIndexingTest, ArrayCoercionAndPropertyAccessOrder) {
  Check(R"JS(
    const trace = [];
    const object = new Proxy({ length: 2, 1: 'last' }, {
      get(target, key) { trace.push(key); return Reflect.get(target, key); }
    });
    const index = { valueOf() { trace.push('index'); return -1; } };
    same(Array.prototype.at.call(object, index), 'last');
    same(trace.join(','), 'length,index,1'); trace.length = 0;
    same(Array.prototype.at.call(object, 3), undefined);
    same(trace.join(','), 'length');
    let coerced = 0;
    same([].at({ valueOf() { ++coerced; return 0; } }), undefined);
    same(coerced, 1);
  )JS");
}

TEST_F(RelativeIndexingTest, ArrayLengthAndIndexDoNotWrap) {
  Check(R"JS(
    const object = { length: Infinity, 9007199254740990: 'maximum' };
    same(Array.prototype.at.call(object, -1), 'maximum');
    same(Array.prototype.at.call({ length: 2 ** 40, 1099511627775: 7 }, -1), 7);
    same(Array.prototype.at.call({ length: 2.9, 1: 4 }, -1), 4);
    same(Array.prototype.at.call({ length: -3, 0: 4 }, 0), undefined);
    same([1].at(2 ** 100), undefined); same([1].at(-(2 ** 100)), undefined);
  )JS");
}

TEST_F(RelativeIndexingTest, ArrayAbruptCompletionAndReceiverValidation) {
  Check(R"JS(
    throws(() => Array.prototype.at.call(null), TypeError);
    throws(() => Array.prototype.at.call(undefined), TypeError);
    throws(() => [1].at(Symbol()), TypeError);
    throws(() => [1].at(1n), TypeError);
    throws(() => Array.prototype.at.call({ length: 1n }, 0), TypeError);
    const sentinel = {}; let touched = false;
    try {
      Array.prototype.at.call({ get length() { throw sentinel; } },
        { valueOf() { touched = true; return 0; } });
      throw new Error('missing length failure');
    } catch (error) { same(error, sentinel); }
    same(touched, false);
  )JS");
}

TEST_F(RelativeIndexingTest, StringRelativeBoundsAndUtf16CodeUnits) {
  Check(R"JS(
    same('abc'.at(), 'a'); same('abc'.at(-0), 'a'); same('abc'.at(NaN), 'a');
    same('abc'.at(-1), 'c'); same('abc'.at(-3), 'a');
    same('abc'.at(-4), undefined); same('abc'.at(3), undefined);
    same('abc'.at(1.9), 'b'); same('abc'.at(-1.9), 'c');
    same('abc'.at(Infinity), undefined); same('abc'.at(-Infinity), undefined);
    same(''.at(), undefined); same('\u00e9'.at(0), '\u00e9');
    same('\u6f22'.at(-1), '\u6f22'); same('\ud800'.at(0), '\ud800');
    same('A\ud83d\ude03B'.at(1), '\ud83d');
    same('A\ud83d\ude03B'.at(-2), '\ude03');
    same('abc'.at(2 ** 100), undefined);
  )JS");
}

TEST_F(RelativeIndexingTest, StringCoercionAndAbruptCompletion) {
  Check(R"JS(
    const trace = [];
    const object = { toString() { trace.push('string'); return 'abc'; } };
    const index = { valueOf() { trace.push('index'); return -1; } };
    same(String.prototype.at.call(object, index), 'c');
    same(trace.join(','), 'string,index');
    throws(() => String.prototype.at.call(null, index), TypeError);
    throws(() => String.prototype.at.call(undefined), TypeError);
    throws(() => String.prototype.at.call(Symbol()), TypeError);
    throws(() => 'x'.at(1n), TypeError); throws(() => 'x'.at(Symbol()), TypeError);
    const sentinel = {}; let caught = false;
    try { 'abc'.at({ valueOf() { throw sentinel; } }); }
    catch (error) { same(error, sentinel); caught = true; }
    same(caught, true);
  )JS");
}

TEST_F(RelativeIndexingTest, StandardMethodDescriptors) {
  Check(R"JS(
    for (const prototype of [Array.prototype, String.prototype]) {
      const descriptor = Object.getOwnPropertyDescriptor(prototype, 'at');
      same(descriptor.writable, true); same(descriptor.configurable, true);
      same(descriptor.enumerable, false); same(descriptor.value.name, 'at');
      same(descriptor.value.length, 1);
      same(Object.getOwnPropertyDescriptor(descriptor.value, 'prototype'), undefined);
      throws(() => new descriptor.value(), TypeError);
    }
    same(Array.prototype[Symbol.unscopables].at, true);
  )JS");
}

TEST_F(RelativeIndexingTest, CollectionDuringTemporaryStringConversion) {
  Check(R"JS(
    for (let i = 0; i < 40; ++i) {
      const temporary = { toString() { return 'a'.repeat(257) + 'z'; } };
      const index = { valueOf() { collectRelativeIndexing(); return -1; } };
      same(String.prototype.at.call(temporary, index), 'z');
    }
  )JS");
}

TEST_F(RelativeIndexingTest, CollectionDuringGenericArrayAccess) {
  Check(R"JS(
    const marker = { intact: true };
    const object = {
      get length() { collectRelativeIndexing(); return 2; },
      get 1() { collectRelativeIndexing(); return marker; }
    };
    const index = { valueOf() { collectRelativeIndexing(); return -1; } };
    same(Array.prototype.at.call(object, index), marker);
    same(Array.prototype.at.call('xy', index), 'y');
    const values = [marker]; const retained = values.at(-1);
    values.length = 0; collectRelativeIndexing(); same(retained.intact, true);
  )JS");
}
