// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstring>
#include <memory>
#include <string>

#ifdef __cplusplus
extern "C" {
#endif

#include "quickjs/include/quickjs.h"

#ifdef __cplusplus
}
#endif

static bool IsASCII(char c) { return !(c & ~0x7F); }

static bool IsSpaceOrNewLine(char c) {
  return IsASCII(c) && c <= ' ' && (c == ' ' || (c <= 0xD && c >= 0x9));
}

static std::string StripWhiteSpace(std::string& str) {
  std::string result = "";
  if (!str.length()) return result;
  size_t start = 0;
  size_t end = str.length() - 1;

  // skip white space from start
  while (start <= end && IsSpaceOrNewLine(str[start])) ++start;

  // only white space
  if (start > end) return result;

  // skip white space from end
  while (end && IsSpaceOrNewLine(str[end])) --end;

  if (!start && end == str.length() - 1) {
    result = str;
  } else {
    result = str.substr(start, end + 1 - start);
  }
  return result;
}

static bool ContentNotSatisfied(const std::string& content, size_t pos,
                                uint8_t multi_line) {
  bool condition1 = (content[pos] != '/');
  bool condition2 = ((content[pos + 1] != '/' || multi_line) &&
                     (content[pos + 1] != '*' || !multi_line));
  bool condition3 = (content[pos + 2] != '#' && content[pos + 2] != '@');
  bool condition4 = (content[pos + 3] != ' ' && content[pos + 3] != '\t');

  return condition1 && condition2 && condition3 && condition4;
}

char* FindDebuggerMagicContent(LEPUSContext* ctx, char* source,
                               char* search_name, uint8_t multi_line) {
  std::string content = source;
  std::string name = search_name;
  size_t length = content.length();
  size_t name_length = name.length();

  size_t pos = length;
  size_t equal_sign_pos = 0;
  size_t closing_comment_pos = 0;

  while (true) {
    pos = content.rfind(name, pos);
    if (pos == std::string::npos) {
      return NULL;
    }

    // Check for a /\/[\/*][@#][ \t]/ regexp (length of 4) before found name.
    if (pos < 4) return NULL;
    pos -= 4;
    if (ContentNotSatisfied(content, pos, multi_line)) {
      continue;
    }
    equal_sign_pos = pos + 4 + name_length;
    if (equal_sign_pos >= length) continue;
    if (content[equal_sign_pos] != '=') continue;
    if (multi_line) {
      closing_comment_pos = content.find("*/", equal_sign_pos + 1);
      if (closing_comment_pos == std::string::npos) return NULL;
    }
    break;
  }

  size_t url_pos = equal_sign_pos + 1;
  std::string match =
      multi_line ? content.substr(url_pos, closing_comment_pos - url_pos)
                 : content.substr(url_pos);

  size_t newLine = match.find("\n");
  if (newLine != std::string::npos) match = match.substr(0, newLine);
  match = StripWhiteSpace(match);

  for (size_t i = 0; i < match.length(); ++i) {
    char c = match[i];
    if (c == '"' || c == '\'' || c == ' ' || c == '\t') {
      match = "";
      break;
    }
  }
  char* result = static_cast<char*>(lepus_malloc(
      ctx, sizeof(char) * (match.length() + 1), ALLOC_TAG_WITHOUT_PTR));
  if (result) {
    strcpy(result, match.c_str());
  }
  return result;
}
