// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_JSC_ENV_H_
#define SRC_WASM_JSC_ENV_H_

// NOTE:
// THIS HEADER FILE SHOULD NOT BE INCLUDED IN ANY HEADERS IN JSC/QJS MODULE

#include <JavaScriptCore/JavaScriptCore.h>

#include <atomic>
#include <cstdint>
#include <map>
#include <vector>

#include "common/js_type.h"
#include "common/wasm_utils.h"
#include "jsc/jsc_class_creator.h"
#include "jsc/jsc_wasm_function.h"
#include "jsc/jsc_wasm_global.h"
#include "jsc/jsc_wasm_memory.h"
#include "jsc/jsc_wasm_table.h"

namespace primjs::jsc {
using JSValue = JSValue<JSValueRef>;
using JSObject = JSValueType<JSValueRef>::Object;
using JSContext = JSContext<JSValueRef>;

class JSCEnv {
 public:
  using JSValue = JSValueType<JSValueRef>::Type;
  using JSContext = JSValueType<JSValueRef>::Context;
  using JSObject = JSValueType<JSValueRef>::Object;

  JSCEnv(JSContext ctx, std::atomic_bool* ctx_invalid, bool prism_mode = false);
  void Finalize();
  ~JSCEnv();

  bool IsObject(JSValue val);
  bool IsFunction(JSValue val);
  bool IsWasmFunction(JSValue val);
  bool IsNumber(JSValue val);
  bool IsBigInt(JSValue val);
  bool IsUndefined(JSValue val);
  bool IsNull(JSValue val);

  JSValue GetProperty(JSObject target, const char* name,
                      JSValue* exception = nullptr);
  bool SetProperty(JSObject obj, const char* name, JSValue val);
  bool SetPropertyAtIndex(JSObject obj, uint32_t index, JSValue val);
  JSObject MakeObject();
  JSValue MakeString(const char* str);
  JSValue MakeNumber(double num);
  bool MakeBigInt64(int64_t num, JSValue* result, JSValue* exception = nullptr);
  JSValue MakeException(ErrorTypes err, const char* code, const char* msg,
                        JSValue* exception);

  JSObject MakeWasmMemory(InteropRuntime* interop, WasmMemoryRef mem,
                          size_t pages);
  JSObject MakeWasmGlobal(InteropRuntime* interop, WasmGlobalRef gbl);
  JSObject MakeWasmTable(InteropRuntime* interop, WasmTableRef table);
  JSObject MakeWasmFunction(InteropRuntime* interop, const char* name,
                            WasmFunctionRef pack);

  JSValue MakeUndefined() {
    static JSValue js_undef = JSValueMakeUndefined(js_ctx_);
    return js_undef;
  }
  // JS_NULL is not nullptr in JavaScriptCore.
  JSValue MakeNull() {
    static JSValue js_null = JSValueMakeNull(js_ctx_);
    return js_null;
  }

  WasmGlobalRef GetWasmGlobal(JSObject value);
  WasmMemoryRef GetWasmMemory(JSObject value);
  WasmTableRef GetWasmTable(JSObject value);
  WasmFunctionRef GetWasmFunction(JSObject value);

  template <typename T>
  T DupValue(T value) {
    static_assert(std::is_same_v<T, JSValue> || std::is_same_v<T, JSObject>);
    JSValueProtect(js_ctx_, value);
    return value;
  }

  JSValue ReserveObject(JSValue obj);
  void ReleaseObject(JSValue obj);

  void ValueToInt32(int32_t& num, JSValue val, JSValue& result);
  void ValueToBigInt64(int64_t& num, JSValue val, JSValue& result);
  void ValueToBigInt64ForPrism(int64_t& num, JSValue val, JSValue& result);
  void ValueToNumber(double& num, JSValue val, JSValue& result);

  JSObject ValueToObject(JSValue val);
  JSObject ValueToFunction(JSValue val);

  template <typename To, typename From>
  inline static To ToJSC(From from) {
    return reinterpret_cast<To>(from);
  }

  template <typename T>
  void FreeValue(T value) {
    static_assert(std::is_same_v<T, JSValue> || std::is_same_v<T, JSObject>);
    JSValueUnprotect(js_ctx_, value);
  }

  template <typename T>
  T ReserveValue(T value) {
    static_assert(std::is_same_v<T, JSValue> || std::is_same_v<T, JSObject>);
    JSValueProtect(js_ctx_, value);
    return value;
  }

  template <typename T>
  void ReleaseValue(T value) {
    static_assert(std::is_same_v<T, JSValue> || std::is_same_v<T, JSObject>);
    JSValueUnprotect(js_ctx_, value);
  }

  JSValue CallAsFunction(JSObject function, JSObject thisObject, size_t argc,
                         JSValue args[], JSValue* exception);
  // Pending-exception slot used to ferry an imported JS function's thrown
  // value across the wasm call boundary on the prism+jsc path.
  // JSC's C API has no per-context pending-exception register, so the
  // PrismFunction callback stashes the exception here when it traps and
  // the outer CallWasmFunction (in wasm_function.h) takes it back to
  // surface to the JS try/catch.  See wasm_function.h for the full flow.
  void StashWasmException(JSValueRef ex);
  JSValueRef TakeWasmException();

