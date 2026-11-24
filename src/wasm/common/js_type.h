// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_JS_TYPE_H_
#define SRC_WASM_COMMON_JS_TYPE_H_

#if defined(__APPLE__)
#include <JavaScriptCore/JavaScriptCore.h>
#endif

namespace primjs {

#if !defined(__APPLE__)
struct DefaultType;
using JSValueRef = const DefaultType*;
using JSObjectRef = DefaultType*;
using JSContextRef = DefaultType*;
#endif

enum class ErrorTypes { kError = 0, kTypeError, kRangeError };
constexpr const char* kErrorStrings[] = {"Error", "TypeError", "RangeError"};

}  // namespace primjs

#endif  // SRC_WASM_COMMON_JS_TYPE_H_
