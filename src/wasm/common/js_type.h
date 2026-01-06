// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_JS_TYPE_H_
#define SRC_WASM_COMMON_JS_TYPE_H_

#include "wasm_type.h"
#if defined(__APPLE__)
#include <JavaScriptCore/JavaScriptCore.h>
#endif

#include "gc/persistent-handle.h"
#include "one_of.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs {
template <typename ValueType>
struct JSValueType;

// Empty struct for default definition
struct DefaultType {};

// Default definition for JSValueType
template <typename ValueType>
struct JSValueType {};

#define JS_NULL WASMGCPersistent(LEPUS_NULL);

// Specialization for JS engine: JSC
template <>
struct JSValueType<LEPUSValue> {
  using Context = LEPUSContext*;
  using Type = WASMGCPersistent;
  using Object = WASMGCPersistent;
  Type null_value_ = WASMGCPersistent(LEPUS_NULL);
};

#if !defined(__APPLE__)
using JSValueRef = const struct DefaultType*;
using JSObjectRef = struct DefaultType*;
using JSContextRef = struct DefaultType*;
#endif

template <>
struct JSValueType<JSValueRef> {
  using Context = JSContextRef;
  using Type = JSValueRef;
  using Object = JSObjectRef;
  Type null_value_ = nullptr;
};

// Type aliases using CRTP
template <typename ValueType>
using JSValue = typename JSValueType<ValueType>::Type;

template <typename ValueType>
using JSObject = typename JSValueType<ValueType>::Object;

template <typename ValueType>
using JSContext = typename JSValueType<ValueType>::Context;

using JSValueRefs = OneOf<WASMGCPersistent, JSObjectRef>;

enum class ErrorTypes { kError = 0, kTypeError, kRangeError };
constexpr const char* kErrorStrings[] = {"Error", "TypeError", "RangeError"};

#if !defined(__APPLE__)
namespace jsc {
class JSCEnv {};
}  // namespace jsc
#endif
}  // namespace primjs

#endif  // SRC_WASM_COMMON_JS_TYPE_H_
