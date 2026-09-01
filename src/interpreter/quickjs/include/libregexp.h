/*
 * Regular Expression Engine
 *
 * Copyright (c) 2017-2018 Fabrice Bellard
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#ifndef SRC_INTERPRETER_QUICKJS_INCLUDE_LIBREGEXP_H_
#define SRC_INTERPRETER_QUICKJS_INCLUDE_LIBREGEXP_H_

#include <stddef.h>
#include <stdint.h>

#include "base_export.h"
#include "quickjs/include/libunicode.h"

#define LRE_FLAG_GLOBAL (1 << 0)
#define LRE_FLAG_IGNORECASE (1 << 1)
#define LRE_FLAG_MULTILINE (1 << 2)
#define LRE_FLAG_DOTALL (1 << 3)
#define LRE_FLAG_UNICODE (1 << 4)
#define LRE_FLAG_UTF16 LRE_FLAG_UNICODE
#define LRE_FLAG_STICKY (1 << 5)
#define LRE_FLAG_INDICES (1 << 6)
#define LRE_FLAG_NAMED_GROUPS (1 << 7)
#define LRE_FLAG_UNICODE_SETS (1 << 8)

#define LRE_RET_MEMORY_ERROR (-1)
#define LRE_RET_TIMEOUT (-2)

/* Includes the terminating NUL and duplicate-name scope byte. */
#define LRE_GROUP_NAME_TRAILER_LEN 2

uint8_t *lre_compile(int *plen, char *error_msg, int error_msg_size,
                     const char *buf, size_t buf_len, int re_flags,
                     void *opaque);
int lre_get_alloc_count(const uint8_t *bc_buf);
int lre_get_capture_count(const uint8_t *bc_buf);
QJS_HIDE int lre_get_flags(const uint8_t *bc_buf);
const char *lre_get_groupnames(const uint8_t *bc_buf);
int lre_exec(uint8_t **capture, const uint8_t *bc_buf, const uint8_t *cbuf,
             int cindex, int clen, int cbuf_type, void *opaque);
QJS_HIDE void lre_free(void *ptr);

QJS_HIDE int lre_parse_escape(const uint8_t **pp, int allow_utf16);
QJS_HIDE int lre_is_space(int c);

extern uint32_t const lre_id_start_table_ascii[4];
extern uint32_t const lre_id_continue_table_ascii[4];

static inline int lre_js_is_ident_first(int c) {
  if ((uint32_t)c < 128) {
    return (lre_id_start_table_ascii[c >> 5] >> (c & 31)) & 1;
  }
#ifdef CONFIG_ALL_UNICODE
  return lre_is_id_start(c);
#else
  return !lre_is_space(c);
#endif
}

static inline int lre_js_is_ident_next(int c) {
  if ((uint32_t)c < 128) {
    return (lre_id_continue_table_ascii[c >> 5] >> (c & 31)) & 1;
  }
#ifdef CONFIG_ALL_UNICODE
  return lre_is_id_continue(c) || c == 0x200c || c == 0x200d;
#else
  return !lre_is_space(c) || c == 0x200c || c == 0x200d;
#endif
}

QJS_HIDE int lre_check_stack_overflow(void *opaque, size_t alloca_size);
QJS_HIDE int lre_check_timeout(void *opaque);

#endif  // SRC_INTERPRETER_QUICKJS_INCLUDE_LIBREGEXP_H_
