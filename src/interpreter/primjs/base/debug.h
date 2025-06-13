// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_DEBUG_H
#define PRIMJS_DEBUG_H

#include <stdarg.h>
#include <stdio.h>

namespace base {
void report_vm_error(const char *file, int line, const char *error_msg,
                     const char *detail_fmt, ...);
}
#endif  // PRIMJS_VM_DEBUG_H
