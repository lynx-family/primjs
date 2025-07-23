/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#ifndef SRC_NAPI_V8_JS_NATIVE_API_V8_CC_H_
#define SRC_NAPI_V8_JS_NATIVE_API_V8_CC_H_
#ifndef _NAPI_V8_EXPORT_SOURCE_ONLY_
#include <algorithm>
#include <climits>  // INT_MAX
#include <cmath>
#include <utility>
#include <vector>

#include "js_native_api_v8.h"
#include "napi_env_v8.h"
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif
#define DECLARE_METHOD(API) \
  static std::remove_pointer<decltype(napi_env__::napi_##API)>::type napi_##API;

FOR_EACH_NAPI_ENGINE_CALL(DECLARE_METHOD)

#undef DECLARE_METHOD

#define CHECK_MAYBE_NOTHING(env, maybe, status) \
  RETURN_STATUS_IF_FALSE((env), !((maybe).IsNothing()), (status))

#define CHECK_MAYBE_NOTHING_WITH_PREAMBLE(env, maybe, status) \
  RETURN_STATUS_IF_FALSE_WITH_PREAMBLE((env), !((maybe).IsNothing()), (status))

#define CHECK_TO_NUMBER(env, context, result, src) \
  CHECK_TO_TYPE((env), Number, (context), (result), (src), napi_number_expected)

// n-api defines NAPI_AUTO_LENGHTH as the indicator that a string
// is null terminated. For V8 the equivalent is -1. The assert
// validates that our cast of NAPI_AUTO_LENGTH results in -1 as
// needed by V8.
#define CHECK_NEW_FROM_UTF8_LEN(env, result, str, len)                         \
  do {                                                                         \
    static_assert(static_cast<int>(NAPI_AUTO_LENGTH) == -1,                    \
                  "Casting NAPI_AUTO_LENGTH to int must result in -1");        \
    RETURN_STATUS_IF_FALSE((env), (len == NAPI_AUTO_LENGTH) || len <= INT_MAX, \
                           napi_invalid_arg);                                  \
    RETURN_STATUS_IF_FALSE((env), (str) != nullptr, napi_invalid_arg);         \
    auto str_maybe = v8::String::NewFromUtf8((env)->ctx->isolate, (str),       \
                                             v8::NewStringType::kInternalized, \
                                             static_cast<int>(len));           \
    CHECK_MAYBE_EMPTY((env), str_maybe, napi_generic_failure);                 \
    (result) = str_maybe.ToLocalChecked();                                     \
  } while (0)

#define CHECK_NEW_FROM_UTF8(env, result, str) \
  CHECK_NEW_FROM_UTF8_LEN((env), (result), (str), NAPI_AUTO_LENGTH)

#define CREATE_TYPED_ARRAY(env, type, size_of_element, buffer, byte_offset,   \
                           length, out)                                       \
  do {                                                                        \
    if ((size_of_element) > 1) {                                              \
      THROW_RANGE_ERROR_IF_FALSE(                                             \
          (env), (byte_offset) % (size_of_element) == 0,                      \
          "ERR_NAPI_INVALID_TYPEDARRAY_ALIGNMENT",                            \
          "start offset of " #type                                            \
          " should be a multiple of " #size_of_element);                      \
    }                                                                         \
    THROW_RANGE_ERROR_IF_FALSE(                                               \
        (env),                                                                \
        (length) * (size_of_element) + (byte_offset) <= buffer->ByteLength(), \
        "ERR_NAPI_INVALID_TYPEDARRAY_LENGTH", "Invalid typed array length");  \
    (out) = v8::type::New((buffer), (byte_offset), (length));                 \
  } while (0)

namespace v8impl {

namespace {

inline static napi_status V8NameFromPropertyDescriptor(
    napi_env env, const napi_property_descriptor* p,
    v8::Local<v8::Name>* result) {
  if (p->utf8name != nullptr) {
    CHECK_NEW_FROM_UTF8(env, *result, p->utf8name);
  } else {
    v8::Local<v8::Value> property_value =
        v8impl::V8LocalValueFromJsValue(p->name);

    RETURN_STATUS_IF_FALSE(env, property_value->IsName(), napi_name_expected);
    *result = property_value.As<v8::Name>();
  }

  return napi_ok;
}

// convert from n-api property attributes to v8::PropertyAttribute
inline static v8::PropertyAttribute V8PropertyAttributesFromDescriptor(
    const napi_property_descriptor* descriptor) {
  unsigned int attribute_flags = v8::PropertyAttribute::None;

  // The napi_writable attribute is ignored for accessor descriptors, but
  // V8 would throw `TypeError`s on assignment with nonexistence of a setter.
  if ((descriptor->getter == nullptr && descriptor->setter == nullptr) &&
      (descriptor->attributes & napi_writable) == 0) {
    attribute_flags |= v8::PropertyAttribute::ReadOnly;
  }

  if ((descriptor->attributes & napi_enumerable) == 0) {
    attribute_flags |= v8::PropertyAttribute::DontEnum;
  }
  if ((descriptor->attributes & napi_configurable) == 0) {
    attribute_flags |= v8::PropertyAttribute::DontDelete;
  }

  return static_cast<v8::PropertyAttribute>(attribute_flags);
}

inline static napi_deferred JsDeferredFromNodePersistent(
    v8impl::Persistent<v8::Value>* local) {
  return reinterpret_cast<napi_deferred>(local);
}

inline static v8impl::Persistent<v8::Value>* NodePersistentFromJsDeferred(
    napi_deferred local) {
  return reinterpret_cast<v8impl::Persistent<v8::Value>*>(local);
}

class ContextScopeWrapper {
 public:
  explicit ContextScopeWrapper(v8::Local<v8::Context> ctx) : scope(ctx) {}

 private:
  v8::Context::Scope scope;
};

class HandleScopeWrapper {
 public:
  explicit HandleScopeWrapper(v8::Isolate* isolate) : scope(isolate) {}

 private:
  v8::HandleScope scope;
};

// In node v0.10 version of v8, there is no EscapableHandleScope and the
// node v0.10 port use HandleScope::Close(Local<T> v) to mimic the behavior
// of a EscapableHandleScope::Escape(Local<T> v), but it is not the same
// semantics. This is an example of where the api abstraction fail to work
// across different versions.
class EscapableHandleScopeWrapper {
 public:
  explicit EscapableHandleScopeWrapper(v8::Isolate* isolate)
      : scope(isolate), escape_called_(false) {}
  bool escape_called() const { return escape_called_; }
  template <typename T>
  v8::Local<T> Escape(v8::Local<T> handle) {
    escape_called_ = true;
    return scope.Escape(handle);
  }

 private:
  v8::EscapableHandleScope scope;
  bool escape_called_;
};

inline static napi_context_scope JsContextScopeFromV8ContextScope(
    ContextScopeWrapper* s) {
  return reinterpret_cast<napi_context_scope>(s);
}

inline static ContextScopeWrapper* V8ContextScopeFromJsContextScope(
    napi_context_scope s) {
  return reinterpret_cast<ContextScopeWrapper*>(s);
}

inline static napi_handle_scope JsHandleScopeFromV8HandleScope(
    HandleScopeWrapper* s) {
  return reinterpret_cast<napi_handle_scope>(s);
}

inline static HandleScopeWrapper* V8HandleScopeFromJsHandleScope(
    napi_handle_scope s) {
  return reinterpret_cast<HandleScopeWrapper*>(s);
}

inline static napi_escapable_handle_scope
JsEscapableHandleScopeFromV8EscapableHandleScope(
    EscapableHandleScopeWrapper* s) {
  return reinterpret_cast<napi_escapable_handle_scope>(s);
}

inline static EscapableHandleScopeWrapper*
V8EscapableHandleScopeFromJsEscapableHandleScope(
    napi_escapable_handle_scope s) {
  return reinterpret_cast<EscapableHandleScopeWrapper*>(s);
}

inline static napi_status ConcludeDeferred(napi_env env, napi_deferred deferred,
                                           napi_value result,
                                           bool is_resolved) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8impl::Persistent<v8::Value>* deferred_ref =
      NodePersistentFromJsDeferred(deferred);
  v8::Local<v8::Value> v8_deferred =
      v8::Local<v8::Value>::New(env->ctx->isolate, *deferred_ref);

  auto v8_resolver = v8::Local<v8::Promise::Resolver>::Cast(v8_deferred);

  v8::Maybe<bool> success =
      is_resolved ? v8_resolver->Resolve(
                        context, v8impl::V8LocalValueFromJsValue(result))
                  : v8_resolver->Reject(
                        context, v8impl::V8LocalValueFromJsValue(result));

  delete deferred_ref;

  RETURN_STATUS_IF_FALSE(env, success.FromMaybe(false), napi_generic_failure);

  return GET_RETURN_STATUS(env);
}

// Wrapper around v8impl::Persistent that implements reference counting.
class RefBase : protected Finalizer, RefTracker {
 protected:
  RefBase(napi_env env, uint32_t initial_refcount, bool delete_self,
          napi_finalize finalize_callback, void* finalize_data,
          void* finalize_hint)
      : Finalizer(env, finalize_callback, finalize_data, finalize_hint),
        _refcount(initial_refcount),
        _delete_self(delete_self) {
    Link(finalize_callback == nullptr ? &env->ctx->reflist
                                      : &env->ctx->finalizing_reflist);
  }

 public:
  static RefBase* New(napi_env env, uint32_t initial_refcount, bool delete_self,
                      napi_finalize finalize_callback, void* finalize_data,
                      void* finalize_hint) {
    return new RefBase(env, initial_refcount, delete_self, finalize_callback,
                       finalize_data, finalize_hint);
  }

  virtual ~RefBase() { Unlink(); }

  inline void* Data() { return _finalize_data; }

  // Delete is called in 2 ways. Either from the finalizer or
  // from one of Unwrap or napi_delete_reference.
  //
  // When it is called from Unwrap or napi_delete_reference we only
  // want to do the delete if the finalizer has already run or
  // cannot have been queued to run (ie the reference count is > 0),
  // otherwise we may crash when the finalizer does run.
  // If the finalizer may have been queued and has not already run
  // delay the delete until the finalizer runs by not doing the delete
  // and setting _delete_self to true so that the finalizer will
  // delete it when it runs.
  //
  // The second way this is called is from
  // the finalizer and _delete_self is set. In this case we
  // know we need to do the deletion so just do it.
  static inline void Delete(RefBase* reference) {
    if ((reference->RefCount() != 0) || (reference->_delete_self) ||
        (reference->_finalize_ran)) {
      delete reference;
    } else {
      // defer until finalizer runs as
      // it may alread be queued
      reference->_delete_self = true;
    }
  }

  inline uint32_t Ref() { return ++_refcount; }

  inline uint32_t Unref() {
    if (_refcount == 0) {
      return 0;
    }
    return --_refcount;
  }

  inline uint32_t RefCount() { return _refcount; }

 protected:
  inline void Finalize(bool is_env_teardown = false) override {
    // In addition to being called during environment teardown, this method is
    // also the entry point for the garbage collector. During environment
    // teardown we have to remove the garbage collector's reference to this
    // method so that, if, as part of the user's callback, JS gets executed,
    // resulting in a garbage collection pass, this method is not re-entered as
    // part of that pass, because that'll cause a double free (as seen in
    // https://github.com/nodejs/node/issues/37236).
    //
    // Since this class does not have access to the V8 persistent reference,
    // this method is overridden in the `Reference` class below. Therein the
    // weak callback is removed, ensuring that the garbage collector does not
    // re-enter this method, and the method chains up to continue the process of
    // environment-teardown-induced finalization.

    // During environment teardown we have to convert a strong reference to
    // a weak reference to force the deferring behavior if the user's finalizer
    // happens to delete this reference so that the code in this function that
    // follows the call to the user's finalizer may safely access variables from
    // this instance.
    if (is_env_teardown && RefCount() > 0) _refcount = 0;

    if (_finalize_callback != nullptr) {
      // This ensures that we never call the finalizer twice.
      napi_finalize fini = _finalize_callback;
      _finalize_callback = nullptr;
      _env->ctx->CallFinalizer(fini, _finalize_data, _finalize_hint);
    }

    // this is safe because if a request to delete the reference
    // is made in the finalize_callback it will defer deletion
    // to this block and set _delete_self to true
    if (_delete_self || is_env_teardown) {
      Delete(this);
    } else {
      _finalize_ran = true;
    }
  }

 private:
  uint32_t _refcount;
  bool _delete_self;
};

class Reference : public RefBase {
  using SecondPassCallParameterRef = Reference*;

 protected:
  template <typename... Args>
  Reference(napi_env env, v8::Local<v8::Value> value, Args&&... args)
      : RefBase(env, std::forward<Args>(args)...),
        _persistent(env->ctx->isolate, value),
        _secondPassParameter(new SecondPassCallParameterRef(this)),
        _secondPassScheduled(false) {
    if (RefCount() == 0) {
      SetWeak();
    }
  }

 public:
  static inline Reference* New(napi_env env, v8::Local<v8::Value> value,
                               uint32_t initial_refcount, bool delete_self,
                               napi_finalize finalize_callback = nullptr,
                               void* finalize_data = nullptr,
                               void* finalize_hint = nullptr) {
    return new Reference(env, value, initial_refcount, delete_self,
                         finalize_callback, finalize_data, finalize_hint);
  }

  ~Reference() {
    // If the second pass callback is scheduled, it will delete the
    // parameter passed to it, otherwise it will never be scheduled
    // and we need to delete it here.
    if (!_secondPassScheduled) {
      delete _secondPassParameter;
    }
  }

  inline uint32_t Ref() {
    uint32_t refcount = RefBase::Ref();
    if (refcount == 1) {
      ClearWeak();
    }
    return refcount;
  }

  inline uint32_t Unref() {
    uint32_t old_refcount = RefCount();
    uint32_t refcount = RefBase::Unref();
    if (old_refcount == 1 && refcount == 0) {
      SetWeak();
    }
    return refcount;
  }

  inline v8::Local<v8::Value> Get() {
    if (_persistent.IsEmpty()) {
      return v8::Local<v8::Value>();
    } else {
      return v8::Local<v8::Value>::New(_env->ctx->isolate, _persistent);
    }
  }

 protected:
  void Finalize(bool is_env_teardown = false) {
    // During env teardown, `~napi_env()` alone is responsible for finalizing.
    // Thus, we don't want any stray gc passes to trigger a second call to
    // `RefBase::Finalize()`. ClearWeak will ensure that even if the
    // gc is in progress no Finalization will be run for this Reference
    // by the gc.
    if (is_env_teardown) {
      ClearWeak();
    }

    // Chain up to perform the rest of the finalization.
    RefBase::Finalize(is_env_teardown);
  }

 private:
  void ClearWeak() {
    if (!_persistent.IsEmpty()) {
      _persistent.ClearWeak();
    }
    if (_secondPassParameter != nullptr) {
      *_secondPassParameter = nullptr;
    }
  }
  void SetWeak() {
    if (_secondPassParameter == nullptr) {
      // This means that the Reference has already been processed
      // by the second pass callback, so its already been Finalized, do
      // nothing
      return;
    }
    _persistent.SetWeak(_secondPassParameter, FinalizeCallback,
                        v8::WeakCallbackType::kParameter);
    *_secondPassParameter = this;
  }
  // The N-API finalizer callback may make calls into the engine. V8's heap is
  // not in a consistent state during the weak callback, and therefore it does
  // not support calls back into it. However, it provides a mechanism for adding
  // a finalizer which may make calls back into the engine by allowing us to
  // attach such a second-pass finalizer from the first pass finalizer. Thus,
  // we do that here to ensure that the N-API finalizer callback is free to call
  // into the engine.
  static void FinalizeCallback(
      const v8::WeakCallbackInfo<SecondPassCallParameterRef>& data) {
    SecondPassCallParameterRef* parameter = data.GetParameter();
    Reference* reference = *parameter;
    if (reference == nullptr) {
      return;
    }

    // The reference must be reset during the first pass.
    reference->_persistent.Reset();
    // Mark the parameter not delete-able until the second pass callback is
    // invoked.
    reference->_secondPassScheduled = true;

    data.SetSecondPassCallback(SecondPassCallback);
  }

  static void SecondPassCallback(
      const v8::WeakCallbackInfo<SecondPassCallParameterRef>& data) {
    SecondPassCallParameterRef* parameter = data.GetParameter();
    Reference* reference = *parameter;
    delete parameter;
    if (reference == nullptr) {
      // the reference itself has already been deleted so nothing to do
      return;
    }
    reference->_secondPassParameter = nullptr;
    reference->Finalize();
  }

  v8impl::Persistent<v8::Value> _persistent;
  SecondPassCallParameterRef* _secondPassParameter;
  bool _secondPassScheduled;
};

enum UnwrapAction { KeepWrap, RemoveWrap };

inline static napi_status Unwrap(napi_env env, napi_value js_object,
                                 void** result, UnwrapAction action) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  // val->IsXXX check is expensive, omit them (though not safe)
  v8::Local<v8::Value> value = v8impl::V8LocalValueFromJsValue(js_object);
  //  RETURN_STATUS_IF_FALSE(env, value->IsObject(), napi_invalid_arg);
  v8::Local<v8::Object> obj = value.As<v8::Object>();

  if (obj->InternalFieldCount() == 0) {
    if (result) {
      *result = nullptr;
    }
    return napi_clear_last_error(env);
  }

  auto val = obj->GetInternalField(0);

  if (!val->IsExternal()) {
    if (result) {
      *result = nullptr;
    }
    return napi_clear_last_error(env);
  }

  Reference* reference =
      static_cast<v8impl::Reference*>(val.As<v8::External>()->Value());

  if (result) {
    *result = reference->Data();
  }

  if (action == RemoveWrap) {
    obj->SetInternalField(0, v8::Undefined(env->ctx->isolate));
    Reference::Delete(reference);
  }

  return napi_clear_last_error(env);
}

//=== Function napi_callback wrapper =================================

// Use this data structure to associate callback data with each N-API function
// exposed to JavaScript. The structure is stored in a v8::External which gets
// passed into our callback wrapper. This reduces the performance impact of
// calling through N-API.
// Ref: benchmark/misc/function_call
// Discussion (incl. perf. data): https://github.com/nodejs/node/pull/21072
struct CallbackBundle {
  napi_env env;   // Necessary to invoke C++ NAPI callback
  void* cb_data;  // The user provided callback data
  napi_callback function_or_getter;
  napi_callback setter;
};

// Base class extended by classes that wrap V8 function and property callback
// info.
class CallbackWrapper {
 public:
  CallbackWrapper(napi_value this_arg, size_t args_length, void* data)
      : _this(this_arg), _args_length(args_length), _data(data) {}

  virtual napi_value GetNewTarget() = 0;
  virtual void Args(napi_value* buffer, size_t bufferlength) = 0;
  virtual void SetReturnValue(napi_value value) = 0;

  napi_value This() { return _this; }

  size_t ArgsLength() { return _args_length; }

  void* Data() { return _data; }

 protected:
  const napi_value _this;
  const size_t _args_length;
  void* _data;
};

template <typename Info, napi_callback CallbackBundle::*FunctionField>
class CallbackWrapperBase : public CallbackWrapper {
 public:
  CallbackWrapperBase(const Info& cbinfo, const size_t args_length)
      : CallbackWrapper(JsValueFromV8LocalValue(cbinfo.This()), args_length,
                        nullptr),
        _cbinfo(cbinfo) {
    _bundle = reinterpret_cast<CallbackBundle*>(
        v8::Local<v8::External>::Cast(cbinfo.Data())->Value());
    _data = _bundle->cb_data;
  }

  napi_value GetNewTarget() override { return nullptr; }

 protected:
  void InvokeCallback() {
    napi_callback_info cbinfo_wrapper = reinterpret_cast<napi_callback_info>(
        static_cast<CallbackWrapper*>(this));

    // All other pointers we need are stored in `_bundle`
    napi_env env = _bundle->env;
    napi_callback cb = _bundle->*FunctionField;

    napi_value result;
    env->ctx->CallIntoModule(
        [&](napi_env env) { result = cb(env, cbinfo_wrapper); });

    if (result != nullptr) {
      this->SetReturnValue(result);
    }
  }

  const Info& _cbinfo;
  CallbackBundle* _bundle;
};

class FunctionCallbackWrapper
    : public CallbackWrapperBase<v8::FunctionCallbackInfo<v8::Value>,
                                 &CallbackBundle::function_or_getter> {
 public:
  static void Invoke(const v8::FunctionCallbackInfo<v8::Value>& info) {
    FunctionCallbackWrapper cbwrapper(info);
    cbwrapper.InvokeCallback();
  }

  explicit FunctionCallbackWrapper(
      const v8::FunctionCallbackInfo<v8::Value>& cbinfo)
      : CallbackWrapperBase(cbinfo, cbinfo.Length()) {}

  napi_value GetNewTarget() override {
    if (_cbinfo.IsConstructCall()) {
      return v8impl::JsValueFromV8LocalValue(_cbinfo.NewTarget());
    } else {
      return nullptr;
    }
  }

  /*virtual*/
  void Args(napi_value* buffer, size_t buffer_length) override {
    size_t i = 0;
    size_t min = std::min(buffer_length, _args_length);

    for (; i < min; i += 1) {
      buffer[i] = v8impl::JsValueFromV8LocalValue(_cbinfo[i]);
    }

    if (i < buffer_length) {
      napi_value undefined =
          v8impl::JsValueFromV8LocalValue(v8::Undefined(_cbinfo.GetIsolate()));
      for (; i < buffer_length; i += 1) {
        buffer[i] = undefined;
      }
    }
  }

  /*virtual*/
  void SetReturnValue(napi_value value) override {
    v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
    _cbinfo.GetReturnValue().Set(val);
  }
};

class GetterCallbackWrapper
    : public CallbackWrapperBase<v8::PropertyCallbackInfo<v8::Value>,
                                 &CallbackBundle::function_or_getter> {
 public:
  static void Invoke(v8::Local<v8::Name> property,
                     const v8::PropertyCallbackInfo<v8::Value>& info) {
    GetterCallbackWrapper cbwrapper(info);
    cbwrapper.InvokeCallback();
  }

  explicit GetterCallbackWrapper(
      const v8::PropertyCallbackInfo<v8::Value>& cbinfo)
      : CallbackWrapperBase(cbinfo, 0) {}

  /*virtual*/
  void Args(napi_value* buffer, size_t buffer_length) override {
    if (buffer_length > 0) {
      napi_value undefined =
          v8impl::JsValueFromV8LocalValue(v8::Undefined(_cbinfo.GetIsolate()));
      for (size_t i = 0; i < buffer_length; i += 1) {
        buffer[i] = undefined;
      }
    }
  }

  /*virtual*/
  void SetReturnValue(napi_value value) override {
    v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
    _cbinfo.GetReturnValue().Set(val);
  }
};

class SetterCallbackWrapper
    : public CallbackWrapperBase<v8::PropertyCallbackInfo<void>,
                                 &CallbackBundle::setter> {
 public:
  static void Invoke(v8::Local<v8::Name> property, v8::Local<v8::Value> value,
                     const v8::PropertyCallbackInfo<void>& info) {
    SetterCallbackWrapper cbwrapper(info, value);
    cbwrapper.InvokeCallback();
  }

  SetterCallbackWrapper(const v8::PropertyCallbackInfo<void>& cbinfo,
                        const v8::Local<v8::Value>& value)
      : CallbackWrapperBase(cbinfo, 1), _value(value) {}

  /*virtual*/
  void Args(napi_value* buffer, size_t buffer_length) override {
    if (buffer_length > 0) {
      buffer[0] = v8impl::JsValueFromV8LocalValue(_value);

      if (buffer_length > 1) {
        napi_value undefined = v8impl::JsValueFromV8LocalValue(
            v8::Undefined(_cbinfo.GetIsolate()));
        for (size_t i = 1; i < buffer_length; i += 1) {
          buffer[i] = undefined;
        }
      }
    }
  }

  /*virtual*/
  void SetReturnValue(napi_value value) override {
    // Ignore any value returned from a setter callback.
  }

 private:
  const v8::Local<v8::Value>& _value;
};

static void DeleteCallbackBundle(napi_env env, void* data, void* hint) {
  CallbackBundle* bundle = static_cast<CallbackBundle*>(data);
  delete bundle;
}

// Creates an object to be made available to the static function callback
// wrapper, used to retrieve the native callback function and data pointer.
static v8::Local<v8::Value> CreateFunctionCallbackData(napi_env env,
                                                       napi_callback cb,
                                                       void* data) {
  CallbackBundle* bundle = new CallbackBundle();
  bundle->function_or_getter = cb;
  bundle->cb_data = data;
  bundle->env = env;
  v8::Local<v8::Value> cbdata = v8::External::New(env->ctx->isolate, bundle);
  Reference::New(env, cbdata, 0, true, DeleteCallbackBundle, bundle, nullptr);

  return cbdata;
}

enum WrapType { retrievable, anonymous };

template <WrapType wrap_type>
inline napi_status Wrap(napi_env env, napi_value js_object, void* native_object,
                        napi_finalize finalize_cb, void* finalize_hint,
                        napi_ref* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  v8::Local<v8::Value> value = v8impl::V8LocalValueFromJsValue(js_object);
  RETURN_STATUS_IF_FALSE(env, value->IsObject(), napi_invalid_arg);
  v8::Local<v8::Object> obj = value.As<v8::Object>();

  if (wrap_type == retrievable) {
    // If we've already wrapped this object, we error out.
    RETURN_STATUS_IF_FALSE(env, obj->GetInternalField(0)->IsUndefined(),
                           napi_invalid_arg);
  } else if (wrap_type == anonymous) {
    // If no finalize callback is provided, we error out.
    CHECK_ARG(env, finalize_cb);
  }

  v8impl::Reference* reference = nullptr;
  if (result != nullptr) {
    // The returned reference should be deleted via napi_delete_reference()
    // ONLY in response to the finalize callback invocation. (If it is deleted
    // before then, then the finalize callback will never be invoked.)
    // Therefore a finalize callback is required when returning a reference.
    CHECK_ARG(env, finalize_cb);
    reference = v8impl::Reference::New(env, obj, 0, false, finalize_cb,
                                       native_object, finalize_hint);
    *result = reinterpret_cast<napi_ref>(reference);
  } else {
    // Create a self-deleting reference.
    reference = v8impl::Reference::New(
        env, obj, 0, true, finalize_cb, native_object,
        finalize_cb == nullptr ? nullptr : finalize_hint);
  }

  if (wrap_type == retrievable) {
    obj->SetInternalField(0, v8::External::New(env->ctx->isolate, reference));
  }

  return napi_clear_last_error(env);
}

}  // end of anonymous namespace

}  // end of namespace v8impl

