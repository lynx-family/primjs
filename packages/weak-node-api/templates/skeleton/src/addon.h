#pragma once

#include <napi.h>
#if defined(USE_WEAK_SUFFIX_NAPI)
#include "weak_napi_defines.h"
#endif

namespace __PROJECT_SYMBOL__ {

constexpr const char* kAddonName = "__PROJECT_NAME__";

Napi::Object Init(Napi::Env env, Napi::Object exports);

}  // namespace __PROJECT_SYMBOL__

#if defined(USE_WEAK_SUFFIX_NAPI)
#include "weak_napi_undefs.h"
#endif
