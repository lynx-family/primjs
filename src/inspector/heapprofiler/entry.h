
// Copyright 2013 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INSPECTOR_HEAPPROFILER_ENTRY_H_
#define SRC_INSPECTOR_HEAPPROFILER_ENTRY_H_

#include <string>
#include <vector>

#include "inspector/heapprofiler/edge.h"
#include "quickjs/include/quickjs-inner.h"

namespace quickjs {
namespace heapprofiler {

class HeapSnapshot;
class HeapGraphEdge;
using SnapshotObjectId = uint64_t;
using HeapPtr = const void*;
struct JSOSRWHandler;
struct JSOSSignalHandler;
struct JSOSTimer;
struct JSSTDFile;
struct JSBigFloat;

class HeapObjPtr {
 public:
  enum PtrType {
    kDefaultPtr = 0,
    kWithoutPtr = 1,
#define DEFTAG(type, ptr) k##type,
#include "quickjs/include/quickjs-tag.h"
#undef DEFTAG
    kVarRef2Array,
    kAtom2Array,
    kShape2Array,
    kContext,
    kRuntime,
    kCString,
  };

#define deftag(type, description)
#define DEFTAG(type, description) \
  explicit HeapObjPtr(const type* ptr) : ptr_{ptr}, type_{PtrType::k##type} {}
#include "quickjs/include/quickjs-tag.h"
#undef DEFTAG
#undef deftag
  explicit HeapObjPtr(const char* str)
      : ptr_{str}, type_{PtrType::kCString}, size_{strlen(str) + 1} {}
  explicit HeapObjPtr(const LEPUSContext* ctx)
      : ptr_{ctx}, type_{PtrType::kContext} {};
  explicit HeapObjPtr(const LEPUSRuntime* rt)
      : ptr_{rt}, type_{PtrType::kRuntime} {}
  HeapObjPtr(const LEPUSValue* value, size_t size)
      : ptr_{value}, type_{PtrType::kJSValueArray}, size_{size} {}
  HeapObjPtr(JSVarRef** var_refs, size_t size)
      : ptr_{var_refs}, type_{PtrType::kVarRef2Array}, size_{size} {}
  HeapObjPtr(void* ptr, PtrType type, size_t size = 0)
      : ptr_{ptr}, type_{type}, size_{size} {}

  HeapObjPtr(JSAtomStruct** atom_array, size_t size)
      : ptr_{atom_array}, type_{kAtom2Array}, size_(size) {}
  HeapObjPtr(JSShape** shape2arr, size_t size)
      : ptr_{shape2arr}, type_{kShape2Array}, size_(size) {}

  HeapPtr ptr_;
  PtrType type_;
  size_t size_ = 0;
};

#ifdef CONFIG_BIGNUM
#define VALUE_TAG_TYPE(V)                               \
  V(LEPUS_TAG_LEPUS_REF, LEPUSLepusRef)                 \
  V(LEPUS_TAG_SEPARABLE_STRING, JSSeparableString)      \
  V(LEPUS_TAG_BIG_INT, JSBigFloat)                      \
  V(LEPUS_TAG_BIG_FLOAT, JSBigFloat)                    \
  V(LEPUS_TAG_SYMBOL, JSString)                         \
  V(LEPUS_TAG_STRING, JSString)                         \
  V(LEPUS_TAG_SHAPE, JSShape)                           \
  V(LEPUS_TAG_ASYNC_FUNCTION, JSAsyncFunctionData)      \
  V(LEPUS_TAG_VAR_REF, JSVarRef)                        \
  V(LEPUS_TAG_MODULE, LEPUSModuleDef)                   \
  V(LEPUS_TAG_FUNCTION_BYTECODE, LEPUSFunctionBytecode) \
  V(LEPUS_TAG_OBJECT, LEPUSObject)
#else
#define VALUE_TAG_TYPE(V)                               \
  V(LEPUS_TAG_LEPUS_REF, LEPUSLepusRef)                 \
  V(LEPUS_TAG_SEPARABLE_STRING, JSSeparableString)      \
  V(LEPUS_TAG_SYMBOL, JSString)                         \
  V(LEPUS_TAG_STRING, JSString)                         \
  V(LEPUS_TAG_SHAPE, JSShape)                           \
  V(LEPUS_TAG_ASYNC_FUNCTION, JSAsyncFunctionData)      \
  V(LEPUS_TAG_VAR_REF, JSVarRef)                        \
  V(LEPUS_TAG_MODULE, LEPUSModuleDef)                   \
  V(LEPUS_TAG_FUNCTION_BYTECODE, LEPUSFunctionBytecode) \
  V(LEPUS_TAG_OBJECT, LEPUSObject)
#endif

class HeapEntry {
 public:
  enum Type {
    kHidden = 0,         // Hidden node, may be filtered when shown to user.
    kArray = 1,          // An array of elements.
    kString = 2,         // A string.
    kObject = 3,         // A JS object (except for arrays and strings).
    kCode = 4,           // Compiled code.
    kClosure = 5,        // Function closure.
    kRegExp = 6,         // RegExp.
    kHeapNumber = 7,     // Number stored in the heap.
    kNative = 8,         // Native object (not from V8 heap).
    kSynthetic = 9,      // Synthetic object, usually used for grouping
                         // snapshot items together.
    kConsString = 10,    // Concatenated string. A pair of pointers to strings.
    kSlicedString = 11,  // Sliced string. A fragment of another string.
    kSymbol = 12,        // A Symbol (ES6).
    kBigInt = 13,        // BigInt.
    kObjectShape = 14,   // Internal data used for tracking the shapes (or
                         // "hidden classes") of JS objects.
    kNumberTypes,
  };

