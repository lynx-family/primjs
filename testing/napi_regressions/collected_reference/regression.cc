// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <cstdio>
#include <cstdlib>

#include "js_native_api_adapter.h"
#include "napi.h"
#include "napi_env.h"
#include "napi_env_quickjs.h"

#ifdef REGRESSION_TRACING_GC
// Override the monitor stub to select tracing GC in this standalone test only.
int GetSettingsFlag() { return 1 << 8; }
#endif

namespace {
void Require(bool condition, int line = __builtin_LINE()) {
  if (!condition) {
    std::fprintf(stderr, "Reference regression failed at line %d\n", line);
    std::abort();
  }
}
void Check(napi_status status) { Require(status == napi_ok); }

// Borrow the caller-owned reference so Ref/Unref exercise the legacy C++ path.
class BorrowedReference : public Napi::Reference<Napi::Value> {
 public:
  BorrowedReference(napi_env env, napi_ref reference)
      : Napi::Reference<Napi::Value>(env, reference) {}
  ~BorrowedReference() { _ref = nullptr; }
};

void Run(bool adapter, bool initially_strong) {
  napi_env env = napi_new_env();
  LEPUSRuntime* runtime = LEPUS_NewRuntime();
  LEPUSContext* context = LEPUS_NewContext(runtime);
#ifdef REGRESSION_TRACING_GC
  Require(LEPUS_IsGCMode(context));
#endif
  napi_attach_quickjs(env, context);
  int finalizers = 0;
  napi_ref reference;
  napi_value original;
  napi_handle_scope scope;
  Check(env->napi_open_handle_scope(env, &scope));
  auto finalize = [](napi_env, void* data, void*) {
    ++*static_cast<int*>(data);
  };
  Check(adapter ? napi_create_external_primjs(env, &finalizers, finalize,
                                              nullptr, &original)
                : env->napi_create_external(env, &finalizers, finalize, nullptr,
                                            &original));
  Check(adapter ? napi_create_reference_primjs(
                      env, original, initially_strong ? 1 : 0, &reference)
                : env->napi_create_reference(
                      env, original, initially_strong ? 1 : 0, &reference));
  auto ref = [&] {
    uint32_t count;
    if (adapter)
      Check(napi_reference_ref_primjs(env, reference, &count));
    else
      count = BorrowedReference(env, reference).Ref();
    return count;
  };
  auto unref = [&] {
    uint32_t count;
    if (adapter)
      Check(napi_reference_unref_primjs(env, reference, &count));
    else
      count = BorrowedReference(env, reference).Unref();
    return count;
  };
  auto value = [&] {
    napi_value value;
    Check(adapter ? napi_get_reference_value_primjs(env, reference, &value)
                  : env->napi_get_reference_value(env, reference, &value));
    return value;
  };
  if (initially_strong) {
    Require(ref() == 2);
    Require(unref() == 1);
    Require(unref() == 0);
    Require(ref() == 1);
    bool equal;
    Check(env->napi_strict_equals(env, original, value(), &equal));
    Require(equal);
  }
  Check(env->napi_close_handle_scope(env, scope));
  LEPUS_RunGC(runtime);
  if (!initially_strong) {
    Require(value() == nullptr && finalizers == 1);
    for (int i = 0; i < 3; ++i) {
      Require(ref() == 1);
      Require(value() == nullptr);
      Require(unref() == 0);
    }
  }
  Check(adapter ? napi_delete_reference_primjs(env, reference)
                : env->napi_delete_reference(env, reference));
  napi_detach_quickjs(env);
  napi_free_env(env);
  LEPUS_FreeContext(context);
  LEPUS_FreeRuntime(runtime);
  Require(finalizers == 1);
  std::fprintf(stdout, "%s %s: passed; finalizer count=1\n",
               adapter ? "adapter" : "legacy",
               initially_strong ? "live" : "collected");
}
}  // namespace

int main() {
  for (bool adapter : {false, true}) {
    Run(adapter, true);
    Run(adapter, false);
  }
  return 0;
}
