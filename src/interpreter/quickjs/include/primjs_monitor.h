// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INTERPRETER_QUICKJS_INCLUDE_PRIMJS_MONITOR_H_
#define SRC_INTERPRETER_QUICKJS_INCLUDE_PRIMJS_MONITOR_H_

#define MODULE_PRIMJS "primjs"
#define MODULE_QUICK "quickjs"

#define MODULE_NAPI "napi"
#define DEFAULT_BIZ_NAME "unknown_biz_name"

void MonitorEvent(const char* moduleName, const char* bizName,
                  const char* dataKey, const char* dataValue);
bool GetSettingsWithKey(const char* key);
int GetSettingsFlag();

#endif  // SRC_INTERPRETER_QUICKJS_INCLUDE_PRIMJS_MONITOR_H_