napi_status napi_define_properties(napi_env env, napi_value object,
                                   size_t property_count,
                                   const napi_property_descriptor* properties) {
  NAPI_PREAMBLE(env);
  if (property_count > 0) {
    CHECK_ARG(env, properties);
  }

  v8::Local<v8::Context> context = env->ctx->context();

  v8::Local<v8::Object> obj;
  CHECK_TO_OBJECT(env, context, obj, object);

  for (size_t i = 0; i < property_count; i++) {
    const napi_property_descriptor* p = &properties[i];

    v8::Local<v8::Name> property_name;
    napi_status status =
        v8impl::V8NameFromPropertyDescriptor(env, p, &property_name);

    if (status != napi_ok) {
      return napi_set_last_error(env, status);
    }

    if (p->getter != nullptr || p->setter != nullptr) {
      v8::Local<v8::Value> local_getter;
      v8::Local<v8::Value> local_setter;

      if (p->getter != nullptr) {
        v8::Local<v8::Value> getter_data =
            v8impl::CreateFunctionCallbackData(env, p->getter, p->data);
        CHECK_MAYBE_EMPTY(env, getter_data, napi_generic_failure);

        v8::MaybeLocal<v8::Function> maybe_getter = v8::Function::New(
            context, v8impl::FunctionCallbackWrapper::Invoke, getter_data);
        CHECK_MAYBE_EMPTY(env, maybe_getter, napi_generic_failure);

        local_getter = maybe_getter.ToLocalChecked();
      }
      if (p->setter != nullptr) {
        v8::Local<v8::Value> setter_data =
            v8impl::CreateFunctionCallbackData(env, p->setter, p->data);
        CHECK_MAYBE_EMPTY(env, setter_data, napi_generic_failure);

        v8::MaybeLocal<v8::Function> maybe_setter = v8::Function::New(
            context, v8impl::FunctionCallbackWrapper::Invoke, setter_data);
        CHECK_MAYBE_EMPTY(env, maybe_setter, napi_generic_failure);
        local_setter = maybe_setter.ToLocalChecked();
      }

      v8::PropertyDescriptor descriptor(local_getter, local_setter);
      descriptor.set_enumerable((p->attributes & napi_enumerable) != 0);
      descriptor.set_configurable((p->attributes & napi_configurable) != 0);

      auto define_maybe =
          obj->DefineProperty(context, property_name, descriptor);

      if (!define_maybe.FromMaybe(false)) {
        return napi_set_last_error(env, napi_invalid_arg);
      }
    } else if (p->method != nullptr) {
      v8::Local<v8::Value> cbdata =
          v8impl::CreateFunctionCallbackData(env, p->method, p->data);

      CHECK_MAYBE_EMPTY(env, cbdata, napi_generic_failure);

      v8::MaybeLocal<v8::Function> maybe_fn = v8::Function::New(
          context, v8impl::FunctionCallbackWrapper::Invoke, cbdata);

      CHECK_MAYBE_EMPTY(env, maybe_fn, napi_generic_failure);

      v8::PropertyDescriptor descriptor(maybe_fn.ToLocalChecked(),
                                        (p->attributes & napi_writable) != 0);
      descriptor.set_enumerable((p->attributes & napi_enumerable) != 0);
      descriptor.set_configurable((p->attributes & napi_configurable) != 0);

      auto define_maybe =
          obj->DefineProperty(context, property_name, descriptor);

      if (!define_maybe.FromMaybe(false)) {
        return napi_set_last_error(env, napi_generic_failure);
      }
    } else {
      v8::Local<v8::Value> value = v8impl::V8LocalValueFromJsValue(p->value);

      v8::PropertyDescriptor descriptor(value,
                                        (p->attributes & napi_writable) != 0);
      descriptor.set_enumerable((p->attributes & napi_enumerable) != 0);
      descriptor.set_configurable((p->attributes & napi_configurable) != 0);

      auto define_maybe =
          obj->DefineProperty(context, property_name, descriptor);

      if (!define_maybe.FromMaybe(false)) {
        return napi_set_last_error(env, napi_invalid_arg);
      }
    }
  }

  return GET_RETURN_STATUS(env);
}

