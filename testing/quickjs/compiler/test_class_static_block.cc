// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <string>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/quickjs.h"
}
#include "gc/trace-gc.h"
#include "quickjs/include/quickjs-inner.h"

class ClassStaticBlockTest : public ::testing::Test {
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
                   "<class-static-block>", LEPUS_EVAL_TYPE_GLOBAL);
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

TEST_F(ClassStaticBlockTest, RunsWithTheClassAsThisInSourceOrder) {
  Check(R"JS(
    same(eval('(class { static x; static { this.x = 1; } }).x'), 1);
    const order = [];
    class Ordered {
      static first = (order.push('first'), 1);
      static {
        order.push('block:' + this.first + ':' + (this === Ordered));
        this.second = 2;
      }
      static third = (order.push('third:' + this.second), 3);
      static { order.push('last:' + this.third); }
      static {}
    }
    same(order.join(','), 'first,block:1:true,third:2,last:3');
    same(Ordered.second, 2);
    same(Object.keys(Ordered).join(','), 'first,second,third');
    let target;
    const Expression = class Named { static { target = Named; } };
    same(target, Expression);
    let seenNewTarget = 'unset';
    class Target { static { seenNewTarget = new.target; } }
    same(seenNewTarget, undefined);
    class OnlyBlock { static { this.ready = true; } }
    same(OnlyBlock.ready, true);
  )JS");
}

TEST_F(ClassStaticBlockTest, SharesPrivateNamesAndSuperWithTheClass) {
  Check(R"JS(
    let read, readStatic;
    class Vault {
      #secret;
      static #count = 0;
      constructor(secret) { this.#secret = secret; Vault.#count++; }
      static {
        read = vault => vault.#secret;
        readStatic = () => Vault.#count;
        this.#count = 10;
      }
    }
    same(read(new Vault('key')), 'key');
    same(readStatic(), 11);
    throws(() => read({}), TypeError);
    class Base { static inherited = 'base'; static greet() { return 'hi'; } }
    let viaSuper, viaMethod;
    class Derived extends Base {
      static {
        viaSuper = super.inherited;
        viaMethod = super.greet();
        super.assigned = 'set';
      }
    }
    same(viaSuper, 'base'); same(viaMethod, 'hi');
    same(Derived.assigned, 'set');
    same(Object.prototype.hasOwnProperty.call(Base, 'assigned'), false);
  )JS");
}

TEST_F(ClassStaticBlockTest, GivesEachBlockItsOwnVariableScope) {
  Check(R"JS(
    const seen = [];
    class Scoped {
      static {
        var hoisted = 'one';
        let local = 'let';
        const fixed = 'const';
        function declared() { return 'function'; }
        class Inner { static { seen.push('inner:' + hoisted); } }
        seen.push([hoisted, local, fixed, declared()].join('|'));
      }
      static {
        seen.push(typeof hoisted + '|' + typeof local + '|' + typeof declared);
        var hoisted = 'two';
        seen.push(hoisted);
      }
    }
    same(seen.join(','),
         'inner:one,one|let|const|function,undefined|undefined|undefined,two');
    same(typeof hoisted, 'undefined');
    const captured = [];
    class Closures {
      static {
        for (let i = 0; i < 3; ++i) captured.push(() => i * 2);
      }
    }
    same(captured.map(call => call()).join(','), '0,2,4');
    let total = 0;
    class Control {
      static {
        outer: for (const a of [1, 2, 3]) {
          for (const b of [1, 2, 3]) {
            if (b === 2) continue outer;
            if (a === 3) break outer;
            total += a * b;
          }
        }
        try { throw new Error('caught'); } catch (error) { total += 10; }
      }
    }
    same(total, 13);
  )JS");
}

TEST_F(ClassStaticBlockTest, RejectsArgumentsAwaitAndReturn) {
  Check(R"JS(
    const run = (0, eval);
    for (const source of [
      'class A { static { arguments; } }',
      'class A { static { (() => arguments)(); } }',
      'class A { static { await; } }',
      'class A { static { await 1; } }',
      'class A { static { var await; } }',
      'class A { static { (await => 0); } }',
      'class A { static { ((a = await) => 0); } }',
      'class A { static { await: 1; } }',
      'class A { static { return; } }',
      'class A { static { return 1; } }',
      'class A { static { if (true) return; } }',
      'class A { static { super(); } }',
      'class A { static { yield; } }',
      'class A { static { let a; let a; } }',
      'class A { static { var a; let a; } }',
      'class A { static { break; } }',
      'class A { static {} static }',
      'class A { static { }',
      'async function f() { class A { static { await 1; } } }',
      'function* g() { class A { static { yield 1; } } }',
    ]) {
      try {
        run(source);
      } catch (error) {
        if (error instanceof SyntaxError) continue;
        throw error;
      }
      throw new Error('no SyntaxError: ' + source);
    }
    same(run(`(class {
      static {
        function nested() { var await = 3; return arguments.length + await; }
        this.value = nested(1, 2);
        this.arrow = (() => { return 'arrow'; })();
        this.property = { await: 1, return: 2 }.await;
        this.later = async () => { await null; return 'async'; };
      }
    })`).value, 5);
    same(run('(class { static {} await() { return 1; } })').prototype.await(),
         1);
    same(run(`(class {
      static {
        this.binding = (() => { var await = 6; return await; })();
        this.shorthand = (() => { const await = 7; return { await }; })();
        this.caught = (() => { try { throw 8; } catch (await) { return await; } })();
        this.named = (() => { class await {} return await.name; })();
      }
    })`).shorthand.await, 7);
    throws(() => run('(class { static { (() => await)(); } })'),
           ReferenceError);
    same(run('(class { static; static { this.set = this.static; } })').set,
         undefined);
    same(run('(class { static static() { return 4; } static { this.four = ' +
             'this.static(); } })').four, 4);
    same(run('(class { static { "use strict"; this.directive = 1; } })')
             .directive, 1);
  )JS");
}

TEST_F(ClassStaticBlockTest, PropagatesExceptionsFromTheBlock) {
  Check(R"JS(
    const sentinel = {};
    const order = [];
    try {
      class Broken {
        static before = order.push('before');
        static { order.push('block'); throw sentinel; }
        static after = order.push('after');
      }
      throw new Error('missing exception');
    } catch (error) { same(error, sentinel); }
    same(order.join(','), 'before,block');
    throws(() => {
      class Early { static { Later; } }
      class Later {}
    }, ReferenceError);
    let assigned;
    throws(() => { assigned = class { static { null.x; } }; }, TypeError);
    same(assigned, undefined);
  )JS");
}

TEST_F(ClassStaticBlockTest, SurvivesCollectionInsideTheBlock) {
  Check(R"JS(
    const classes = [];
    for (let round = 0; round < 200; ++round) {
      classes.push(class {
        static #items = [];
        static {
          for (let i = 0; i < 20; ++i) this.#items.push({ round, i });
          if (round % 50 === 0) collect();
          this.total = this.#items.reduce((sum, item) => sum + item.i, 0);
          this.read = () => this.#items.length;
        }
      });
    }
    collect();
    same(classes.length, 200);
    same(classes[199].total, 190);
    same(classes[0].read(), 20);
  )JS");
}
