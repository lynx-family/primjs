// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// Umbrella header of the `PrimJS` Clang module (see module.modulemap). It
// lists the C API that is importable from Swift and Objective-C; the C++
// headers next to it stay textual includes.

#ifndef SWIFTPM_HEADERS_PRIMJS_PRIMJS_H_
#define SWIFTPM_HEADERS_PRIMJS_PRIMJS_H_

// quickjs.h is written for C++, where `bool` is built in. When the module is
// built as C (Swift importer, Objective-C) it comes from here.
#include <stdbool.h>

#include "quickjs/include/quickjs.h"

#endif  // SWIFTPM_HEADERS_PRIMJS_PRIMJS_H_