napi_status napi_create_function(napi_env env, const char* utf8name,
                                 size_t length, napi_callback cb,
                                 void* callback_data, napi_value* result) {
  NAPI_PREAMBLE(env);

  v8::Isolate* isolate = env->ctx->isolate;
  v8::Local<v8::Function> return_value;
  v8::EscapableHandleScope scope(isolate);
  v8::Local<v8::Value> cbdata =
      v8impl::CreateFunctionCallbackData(env, cb, callback_data);

  RETURN_STATUS_IF_FALSE(env, !cbdata.IsEmpty(), napi_generic_failure);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::MaybeLocal<v8::Function> maybe_function = v8::Function::New(
      context, v8impl::FunctionCallbackWrapper::Invoke, cbdata);
  CHECK_MAYBE_EMPTY(env, maybe_function, napi_generic_failure);

  return_value = scope.Escape(maybe_function.ToLocalChecked());

  if (utf8name != nullptr) {
    v8::Local<v8::String> name_string;
    CHECK_NEW_FROM_UTF8_LEN(env, name_string, utf8name, length);
    return_value->SetName(name_string);
  }

  *result = v8impl::JsValueFromV8LocalValue(return_value);

  return GET_RETURN_STATUS(env);
}

namespace v8impl {
// DO NOT use napi_class__ type alias
// Xcode will link its destructor to napi_class__ in JSC implementation
// What a strange bug!
struct Clazz {
  explicit Clazz(v8::Isolate* isolate,
                 v8::Local<v8::FunctionTemplate> function_template,
                 v8::Local<v8::Function> function)
      : function_template_persistent(isolate, function_template),
        function_persistent(isolate, function) {}

  v8impl::Persistent<v8::FunctionTemplate> function_template_persistent;
  v8impl::Persistent<v8::Function> function_persistent;
};
}  // namespace v8impl

