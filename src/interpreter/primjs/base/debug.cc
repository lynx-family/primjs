
/*
 * Copyright (c) 2025 The Lynx Authors. All rights reserved.
 */
#include "primjs/base/debug.h"

#include <string.h>

#include <cstdlib>
#include <cstring>

namespace base {

void report_error(const char *file, int line, const char *error_msg) {
  fprintf(stderr, "Error: %s at %s:%d\n", error_msg, file, line);
  ::fflush(stderr);
  std::abort();
}
}  // namespace base
