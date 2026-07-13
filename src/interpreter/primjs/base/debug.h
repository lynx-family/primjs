/*
 * Copyright (c) 2024 The Lynx Authors. All rights reserved.
 */
#ifndef PRIMJS_DEBUG_H
#define PRIMJS_DEBUG_H

#include <stdarg.h>
#include <stdio.h>

namespace base {
void report_error(const char *file, int line, const char *error_msg);
}
#endif  // PRIMJS_VM_DEBUG_H
