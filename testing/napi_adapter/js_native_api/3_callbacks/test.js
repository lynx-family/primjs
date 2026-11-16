'use strict';
const common = require('../../common');
const assert = require('assert');
const addon = require(`./build/export`);

addon.RunCallback(function(msg) {
  assert.strictEqual(msg, 'hello world');
});

function testRecv(desiredRecv) {
  const callback = function() {
    assert.strictEqual(this, desiredRecv);
  };
  callback.apply = function() {
    assert.fail('napi_call_function must ignore a callback own apply property');
  };
  addon.RunCallbackWithRecv(callback, desiredRecv);
}

testRecv(undefined);
testRecv(null);
testRecv(5);
testRecv(true);
testRecv('Hello');
testRecv([]);
testRecv({});

const originalApply = Reflect.apply;
Reflect.apply = function() {
  assert.fail('napi_call_function must ignore a replaced Reflect.apply');
};
try {
  [undefined, null, 5, true, 'Hello', [], {}].forEach(testRecv);
} finally {
  Reflect.apply = originalApply;
}
