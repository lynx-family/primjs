// Copyright Joyent, Inc. and other Node contributors.
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the
// "Software"), to deal in the Software without restriction, including
// without limitation the rights to use, copy, modify, merge, publish,
// distribute, sublicense, and/or sell copies of the Software, and to permit
// persons to whom the Software is furnished to do so, subject to the
// following conditions:
//
// The above copyright notice and this permission notice shall be included
// in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
// OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
// MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
// NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
// DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
// OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
// USE OR OTHER DEALINGS IN THE SOFTWARE.

/* eslint-disable node-core/crypto-check */
'use strict';

const util = require('util');
const assert = require('assert');
const buildType = "debug";

const common = {
  mustCall,
  mustNotCall,
  runCallChecks,
  gcUntil,
  buildType,
};

function gcUntil(name, condition) {
  if (typeof name === 'function') {
    condition = name;
    name = undefined;
  }
  return new Promise((resolve, reject) => {
    let count = 0;
    function gcAndCheck() {
      count++;
      global.gc();
      if (condition()) {
        resolve();
      } else if (count < 10) {
        gcAndCheck();
      } else {
        reject(name === undefined ? undefined : 'Test ' + name + ' failed');
      }
    }
    gcAndCheck();
  });
}


const mustCallChecks = [];

function runCallChecks() {
  const failed = mustCallChecks.filter(function(context) {
    if ('minimum' in context) {
      context.messageSegment = `at least ${context.minimum}`;
      return context.actual < context.minimum;
    }
    context.messageSegment = `exactly ${context.exact}`;
    return context.actual !== context.exact;
  });

  let message = '';
  let stack = '';
  failed.forEach(function(context) {
    message += 'Mismatched ' + context.name + ' function calls. Expected ' + context.messageSegment + ', actual ' + context.actual + '. ';
    stack += context.stack.split('\n').slice(2).join('\n') + '\n';
  });

  if (failed.length) {
    assert.fail(message + " stack: " + stack);
  }
}

window.runCallChecks = runCallChecks;

function getCallSite(top) {
  const originalStackFormatter = Error.prepareStackTrace;
  Error.prepareStackTrace = (err, stack) =>
    `${stack[0].getFileName()}:${stack[0].getLineNumber()}`;
  const err = new Error();
  // Error.captureStackTrace(err, top);
  // With the V8 Error API, the stack is not formatted until it is accessed
  err.stack;
  Error.prepareStackTrace = originalStackFormatter;
  return err.stack;
}

function mustNotCall(msg) {
  const callSite = getCallSite(mustNotCall);
  return function mustNotCall(...args) {
    const argsInfo = args.length > 0 ?
      `\ncalled with arguments: ${args.map(util.inspect).join(', ')}` : '';
    assert.fail(
      `${msg || 'function should not have been called'} at ${callSite}` +
      argsInfo);
  };
}

function mustCall(fn, exact) {
  return _mustCallInner(fn, exact, 'exact');
}

function mustCallAtLeast(fn, minimum) {
  return _mustCallInner(fn, minimum, 'minimum');
}

function _mustCallInner(fn, criteria = 1, field) {
  if (typeof fn === 'number') {
    criteria = fn;
    fn = () => {};
  } else if (fn === undefined) {
    fn = () => {};
  }

  if (typeof criteria !== 'number')
    throw new TypeError(`Invalid ${field} value: ${criteria}`);

  const context = {
    [field]: criteria,
    actual: 0,
    stack: util.inspect(new Error()),
    name: fn.name || '<anonymous>'
  };

  mustCallChecks.push(context);

  return function() {
    context.actual++;
    return fn.apply(this, arguments);
  };
}

const validProperties = new Set(Object.keys(common));
module.exports = new Proxy(common, {
  get(obj, prop) {
    if (!validProperties.has(prop))
      throw new Error(`Using invalid common property: '${prop}'`);
    return obj[prop];
  },
});