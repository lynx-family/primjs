// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INSPECTOR_HEAPPROFILER_RUNTIME_HOOKS_H_
#define SRC_INSPECTOR_HEAPPROFILER_RUNTIME_HOOKS_H_

#if defined(ENABLE_HEAPPROFILER) || defined(ENABLE_QUICKJS_DEBUGGER)
#include "quickjs/include/base_export.h"

struct LEPUSRuntime;
// Release the Runtime's profiler on its owner thread during teardown.
extern "C" QJS_HIDE void js_profile_remove_runtime(LEPUSRuntime* rt);
#endif

#endif  // SRC_INSPECTOR_HEAPPROFILER_RUNTIME_HOOKS_H_
