// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_COMMON_WASM_UTILS_H_
#define SRC_WASM_COMMON_WASM_UTILS_H_

#include <cassert>
#include <cstddef>
#include <cstdint>
#include <cstdlib>

#include "wasm_log.h"

#if defined(WASM_DEBUG) && defined(JS_ENGINE_QJS)
#define GET_REFCOUNT(v, msg)                                                 \
  do {                                                                       \
    if (LEPUS_VALUE_HAS_REF_COUNT(v)) {                                      \
      LEPUSRefCountHeader* p = (LEPUSRefCountHeader*)LEPUS_VALUE_GET_PTR(v); \
      WLOGI("%s's `" #v "` refcount is %d; " #msg, __func__, p->ref_count);  \
    } else {                                                                 \
      WLOGI("QJS Refcount is not available; %s", msg);                       \
    }                                                                        \
  } while (0);
#else
#define GET_REFCOUNT(v, msg) ((void)0);
#endif

#if defined(__GNUC__) || defined(__clang__)
#define wasm_likely(x) __builtin_expect(!!(x), 1)
#define wasm_unlikely(x) __builtin_expect(!!(x), 0)
#else
#define wasm_likely(x) (x)
#define wasm_unlikely(x) (x)
#endif

#if defined(__clang__)
#define WASM_MINSIZE __attribute__((minsize, cold))
#elif defined(__GNUC__)
#define WASM_MINSIZE __attribute__((optimize("Os"), cold))
#else
#define WASM_MINSIZE
#endif

#define FORCE_INLINE inline __attribute__((always_inline))

#ifndef WASM_CHECK
#define WASM_CHECK(condition)                                               \
  do {                                                                      \
    if (wasm_likely(condition)) {                                           \
      ;                                                                     \
    } else {                                                                \
      WLOGE("WASM_CHECK %s:%d failed: %s", __FILE__, __LINE__, #condition); \
      assert(condition);                                                    \
    }                                                                       \
  } while (false);
#endif

#ifndef WASM_DCHECK
#if defined(WASM_DEBUG)
#define WASM_DCHECK(condition) WASM_CHECK(condition)
#else
#define WASM_DCHECK(condition) ((void)0);
#endif
#endif

#define OWNER    /* owner of this pointer */
#define BORROWER /* on-owner of this pointer */

namespace primjs::wasm {

bool DecodeBase64(const uint8_t* src, size_t len, uint8_t** out_data,
                  size_t* out_len);

}  // namespace primjs::wasm

#endif  // SRC_WASM_COMMON_WASM_UTILS_H_
