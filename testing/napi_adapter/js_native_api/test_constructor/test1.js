'use strict';
const common = require('../../common');
const assert = require('assert');

// Testing api calls for a constructor that defines properties
const TestConstructor =
    require(`./build/export`).constructorName;
assert.strictEqual(TestConstructor.name, 'MyObject_Extra');
