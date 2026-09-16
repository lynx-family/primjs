// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INTERPRETER_QUICKJS_INCLUDE_PRIMJS_MONITOR_H_
#define SRC_INTERPRETER_QUICKJS_INCLUDE_PRIMJS_MONITOR_H_

#define MODULE_PRIMJS "primjs"
#define MODULE_QUICK "quickjs"

// MODULE_WASM is overridable from the build system so that downstream
// integrators can keep their existing telemetry dimension name without
// leaking that dimension name into this open-source header. The default
// below is the open-source value; downstream builds inject
// `-DMODULE_WASM="<their-name>"` on the wasm binding compile targets to
// override it.
#ifndef MODULE_WASM
#define MODULE_WASM "PrimjsWasm"
#endif
#define MODULE_NAPI "napi"
#define DEFAULT_BIZ_NAME "unknown_biz_name"

void MonitorEvent(const char* moduleName, const char* bizName,
                  const char* dataKey, const char* dataValue);
#ifdef ENABLE_WASM_PERF_COMPARE
// Reports a numeric duration. Prefer this over MonitorEvent for latency
// metrics so that Slardar can compute mean/P95/P99 accurately. The unit
// (ms, us, etc.) is encoded in metricKey — callers must use a key suffix
// that reflects the unit (e.g. "_ms_" for milliseconds, "_us_" for
// microseconds).
void MonitorDuration(const char* moduleName, const char* bizName,
                     const char* metricKey, double value);
#endif  // ENABLE_WASM_PERF_COMPARE
bool GetSettingsWithKey(const char* key);
int GetSettingsFlag();

#endif  // SRC_INTERPRETER_QUICKJS_INCLUDE_PRIMJS_MONITOR_H_
