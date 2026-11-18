'use strict';
const common = require('../../common');
const assert = require('assert');

const getterOnlyErrorRE =
  "TypeError: Cannot set property .* of #<.*> which has only a getter";

// Testing api calls for a constructor that defines properties
const TestConstructor = require(`./build/export`);
const test_object = new TestConstructor();

assert.strictEqual(test_object.echo('hello'), 'hello');

test_object.readwriteValue = 1;
assert.strictEqual(test_object.readwriteValue, 1);
test_object.readwriteValue = 2;
assert.strictEqual(test_object.readwriteValue, 2);

assert.throws(() => { test_object.readonlyValue = 3; },
              "TypeError: Cannot assign to read only property 'readonlyValue' of object '#<MyObject>'");

assert.ok(test_object.hiddenValue);

// Properties with napi_enumerable attribute should be enumerable.
const propertyNames = [];
for (const name in test_object) {
  propertyNames.push(name);
}
assert.ok(propertyNames.includes('echo'));
assert.ok(propertyNames.includes('readwriteValue'));
assert.ok(propertyNames.includes('readonlyValue'));
assert.ok(!propertyNames.includes('hiddenValue'));
assert.ok(!propertyNames.includes('readwriteAccessor1'));
assert.ok(!propertyNames.includes('readwriteAccessor2'));
assert.ok(!propertyNames.includes('readonlyAccessor1'));
assert.ok(!propertyNames.includes('readonlyAccessor2'));

// The napi_writable attribute should be ignored for accessors.
test_object.readwriteAccessor1 = 1;
assert.strictEqual(test_object.readwriteAccessor1, 1);
assert.strictEqual(test_object.readonlyAccessor1, 1);
assert.throws(() => { test_object.readonlyAccessor1 = 3; }, getterOnlyErrorRE);
test_object.readwriteAccessor2 = 2;
assert.strictEqual(test_object.readwriteAccessor2, 2);
assert.strictEqual(test_object.readonlyAccessor2, 2);
assert.throws(() => { test_object.readonlyAccessor2 = 3; }, getterOnlyErrorRE);

// Validate that static properties are on the class as opposed
// to the instance
assert.strictEqual(TestConstructor.staticReadonlyAccessor1, 10);
assert.strictEqual(test_object.staticReadonlyAccessor1, undefined);

// Verify that passing NULL to napi_define_class() results in the correct
// error.
assert.deepStrictEqual(TestConstructor.TestDefineClass(), {
  envIsNull: 'Invalid argument',
  nameIsNull: 'Invalid argument',
  cbIsNull: 'Invalid argument',
  cbDataIsNull: 'napi_ok',
  propertiesIsNull: 'Invalid argument',
  resultIsNull: 'Invalid argument'
});

// A native constructor may leave its result unset or return a primitive.
// Both JavaScript `new` and native factories must retain the created instance.
{
  const Constructor = TestConstructor.createReturnValueConstructor();
  const checkInstance = (instance) => {
    assert.ok(instance instanceof Constructor);
    assert.strictEqual(Object.getPrototypeOf(instance), Constructor.prototype);
    assert.strictEqual(instance.nativeConstructor, Constructor);
  };
  checkInstance(new Constructor());
  checkInstance(TestConstructor.constructWithReturnValue(Constructor));
  for (const value of [undefined, null, false, 42, 'ignored', Symbol('ignored')]) {
    checkInstance(new Constructor(value));
    checkInstance(TestConstructor.constructWithReturnValue(Constructor, value));
  }
  for (const value of [{replacement: true}, function replacement() {}]) {
    assert.strictEqual(new Constructor(value), value);
    assert.strictEqual(
      TestConstructor.constructWithReturnValue(Constructor, value), value);
  }
}
