/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#if !defined(SRC_NAPI_V8_JS_NATIVE_API_V8_H_) && \
    !defined(_NAPI_V8_EXPORT_SOURCE_ONLY_)
#define SRC_NAPI_V8_JS_NATIVE_API_V8_H_

// This file needs to be compatible with C compilers.
#include <string.h>  // NOLINT(modernize-deprecated-headers)

#include <functional>
#include <unordered_map>

#define NAPI_COMPILE_UNIT v8

#include "js_native_api.h"
#include "js_native_api_v8_internals.h"
#include "napi_state.h"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif
namespace v8impl {

class RefTracker {
 public:
  RefTracker() {}
  virtual ~RefTracker() {}
  virtual void Finalize(bool isEnvTeardown) {}

  typedef RefTracker RefList;

  inline void Link(RefList* list) {
    prev_ = list;
    next_ = list->next_;
    if (next_ != nullptr) {
      next_->prev_ = this;
    }
    list->next_ = this;
  }

  inline void Unlink() {
    if (prev_ != nullptr) {
      prev_->next_ = next_;
    }
    if (next_ != nullptr) {
      next_->prev_ = prev_;
    }
    prev_ = nullptr;
    next_ = nullptr;
  }

  static void FinalizeAll(RefList* list) {
    while (list->next_ != nullptr) {
      list->next_->Finalize(true);
    }
  }

 private:
  RefList* next_ = nullptr;
  RefList* prev_ = nullptr;
};
}  // end of namespace v8impl

struct napi_context__v8 {
  explicit napi_context__v8(napi_env env, v8::Local<v8::Context> context)
      : env(env),
        isolate(context->GetIsolate()),
        context_persistent(isolate, context) {
    CHECK_EQ(isolate, context->GetIsolate());
  }

  ~napi_context__v8() {
    // First we must finalize those references that have `napi_finalizer`
    // callbacks. The reason is that addons might store other references
    // which they delete during their `napi_finalizer` callbacks. If we
    // deleted such references here first, they would be doubly deleted when
    // the `napi_finalizer` deleted them subsequently.
    v8impl::RefTracker::FinalizeAll(&finalizing_reflist);
    v8impl::RefTracker::FinalizeAll(&reflist);

    last_exception.Reset();
    context_persistent.Reset();
    instance_data_registry.clear();
  }

  napi_env env;
  v8::Isolate* const isolate;  // Shortcut for context()->GetIsolate()
  v8impl::Persistent<v8::Context> context_persistent;

  inline v8::Local<v8::Context> context() const {
    return v8impl::PersistentToLocal::Strong(context_persistent);
  }

  inline void Ref() { refs++; }
  inline void Unref() {
    if (--refs == 0) delete this;
  }

  bool can_call_into_js() const { return true; }

  static inline void HandleThrow(napi_context ctx, v8::Local<v8::Value> value) {
    ctx->isolate->ThrowException(value);
  }

  template <typename T, typename U = decltype(HandleThrow)>
  inline void CallIntoModule(T&& call, U&& handle_exception = HandleThrow) {
    int open_handle_scopes_before = open_handle_scopes;
    int open_callback_scopes_before = open_context_scopes;
    (void)open_handle_scopes_before;
    (void)open_callback_scopes_before;
    napi_clear_last_error(this->env);
    call(this->env);
    CHECK_EQ(open_handle_scopes, open_handle_scopes_before);
    CHECK_EQ(open_context_scopes, open_callback_scopes_before);
    if (!last_exception.IsEmpty()) {
      handle_exception(this, last_exception.Get(this->isolate));
      last_exception.Reset();
    }
  }

  void CallFinalizer(napi_finalize cb, void* data, void* hint) {
    v8::HandleScope handle_scope(isolate);
    CallIntoModule([&](napi_env env) { cb(env, data, hint); });
  }

  v8impl::Persistent<v8::Value> last_exception;

  // We store references in two different lists, depending on whether they have
  // `napi_finalizer` callbacks, because we must first finalize the ones that
  // have such a callback. See `~napi_context__v8()` above for details.
  v8impl::RefTracker::RefList reflist;
  v8impl::RefTracker::RefList finalizing_reflist;
  int open_handle_scopes = 0;
  int open_context_scopes = 0;
  int refs = 1;
  std::unordered_map<uint64_t, void*> instance_data_registry;
};

#define RETURN_STATUS_IF_FALSE(env, condition, status) \
  do {                                                 \
    if (!(condition)) {                                \
      return napi_set_last_error((env), (status));     \
    }                                                  \
  } while (0)

#define RETURN_STATUS_IF_FALSE_WITH_PREAMBLE(env, condition, status)         \
  do {                                                                       \
    if (!(condition)) {                                                      \
      return napi_set_last_error(                                            \
          (env), try_catch.HasCaught() ? napi_pending_exception : (status)); \
    }                                                                        \
  } while (0)

#define CHECK_ARG(env, arg) \
  RETURN_STATUS_IF_FALSE((env), ((arg) != nullptr), napi_invalid_arg)

#define CHECK_ARG_WITH_PREAMBLE(env, arg)                         \
  RETURN_STATUS_IF_FALSE_WITH_PREAMBLE((env), ((arg) != nullptr), \
                                       napi_invalid_arg)

#define CHECK_MAYBE_EMPTY(env, maybe, status) \
  RETURN_STATUS_IF_FALSE((env), !((maybe).IsEmpty()), (status))

