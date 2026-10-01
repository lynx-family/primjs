'use strict';
const common = require('../../common');
const assert = require('assert');

// N-API addon exporting BaseClass, SubClass and setupInheritance()
const addon = require('./build/export');

// Basic shape checks for the exported constructors.
assert.strictEqual(typeof addon.BaseClass, 'function');
assert.strictEqual(typeof addon.SubClass, 'function');

// Before wiring prototypes, SubClass should not have BaseClass methods.
assert.strictEqual(addon.SubClass.baseStatic, undefined);
const subBefore = new addon.SubClass();
assert.strictEqual(subBefore.baseInstance, undefined);

// Use N-API powered helper to connect the prototype chains:
//   - SubClass.__proto__ = BaseClass
//   - SubClass.prototype.__proto__ = BaseClass.prototype
addon.setupInheritance();

// After inheritance is established, SubClass should see BaseClass static method.
assert.strictEqual(addon.BaseClass.baseStatic(), 'baseStatic');
assert.strictEqual(addon.SubClass.baseStatic(), 'baseStatic');

// And instances of SubClass should see BaseClass instance method.
const sub = new addon.SubClass();
assert.ok(sub instanceof addon.BaseClass, 'sub should be instanceof BaseClass');
assert.ok(sub instanceof addon.SubClass, 'sub should be instanceof SubClass');
assert.ok(typeof sub.baseInstance === 'function', 'sub.baseInstance should be function');

assert.strictEqual(sub.baseInstance(), 'baseInstance');

// Also verify the prototype chain shape from JavaScript side.
assert.strictEqual(Object.getPrototypeOf(addon.SubClass), addon.BaseClass);
assert.strictEqual(Object.getPrototypeOf(addon.SubClass.prototype),
                   addon.BaseClass.prototype);
