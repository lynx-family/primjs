/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */

#ifndef PRIMJS_UTF8_UTILS_H
#define PRIMJS_UTF8_UTILS_H

#include "primjs/base/globals.h"
#include "rtsvm/vm/rgbbase/utf_inl.h"

namespace utf8 {

inline bool is_latin1(const PRIMJS_char *base, int length) {
  for (int i = 0; i < length; i++) {
    if (base[i] > 0x00FF) {
      return false;
    }
  }
  return true;
}

inline bool is_ascii(PRIMJS_byte ch) {
  // 1..0x7f
  if (ch > 0x7F || ch == 0x00) {
    return false;
  }
  return true;
}

inline int utf8_length(const PRIMJS_byte *base, int length) {
  int result = 0;
  for (int index = 0; index < length; index++) {
    PRIMJS_byte c = base[index];
    result += is_ascii(c) ? 1 : 2;
  }
  return result;
}

/*
 * Modified UTF-8 consists of a series of bytes up to 21 bit Unicode code points
 * as follows: U+0001  - U+007F   0xxxxxxx U+0080  - U+07FF   110xxxxx 10xxxxxx
 * U+0800  - U+FFFF   1110xxxx 10xxxxxx 10xxxxxx
 * U+10000 - U+1FFFFF 11110xxx 10xxxxxx 10xxxxxx 10xxxxxx
 */
inline char *convert_utf8(char *buf, int buflen, const PRIMJS_byte *base,
                          int length) {
  PRIMJS_byte *p = (PRIMJS_byte *)buf;
  for (int index = 0; index < length; index++) {
    PRIMJS_byte c = base[index];
    int sz = is_ascii(c) ? 1 : 2;
    buflen -= sz;
    if (buflen <= 0) break;
    if (sz == 1) {
      *p++ = c;
    } else {
      *p++ = ((c >> 6) | 0xc0);
      *p++ = ((c & 0x3f) | 0x80);
    }
  }
  *p = '\0';
  return buf;
}

template <typename UChar>
static ALWAYSINLINE int utf8_length(const UChar *ptr, int len) {
  if constexpr (std::is_same<UChar, char>::value) {
    return utf8_length((const uint8_t *)ptr, len);
  } else {
    return CountModifiedUtf8BytesInUtf16((const PRIMJS_char *)ptr, len);
  }
}

template <typename UChar>
static ALWAYSINLINE void convert_utf8(const UChar *ptr, int length, char *buf,
                                      int buflen) {
  if constexpr (std::is_same<UChar, char>::value) {
    convert_utf8(buf, buflen, (const uint8_t *)ptr, length);
  } else {
    auto new_ptr = buf;
    ConvertUtf16ToUtf8<false, true, false>((const PRIMJS_char *)ptr, length,
                                           [&](char c) { *new_ptr++ = c; });
    *new_ptr = '\0';
  }
}

}  // namespace utf8
#endif  // PRIMJS_UTF8_UTILS_H
