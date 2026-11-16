'use strict';
const common = require('../../common');
const assert = require('assert');

// Testing handle scope api calls
const testHandleScope = require(`./build/export`);

testHandleScope.NewScope();

assert.ok(testHandleScope.NewScopeEscape() instanceof Object);

// PrimJS and JavaScriptCore do not report napi_escape_called_twice yet.
if (global.__napi_test_engine === 'V8') {
  testHandleScope.NewScopeEscapeTwice();
}

assert.throws(
  () => {
    testHandleScope.NewScopeWithException(() => { throw new RangeError(); });
  },
  RangeError);
