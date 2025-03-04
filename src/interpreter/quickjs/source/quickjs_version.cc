// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs_version.h"
#ifdef __cplusplus
}
#endif

#include <string.h>
void VersionInit(struct Version* v, const char* version) {
  v->build = 0;
  v->major = 0;
  v->minor = 0;
  v->revision = 0;
  sscanf(version, "%d.%d.%d.%d", &v->major, &v->minor, &v->revision, &v->build);
  if (v->major < 0) v->major = 0;
  if (v->minor < 0) v->minor = 0;
  if (v->revision < 0) v->revision = 0;
  if (v->build < 0) v->build = 0;
}

static uint8_t VersionLess(struct Version v1, struct Version other) {
  if (v1.major < other.major)
    return 1;
  else if (v1.major > other.major)
    return 0;

  // Compare moinor
  if (v1.minor < other.minor)
    return 1;
  else if (v1.minor > other.minor)
    return 0;

  // Compare revision
  if (v1.revision < other.revision)
    return 1;
  else if (v1.revision > other.revision)
    return 0;

  // Compare build
  if (v1.build < other.build)
    return 1;
  else if (v1.build > other.build)
    return 0;

  return 0;
}

static uint8_t VersionEqual(Version v1, Version other) {
  return (v1.major == other.major && v1.minor == other.minor &&
          v1.revision == other.revision && v1.build == other.build);
}

uint8_t VersionLessOrEqual(Version v1, Version other) {
  return VersionEqual(v1, other) || VersionLess(v1, other);
}

uint8_t IsHigherOrEqual(const char* targetV, const char* baseV) {
  if (!targetV || strcmp(targetV, "") == 0 || strcmp(targetV, "null") == 0) {
    return 1;
  }
  Version base;
  VersionInit(&base, baseV);
  Version target;
  VersionInit(&target, targetV);
  return VersionLessOrEqual(base, target);
}
