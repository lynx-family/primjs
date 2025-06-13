// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/base/debug.h"

#include <string.h>

#include <cstdlib>
#include <cstring>

namespace base {

static void print_error_for_unit_test(const char *message,
                                      const char *detail_fmt,
                                      va_list detail_args) {
  char detail_msg[256];
  if (detail_fmt != nullptr) {
    va_list detail_args_copy;
    va_copy(detail_args_copy, detail_args);
    vsnprintf(detail_msg, sizeof(detail_msg), detail_fmt, detail_args_copy);

    // the VM assert tests look for "assert failed: "
    if (message == nullptr) {
      fprintf(stderr, "assert failed: %s", detail_msg);
    } else {
      if (strlen(detail_msg) > 0) {
        fprintf(stderr, "assert failed: %s: %s", message, detail_msg);
      } else {
        fprintf(stderr, "assert failed: Error: %s", message);
      }
    }
    ::fflush(stderr);
    va_end(detail_args_copy);
  }
}

void report_vm_error(const char *file, int line, const char *error_msg,
                     const char *detail_fmt, ...) {
  va_list detail_args;
  va_start(detail_args, detail_fmt);
#ifdef CAN_SHOW_REGISTERS_ON_ASSERT
  if (g_assertion_context != nullptr &&
      os::current_thread_id() == g_asserting_thread) {
    context = g_assertion_context;
  }
#endif  // CAN_SHOW_REGISTERS_ON_ASSERT

  print_error_for_unit_test(error_msg, detail_fmt, detail_args);

  std::abort();
  va_end(detail_args);
}
}  // namespace base
