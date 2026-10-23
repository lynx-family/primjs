// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "napi/harmony/jsvm_dynamic_loader.h"

#include <dlfcn.h>

namespace primjs {
namespace harmony {

JSVMDynamicLoader::JSVMDynamicLoader(const char* library_path) {
  handle_ = dlopen(library_path, RTLD_NOW | RTLD_LOCAL);
  if (!handle_) {
    const char* error = dlerror();
    error_ = error ? error : "Unable to load JSVM";
    return;
  }

  // Publish a usable table only when every API needed by this build exists.
#define JSVM_FUNCTION(name)                                               \
  functions_.name =                                                       \
      reinterpret_cast<decltype(functions_.name)>(dlsym(handle_, #name)); \
  if (!functions_.name) {                                                 \
    error_ = "Missing JSVM symbol: " #name;                               \
    dlclose(handle_);                                                     \
    handle_ = nullptr;                                                    \
    return;                                                               \
  }
#include "napi/harmony/jsvm_functions.inc"
#undef JSVM_FUNCTION
}

JSVMDynamicLoader::~JSVMDynamicLoader() {
  if (handle_) {
    dlclose(handle_);
  }
}

const JSVMDynamicLoader& JSVMDynamicLoader::GetInstance() {
  // Keep the library alive for finalizers and references destroyed at exit.
  // Local static initialization also serializes concurrent first use.
  static const auto* loader = new JSVMDynamicLoader("libjsvm.so");
  return *loader;
}

}  // namespace harmony
}  // namespace primjs
