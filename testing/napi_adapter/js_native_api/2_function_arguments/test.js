'use strict';
const common = require('../../common');
const assert = require('assert');
const addon = require(`./build/export`);

assert.strictEqual(addon.add(3, 5), 8);