napi_status napi_define_class(napi_env env, const char* utf8name, size_t length,
                              napi_callback constructor, void* callback_data,
                              size_t property_count,
                              const napi_property_descriptor* properties,
                              napi_class super_class, napi_class* result) {
  NAPI_PREAMBLE(env);

  v8::Isolate* isolate = env->ctx->isolate;

  v8::HandleScope scope(isolate);
  v8::Local<v8::Value> cbdata =
      v8impl::CreateFunctionCallbackData(env, constructor, callback_data);

  RETURN_STATUS_IF_FALSE(env, !cbdata.IsEmpty(), napi_generic_failure);

  v8::Local<v8::FunctionTemplate> tpl = v8::FunctionTemplate::New(
      isolate, v8impl::FunctionCallbackWrapper::Invoke, cbdata);

  if (super_class != nullptr) {
    tpl->Inherit(reinterpret_cast<v8impl::Clazz*>(super_class)
                     ->function_template_persistent.Get(isolate));
  }

  tpl->InstanceTemplate()->SetInternalFieldCount(1);

  v8::Local<v8::String> name_string;
  CHECK_NEW_FROM_UTF8_LEN(env, name_string, utf8name, length);
  tpl->SetClassName(name_string);

  size_t static_property_count = 0;
  for (size_t i = 0; i < property_count; i++) {
    const napi_property_descriptor* p = properties + i;

    if ((p->attributes & napi_static) != 0) {
      // Static properties are handled separately below.
      static_property_count++;
      continue;
    }

    v8::Local<v8::Name> property_name;
    napi_status status =
        v8impl::V8NameFromPropertyDescriptor(env, p, &property_name);

    if (status != napi_ok) {
      return napi_set_last_error(env, status);
    }

    v8::PropertyAttribute attributes =
        v8impl::V8PropertyAttributesFromDescriptor(p);

    // This code is similar to that in napi_define_properties(); the
    // difference is it applies to a template instead of an object,
    // and preferred PropertyAttribute for lack of PropertyDescriptor
    // support on ObjectTemplate.
    if (p->getter != nullptr || p->setter != nullptr) {
      v8::Local<v8::FunctionTemplate> getter_tpl;
      v8::Local<v8::FunctionTemplate> setter_tpl;
      if (p->getter != nullptr) {
        v8::Local<v8::Value> getter_data =
            v8impl::CreateFunctionCallbackData(env, p->getter, p->data);

        getter_tpl = v8::FunctionTemplate::New(
            isolate, v8impl::FunctionCallbackWrapper::Invoke, getter_data);
      }
      if (p->setter != nullptr) {
        v8::Local<v8::Value> setter_data =
            v8impl::CreateFunctionCallbackData(env, p->setter, p->data);

        setter_tpl = v8::FunctionTemplate::New(
            isolate, v8impl::FunctionCallbackWrapper::Invoke, setter_data);
      }

      tpl->PrototypeTemplate()->SetAccessorProperty(property_name, getter_tpl,
                                                    setter_tpl, attributes,
                                                    v8::AccessControl::DEFAULT);
    } else if (p->method != nullptr) {
      v8::Local<v8::Value> cbdata =
          v8impl::CreateFunctionCallbackData(env, p->method, p->data);

      RETURN_STATUS_IF_FALSE(env, !cbdata.IsEmpty(), napi_generic_failure);

      v8::Local<v8::FunctionTemplate> t = v8::FunctionTemplate::New(
          isolate, v8impl::FunctionCallbackWrapper::Invoke, cbdata,
          v8::Signature::New(isolate, tpl));

      tpl->PrototypeTemplate()->Set(property_name, t, attributes);
    } else {
      v8::Local<v8::Value> value = v8impl::V8LocalValueFromJsValue(p->value);
      tpl->PrototypeTemplate()->Set(property_name, value, attributes);
    }
  }

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Function> function = tpl->GetFunction(context).ToLocalChecked();

  if (super_class != nullptr) {
    CHECK_MAYBE_NOTHING(
        env,
        function->SetPrototype(context,
                               reinterpret_cast<v8impl::Clazz*>(super_class)
                                   ->function_persistent.Get(isolate)),
        napi_generic_failure);
  }

  *result =
      reinterpret_cast<napi_class>(new v8impl::Clazz(isolate, tpl, function));

  if (static_property_count > 0) {
    napi_value value = v8impl::JsValueFromV8LocalValue(function);
    std::vector<napi_property_descriptor> static_descriptors;
    static_descriptors.reserve(static_property_count);

    for (size_t i = 0; i < property_count; i++) {
      const napi_property_descriptor* p = properties + i;
      if ((p->attributes & napi_static) != 0) {
        static_descriptors.push_back(*p);
      }
    }

    napi_status status = napi_define_properties(
        env, value, static_descriptors.size(), static_descriptors.data());
    if (status != napi_ok) return status;
  }

  return GET_RETURN_STATUS(env);
}

napi_status napi_release_class(napi_env env, napi_class clazz) {
  delete reinterpret_cast<v8impl::Clazz*>(clazz);
  return napi_ok;
}

napi_status napi_class_get_function(napi_env env, napi_class clazz,
                                    napi_value* result) {
  *result = v8impl::JsValueFromV8LocalValue(
      reinterpret_cast<v8impl::Clazz*>(clazz)->function_persistent.Get(
          env->ctx->isolate));
  return napi_ok;
}

napi_status napi_get_property_names(napi_env env, napi_value object,
                                    napi_value* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Object> obj;
  CHECK_TO_OBJECT(env, context, obj, object);

  v8::MaybeLocal<v8::Array> maybe_propertynames = obj->GetPropertyNames(
      context, v8::KeyCollectionMode::kIncludePrototypes,
      static_cast<v8::PropertyFilter>(v8::PropertyFilter::ONLY_ENUMERABLE |
                                      v8::PropertyFilter::SKIP_SYMBOLS),
      v8::IndexFilter::kIncludeIndices,
      v8::KeyConversionMode::kConvertToString);

  CHECK_MAYBE_EMPTY(env, maybe_propertynames, napi_generic_failure);

  *result =
      v8impl::JsValueFromV8LocalValue(maybe_propertynames.ToLocalChecked());
  return GET_RETURN_STATUS(env);
}

napi_status napi_set_property(napi_env env, napi_value object, napi_value key,
                              napi_value value) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);

  v8::Local<v8::Value> k = v8impl::V8LocalValueFromJsValue(key);
  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);

  v8::Maybe<bool> set_maybe = obj->Set(context, k, val);

  RETURN_STATUS_IF_FALSE(env, set_maybe.FromMaybe(false), napi_generic_failure);
  return GET_RETURN_STATUS(env);
}

napi_status napi_has_property(napi_env env, napi_value object, napi_value key,
                              bool* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);

  v8::Local<v8::Value> k = v8impl::V8LocalValueFromJsValue(key);
  v8::Maybe<bool> has_maybe = obj->Has(context, k);

  CHECK_MAYBE_NOTHING(env, has_maybe, napi_generic_failure);

  *result = has_maybe.FromMaybe(false);
  return GET_RETURN_STATUS(env);
}

napi_status napi_get_property(napi_env env, napi_value object, napi_value key,
                              napi_value* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Value> k = v8impl::V8LocalValueFromJsValue(key);
  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);

  auto get_maybe = obj->Get(context, k);

  CHECK_MAYBE_EMPTY(env, get_maybe, napi_generic_failure);

  v8::Local<v8::Value> val = get_maybe.ToLocalChecked();
  *result = v8impl::JsValueFromV8LocalValue(val);
  return GET_RETURN_STATUS(env);
}

napi_status napi_delete_property(napi_env env, napi_value object,
                                 napi_value key, bool* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Value> k = v8impl::V8LocalValueFromJsValue(key);
  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);
  v8::Maybe<bool> delete_maybe = obj->Delete(context, k);
  CHECK_MAYBE_NOTHING(env, delete_maybe, napi_generic_failure);

  if (result != nullptr) *result = delete_maybe.FromMaybe(false);

  return GET_RETURN_STATUS(env);
}

napi_status napi_has_own_property(napi_env env, napi_value object,
                                  napi_value key, bool* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);
  v8::Local<v8::Value> k = v8impl::V8LocalValueFromJsValue(key);
  RETURN_STATUS_IF_FALSE(env, k->IsName(), napi_name_expected);
  v8::Maybe<bool> has_maybe = obj->HasOwnProperty(context, k.As<v8::Name>());
  CHECK_MAYBE_NOTHING(env, has_maybe, napi_generic_failure);
  *result = has_maybe.FromMaybe(false);

  return GET_RETURN_STATUS(env);
}

napi_status napi_set_named_property(napi_env env, napi_value object,
                                    const char* utf8name, napi_value value) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);

  v8::Local<v8::Name> key;
  CHECK_NEW_FROM_UTF8(env, key, utf8name);

  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);

  v8::Maybe<bool> set_maybe = obj->Set(context, key, val);

  RETURN_STATUS_IF_FALSE(env, set_maybe.FromMaybe(false), napi_generic_failure);
  return GET_RETURN_STATUS(env);
}

napi_status napi_has_named_property(napi_env env, napi_value object,
                                    const char* utf8name, bool* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);

  v8::Local<v8::Name> key;
  CHECK_NEW_FROM_UTF8(env, key, utf8name);

  v8::Maybe<bool> has_maybe = obj->Has(context, key);

  CHECK_MAYBE_NOTHING(env, has_maybe, napi_generic_failure);

  *result = has_maybe.FromMaybe(false);
  return GET_RETURN_STATUS(env);
}

napi_status napi_get_named_property(napi_env env, napi_value object,
                                    const char* utf8name, napi_value* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();

  v8::Local<v8::Name> key;
  CHECK_NEW_FROM_UTF8(env, key, utf8name);

  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);

  auto get_maybe = obj->Get(context, key);

  CHECK_MAYBE_EMPTY(env, get_maybe, napi_generic_failure);

  v8::Local<v8::Value> val = get_maybe.ToLocalChecked();
  *result = v8impl::JsValueFromV8LocalValue(val);
  return GET_RETURN_STATUS(env);
}

napi_status napi_set_element(napi_env env, napi_value object, uint32_t index,
                             napi_value value) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);

  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
  auto set_maybe = obj->Set(context, index, val);

  RETURN_STATUS_IF_FALSE(env, set_maybe.FromMaybe(false), napi_generic_failure);

  return GET_RETURN_STATUS(env);
}

napi_status napi_has_element(napi_env env, napi_value object, uint32_t index,
                             bool* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);

  v8::Maybe<bool> has_maybe = obj->Has(context, index);

  CHECK_MAYBE_NOTHING(env, has_maybe, napi_generic_failure);

  *result = has_maybe.FromMaybe(false);
  return GET_RETURN_STATUS(env);
}

