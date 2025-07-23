/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#if !defined(SRC_NAPI_V8_JS_NATIVE_API_V8_INTERNALS_H_) && \
    !defined(_NAPI_V8_EXPORT_SOURCE_ONLY_)
#define SRC_NAPI_V8_JS_NATIVE_API_V8_INTERNALS_H_

#include <v8.h>

#include <cassert>
#include <string>

#define NAPI_ARRAYSIZE(array) (sizeof(array) / sizeof(array[0]))

inline v8::Local<v8::String> OneByteString(v8::Isolate* isolate,
                                           const char* data, int length) {
  return v8::String::NewFromOneByte(isolate,
                                    reinterpret_cast<const uint8_t*>(data),
                                    v8::NewStringType::kNormal, length)
      .ToLocalChecked();
}

#define NAPI_FIXED_ONE_BYTE_STRING(isolate, string) \
  OneByteString((isolate), (string), sizeof(string) - 1)

namespace v8impl {

template <typename T>
using Persistent = v8::Global<T>;

class PersistentToLocal {
 public:
  template <class TypeName>
  static inline v8::Local<TypeName> Strong(
      const v8::PersistentBase<TypeName>& persistent) {
    return *reinterpret_cast<v8::Local<TypeName>*>(
        const_cast<v8::PersistentBase<TypeName>*>(&persistent));
  }
};
}  // end of namespace v8impl

#ifndef CHECK
#define CHECK(expr) assert(expr)
#endif

#ifndef CHECK_EQ
#define CHECK_EQ(a, b) CHECK((a) == (b))
#endif

#ifndef CHECK_LE
#define CHECK_LE(a, b) CHECK((a) <= (b))
#endif

#endif  // SRC_NAPI_V8_JS_NATIVE_API_V8_INTERNALS_H_
