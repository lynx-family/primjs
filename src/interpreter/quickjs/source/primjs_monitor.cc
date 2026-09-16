// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "quickjs/include/primjs_monitor.h"

__attribute__((weak)) void MonitorEvent(const char*, const char*, const char*,
                                        const char*) {}
// Always provide the weak stub regardless of ENABLE_WASM_PERF_COMPARE on this
// TU: callers that do define the macro emit references to MonitorDuration even
// though primjs_monitor.cc itself may be built without that define (e.g. when
// it sits in quickjs_lib while the strong define lives only on the wasm
// binding target). The weak attribute lets the platform-specific strong
// implementation override this stub when present.
__attribute__((weak)) void MonitorDuration(const char*, const char*,
                                           const char*, double) {}

int GetSettingsFlag() { return 0; }
bool GetSettingsWithKey(const char* key) { return false; }
