// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <string>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

class LogicalAssignmentTest : public ::testing::Test {
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
                   "<logical-assignment>", LEPUS_EVAL_TYPE_GLOBAL);
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

TEST_F(LogicalAssignmentTest, AssignsOnlyWhenTheCurrentValueSelectsIt) {
  Check(R"JS(
    let a = 0, b = 1, c = null, d = undefined, e = '';
    same(a ||= 5, 5); same(a, 5);
    same(b ||= 5, 1); same(b, 1);
    same(a &&= 7, 7); same(a, 7);
    a = 0; same(a &&= 7, 0); same(a, 0);
    same(c ??= 'c', 'c'); same(c, 'c');
    same(d ??= 'd', 'd'); same(d, 'd');
    same(e ??= 'x', ''); same(e, '');
    let zero = 0, no = false, nan = NaN;
    same(zero ??= 1, 0); same(no ??= true, false); same(nan ??= 1, NaN);
    same(nan ||= 3, 3); same(no &&= true, false);
    var v;
    same(v ??= 2, 2); same(v, 2);
    let evaluated = 0;
    const count = () => ++evaluated;
    let truthy = 1, falsy = 0, defined = 0;
    truthy ||= count(); falsy &&= count(); defined ??= count();
    same(evaluated, 0);
    falsy ||= count(); truthy &&= count();
    same(evaluated, 2); same(falsy, 1); same(truthy, 2);
  )JS");
}

TEST_F(LogicalAssignmentTest, ReadsAndWritesPropertyTargetsOnce) {
  Check(R"JS(
    const trace = [];
    const target = {
      get value() { trace.push('get'); return this.stored; },
      set value(next) { trace.push('set:' + next); this.stored = next; },
      stored: 0,
    };
    const object = () => { trace.push('object'); return target; };
    const key = () => { trace.push('key'); return 'value'; };
    const right = () => { trace.push('right'); return 9; };
    same(object()[key()] ||= right(), 9);
    same(trace.join(','), 'object,key,get,right,set:9'); trace.length = 0;
    same(object().value ||= right(), 9);
    same(trace.join(','), 'object,get'); trace.length = 0;
    same(object()[key()] &&= right(), 9);
    same(trace.join(','), 'object,key,get,right,set:9'); trace.length = 0;
    target.stored = null;
    same(object().value ??= right(), 9);
    same(trace.join(','), 'object,get,right,set:9'); trace.length = 0;
    same(object()[key()] ??= right(), 9);
    same(trace.join(','), 'object,key,get'); trace.length = 0;
    const keyObject = { toString() { trace.push('toString'); return 'k'; } };
    const plain = {};
    plain[keyObject] ??= 4;
    same(plain.k, 4); same(trace.join(','), 'toString');
    const list = [0, 1];
    list[0] ||= 'first'; list[1] &&= 'second'; list[2] ??= 'third';
    same(list.join(','), 'first,second,third');
  )JS");
}

TEST_F(LogicalAssignmentTest, SkipsTheStoreWhenItShortCircuits) {
  Check(R"JS(
    const frozen = Object.freeze({ on: 1, off: 0, set: 2 });
    same(frozen.on ||= 5, 1);
    same(frozen.off &&= 5, 0);
    same(frozen.set ??= 5, 2);
    throws(() => { frozen.off ||= 5; }, TypeError);
    throws(() => { frozen.on &&= 5; }, TypeError);
    const getterOnly = { get ready() { return true; } };
    same(getterOnly.ready ||= false, true);
    throws(() => { getterOnly.ready &&= false; }, TypeError);
    const constant = 1;
    same(constant ||= 2, 1);
    same(constant ??= 2, 1);
    throws(() => { constant &&= 2; }, TypeError);
    throws(() => { late ??= 1; let late; }, ReferenceError);
    throws(() => { null.x ||= 1; }, TypeError);
    throws(() => { undefined[0] ??= 1; }, TypeError);
  )JS");
}

TEST_F(LogicalAssignmentTest, NamesAnonymousFunctionsAssignedToIdentifiers) {
  Check(R"JS(
    let first, second = 0, third = 1;
    first ??= function() {};
    second ||= () => {};
    third &&= class {};
    same(first.name, 'first');
    same(second.name, 'second');
    same(third.name, 'third');
    const holder = {};
    holder.member ??= function() {};
    same(holder.member.name, '');
    let named;
    named ??= function inner() {};
    same(named.name, 'inner');
  )JS");
}

