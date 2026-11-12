// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <string>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

class TypedArrayAtTest : public ::testing::Test {
 protected:
  void SetUp() override {
    runtime_ = LEPUS_NewRuntime();
    ASSERT_NE(runtime_, nullptr);
    context_ = LEPUS_NewContext(runtime_);
    ASSERT_NE(context_, nullptr);
    RecordProperty("memory_mode", runtime_->gc_enable ? "gc" : "rc");
    LEPUSValue global = LEPUS_GetGlobalObject(context_);
    const int collect = LEPUS_SetPropertyStr(
        context_, global, "collect",
        LEPUS_NewCFunction(context_, Collect, "collect", 0));
    const int detach = LEPUS_SetPropertyStr(
        context_, global, "detachArrayBuffer",
        LEPUS_NewCFunction(context_, Detach, "detachArrayBuffer", 1));
    Release(global);
    ASSERT_GE(collect, 0);
    ASSERT_GE(detach, 0);
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
  static LEPUSValue Detach(LEPUSContext* context, LEPUSValueConst, int,
                           LEPUSValueConst* argv) {
    LEPUS_DetachArrayBuffer(context, argv[0]);
    return LEPUS_UNDEFINED;
  }
  void Release(LEPUSValue value) {
    if (!runtime_->gc_enable) LEPUS_FreeValue(context_, value);
  }
  void Check(const char* body) {
    const std::string source = std::string(R"JS((function() {
      'use strict';
      function same(value, expected) {
        if (!Object.is(value, expected))
          throw new Error(String(value) + ' !== ' + String(expected));
      }
      function throws(operation, constructor) {
        try { operation(); } catch (error) {
          if (error instanceof constructor) return;
          throw error;
        }
        throw new Error('missing exception');
      }
      const TypedArray = Object.getPrototypeOf(Int8Array);
      const at = TypedArray.prototype.at;
    )JS") + body + "\nreturn true; })()";
    LEPUSValue result = LEPUS_Eval(context_, source.c_str(), source.size(),
                                   "<typed-array-at>", LEPUS_EVAL_TYPE_GLOBAL);
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

TEST_F(TypedArrayAtTest, RelativeIndexAndIntegerConversion) {
  Check(R"JS(
    const a = new Int16Array([10, 20, 30]);
    same(a.at(), 10); same(a.at(-0), 10); same(a.at(NaN), 10);
    same(a.at(2), 30); same(a.at(-1), 30); same(a.at(-3), 10);
    same(a.at(3), undefined); same(a.at(-4), undefined);
    same(a.at(1.9), 20); same(a.at(-1.9), 30); same(a.at(-0.5), 10);
    same(a.at('1'), 20); same(a.at(null), 10); same(a.at(true), 20);
    same(a.at(Infinity), undefined); same(a.at(-Infinity), undefined);
    same(a.at(2 ** 100), undefined); same(a.at(-(2 ** 100)), undefined);
    same(a.at(2 ** 32), undefined); same(a.at(-(2 ** 32) - 1), undefined);
    same(new Float64Array(0).at(0), undefined);
    same(new Float64Array(0).at(-1), undefined);
  )JS");
}

TEST_F(TypedArrayAtTest, ElementTypesViewsAndSubclasses) {
  Check(R"JS(
    same(new Uint8Array([255]).at(-1), 255);
    same(new Int8Array([-128]).at(0), -128);
    same(new Uint8ClampedArray([300]).at(0), 255);
    same(new Uint32Array([0xffffffff]).at(0), 4294967295);
    same(new Float32Array([NaN]).at(-1), NaN);
    same(new Float64Array([-0]).at(0), -0);
    same(new BigInt64Array([-1n, 2n]).at(-2), -1n);
    same(new BigUint64Array([2n ** 64n - 1n]).at(0), 2n ** 64n - 1n);
    const sub = new Int8Array([1, 2, 3, 4]).subarray(1, 3);
    same(sub.at(0), 2); same(sub.at(-1), 3); same(sub.at(2), undefined);
    const view = new Int16Array(new ArrayBuffer(8), 2, 2);
    view[1] = 9; same(view.at(-1), 9); same(view.at(-3), undefined);
    class Bytes extends Uint8Array {}
    same(new Bytes([4, 5]).at(-1), 5);
  )JS");
}

TEST_F(TypedArrayAtTest, ReceiverValidationPrecedesIndexConversion) {
  Check(R"JS(
    let coerced = 0;
    const index = { valueOf() { ++coerced; return 0; } };
    const receivers = [undefined, null, 1, 'ab', [1], { length: 1, 0: 1 },
                       new ArrayBuffer(1), new DataView(new ArrayBuffer(1))];
    for (const receiver of receivers)
      throws(() => at.call(receiver, index), TypeError);
    same(coerced, 0);
    const detached = new Uint8Array([1, 2]);
    detachArrayBuffer(detached.buffer);
    throws(() => detached.at(index), TypeError);
    throws(() => detached.at(0), TypeError);
    same(coerced, 0);
  )JS");
}

TEST_F(TypedArrayAtTest, IndexConversionCanDetachOrCollect) {
  Check(R"JS(
    const a = new Float64Array([1.5, 2.5]);
    same(a.at({ valueOf() { detachArrayBuffer(a.buffer); return 0; } }),
         undefined);
    same(a.length, 0);
    const b = new Int32Array([7, 8]);
    same(b.at({ valueOf() { detachArrayBuffer(b.buffer); collect();
                            return -1; } }), undefined);
    const c = new Uint16Array([5, 6, 7]);
    same(c.at({ valueOf() {
      const junk = [];
      for (let i = 0; i < 1000; ++i) junk.push({ i, s: 'x' + i });
      collect();
      return -2;
    } }), 6);
  )JS");
}

TEST_F(TypedArrayAtTest, AbruptIndexConversion) {
  Check(R"JS(
    const a = new Uint8Array([1]);
    throws(() => a.at({ valueOf() { throw new RangeError('index'); } }),
           RangeError);
    throws(() => a.at(Symbol()), TypeError);
    throws(() => a.at(1n), TypeError);
  )JS");
}

TEST_F(TypedArrayAtTest, PropertyDescriptor) {
  Check(R"JS(
    const desc = Object.getOwnPropertyDescriptor(TypedArray.prototype, 'at');
    same(desc.value, at); same(desc.writable, true);
    same(desc.enumerable, false); same(desc.configurable, true);
    same(at.name, 'at'); same(at.length, 1);
    throws(() => new at(0), TypeError);
    const constructors = [Int8Array, Uint8Array, Uint8ClampedArray, Int16Array,
                          Uint16Array, Int32Array, Uint32Array, Float32Array,
                          Float64Array, BigInt64Array, BigUint64Array];
    for (const C of constructors) {
      same(Object.prototype.hasOwnProperty.call(C.prototype, 'at'), false);
      same(C.prototype.at, at);
    }
  )JS");
}
