// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_WASM_QJS_JS_ENV_QJS_H_
#define SRC_WASM_QJS_JS_ENV_QJS_H_

// NOTE:
// THIS HEADER FILE SHOULD NOT BE INCLUDED IN ANY HEADERS IN JSC/QJS MODULE

#include <atomic>
#include <map>

#include "common/js_type.h"
#include "common/one_of.h"
#include "common/wasm_utils.h"
#include "qjs/qjs_ext_api.h"
#include "qjs/qjs_wasm_function.h"
#include "qjs/qjs_wasm_global.h"
#include "qjs/qjs_wasm_memory.h"
#include "qjs/qjs_wasm_table.h"
#include "quickjs/include/quickjs-inner.h"

namespace primjs {
class InteropRuntime;

namespace qjs {
using JSValue = JSValue<LEPUSValue>;
using JSObject = JSValueType<LEPUSValue>::Object;
using JSContext = JSContext<LEPUSValue>;

class QJSEnv {
 public:
  using JSValue = JSValueType<LEPUSValue>::Type;
  using JSContext = JSValueType<LEPUSValue>::Context;
  using JSObject = JSValueType<LEPUSValue>::Object;

  QJSEnv(JSContext ctx, std::atomic_bool *invalid);
  ~QJSEnv();
  void Finalize();

  JSValue GetProperty(JSValue target, const char *name);
  bool SetProperty(JSValue obj, const char *name, JSValue val);
  bool SetPropertyAtIndex(JSValue obj, uint32_t index, JSValue val);
  JSValue MakeFunction(const char *name, void *pack);
  JSValue MakeString(const char *str);
  JSValue MakeNumber(double num);

  JSValue ReserveObject(JSValue obj);
  void ReleaseObject(JSValue obj);

  void ValueToInt32(int32_t &num, JSValue val, JSValue &result);
  void ValueToBigInt64(int64_t &num, JSValue val, JSValue &result);
  void ValueToNumber(double &num, JSValue val, JSValue &result);

  JSValue ValueToObject(JSValue val);
  JSValue ValueToFunction(JSValue val);
  JSValue CallAsFunction(JSValue function, JSValue thisObject, size_t argc,
                         JSValue args[], JSValue *exception);

  inline static LEPUSValue ToQJS(JSValue from) { return from.Get(); }

  inline static LEPUSContext *ToQJS(JSContext from) { return from; }

  inline static JSValue FromQJS(LEPUSValue from, LEPUSRuntime *rt) {
    return WASMGCPersistent(rt, from);
  }

  bool IsObject(JSValue val) { return LEPUS_IsObject(val.Get()); }
  bool IsNumber(JSValue val) { return LEPUS_IsNumber(val.Get()); }
  bool IsUndefined(JSValue val) { return LEPUS_IsUndefined(val.Get()); }
  bool IsNull(JSValue val) { return LEPUS_IsNull(val.Get()); }
  bool IsException(JSValue val) { return LEPUS_IsException(val.Get()); }
  bool IsFunction(JSValue val) { return LEPUS_IsFunction(js_ctx_, val.Get()); }

  bool IsWasmFunction(JSValue val) {
    return LEPUS_GetClassID(js_ctx_, val.Get()) == QJSWasmFunction::class_id();
  }

  JSValue MakeObject();
  JSValue MakeUndefined();
  JSValue MakeNull();
  JSValue MakeException(ErrorTypes err, const char *code, const char *msg,
                        JSValue *exception);
  JSValue MakeWasmMemory(InteropRuntime *interop, WasmMemoryRef memory,
                         size_t pages);
  JSValue MakeWasmGlobal(InteropRuntime *interop, WasmGlobalRef global);
  JSValue MakeWasmTable(InteropRuntime *interop, WasmTableRef table);
  JSValue MakeWasmFunction(InteropRuntime *interop, const char *name,
                           WasmFunctionRef function);

  WasmGlobalRef GetWasmGlobal(JSValue value);
  WasmMemoryRef GetWasmMemory(JSValue value);
  WasmTableRef GetWasmTable(JSValue value);
  WasmFunctionRef GetWasmFunction(JSValue value);

  JSValue DupValue(JSValue value);
  void FreeValue(LEPUSRuntime *rt, JSValue value);
  void FreeValue(JSValue value);

  JSValue ReserveValue(JSValue obj);
  void ReleaseValue(JSValue obj);

  bool IsInvalid() const { return (ctx_invalid_ && ctx_invalid_->load()); }

  int RefCount(JSValue value, const char *msg);

  void PrintObjectProperties(LEPUSContext *ctx, LEPUSValueConst obj);

  void Mark(LEPUS_MarkFunc *mark_func, LEPUSRuntime *rt, uint64_t trace_tool);

  auto &wasm_memory_cache() { return wasm_memory_cache_; }
  auto &wasm_table_cache() { return wasm_table_cache_; }
  auto &wasm_global_cache() { return wasm_global_cache_; }
  auto &wasm_func_cache() { return wasm_func_cache_; }

 private:
  BORROWER LEPUSRuntime *js_rt_;
  BORROWER JSContext js_ctx_;
  BORROWER std::atomic_bool *ctx_invalid_;

  std::map<uintptr_t, WASMGCPersistent> wasm_memory_cache_;
  std::map<uintptr_t, WASMGCPersistent> wasm_table_cache_;
  std::map<uintptr_t, WASMGCPersistent> wasm_global_cache_;
  std::map<uintptr_t, WASMGCPersistent> wasm_func_cache_;
};

}  // namespace qjs
}  // namespace primjs

#endif  // SRC_WASM_QJS_JS_ENV_QJS_H_
