// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <string>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

class ObjectHasOwnTest : public ::testing::Test {
 protected:
  void SetUp() override {
    runtime_ = LEPUS_NewRuntime();
    ASSERT_NE(runtime_, nullptr);
    context_ = LEPUS_NewContext(runtime_);
    ASSERT_NE(context_, nullptr);
    RecordProperty("memory_mode", runtime_->gc_enable ? "gc" : "rc");
    LEPUSValue global = LEPUS_GetGlobalObject(context_);
    const int installed = LEPUS_SetPropertyStr(
        context_, global, "collectOwnProperty",
        LEPUS_NewCFunction(context_, Collect, "collectOwnProperty", 0));
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
      same(typeof Object.hasOwn, 'function');
    )JS") + body + "\nreturn true; })()";
    LEPUSValue result = LEPUS_Eval(context_, source.c_str(), source.size(),
                                   "<object-has-own>", LEPUS_EVAL_TYPE_GLOBAL);
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

TEST_F(ObjectHasOwnTest, StandardDescriptorAndBorrowedReceiver) {
  Check(R"JS(
    const method = Object.hasOwn;
    const descriptor = Object.getOwnPropertyDescriptor(Object, 'hasOwn');
    same(descriptor.value, method); same(descriptor.writable, true);
    same(descriptor.enumerable, false); same(descriptor.configurable, true);
    same(method.name, 'hasOwn'); same(method.length, 2);
    same(method.prototype, undefined);
    same(method.toString().includes('[native code]'), true);
    const length = Object.getOwnPropertyDescriptor(method, 'length');
    same(length.writable, false); same(length.enumerable, false);
    same(length.configurable, true);
    throws(() => new method({}, 'x'), TypeError);
    same(method.call(null, {x: 1}, 'x'), true);
    same(method.call(undefined, {}, 'x'), false);
  )JS");
}

TEST_F(ObjectHasOwnTest, OwnInheritedAndAccessorDescriptors) {
  Check(R"JS(
    const inherited = { inherited: 1, get absent() { throw new Error(); } };
    const object = Object.create(inherited);
    let reads = 0;
    Object.defineProperty(object, 'own', { get() { reads++; return 7; } });
    same(Object.hasOwn(object, 'own'), true); same(reads, 0);
    same(Object.hasOwn(object, 'inherited'), false);
    same(Object.hasOwn(object, 'absent'), false);
    same(Object.hasOwn(object, 'missing'), false);
    const bare = Object.create(null);
    bare.hasOwnProperty = () => { throw new Error(); };
    bare.__proto__ = 1; bare.undefined = 2;
    same(Object.hasOwn(bare, '__proto__'), true);
    same(Object.hasOwn(bare), true);
    for (const writable of [true, false]) {
      for (const enumerable of [true, false]) {
        const data = {};
        Object.defineProperty(data, 'value', { value: undefined, writable,
          enumerable, configurable: false });
        same(Object.hasOwn(data, 'value'), true);
      }
    }
  )JS");
}

TEST_F(ObjectHasOwnTest, PrimitiveAndIndexedExoticReceivers) {
  Check(R"JS(
    same(Object.hasOwn('abc', 0), true);
    same(Object.hasOwn('abc', 'length'), true);
    same(Object.hasOwn('abc', 3), false);
    same(Object.hasOwn('abc', 'toString'), false);
    for (const value of [true, 123, 1n, Symbol('value')]) {
      same(Object.hasOwn(value, 'constructor'), false);
    }
    same(Object.hasOwn([, 4], 0), false);
    same(Object.hasOwn([, 4], 1), true);
    same(Object.hasOwn([], 'length'), true);
    same(Object.hasOwn(new Uint8Array(2), 1), true);
    same(Object.hasOwn(new Uint8Array(2), 2), false);
  )JS");
}

