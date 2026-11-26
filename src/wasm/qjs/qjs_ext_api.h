// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_QJS_WASM_EXT_API_H_
#define SRC_WASM_QJS_QJS_WASM_EXT_API_H_

#include <pthread.h>

#include <cstddef>
#include <cstdint>

#include "common/js_type.h"
#include "common/wasm_store_owner.h"
#include "common/wasm_utils.h"
#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif

namespace primjs::qjs {

class QJSEnv;

constexpr const char* const kPrivateWasmRootProp = "__WASM_PRIVATE__";

#ifndef countof
#define countof(x) (sizeof(x) / sizeof((x)[0]))
#endif

enum class WasmQJSClass : uint8_t {
  kWebAssembly = 0,
  kModule = 1,
  kInstance = 2,
  kMemory = 3,
  kTable = 4,
  kFunction = 5,
  kCount = 6,
};

LEPUSClassID GetWasmClassId(WasmQJSClass kind);

void WasmWrapperFinalizer(LEPUSRuntime* rt, LEPUSValue obj);
void WasmWrapperGCMark(LEPUSRuntime* rt, LEPUSValueConst obj,
                       LEPUS_MarkFunc* mark_func, uint64_t trace_tool);

bool JSSafeNewClass(LEPUSContext* ctx, LEPUSClassID class_id,
                    const LEPUSClassDef* class_def);

bool RegisterWasmClass(LEPUSContext* ctx, LEPUSValueConst wasm_root,
                       WasmQJSClass kind, const char* class_name,
                       const char* ctor_name, LEPUSCFunction* ctor_fn,
                       const LEPUSCFunctionListEntry* proto_funcs = nullptr,
                       size_t proto_func_count = 0,
                       const LEPUSCFunctionListEntry* static_funcs = nullptr,
                       size_t static_func_count = 0,
                       LEPUSClassGCMark* custom_mark = nullptr);

// Resolves QJSEnv from a constructor's `new_target`. Throws TypeError and
// returns nullptr when invoked without `new` or with a detached root.
QJSEnv* RequireConstructorEnv(LEPUSContext* ctx, LEPUSValueConst new_target,
                              const char* code);

// Allocates a wrapper object of `kind` after verifying `env->wasm_root()`.
LEPUSValue NewWasmWrapperObject(LEPUSContext* ctx, QJSEnv* env,
                                WasmQJSClass kind, const char* code);

inline void FreeValueIfRC(LEPUSContext* ctx, LEPUSValue v) {
  LEPUSRuntime* rt = LEPUS_GetRuntime(ctx);
  if (!LEPUS_IsGCModeRT(rt)) {
    LEPUS_FreeValueRT(rt, v);
  }
}

inline LEPUSValue DupValueIfRC(LEPUSContext* ctx, LEPUSValueConst v) {
  LEPUSRuntime* rt = LEPUS_GetRuntime(ctx);
  return LEPUS_IsGCModeRT(rt) ? v : LEPUS_DupValueRT(rt, v);
}

// Shared base for native opaque payloads that keep `wasm_root` reachable and
// participate in deterministic context-exit store reclamation.
class QJSWasmWrapperBase {
 public:
  using DetachNativeFn = void (*)(QJSWasmWrapperBase* self, LEPUSRuntime* rt);

  QJSWasmWrapperBase(LEPUSRuntime* rt, LEPUSValue wasm_root,
                     wasm::WasmStoreOwner* store_owner,
                     DetachNativeFn detach_native);
  ~QJSWasmWrapperBase();

  void UnlinkAndDetach(LEPUSRuntime* rt = nullptr);
  void DetachNative(LEPUSRuntime* rt);
  void ReleaseRoot(LEPUSRuntime* rt);
  void MarkRoot(LEPUSRuntime* rt, LEPUS_MarkFunc* mark_func,
                uint64_t trace_tool) const;
  void AddKeepToken(LEPUSContext* ctx, LEPUSValueConst val);
  void MergeKeepSet(LEPUSContext* ctx, const QJSWasmWrapperBase& other);
  bool HasKeepTokens() const;

  LEPUSValue wasm_root() const { return wasm_root_; }
  wasm::WasmStoreOwner* store_owner() const { return store_owner_; }

 private:
  static void SharedDetachOnExit(wasm::WasmTrackedHandle* handle,
                                 void* exit_ctx);

  wasm::WasmTrackedHandle tracked_;
  wasm::WasmStoreOwner* store_owner_ = nullptr;
  DetachNativeFn detach_native_ = nullptr;
  mutable pthread_mutex_t keep_mutex_ = PTHREAD_MUTEX_INITIALIZER;
  LEPUSValue wasm_root_ = LEPUS_UNDEFINED;
  LEPUSValue* keep_set_ = nullptr;
  uint32_t keep_count_ = 0;
  uint32_t keep_cap_ = 0;
};

bool JSValueGetInt32(LEPUSContext* ctx, LEPUSValue js_val, int32_t* res);

#if defined(__GNUC__) || defined(__clang__)
__attribute__((cold, noinline))
#endif
LEPUSValue
ThrowIfException(LEPUSContext* ctx, ErrorTypes err, const char* code,
                 const char* msg, LEPUSValue* exception = nullptr);

}  // namespace primjs::qjs

#endif  // SRC_WASM_QJS_QJS_WASM_EXT_API_H_
