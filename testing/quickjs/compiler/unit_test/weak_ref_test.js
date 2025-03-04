// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

function test_NewWeakRef() {
  let obj = { key: 'val' };
  let weakRef = new WeakRef(obj);
  Assert(weakRef.deref() == obj);
}

function test_NewWeakRefWithTwoParam() {
  let obj = {"key": "val"};
  let obj2 = {"key2": "val2"};
  let weakRef = new WeakRef(obj, obj2);
  Assert(weakRef.deref() == obj);
}

function test_ExpandReferenceRecord() {
  let obj = { key: 'val' };
  let weakRef1 = new WeakRef(obj);
  let weakRef2 = new WeakRef(obj);
  let weakRef3 = new WeakRef(obj);
  let weakRef4 = new WeakRef(obj);
  let weakRef5 = new WeakRef(obj);
  Assert(weakRef5.deref() == obj);
}

function test_UndefAfterFree() {
  var weakRef;
  function SetWeakRef() {
    let obj = { key: 'val' };
    weakRef = new WeakRef(obj);
  } // free obj

  SetWeakRef();
  Assert(weakRef.deref() == undefined);
}

function test_WeakRefFreeFirst() {
  let obj = { key: 'val' };
  function freeRef() {
    let weakRef = new WeakRef(obj);
  } // free ref

  freeRef();
  console.log(obj);
}

test_NewWeakRef();
test_NewWeakRefWithTwoParam();
test_ExpandReferenceRecord();
// test_UndefAfterFree();
test_WeakRefFreeFirst();
