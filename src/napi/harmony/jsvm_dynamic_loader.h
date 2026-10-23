// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_NAPI_HARMONY_JSVM_DYNAMIC_LOADER_H_
#define SRC_NAPI_HARMONY_JSVM_DYNAMIC_LOADER_H_

#include <ark_runtime/jsvm.h>

#include <string>

namespace primjs {
namespace harmony {

struct JSVMFunctions {
#define JSVM_FUNCTION(name) decltype(&::name) name = nullptr;
#include "napi/harmony/jsvm_functions.inc"
#undef JSVM_FUNCTION
};

class JSVMDynamicLoader {
 public:
  explicit JSVMDynamicLoader(const char* library_path);
  ~JSVMDynamicLoader();

  JSVMDynamicLoader(const JSVMDynamicLoader&) = delete;
  JSVMDynamicLoader& operator=(const JSVMDynamicLoader&) = delete;

  const JSVMFunctions* GetFunctions() const {
    return handle_ ? &functions_ : nullptr;
  }
  const char* GetError() const { return error_.c_str(); }
  static const JSVMDynamicLoader& GetInstance();

 private:
  void* handle_ = nullptr;
  JSVMFunctions functions_;
  std::string error_;
};

}  // namespace harmony
}  // namespace primjs

// Call only after availability has been checked, before attaching the backend.
#define PRIMJS_JSVM_CALL(name, ...)                                          \
  (::primjs::harmony::JSVMDynamicLoader::GetInstance().GetFunctions()->name( \
      __VA_ARGS__))

#endif  // SRC_NAPI_HARMONY_JSVM_DYNAMIC_LOADER_H_
