// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

function test_FinalizationRegistryConstructorCallAsFunction() {
  let caught = false;
  let message = "";
  try {
    let f = FinalizationRegistry(() => {});
  } catch (e) {
    message = e.message;
    caught = true;
  } finally {
    Assert(caught == true);
  }
}

function test_UnregisterWithNonExistentKey() {
  let fg = new FinalizationRegistry(() => {});
  let success = fg.unregister({"k": "whatever"});
  Assert(success == false);
}

function test_FinalizationRegistry() {
  let cleanup_called = false;
  let cleanup = function(holdings) {
    let holdings_list = [];
    holdings_list.push(holdings);
    cleanup_called = true;
  }

  let fg = new FinalizationRegistry(cleanup);
  (function() {
    let o = {};
    fg.register(o, "holdings");
  })();

  Assert(cleanup_called == true);
}

function test_UnregisterTwice() {
  let cleanup_call_count = 0;
  let cleanup = function(holdings) {
    ++cleanup_call_count;
  }
  let fg = new FinalizationRegistry(cleanup);
  let key = {"k": "this is the key"};

  let object = {};
  fg.register(object, "holdings", key);

  let success = fg.unregister(key);
  Assert(success == true);

  success = fg.unregister(key);
  Assert(success == false);
}

test_FinalizationRegistryConstructorCallAsFunction();
test_UnregisterWithNonExistentKey();
// test_FinalizationRegistry();
test_UnregisterTwice();
