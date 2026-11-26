// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "common/wasm_c_api_dispatch.h"

#include <cstdarg>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "common/wasm_log.h"
#include "common/wasm_store_owner.h"
#include "common/wasm_type.h"
#include "common/wasm_utils.h"

namespace primjs {

WASM_MINSIZE bool WasmSignature::EnsureSlow(const wasm_func_t* func) {
  if (!func) return false;
  wasm_functype_t* type = wasm_func_type(func);
  if (!type) return false;
  const wasm_valtype_vec_t* params = wasm_functype_params(type);
  const wasm_valtype_vec_t* results = wasm_functype_results(type);
  if (!params || !results || params->size > UINT16_MAX ||
      results->size > UINT16_MAX) {
    wasm_functype_delete(type);
    return false;
  }
  const size_t total = params->size + results->size;
  wasm_valkind_t* dst = inline_kinds_;
  if (total > kInlineCap) {
    dst = static_cast<wasm_valkind_t*>(std::malloc(total));
    if (!dst) {
      wasm_functype_delete(type);
      return false;
    }
    std::free(heap_kinds_);
    heap_kinds_ = dst;
  }
  param_count_ = static_cast<uint16_t>(params->size);
  result_count_ = static_cast<uint16_t>(results->size);
  for (size_t i = 0; i < params->size; ++i) {
    dst[i] = wasm_valtype_kind(params->data[i]);
  }
  for (size_t i = 0; i < results->size; ++i) {
    dst[params->size + i] = wasm_valtype_kind(results->data[i]);
  }
  wasm_functype_delete(type);
  ready_ = true;
  return true;
}

WASM_MINSIZE bool WasmSignature::Matches(
    const wasm_functype_t* expected) const {
  if (!expected || !ready_) return false;
  const wasm_valtype_vec_t* params = wasm_functype_params(expected);
  const wasm_valtype_vec_t* results = wasm_functype_results(expected);
  if (!params || !results || params->size != param_count_ ||
      results->size != result_count_) {
    return false;
  }
  const wasm_valkind_t* p = param_kinds();
  const wasm_valkind_t* r = result_kinds();
  for (size_t i = 0; i < param_count_; ++i) {
    if (wasm_valtype_kind(params->data[i]) != p[i]) return false;
  }
  for (size_t i = 0; i < result_count_; ++i) {
    if (wasm_valtype_kind(results->data[i]) != r[i]) return false;
  }
  return true;
}

namespace wasm {

#if defined(PRIMJS_WASM_DYNAMIC_C_API)
WasmCApiTable g_wasm_c_api = {};

namespace {
constexpr char kWasmCApiSymbolSuffixes[] =
#define PRIMJS_ENCODE_SUFFIX(unused, suffix) #suffix "\0"
    PRIMJS_WASM_C_API_SUFFIX_LIST(PRIMJS_ENCODE_SUFFIX, 0)
#undef PRIMJS_ENCODE_SUFFIX
    ;
}  // namespace

WASM_MINSIZE bool BindWasmCApiFromLibrary(void* library_handle,
                                          WasmCApiSymbolResolver resolve_symbol,
                                          const char** missing_symbol) {
  static char s_missing_name[64];
  if (missing_symbol) *missing_symbol = nullptr;
  if (!library_handle || !resolve_symbol) return false;
  WasmCApiTable candidate = {};
  auto** slots = reinterpret_cast<void**>(&candidate);
  const char* cursor = kWasmCApiSymbolSuffixes;
  char full_name[64] = {'w', 'a', 's', 'm', '_'};
  for (size_t i = 0; i < kWasmCApiSymbolCount; ++i) {
    const size_t suffix_len = std::strlen(cursor);
    std::memcpy(full_name + 5, cursor, suffix_len + 1);
    void* symbol = resolve_symbol(library_handle, full_name);
    if (symbol == nullptr) {
      if (missing_symbol) {
        std::memcpy(s_missing_name, full_name, suffix_len + 6);
        *missing_symbol = s_missing_name;
      }
      return false;
    }
    slots[i] = symbol;
    cursor += suffix_len + 1;
  }
  g_wasm_c_api = candidate;
  return true;
}

WASM_MINSIZE bool BindWasmCApiFromTable(const void* const* symbol_table,
                                        size_t symbol_count) {
  if (!symbol_table || symbol_count != kWasmCApiSymbolCount) {
    return false;
  }
  WasmCApiTable candidate = {};
  auto** slots = reinterpret_cast<void**>(&candidate);
  for (size_t i = 0; i < kWasmCApiSymbolCount; ++i) {
    if (symbol_table[i] == nullptr) {
      return false;
    }
    slots[i] = const_cast<void*>(symbol_table[i]);
  }
  g_wasm_c_api = candidate;
  return true;
}

bool IsWasmCApiBound() { return g_wasm_c_api.fn_wasm_engine_new != nullptr; }

void ResetWasmCApiForTesting() {
  std::memset(&g_wasm_c_api, 0, sizeof(g_wasm_c_api));
}
#endif  // defined(PRIMJS_WASM_DYNAMIC_C_API)

namespace {
inline int DecodeBase64Sextet(uint8_t c) {
  if (c >= 'A' && c <= 'Z') return c - 'A';
  if (c >= 'a' && c <= 'z') return c - 'a' + 26;
  if (c >= '0' && c <= '9') return c - '0' + 52;
  if (c == '+') return 62;
  if (c == '/') return 63;
  return -1;
}
}  // namespace

WASM_MINSIZE bool DecodeBase64(const uint8_t* src, size_t len,
                               uint8_t** out_data, size_t* out_len) {
  if (len == 0) {
    auto* empty = static_cast<uint8_t*>(std::malloc(1));
    if (!empty) return false;
    *out_data = empty;
    *out_len = 0;
    return true;
  }
  if (len < 4 || (len & 3u) != 0) return false;
  size_t pad = 0;
  if (src[len - 1] == '=') {
    pad = 1;
    if (src[len - 2] == '=') pad = 2;
  }
  const size_t decoded_len = (len >> 2) * 3 - pad;
  auto* dst = static_cast<uint8_t*>(std::malloc(decoded_len ? decoded_len : 1));
  if (!dst) return false;

  const size_t full_quads = (len >> 2) - (pad ? 1 : 0);
  size_t out_idx = 0;
  for (size_t q = 0; q < full_quads; ++q) {
    const uint8_t* p = src + (q << 2);
    const int a = DecodeBase64Sextet(p[0]);
    const int b = DecodeBase64Sextet(p[1]);
    const int c = DecodeBase64Sextet(p[2]);
    const int d = DecodeBase64Sextet(p[3]);
    if (wasm_unlikely((a | b | c | d) < 0)) {
      std::free(dst);
      return false;
    }
    const uint32_t v =
        (static_cast<uint32_t>(a) << 18) | (static_cast<uint32_t>(b) << 12) |
        (static_cast<uint32_t>(c) << 6) | static_cast<uint32_t>(d);
    dst[out_idx++] = static_cast<uint8_t>(v >> 16);
    dst[out_idx++] = static_cast<uint8_t>(v >> 8);
    dst[out_idx++] = static_cast<uint8_t>(v);
  }
  if (pad) {
    const uint8_t* p = src + (full_quads << 2);
    const int a = DecodeBase64Sextet(p[0]);
    const int b = DecodeBase64Sextet(p[1]);
    if ((a | b) < 0) {
      std::free(dst);
      return false;
    }
    if (pad == 2) {
      dst[out_idx++] = static_cast<uint8_t>((a << 2) | (b >> 4));
    } else {
      const int c = DecodeBase64Sextet(p[2]);
      if (c < 0) {
        std::free(dst);
        return false;
      }
      const uint32_t v = (static_cast<uint32_t>(a) << 12) |
                         (static_cast<uint32_t>(b) << 6) |
                         static_cast<uint32_t>(c);
      dst[out_idx++] = static_cast<uint8_t>(v >> 10);
      dst[out_idx++] = static_cast<uint8_t>(v >> 2);
    }
  }
  *out_data = dst;
  *out_len = out_idx;
  return true;
}

WasmStoreOwner::WasmStoreOwner() {
  pthread_mutex_init(&tracked_mutex_, nullptr);
  pthread_cond_init(&tracked_cv_, nullptr);
  head_.prev = &head_;
  head_.next = &head_;
}

WasmStoreOwner::~WasmStoreOwner() {
  ReleaseStore();
  pthread_cond_destroy(&tracked_cv_);
  pthread_mutex_destroy(&tracked_mutex_);
}

WASM_MINSIZE WasmStoreOwner* WasmStoreOwner::CreateRaw() {
  auto* owner = new WasmStoreOwner();
  if (!owner->Init()) {
    delete owner;
    return nullptr;
  }
  return owner;
}

WASM_MINSIZE bool WasmStoreOwner::Init() {
  engine_ = wasm_engine_new();
  if (wasm_unlikely(!engine_)) return false;
  store_ = wasm_store_new(engine_);
  if (wasm_unlikely(!store_)) {
    wasm_engine_delete(engine_);
    engine_ = nullptr;
    return false;
  }
  return true;
}

WASM_MINSIZE void WasmStoreOwner::ReleaseStore() {
  if (store_) {
    wasm_store_delete(store_);
    store_ = nullptr;
  }
  if (engine_) {
    wasm_engine_delete(engine_);
    engine_ = nullptr;
  }
}

WASM_MINSIZE void WasmStoreOwner::LinkHandle(
    WasmTrackedHandle* handle, void* owner_object,
    WasmTrackedHandle::DetachCallback detach_fn, bool priority_buffer_phase) {
  if (wasm_unlikely(!handle || !detach_fn)) return;
  pthread_mutex_lock(&tracked_mutex_);
  handle->owner_object = owner_object;
  handle->detach_fn = detach_fn;
  handle->priority_buffer_phase = priority_buffer_phase;
  handle->prev = head_.prev;
  handle->next = &head_;
  head_.prev->next = handle;
  head_.prev = handle;
  pthread_mutex_unlock(&tracked_mutex_);
}

WASM_MINSIZE bool WasmStoreOwner::UnlinkHandle(WasmTrackedHandle* handle) {
  if (wasm_unlikely(!handle)) return false;
  const pthread_t self_tid = pthread_self();
  pthread_mutex_lock(&tracked_mutex_);
  while (detaching_ == handle && detaching_active_ &&
         !pthread_equal(detaching_tid_, self_tid)) {
    pthread_cond_wait(&tracked_cv_, &tracked_mutex_);
  }
  if (!handle->prev) {
    pthread_mutex_unlock(&tracked_mutex_);
    return false;
  }
  handle->prev->next = handle->next;
  handle->next->prev = handle->prev;
  handle->prev = nullptr;
  handle->next = nullptr;
  pthread_mutex_unlock(&tracked_mutex_);
  return true;
}

WASM_MINSIZE WasmTrackedHandle* WasmStoreOwner::PopOneHandleForDetach(
    bool priority_buffer_phase, pthread_t tid) {
  pthread_mutex_lock(&tracked_mutex_);
  for (WasmTrackedHandle* cur = head_.next; cur != &head_; cur = cur->next) {
    if (cur->priority_buffer_phase == priority_buffer_phase) {
      cur->prev->next = cur->next;
      cur->next->prev = cur->prev;
      cur->prev = nullptr;
      cur->next = nullptr;
      detaching_ = cur;
      detaching_tid_ = tid;
      detaching_active_ = true;
      pthread_mutex_unlock(&tracked_mutex_);
      return cur;
    }
  }
  pthread_mutex_unlock(&tracked_mutex_);
  return nullptr;
}

WASM_MINSIZE void WasmStoreOwner::FinishHandleDetach() {
  pthread_mutex_lock(&tracked_mutex_);
  detaching_ = nullptr;
  detaching_active_ = false;
  pthread_mutex_unlock(&tracked_mutex_);
  pthread_cond_broadcast(&tracked_cv_);
}

WASM_MINSIZE void WasmStoreOwner::DrainMatchingHandles(
    void* exit_ctx, bool priority_buffer_phase) {
  const pthread_t tid = pthread_self();
  while (WasmTrackedHandle* handle =
             PopOneHandleForDetach(priority_buffer_phase, tid)) {
    handle->detach_fn(handle, exit_ctx);
    FinishHandleDetach();
  }
}

WASM_MINSIZE void WasmStoreOwner::DrainHandlesOnExit(void* exit_ctx) {
  DrainMatchingHandles(exit_ctx, true);
  DrainMatchingHandles(exit_ctx, false);
}

WASM_MINSIZE bool WasmStoreOwner::TryRetain(WasmStoreOwner* owner) {
  if (wasm_unlikely(!owner)) return false;
  int cur = owner->ref_count_.load(std::memory_order_acquire);
  while (cur > 0) {
    if (owner->ref_count_.compare_exchange_weak(cur, cur + 1,
                                                std::memory_order_acq_rel,
                                                std::memory_order_acquire)) {
      return true;
    }
  }
  return false;
}

WASM_MINSIZE void WasmStoreOwner::Release(WasmStoreOwner*& owner) {
  auto* target = owner;
  owner = nullptr;
  if (wasm_unlikely(!target)) return;
  WASM_DCHECK(target->ref_count_.load(std::memory_order_acquire) > 0);
  const int remaining =
      target->ref_count_.fetch_sub(1, std::memory_order_seq_cst) - 1;
  if (remaining == 0) {
    MaybeFinishRelease(target);
  }
}

WASM_MINSIZE void WasmStoreOwner::RequestRelease(WasmStoreOwner* owner) {
  if (wasm_unlikely(!owner)) return;
  owner->release_requested_.store(true, std::memory_order_seq_cst);
  if (owner->ref_count_.load(std::memory_order_seq_cst) == 0) {
    MaybeFinishRelease(owner);
  }
}

WASM_MINSIZE void WasmStoreOwner::RequestReleaseAndConsumeRef(
    WasmStoreOwner*& owner) {
  auto* target = owner;
  owner = nullptr;
  if (wasm_unlikely(!target)) return;
  target->release_requested_.store(true, std::memory_order_seq_cst);
  Release(target);
}

WASM_MINSIZE void WasmStoreOwner::MaybeFinishRelease(WasmStoreOwner* owner) {
  if (!owner || !owner->release_requested_.load(std::memory_order_seq_cst) ||
      owner->ref_count_.load(std::memory_order_seq_cst) != 0) {
    return;
  }
  if (owner->release_claimed_.exchange(true, std::memory_order_acq_rel)) {
    return;
  }
  if (BeforeDeleteCallback cb = owner->before_delete_cb_.exchange(
          nullptr, std::memory_order_acq_rel)) {
    cb(owner);
  }
  if (auto* count = owner->release_count_for_testing_) {
    count->fetch_add(1, std::memory_order_acq_rel);
  }
  owner->ReleaseStore();
  delete owner;
}

WASM_MINSIZE WasmBufferKeep* WasmBufferKeep::Create(
    WasmStoreOwner* store_owner, wasm_memory_t* source_memory,
    WasmTrackedHandle::DetachCallback exit_detach) {
  if (!store_owner || !source_memory) return nullptr;
  wasm_memory_t* copy = wasm_memory_copy(source_memory);
  if (!copy) return nullptr;
  WasmStoreOwner::Retain(store_owner);
  auto* keep = new WasmBufferKeep();
  keep->owner = store_owner;
  keep->memory = copy;
  if (exit_detach) {
    store_owner->LinkHandle(&keep->tracked, keep, exit_detach, true);
  }
  return keep;
}

WASM_MINSIZE void WasmBufferKeep::DropOnce() {
  if (dropped.exchange(true, std::memory_order_acq_rel)) {
    return;
  }
  if (owner) {
    owner->UnlinkHandle(&tracked);
  }
  if (memory) {
    wasm_memory_delete(memory);
    memory = nullptr;
  }
  if (owner) {
    WasmStoreOwner::Release(owner);
  }
}

void WasmLogPrint(int level, const char* format, ...) {
  char buf[256];
  va_list args;
  va_start(args, format);
  std::vsnprintf(buf, sizeof(buf), format, args);
  va_end(args);

#if defined(OS_ANDROID)
  int prio = ANDROID_LOG_INFO;
  const char* tag = "WasmInfo";
  if (level <= LOG_LEVEL_ERROR) {
    prio = ANDROID_LOG_ERROR;
    tag = "WasmError";
  } else if (level == LOG_LEVEL_DEBUG || level == LOG_LEVEL_VERBOSE) {
    prio = ANDROID_LOG_DEBUG;
    tag = "WasmDebug";
  }
  __android_log_write(prio, tag, buf);
#elif defined(OS_IOS) || defined(OS_HARMONY)
  if (level <= LOG_LEVEL_ERROR) {
    LOGE(buf);
  } else if (level == LOG_LEVEL_INFO) {
    LOGI(buf);
  } else {
    LOGV(buf);
  }
#else
  if (level <= LOG_LEVEL_ERROR) {
    std::fprintf(stderr, "[WasmError] %s\n", buf);
  }
#endif
}

}  // namespace wasm
}  // namespace primjs
