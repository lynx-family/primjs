// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/js_env_jsc.h"

#include <algorithm>
#include <cmath>
#include <cstring>

#include "common/wasm_log.h"
#include "jsc/jsc_builtin_objects.h"
#include "jsc/jsc_ext_api.h"
#include "jsc/jsc_wasm.h"
#include "jsc/jsc_wasm_function.h"
#include "jsc/jsc_wasm_global.h"
#include "jsc/jsc_wasm_memory.h"
#include "jsc/jsc_wasm_table.h"
#include "runtime/prism/wasm_function.h"
#include "runtime/prism/wasm_runtime.h"
#include "runtime/wasm3/wasm_function.h"
#include "runtime/wasm3/wasm_runtime.h"

#if (defined(__IPHONE_18_0) && defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && \
     (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_18_0)) ||                \
    (defined(__MAC_15_0) && defined(__MAC_OS_X_VERSION_MAX_ALLOWED) &&     \
     (__MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_15_0))
#define PRIMJS_JSC_HAS_BIGINT_C_API 1
#else
#define PRIMJS_JSC_HAS_BIGINT_C_API 0
#endif

namespace primjs::jsc {
JSCEnv::JSCEnv(JSContextRef ctx, std::atomic_bool* ctx_invalid, bool prism_mode)
    : js_ctx_(ctx), ctx_invalid_(ctx_invalid), prism_mode_(prism_mode) {
  JSCWasmFunction::CreatePrototype(ctx, nullptr);

  if (!prism_mode_) return;

  JSValueRef exception = nullptr;
  if (__builtin_available(macos 10.12, ios 10.0, *)) {
    js_bigint64_array_ = JSObjectMakeTypedArray(
        js_ctx_, kJSTypedArrayTypeBigInt64Array, 1, &exception);
    if (!exception && js_bigint64_array_) {
      JSValueProtect(js_ctx_, js_bigint64_array_);
    } else {
      js_bigint64_array_ = nullptr;
    }
  }
}

void JSCEnv::Finalize() {
  WLOGD("Running JSCEnv::Finalize");
  if (!prism_mode_) return;

  auto unprotect_cache = [this](auto& cache) {
    for (const auto& entry : cache) {
      JSValueUnprotect(js_ctx_, entry.second);
    }
    cache.clear();
  };
  unprotect_cache(wasm_memory_cache_);
  unprotect_cache(wasm_table_cache_);
  unprotect_cache(wasm_global_cache_);
  unprotect_cache(wasm_func_cache_);

  for (const auto& callback : wasm_import_callback_roots_) {
    JSValueUnprotect(js_ctx_, callback.value);
  }
  wasm_import_callback_roots_.clear();
  for (JSObjectRef buffer : wasm_memory_buffer_roots_) {
    JSValueUnprotect(js_ctx_, buffer);
  }
  wasm_memory_buffer_roots_.clear();

  auto unprotect = [this](auto& value) {
    if (!value) return;
    JSValueUnprotect(js_ctx_, value);
    value = nullptr;
  };
  unprotect(pending_wasm_exception_);
  unprotect(js_bigint64_array_);
  unprotect(js_memory_constructor_);
  unprotect(js_global_constructor_);
  unprotect(js_table_constructor_);
  unprotect(js_module_constructor_);
  unprotect(js_instance_constructor_);
}

void JSCEnv::CacheWasmFunction(uintptr_t key, JSObject value) {
  auto it = wasm_func_cache_.find(key);
  if (it != wasm_func_cache_.end()) {
    if (it->second == value) return;
    if (prism_mode_) JSValueUnprotect(js_ctx_, it->second);
  }
  if (prism_mode_) JSValueProtect(js_ctx_, value);
  wasm_func_cache_[key] = value;
}

uint64_t JSCEnv::BeginWasmImportCallbackTransaction() {
  ++next_wasm_import_callback_transaction_;
  if (next_wasm_import_callback_transaction_ == 0) {
    ++next_wasm_import_callback_transaction_;
  }
  return next_wasm_import_callback_transaction_;
}

void JSCEnv::CacheWasmImportCallback(JSObject value, uint64_t transaction) {
  JSValueProtect(js_ctx_, value);
  wasm_import_callback_roots_.push_back({value, transaction});
}

size_t JSCEnv::RollbackWasmImportCallbackTransaction(uint64_t transaction) {
  size_t rolled_back = 0;
  for (auto it = wasm_import_callback_roots_.begin();
       it != wasm_import_callback_roots_.end();) {
    if (it->transaction != transaction) {
      ++it;
      continue;
    }
    JSValueUnprotect(js_ctx_, it->value);
    it = wasm_import_callback_roots_.erase(it);
    ++rolled_back;
  }
  return rolled_back;
}

void JSCEnv::ProtectWasmMemoryBuffer(JSObject value) {
  JSValueProtect(js_ctx_, value);
  wasm_memory_buffer_roots_.push_back(value);
}

void JSCEnv::UnprotectWasmMemoryBuffer(JSObject value) {
  auto it = std::find(wasm_memory_buffer_roots_.begin(),
                      wasm_memory_buffer_roots_.end(), value);
  if (it == wasm_memory_buffer_roots_.end()) return;
  JSValueUnprotect(js_ctx_, value);
  wasm_memory_buffer_roots_.erase(it);
}

JSCEnv::~JSCEnv() { WLOGD("Running JSCEnv::%s...", __func__); }

bool JSCEnv::IsObject(JSValue val) { return JSValueIsObject(js_ctx_, val); }

bool JSCEnv::IsWasmFunction(JSValue val) {
  JSValue jsc_val = val;
  return JSValueIsObjectOfClass(js_ctx_, jsc_val, JSCWasmFunction::class_id());
}

bool JSCEnv::IsFunction(JSValue val) {
  JSValue jsc_val = val;
  if (JSValueIsObject(js_ctx_, jsc_val)) {
    JSObject obj = JSValueToObject(js_ctx_, jsc_val, nullptr);
    return JSObjectIsFunction(js_ctx_, obj);
  }
  return false;
}

bool JSCEnv::IsNumber(JSValue val) { return JSValueIsNumber(js_ctx_, val); }

bool JSCEnv::IsBigInt(JSValue val) {
#if PRIMJS_JSC_HAS_BIGINT_C_API
  if (__builtin_available(macos 15.0, ios 18.0, *)) {
    return JSValueIsBigInt(js_ctx_, val);
  }
#endif

  // BigInt predates its public JSC C-API predicate. On systems that expose
  // Symbol, eliminate every other ECMAScript primitive without coercion; the
  // sole remaining primitive type is BigInt. Older systems have no BigInt
  // support and conservatively return false.
  if (__builtin_available(macos 10.15, ios 13.0, *)) {
    return !JSValueIsObject(js_ctx_, val) &&
           !JSValueIsUndefined(js_ctx_, val) && !JSValueIsNull(js_ctx_, val) &&
           !JSValueIsBoolean(js_ctx_, val) && !JSValueIsNumber(js_ctx_, val) &&
           !JSValueIsString(js_ctx_, val) && !JSValueIsSymbol(js_ctx_, val);
  }
  return false;
}

bool JSCEnv::IsUndefined(JSValue val) {
  return JSValueIsUndefined(js_ctx_, val);
}

bool JSCEnv::IsNull(JSValue val) {
  return val == nullptr || JSValueIsNull(js_ctx_, val);
}

bool JSCEnv::SetProperty(JSObject obj, const char* name, JSValue val) {
  JSValue exception{};
  JSObjectSetProperty(js_ctx_, obj, JSString(name), val,
                      kJSPropertyAttributeNone, &exception);
  return exception == nullptr;
}

bool JSCEnv::SetPropertyAtIndex(JSObject obj, uint32_t index, JSValue val) {
  JSValue exception{};
  JSObjectSetPropertyAtIndex(js_ctx_, obj, index, val, &exception);
  return exception == nullptr;
}

JSValue JSCEnv::GetProperty(JSObject target, const char* name,
                            JSValue* exception) {
  // Caller must ensure that target is a JSObject.
  return JSObjectGetProperty(js_ctx_, target, JSString(name), exception);
}

JSObject JSCEnv::MakeObject() {
  return JSObjectMake(js_ctx_, nullptr, nullptr);
}

JSValue JSCEnv::MakeString(const char* str) {
  return JSValueMakeString(js_ctx_, JSString(str));
}

JSValue JSCEnv::MakeNumber(double num) {
  return JSValueMakeNumber(js_ctx_, num);
}

bool JSCEnv::MakeBigInt64(int64_t num, JSValue* result, JSValue* exception) {
  JSValueRef local_exception = nullptr;
  JSValueRef* exception_out = exception ? exception : &local_exception;
  *exception_out = nullptr;
#if PRIMJS_JSC_HAS_BIGINT_C_API
  if (__builtin_available(macos 15.0, ios 18.0, *)) {
    *result = JSBigIntCreateWithInt64(js_ctx_, num, exception_out);
    return *exception_out == nullptr && *result != nullptr;
  }
#endif
  if (!js_bigint64_array_) {
    MakeException(ErrorTypes::kTypeError, "",
                  "BigInt conversion is unavailable", exception_out);
    return false;
  }

  void* bytes =
      JSObjectGetTypedArrayBytesPtr(js_ctx_, js_bigint64_array_, exception_out);
  if (*exception_out || !bytes) return false;
  std::memcpy(bytes, &num, sizeof(num));
  *result =
      JSObjectGetPropertyAtIndex(js_ctx_, js_bigint64_array_, 0, exception_out);
  return *exception_out == nullptr && *result != nullptr;
}

JSValue JSCEnv::MakeException(ErrorTypes err, const char* code, const char* msg,
                              JSValue* exception) {
  return ThrowIfException(js_ctx_, err, code, msg, exception);
}

JSObject JSCEnv::MakeWasmFunction(InteropRuntime* interop, const char* name,
                                  WasmFunctionRef function) {
  JSValue exception{};
  // use memory constructor to get interop runtime
  JSObject js_obj = JSCWasmFunction::CreateJSObject(
      js_ctx_, js_memory_constructor_, function, &exception);
  if (prism_mode_ && (!js_obj || exception)) return nullptr;
  if (name) {
    JSValue name_ref = JSValueMakeString(js_ctx_, JSString(name));
    JSObjectSetProperty(js_ctx_, js_obj, JSString("name"), name_ref,
                        JSClassCreator::DefaultAttr(), &exception);
  }
  if (exception) return nullptr;
  return js_obj;
}

JSObject JSCEnv::MakeWasmMemory(InteropRuntime* interop, WasmMemoryRef mem,
                                size_t pages) {
  JSValue exception{};
  JSObject js_obj = JSCWasmMemory::CreateJSObject(
      js_ctx_, js_memory_constructor_, mem, pages, nullptr);
  if (exception) return nullptr;
  return js_obj;
}

JSObject JSCEnv::MakeWasmTable(InteropRuntime* interop, WasmTableRef table) {
  JSValue exception{};
  JSObject ret = JSCWasmTable::CreateJSObject(js_ctx_, js_table_constructor_,
                                              table, &exception);
  if (exception) ret = ValueToObject(MakeNull());
  return ret;
}

JSObject JSCEnv::MakeWasmGlobal(InteropRuntime* interop, WasmGlobalRef gbl) {
  JSValue exception{};
  JSObject js_obj = JSCWasmGlobal::CreateJSObject(
      js_ctx_, js_global_constructor_, gbl, &exception);
  if (exception) return nullptr;
  return js_obj;
}

// spec: https://tc39.es/ecma262/#sec-tobigint64
void JSCEnv::ValueToBigInt64(int64_t& i64, JSValue val, JSValue& exception) {
  // 1. Let n be ? ToBigInt(argument).
  if (JSValueIsNull(js_ctx_, ToJSC<JSValueRef>(val)) ||
      JSValueIsUndefined(js_ctx_, ToJSC<JSValueRef>(val))) {
    exception = MakeException(
        ErrorTypes::kError, "",
        "Value cannot be typeof Null, Undefined, Number or Symbol", &exception);
    return;
  }

  if (__builtin_available(macos 10.15, ios 13.0, *)) {
    // In principle, we should add "JSValueIsNumber(js_ctx_, val)" as a
    // condition, but "Number" here is not a instance of JS Object Number("123")
    if (JSValueIsSymbol(js_ctx_, ToJSC<JSValueRef>(val))) {
      exception = MakeException(
          ErrorTypes::kError, "",
          "value cannot be typeof undefined, Null, Number or Symbol",
          &exception);
      return;
    }
  }

  // For typeof BigInt, Boolean or String
  JSValueRef result{};
  double bigint = JSValueToNumber(js_ctx_, ToJSC<JSValueRef>(val), &result);
  exception = result;

  // 2. Let int64bit be ℝ(n) modulo 2**64. skip... because uint64_t cannot
  //    larger than 2**64
  // 3. If int64bit ≥ 2**63, return ℤ(int64bit - 2**64); otherwise return
  //    ℤ(int64bit). skip... because int64_t cannot larger than 2**63

  // Convert bigint to int64_t
  i64 = static_cast<int64_t>(bigint);
}

void JSCEnv::ValueToBigInt64ForPrism(int64_t& i64, JSValue val,
                                     JSValue& exception) {
  exception = nullptr;
#if PRIMJS_JSC_HAS_BIGINT_C_API
  if (__builtin_available(macos 15.0, ios 18.0, *)) {
    if (JSValueIsBigInt(js_ctx_, val)) {
      i64 = JSValueToInt64(js_ctx_, val, &exception);
      return;
    }
  }
#endif
  if (!js_bigint64_array_) {
    MakeException(ErrorTypes::kTypeError, "",
                  "BigInt conversion is unavailable", &exception);
    return;
  }

  JSObjectSetPropertyAtIndex(js_ctx_, js_bigint64_array_, 0, val, &exception);
  if (exception) return;
  void* bytes =
      JSObjectGetTypedArrayBytesPtr(js_ctx_, js_bigint64_array_, &exception);
  if (exception || !bytes) return;
  std::memcpy(&i64, bytes, sizeof(i64));
}

// spec: https://tc39.es/ecma262/#sec-toint32
void JSCEnv::ValueToInt32(int32_t& i32, JSValue val, JSValue& exception) {
  exception = nullptr;
  // 1. Let number be ? ToNumber(argument).
  double number = JSValueToNumber(js_ctx_, val, &exception);
  if (exception) return;
  // 2. If number is not finite or number is either +0𝔽 or -0𝔽, return +0𝔽.
  // 3. Let int be truncate(ℝ(number)).
  // 4. Let int32bit be int modulo 2**32.
  // 5. If int32bit ≥ 2**31, return 𝔽(int32bit - 2**32); otherwise return
  //    𝔽(int32bit).
  // Skip 2, 3, 4, 5... For performance reason, handle binary bits directly
  // according to the IEEE 754 floating-point standard
  uint64_t u64 = *reinterpret_cast<uint64_t*>(&number);
  // u64 >> 52 bits and & 0x7ff, extract the exponential part of number
  int e = (u64 >> 52) & 0x7ff;
  // If e <= (1023 + 30) (equals 1.b51...b0✖️2^{e-1023+30}), converting
  // directly
  if (wasm_likely(e <= (1023 + 30))) {
    i32 = static_cast<int32_t>(number);
  } else if (e <= (1023 + 30 + 53)) {
    // Extract fraction from number
    uint64_t v = (u64 & ((1ULL << 52) - 1)) | (1ULL << 52);
    // Converts the mantissa portion of number to a int32_t
    v = v << ((e - 1023) - 52 + 32);
    uint32_t tmp = static_cast<uint32_t>(v >> 32);
    if (u64 >> 63) {
      tmp = ~tmp + 1;  // 二进制补码取负（无 UB）
    }
    i32 = static_cast<int32_t>(tmp);
  } else {
    // Handle Infinity and NAN
    i32 = 0;
  }
}

namespace {
bool IsBigInt(JSValueRef valueRef) {
  JSGlobalContextRef context = JSGlobalContextCreateInGroup(nullptr, nullptr);
  JSObjectRef globalObjectRef = JSContextGetGlobalObject(context);

  JSStringRef bigintString = JSStringCreateWithUTF8CString("BigInt");
  JSValueRef bigintConstructorValue =
      JSObjectGetProperty(context, globalObjectRef, bigintString, nullptr);
  JSStringRelease(bigintString);

  JSObjectRef bigintConstructor =
      JSValueToObject(context, bigintConstructorValue, nullptr);

  bool isBigInt = JSValueIsInstanceOfConstructor(context, valueRef,
                                                 bigintConstructor, nullptr);

  JSGlobalContextRelease(context);

  return isBigInt;
}

JSValueRef CreateBigInt(JSContextRef context, const char* value) {
  JSObjectRef globalObjectRef = JSContextGetGlobalObject(context);

  JSStringRef bigintString = JSStringCreateWithUTF8CString("BigInt");
  JSValueRef bigintConstructorValue =
      JSObjectGetProperty(context, globalObjectRef, bigintString, nullptr);
  JSStringRelease(bigintString);

  JSObjectRef bigintConstructor =
      JSValueToObject(context, bigintConstructorValue, nullptr);
  JSStringRef valueString = JSStringCreateWithUTF8CString(value);
  JSValueRef arguments[] = {JSValueMakeString(context, valueString)};
  JSValueRef bigintObject = JSObjectCallAsConstructor(
      context, bigintConstructor, 1, arguments, nullptr);
  JSStringRelease(valueString);

  return bigintObject;
}

int64_t GetBigIntValue(JSContextRef context, JSValueRef bigintValue) {
  JSStringRef toStringString = JSStringCreateWithUTF8CString("toString");
  JSObjectRef bigintObject = JSValueToObject(context, bigintValue, nullptr);
  JSValueRef toStringFunction =
      JSObjectGetProperty(context, bigintObject, toStringString, nullptr);
  JSObjectRef toStringFunctionObject =
      JSValueToObject(context, toStringFunction, nullptr);
  JSStringRelease(toStringString);

  JSObjectRef globalObject = JSContextGetGlobalObject(context);
  JSValueRef toStringFunctionBound = JSObjectCallAsFunction(
      context, toStringFunctionObject, globalObject, 0, nullptr, nullptr);

  JSStringRef resultString =
      JSValueToStringCopy(context, toStringFunctionBound, nullptr);
  size_t resultLength = JSStringGetMaximumUTF8CStringSize(resultString);
  std::string resultValue(resultLength, '\0');
  JSStringGetUTF8CString(resultString, &resultValue[0], resultLength);
  int64_t result = std::atoll(resultValue.c_str());
  JSStringRelease(resultString);

  return result;
}
}  // namespace

void JSCEnv::ValueToNumber(double& num, JSValue val, JSValue& exception) {
  exception = nullptr;
  num = JSValueToNumber(js_ctx_, val, &exception);
}

JSValue JSCEnv::CallAsFunction(JSObject function, JSObject thisObject,
                               size_t argc, JSValue args[],
                               JSValue* exception) {
  JSValue jsc_exception = nullptr;
  JSObject receiver = thisObject;
  if (!receiver && prism_mode_) {
    // Match the existing spec-compliant N-API JSC call path: pass the
    // primitive through so strict functions observe `undefined`, while sloppy
    // functions still receive globalThis. wasm3 keeps its original nullptr.
    receiver = const_cast<JSObject>(JSValueMakeUndefined(js_ctx_));
  }
  JSValue val = JSObjectCallAsFunction(js_ctx_, function, receiver, argc, args,
                                       &jsc_exception);
  if (jsc_exception && exception) *exception = jsc_exception;
  return val;
}

void JSCEnv::StashWasmException(JSValueRef ex) {
  // Replace any prior unrecovered exception (last write wins, same as
  // QJS's pending-exception slot).  Drop the previous protect first so
  // the protect count of the obsolete value doesn't leak.
  if (pending_wasm_exception_) {
    JSValueUnprotect(js_ctx_, pending_wasm_exception_);
    pending_wasm_exception_ = nullptr;
  }
  if (ex) {
    JSValueProtect(js_ctx_, ex);
    pending_wasm_exception_ = ex;
  }
}

JSValueRef JSCEnv::TakeWasmException() {
  JSValueRef ex = pending_wasm_exception_;
  if (ex) {
    // The caller becomes the owner of the protect taken in Stash.
    pending_wasm_exception_ = nullptr;
  }
  return ex;
}

WasmGlobalRef JSCEnv::GetWasmGlobal(JSObject val) {
  JSObject val_obj = val;
  if (!prism_mode_) {
    auto jsc_global = static_cast<JSCWasmGlobal*>(JSObjectGetPrivate(val_obj));
    return jsc_global->global();
  }
  if (JSCWasmGlobal::IsJSCWasmGlobal(js_ctx_, val_obj)) {
    auto jsc_global = static_cast<JSCWasmGlobal*>(JSObjectGetPrivate(val_obj));
    return jsc_global->global();
  }
  return {};
}

WasmMemoryRef JSCEnv::GetWasmMemory(JSObject val) {
  JSObject val_obj = val;
  if (!prism_mode_) {
    auto jsc_memory = static_cast<JSCWasmMemory*>(JSObjectGetPrivate(val_obj));
    return jsc_memory->memory();
  }
  if (JSCWasmMemory::IsJSCWasmMemory(js_ctx_, val_obj)) {
    auto jsc_memory = static_cast<JSCWasmMemory*>(JSObjectGetPrivate(val_obj));
    return jsc_memory->memory();
  }
  return {};
}

WasmTableRef JSCEnv::GetWasmTable(JSObject val) {
  JSObject val_obj = val;
  if (JSCWasmTable::IsJSCWasmTable(js_ctx_, val_obj)) {
    auto jsc_table = static_cast<JSCWasmTable*>(JSObjectGetPrivate(val_obj));
    return jsc_table->table();
  }
  return {};
}

WasmFunctionRef JSCEnv::GetWasmFunction(JSObject val) {
  JSObject val_obj = val;
  auto jsc_function =
      static_cast<JSCWasmFunction*>(JSObjectGetPrivate(val_obj));
  return jsc_function->function();
}

JSObject JSCEnv::ValueToObject(JSValue val) {
  JSValue jsc_val = val;
  if (JSValueIsObject(js_ctx_, jsc_val))
    return JSValueToObject(js_ctx_, jsc_val, nullptr);
  return nullptr;
}

JSObject JSCEnv::ValueToFunction(JSValue val) {
  JSValue jsc_val = val;
  if (JSValueIsObject(js_ctx_, jsc_val)) {
    JSObject maybe_func = JSValueToObject(js_ctx_, jsc_val, nullptr);
    if (JSObjectIsFunction(js_ctx_, maybe_func)) return maybe_func;
  }
  return nullptr;
}

}  // namespace primjs::jsc
