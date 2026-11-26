// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "jsc/js_env_jsc.h"

#include <algorithm>
#include <cmath>
#include <cstring>
#include <string>

#include "common/wasm_log.h"
#include "jsc/jsc_ext_api.h"
#include "jsc/jsc_wasm_function.h"

#if (defined(__IPHONE_18_0) && defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && \
     (__IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_18_0)) ||                \
    (defined(__MAC_15_0) && defined(__MAC_OS_X_VERSION_MAX_ALLOWED) &&     \
     (__MAC_OS_X_VERSION_MAX_ALLOWED >= __MAC_15_0))
#define PRIMJS_JSC_HAS_BIGINT_C_API 1
#else
#define PRIMJS_JSC_HAS_BIGINT_C_API 0
#endif

namespace primjs::jsc {

JSCEnv::JSCEnv(JSContextRef ctx, std::atomic_bool* ctx_invalid,
               wasm::WasmStoreOwner* store_owner)
    : js_ctx_(ctx), ctx_invalid_(ctx_invalid), store_owner_(store_owner) {
  JSCWasmFunction::CreatePrototype(ctx, nullptr);

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

  static constexpr char kInitHelpersSrc[] =
      "(() => {"
      "  const wm = new WeakMap();"
      "  const wmSet = Function.prototype.call.bind(WeakMap.prototype.set, wm);"
      "  const dp = Object.defineProperty;"
      "  const WR = typeof WeakRef === 'function' ? WeakRef : null;"
      "  const wrDeref = WR ? Function.prototype.call.bind(WR.prototype.deref) "
      ": null;"
      "  const abTransfer = (typeof ArrayBuffer === 'function' && "
      "ArrayBuffer.prototype && typeof ArrayBuffer.prototype.transfer === "
      "'function') ? Function.prototype.call.bind("
      "ArrayBuffer.prototype.transfer) : null;"
      "  const bufs = Object.setPrototypeOf([], null);"
      "  let nextCompact = 64;"
      "  const trackBuf = (WR && abTransfer) ? (b) => {"
      "    if (bufs.length >= nextCompact) {"
      "      let w = 0;"
      "      for (let i = 0; i < bufs.length; ++i) {"
      "        if (wrDeref(bufs[i]) !== undefined) bufs[w++] = bufs[i];"
      "      }"
      "      bufs.length = w;"
      "      nextCompact = w < 32 ? 64 : w * 2;"
      "    }"
      "    bufs[bufs.length] = new WR(b);"
      "  } : null;"
      "  const detachBufs = (WR && abTransfer) ? () => {"
      "    for (let i = 0; i < bufs.length; ++i) {"
      "      const b = wrDeref(bufs[i]);"
      "      if (b !== undefined) {"
      "        try { abTransfer(b, 0); } catch (_) {}"
      "      }"
      "    }"
      "    bufs.length = 0;"
      "    nextCompact = 64;"
      "  } : null;"
      "  const attach = (owner, arr, idx, val) => {"
      "    dp(arr, idx, {value: val, configurable: true, enumerable: true, "
      "writable: true});"
      "    wmSet(owner, arr);"
      "  };"
      "  return [attach, trackBuf, detachBufs];"
      "})()";
  JSValueRef helpers_exc = nullptr;
  JSValueRef helpers_val = JSEvaluateScript(js_ctx_, JSString(kInitHelpersSrc),
                                            nullptr, nullptr, 1, &helpers_exc);
  if (!helpers_exc && helpers_val && JSValueIsObject(js_ctx_, helpers_val)) {
    JSObjectRef helpers_obj = JSValueToObject(js_ctx_, helpers_val, nullptr);
    if (helpers_obj) {
      auto grab_fn = [&](unsigned idx, JSObjectRef* slot) {
        JSValueRef local_exc = nullptr;
        JSValueRef v =
            JSObjectGetPropertyAtIndex(js_ctx_, helpers_obj, idx, &local_exc);
        if (!local_exc && v && JSValueIsObject(js_ctx_, v)) {
          *slot = JSValueToObject(js_ctx_, v, nullptr);
          if (*slot) JSValueProtect(js_ctx_, *slot);
        }
      };
      grab_fn(0, &keep_attach_fn_);
      grab_fn(1, &track_buffer_fn_);
      grab_fn(2, &detach_buffers_fn_);
    }
  }
}

JSCEnv::~JSCEnv() = default;

void JSCEnv::Finalize() {
  for (const auto& callback : wasm_import_callback_roots_) {
    JSValueUnprotect(js_ctx_, callback.value);
  }
  wasm_import_callback_roots_.clear();
  for (JSObjectRef buffer : wasm_memory_buffer_roots_) {
    JSValueUnprotect(js_ctx_, buffer);
  }
  wasm_memory_buffer_roots_.clear();
  for (JSObjectRef buffer : wasm_memory_buffers_to_unprotect_) {
    JSValueUnprotect(js_ctx_, buffer);
  }
  wasm_memory_buffers_to_unprotect_.clear();

  auto unprotect_ctor = [this](JSObjectRef& ctor) {
    if (!ctor) return;
    if (JSObjectGetPrivate(ctor) == this) {
      JSObjectSetPrivate(ctor, nullptr);
    }
    JSValueUnprotect(js_ctx_, ctor);
    ctor = nullptr;
  };
  if (pending_wasm_exception_) {
    JSValueUnprotect(js_ctx_, pending_wasm_exception_);
    pending_wasm_exception_ = nullptr;
  }
  if (js_bigint64_array_) {
    JSValueUnprotect(js_ctx_, js_bigint64_array_);
    js_bigint64_array_ = nullptr;
  }
  if (keep_attach_fn_) {
    JSValueUnprotect(js_ctx_, keep_attach_fn_);
    keep_attach_fn_ = nullptr;
  }
  if (track_buffer_fn_) {
    JSValueUnprotect(js_ctx_, track_buffer_fn_);
    track_buffer_fn_ = nullptr;
  }
  if (detach_buffers_fn_) {
    JSValueUnprotect(js_ctx_, detach_buffers_fn_);
    detach_buffers_fn_ = nullptr;
  }
  unprotect_ctor(js_memory_constructor_);
  unprotect_ctor(js_table_constructor_);
  unprotect_ctor(js_module_constructor_);
  unprotect_ctor(js_instance_constructor_);
  wasm_root_ = nullptr;
}

void JSCEnv::SetMemoryConstructor(JSObjectRef constructor) {
  if (js_memory_constructor_) JSValueUnprotect(js_ctx_, js_memory_constructor_);
  js_memory_constructor_ = constructor;
  if (constructor) JSValueProtect(js_ctx_, constructor);
}

void JSCEnv::SetTableConstructor(JSObjectRef constructor) {
  if (js_table_constructor_) JSValueUnprotect(js_ctx_, js_table_constructor_);
  js_table_constructor_ = constructor;
  if (constructor) JSValueProtect(js_ctx_, constructor);
}

void JSCEnv::SetModuleConstructor(JSObjectRef constructor) {
  if (js_module_constructor_) JSValueUnprotect(js_ctx_, js_module_constructor_);
  js_module_constructor_ = constructor;
  if (constructor) JSValueProtect(js_ctx_, constructor);
}

void JSCEnv::SetInstanceConstructor(JSObjectRef constructor) {
  if (js_instance_constructor_) {
    JSValueUnprotect(js_ctx_, js_instance_constructor_);
  }
  js_instance_constructor_ = constructor;
  if (constructor) JSValueProtect(js_ctx_, constructor);
}

uint64_t JSCEnv::BeginWasmImportCallbackTransaction() {
  ++next_wasm_import_callback_transaction_;
  if (next_wasm_import_callback_transaction_ == 0) {
    ++next_wasm_import_callback_transaction_;
  }
  return next_wasm_import_callback_transaction_;
}

void JSCEnv::CacheWasmImportCallback(JSObjectRef value, uint64_t transaction,
                                     const void* bridge_key) {
  JSValueProtect(js_ctx_, value);
  wasm_import_callback_roots_.push_back({value, transaction, bridge_key});
}

void JSCEnv::ReleaseWasmImportCallback(const void* bridge_key) {
  if (!bridge_key || !js_ctx_) return;
  for (auto it = wasm_import_callback_roots_.begin();
       it != wasm_import_callback_roots_.end(); ++it) {
    if (it->bridge_key == bridge_key) {
      JSValueUnprotect(js_ctx_, it->value);
      wasm_import_callback_roots_.erase(it);
      return;
    }
  }
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

void JSCEnv::FlushDeferredUnprotects() {
  if (wasm_memory_buffers_to_unprotect_.empty()) return;
  std::vector<JSObjectRef> released;
  released.swap(wasm_memory_buffers_to_unprotect_);
  for (JSObjectRef buffer : released) {
    JSValueUnprotect(js_ctx_, buffer);
  }
}

bool JSCEnv::AttachKeepToken(JSObjectRef owner_obj, JSObjectRef backing_array,
                             size_t index, JSObjectRef token,
                             JSValueRef* exception) {
  if (wasm_unlikely(!keep_attach_fn_ || !owner_obj || !backing_array ||
                    !token)) {
    ThrowIfException(js_ctx_, ErrorTypes::kError, "WebAssembly",
                     "Unable to retain WebAssembly import reference",
                     exception);
    return false;
  }
  JSObjectRef undef_this =
      const_cast<JSObjectRef>(JSValueMakeUndefined(js_ctx_));
  JSValueRef argv[4] = {owner_obj, backing_array,
                        JSValueMakeNumber(js_ctx_, static_cast<double>(index)),
                        token};
  JSValueRef local_exc = nullptr;
  JSObjectCallAsFunction(js_ctx_, keep_attach_fn_, undef_this, 4, argv,
                         &local_exc);
  if (wasm_unlikely(local_exc != nullptr)) {
    if (exception) *exception = local_exc;
    return false;
  }
  return true;
}

bool JSCKeepSet::AddToken(JSCEnv* env, JSObjectRef owner_obj, JSObjectRef token,
                          JSValueRef* exception) {
  if (!owner_obj || !token) return true;
  if (std::find(tokens_.begin(), tokens_.end(), token) != tokens_.end()) {
    return true;
  }
  if (wasm_unlikely(!env || !env->js_ctx())) return false;
  if (!backing_array_) {
    JSValueRef local_exc = nullptr;
    backing_array_ = JSObjectMakeArray(env->js_ctx(), 0, nullptr, &local_exc);
    if (wasm_unlikely(local_exc || !backing_array_)) {
      if (exception) *exception = local_exc;
      backing_array_ = nullptr;
      return false;
    }
  }
  if (!env->AttachKeepToken(owner_obj, backing_array_, tokens_.size(), token,
                            exception)) {
    return false;
  }
  tokens_.push_back(token);
  return true;
}

bool JSCKeepSet::MergeFrom(JSCEnv* env, JSObjectRef owner_obj,
                           const JSCKeepSet& other, JSValueRef* exception) {
  for (JSObjectRef tok : other.tokens_) {
    if (!AddToken(env, owner_obj, tok, exception)) return false;
  }
  return true;
}

void JSCEnv::ProtectWasmMemoryBuffer(JSObjectRef value) {
  FlushDeferredUnprotects();
  if (value) {
    JSValueProtect(js_ctx_, value);
    wasm_memory_buffer_roots_.push_back(value);
    if (track_buffer_fn_) {
      JSObjectRef undef_this =
          const_cast<JSObjectRef>(JSValueMakeUndefined(js_ctx_));
      JSValueRef argv[1] = {value};
      JSValueRef ignored_exc = nullptr;
      JSObjectCallAsFunction(js_ctx_, track_buffer_fn_, undef_this, 1, argv,
                             &ignored_exc);
    }
  }
}

void JSCEnv::DetachAllWasmMemoryBuffers() {
  if (!detach_buffers_fn_ || !js_ctx_) return;
  JSObjectRef undef_this =
      const_cast<JSObjectRef>(JSValueMakeUndefined(js_ctx_));
  JSValueRef ignored_exc = nullptr;
  JSObjectCallAsFunction(js_ctx_, detach_buffers_fn_, undef_this, 0, nullptr,
                         &ignored_exc);
}

void JSCEnv::UnprotectWasmMemoryBufferLater(JSObjectRef value) {
  auto it = std::find(wasm_memory_buffer_roots_.begin(),
                      wasm_memory_buffer_roots_.end(), value);
  if (it == wasm_memory_buffer_roots_.end()) return;
  wasm_memory_buffers_to_unprotect_.push_back(value);
  wasm_memory_buffer_roots_.erase(it);
}

void JSCEnv::UnprotectWasmMemoryBuffer(JSObjectRef value) {
  if (!value) return;
  auto it = std::find(wasm_memory_buffer_roots_.begin(),
                      wasm_memory_buffer_roots_.end(), value);
  if (it == wasm_memory_buffer_roots_.end()) return;
  JSValueUnprotect(js_ctx_, value);
  wasm_memory_buffer_roots_.erase(it);
}

bool JSCEnv::IsBigInt(JSValueRef val) const {
#if PRIMJS_JSC_HAS_BIGINT_C_API
  if (__builtin_available(macos 15.0, ios 18.0, *)) {
    return JSValueIsBigInt(js_ctx_, val);
  }
#endif
  if (__builtin_available(macos 10.15, ios 13.0, *)) {
    return val != nullptr && !JSValueIsObject(js_ctx_, val) &&
           !JSValueIsUndefined(js_ctx_, val) && !JSValueIsNull(js_ctx_, val) &&
           !JSValueIsBoolean(js_ctx_, val) && !JSValueIsNumber(js_ctx_, val) &&
           !JSValueIsString(js_ctx_, val) && !JSValueIsSymbol(js_ctx_, val);
  }
  return false;
}

bool JSCEnv::MakeBigInt64(int64_t num, JSValueRef* result,
                          JSValueRef* exception) {
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
    ThrowIfException(js_ctx_, ErrorTypes::kTypeError, "",
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

void JSCEnv::ValueToBigInt64(int64_t& i64, JSValueRef val,
                             JSValueRef& exception) {
  exception = nullptr;
  if (!val || JSValueIsUndefined(js_ctx_, val) || JSValueIsNull(js_ctx_, val) ||
      JSValueIsNumber(js_ctx_, val)) {
    ThrowIfException(js_ctx_, ErrorTypes::kTypeError, "",
                     "Undefined or Null or Number cannot convert to BigInt",
                     &exception);
    return;
  }
#if PRIMJS_JSC_HAS_BIGINT_C_API
  if (__builtin_available(macos 15.0, ios 18.0, *)) {
    if (JSValueIsBigInt(js_ctx_, val)) {
      i64 = JSValueToInt64(js_ctx_, val, &exception);
      return;
    }
  }
#endif
  if (!js_bigint64_array_) {
    ThrowIfException(js_ctx_, ErrorTypes::kTypeError, "",
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

void JSCEnv::ValueToInt32(int32_t& i32, JSValueRef val, JSValueRef& exception) {
  exception = nullptr;
  double number = JSValueToNumber(js_ctx_, val, &exception);
  if (exception) return;
  uint64_t u64 = 0;
  std::memcpy(&u64, &number, sizeof(u64));
  const int e = static_cast<int>((u64 >> 52) & 0x7ff);
  if (wasm_likely(e <= (1023 + 30))) {
    i32 = static_cast<int32_t>(number);
  } else if (e <= (1023 + 30 + 53)) {
    uint64_t v = (u64 & ((1ULL << 52) - 1)) | (1ULL << 52);
    v = v << ((e - 1023) - 52 + 32);
    uint32_t tmp = static_cast<uint32_t>(v >> 32);
    if (u64 >> 63) {
      tmp = ~tmp + 1;
    }
    i32 = static_cast<int32_t>(tmp);
  } else {
    i32 = 0;
  }
}

bool JSCEnv::ToWasmValue(JSValueRef value, wasm_valkind_t kind, wasm_val_t* out,
                         JSValueRef* exception) {
  JSValueRef local_exc = nullptr;
  out->kind = kind;
  switch (kind) {
    case WASM_I32:
      ValueToInt32(out->of.i32, value, local_exc);
      if (local_exc) {
        if (exception) *exception = local_exc;
        return false;
      }
      return true;
    case WASM_F32: {
      double d = JSValueToNumber(js_ctx_, value, &local_exc);
      if (local_exc) {
        if (exception) *exception = local_exc;
        return false;
      }
      out->of.f32 = static_cast<float>(d);
      return true;
    }
    case WASM_F64: {
      double d = JSValueToNumber(js_ctx_, value, &local_exc);
      if (local_exc) {
        if (exception) *exception = local_exc;
        return false;
      }
      out->of.f64 = d;
      return true;
    }
    case WASM_I64:
      ValueToBigInt64(out->of.i64, value, local_exc);
      if (local_exc) {
        if (exception) *exception = local_exc;
        return false;
      }
      return true;
    default:
      ThrowIfException(js_ctx_, ErrorTypes::kTypeError, "WebAssembly value",
                       "Unsupported WebAssembly value type", exception);
      return false;
  }
}

JSValueRef JSCEnv::FromWasmValueSlow(const wasm_val_t& value,
                                     JSValueRef* exception) {
  switch (value.kind) {
    case WASM_I64: {
      JSValueRef result = nullptr;
      if (!MakeBigInt64(value.of.i64, &result, exception)) {
        return JSValueMakeUndefined(js_ctx_);
      }
      return result;
    }
    default:
      ThrowIfException(js_ctx_, ErrorTypes::kTypeError, "WebAssembly value",
                       "Unable to convert wasm result", exception);
      return JSValueMakeUndefined(js_ctx_);
  }
}

JSValueRef JSCEnv::ThrowTrap(wasm_trap_t* trap, const char* code,
                             JSValueRef* exception) {
  JSValueRef pending = TakeWasmException();
  if (pending) {
    wasm_trap_delete(trap);
    if (exception) *exception = pending;
    JSValueUnprotect(js_ctx_, pending);
    return JSValueMakeUndefined(js_ctx_);
  }
  wasm_message_t message = {0, nullptr};
  wasm_trap_message(trap, &message);
  std::string text = "WebAssembly Trap: ";
  if (message.data && message.size) {
    text.append(message.data, strnlen(message.data, message.size));
  }
  wasm_byte_vec_delete(&message);
  wasm_trap_delete(trap);
  ThrowIfException(js_ctx_, ErrorTypes::kError, code, text.c_str(), exception);
  return JSValueMakeUndefined(js_ctx_);
}

void JSCEnv::StashWasmException(JSValueRef ex) {
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
  pending_wasm_exception_ = nullptr;
  return ex;
}

}  // namespace primjs::jsc
