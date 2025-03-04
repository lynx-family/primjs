/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "js_native_api_JavaScriptCore.h"

#include <algorithm>
#include <cassert>
#include <cmath>
#include <cstring>
#include <functional>
#include <mutex>
#include <string>
#include <vector>

#include "basic/log/logging.h"
#include "napi_env_jsc.h"

#define DECLARE_METHOD(API) \
  static std::remove_pointer<decltype(napi_env__::napi_##API)>::type napi_##API;

FOR_EACH_NAPI_ENGINE_CALL(DECLARE_METHOD)

#undef DECLARE_METHOD

struct napi_callback_info__jsc {
  napi_value newTarget;
  napi_value thisArg;
  napi_value* argv;
  void* data;
  uint16_t argc;
};

namespace {
class JSString {
 public:
  JSString(const JSString&) = delete;

  JSString(JSString&& other) {
    _string = other._string;
    other._string = nullptr;
  }

  explicit JSString(const char* string, size_t length = NAPI_AUTO_LENGTH)
      : _string{CreateUTF8(string, length)} {}

  explicit JSString(const JSChar* string, size_t length = NAPI_AUTO_LENGTH)
      : _string{JSStringCreateWithCharacters(
            string, length == NAPI_AUTO_LENGTH
                        ? std::char_traits<JSChar>::length(string)
                        : length)} {}

  ~JSString() {
    if (_string != nullptr) {
      JSStringRelease(_string);
    }
  }

  static JSString Attach(JSStringRef string) {
    return static_cast<JSString>(string);
  }

  operator JSStringRef() const { return _string; }

  size_t Length() const { return JSStringGetLength(_string); }

  size_t LengthUTF8() const {
    std::vector<char> buffer(JSStringGetMaximumUTF8CStringSize(_string));
    return JSStringGetUTF8CString(_string, buffer.data(), buffer.size()) - 1;
  }

  size_t LengthLatin1() const {
    // Latin1 has the same length as Unicode.
    return JSStringGetLength(_string);
  }

  void CopyTo(JSChar* buf, size_t bufsize, size_t* result) const {
    size_t length{JSStringGetLength(_string)};
    const JSChar* chars{JSStringGetCharactersPtr(_string)};
    size_t size{std::min(length, bufsize - 1)};
    std::copy(chars, chars + size, buf);
    buf[size] = '\0';
    if (result != nullptr) {
      *result = size;
    }
  }

  void CopyToUTF8(char* buf, size_t bufsize, size_t* result) const {
    size_t size{JSStringGetUTF8CString(_string, buf, bufsize)};
    if (result != nullptr) {
      // JSStringGetUTF8CString returns size with null terminator.
      *result = size - 1;
    }
  }

  void CopyToLatin1(char* buf, size_t bufsize, size_t* result) const {
    size_t length{JSStringGetLength(_string)};
    const JSChar* chars{JSStringGetCharactersPtr(_string)};
    size_t size{std::min(length, bufsize - 1)};
    for (size_t i = 0; i < size; ++i) {
      const JSChar ch{chars[i]};
      buf[i] = (ch < 256) ? ch : '?';
    }
    buf[size] = '\0';
    if (result != nullptr) {
      *result = size;
    }
  }

 private:
  static JSStringRef CreateUTF8(const char* string, size_t length) {
    if (length == NAPI_AUTO_LENGTH) {
      return JSStringCreateWithUTF8CString(string);
    }

    return JSStringCreateWithUTF8CString(std::string(string, length).c_str());
  }

  explicit JSString(JSStringRef string) : _string{string} {}

  JSStringRef _string;
};

JSValueRef ToJSValue(const napi_value value) {
  return reinterpret_cast<JSValueRef>(value);
}

const JSValueRef* ToJSValues(const napi_value* values) {
  return reinterpret_cast<const JSValueRef*>(values);
}

JSObjectRef ToJSObject(napi_value value) {
  return reinterpret_cast<JSObjectRef>(value);
}

JSObjectRef ToJSObject(JSValueRef value) {
  return const_cast<JSObjectRef>(value);
}

JSString ToJSString(napi_env env, napi_value value, JSValueRef* exception) {
  return JSString::Attach(
      JSValueToStringCopy(env->ctx->context, ToJSValue(value), exception));
}

JSPropertyAttributes ToJSCPropertyAttributes(
    napi_property_attributes napi_attributes) {
  JSPropertyAttributes attributes{kJSPropertyAttributeNone};
  if ((napi_attributes & napi_writable) == 0) {
    attributes |= kJSPropertyAttributeReadOnly;
  }
  if ((napi_attributes & napi_enumerable) == 0) {
    attributes |= kJSPropertyAttributeDontEnum;
  }
  if ((napi_attributes & napi_configurable) == 0) {
    attributes |= kJSPropertyAttributeDontDelete;
  }
  return attributes;
}

napi_value ToNapi(const JSValueRef value) {
  return reinterpret_cast<napi_value>(const_cast<OpaqueJSValue*>(value));
}

napi_value* ToNapi(const JSValueRef* values) {
  return reinterpret_cast<napi_value*>(const_cast<OpaqueJSValue**>(values));
}

napi_status napi_set_exception(napi_env env, JSValueRef exception) {
  env->ctx->last_exception = exception;
  return napi_set_last_error(env, napi_pending_exception);
}

napi_status napi_set_error_code(napi_env env, napi_value error, napi_value code,
                                const char* code_cstring) {
  napi_value code_value{code};
  if (code_value == nullptr) {
    code_value =
        ToNapi(JSValueMakeString(env->ctx->context, JSString(code_cstring)));
  } else {
    RETURN_STATUS_IF_FALSE(
        env, JSValueIsString(env->ctx->context, ToJSValue(code_value)),
        napi_string_expected);
  }

  CHECK_NAPI(napi_set_named_property(env, error, "code", code_value));
  return napi_clear_last_error(env);
}

}  // namespace

namespace jscimpl {
class Persistent;
class NativeInfo;

struct WeakInfo {
  std::list<Persistent*>::const_iterator weak_iter;
  std::function<void(void*)> cb;
  void* cb_arg;
};

class Persistent {
 public:
  Persistent() : _env(nullptr), _value(nullptr), _native_info(nullptr) {}

  Persistent(napi_env env, JSObjectRef value, NativeInfo* native_info)
      : _env(env), _value(value), _native_info(native_info) {
    JSValueProtect(env->ctx->context, value);
  }

  Persistent(const Persistent&) = delete;
  void operator=(const Persistent&) = delete;

  inline void Reset(napi_env env, JSObjectRef value, NativeInfo* native_info) {
    Reset();
    _env = env;
    _value = value;
    JSValueProtect(env->ctx->context, value);
    _native_info = native_info;
  }

  void Reset() {
    if (!_value) {
      return;
    }
    if (_weak_info) {
      ResetWeakInfo();
    } else {
      JSValueUnprotect(_env->ctx->context, _value);
    }

    _env = nullptr;
    _value = nullptr;
    _native_info = nullptr;
  }

  void SetWeak(void* data, std::function<void(void*)> cb);

  void ClearWeak();

  ~Persistent() { Reset(); }

  JSObjectRef Value() { return _value; }

  // called only in weak mode
  static void OnFinalize(Persistent* ref) {
    auto cb = ref->_weak_info->cb;
    auto cb_arg = ref->_weak_info->cb_arg;
    ref->Reset();
    cb(cb_arg);
  }

 private:
  void ResetWeakInfo();

  NativeInfo* _get_native_info();

  napi_env _env;
  JSObjectRef _value;
  NativeInfo* _native_info;
  std::unique_ptr<WeakInfo> _weak_info;
};

enum class NativeType { Constructor, External, Function, Wrapper };

class NativeInfo final {
 public:
  NativeInfo(napi_env env, NativeType type)
      : _env(env), _type(type), _data(nullptr) {}

  ~NativeInfo() {
    // ref will remove itself when finalize, so copy is needed
    for (Persistent* ref :
         std::vector<Persistent*>(std::begin(_weakRefs), std::end(_weakRefs))) {
      Persistent::OnFinalize(ref);
    }
  }

  std::list<Persistent*>::const_iterator AddWeakRef(Persistent* ref) {
    return _weakRefs.insert(_weakRefs.end(), ref);
  }

  void RemoveWeakRef(std::list<Persistent*>::const_iterator iter) {
    _weakRefs.erase(iter);
  }

  napi_env Env() const { return _env; }

  void Data(void* value) { _data = value; }

  void* Data() const { return _data; }

  NativeType Type() const { return _type; }

 private:
  const napi_env _env;
  const NativeType _type;
  void* _data;
  std::list<Persistent*> _weakRefs;
};

class RefBase : protected Finalizer, RefTracker {
 protected:
  RefBase(napi_env env, uint32_t initial_refcount, bool delete_self,
          napi_finalize finalize_callback, void* finalize_data,
          void* finalize_hint)
      : Finalizer(env, finalize_callback, finalize_data, finalize_hint),
        _refcount(initial_refcount),
        _delete_self(delete_self),
        _is_self_destroying(false) {
    Link(finalize_callback == nullptr ? &env->ctx->reflist
                                      : &env->ctx->finalizing_reflist);
  }

 public:
  static RefBase* New(napi_env env, uint32_t initial_refcount, bool delete_self,
                      napi_finalize finalize_callback, void* finalize_data,
                      void* finalize_hint) {
    auto ref_base_ptr =
        new RefBase(env, initial_refcount, delete_self, finalize_callback,
                    finalize_data, finalize_hint);
    return ref_base_ptr;
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
    if (is_env_teardown && RefCount() > 0) _refcount = 0;

    // There are cases where we want to avoid the reentrance of Finalize (
    // causing double-free):
    // * When a wrapped object holds its own strong reference (either directly
    //   or indirectly)
    // * (JSCore specific) when the destruction of a strong reference triggers
    //   garbage collection
    // If we are sure this is getting deleted soon, there is no need for the
    // finalizer to proceed.
    if (_is_self_destroying && !is_env_teardown) {
      return;
    }
    if (is_env_teardown) {
      _is_self_destroying = true;
    }

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
  bool _is_self_destroying;
};

class Reference : public RefBase {
 protected:
  template <typename... Args>
  Reference(napi_env env, JSObjectRef value, NativeInfo* native_info,
            Args&&... args)
      : RefBase(env, std::forward<Args>(args)...),
        _persistent(env, value, native_info) {
    if (RefCount() == 0) {
      _persistent.SetWeak(this, FinalizeCallback);
    }
  }

 public:
  static inline Reference* New(napi_env env, JSObjectRef value,
                               NativeInfo* native_info,
                               uint32_t initial_refcount, bool delete_self,
                               napi_finalize finalize_callback = nullptr,
                               void* finalize_data = nullptr,
                               void* finalize_hint = nullptr) {
    auto ref_ptr =
        new Reference(env, value, native_info, initial_refcount, delete_self,
                      finalize_callback, finalize_data, finalize_hint);
    return ref_ptr;
  }

  inline uint32_t Ref() {
    uint32_t refcount = RefBase::Ref();
    if (refcount == 1) {
      _persistent.ClearWeak();
    }
    return refcount;
  }

  inline uint32_t Unref() {
    uint32_t old_refcount = RefCount();
    uint32_t refcount = RefBase::Unref();
    if (old_refcount == 1 && refcount == 0) {
      _persistent.SetWeak(this, FinalizeCallback);
    }
    return refcount;
  }

  inline JSValueRef Get() { return _persistent.Value(); }

 private:
  static void FinalizeCallback(void* data) {
    Reference* r = static_cast<Reference*>(data);
    r->_persistent.Reset();
    r->Finalize();
  }

  Persistent _persistent;
};

namespace {
JSStringRef getNameString() {
  static JSStringRef name = JSStringCreateWithUTF8CString("name");
  return name;
}
}  // namespace

class Function {
 public:
  static napi_status Create(napi_env env, const char* utf8name, size_t length,
                            napi_callback cb, void* data, napi_value* result) {
    static std::once_flag once_flag;
    static JSClassRef functionClass{};

    std::call_once(once_flag, []() {
      JSClassDefinition functionClassDef = kJSClassDefinitionEmpty;
      functionClassDef.version = 0;
      functionClassDef.attributes = kJSClassAttributeNoAutomaticPrototype;
      functionClassDef.finalize = Finalize;
      functionClassDef.callAsFunction = CallAsFunction;
      functionClassDef.className = "Function";
      functionClass = JSClassCreate(&functionClassDef);
    });

    NativeInfo* info = new NativeInfo(env, NativeType::Function);
    Function* fun = new Function(env->ctx, cb, utf8name, data);
    info->Data(fun);

    JSObjectRef function{JSObjectMake(env->ctx->context, functionClass, info)};
    Initialize(env->ctx->context, function, info);
    Reference::New(
        env, function, info, 0, true,
        [](napi_env env, void* data, void* hint) {
          delete static_cast<Function*>(data);
          static_cast<NativeInfo*>(hint)->Data(nullptr);
        },
        fun, info);

    *result = ToNapi(function);
    return napi_ok;
  }

 private:
  Function(napi_context ctx, napi_callback cb, const char* name, void* cb_data)
      : _ctx(ctx), _cb{cb}, _cb_data{cb_data}, _name(name) {}

  static void Initialize(JSContextRef ctx, JSObjectRef object,
                         NativeInfo* info) {
    assert(info->Type() == NativeType::Function);
    Function* func_data = static_cast<Function*>(info->Data());
    assert(func_data);

    JSValueRef exc = nullptr;

    JSObjectSetProperty(
        ctx, object, getNameString(), JSValueMakeString(ctx, func_data->_name),
        kJSPropertyAttributeReadOnly | kJSPropertyAttributeDontEnum, &exc);
    if (exc) {
      // Silently fail to set name
      exc = nullptr;
    }

    // defaults set all Function.length to 0
    JSStringRef js_length = JSStringCreateWithUTF8CString("length");
    JSObjectSetProperty(
        ctx, object, js_length, JSValueMakeNumber(ctx, 0),
        kJSPropertyAttributeReadOnly | kJSPropertyAttributeDontEnum, &exc);
    if (exc) {
      // Silently fail to set length
      exc = nullptr;
    }
    JSStringRelease(js_length);

    if (func_data->_ctx->func_proto) {
      JSObjectSetPrototype(ctx, object, func_data->_ctx->func_proto);
    }
  }

  // JSObjectCallAsFunctionCallback
  static JSValueRef CallAsFunction(JSContextRef ctx, JSObjectRef function,
                                   JSObjectRef thisObject, size_t argumentCount,
                                   const JSValueRef arguments[],
                                   JSValueRef* exception) {
    NativeInfo* info{static_cast<NativeInfo*>(JSObjectGetPrivate(function))};
    assert(info->Type() == NativeType::Function);
    Function* func_data = static_cast<Function*>(info->Data());
    assert(func_data);

    napi_env env = info->Env();
    // Make sure any errors encountered last time we were in N-API are gone.
    napi_clear_last_error(env);

    napi_callback_info__jsc cbinfo{};
    cbinfo.thisArg = ToNapi(thisObject);
    cbinfo.newTarget = nullptr;
    cbinfo.argc = argumentCount;
    cbinfo.argv = ToNapi(arguments);
    cbinfo.data = func_data->_cb_data;

    napi_value result;
    env->ctx->CallIntoModule(
        [&](napi_env env) { result = func_data->_cb(env, &cbinfo); },
        [&](napi_env, JSValueRef exception_value) {
          *exception = exception_value;
        });

    return ToJSValue(result);
  }

  // JSObjectFinalizeCallback
  static void Finalize(JSObjectRef object) {
    NativeInfo* info{static_cast<NativeInfo*>(JSObjectGetPrivate(object))};
    JSObjectSetPrivate(object, nullptr);
    delete info;
  }

  napi_context _ctx;
  napi_callback _cb;
  void* _cb_data;
  JSString _name;
};

class External {
 public:
  static NativeInfo* Create(napi_env env, napi_value* result) {
    static std::once_flag once_flag;
    static JSClassRef externalClass{};  // never release

    std::call_once(once_flag, []() {
      JSClassDefinition externalClassDef = kJSClassDefinitionEmpty;
      externalClassDef.version = 0;
      externalClassDef.attributes = kJSClassAttributeNoAutomaticPrototype;
      externalClassDef.className = "External";
      externalClassDef.finalize = External::Finalize;

      externalClass = JSClassCreate(&externalClassDef);
    });

    NativeInfo* info{new NativeInfo(env, NativeType::External)};
    *result = ToNapi(JSObjectMake(env->ctx->context, externalClass, info));
    return info;
  }

 private:
  // JSObjectFinalizeCallback
  static void Finalize(JSObjectRef object) {
    NativeInfo* info{static_cast<NativeInfo*>(JSObjectGetPrivate(object))};
    JSObjectSetPrivate(object, nullptr);
    delete info;
  }
};

inline void Persistent::SetWeak(void* data, std::function<void(void*)> cb) {
  assert(_value);
  if (_weak_info) {
    _weak_info->cb_arg = data;
    _weak_info->cb = cb;
  } else {
    JSValueUnprotect(_env->ctx->context, _value);

    _weak_info.reset(
        new WeakInfo{_get_native_info()->AddWeakRef(this), cb, data});
  }
}

inline void Persistent::ClearWeak() {
  JSValueProtect(_env->ctx->context, _value);
  ResetWeakInfo();
}

inline void Persistent::ResetWeakInfo() {
  assert(_value);
  _get_native_info()->RemoveWeakRef(_weak_info->weak_iter);
  _weak_info.reset();
}

inline NativeInfo* Persistent::_get_native_info() {
  assert(_value);
  if (!_native_info) {
    static const JSStringRef magic = JSStringCreateWithUTF8CString("@#hmhm@#");

    JSValueRef exception = nullptr;

    JSValueRef finalizer =
        JSObjectGetProperty(_env->ctx->context, _value, magic, &exception);
    assert(exception == nullptr);

    if (JSValueIsUndefined(_env->ctx->context, finalizer)) {
      napi_value finalize_obj;
      _native_info = External::Create(_env, &finalize_obj);

      JSObjectSetProperty(
          _env->ctx->context, _value, magic, ToJSValue(finalize_obj),
          kJSPropertyAttributeReadOnly | kJSPropertyAttributeDontEnum |
              kJSPropertyAttributeDontDelete,
          &exception);
    } else {
      _native_info =
          static_cast<NativeInfo*>(JSObjectGetPrivate(ToJSObject(finalizer)));
    }

    assert(exception == nullptr);
  }
  return _native_info;
}

namespace {
JSStringRef getConstructorString() {
  static JSStringRef str = JSStringCreateWithUTF8CString("constructor");
  return str;
}

JSStringRef getPrototypeString() {
  static JSStringRef str = JSStringCreateWithUTF8CString("prototype");
  return str;
}
}  // namespace

class Wrapper {
 public:
  static JSObjectRef Create(napi_env env) {
    static std::once_flag once_flag;
    static JSClassRef wrapperClass{};  // never release

    std::call_once(once_flag, []() {
      JSClassDefinition wrapperClassDef = kJSClassDefinitionEmpty;
      wrapperClassDef.version = 0;
      wrapperClassDef.attributes = kJSClassAttributeNoAutomaticPrototype;
      wrapperClassDef.className = "Object";
      wrapperClassDef.finalize = Wrapper::Finalize;

      wrapperClass = JSClassCreate(&wrapperClassDef);
    });

    NativeInfo* info{new NativeInfo(env, NativeType::Wrapper)};
    return JSObjectMake(env->ctx->context, wrapperClass, info);
  }

 private:
  // JSObjectFinalizeCallback
  static void Finalize(JSObjectRef object) {
    NativeInfo* info{static_cast<NativeInfo*>(JSObjectGetPrivate(object))};
    JSObjectSetPrivate(object, nullptr);
    delete info;
  }
};

class Constructor {
 public:
  static napi_status Create(napi_env env, const char* utf8name, size_t length,
                            napi_callback cb, void* data,
                            napi_class super_class, napi_class* result) {
    static std::once_flag constructorClassOnceFlag;
    static JSClassRef constructorClass{};

    std::call_once(constructorClassOnceFlag, [] {
      JSClassDefinition constructorClassDef = kJSClassDefinitionEmpty;
      constructorClassDef.version = 0;
      constructorClassDef.attributes = kJSClassAttributeNoAutomaticPrototype;
      constructorClassDef.callAsFunction = CallAsFunction;
      constructorClassDef.callAsConstructor = CallAsConstructor;
      constructorClassDef.hasInstance = HasInstance;
      constructorClassDef.finalize = Finalize;

      constructorClass = JSClassCreate(&constructorClassDef);
    });

    JSObjectRef prototype{JSObjectMake(env->ctx->context, nullptr, nullptr)};
    if (super_class != nullptr) {
      JSObjectSetPrototype(env->ctx->context, prototype, super_class->_proto);
    }

    NativeInfo* info = new NativeInfo(env, NativeType::Constructor);
    Constructor* ctor_data =
        new Constructor(env, utf8name, length, cb, data, prototype);
    info->Data(ctor_data);

    // function A() {}
    JSObjectRef constructor{
        JSObjectMake(env->ctx->context, constructorClass, info)};

    // Since `ConstructorInfo` holds a `JSValueRef` without holding the
    // `JSGlobalContext`, it's unsafe to use `JSClassDefinition.finalize` to
    // trigger the destructor of `ConstructorInfo`, use napi finalizer instead
    Reference::New(
        env, constructor, info, 0, true,
        [](napi_env env, void* data, void* hint) {
          delete static_cast<Constructor*>(data);
          static_cast<NativeInfo*>(hint)->Data(nullptr);
        },
        ctor_data, info);

    // A.name = "A"
    // Function.prototype.name is not writable, so we need to set name field
    // before set prototype
    JSValueRef exception{};
    JSObjectSetProperty(env->ctx->context, constructor, getNameString(),
                        JSValueMakeString(env->ctx->context, ctor_data->_name),
                        kJSPropertyAttributeReadOnly |
                            kJSPropertyAttributeDontEnum |
                            kJSPropertyAttributeDontDelete,
                        &exception);
    if (exception) {
      // Silently fail to set name
      exception = nullptr;
    }

    if (super_class != nullptr) {
      JSObjectSetPrototype(env->ctx->context, constructor, super_class->_ctor);
    } else {
      if (env->ctx->func_proto) {
        JSObjectSetPrototype(env->ctx->context, constructor,
                             env->ctx->func_proto);
      }
    }

    // A.prototype = prototype
    JSObjectSetProperty(
        env->ctx->context, constructor, getPrototypeString(), prototype,
        kJSPropertyAttributeDontDelete | kJSPropertyAttributeDontEnum,
        &exception);
    CHECK_JSC(env, exception);

    // prototype.constructor = A
    JSObjectSetProperty(env->ctx->context, prototype, getConstructorString(),
                        constructor, kJSPropertyAttributeDontEnum, &exception);
    CHECK_JSC(env, exception);

    *result = new napi_class__jsc(env->ctx->context, prototype, constructor);
    return napi_ok;
  }

 private:
  Constructor(napi_env env, const char* name, size_t length, napi_callback cb,
              void* cb_data, JSObjectRef proto)
      : _ctx{env->ctx->context},
        _name{name, (length == NAPI_AUTO_LENGTH ? std::strlen(name) : length)},
        _cb{cb},
        _cb_data{cb_data},
        _proto(proto) {
    JSValueProtect(_ctx, _proto);
  }

  ~Constructor() { JSValueUnprotect(_ctx, _proto); }

  static JSValueRef CallAsFunction(JSContextRef ctx, JSObjectRef function,
                                   JSObjectRef thisObject, size_t argumentCount,
                                   const JSValueRef arguments[],
                                   JSValueRef* exception) {
    if (exception != nullptr) {
      static JSStringRef error_message =
          JSStringCreateWithUTF8CString("Must call constructor with new");

      JSValueRef err_string = JSValueMakeString(ctx, error_message);
      *exception = JSObjectMakeError(ctx, 1, &err_string, nullptr);
    }
    return nullptr;
  }

  // JSObjectCallAsConstructorCallback
  static JSObjectRef CallAsConstructor(JSContextRef ctx,
                                       JSObjectRef constructor,
                                       size_t argumentCount,
                                       const JSValueRef arguments[],
                                       JSValueRef* exception) {
    NativeInfo* info{static_cast<NativeInfo*>(JSObjectGetPrivate(constructor))};
    assert(info->Type() == NativeType::Constructor);
    Constructor* cons_data = static_cast<Constructor*>(info->Data());
    assert(cons_data);

    // Make sure any errors encountered last time we were in N-API are
    // gone.
    napi_env env = info->Env();
    napi_clear_last_error(env);

    JSObjectRef instance = Wrapper::Create(env);

    JSObjectSetPrototype(ctx, instance, cons_data->_proto);

    napi_callback_info__jsc cbinfo{};
    cbinfo.thisArg = ToNapi(instance);
    cbinfo.newTarget = ToNapi(constructor);
    cbinfo.argc = argumentCount;
    cbinfo.argv = ToNapi(arguments);
    cbinfo.data = cons_data->_cb_data;

    napi_value result;
    env->ctx->CallIntoModule(
        [&](napi_env env) { result = cons_data->_cb(env, &cbinfo); },
        [&](napi_env, JSValueRef exception_value) {
          *exception = exception_value;
        });

    return ToJSObject(result);
  }

  // JSObjectHasInstanceCallback
  static bool HasInstance(JSContextRef ctx, JSObjectRef constructor,
                          JSValueRef possibleInstance, JSValueRef* exception) {
    NativeInfo* info{static_cast<NativeInfo*>(JSObjectGetPrivate(constructor))};
    assert(info->Type() == NativeType::Constructor);
    Constructor* cons_data = static_cast<Constructor*>(info->Data());
    assert(cons_data);

    JSObjectRef constructor_prototype = cons_data->_proto;

    if (!JSValueIsObject(ctx, possibleInstance)) {
      return false;
    }

    JSObjectRef instance = JSValueToObject(ctx, possibleInstance, exception);
    if (*exception != nullptr || instance == nullptr) {
      return false;
    }

    JSValueRef proto_value = JSObjectGetPrototype(ctx, instance);
    while (!JSValueIsNull(ctx, proto_value)) {
      if (JSValueIsStrictEqual(ctx, constructor_prototype, proto_value)) {
        return true;
      }
      JSObjectRef proto = JSValueToObject(ctx, proto_value, exception);
      if (*exception != nullptr || proto == nullptr) {
        return false;
      }
      proto_value = JSObjectGetPrototype(ctx, proto);
    }

    return false;
  }

  // JSObjectFinalizeCallback
  static void Finalize(JSObjectRef object) {
    NativeInfo* info{static_cast<NativeInfo*>(JSObjectGetPrivate(object))};
    JSObjectSetPrivate(object, nullptr);
    delete info;
  }

 private:
  JSGlobalContextRef _ctx;
  JSString _name;
  napi_callback _cb;
  void* _cb_data;
  JSObjectRef _proto;
};

enum WrapType { retrievable, anonymous };

template <WrapType wrap_type>
inline napi_status Wrap(napi_env env, napi_value js_object, void* native_object,
                        napi_finalize finalize_cb, void* finalize_hint,
                        napi_ref* result) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.
  JSValueRef value = ToJSValue(js_object);
  //   RETURN_STATUS_IF_FALSE(env, JSValueIsObject(env->ctx->context, value),
  //                          napi_invalid_arg);
  JSObjectRef obj = ToJSObject(value);

  NativeInfo* info = static_cast<NativeInfo*>(JSObjectGetPrivate(obj));

  if (wrap_type == retrievable) {
    RETURN_STATUS_IF_FALSE(env,
                           info != nullptr &&
                               info->Type() == NativeType::Wrapper &&
                               info->Data() == nullptr,
                           napi_invalid_arg);
  } else {
    // If no finalize callback is provided, we error out.
    CHECK_ARG(env, finalize_cb);
  }

  Reference* reference = nullptr;
  if (result != nullptr) {
    // The returned reference should be deleted via napi_delete_reference()
    // ONLY in response to the finalize callback invocation. (If it is deleted
    // before then, then the finalize callback will never be invoked.)
    // Therefore a finalize callback is required when returning a reference.
    CHECK_ARG(env, finalize_cb);
    reference = Reference::New(env, obj, info, 0, false, finalize_cb,
                               native_object, finalize_hint);
    *result = reinterpret_cast<napi_ref>(reference);
  } else {
    // Create a self-deleting reference.
    reference =
        Reference::New(env, obj, info, 0, true, finalize_cb, native_object,
                       finalize_cb == nullptr ? nullptr : finalize_hint);
  }

  if (wrap_type == retrievable) {
    info->Data(reference);
  }

  return napi_clear_last_error(env);
}

enum UnwrapAction { KeepWrap, RemoveWrap };

inline static napi_status Unwrap(napi_env env, napi_value js_object,
                                 void** result, UnwrapAction action) {
  // Omit NAPI_PREAMBLE and GET_RETURN_STATUS because V8 calls here cannot throw
  // JS exceptions.
  if (action == KeepWrap) {
    CHECK_ARG(env, result);
  }

  // val->IsXXX check is expensive, omit them (though not safe)
  JSValueRef value = ToJSValue(js_object);
  //  RETURN_STATUS_IF_FALSE(env, JSValueIsObject(env->ctx->context, value),
  //  napi_invalid_arg);
  JSObjectRef obj = ToJSObject(value);

  NativeInfo* info = static_cast<NativeInfo*>(JSObjectGetPrivate(obj));

  if (info == nullptr || info->Type() != NativeType::Wrapper ||
      info->Data() == nullptr) {
    if (result) {
      *result = nullptr;
    }
    return napi_clear_last_error(env);
  }

  Reference* reference = static_cast<Reference*>(info->Data());

  if (result) {
    *result = reference->Data();
  }

  if (action == RemoveWrap) {
    info->Data(nullptr);
    Reference::Delete(reference);
  }

  return napi_clear_last_error(env);
}

}  // namespace jscimpl

napi_status napi_create_function(napi_env env, const char* utf8name,
                                 size_t length, napi_callback cb,
                                 void* callback_data, napi_value* result) {
  CHECK_NAPI(jscimpl::Function::Create(env, utf8name, length, cb, callback_data,
                                       result));
  return napi_clear_last_error(env);
}

napi_status napi_define_class(napi_env env, const char* utf8name, size_t length,
                              napi_callback cb, void* data,
                              size_t property_count,
                              const napi_property_descriptor* properties,
                              napi_class super_class, napi_class* result) {
  CHECK_NAPI(jscimpl::Constructor::Create(env, utf8name, length, cb, data,
                                          super_class, result));

  napi_value constructor = ToNapi((*result)->_ctor);

  int instancePropertyCount{0};
  int staticPropertyCount{0};
  for (size_t i = 0; i < property_count; i++) {
    if ((properties[i].attributes & napi_static) != 0) {
      staticPropertyCount++;
    } else {
      instancePropertyCount++;
    }
  }

  std::vector<napi_property_descriptor> staticDescriptors{};
  std::vector<napi_property_descriptor> instanceDescriptors{};
  staticDescriptors.reserve(staticPropertyCount);
  instanceDescriptors.reserve(instancePropertyCount);

  for (size_t i = 0; i < property_count; i++) {
    if ((properties[i].attributes & napi_static) != 0) {
      staticDescriptors.push_back(properties[i]);
    } else {
      instanceDescriptors.push_back(properties[i]);
    }
  }

  if (staticPropertyCount > 0) {
    CHECK_NAPI(napi_define_properties(
        env, constructor, staticDescriptors.size(), staticDescriptors.data()));
  }

  if (instancePropertyCount > 0) {
    napi_value prototype = ToNapi((*result)->_proto);

    CHECK_NAPI(napi_define_properties(env, prototype,
                                      instanceDescriptors.size(),
                                      instanceDescriptors.data()));
  }

  return napi_clear_last_error(env);
}

napi_status napi_release_class(napi_env env, napi_class clazz) {
  delete clazz;
  return napi_clear_last_error(env);
}

napi_status napi_class_get_function(napi_env env, napi_class clazz,
                                    napi_value* result) {
  *result = ToNapi(clazz->_ctor);
  return napi_clear_last_error(env);
}

napi_status napi_get_property_names(napi_env env, napi_value object,
                                    napi_value* result) {
  JSObjectRef obj = ToJSObject(object);

  JSPropertyNameArrayRef names =
      JSObjectCopyPropertyNames(env->ctx->context, obj);

  size_t len = JSPropertyNameArrayGetCount(names);

  napi_value array;
  CHECK_NAPI(napi_create_array_with_length(env, len, &array));

  JSValueRef exception = nullptr;
  for (size_t i = 0; i < len; i++) {
    // it seems that `str` is not owned by call side
    // do not call `JSStringRelease`
    JSStringRef str = JSPropertyNameArrayGetNameAtIndex(names, i);
    JSObjectSetPropertyAtIndex(
        env->ctx->context, ToJSObject(array), static_cast<unsigned>(i),
        JSValueMakeString(env->ctx->context, str), &exception);
    if (exception) {
      break;
    }
  }

  JSPropertyNameArrayRelease(names);

  CHECK_JSC(env, exception);

  *result = array;

  return napi_clear_last_error(env);
}

napi_status napi_set_property(napi_env env, napi_value object, napi_value key,
                              napi_value value) {
#ifndef _JSC_NO_FAST_KEY
  if (__builtin_available(macos 10.15, ios 13.0, *)) {
    JSValueRef exception{};

    JSObjectSetPropertyForKey(env->ctx->context, ToJSObject(object),
                              ToJSValue(key), ToJSValue(value),
                              kJSPropertyAttributeNone, &exception);
    CHECK_JSC(env, exception);
  } else
#endif
  {
    napi_value global{}, reflect{}, function{};
    CHECK_NAPI(napi_get_global(env, &global));
    CHECK_NAPI(napi_get_named_property(env, global, "Reflect", &reflect));
    CHECK_NAPI(napi_get_named_property(env, reflect, "set", &function));
    napi_value args[] = {object, key, value};
    CHECK_NAPI(napi_call_function(env, reflect, function, 3, args, nullptr));
  }
  return napi_clear_last_error(env);
}

napi_status napi_has_property(napi_env env, napi_value object, napi_value key,
                              bool* result) {
#ifndef _JSC_NO_FAST_KEY
  if (__builtin_available(macos 10.15, ios 13.0, *)) {
    JSValueRef exception{};
    *result = JSObjectHasPropertyForKey(env->ctx->context, ToJSObject(object),
                                        ToJSValue(key), &exception);
    CHECK_JSC(env, exception);
  } else
#endif
  {
    napi_value global{}, reflect{}, function{}, ret{};
    CHECK_NAPI(napi_get_global(env, &global));
    CHECK_NAPI(napi_get_named_property(env, global, "Reflect", &reflect));
    CHECK_NAPI(napi_get_named_property(env, reflect, "has", &function));
    napi_value args[] = {object, key};
    CHECK_NAPI(napi_call_function(env, reflect, function, 2, args, &ret));
    CHECK_NAPI(napi_get_value_bool(env, ret, result));
  }
  return napi_clear_last_error(env);
}

napi_status napi_get_property(napi_env env, napi_value object, napi_value key,
                              napi_value* result) {
#ifndef _JSC_NO_FAST_KEY
  if (__builtin_available(macos 10.15, ios 13.0, *)) {
    JSValueRef exception{};
    *result = ToNapi(JSObjectGetPropertyForKey(
        env->ctx->context, ToJSObject(object), ToJSValue(key), &exception));
    CHECK_JSC(env, exception);
  } else
#endif
  {
    napi_value global{}, reflect{}, function{};
    CHECK_NAPI(napi_get_global(env, &global));
    CHECK_NAPI(napi_get_named_property(env, global, "Reflect", &reflect));
    CHECK_NAPI(napi_get_named_property(env, reflect, "get", &function));
    napi_value args[] = {object, key};
    CHECK_NAPI(napi_call_function(env, reflect, function, 2, args, result));
  }
  return napi_clear_last_error(env);
}

napi_status napi_delete_property(napi_env env, napi_value object,
                                 napi_value key, bool* result) {
#ifndef _JSC_NO_FAST_KEY
  if (__builtin_available(macos 10.15, ios 13.0, *)) {
    JSValueRef exception{};
    *result = JSObjectDeletePropertyForKey(
        env->ctx->context, ToJSObject(object), ToJSValue(key), &exception);
    CHECK_JSC(env, exception);
  } else
#endif
  {
    napi_value global{}, reflect{}, function{}, ret{};
    CHECK_NAPI(napi_get_global(env, &global));
    CHECK_NAPI(napi_get_named_property(env, global, "Reflect", &reflect));
    CHECK_NAPI(
        napi_get_named_property(env, reflect, "deleteProperty", &function));
    napi_value args[] = {object, key};
    CHECK_NAPI(napi_call_function(env, reflect, function, 2, args, &ret));
    CHECK_NAPI(napi_get_value_bool(env, ret, result));
  }

  return napi_clear_last_error(env);
}

napi_status napi_has_own_property(napi_env env, napi_value object,
                                  napi_value key, bool* result) {
  napi_value global{}, object_ctor{}, object_prototype{}, function{}, value{};
  CHECK_NAPI(napi_get_global(env, &global));
  CHECK_NAPI(napi_get_named_property(env, global, "Object", &object_ctor));
  CHECK_NAPI(napi_get_named_property(env, object_ctor, "prototype",
                                     &object_prototype));
  CHECK_NAPI(napi_get_named_property(env, object_prototype, "hasOwnProperty",
                                     &function));
  CHECK_NAPI(napi_call_function(env, object, function, 1, &key, &value));
  *result = JSValueToBoolean(env->ctx->context, ToJSValue(value));

  return napi_clear_last_error(env);
}

napi_status napi_set_named_property(napi_env env, napi_value object,
                                    const char* utf8name, napi_value value) {
  JSValueRef exception{};
  JSObjectSetProperty(env->ctx->context, ToJSObject(object), JSString(utf8name),
                      ToJSValue(value), kJSPropertyAttributeNone, &exception);
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_has_named_property(napi_env env, napi_value object,
                                    const char* utf8name, bool* result) {
  *result = JSObjectHasProperty(env->ctx->context, ToJSObject(object),
                                JSString(utf8name));

  return napi_clear_last_error(env);
}

napi_status napi_get_named_property(napi_env env, napi_value object,
                                    const char* utf8name, napi_value* result) {
  JSValueRef exception{};
  *result = ToNapi(JSObjectGetProperty(env->ctx->context, ToJSObject(object),
                                       JSString(utf8name), &exception));
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_set_element(napi_env env, napi_value object, uint32_t index,
                             napi_value value) {
  JSValueRef exception{};
  JSObjectSetPropertyAtIndex(env->ctx->context, ToJSObject(object), index,
                             ToJSValue(value), &exception);
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_has_element(napi_env env, napi_value object, uint32_t index,
                             bool* result) {
  JSValueRef exception{};
  JSValueRef value{JSObjectGetPropertyAtIndex(
      env->ctx->context, ToJSObject(object), index, &exception)};
  CHECK_JSC(env, exception);

  *result = !JSValueIsUndefined(env->ctx->context, value);
  return napi_clear_last_error(env);
}

napi_status napi_get_element(napi_env env, napi_value object, uint32_t index,
                             napi_value* result) {
  JSValueRef exception{};
  *result = ToNapi(JSObjectGetPropertyAtIndex(
      env->ctx->context, ToJSObject(object), index, &exception));
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_delete_element(napi_env env, napi_value object, uint32_t index,
                                bool* result) {
  JSValueRef exception{};

  std::string index_str = std::to_string(index);

  *result = JSObjectDeleteProperty(
      env->ctx->context, ToJSObject(object),
      JSString(index_str.c_str(), index_str.size()), &exception);
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_define_properties(napi_env env, napi_value object,
                                   size_t property_count,
                                   const napi_property_descriptor* properties) {
  if (property_count > 0) {
    CHECK_ARG(env, properties);
  }

  for (size_t i = 0; i < property_count; i++) {
    const napi_property_descriptor* p{properties + i};

    if (p->getter != nullptr || p->setter != nullptr || p->name) {
      // JSC has no getter/setter API nor symbol operation, so a lot of hacks

      napi_value property_name{};
      if (p->name) {
        property_name = p->name;
      } else {
        CHECK_NAPI(napi_create_string_utf8(env, p->utf8name, NAPI_AUTO_LENGTH,
                                           &property_name));
      }

      napi_value descriptor{};
      CHECK_NAPI(napi_create_object(env, &descriptor));

      napi_value configurable{};
      CHECK_NAPI(napi_get_boolean(
          env, (p->attributes & napi_configurable) || p->setter != nullptr,
          &configurable));
      CHECK_NAPI(napi_set_named_property(env, descriptor, "configurable",
                                         configurable));

      napi_value enumerable{};
      CHECK_NAPI(napi_get_boolean(env, (p->attributes & napi_enumerable),
                                  &enumerable));
      CHECK_NAPI(
          napi_set_named_property(env, descriptor, "enumerable", enumerable));

      if (p->getter != nullptr || p->setter != nullptr) {
        char name_buf[128];
        memset(name_buf, 0, sizeof(name_buf));
        if (p->getter != nullptr) {
          if (p->utf8name) {
            assert(sizeof(name_buf) > strlen(p->utf8name));
            snprintf(name_buf, sizeof(name_buf), "get %s", p->utf8name);
          }
          napi_value getter{};
          CHECK_NAPI(napi_create_function(env, name_buf, NAPI_AUTO_LENGTH,
                                          p->getter, p->data, &getter));
          CHECK_NAPI(napi_set_named_property(env, descriptor, "get", getter));
        }
        if (p->setter != nullptr) {
          if (p->utf8name) {
            assert(sizeof(name_buf) > strlen(p->utf8name));
            snprintf(name_buf, sizeof(name_buf), "set %s", p->utf8name);
          }
          napi_value setter{};
          CHECK_NAPI(napi_create_function(env, name_buf, NAPI_AUTO_LENGTH,
                                          p->setter, p->data, &setter));
          CHECK_NAPI(napi_set_named_property(env, descriptor, "set", setter));
        }
      } else if (p->method != nullptr) {
        napi_value method{};
        CHECK_NAPI(napi_create_function(env, p->utf8name, NAPI_AUTO_LENGTH,
                                        p->method, p->data, &method));
        CHECK_NAPI(napi_set_named_property(env, descriptor, "value", method));
      } else {
        RETURN_STATUS_IF_FALSE(env, p->value != nullptr, napi_invalid_arg);

        napi_value writable{};
        CHECK_NAPI(
            napi_get_boolean(env, (p->attributes & napi_writable), &writable));
        CHECK_NAPI(
            napi_set_named_property(env, descriptor, "writable", writable));

        CHECK_NAPI(napi_set_named_property(env, descriptor, "value", p->value));
      }

      napi_value global{}, object_ctor{}, function{};
      CHECK_NAPI(napi_get_global(env, &global));
      CHECK_NAPI(napi_get_named_property(env, global, "Object", &object_ctor));
      CHECK_NAPI(napi_get_named_property(env, object_ctor, "defineProperty",
                                         &function));

      napi_value args[] = {object, property_name, descriptor};
      CHECK_NAPI(
          napi_call_function(env, object_ctor, function, 3, args, nullptr));
    } else {
      napi_value value;
      if (p->method != nullptr) {
        CHECK_NAPI(napi_create_function(env, p->utf8name, NAPI_AUTO_LENGTH,
                                        p->method, p->data, &value));
      } else {
        RETURN_STATUS_IF_FALSE(env, p->value != nullptr, napi_invalid_arg);
        value = p->value;
      }

      JSValueRef exc = nullptr;
      JSObjectSetProperty(env->ctx->context, ToJSObject(object),
                          JSString(p->utf8name), ToJSValue(value),
                          ToJSCPropertyAttributes(p->attributes), &exc);
      CHECK_JSC(env, exc);
    }
  }

  return napi_clear_last_error(env);
}

namespace {
JSStringRef getLengthString() {
  static JSStringRef length = JSStringCreateWithUTF8CString("length");
  return length;
}

JSStringRef getArrayString() {
  static JSStringRef array = JSStringCreateWithUTF8CString("Array");
  return array;
}

JSStringRef getIsArrayString() {
  static JSStringRef isArray = JSStringCreateWithUTF8CString("isArray");
  return isArray;
}
}  // namespace

napi_status napi_is_array(napi_env env, napi_value value, bool* result) {
  JSContextRef ctx = env->ctx->context;
  if (__builtin_available(macos 10.11, ios 9.0, *)) {
    *result = JSValueIsArray(ctx, ToJSValue(value));
  } else {
    JSObjectRef global = JSContextGetGlobalObject(ctx);
    JSStringRef arrayString = getArrayString();
    JSValueRef exc = nullptr;
    JSValueRef arrayCtorValue =
        JSObjectGetProperty(ctx, global, arrayString, &exc);
    CHECK_JSC(env, exc);
    JSObjectRef arrayCtor = JSValueToObject(ctx, arrayCtorValue, &exc);
    CHECK_JSC(env, exc);
    JSStringRef isArrayString = getIsArrayString();
    JSValueRef isArrayValue =
        JSObjectGetProperty(ctx, arrayCtor, isArrayString, &exc);
    CHECK_JSC(env, exc);
    JSObjectRef isArray = JSValueToObject(ctx, isArrayValue, &exc);
    CHECK_JSC(env, exc);
    JSValueRef is_array = JSObjectCallAsFunction(ctx, isArray, nullptr, 1,
                                                 ToJSValues(&value), &exc);
    CHECK_JSC(env, exc);
    *result = JSValueToBoolean(ctx, is_array);
  }
  return napi_clear_last_error(env);
}

napi_status napi_get_array_length(napi_env env, napi_value value,
                                  uint32_t* result) {
  JSValueRef exception{};
  JSValueRef length = JSObjectGetProperty(env->ctx->context, ToJSObject(value),
                                          getLengthString(), &exception);
  CHECK_JSC(env, exception);

  *result = static_cast<uint32_t>(
      JSValueToNumber(env->ctx->context, length, &exception));
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_equals(napi_env env, napi_value lhs, napi_value rhs,
                        bool* result) {
  JSValueRef exception{};

  *result = JSValueIsEqual(env->ctx->context, ToJSValue(lhs), ToJSValue(rhs),
                           &exception);

  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_strict_equals(napi_env env, napi_value lhs, napi_value rhs,
                               bool* result) {
  *result =
      JSValueIsStrictEqual(env->ctx->context, ToJSValue(lhs), ToJSValue(rhs));
  return napi_clear_last_error(env);
}

napi_status napi_get_prototype(napi_env env, napi_value object,
                               napi_value* result) {
  JSValueRef exception{};
  JSObjectRef prototype{JSValueToObject(
      env->ctx->context,
      JSObjectGetPrototype(env->ctx->context, ToJSObject(object)), &exception)};
  CHECK_JSC(env, exception);

  *result = ToNapi(prototype);
  return napi_clear_last_error(env);
}

napi_status napi_create_object(napi_env env, napi_value* result) {
  *result = ToNapi(JSObjectMake(env->ctx->context, nullptr, nullptr));
  return napi_clear_last_error(env);
}

napi_status napi_create_array(napi_env env, napi_value* result) {
  JSValueRef exception{};
  *result =
      ToNapi(JSObjectMakeArray(env->ctx->context, 0, nullptr, &exception));
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_create_array_with_length(napi_env env, size_t length,
                                          napi_value* result) {
  JSValueRef exception{};
  JSObjectRef array =
      JSObjectMakeArray(env->ctx->context, 0, nullptr, &exception);
  CHECK_JSC(env, exception);

  JSObjectSetProperty(
      env->ctx->context, array, getLengthString(),
      JSValueMakeNumber(env->ctx->context, static_cast<double>(length)),
      kJSPropertyAttributeNone, &exception);
  CHECK_JSC(env, exception);

  *result = ToNapi(array);
  return napi_clear_last_error(env);
}

napi_status napi_create_string_latin1(napi_env env, const char* str,
                                      size_t length, napi_value* result) {
  *result = ToNapi(JSValueMakeString(env->ctx->context, JSString(str, length)));
  return napi_clear_last_error(env);
}

static int unicode_from_utf8(const uint8_t* p, int max_len,
                             const uint8_t** pp) {
  int len, c, b;

  const uint8_t* p_start = p;

  c = *p++;
  *pp = p;
  if (c < 0x80) {
    return c;
  }
  switch (c) {
    case 0xc0 ... 0xdf:
      len = 1;
      break;
    case 0xe0 ... 0xef:
      len = 2;
      break;
    case 0xf0 ... 0xf7:
      len = 3;
      break;
    default:
      return -1;
  }
  const unsigned int utf8_min_code[3] = {0x80, 0x800, 0x10000};
  const unsigned int utf8_max_code[3] = {0x7ff, 0xffff, 0x10ffff};

  const unsigned char utf8_first_code_mask[3] = {
      0x1f,
      0xf,
      0x7,
  };

  int i = 1;

  c &= utf8_first_code_mask[len - 1];
  while (i <= len) {
    if (i > max_len) {
      *pp = p;
      return -1;
    }
    b = *p;
    if (b < 0x80 || b >= 0xc0) {
      *pp = p;
      return -1;
    }
    p++;
    i++;
    c = (c << 6) | (b & 0x3f);
  }

  if (c < utf8_min_code[len - 1] || c > utf8_max_code[len - 1]) {
    *pp = p_start + 1;
    return -1;
  } else {
    *pp = p;
    return c;
  }
}

napi_status napi_create_string_utf8(napi_env env, const char* str,
                                    size_t length, napi_value* result) {
  if (env->ctx->new_string_utf8_flag) {
    const uint8_t *p, *p_end, *p_next;
    uint32_t c;

    p = (const uint8_t*)str;
    p_end = p + length;
    std::u16string utf16_string;

    while (p < p_end || (length == NAPI_AUTO_LENGTH && *p != 0)) {
      if (*p < 128) {
        utf16_string.push_back(*p++);
      } else {
        c = unicode_from_utf8(p, p_end - p, &p_next);
        if (c < 0x10000) {
          utf16_string.push_back(c & 0xFFFF);
        } else if (c <= 0x10FFFF) {
          c -= 0x10000;
          utf16_string.push_back((c >> 10) + 0xd800);
          c = (c & 0x3ff) + 0xdc00;
          utf16_string.push_back(c);
        } else {
          /* use Unicode Replacement Character to replace the invalid chars */
          utf16_string.push_back(0xfffd);
        }
        p = p_next;
      }
    }
    *result = ToNapi(JSValueMakeString(
        env->ctx->context,
        JSString((const JSChar*)utf16_string.c_str(), utf16_string.length())));
    return napi_clear_last_error(env);
  } else {
    *result =
        ToNapi(JSValueMakeString(env->ctx->context, JSString(str, length)));
    return napi_clear_last_error(env);
  }
}

napi_status napi_create_string_utf16(napi_env env, const char16_t* str,
                                     size_t length, napi_value* result) {
  static_assert(sizeof(char16_t) == sizeof(JSChar),
                "size mismatch between char16_t and JSChar");
  *result = ToNapi(JSValueMakeString(
      env->ctx->context,
      JSString(reinterpret_cast<const JSChar*>(str), length)));
  return napi_clear_last_error(env);
}

napi_status napi_create_double(napi_env env, double value, napi_value* result) {
  *result = ToNapi(JSValueMakeNumber(env->ctx->context, value));
  return napi_clear_last_error(env);
}

napi_status napi_create_int32(napi_env env, int32_t value, napi_value* result) {
  *result =
      ToNapi(JSValueMakeNumber(env->ctx->context, static_cast<double>(value)));
  return napi_clear_last_error(env);
}

napi_status napi_create_uint32(napi_env env, uint32_t value,
                               napi_value* result) {
  *result =
      ToNapi(JSValueMakeNumber(env->ctx->context, static_cast<double>(value)));
  return napi_clear_last_error(env);
}

napi_status napi_create_int64(napi_env env, int64_t value, napi_value* result) {
  *result =
      ToNapi(JSValueMakeNumber(env->ctx->context, static_cast<double>(value)));
  return napi_clear_last_error(env);
}

napi_status napi_get_boolean(napi_env env, bool value, napi_value* result) {
  *result = ToNapi(JSValueMakeBoolean(env->ctx->context, value));
  return napi_clear_last_error(env);
}

napi_status napi_create_symbol(napi_env env, napi_value description,
                               napi_value* result) {
  napi_value global{}, symbol_func{};
  CHECK_NAPI(napi_get_global(env, &global));
  CHECK_NAPI(napi_get_named_property(env, global, "Symbol", &symbol_func));
  CHECK_NAPI(
      napi_call_function(env, global, symbol_func, 1, &description, result));
  return napi_clear_last_error(env);
}

napi_status napi_create_error(napi_env env, napi_value code, napi_value msg,
                              napi_value* result) {
  JSValueRef exception{};
  JSValueRef args[] = {ToJSValue(msg)};
  napi_value error =
      ToNapi(JSObjectMakeError(env->ctx->context, 1, args, &exception));
  CHECK_JSC(env, exception);

  CHECK_NAPI(napi_set_error_code(env, error, code, nullptr));

  *result = error;
  return napi_clear_last_error(env);
}

napi_status napi_create_type_error(napi_env env, napi_value code,
                                   napi_value msg, napi_value* result) {
  napi_value global{}, error_ctor{}, error{};
  CHECK_NAPI(napi_get_global(env, &global));
  CHECK_NAPI(napi_get_named_property(env, global, "TypeError", &error_ctor));
  CHECK_NAPI(napi_new_instance(env, error_ctor, 1, &msg, &error));
  CHECK_NAPI(napi_set_error_code(env, error, code, nullptr));

  *result = error;
  return napi_clear_last_error(env);
}

napi_status napi_create_range_error(napi_env env, napi_value code,
                                    napi_value msg, napi_value* result) {
  napi_value global{}, error_ctor{}, error{};
  CHECK_NAPI(napi_get_global(env, &global));
  CHECK_NAPI(napi_get_named_property(env, global, "RangeError", &error_ctor));
  CHECK_NAPI(napi_new_instance(env, error_ctor, 1, &msg, &error));
  CHECK_NAPI(napi_set_error_code(env, error, code, nullptr));

  *result = error;
  return napi_clear_last_error(env);
}

napi_status napi_typeof(napi_env env, napi_value value,
                        napi_valuetype* result) {
  JSType valueType = JSValueGetType(env->ctx->context, ToJSValue(value));
  switch (valueType) {
    case kJSTypeUndefined:
      *result = napi_undefined;
      break;
    case kJSTypeNull:
      *result = napi_null;
      break;
    case kJSTypeBoolean:
      *result = napi_boolean;
      break;
    case kJSTypeNumber:
      *result = napi_number;
      break;
    case kJSTypeString:
      *result = napi_string;
      break;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wswitch"
    case /* kJSTypeSymbol */ 6:
      *result = napi_symbol;
      break;
#pragma clang diagnostic pop
    case kJSTypeObject: {
      JSObjectRef object{ToJSObject(value)};
      if (!JSValueIsObject(env->ctx->context, object)) {
        // Since iOS 13, JSValueGetType will return kJSTypeSymbol
        // Before: Empirically, an es6 Symbol is not an object, but its type is
        // object.  This makes no sense, but we'll run with it.
        // https://github.com/WebKit/webkit/blob/master/Source/JavaScriptCore/API/JSValueRef.cpp#L79-L82
        *result = napi_symbol;
      } else if (JSObjectIsFunction(env->ctx->context, object)) {
        *result = napi_function;
      } else {
        jscimpl::NativeInfo* info{
            static_cast<jscimpl::NativeInfo*>(JSObjectGetPrivate(object))};
        if (info != nullptr && info->Type() == jscimpl::NativeType::External) {
          *result = napi_external;
        } else {
          *result = napi_object;
        }
      }
      break;
    }
#if defined(__IPHONE_18_0)
    case kJSTypeBigInt:
      // JSC does not support BigInt under iOS 18
      *result = napi_bigint;
      break;
#endif
  }

  return napi_clear_last_error(env);
}

napi_status napi_get_undefined(napi_env env, napi_value* result) {
  *result = ToNapi(JSValueMakeUndefined(env->ctx->context));
  return napi_clear_last_error(env);
}

napi_status napi_get_null(napi_env env, napi_value* result) {
  *result = ToNapi(JSValueMakeNull(env->ctx->context));
  return napi_clear_last_error(env);
}

napi_status napi_get_cb_info(
    napi_env env,               // [in] NAPI environment handle
    napi_callback_info cbinfo,  // [in] Opaque callback-info handle
    size_t* argc,      // [in-out] Specifies the size of the provided argv array
                       // and receives the actual count of args.
    napi_value* argv,  // [out] Array of values
    napi_value* this_arg,  // [out] Receives the JS 'this' arg for the call
    void** data) {         // [out] Receives the data pointer for the callback.
  if (argv != nullptr) {
    CHECK_ARG(env, argc);

    size_t i{0};
    size_t min{std::min(*argc, static_cast<size_t>(cbinfo->argc))};

    for (; i < min; i++) {
      argv[i] = cbinfo->argv[i];
    }

    if (i < *argc) {
      for (; i < *argc; i++) {
        argv[i] = ToNapi(JSValueMakeUndefined(env->ctx->context));
      }
    }
  }

  if (argc != nullptr) {
    *argc = cbinfo->argc;
  }

  if (this_arg != nullptr) {
    *this_arg = cbinfo->thisArg;
  }

  if (data != nullptr) {
    *data = cbinfo->data;
  }

  return napi_clear_last_error(env);
}

napi_status napi_get_new_target(napi_env env, napi_callback_info cbinfo,
                                napi_value* result) {
  *result = cbinfo->newTarget;
  return napi_clear_last_error(env);
}

napi_status napi_call_function(napi_env env, napi_value recv, napi_value func,
                               size_t argc, const napi_value* argv,
                               napi_value* result) {
  if (argc > 0) {
    CHECK_ARG(env, argv);
  }

  JSValueRef exception{};
  JSValueRef return_value{JSObjectCallAsFunction(
      env->ctx->context, ToJSObject(func),
      recv ? JSValueIsUndefined(env->ctx->context, ToJSValue(recv))
                 ? nullptr
                 : ToJSObject(recv)
           : nullptr,
      argc, ToJSValues(argv), &exception)};
  CHECK_JSC(env, exception);

  if (result != nullptr) {
    *result = ToNapi(return_value);
  }

  return napi_clear_last_error(env);
}

napi_status napi_get_global(napi_env env, napi_value* result) {
  *result = ToNapi(JSContextGetGlobalObject(env->ctx->context));
  return napi_clear_last_error(env);
}

napi_status napi_throw_(napi_env env, napi_value error) {
  env->ctx->last_exception = ToJSValue(error);

  return napi_clear_last_error(env);
}

napi_status napi_throw_error(napi_env env, const char* code, const char* msg) {
  napi_value code_value{
      ToNapi(JSValueMakeString(env->ctx->context, JSString(code)))};
  napi_value msg_value{
      ToNapi(JSValueMakeString(env->ctx->context, JSString(msg)))};
  napi_value error{};
  CHECK_NAPI(napi_create_error(env, code_value, msg_value, &error));
  return napi_throw_(env, error);
}

napi_status napi_throw_type_error(napi_env env, const char* code,
                                  const char* msg) {
  napi_value code_value{
      ToNapi(JSValueMakeString(env->ctx->context, JSString(code)))};
  napi_value msg_value{
      ToNapi(JSValueMakeString(env->ctx->context, JSString(msg)))};
  napi_value error{};
  CHECK_NAPI(napi_create_type_error(env, code_value, msg_value, &error));
  return napi_throw_(env, error);
}

napi_status napi_throw_range_error(napi_env env, const char* code,
                                   const char* msg) {
  napi_value code_value{
      ToNapi(JSValueMakeString(env->ctx->context, JSString(code)))};
  napi_value msg_value{
      ToNapi(JSValueMakeString(env->ctx->context, JSString(msg)))};
  napi_value error{};
  CHECK_NAPI(napi_create_range_error(env, code_value, msg_value, &error));
  return napi_throw_(env, error);
}

napi_status napi_is_error(napi_env env, napi_value value, bool* result) {
  napi_value global{}, error_ctor{};
  CHECK_NAPI(napi_get_global(env, &global));
  CHECK_NAPI(napi_get_named_property(env, global, "Error", &error_ctor));
  CHECK_NAPI(napi_instanceof(env, value, error_ctor, result));

  return napi_clear_last_error(env);
}

napi_status napi_get_value_double(napi_env env, napi_value value,
                                  double* result) {
  JSValueRef exception{};
  *result = JSValueToNumber(env->ctx->context, ToJSValue(value), &exception);
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_get_value_int32(napi_env env, napi_value value,
                                 int32_t* result) {
  JSValueRef exception{};
  *result = static_cast<int32_t>(
      JSValueToNumber(env->ctx->context, ToJSValue(value), &exception));
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_get_value_uint32(napi_env env, napi_value value,
                                  uint32_t* result) {
  JSValueRef exception{};
  *result = static_cast<uint32_t>(
      JSValueToNumber(env->ctx->context, ToJSValue(value), &exception));
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_get_value_int64(napi_env env, napi_value value,
                                 int64_t* result) {
  JSValueRef exception{};
  double number =
      JSValueToNumber(env->ctx->context, ToJSValue(value), &exception);
  CHECK_JSC(env, exception);

  if (std::isfinite(number)) {
    *result = static_cast<int64_t>(number);
  } else {
    *result = 0;
  }

  return napi_clear_last_error(env);
}

napi_status napi_get_value_bool(napi_env env, napi_value value, bool* result) {
  *result = JSValueToBoolean(env->ctx->context, ToJSValue(value));
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
  JSValueRef exception{};
  JSString string{ToJSString(env, value, &exception)};
  CHECK_JSC(env, exception);

  if (buf == nullptr) {
    *result = string.LengthLatin1();
  } else {
    string.CopyToLatin1(buf, bufsize, result);
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
  JSValueRef exception{};
  JSString string{ToJSString(env, value, &exception)};
  CHECK_JSC(env, exception);

  if (buf == nullptr) {
    *result = string.LengthUTF8();
  } else {
    string.CopyToUTF8(buf, bufsize, result);
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
  JSValueRef exception{};
  JSString string{ToJSString(env, value, &exception)};
  CHECK_JSC(env, exception);

  if (buf == nullptr) {
    *result = string.Length();
  } else {
    static_assert(sizeof(char16_t) == sizeof(JSChar),
                  "size mismatch between char16_t and JSChar");
    string.CopyTo(reinterpret_cast<JSChar*>(buf), bufsize, result);
  }

  return napi_clear_last_error(env);
}

napi_status napi_coerce_to_bool(napi_env env, napi_value value,
                                napi_value* result) {
  *result = ToNapi(JSValueMakeBoolean(
      env->ctx->context,
      JSValueToBoolean(env->ctx->context, ToJSValue(value))));
  return napi_clear_last_error(env);
}

napi_status napi_coerce_to_number(napi_env env, napi_value value,
                                  napi_value* result) {
  JSValueRef exception{};
  double number{
      JSValueToNumber(env->ctx->context, ToJSValue(value), &exception)};
  CHECK_JSC(env, exception);

  *result = ToNapi(JSValueMakeNumber(env->ctx->context, number));
  return napi_clear_last_error(env);
}

napi_status napi_coerce_to_object(napi_env env, napi_value value,
                                  napi_value* result) {
  JSValueRef exception{};
  *result =
      ToNapi(JSValueToObject(env->ctx->context, ToJSValue(value), &exception));
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_coerce_to_string(napi_env env, napi_value value,
                                  napi_value* result) {
  JSValueRef exception{};
  JSString string{ToJSString(env, value, &exception)};
  CHECK_JSC(env, exception);

  *result = ToNapi(JSValueMakeString(env->ctx->context, string));
  return napi_clear_last_error(env);
}

napi_status napi_wrap(napi_env env, napi_value js_object, void* native_object,
                      napi_finalize finalize_cb, void* finalize_hint,
                      napi_ref* result) {
  return jscimpl::Wrap<jscimpl::retrievable>(
      env, js_object, native_object, finalize_cb, finalize_hint, result);
}

napi_status napi_unwrap(napi_env env, napi_value obj, void** result) {
  return jscimpl::Unwrap(env, obj, result, jscimpl::KeepWrap);
}

napi_status napi_remove_wrap(napi_env env, napi_value obj, void** result) {
  return jscimpl::Unwrap(env, obj, result, jscimpl::RemoveWrap);
}

napi_status napi_create_external(napi_env env, void* data,
                                 napi_finalize finalize_cb, void* finalize_hint,
                                 napi_value* result) {
  jscimpl::NativeInfo* info = jscimpl::External::Create(env, result);
  info->Data(data);

  jscimpl::Reference::New(env, ToJSObject(*result), info, 0, true, finalize_cb,
                          data, finalize_hint);

  return napi_clear_last_error(env);
}

napi_status napi_get_value_external(napi_env env, napi_value value,
                                    void** result) {
  if (!JSValueIsObject(env->ctx->context, ToJSValue(value))) {
    return napi_object_expected;
  }

  jscimpl::NativeInfo* info{
      static_cast<jscimpl::NativeInfo*>(JSObjectGetPrivate(ToJSObject(value)))};
  *result = (info != nullptr && info->Type() == jscimpl::NativeType::External)
                ? info->Data()
                : nullptr;
  return napi_clear_last_error(env);
}

// Set initial_refcount to 0 for a weak reference, >0 for a strong reference.
napi_status napi_create_reference(napi_env env, napi_value value,
                                  uint32_t initial_refcount, napi_ref* result) {
  JSValueRef jsc_value = ToJSValue(value);

  if (!JSValueIsObject(env->ctx->context, jsc_value)) {
    return napi_set_last_error(env, napi_object_expected);
  }

  jscimpl::Reference* reference = jscimpl::Reference::New(
      env, ToJSObject(jsc_value),
      // NativeInfo is used in weak references
      // A bridge object will be created if its null
      // see `_get_native_info` for details
      static_cast<jscimpl::NativeInfo*>(JSObjectGetPrivate(ToJSObject(value))),
      initial_refcount, false);
  *result = reinterpret_cast<napi_ref>(reference);

  return napi_clear_last_error(env);
}

// Deletes a reference. The referenced value is released, and may be GC'd
// unless there are other references to it.
napi_status napi_delete_reference(napi_env env, napi_ref ref) {
  jscimpl::Reference::Delete(reinterpret_cast<jscimpl::Reference*>(ref));

  return napi_clear_last_error(env);
}

// Increments the reference count, optionally returning the resulting count.
// After this call the reference will be a strong reference because its refcount
// is >0, and the referenced object is effectively "pinned". Calling this when
// the refcount is 0 and the target is unavailable results in an error.
napi_status napi_reference_ref(napi_env env, napi_ref ref, uint32_t* result) {
  jscimpl::Reference* reference = reinterpret_cast<jscimpl::Reference*>(ref);
  uint32_t count = reference->Ref();

  if (result != nullptr) {
    *result = count;
  }

  return napi_clear_last_error(env);
}

// Decrements the reference count, optionally returning the resulting count.
// If the result is 0 the reference is now weak and the object may be GC'd at
// any time if there are no other references. Calling this when the refcount
// is already 0 results in an error.
napi_status napi_reference_unref(napi_env env, napi_ref ref, uint32_t* result) {
  jscimpl::Reference* reference = reinterpret_cast<jscimpl::Reference*>(ref);

  if (reference->RefCount() == 0) {
    return napi_set_last_error(env, napi_generic_failure);
  }

  uint32_t count = reference->Unref();

  if (result != nullptr) {
    *result = count;
  }

  return napi_clear_last_error(env);
}

// Attempts to get a referenced value. If the reference is weak, the value
// might no longer be available, in that case the call is still successful but
// the result is NULL.
napi_status napi_get_reference_value(napi_env env, napi_ref ref,
                                     napi_value* result) {
  jscimpl::Reference* reference = reinterpret_cast<jscimpl::Reference*>(ref);

  *result = ToNapi(reference->Get());
  return napi_clear_last_error(env);
}

// Stub implementation of handle scope apis for JSC.
napi_status napi_open_context_scope(napi_env env, napi_context_scope* result) {
  *result = reinterpret_cast<napi_context_scope>(1);
  return napi_clear_last_error(env);
}

// Stub implementation of handle scope apis for JSC.
napi_status napi_close_context_scope(napi_env env, napi_context_scope scope) {
  return napi_clear_last_error(env);
}

// Stub implementation of handle scope apis for JSC.
napi_status napi_open_handle_scope(napi_env env, napi_handle_scope* result) {
  *result = reinterpret_cast<napi_handle_scope>(1);
  return napi_clear_last_error(env);
}

// Stub implementation of handle scope apis for JSC.
napi_status napi_close_handle_scope(napi_env env, napi_handle_scope scope) {
  return napi_clear_last_error(env);
}

// Stub implementation of handle scope apis for JSC.
napi_status napi_open_escapable_handle_scope(
    napi_env env, napi_escapable_handle_scope* result) {
  *result = reinterpret_cast<napi_escapable_handle_scope>(1);
  return napi_clear_last_error(env);
}

// Stub implementation of handle scope apis for JSC.
napi_status napi_close_escapable_handle_scope(
    napi_env env, napi_escapable_handle_scope scope) {
  return napi_clear_last_error(env);
}

// Stub implementation of handle scope apis for JSC.
// This one will return escapee value as this is called from leveldown db.
napi_status napi_escape_handle(napi_env env, napi_escapable_handle_scope scope,
                               napi_value escapee, napi_value* result) {
  *result = escapee;
  return napi_clear_last_error(env);
}

napi_status napi_new_instance(napi_env env, napi_value constructor, size_t argc,
                              const napi_value* argv, napi_value* result) {
  if (argc > 0) {
    CHECK_ARG(env, argv);
  }

  JSValueRef exception{};
  *result = ToNapi(JSObjectCallAsConstructor(env->ctx->context,
                                             ToJSObject(constructor), argc,
                                             ToJSValues(argv), &exception));
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_instanceof(napi_env env, napi_value object,
                            napi_value constructor, bool* result) {
  JSValueRef exception{};
  *result = JSValueIsInstanceOfConstructor(env->ctx->context, ToJSValue(object),
                                           ToJSObject(constructor), &exception);
  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

napi_status napi_is_exception_pending(napi_env env, bool* result) {
  *result = (env->ctx->last_exception != nullptr);
  return napi_clear_last_error(env);
}

napi_status napi_get_and_clear_last_exception(napi_env env,
                                              napi_value* result) {
  if (env->ctx->last_exception == nullptr) {
    return napi_get_undefined(env, result);
  } else {
    *result = ToNapi(env->ctx->last_exception);
    env->ctx->last_exception = nullptr;
  }

  return napi_clear_last_error(env);
}

napi_status napi_get_unhandled_rejection_exception(napi_env env,
                                                   napi_value* result) {
  return napi_clear_last_error(env);
}

napi_status napi_get_own_property_descriptor(napi_env env, napi_value obj,
                                             napi_value prop,
                                             napi_value* result) {
  /*  JavaScriptCore C API does not provide a direct function to retrieve the
   *  property descriptor of an object, so we need use Napi function to call
   * Reflect.getOwnPropertyDescriptor to achieve this.
   */
  napi_value global{}, reflect{}, function{};
  CHECK_NAPI(napi_get_global(env, &global));
  CHECK_NAPI(napi_get_named_property(env, global, "Reflect", &reflect));
  CHECK_NAPI(napi_get_named_property(env, reflect, "getOwnPropertyDescriptor",
                                     &function));
  napi_value args[] = {obj, prop};
  CHECK_NAPI(napi_call_function(env, reflect, function, 2, args, result));
  return napi_clear_last_error(env);
}

napi_status napi_is_arraybuffer(napi_env env, napi_value value, bool* result) {
  if (__builtin_available(macos 10.12, ios 10.0, *)) {
    JSValueRef exception{};
    JSTypedArrayType type{JSValueGetTypedArrayType(
        env->ctx->context, ToJSValue(value), &exception)};
    CHECK_JSC(env, exception);

    *result = (type == kJSTypedArrayTypeArrayBuffer);
  } else {
    return napi_set_last_error(env, napi_generic_failure);
  }
  return napi_clear_last_error(env);
}

napi_status napi_create_arraybuffer(napi_env env, size_t byte_length,
                                    void** data, napi_value* result) {
  if (__builtin_available(macos 10.12, ios 10.0, *)) {
    *data = malloc(byte_length);
    JSValueRef exception{};
    *result = ToNapi(JSObjectMakeArrayBufferWithBytesNoCopy(
        env->ctx->context, *data, byte_length,
        [](void* bytes, void* deallocatorContext) { free(bytes); }, nullptr,
        &exception));
    CHECK_JSC(env, exception);
  } else {
    return napi_set_last_error(env, napi_generic_failure);
  }
  return napi_clear_last_error(env);
}

napi_status napi_create_external_arraybuffer(napi_env env, void* external_data,
                                             size_t byte_length,
                                             napi_finalize finalize_cb,
                                             void* finalize_hint,
                                             napi_value* result) {
  if (__builtin_available(macos 10.12, ios 10.0, *)) {
    JSValueRef exception{};

    JSObjectRef buffer = JSObjectMakeArrayBufferWithBytesNoCopy(
        env->ctx->context, external_data, byte_length, [](void*, void*) {},
        nullptr, &exception);

    if (finalize_cb != nullptr) {
      jscimpl::Reference::New(env, buffer, nullptr, 0, true, finalize_cb,
                              external_data, finalize_hint);
    }

    *result = ToNapi(buffer);
  } else {
    return napi_set_last_error(env, napi_generic_failure);
  }
  return napi_clear_last_error(env);
}

napi_status napi_get_arraybuffer_info(napi_env env, napi_value arraybuffer,
                                      void** data, size_t* byte_length) {
  if (__builtin_available(macos 10.12, ios 10.0, *)) {
    JSValueRef exception{};

    if (data != nullptr) {
      *data = JSObjectGetArrayBufferBytesPtr(
          env->ctx->context, ToJSObject(arraybuffer), &exception);
      CHECK_JSC(env, exception);
    }

    if (byte_length != nullptr) {
      *byte_length = JSObjectGetArrayBufferByteLength(
          env->ctx->context, ToJSObject(arraybuffer), &exception);
      CHECK_JSC(env, exception);
    }
  } else {
    return napi_set_last_error(env, napi_generic_failure);
  }
  return napi_clear_last_error(env);
}

napi_status napi_is_typedarray(napi_env env, napi_value value, bool* result) {
  if (__builtin_available(macos 10.12, ios 10.0, *)) {
    JSValueRef exception{};
    JSTypedArrayType type{JSValueGetTypedArrayType(
        env->ctx->context, ToJSValue(value), &exception)};
    CHECK_JSC(env, exception);

    *result =
        (type != kJSTypedArrayTypeNone && type != kJSTypedArrayTypeArrayBuffer);
  } else {
    return napi_set_last_error(env, napi_generic_failure);
  }
  return napi_clear_last_error(env);
}

napi_status napi_create_typedarray(napi_env env, napi_typedarray_type type,
                                   size_t length, napi_value arraybuffer,
                                   size_t byte_offset, napi_value* result) {
  if (__builtin_available(macos 10.12, ios 10.0, *)) {
    JSTypedArrayType jsType{};
    switch (type) {
      case napi_int8_array:
        jsType = kJSTypedArrayTypeInt8Array;
        break;
      case napi_uint8_array:
        jsType = kJSTypedArrayTypeUint8Array;
        break;
      case napi_uint8_clamped_array:
        jsType = kJSTypedArrayTypeUint8ClampedArray;
        break;
      case napi_int16_array:
        jsType = kJSTypedArrayTypeInt16Array;
        break;
      case napi_uint16_array:
        jsType = kJSTypedArrayTypeUint16Array;
        break;
      case napi_int32_array:
        jsType = kJSTypedArrayTypeInt32Array;
        break;
      case napi_uint32_array:
        jsType = kJSTypedArrayTypeUint32Array;
        break;
      case napi_float32_array:
        jsType = kJSTypedArrayTypeFloat32Array;
        break;
      case napi_float64_array:
        jsType = kJSTypedArrayTypeFloat64Array;
        break;
      default:
        return napi_set_last_error(env, napi_invalid_arg);
    }

    JSValueRef exception{};
    *result = ToNapi(JSObjectMakeTypedArrayWithArrayBufferAndOffset(
        env->ctx->context, jsType, ToJSObject(arraybuffer), byte_offset, length,
        &exception));
    CHECK_JSC(env, exception);
  } else {
    return napi_set_last_error(env, napi_generic_failure);
  }

  return napi_clear_last_error(env);
}

napi_status napi_is_typedarray_of(napi_env env, napi_value typedarray,
                                  napi_typedarray_type type, bool* result) {
  if (__builtin_available(macos 10.12, ios 10.0, *)) {
    JSValueRef exception{};

    JSTypedArrayType typedArrayType{JSValueGetTypedArrayType(
        env->ctx->context, ToJSValue(typedarray), &exception)};
    CHECK_JSC(env, exception);

    switch (type) {
      case napi_int8_array:
        *result = typedArrayType == kJSTypedArrayTypeInt8Array;
        break;
      case napi_uint8_array:
        *result = typedArrayType == kJSTypedArrayTypeUint8Array;
        break;
      case napi_uint8_clamped_array:
        *result = typedArrayType == kJSTypedArrayTypeUint8ClampedArray;
        break;
      case napi_int16_array:
        *result = typedArrayType == kJSTypedArrayTypeInt16Array;
        break;
      case napi_uint16_array:
        *result = typedArrayType == kJSTypedArrayTypeUint16Array;
        break;
      case napi_int32_array:
        *result = typedArrayType == kJSTypedArrayTypeInt32Array;
        break;
      case napi_uint32_array:
        *result = typedArrayType == kJSTypedArrayTypeUint32Array;
        break;
      case napi_float32_array:
        *result = typedArrayType == kJSTypedArrayTypeFloat32Array;
        break;
      case napi_float64_array:
        *result = typedArrayType == kJSTypedArrayTypeFloat64Array;
        break;
      default:
        break;
    }
  } else {
    return napi_set_last_error(env, napi_generic_failure);
  }
  return napi_clear_last_error(env);
}

napi_status napi_get_typedarray_info(napi_env env, napi_value typedarray,
                                     napi_typedarray_type* type, size_t* length,
                                     void** data, napi_value* arraybuffer,
                                     size_t* byte_offset) {
  if (__builtin_available(macos 10.12, ios 10.0, *)) {
    JSValueRef exception{};

    JSObjectRef object{ToJSObject(typedarray)};

    if (type != nullptr) {
      JSTypedArrayType typedArrayType{
          JSValueGetTypedArrayType(env->ctx->context, object, &exception)};
      CHECK_JSC(env, exception);

      switch (typedArrayType) {
        case kJSTypedArrayTypeInt8Array:
          *type = napi_int8_array;
          break;
        case kJSTypedArrayTypeUint8Array:
          *type = napi_uint8_array;
          break;
        case kJSTypedArrayTypeUint8ClampedArray:
          *type = napi_uint8_clamped_array;
          break;
        case kJSTypedArrayTypeInt16Array:
          *type = napi_int16_array;
          break;
        case kJSTypedArrayTypeUint16Array:
          *type = napi_uint16_array;
          break;
        case kJSTypedArrayTypeInt32Array:
          *type = napi_int32_array;
          break;
        case kJSTypedArrayTypeUint32Array:
          *type = napi_uint32_array;
          break;
        case kJSTypedArrayTypeFloat32Array:
          *type = napi_float32_array;
          break;
        case kJSTypedArrayTypeFloat64Array:
          *type = napi_float64_array;
          break;
        default:
          return napi_set_last_error(env, napi_generic_failure);
      }
    }

    if (length != nullptr) {
      *length =
          JSObjectGetTypedArrayLength(env->ctx->context, object, &exception);
      CHECK_JSC(env, exception);
    }

    if (data != nullptr || byte_offset != nullptr) {
      size_t data_byte_offset{JSObjectGetTypedArrayByteOffset(
          env->ctx->context, object, &exception)};
      CHECK_JSC(env, exception);

      if (data != nullptr) {
        *data = static_cast<uint8_t*>(JSObjectGetTypedArrayBytesPtr(
                    env->ctx->context, object, &exception)) +
                data_byte_offset;
        CHECK_JSC(env, exception);
      }

      if (byte_offset != nullptr) {
        *byte_offset = data_byte_offset;
      }
    }

    if (arraybuffer != nullptr) {
      *arraybuffer = ToNapi(
          JSObjectGetTypedArrayBuffer(env->ctx->context, object, &exception));
      CHECK_JSC(env, exception);
    }
  } else {
    return napi_set_last_error(env, napi_generic_failure);
  }

  return napi_clear_last_error(env);
}

napi_status napi_create_dataview(napi_env env, size_t byte_length,
                                 napi_value arraybuffer, size_t byte_offset,
                                 napi_value* result) {
  napi_value global{}, dataview_ctor{};
  CHECK_NAPI(napi_get_global(env, &global));
  CHECK_NAPI(napi_get_named_property(env, global, "DataView", &dataview_ctor));

  napi_value byte_offset_value{}, byte_length_value{};
  napi_create_double(env, static_cast<double>(byte_offset), &byte_offset_value);
  napi_create_double(env, static_cast<double>(byte_length), &byte_length_value);
  napi_value args[] = {arraybuffer, byte_offset_value, byte_length_value};
  CHECK_NAPI(napi_new_instance(env, dataview_ctor, 3, args, result));

  return napi_clear_last_error(env);
}

napi_status napi_is_dataview(napi_env env, napi_value value, bool* result) {
  napi_value global{}, dataview_ctor{};
  CHECK_NAPI(napi_get_global(env, &global));
  CHECK_NAPI(napi_get_named_property(env, global, "DataView", &dataview_ctor));
  CHECK_NAPI(napi_instanceof(env, value, dataview_ctor, result));

  return napi_clear_last_error(env);
}

napi_status napi_get_dataview_info(napi_env env, napi_value dataview,
                                   size_t* byte_length, void** data,
                                   napi_value* arraybuffer,
                                   size_t* byte_offset) {
  if (byte_length != nullptr) {
    napi_value value{};
    double doubleValue{};
    CHECK_NAPI(napi_get_named_property(env, dataview, "byteLength", &value));
    CHECK_NAPI(napi_get_value_double(env, value, &doubleValue));
    *byte_length = static_cast<size_t>(doubleValue);
  }

  if (data != nullptr) {
    napi_value value{};
    CHECK_NAPI(napi_get_named_property(env, dataview, "buffer", &value));
    CHECK_NAPI(napi_get_arraybuffer_info(env, value, data, nullptr));
  }

  if (arraybuffer != nullptr) {
    CHECK_NAPI(napi_get_named_property(env, dataview, "buffer", arraybuffer));
  }

  if (byte_offset != nullptr) {
    napi_value value{};
    double doubleValue{};
    CHECK_NAPI(napi_get_named_property(env, dataview, "byteOffset", &value));
    CHECK_NAPI(napi_get_value_double(env, value, &doubleValue));
    *byte_offset = static_cast<size_t>(doubleValue);
  }

  return napi_clear_last_error(env);
}

struct napi_deferred__jsc {
  jscimpl::Persistent resolve;
  jscimpl::Persistent reject;

  bool has_init = false;

  static napi_value Callback(napi_env env, napi_callback_info cbinfo) {
    napi_deferred__jsc* deferred =
        static_cast<napi_deferred__jsc*>(cbinfo->data);
    deferred->has_init = true;
    deferred->resolve.Reset(env, ToJSObject(cbinfo->argv[0]), nullptr);
    deferred->reject.Reset(env, ToJSObject(cbinfo->argv[1]), nullptr);
    return nullptr;
  }
};

napi_status napi_create_promise(napi_env env, napi_deferred* deferred,
                                napi_value* promise) {
  napi_value global{}, promise_ctor{};
  CHECK_NAPI(napi_get_global(env, &global));
  CHECK_NAPI(napi_get_named_property(env, global, "Promise", &promise_ctor));

  std::unique_ptr<napi_deferred__jsc> deferred_val =
      std::make_unique<napi_deferred__jsc>();
  napi_value executor{}, promise_val{};
  CHECK_NAPI(napi_create_function(env, "executor", NAPI_AUTO_LENGTH,
                                  napi_deferred__jsc::Callback,
                                  deferred_val.get(), &executor));
  CHECK_NAPI(napi_new_instance(env, promise_ctor, 1, &executor, &promise_val));

  if (!deferred_val->has_init) {
    return napi_set_last_error(env, napi_generic_failure);
  }

  *promise = promise_val;
  *deferred = deferred_val.release();

  return napi_clear_last_error(env);
}

napi_status napi_release_deferred(napi_env env, napi_deferred deferred,
                                  napi_value resolution,
                                  napi_deferred_release_mode mode) {
  std::unique_ptr<napi_deferred__jsc> _(deferred);  // RAII

  switch (mode) {
    case napi_deferred_delete:
      break;
    case napi_deferred_resolve:
    case napi_deferred_reject:
      JSObjectRef resolve_fn = mode == napi_deferred_resolve
                                   ? deferred->resolve.Value()
                                   : deferred->reject.Value();
      JSValueRef exc = nullptr;
      JSObjectCallAsFunction(env->ctx->context, resolve_fn, nullptr, 1,
                             ToJSValues(&resolution), &exc);
      CHECK_JSC(env, exc);
      break;
  }

  return napi_clear_last_error(env);
}

napi_status napi_is_promise(napi_env env, napi_value promise,
                            bool* is_promise) {
  napi_value global{}, promise_ctor{};
  CHECK_NAPI(napi_get_global(env, &global));
  CHECK_NAPI(napi_get_named_property(env, global, "Promise", &promise_ctor));
  CHECK_NAPI(napi_instanceof(env, promise, promise_ctor, is_promise));

  return napi_clear_last_error(env);
}

napi_status napi_run_script(napi_env env, const char* script, size_t length,
                            const char* filename, napi_value* result) {
  JSValueRef exception{};

  if (filename) {
    *result =
        ToNapi(JSEvaluateScript(env->ctx->context, JSString(script, length),
                                nullptr, JSString(filename), 0, &exception));
  } else {
    *result =
        ToNapi(JSEvaluateScript(env->ctx->context, JSString(script, length),
                                nullptr, nullptr, 0, &exception));
  }

  CHECK_JSC(env, exception);

  return napi_clear_last_error(env);
}

#ifdef ENABLE_CODECACHE
napi_status napi_run_script_cache(napi_env env, const char* script,
                                  size_t length, const char* filename,
                                  napi_value* result) {
  // JavaScriptCore do not support codecache yet.
  return napi_run_script(env, script, length, filename, result);
}
napi_status napi_run_code_cache(napi_env env, const uint8_t* data, int length,
                                napi_value* result) {
  // JavaScriptCore do not support codecache yet.
  return napi_ok;
}
napi_status napi_gen_code_cache(napi_env env, const char* script,
                                size_t script_len, const uint8_t** data,
                                int* length) {
  // JavaScriptCore do not support codecache yet.
  return napi_ok;
}
#endif  // ENABLE_CODECACHE

napi_status napi_add_finalizer(napi_env env, napi_value js_object,
                               void* native_object, napi_finalize finalize_cb,
                               void* finalize_hint, napi_ref* result) {
  return jscimpl::Wrap<jscimpl::anonymous>(env, js_object, native_object,
                                           finalize_cb, finalize_hint, result);
}

napi_status napi_adjust_external_memory(napi_env env, int64_t change_in_bytes,
                                        int64_t* adjusted_value) {
  // For now, we can lie and say that we always adjusted more memory
  *adjusted_value = change_in_bytes;

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
      jscimpl::RefBase::New(env, 0, true, finalize_cb, data, finalize_hint);

  return napi_clear_last_error(env);
}

napi_status napi_get_instance_data(napi_env env, uint64_t key, void** data) {
  auto it = env->ctx->instance_data_registry.find(key);
  if (it == env->ctx->instance_data_registry.end()) {
    *data = nullptr;
  } else {
    jscimpl::RefBase* idata = static_cast<jscimpl::RefBase*>(it->second);

    *data = idata->Data();
  }

  return napi_clear_last_error(env);
}

void napi_attach_jsc(napi_env env, JSGlobalContextRef global_ctx) {
#define SET_METHOD(API) env->napi_##API = napi_##API;

  FOR_EACH_NAPI_ENGINE_CALL(SET_METHOD)

#undef SET_METHOD

  env->ctx = new napi_context__jsc(env, global_ctx);
}

void napi_detach_jsc(napi_env env) {
  delete env->ctx;
  env->ctx = nullptr;
}

JSGlobalContextRef napi_get_env_context_jsc(napi_env env) {
  return env->ctx->context;
}

JSValueRef napi_js_value_to_jsc_value(napi_env env, napi_value value) {
  return ToJSValue(value);
}

napi_value napi_jsc_value_to_js_value(napi_env env, JSValueRef value) {
  return ToNapi(value);
}
