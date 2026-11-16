'use strict';

const common = require('../../common');
const assert = require('assert');
const binding = require(`./build/export`);

let baseClass = binding.BaseClass();
let constructor = binding.Constructor();

class Class extends baseClass {
  constructor() {
    super();
    this.ok = true;
  }
  method() {
    this.ok = true;
  }
}

assert.ok(new Class() instanceof baseClass);
assert.ok(new Class().ok);
assert.ok(binding.OrdinaryFunction());
assert.ok(
  new constructor(constructor) instanceof constructor);