TEST_F(ObjectHasOwnTest, RejectNullishBeforePropertyKeyConversion) {
  Check(R"JS(
    let calls = 0;
    const key = { get [Symbol.toPrimitive]() { calls++; throw new Error(); } };
    throws(() => Object.hasOwn(null, key), TypeError);
    throws(() => Object.hasOwn(undefined, key), TypeError);
    throws(() => Object.hasOwn(), TypeError);
    same(calls, 0);
  )JS");
}

TEST_F(ObjectHasOwnTest, PropertyKeyConversionAndAbruptCompletion) {
  Check(R"JS(
    const symbol = Symbol('own'); const object = {[symbol]: 1, '0': 2};
    same(Object.hasOwn(object, symbol), true);
    same(Object.hasOwn(object, Object(symbol)), true);
    same(Object.hasOwn(object, -0), true);
    const trace = [];
    same(Object.hasOwn(object, {[Symbol.toPrimitive](hint) {
      trace.push(hint); return symbol;
    }}), true);
    same(trace.join(','), 'string');
    trace.length = 0;
    same(Object.hasOwn(object, {toString() { trace.push('string'); return {}; },
      valueOf() { trace.push('value'); return 0; }}), true);
    same(trace.join(','), 'string,value');
    throws(() => Object.hasOwn(object, {[Symbol.toPrimitive]() {return {};}}),
           TypeError);
    const sentinel = {}; let caught = false;
    try { Object.hasOwn(object, {toString() { throw sentinel; }}); }
    catch (error) { same(error, sentinel); caught = true; }
    same(caught, true);
  )JS");
}

TEST_F(ObjectHasOwnTest, ProxyUsesDescriptorTrapAndPreservesErrors) {
  Check(R"JS(
    const trace = []; const target = {x: 1};
    const proxy = new Proxy(target, {
      has() { throw new Error('has trap must not run'); },
      get() { throw new Error('get trap must not run'); },
      ownKeys() { throw new Error('ownKeys trap must not run'); },
      getOwnPropertyDescriptor(target, key) {
        trace.push('descriptor:' + key);
        return Object.getOwnPropertyDescriptor(target, key);
      }
    });
    same(Object.hasOwn(proxy, {toString() { trace.push('key'); return 'x'; }}),
         true);
    same(trace.join(','), 'key,descriptor:x');
    same(Object.hasOwn(proxy, 'missing'), false);
    const sentinel = {}; let caught = false;
    const throwing = new Proxy({}, {getOwnPropertyDescriptor() {
      throw sentinel;
    }});
    try { Object.hasOwn(throwing, 'x'); }
    catch (error) { same(error, sentinel); caught = true; }
    same(caught, true);
    const revoked = Proxy.revocable({}, {}); revoked.revoke();
    throws(() => Object.hasOwn(revoked.proxy, 'x'), TypeError);
    const invalid = new Proxy(Object.preventExtensions({}), {
      getOwnPropertyDescriptor() { return {value: 1, configurable: true}; }
    });
    throws(() => Object.hasOwn(invalid, 'x'), TypeError);
  )JS");
}

TEST_F(ObjectHasOwnTest, CollectionDuringTemporaryReceiverKeyConversion) {
  Check(R"JS(
    for (let i = 0; i < 64; i++) {
      same(Object.hasOwn('temporary-' + i, {toString() {
        const temporary = Array.from({length: 32}, () => ({}));
        collectOwnProperty(); return 'length';
      }}), true);
    }
  )JS");
}

TEST_F(ObjectHasOwnTest, CollectionDuringSymbolKeyAndProxyDescriptor) {
  Check(R"JS(
    for (let i = 0; i < 64; i++) {
      const symbol = Symbol('owned-' + i);
      const proxy = new Proxy({[symbol]: i}, {getOwnPropertyDescriptor(target, key) {
        collectOwnProperty();
        same(key, symbol);
        return Object.getOwnPropertyDescriptor(target, key);
      }});
      same(Object.hasOwn(proxy, {[Symbol.toPrimitive]() {
        collectOwnProperty(); return symbol;
      }}), true);
    }
  )JS");
}