napi_status napi_get_element(napi_env env, napi_value object, uint32_t index,
                             napi_value* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);

  auto get_maybe = obj->Get(context, index);

  CHECK_MAYBE_EMPTY(env, get_maybe, napi_generic_failure);

  *result = v8impl::JsValueFromV8LocalValue(get_maybe.ToLocalChecked());
  return GET_RETURN_STATUS(env);
}

napi_status napi_delete_element(napi_env env, napi_value object, uint32_t index,
                                bool* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Object> obj;

  CHECK_TO_OBJECT(env, context, obj, object);
  v8::Maybe<bool> delete_maybe = obj->Delete(context, index);
  CHECK_MAYBE_NOTHING(env, delete_maybe, napi_generic_failure);

  if (result != nullptr) *result = delete_maybe.FromMaybe(false);

  return GET_RETURN_STATUS(env);
}

napi_status napi_is_array(napi_env env, napi_value value, bool* result) {
  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);

  *result = val->IsArray();
  return napi_clear_last_error(env);
}

napi_status napi_get_array_length(napi_env env, napi_value value,
                                  uint32_t* result) {
  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
  RETURN_STATUS_IF_FALSE(env, val->IsArray(), napi_array_expected);

  v8::Local<v8::Array> arr = val.As<v8::Array>();
  *result = arr->Length();

  return napi_clear_last_error(env);
}

napi_status napi_equals(napi_env env, napi_value lhs, napi_value rhs,
                        bool* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();

  v8::Local<v8::Value> a = v8impl::V8LocalValueFromJsValue(lhs);
  v8::Local<v8::Value> b = v8impl::V8LocalValueFromJsValue(rhs);

  v8::Maybe<bool> maybe_result = a->Equals(context, b);

  napi_status status = napi_generic_failure;
  CHECK_MAYBE_NOTHING_WITH_PREAMBLE(env, maybe_result, status);

  if (result != nullptr) {
    *result = maybe_result.FromJust();
  }

  return GET_RETURN_STATUS(env);
}

napi_status napi_strict_equals(napi_env env, napi_value lhs, napi_value rhs,
                               bool* result) {
  v8::Local<v8::Value> a = v8impl::V8LocalValueFromJsValue(lhs);
  v8::Local<v8::Value> b = v8impl::V8LocalValueFromJsValue(rhs);

  *result = a->StrictEquals(b);
  return napi_clear_last_error(env);
}

napi_status napi_get_prototype(napi_env env, napi_value object,
                               napi_value* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Context> context = env->ctx->context();

  v8::Local<v8::Object> obj;
  CHECK_TO_OBJECT(env, context, obj, object);

  v8::Local<v8::Value> val = obj->GetPrototype();
  *result = v8impl::JsValueFromV8LocalValue(val);
  return GET_RETURN_STATUS(env);
}

napi_status napi_create_object(napi_env env, napi_value* result) {
  *result = v8impl::JsValueFromV8LocalValue(v8::Object::New(env->ctx->isolate));

  return napi_clear_last_error(env);
}

napi_status napi_create_array(napi_env env, napi_value* result) {
  *result = v8impl::JsValueFromV8LocalValue(v8::Array::New(env->ctx->isolate));

  return napi_clear_last_error(env);
}

napi_status napi_create_array_with_length(napi_env env, size_t length,
                                          napi_value* result) {
  *result = v8impl::JsValueFromV8LocalValue(
      v8::Array::New(env->ctx->isolate, length));

  return napi_clear_last_error(env);
}

napi_status napi_create_string_latin1(napi_env env, const char* str,
                                      size_t length, napi_value* result) {
  RETURN_STATUS_IF_FALSE(env, (length == NAPI_AUTO_LENGTH) || length <= INT_MAX,
                         napi_invalid_arg);

  auto isolate = env->ctx->isolate;
  auto str_maybe =
      v8::String::NewFromOneByte(isolate, reinterpret_cast<const uint8_t*>(str),
                                 v8::NewStringType::kNormal, length);
  CHECK_MAYBE_EMPTY(env, str_maybe, napi_generic_failure);

  *result = v8impl::JsValueFromV8LocalValue(str_maybe.ToLocalChecked());
  return napi_clear_last_error(env);
}

napi_status napi_create_string_utf8(napi_env env, const char* str,
                                    size_t length, napi_value* result) {
  RETURN_STATUS_IF_FALSE(env, (length == NAPI_AUTO_LENGTH) || length <= INT_MAX,
                         napi_invalid_arg);

  auto isolate = env->ctx->isolate;
  auto str_maybe = v8::String::NewFromUtf8(
      isolate, str, v8::NewStringType::kNormal, static_cast<int>(length));
  CHECK_MAYBE_EMPTY(env, str_maybe, napi_generic_failure);
  *result = v8impl::JsValueFromV8LocalValue(str_maybe.ToLocalChecked());
  return napi_clear_last_error(env);
}

napi_status napi_create_string_utf16(napi_env env, const char16_t* str,
                                     size_t length, napi_value* result) {
  RETURN_STATUS_IF_FALSE(env, (length == NAPI_AUTO_LENGTH) || length <= INT_MAX,
                         napi_invalid_arg);

  auto isolate = env->ctx->isolate;
  auto str_maybe = v8::String::NewFromTwoByte(
      isolate, reinterpret_cast<const uint16_t*>(str),
      v8::NewStringType::kNormal, length);
  CHECK_MAYBE_EMPTY(env, str_maybe, napi_generic_failure);

  *result = v8impl::JsValueFromV8LocalValue(str_maybe.ToLocalChecked());
  return napi_clear_last_error(env);
}

napi_status napi_create_double(napi_env env, double value, napi_value* result) {
  *result = v8impl::JsValueFromV8LocalValue(
      v8::Number::New(env->ctx->isolate, value));

  return napi_clear_last_error(env);
}

napi_status napi_create_int32(napi_env env, int32_t value, napi_value* result) {
  *result = v8impl::JsValueFromV8LocalValue(
      v8::Integer::New(env->ctx->isolate, value));

  return napi_clear_last_error(env);
}

napi_status napi_create_uint32(napi_env env, uint32_t value,
                               napi_value* result) {
  *result = v8impl::JsValueFromV8LocalValue(
      v8::Integer::NewFromUnsigned(env->ctx->isolate, value));

  return napi_clear_last_error(env);
}

napi_status napi_create_int64(napi_env env, int64_t value, napi_value* result) {
  *result = v8impl::JsValueFromV8LocalValue(
      v8::Number::New(env->ctx->isolate, static_cast<double>(value)));

  return napi_clear_last_error(env);
}

napi_status napi_get_boolean(napi_env env, bool value, napi_value* result) {
  v8::Isolate* isolate = env->ctx->isolate;

  if (value) {
    *result = v8impl::JsValueFromV8LocalValue(v8::True(isolate));
  } else {
    *result = v8impl::JsValueFromV8LocalValue(v8::False(isolate));
  }

  return napi_clear_last_error(env);
}

napi_status napi_create_symbol(napi_env env, napi_value description,
                               napi_value* result) {
  v8::Isolate* isolate = env->ctx->isolate;

  if (description == nullptr) {
    *result = v8impl::JsValueFromV8LocalValue(v8::Symbol::New(isolate));
  } else {
    v8::Local<v8::Value> desc = v8impl::V8LocalValueFromJsValue(description);
    RETURN_STATUS_IF_FALSE(env, desc->IsString(), napi_string_expected);

    *result = v8impl::JsValueFromV8LocalValue(
        v8::Symbol::New(isolate, desc.As<v8::String>()));
  }

  return napi_clear_last_error(env);
}

static inline napi_status set_error_code(napi_env env,
                                         v8::Local<v8::Value> error,
                                         napi_value code,
                                         const char* code_cstring) {
  if ((code != nullptr) || (code_cstring != nullptr)) {
    v8::Local<v8::Context> context = env->ctx->context();
    v8::Local<v8::Object> err_object = error.As<v8::Object>();

    v8::Local<v8::Value> code_value = v8impl::V8LocalValueFromJsValue(code);
    if (code != nullptr) {
      code_value = v8impl::V8LocalValueFromJsValue(code);
      RETURN_STATUS_IF_FALSE(env, code_value->IsString(), napi_string_expected);
    } else {
      CHECK_NEW_FROM_UTF8(env, code_value, code_cstring);
    }

    v8::Local<v8::Name> code_key;
    CHECK_NEW_FROM_UTF8(env, code_key, "code");

    v8::Maybe<bool> set_maybe = err_object->Set(context, code_key, code_value);
    RETURN_STATUS_IF_FALSE(env, set_maybe.FromMaybe(false),
                           napi_generic_failure);
  }
  return napi_ok;
}

napi_status napi_create_error(napi_env env, napi_value code, napi_value msg,
                              napi_value* result) {
  v8::Local<v8::Value> message_value = v8impl::V8LocalValueFromJsValue(msg);
  RETURN_STATUS_IF_FALSE(env, message_value->IsString(), napi_string_expected);

  v8::Local<v8::Value> error_obj =
      v8::Exception::Error(message_value.As<v8::String>());
  napi_status status = set_error_code(env, error_obj, code, nullptr);
  if (status != napi_ok) return status;

  *result = v8impl::JsValueFromV8LocalValue(error_obj);

  return napi_clear_last_error(env);
}

napi_status napi_create_type_error(napi_env env, napi_value code,
                                   napi_value msg, napi_value* result) {
  v8::Local<v8::Value> message_value = v8impl::V8LocalValueFromJsValue(msg);
  RETURN_STATUS_IF_FALSE(env, message_value->IsString(), napi_string_expected);

  v8::Local<v8::Value> error_obj =
      v8::Exception::TypeError(message_value.As<v8::String>());
  napi_status status = set_error_code(env, error_obj, code, nullptr);
  if (status != napi_ok) return status;

  *result = v8impl::JsValueFromV8LocalValue(error_obj);

  return napi_clear_last_error(env);
}

napi_status napi_create_range_error(napi_env env, napi_value code,
                                    napi_value msg, napi_value* result) {
  v8::Local<v8::Value> message_value = v8impl::V8LocalValueFromJsValue(msg);
  RETURN_STATUS_IF_FALSE(env, message_value->IsString(), napi_string_expected);

  v8::Local<v8::Value> error_obj =
      v8::Exception::RangeError(message_value.As<v8::String>());
  napi_status status = set_error_code(env, error_obj, code, nullptr);
  if (status != napi_ok) return status;

  *result = v8impl::JsValueFromV8LocalValue(error_obj);

  return napi_clear_last_error(env);
}

napi_status napi_typeof(napi_env env, napi_value value,
                        napi_valuetype* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  v8::Local<v8::Value> v = v8impl::V8LocalValueFromJsValue(value);

  if (v->IsNumber()) {
    *result = napi_number;
  } else if (v->IsBigInt()) {
    *result = napi_bigint;
  } else if (v->IsString()) {
    *result = napi_string;
  } else if (v->IsFunction()) {
    // This test has to come before IsObject because IsFunction
    // implies IsObject
    *result = napi_function;
  } else if (v->IsExternal()) {
    // This test has to come before IsObject because IsExternal
    // implies IsObject
    *result = napi_external;
  } else if (v->IsObject()) {
    *result = napi_object;
  } else if (v->IsBoolean()) {
    *result = napi_boolean;
  } else if (v->IsUndefined()) {
    *result = napi_undefined;
  } else if (v->IsSymbol()) {
    *result = napi_symbol;
  } else if (v->IsNull()) {
    *result = napi_null;
  } else {
    // Should not get here unless V8 has added some new kind of value.
    return napi_set_last_error(env, napi_invalid_arg);
  }

  return napi_clear_last_error(env);
}

