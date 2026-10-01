'use strict';
const assert = require('assert');
const common = require('../../common');
const addon = require(`./build/export`);

addon.RunCallbackWithNullRecv(function() {
});

