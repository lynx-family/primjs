// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_ENV_H_
#define SRC_WASM_JSC_ENV_H_

#include <JavaScriptCore/JavaScriptCore.h>

#include <atomic>
#include <cstddef>
#include <cstdint>
#include <vector>

#include "common/js_type.h"
#include "common/wasm_store_owner.h"
#include "common/wasm_type.h"
#include "common/wasm_utils.h"

namespace primjs::jsc {

class JSCEnv;

// Deduplicated C++ + private-WeakMap keep-set for JSC Wasm wrapper objects.
// Tokens are stored in an internal WeakMap owned by JSCEnv so JS code cannot
// inspect, overwrite, delete, or block attachment via Object.freeze().
class JSCKeepSet {
 public:
  const std::vector<JSObjectRef>& tokens() const { return tokens_; }
  bool empty() const { return tokens_.empty(); }

  bool AddToken(JSCEnv* env, JSObjectRef owner_obj, JSObjectRef token,
                JSValueRef* exception);
  bool MergeFrom(JSCEnv* env, JSObjectRef owner_obj, const JSCKeepSet& other,
                 JSValueRef* exception);

 private:
  JSObjectRef backing_array_ = nullptr;
  std::vector<JSObjectRef> tokens_;
};

class JSCEnv {
 public:
  JSCEnv(JSContextRef ctx, std::atomic_bool* ctx_invalid,
         wasm::WasmStoreOwner* store_owner = nullptr);
  ~JSCEnv();

  void Finalize();

  JSContextRef js_ctx() const { return js_ctx_; }
  wasm::WasmStoreOwner* store_owner() const { return store_owner_; }
  wasm_store_t* wasm_store() const {
    return store_owner_ ? store_owner_->store() : nullptr;
  }

  void SetWasmRoot(JSObjectRef wasm_root) { wasm_root_ = wasm_root; }
  JSObjectRef wasm_root() const { return wasm_root_; }

  bool IsInvalid() const {
    return (ctx_invalid_ && ctx_invalid_->load(std::memory_order_acquire));
  }

  bool IsBigInt(JSValueRef val) const;
  bool MakeBigInt64(int64_t num, JSValueRef* result,
                    JSValueRef* exception = nullptr);
  void ValueToBigInt64(int64_t& num, JSValueRef val, JSValueRef& exception);
  void ValueToInt32(int32_t& num, JSValueRef val, JSValueRef& exception);

  bool ToWasmValue(JSValueRef value, wasm_valkind_t kind, wasm_val_t* out,
                   JSValueRef* exception);
  inline JSValueRef FromWasmValue(const wasm_val_t& value,
                                  JSValueRef* exception) {
    switch (value.kind) {
      case WASM_I32:
        return JSValueMakeNumber(js_ctx_, value.of.i32);
      case WASM_F64:
        return JSValueMakeNumber(js_ctx_, value.of.f64);
      case WASM_F32:
        return JSValueMakeNumber(js_ctx_, static_cast<double>(value.of.f32));
      default:
        return FromWasmValueSlow(value, exception);
    }
  }
  JSValueRef FromWasmValueSlow(const wasm_val_t& value, JSValueRef* exception);
  JSValueRef ThrowTrap(wasm_trap_t* trap, const char* code,
                       JSValueRef* exception);

  void StashWasmException(JSValueRef ex);
  JSValueRef TakeWasmException();

  void SetMemoryConstructor(JSObjectRef constructor);
  void SetTableConstructor(JSObjectRef constructor);
  void SetModuleConstructor(JSObjectRef constructor);
  void SetInstanceConstructor(JSObjectRef constructor);

  JSObjectRef js_module_constructor() const { return js_module_constructor_; }
  JSObjectRef js_instance_constructor() const {
    return js_instance_constructor_;
  }
  JSObjectRef js_table_constructor() const { return js_table_constructor_; }
  JSObjectRef js_memory_constructor() const { return js_memory_constructor_; }

  uint64_t BeginWasmImportCallbackTransaction();
  void CacheWasmImportCallback(JSObjectRef value, uint64_t transaction = 0,
                               const void* bridge_key = nullptr);
  void ReleaseWasmImportCallback(const void* bridge_key);
  size_t RollbackWasmImportCallbackTransaction(uint64_t transaction);
  void FinishWasmImportCallbackTransaction(uint64_t transaction) {
    (void)RollbackWasmImportCallbackTransaction(transaction);
  }

  void ProtectWasmMemoryBuffer(JSObjectRef value);
  void UnprotectWasmMemoryBuffer(JSObjectRef value);
  void UnprotectWasmMemoryBufferLater(JSObjectRef value);
  void FlushDeferredUnprotects();
  void DetachAllWasmMemoryBuffers();

  bool AttachKeepToken(JSObjectRef owner_obj, JSObjectRef backing_array,
                       size_t index, JSObjectRef token, JSValueRef* exception);

#if defined(QJS_UNITTEST)
  size_t ProtectedRootCountForTesting() const {
    return wasm_import_callback_roots_.size() +
           wasm_memory_buffer_roots_.size() +
           wasm_memory_buffers_to_unprotect_.size() +
           static_cast<size_t>(pending_wasm_exception_ != nullptr) +
           static_cast<size_t>(js_bigint64_array_ != nullptr) +
           static_cast<size_t>(keep_attach_fn_ != nullptr) +
           static_cast<size_t>(track_buffer_fn_ != nullptr) +
           static_cast<size_t>(detach_buffers_fn_ != nullptr) +
           static_cast<size_t>(js_memory_constructor_ != nullptr) +
           static_cast<size_t>(js_table_constructor_ != nullptr) +
           static_cast<size_t>(js_module_constructor_ != nullptr) +
           static_cast<size_t>(js_instance_constructor_ != nullptr);
  }
#endif

 private:
  struct WasmImportCallbackRoot {
    JSObjectRef value;
    uint64_t transaction;
    const void* bridge_key;
  };

  JSObjectRef js_module_constructor_ = nullptr;
  JSObjectRef js_instance_constructor_ = nullptr;
  JSObjectRef js_table_constructor_ = nullptr;
  JSObjectRef js_memory_constructor_ = nullptr;
  JSObjectRef js_bigint64_array_ = nullptr;
  JSObjectRef keep_attach_fn_ = nullptr;
  JSObjectRef track_buffer_fn_ = nullptr;
  JSObjectRef detach_buffers_fn_ = nullptr;
  JSObjectRef wasm_root_ = nullptr;

  JSContextRef js_ctx_ = nullptr;
  std::atomic_bool* ctx_invalid_ = nullptr;
  wasm::WasmStoreOwner* store_owner_ = nullptr;

  std::vector<WasmImportCallbackRoot> wasm_import_callback_roots_;
  uint64_t next_wasm_import_callback_transaction_ = 0;
  std::vector<JSObjectRef> wasm_memory_buffer_roots_;
  std::vector<JSObjectRef> wasm_memory_buffers_to_unprotect_;
  JSValueRef pending_wasm_exception_ = nullptr;
};

}  // namespace primjs::jsc

#endif  // SRC_WASM_JSC_ENV_H_