napi_status napi_get_undefined(napi_env env, napi_value* result) {
  *result = v8impl::JsValueFromV8LocalValue(v8::Undefined(env->ctx->isolate));

  return napi_clear_last_error(env);
}

napi_status napi_get_null(napi_env env, napi_value* result) {
  *result = v8impl::JsValueFromV8LocalValue(v8::Null(env->ctx->isolate));

  return napi_clear_last_error(env);
}

// Gets all callback info in a single call. (Ugly, but faster.)
napi_status napi_get_cb_info(
    napi_env env,               // [in] NAPI environment handle
    napi_callback_info cbinfo,  // [in] Opaque callback-info handle
    size_t* argc,      // [in-out] Specifies the size of the provided argv array
                       // and receives the actual count of args.
    napi_value* argv,  // [out] Array of values
    napi_value* this_arg,  // [out] Receives the JS 'this' arg for the call
    void** data) {         // [out] Receives the data pointer for the callback.

  v8impl::CallbackWrapper* info =
      reinterpret_cast<v8impl::CallbackWrapper*>(cbinfo);

  if (argv != nullptr) {
    info->Args(argv, *argc);
  }
  if (argc != nullptr) {
    *argc = info->ArgsLength();
  }
  if (this_arg != nullptr) {
    *this_arg = info->This();
  }
  if (data != nullptr) {
    *data = info->Data();
  }

  return napi_clear_last_error(env);
}

napi_status napi_get_new_target(napi_env env, napi_callback_info cbinfo,
                                napi_value* result) {
  v8impl::CallbackWrapper* info =
      reinterpret_cast<v8impl::CallbackWrapper*>(cbinfo);

  *result = info->GetNewTarget();
  return napi_clear_last_error(env);
}

napi_status napi_call_function(napi_env env, napi_value recv, napi_value func,
                               size_t argc, const napi_value* argv,
                               napi_value* result) {
  NAPI_PREAMBLE(env);
  if (argc > 0) {
    CHECK_ARG(env, argv);
  }

  v8::Local<v8::Context> context = env->ctx->context();

  v8::Local<v8::Value> v8recv = v8impl::V8LocalValueFromJsValue(recv);

  v8::Local<v8::Function> v8func;
  CHECK_TO_FUNCTION(env, v8func, func);

  auto maybe = v8func->Call(
      context, v8recv, argc,
      reinterpret_cast<v8::Local<v8::Value>*>(const_cast<napi_value*>(argv)));

  if (try_catch.HasCaught()) {
    return napi_set_last_error(env, napi_pending_exception);
  } else {
    if (result != nullptr) {
      CHECK_MAYBE_EMPTY(env, maybe, napi_generic_failure);
      *result = v8impl::JsValueFromV8LocalValue(maybe.ToLocalChecked());
    }
    return napi_clear_last_error(env);
  }
}

napi_status napi_get_global(napi_env env, napi_value* result) {
  *result = v8impl::JsValueFromV8LocalValue(env->ctx->context()->Global());

  return napi_clear_last_error(env);
}

napi_status napi_throw_(napi_env env, napi_value error) {
  NAPI_PREAMBLE(env);

  v8::Isolate* isolate = env->ctx->isolate;

  isolate->ThrowException(v8impl::V8LocalValueFromJsValue(error));
  // any VM calls after this point and before returning
  // to the javascript invoker will fail
  return napi_clear_last_error(env);
}

napi_status napi_throw_error(napi_env env, const char* code, const char* msg) {
  NAPI_PREAMBLE(env);

  v8::Isolate* isolate = env->ctx->isolate;
  v8::Local<v8::String> str;
  CHECK_NEW_FROM_UTF8(env, str, msg);

  v8::Local<v8::Value> error_obj = v8::Exception::Error(str);
  napi_status status = set_error_code(env, error_obj, nullptr, code);
  if (status != napi_ok) return status;

  isolate->ThrowException(error_obj);
  // any VM calls after this point and before returning
  // to the javascript invoker will fail
  return napi_clear_last_error(env);
}

napi_status napi_throw_type_error(napi_env env, const char* code,
                                  const char* msg) {
  NAPI_PREAMBLE(env);

  v8::Isolate* isolate = env->ctx->isolate;
  v8::Local<v8::String> str;
  CHECK_NEW_FROM_UTF8(env, str, msg);

  v8::Local<v8::Value> error_obj = v8::Exception::TypeError(str);
  napi_status status = set_error_code(env, error_obj, nullptr, code);
  if (status != napi_ok) return status;

  isolate->ThrowException(error_obj);
  // any VM calls after this point and before returning
  // to the javascript invoker will fail
  return napi_clear_last_error(env);
}

napi_status napi_throw_range_error(napi_env env, const char* code,
                                   const char* msg) {
  NAPI_PREAMBLE(env);

  v8::Isolate* isolate = env->ctx->isolate;
  v8::Local<v8::String> str;
  CHECK_NEW_FROM_UTF8(env, str, msg);

  v8::Local<v8::Value> error_obj = v8::Exception::RangeError(str);
  napi_status status = set_error_code(env, error_obj, nullptr, code);
  if (status != napi_ok) return status;

  isolate->ThrowException(error_obj);
  // any VM calls after this point and before returning
  // to the javascript invoker will fail
  return napi_clear_last_error(env);
}

napi_status napi_is_error(napi_env env, napi_value value, bool* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot
  // throw JS exceptions.

  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
  *result = val->IsNativeError();

  return napi_clear_last_error(env);
}

napi_status napi_get_value_double(napi_env env, napi_value value,
                                  double* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  auto val =
      v8impl::V8LocalValueFromJsValue(value)->NumberValue(env->ctx->context());
  RETURN_STATUS_IF_FALSE(env, val.IsJust(), napi_number_expected);

  *result = val.ToChecked();

  return napi_clear_last_error(env);
}

napi_status napi_get_value_int32(napi_env env, napi_value value,
                                 int32_t* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  auto val =
      v8impl::V8LocalValueFromJsValue(value)->Int32Value(env->ctx->context());

  RETURN_STATUS_IF_FALSE(env, val.IsJust(), napi_number_expected);

  *result = val.ToChecked();

  return napi_clear_last_error(env);
}

napi_status napi_get_value_uint32(napi_env env, napi_value value,
                                  uint32_t* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  auto val =
      v8impl::V8LocalValueFromJsValue(value)->Uint32Value(env->ctx->context());

  RETURN_STATUS_IF_FALSE(env, val.IsJust(), napi_number_expected);

  *result = val.ToChecked();

  return napi_ok;
}

napi_status napi_get_value_int64(napi_env env, napi_value value,
                                 int64_t* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  auto val =
      v8impl::V8LocalValueFromJsValue(value)->IntegerValue(env->ctx->context());

  RETURN_STATUS_IF_FALSE(env, val.IsJust(), napi_number_expected);

  *result = val.ToChecked();

  return napi_clear_last_error(env);
}

napi_status napi_get_value_bool(napi_env env, napi_value value, bool* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  *result =
      v8impl::V8LocalValueFromJsValue(value)->BooleanValue(env->ctx->isolate);

  return napi_clear_last_error(env);
}

// Copies a JavaScript string into a LATIN-1 string buffer. The result is the
// number of bytes (excluding the null terminator) copied into buf.
// A sufficient buffer size should be greater than the length of string,
// reserving space for null terminator.
// If bufsize is insufficient, the string will be truncated and null terminated.
// If buf is NULL, this method returns the length of the string (in bytes)
// via the result parameter.
// The result argument is optional unless buf is NULL.
napi_status napi_get_value_string_latin1(napi_env env, napi_value value,
                                         char* buf, size_t bufsize,
                                         size_t* result) {
  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
  RETURN_STATUS_IF_FALSE(env, val->IsString(), napi_string_expected);

  if (!buf) {
    CHECK_ARG(env, result);
    *result = val.As<v8::String>()->Length();
  } else if (bufsize != 0) {
    int copied = val.As<v8::String>()->WriteOneByte(
        env->ctx->isolate, reinterpret_cast<uint8_t*>(buf), 0, bufsize - 1,
        v8::String::NO_NULL_TERMINATION);

    buf[copied] = '\0';
    if (result != nullptr) {
      *result = copied;
    }
  } else if (result != nullptr) {
    *result = 0;
  }

  return napi_clear_last_error(env);
}

// Copies a JavaScript string into a UTF-8 string buffer. The result is the
// number of bytes (excluding the null terminator) copied into buf.
// A sufficient buffer size should be greater than the length of string,
// reserving space for null terminator.
// If bufsize is insufficient, the string will be truncated and null terminated.
// If buf is NULL, this method returns the length of the string (in bytes)
// via the result parameter.
// The result argument is optional unless buf is NULL.
napi_status napi_get_value_string_utf8(napi_env env, napi_value value,
                                       char* buf, size_t bufsize,
                                       size_t* result) {
  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
  RETURN_STATUS_IF_FALSE(env, val->IsString(), napi_string_expected);

  if (!buf) {
    CHECK_ARG(env, result);
    *result = val.As<v8::String>()->Utf8Length(env->ctx->isolate);
  } else if (bufsize != 0) {
    int copied = val.As<v8::String>()->WriteUtf8(
        env->ctx->isolate, buf, bufsize - 1, nullptr,
        v8::String::REPLACE_INVALID_UTF8 | v8::String::NO_NULL_TERMINATION);

    buf[copied] = '\0';
    if (result != nullptr) {
      *result = copied;
    }
  } else if (result != nullptr) {
    *result = 0;
  }

  return napi_clear_last_error(env);
}

// Copies a JavaScript string into a UTF-16 string buffer. The result is the
// number of 2-byte code units (excluding the null terminator) copied into buf.
// A sufficient buffer size should be greater than the length of string,
// reserving space for null terminator.
// If bufsize is insufficient, the string will be truncated and null terminated.
// If buf is NULL, this method returns the length of the string (in 2-byte
// code units) via the result parameter.
// The result argument is optional unless buf is NULL.
napi_status napi_get_value_string_utf16(napi_env env, napi_value value,
                                        char16_t* buf, size_t bufsize,
                                        size_t* result) {
  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
  RETURN_STATUS_IF_FALSE(env, val->IsString(), napi_string_expected);

  if (!buf) {
    CHECK_ARG(env, result);
    // V8 assumes UTF-16 length is the same as the number of characters.
    *result = val.As<v8::String>()->Length();
  } else if (bufsize != 0) {
    int copied = val.As<v8::String>()->Write(
        env->ctx->isolate, reinterpret_cast<uint16_t*>(buf), 0, bufsize - 1,
        v8::String::NO_NULL_TERMINATION);

    buf[copied] = '\0';
    if (result != nullptr) {
      *result = copied;
    }
  } else if (result != nullptr) {
    *result = 0;
  }

  return napi_clear_last_error(env);
}