#define CHECK_MAYBE_EMPTY_WITH_PREAMBLE(env, maybe, status) \
  RETURN_STATUS_IF_FALSE_WITH_PREAMBLE((env), !((maybe).IsEmpty()), (status))

// NAPI_PREAMBLE is not wrapped in do..while: try_catch must have function scope
#define NAPI_PREAMBLE(env)                                                    \
  RETURN_STATUS_IF_FALSE(                                                     \
      (env),                                                                  \
      (env)->ctx->last_exception.IsEmpty() && (env)->ctx->can_call_into_js(), \
      napi_pending_exception);                                                \
  napi_clear_last_error((env));                                               \
  v8impl::TryCatch try_catch((env))

#define CHECK_TO_TYPE(env, type, context, result, src, status)         \
  do {                                                                 \
    auto maybe =                                                       \
        v8impl::V8LocalValueFromJsValue((src)) -> To##type((context)); \
    CHECK_MAYBE_EMPTY((env), maybe, (status));                         \
    (result) = maybe.ToLocalChecked();                                 \
  } while (0)

#define CHECK_TO_FUNCTION(env, result, src)                                 \
  do {                                                                      \
    v8::Local<v8::Value> v8value = v8impl::V8LocalValueFromJsValue((src));  \
    RETURN_STATUS_IF_FALSE((env), v8value->IsFunction(), napi_invalid_arg); \
    (result) = v8value.As<v8::Function>();                                  \
  } while (0)

#define CHECK_TO_OBJECT(env, context, result, src) \
  CHECK_TO_TYPE((env), Object, (context), (result), (src), napi_object_expected)

#define CHECK_TO_STRING(env, context, result, src) \
  CHECK_TO_TYPE((env), String, (context), (result), (src), napi_string_expected)

#define GET_RETURN_STATUS(env) \
  (!try_catch.HasCaught()      \
       ? napi_ok               \
       : napi_set_last_error((env), napi_pending_exception))

#define THROW_RANGE_ERROR_IF_FALSE(env, condition, error, message) \
  do {                                                             \
    if (!(condition)) {                                            \
      napi_throw_range_error((env), (error), (message));           \
      return napi_set_last_error((env), napi_generic_failure);     \
    }                                                              \
  } while (0)

#define RETURN_STATUS_IF_FALSE_WITH_PREAMBLE(env, condition, status)         \
  do {                                                                       \
    if (!(condition)) {                                                      \
      return napi_set_last_error(                                            \
          (env), try_catch.HasCaught() ? napi_pending_exception : (status)); \
    }                                                                        \
  } while (0)

#define CHECK_MAYBE_EMPTY_WITH_PREAMBLE(env, maybe, status) \
  RETURN_STATUS_IF_FALSE_WITH_PREAMBLE((env), !((maybe).IsEmpty()), (status))

namespace v8impl {

//=== Conversion between V8 Handles and napi_value ========================

// This asserts v8::Local<> will always be implemented with a single
// pointer field so that we can pass it around as a void*.
static_assert(sizeof(v8::Local<v8::Value>) == sizeof(napi_value),
              "Cannot convert between v8::Local<v8::Value> and napi_value");

inline napi_value JsValueFromV8LocalValue(v8::Local<v8::Value> local) {
  return reinterpret_cast<napi_value>(*local);
}

inline v8::Local<v8::Value> V8LocalValueFromJsValue(napi_value v) {
  union UnionV {
    UnionV() : v_v8() {}
    v8::Local<v8::Value> v_v8;
    napi_value v_napi;
  } value;
  value.v_napi = v;
  return value.v_v8;
}

// Adapter for napi_finalize callbacks.
class Finalizer {
 public:
  // Some Finalizers are run during shutdown when the napi_env is destroyed,
  // and some need to keep an explicit reference to the napi_env because they
  // are run independently.
  enum EnvReferenceMode { kNoEnvReference, kKeepEnvReference };

 protected:
  Finalizer(napi_env env, napi_finalize finalize_callback, void* finalize_data,
            void* finalize_hint, EnvReferenceMode refmode = kNoEnvReference)
      : _env(env),
        _finalize_callback(finalize_callback),
        _finalize_data(finalize_data),
        _finalize_hint(finalize_hint),
        _has_env_reference(refmode == kKeepEnvReference) {
    if (_has_env_reference) _env->ctx->Ref();
  }

  ~Finalizer() {
    if (_has_env_reference) _env->ctx->Unref();
  }

 public:
  static Finalizer* New(napi_env env, napi_finalize finalize_callback = nullptr,
                        void* finalize_data = nullptr,
                        void* finalize_hint = nullptr,
                        EnvReferenceMode refmode = kNoEnvReference) {
    return new Finalizer(env, finalize_callback, finalize_data, finalize_hint,
                         refmode);
  }

  static void Delete(Finalizer* finalizer) { delete finalizer; }

 protected:
  napi_env _env;
  napi_finalize _finalize_callback;
  void* _finalize_data;
  void* _finalize_hint;
  bool _finalize_ran = false;
  bool _has_env_reference = false;
};

class TryCatch : public v8::TryCatch {
 public:
  explicit TryCatch(napi_env env)
      : v8::TryCatch(env->ctx->isolate), _env(env) {}

  ~TryCatch() {
    if (HasCaught()) {
      _env->ctx->last_exception.Reset(_env->ctx->isolate, Exception());
    }
  }

 private:
  napi_env _env;
};

}  // end of namespace v8impl
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif
#endif  // SRC_NAPI_V8_JS_NATIVE_API_V8_H_
