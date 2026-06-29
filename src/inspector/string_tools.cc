// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>

#include "quickjs/include/quickjs.h"

static bool IsASCII(char c) { return !(c & ~0x7F); }

static bool IsSpaceOrNewLine(char c) {
  return IsASCII(c) && c <= ' ' && (c == ' ' || (c <= 0xD && c >= 0x9));
}

static bool ContentNotSatisfied(const char* content, size_t pos,
                                uint8_t multi_line) {
  bool condition1 = (content[pos] != '/');
  bool condition2 = ((content[pos + 1] != '/' || multi_line) &&
                     (content[pos + 1] != '*' || !multi_line));
  bool condition3 = (content[pos + 2] != '#' && content[pos + 2] != '@');
  bool condition4 = (content[pos + 3] != ' ' && content[pos + 3] != '\t');

  return condition1 && condition2 && condition3 && condition4;
}

static const char* FindClosingComment(const char* start) {
  if (start == nullptr) return nullptr;
  while (*start) {
    if (start[0] == '*' && start[1] == '/') {
      return start;
    }
    ++start;
  }
  return nullptr;
}

char* FindDebuggerMagicContent(LEPUSContext* ctx, char* source,
                               char* search_name, uint8_t multi_line) {
  if (source == nullptr || search_name == nullptr) return nullptr;
  size_t length = strlen(source);
  size_t name_length = strlen(search_name);
  if (length == 0 || name_length == 0 || name_length > length) {
    return nullptr;
  }

  size_t value_begin = 0;
  size_t value_end = 0;
  bool matched = false;

  for (size_t pos = length - name_length + 1; pos-- > 0;) {
    if (memcmp(source + pos, search_name, name_length) != 0) {
      continue;
    }

    // Check for a /\/[\/*][@#][ \t]/ regexp (length of 4) before found name.
    if (pos < 4) {
      return NULL;
    }
    size_t prefix_pos = pos - 4;
    if (ContentNotSatisfied(source, prefix_pos, multi_line)) {
      continue;
    }
    size_t equal_sign_pos = pos + name_length;
    if (equal_sign_pos >= length || source[equal_sign_pos] != '=') {
      continue;
    }
    value_begin = equal_sign_pos + 1;
    if (multi_line) {
      const char* closing_comment = FindClosingComment(source + value_begin);
      if (closing_comment == nullptr) {
        return NULL;
      }
      value_end = static_cast<size_t>(closing_comment - source);
    } else {
      value_end = length;
    }
    matched = true;
    break;
  }

  if (!matched) {
    return NULL;
  }

  const char* line_end = static_cast<const char*>(
      memchr(source + value_begin, '\n', value_end - value_begin));
  if (line_end != nullptr) {
    value_end = static_cast<size_t>(line_end - source);
  }

  while (value_begin < value_end && IsSpaceOrNewLine(source[value_begin])) {
    ++value_begin;
  }
  while (value_begin < value_end && IsSpaceOrNewLine(source[value_end - 1])) {
    --value_end;
  }

  size_t match_length = value_end - value_begin;
  for (size_t i = 0; i < match_length; ++i) {
    char c = source[value_begin + i];
    if (c == '"' || c == '\'' || c == ' ' || c == '\t') {
      match_length = 0;
      break;
    }
  }
  char* result = static_cast<char*>(lepus_malloc(
      ctx, sizeof(char) * (match_length + 1), ALLOC_TAG_WITHOUT_PTR));
  if (result) {
    if (match_length > 0) {
      memcpy(result, source + value_begin, match_length);
    }
    result[match_length] = '\0';
  }
  return result;
}
