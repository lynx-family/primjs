// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

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