napi_status napi_coerce_to_bool(napi_env env, napi_value value,
                                napi_value* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.
  v8::Isolate* isolate = env->ctx->isolate;
  v8::Local<v8::Boolean> b =
      v8impl::V8LocalValueFromJsValue(value)->ToBoolean(isolate);
  *result = v8impl::JsValueFromV8LocalValue(b);
  return napi_clear_last_error(env);
}

#define GEN_COERCE_FUNCTION(UpperCaseName, MixedCaseName, LowerCaseName)     \
  napi_status napi_coerce_to_##LowerCaseName(napi_env env, napi_value value, \
                                             napi_value* result) {           \
    NAPI_PREAMBLE(env);                                                      \
                                                                             \
    v8::Local<v8::Context> context = env->ctx->context();                    \
    v8::Local<v8::MixedCaseName> str;                                        \
                                                                             \
    CHECK_TO_##UpperCaseName(env, context, str, value);                      \
                                                                             \
    *result = v8impl::JsValueFromV8LocalValue(str);                          \
    return GET_RETURN_STATUS(env);                                           \
  }

GEN_COERCE_FUNCTION(NUMBER, Number, number)
GEN_COERCE_FUNCTION(OBJECT, Object, object)
GEN_COERCE_FUNCTION(STRING, String, string)

#undef GEN_COERCE_FUNCTION

napi_status napi_wrap(napi_env env, napi_value js_object, void* native_object,
                      napi_finalize finalize_cb, void* finalize_hint,
                      napi_ref* result) {
  return v8impl::Wrap<v8impl::retrievable>(env, js_object, native_object,
                                           finalize_cb, finalize_hint, result);
}

napi_status napi_unwrap(napi_env env, napi_value obj, void** result) {
  return v8impl::Unwrap(env, obj, result, v8impl::KeepWrap);
}

napi_status napi_remove_wrap(napi_env env, napi_value obj, void** result) {
  return v8impl::Unwrap(env, obj, result, v8impl::RemoveWrap);
}

napi_status napi_create_external(napi_env env, void* data,
                                 napi_finalize finalize_cb, void* finalize_hint,
                                 napi_value* result) {
  v8::Isolate* isolate = env->ctx->isolate;

  v8::Local<v8::Value> external_value = v8::External::New(isolate, data);

  // The Reference object will delete itself after invoking the finalizer
  // callback.
  v8impl::Reference::New(env, external_value, 0, true, finalize_cb, data,
                         finalize_hint);

  *result = v8impl::JsValueFromV8LocalValue(external_value);

  return napi_clear_last_error(env);
}

napi_status napi_get_value_external(napi_env env, napi_value value,
                                    void** result) {
  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
  RETURN_STATUS_IF_FALSE(env, val->IsExternal(), napi_invalid_arg);

  v8::Local<v8::External> external_value = val.As<v8::External>();
  *result = external_value->Value();

  return napi_clear_last_error(env);
}

// Set initial_refcount to 0 for a weak reference, >0 for a strong reference.
napi_status napi_create_reference(napi_env env, napi_value value,
                                  uint32_t initial_refcount, napi_ref* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  v8::Local<v8::Value> v8_value = v8impl::V8LocalValueFromJsValue(value);

  if (!(v8_value->IsObject() || v8_value->IsFunction())) {
    return napi_set_last_error(env, napi_object_expected);
  }

  v8impl::Reference* reference =
      v8impl::Reference::New(env, v8_value, initial_refcount, false);

  *result = reinterpret_cast<napi_ref>(reference);
  return napi_clear_last_error(env);
}

// Deletes a reference. The referenced value is released, and may be GC'd unless
// there are other references to it.
napi_status napi_delete_reference(napi_env env, napi_ref ref) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  v8impl::Reference::Delete(reinterpret_cast<v8impl::Reference*>(ref));

  return napi_clear_last_error(env);
}

// Increments the reference count, optionally returning the resulting count.
// After this call the reference will be a strong reference because its
// refcount is >0, and the referenced object is effectively "pinned".
// Calling this when the refcount is 0 and the object is unavailable
// results in an error.
napi_status napi_reference_ref(napi_env env, napi_ref ref, uint32_t* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  v8impl::Reference* reference = reinterpret_cast<v8impl::Reference*>(ref);
  uint32_t count = reference->Ref();

  if (result != nullptr) {
    *result = count;
  }

  return napi_clear_last_error(env);
}

// Decrements the reference count, optionally returning the resulting count. If
// the result is 0 the reference is now weak and the object may be GC'd at any
// time if there are no other references. Calling this when the refcount is
// already 0 results in an error.
napi_status napi_reference_unref(napi_env env, napi_ref ref, uint32_t* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  v8impl::Reference* reference = reinterpret_cast<v8impl::Reference*>(ref);

  if (reference->RefCount() == 0) {
    return napi_set_last_error(env, napi_generic_failure);
  }

  uint32_t count = reference->Unref();

  if (result != nullptr) {
    *result = count;
  }

  return napi_clear_last_error(env);
}

// Attempts to get a referenced value. If the reference is weak, the value might
// no longer be available, in that case the call is still successful but the
// result is NULL.
napi_status napi_get_reference_value(napi_env env, napi_ref ref,
                                     napi_value* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  v8impl::Reference* reference = reinterpret_cast<v8impl::Reference*>(ref);
  *result = v8impl::JsValueFromV8LocalValue(reference->Get());

  return napi_clear_last_error(env);
}

napi_status napi_open_context_scope(napi_env env, napi_context_scope* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  *result = v8impl::JsContextScopeFromV8ContextScope(
      new v8impl::ContextScopeWrapper(env->ctx->context()));
  env->ctx->open_context_scopes++;
  return napi_clear_last_error(env);
}

napi_status napi_close_context_scope(napi_env env, napi_context_scope scope) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  if (env->ctx->open_context_scopes == 0) {
    return napi_context_scope_mismatch;
  }

  env->ctx->open_context_scopes--;
  delete v8impl::V8ContextScopeFromJsContextScope(scope);
  return napi_clear_last_error(env);
}

napi_status napi_open_handle_scope(napi_env env, napi_handle_scope* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  *result = v8impl::JsHandleScopeFromV8HandleScope(
      new v8impl::HandleScopeWrapper(env->ctx->isolate));
  env->ctx->open_handle_scopes++;
  return napi_clear_last_error(env);
}

napi_status napi_close_handle_scope(napi_env env, napi_handle_scope scope) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  if (env->ctx->open_handle_scopes == 0) {
    return napi_handle_scope_mismatch;
  }

  env->ctx->open_handle_scopes--;
  delete v8impl::V8HandleScopeFromJsHandleScope(scope);
  return napi_clear_last_error(env);
}

napi_status napi_open_escapable_handle_scope(
    napi_env env, napi_escapable_handle_scope* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  *result = v8impl::JsEscapableHandleScopeFromV8EscapableHandleScope(
      new v8impl::EscapableHandleScopeWrapper(env->ctx->isolate));
  env->ctx->open_handle_scopes++;
  return napi_clear_last_error(env);
}

napi_status napi_close_escapable_handle_scope(
    napi_env env, napi_escapable_handle_scope scope) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  if (env->ctx->open_handle_scopes == 0) {
    return napi_handle_scope_mismatch;
  }

  delete v8impl::V8EscapableHandleScopeFromJsEscapableHandleScope(scope);
  env->ctx->open_handle_scopes--;
  return napi_clear_last_error(env);
}

napi_status napi_escape_handle(napi_env env, napi_escapable_handle_scope scope,
                               napi_value escapee, napi_value* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.

  v8impl::EscapableHandleScopeWrapper* s =
      v8impl::V8EscapableHandleScopeFromJsEscapableHandleScope(scope);
  if (!s->escape_called()) {
    *result = v8impl::JsValueFromV8LocalValue(
        s->Escape(v8impl::V8LocalValueFromJsValue(escapee)));
    return napi_clear_last_error(env);
  }
  return napi_set_last_error(env, napi_escape_called_twice);
}

napi_status napi_new_instance(napi_env env, napi_value constructor, size_t argc,
                              const napi_value* argv, napi_value* result) {
  NAPI_PREAMBLE(env);
  if (argc > 0) {
    CHECK_ARG(env, argv);
  }

  v8::Local<v8::Context> context = env->ctx->context();

  v8::Local<v8::Function> ctor;
  CHECK_TO_FUNCTION(env, ctor, constructor);

  auto maybe = ctor->NewInstance(
      context, argc,
      reinterpret_cast<v8::Local<v8::Value>*>(const_cast<napi_value*>(argv)));

  CHECK_MAYBE_EMPTY(env, maybe, napi_generic_failure);

  *result = v8impl::JsValueFromV8LocalValue(maybe.ToLocalChecked());
  return GET_RETURN_STATUS(env);
}

napi_status napi_instanceof(napi_env env, napi_value object,
                            napi_value constructor, bool* result) {
  NAPI_PREAMBLE(env);

  *result = false;

  v8::Local<v8::Object> ctor;
  v8::Local<v8::Context> context = env->ctx->context();

  CHECK_TO_OBJECT(env, context, ctor, constructor);

  if (!ctor->IsFunction()) {
    napi_throw_type_error(env, "ERR_NAPI_CONS_FUNCTION",
                          "Constructor must be a function");

    return napi_set_last_error(env, napi_function_expected);
  }

  napi_status status = napi_generic_failure;

  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(object);
  auto maybe_result = val->InstanceOf(context, ctor);
  CHECK_MAYBE_NOTHING(env, maybe_result, status);
  *result = maybe_result.FromJust();
  return GET_RETURN_STATUS(env);
}

// Methods to support catching exceptions
napi_status napi_is_exception_pending(napi_env env, bool* result) {
  // NAPI_PREAMBLE is not used here: this function must execute when there is a
  // pending exception.

  *result = !env->ctx->last_exception.IsEmpty();
  return napi_clear_last_error(env);
}

napi_status napi_get_and_clear_last_exception(napi_env env,
                                              napi_value* result) {
  // NAPI_PREAMBLE is not used here: this function must execute when there is a
  // pending exception.

  if (env->ctx->last_exception.IsEmpty()) {
    return napi_get_undefined(env, result);
  } else {
    *result = v8impl::JsValueFromV8LocalValue(
        v8::Local<v8::Value>::New(env->ctx->isolate, env->ctx->last_exception));
    env->ctx->last_exception.Reset();
  }

  return napi_clear_last_error(env);
}

// TODO support v8 unhandled_rejection_exception
napi_status napi_get_unhandled_rejection_exception(napi_env env,
                                                   napi_value* result) {
  return napi_clear_last_error(env);
}