TEST_F(LogicalAssignmentTest, SupportsSuperPrivateAndNestedTargets) {
  Check(R"JS(
    class Base {}
    Base.prototype.inherited = 0;
    class Derived extends Base {
      #count = null;
      #flag = 1;
      update() {
        super.inherited ||= 'own';
        super['other'] ??= 'second';
        this.#count ??= 10;
        this.#count &&= this.#count + 1;
        this.#flag ||= 'unused';
        return [this.inherited, this.other, this.#count, this.#flag].join();
      }
    }
    const instance = new Derived();
    same(instance.update(), 'own,second,11,1');
    same(Object.prototype.hasOwnProperty.call(instance, 'inherited'), true);
    same(Base.prototype.inherited, 0);
    let a = 0, b = 0, c = 3;
    same(a ||= b ||= c, 3); same(a, 3); same(b, 3);
    let chosen = null;
    same((chosen ??= [1, 2]).length, 2);
    let ternary = 0;
    ternary ||= a ? 'yes' : 'no'; same(ternary, 'yes');
    let arrow = null;
    arrow ??= value => value * 2; same(arrow(4), 8);
    let sequence = 0;
    same((sequence ||= 1, sequence &&= 2, sequence), 2);
    const nested = { inner: {} };
    nested.inner.deep ??= nested.inner.other ||= 6;
    same(nested.inner.deep, 6); same(nested.inner.other, 6);
    function parameters(first, second) {
      first ||= 'default'; second ??= arguments.length;
      return first + second;
    }
    same(parameters(), 'default0'); same(parameters('x', 0), 'x0');
    let closed = 0;
    const bump = () => { closed ||= 41; closed &&= closed + 1; };
    bump(); same(closed, 42);
  )JS");
}

TEST_F(LogicalAssignmentTest, HandlesGlobalAndWithScopedReferences) {
  Check(R"JS(
    const run = (0, eval);
    globalThis.logicalGlobal = 0;
    same(run('logicalGlobal ||= 7'), 7);
    same(globalThis.logicalGlobal, 7);
    same(run('logicalGlobal &&= logicalGlobal + 1'), 8);
    globalThis.logicalGlobal = null;
    same(run('logicalGlobal ??= "set"'), 'set');
    same(run('logicalGlobal ??= "kept"'), 'set');
    delete globalThis.logicalGlobal;
    throws(() => run('logicalMissing ||= 1'), ReferenceError);
    same('logicalMissing' in globalThis, false);
    throws(() => run('"use strict"; logicalMissing ??= 1'), ReferenceError);
    const scope = { present: null, kept: 5 };
    same(run('(function(scope) { with (scope) { present ??= 3; ' +
             'kept ||= 9; kept &&= kept + 1; } return scope; })')(scope),
         scope);
    same(scope.present, 3); same(scope.kept, 6);
    same(run('var logicalVar; logicalVar ??= 12; logicalVar'), 12);
    delete globalThis.logicalVar;
  )JS");
}

TEST_F(LogicalAssignmentTest, RejectsInvalidAssignmentTargets) {
  Check(R"JS(
    const run = (0, eval);
    for (const source of [
      '1 ||= 2', 'a?.b ||= 1', 'a?.[0] &&= 1', 'f() ??= 1', '(a, b) ||= 1',
      '[a] ||= [1]', '({ a } ??= {})', 'a + b &&= 1', 'this ||= 1',
      'a ||= b = > c', 'a || = 1', 'a && = 1', 'a ?? = 1',
      '"use strict"; arguments ||= 1', '"use strict"; eval ??= 1',
      'new.target ||= 1', 'a++ ||= 1',
    ]) {
      throws(() => run(source), SyntaxError);
    }
    same(run('var loose = 0; loose ||= (1, 2)'), 2);
    same(run('var grouped = null; (grouped) ??= 4'), 4);
    same(run('var spaced = 1; spaced\n&&=\n3'), 3);
    delete globalThis.loose; delete globalThis.grouped;
    delete globalThis.spaced;
  )JS");
}

TEST_F(LogicalAssignmentTest, SurvivesCollectionWhileEvaluatingTheValue) {
  Check(R"JS(
    const store = {};
    const make = index => {
      if (index % 250 === 0) collect();
      return { index, text: 'value' + index };
    };
    for (let i = 0; i < 2000; ++i) {
      store['key' + (i % 500)] ??= make(i);
      store['key' + (i % 500)].seen ||= make(i).text;
      store['key' + (i % 500)].index &&= i;
    }
    collect();
    same(Object.keys(store).length, 500);
    same(store.key7.text, 'value7');
    same(store.key7.seen, 'value7');
    same(store.key7.index, 1507);
    same(store.key0.index, 0);
  )JS");
}