  HeapEntry(HeapSnapshot* snapshot, uint32_t index, Type type, const char* name,
            SnapshotObjectId id, size_t self_size);

  HeapEntry(HeapSnapshot* snapshot, uint32_t index, Type type,
            const std::string& name, SnapshotObjectId id, size_t self_size);

  HeapSnapshot* snapshot() { return snapshot_; }
  Type type() const { return static_cast<Type>(type_); }

  void set_type(Type type) { type_ = type; }
  const std::string& name() const { return name_; }
  void set_name(const char* name) { name_ = name; }
  void set_name(const std::string& name) { name_ = name; }

  SnapshotObjectId id() const { return id_; }

  size_t self_size() const { return self_size_; }

  uint32_t index() const { return index_; }

  // return all edges's count from the entry
  uint32_t children_count() const;

  // set chiledren_end_index according edges's count
  uint32_t set_chiledren_index(uint32_t index);

  void add_child(HeapGraphEdge* edge);

  // return the i edge from this node
  HeapGraphEdge* child(uint32_t i);

  void SetIndexedReference(HeapGraphEdge::Type type, uint32_t index,
                           HeapEntry* entry);
  void SetNamedReference(HeapGraphEdge::Type type, const char* name,
                         HeapEntry* entry);
  void SetNamedReference(HeapGraphEdge::Type type, const std::string& name,
                         HeapEntry* entry);

  void SetIndexedAutoIndexReference(HeapGraphEdge::Type type, HeapEntry* child);
  void SetNamedAutoIndexReference(HeapGraphEdge::Type type, HeapEntry* child);

 private:
  // return edge from this node
  force_inline std::vector<HeapGraphEdge*>::iterator children_begin() const;

  force_inline std::vector<HeapGraphEdge*>::iterator children_end() const;

  uint32_t type_ : 4;
  uint32_t index_ : 28;

  // constructor name
  // example Array() Array, Object, Object()

  std::string name_;

  union {
    uint32_t children_count_;
    uint32_t children_end_index_;
  };
  HeapSnapshot* snapshot_;
  size_t self_size_;

  SnapshotObjectId id_;
};

}  // namespace heapprofiler
}  // namespace quickjs

#endif  // SRC_INSPECTOR_HEAPPROFILER_ENTRY_H_
