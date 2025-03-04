// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_VERSION_H_
#define SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_VERSION_H_

#include <stdint.h>
#include <stdio.h>
#define FEATURE_LEPUSNG_DEBUGINFO_OUTSIDE "2.5"
#define PRIMJS_ADD_VERSION_CODE "2.14"

typedef struct Version {
  int major, minor, revision, build;
} Version;

void VersionInit(Version* v, const char* version);
uint8_t VersionLessOrEqual(Version v1, Version other);
uint8_t IsHigherOrEqual(const char* targetV, const char* baseV);

#endif  // SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_VERSION_H_