  void SetMemoryConstructor(JSObjectRef constructor) {
    js_memory_constructor_ = constructor;
    JSValueProtect(js_ctx_, js_memory_constructor_);
  }

  void SetGlobalConstructor(JSObjectRef constructor) {
    js_global_constructor_ = constructor;
    JSValueProtect(js_ctx_, js_global_constructor_);
  }

  void SetTableConstructor(JSObjectRef constructor) {
    js_table_constructor_ = constructor;
    JSValueProtect(js_ctx_, js_table_constructor_);
  }

  void SetModuleConstructor(JSObjectRef constructor) {
    js_module_constructor_ = constructor;
    JSValueProtect(js_ctx_, js_module_constructor_);
  }

  void SetInstanceConstructor(JSObjectRef constructor) {
    js_instance_constructor_ = constructor;
    JSValueProtect(js_ctx_, js_instance_constructor_);
  }

  bool IsInvalid() const { return (ctx_invalid_ && ctx_invalid_->load()); }

  inline JSObjectRef js_module_constructor() const {
    return js_module_constructor_;
  }

  auto& wasm_memory_cache() { return wasm_memory_cache_; }
  auto& wasm_table_cache() { return wasm_table_cache_; }
  auto& wasm_global_cache() { return wasm_global_cache_; }
  auto& wasm_func_cache() { return wasm_func_cache_; }

  // Prism keeps one agent-lifetime JSValueProtect per entry. wasm3 retains
  // its release/4.0 cache behavior unchanged.
  void CacheWasmFunction(uintptr_t key, JSObject value);
  uint64_t BeginWasmImportCallbackTransaction();
  void CacheWasmImportCallback(JSObject value, uint64_t transaction = 0);
  size_t RollbackWasmImportCallbackTransaction(uint64_t transaction);
  void ProtectWasmMemoryBuffer(JSObject value);
  void UnprotectWasmMemoryBuffer(JSObject value);

#if defined(QJS_UNITTEST)
  size_t ProtectedRootCountForTesting() const {
    return wasm_memory_cache_.size() + wasm_table_cache_.size() +
           wasm_global_cache_.size() + wasm_func_cache_.size() +
           wasm_import_callback_roots_.size() +
           wasm_memory_buffer_roots_.size() +
           static_cast<size_t>(pending_wasm_exception_ != nullptr) +
           static_cast<size_t>(js_bigint64_array_ != nullptr) +
           static_cast<size_t>(js_memory_constructor_ != nullptr) +
           static_cast<size_t>(js_global_constructor_ != nullptr) +
           static_cast<size_t>(js_table_constructor_ != nullptr) +
           static_cast<size_t>(js_module_constructor_ != nullptr) +
           static_cast<size_t>(js_instance_constructor_ != nullptr);
  }
#endif

  int RefCount(JSValue value, const char* msg) {
    int ref_count = -1;
    WLOGI("JSC Refcount is %d; %s", ref_count, msg);
    return ref_count;
  }

  JSContext js_ctx() { return js_ctx_; }

 private:
  OWNER JSObjectRef js_module_constructor_ = nullptr;
  OWNER JSObjectRef js_instance_constructor_ = nullptr;
  OWNER JSObjectRef js_global_constructor_ = nullptr;
  OWNER JSObjectRef js_table_constructor_ = nullptr;
  OWNER JSObjectRef js_memory_constructor_ = nullptr;
  OWNER JSObjectRef js_bigint64_array_ = nullptr;

  BORROWER JSContext js_ctx_;
  BORROWER std::atomic_bool* ctx_invalid_;
  bool prism_mode_ = false;

  // Each agent is associated with the following ordered maps:
  std::map<uintptr_t, JSObjectRef> wasm_memory_cache_;
  std::map<uintptr_t, JSObjectRef> wasm_table_cache_;
  std::map<uintptr_t, JSObjectRef> wasm_global_cache_;
  std::map<uintptr_t, JSObjectRef> wasm_func_cache_;
  // Imported Prism callbacks keep their original callable even if a Table.get
  // wrapper later becomes the identity-cache entry for the same native slot.
  // These are JS roots only; native functions remain owned by Prism's store.
  struct WasmImportCallbackRoot {
    JSObjectRef value;
    uint64_t transaction;
  };
  std::vector<WasmImportCallbackRoot> wasm_import_callback_roots_;
  uint64_t next_wasm_import_callback_transaction_ = 0;
  std::vector<JSObjectRef> wasm_memory_buffer_roots_;

  // See StashWasmException / TakeWasmException above.  nullptr = empty.
  // Owns a JSValueProtect on the stashed value while non-null.
  JSValueRef pending_wasm_exception_ = nullptr;
};

}  // namespace primjs::jsc
#endif  // SRC_WASM_JSC_ENV_H_