napi_status napi_get_own_property_descriptor(napi_env env, napi_value obj,
                                             napi_value prop,
                                             napi_value* result) {
  NAPI_PREAMBLE(env);
  v8::Local<v8::Context> context = env->ctx->context();
  v8::Local<v8::Object> v8_obj;
  CHECK_TO_OBJECT(env, context, v8_obj, obj);
  v8::Local<v8::Value> v8_prop = v8impl::V8LocalValueFromJsValue(prop);
  RETURN_STATUS_IF_FALSE(env, v8_prop->IsName(), napi_name_expected);
  v8::MaybeLocal<v8::Value> maybe_descriptor =
      v8_obj->GetOwnPropertyDescriptor(context, v8_prop.As<v8::Name>());
  CHECK_MAYBE_EMPTY(env, maybe_descriptor, napi_generic_failure);
  v8::Local<v8::Value> local_descriptor = maybe_descriptor.ToLocalChecked();
  *result = v8impl::JsValueFromV8LocalValue(local_descriptor);
  return GET_RETURN_STATUS(env);
}

napi_status napi_is_arraybuffer(napi_env env, napi_value value, bool* result) {
  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
  *result = val->IsArrayBuffer();

  return napi_clear_last_error(env);
}

napi_status napi_is_typedarray(napi_env env, napi_value value, bool* result) {
  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
  *result = val->IsTypedArray();

  return napi_clear_last_error(env);
}

napi_status napi_create_typedarray(napi_env env, napi_typedarray_type type,
                                   size_t length, napi_value arraybuffer,
                                   size_t byte_offset, napi_value* result) {
  v8::Local<v8::Value> value = v8impl::V8LocalValueFromJsValue(arraybuffer);
  RETURN_STATUS_IF_FALSE(env, value->IsArrayBuffer(), napi_invalid_arg);

  v8::Local<v8::ArrayBuffer> buffer = value.As<v8::ArrayBuffer>();
  v8::Local<v8::TypedArray> typedArray;

  switch (type) {
    case napi_int8_array:
      CREATE_TYPED_ARRAY(env, Int8Array, 1, buffer, byte_offset, length,
                         typedArray);
      break;
    case napi_uint8_array:
      CREATE_TYPED_ARRAY(env, Uint8Array, 1, buffer, byte_offset, length,
                         typedArray);
      break;
    case napi_uint8_clamped_array:
      CREATE_TYPED_ARRAY(env, Uint8ClampedArray, 1, buffer, byte_offset, length,
                         typedArray);
      break;
    case napi_int16_array:
      CREATE_TYPED_ARRAY(env, Int16Array, 2, buffer, byte_offset, length,
                         typedArray);
      break;
    case napi_uint16_array:
      CREATE_TYPED_ARRAY(env, Uint16Array, 2, buffer, byte_offset, length,
                         typedArray);
      break;
    case napi_int32_array:
      CREATE_TYPED_ARRAY(env, Int32Array, 4, buffer, byte_offset, length,
                         typedArray);
      break;
    case napi_uint32_array:
      CREATE_TYPED_ARRAY(env, Uint32Array, 4, buffer, byte_offset, length,
                         typedArray);
      break;
    case napi_float32_array:
      CREATE_TYPED_ARRAY(env, Float32Array, 4, buffer, byte_offset, length,
                         typedArray);
      break;
    case napi_float64_array:
      CREATE_TYPED_ARRAY(env, Float64Array, 8, buffer, byte_offset, length,
                         typedArray);
      break;
    case napi_bigint64_array:
      CREATE_TYPED_ARRAY(env, BigInt64Array, 8, buffer, byte_offset, length,
                         typedArray);
      break;
    case napi_biguint64_array:
      CREATE_TYPED_ARRAY(env, BigUint64Array, 8, buffer, byte_offset, length,
                         typedArray);
      break;
    default:
      return napi_set_last_error(env, napi_invalid_arg);
  }

  *result = v8impl::JsValueFromV8LocalValue(typedArray);
  return napi_clear_last_error(env);
}

napi_status napi_is_typedarray_of(napi_env env, napi_value typedarray,
                                  napi_typedarray_type type, bool* result) {
  v8::Local<v8::Value> value = v8impl::V8LocalValueFromJsValue(typedarray);

  switch (type) {
    case napi_int8_array:
      *result = value->IsInt8Array();
      break;
    case napi_uint8_array:
      *result = value->IsUint8Array();
      break;
    case napi_uint8_clamped_array:
      *result = value->IsUint8ClampedArray();
      break;
    case napi_int16_array:
      *result = value->IsInt16Array();
      break;
    case napi_uint16_array:
      *result = value->IsUint16Array();
      break;
    case napi_int32_array:
      *result = value->IsInt32Array();
      break;
    case napi_uint32_array:
      *result = value->IsUint32Array();
      break;
    case napi_float32_array:
      *result = value->IsFloat32Array();
      break;
    case napi_float64_array:
      *result = value->IsFloat64Array();
      break;
    case napi_bigint64_array:
      *result = value->IsBigInt64Array();
      break;
    case napi_biguint64_array:
      *result = value->IsBigUint64Array();
      break;
  }

  return napi_clear_last_error(env);
}

napi_status napi_create_dataview(napi_env env, size_t byte_length,
                                 napi_value arraybuffer, size_t byte_offset,
                                 napi_value* result) {
  NAPI_PREAMBLE(env);

  v8::Local<v8::Value> value = v8impl::V8LocalValueFromJsValue(arraybuffer);
  RETURN_STATUS_IF_FALSE(env, value->IsArrayBuffer(), napi_invalid_arg);

  v8::Local<v8::ArrayBuffer> buffer = value.As<v8::ArrayBuffer>();
  if (byte_length + byte_offset > buffer->ByteLength()) {
    napi_throw_range_error(env, "ERR_NAPI_INVALID_DATAVIEW_ARGS",
                           "byte_offset + byte_length should be less than or "
                           "equal to the size in bytes of the array passed in");
    return napi_set_last_error(env, napi_pending_exception);
  }
  v8::Local<v8::DataView> DataView =
      v8::DataView::New(buffer, byte_offset, byte_length);

  *result = v8impl::JsValueFromV8LocalValue(DataView);
  return GET_RETURN_STATUS(env);
}

napi_status napi_is_dataview(napi_env env, napi_value value, bool* result) {
  v8::Local<v8::Value> val = v8impl::V8LocalValueFromJsValue(value);
  *result = val->IsDataView();

  return napi_clear_last_error(env);
}

napi_status napi_create_promise(napi_env env, napi_deferred* deferred,
                                napi_value* promise) {
  auto maybe = v8::Promise::Resolver::New(env->ctx->context());
  CHECK_MAYBE_EMPTY(env, maybe, napi_generic_failure);

  auto v8_resolver = maybe.ToLocalChecked();
  auto v8_deferred = new v8impl::Persistent<v8::Value>();
  v8_deferred->Reset(env->ctx->isolate, v8_resolver);

  *deferred = v8impl::JsDeferredFromNodePersistent(v8_deferred);
  *promise = v8impl::JsValueFromV8LocalValue(v8_resolver->GetPromise());
  return napi_clear_last_error(env);
}

napi_status napi_release_deferred(napi_env env, napi_deferred deferred,
                                  napi_value resolution,
                                  napi_deferred_release_mode mode) {
  switch (mode) {
    case napi_deferred_resolve:
      return v8impl::ConcludeDeferred(env, deferred, resolution, true);
    case napi_deferred_reject:
      return v8impl::ConcludeDeferred(env, deferred, resolution, false);
    case napi_deferred_delete:
      delete v8impl::NodePersistentFromJsDeferred(deferred);
      return napi_clear_last_error(env);
  }
}

napi_status napi_is_promise(napi_env env, napi_value value, bool* is_promise) {
  *is_promise = v8impl::V8LocalValueFromJsValue(value)->IsPromise();

  return napi_clear_last_error(env);
}

#ifdef ENABLE_CODECACHE
#include <string>
namespace {
// this function should not be called on JS Thread
// because it may consume a lot of time
void create_codecache(napi_env env, v8::Persistent<v8::Script>* script,
                      v8::Isolate* isolate, std::string name) {
  v8::HandleScope scope(isolate);
  v8::Local<v8::Script> v8_script = script->Get(isolate);

  v8::ScriptCompiler::CachedData* dt =
      v8::ScriptCompiler::CreateCodeCache(v8_script->GetUnboundScript());
  env->napi_store_code_cache(env, name, dt->data, dt->length);
  delete dt;
}
}  // anonymous namespace

napi_status napi_run_code_cache(napi_env env, const uint8_t* data, int length,
                                napi_value* result) {
  NAPI_PREAMBLE(env);
  return GET_RETURN_STATUS(env);
}
napi_status napi_gen_code_cache(napi_env env, const char* script,
                                size_t script_len, const uint8_t** data,
                                int* length) {
  NAPI_PREAMBLE(env);
  return GET_RETURN_STATUS(env);
}
#endif  // ENABLE_CODECACHE

napi_status napi_add_finalizer(napi_env env, napi_value js_object,
                               void* native_object, napi_finalize finalize_cb,
                               void* finalize_hint, napi_ref* result) {
  return v8impl::Wrap<v8impl::anonymous>(env, js_object, native_object,
                                         finalize_cb, finalize_hint, result);
}

napi_status napi_adjust_external_memory(napi_env env, int64_t change_in_bytes,
                                        int64_t* adjusted_value) {
  *adjusted_value =
      env->ctx->isolate->AdjustAmountOfExternalAllocatedMemory(change_in_bytes);

  return napi_clear_last_error(env);
}

napi_status napi_set_instance_data(napi_env env, uint64_t key, void* data,
                                   napi_finalize finalize_cb,
                                   void* finalize_hint) {
  auto it = env->ctx->instance_data_registry.find(key);
  if (it != env->ctx->instance_data_registry.end()) {
    return napi_conflict_instance_data;
  }

  env->ctx->instance_data_registry[key] =
      v8impl::RefBase::New(env, 0, true, finalize_cb, data, finalize_hint);

  return napi_clear_last_error(env);
}

napi_status napi_get_instance_data(napi_env env, uint64_t key, void** data) {
  auto it = env->ctx->instance_data_registry.find(key);
  if (it == env->ctx->instance_data_registry.end()) {
    *data = nullptr;
  } else {
    v8impl::RefBase* idata = static_cast<v8impl::RefBase*>(it->second);

    *data = idata->Data();
  }

  return napi_clear_last_error(env);
}

v8::Local<v8::Value> napi_js_value_to_v8_value(napi_env env, napi_value value) {
  return v8impl::V8LocalValueFromJsValue(value);
}

napi_value napi_v8_value_to_js_value(napi_env env, v8::Local<v8::Value> value) {
  return v8impl::JsValueFromV8LocalValue(value);
}
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif
#endif  // NAPI_V8_EXPORT_SOURCE_ONLY_
#endif  // SRC_NAPI_V8_JS_NATIVE_API_V8_CC_H_
