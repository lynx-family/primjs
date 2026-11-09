'use strict';

  const common = require('../../common');
  const test_general = require(`./build/export`);

  // The second argument to `envCleanupWrap()` is an index into the global
  // static string array named `env_cleanup_finalizer_messages` on the native
  // side. A reverse mapping is reproduced here for clarity.
  const finalizerMessages = {
    'simple wrap': 0,
    'wrap, removeWrap': 1,
    'first wrap': 2,
    'second wrap': 3
  };

  // We attach the three objects we will test to `module.exports` to ensure they
  // will not be garbage-collected before the process exits.

  // Make sure the finalizer for a simple wrap will be called at env cleanup.
  module.exports['simple wrap'] =
    test_general.envCleanupWrap({}, finalizerMessages['simple wrap']);

  // Make sure that a removed wrap does not result in a call to its finalizer at
  // env cleanup.
  module.exports['wrap, removeWrap'] =
    test_general.envCleanupWrap({}, finalizerMessages['wrap, removeWrap']);
  test_general.removeWrap(module.exports['wrap, removeWrap']);

  // Make sure that only the latest attached version of a re-wrapped item's
  // finalizer gets called at env cleanup.
  module.exports['first wrap'] =
    test_general.envCleanupWrap({}, finalizerMessages['first wrap']),
  test_general.removeWrap(module.exports['first wrap']);
  test_general.envCleanupWrap(module.exports['first wrap'],
                              finalizerMessages['second wrap']);

