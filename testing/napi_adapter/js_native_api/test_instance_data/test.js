'use strict';
// Test API calls for instance data.

const common = require('../../common');
const assert = require('assert');

if (true) {
  // When required as a module, run the tests.
  const test_instance_data =
    require(`./build/export`);

  // Print to stdout when the environment deletes the instance data. This output
  // is checked by the parent process.
  test_instance_data.setPrintOnDelete();

  // Test that instance data can be accessed from a binding.
  assert.strictEqual(test_instance_data.increment(), 42);

  // Test that the instance data can be accessed from a finalizer.
  test_instance_data.objectWithFinalizer(common.mustCall());
  global.gc();
}