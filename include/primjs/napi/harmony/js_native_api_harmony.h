
#ifndef NAPI_HARMONY_JS_NATIVE_API_HARMONY_H_
#define NAPI_HARMONY_JS_NATIVE_API_HARMONY_H_

#include <ark_runtime/jsvm.h>
#include <assert.h>

#include <functional>
#include <list>
#include <vector>

#define NAPI_COMPILE_UNIT harmony

#include "js_native_api_types.h"
#include "napi_state.h"

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

struct napi_callback_info__harmony {
  JSVM_CallbackInfo jsvm_cb_info;
  void* napi_data;
  JSVM_Value thiz;
};

struct napi_class__harmony {
  napi_class__harmony(JSVM_Env env, JSVM_Value clazz, JSVM_Value proto) {
    env_ = env;
    OH_JSVM_CreateReference(env, clazz, 1, &clazz_);
    OH_JSVM_CreateReference(env, proto, 1, &proto_);
    return;
  }

  ~napi_class__harmony() {
    OH_JSVM_DeleteReference(env_, proto_);
    OH_JSVM_DeleteReference(env_, clazz_);
    return;
  }

  JSVM_Value GetFunction() {
    JSVM_Value func;
    OH_JSVM_GetReferenceValue(env_, clazz_, &func);
    return func;
  }

  JSVM_Value GetPrototype() {
    JSVM_Value prototype;
    OH_JSVM_GetReferenceValue(env_, proto_, &prototype);
    return prototype;
  }

  JSVM_Env env_;
  JSVM_Ref clazz_;
  JSVM_Ref proto_;
};

namespace harmonyimpl {

class HandleScopeWrapper {
 public:
  explicit HandleScopeWrapper(JSVM_Env env) : jsvm_env{env} {
    OH_JSVM_OpenHandleScope(env, &jsvm_handle);
  }

  ~HandleScopeWrapper() { OH_JSVM_CloseHandleScope(jsvm_env, jsvm_handle); }

  HandleScopeWrapper(const HandleScopeWrapper&) = delete;
  HandleScopeWrapper& operator=(const HandleScopeWrapper&) = delete;
  HandleScopeWrapper(HandleScopeWrapper&&) = delete;
  HandleScopeWrapper& operator=(HandleScopeWrapper&) = delete;
  void* operator new(size_t) = delete;
  void* operator new[](size_t) = delete;

 private:
  JSVM_Env jsvm_env;
  JSVM_HandleScope jsvm_handle;
};

struct ExternalNativeInfo {
 public:
  static ExternalNativeInfo* Create(napi_env, napi_finalize, void*, void*);
  static void Delete(JSVM_Env, void*, void*);
  void CallFinalizer();
  void ClearFinalizer() { finalize_cb_ = nullptr; }
  void* Data() { return data_; }

 private:
  ExternalNativeInfo(napi_env env, napi_finalize fcb, void* data,
                     void* finalize_hint);
  ~ExternalNativeInfo();
  napi_env env_;
  napi_finalize finalize_cb_;
  void* data_;
  void* hint_;
  std::list<ExternalNativeInfo*>::const_iterator pos_;
};

struct Reference {
  Reference(napi_env env, JSVM_Value ref, uint32_t rc);
  Reference(napi_env env, JSVM_Ref ref);
  ~Reference();

  uint32_t Ref();
  uint32_t UnRef();
  JSVM_Value GetValue();
  void ClearReference();
  napi_env env_;
  JSVM_Ref ref_;
  std::list<Reference*>::const_iterator iter_;
};

#define RETURN_STATUS_IF_FALSE(env, condition, status) \
  do {                                                 \
    if (!(condition)) {                                \
      return napi_set_last_error((env), (status));     \
    }                                                  \
  } while (0)

inline napi_value JSValueToNapi(JSVM_Value value) {
  return reinterpret_cast<napi_value>(value);
}

inline JSVM_Value NapiValueToJS(napi_value value) {
  return reinterpret_cast<JSVM_Value>(value);
}

inline JSVM_Value* NapiValuePointerToJS(napi_value* result) {
  return reinterpret_cast<JSVM_Value*>(result);
}

inline const JSVM_Value* ConstNapiValuePointerToJS(const napi_value* result) {
  return reinterpret_cast<const JSVM_Value*>(result);
}

inline napi_value* JSvaluePointerToNapi(JSVM_Value* result) {
  return reinterpret_cast<napi_value*>(result);
}

inline napi_handle_scope JSHandleScopeToNapi(JSVM_HandleScope handle) {
  return reinterpret_cast<napi_handle_scope>(handle);
}

inline JSVM_HandleScope NapiHandleScopeToJS(napi_handle_scope handle) {
  return reinterpret_cast<JSVM_HandleScope>(handle);
}

inline napi_escapable_handle_scope JSEscapableHandleToNapi(
    JSVM_EscapableHandleScope handle) {
  return reinterpret_cast<napi_escapable_handle_scope>(handle);
}

inline JSVM_EscapableHandleScope NapiEscapableHandleToJS(
    napi_escapable_handle_scope handle) {
  return reinterpret_cast<JSVM_EscapableHandleScope>(handle);
}

inline napi_deferred JSDeferredToNapi(JSVM_Deferred js_defer) {
  return reinterpret_cast<napi_deferred>(js_defer);
}

inline JSVM_Deferred NapiDeferredToJS(napi_deferred defer) {
  return reinterpret_cast<JSVM_Deferred>(defer);
}

inline Reference* NapiRefToJS(napi_ref ref) {
  return reinterpret_cast<Reference*>(ref);
}
inline napi_ref JSRefToNapi(Reference* ref) {
  return reinterpret_cast<napi_ref>(ref);
}

#define PROPERTY_ATTRIBUTE(V)       \
  V(default, DEFAULT)               \
  V(writable, WRITABLE)             \
  V(enumerable, ENUMERABLE)         \
  V(configurable, CONFIGURABLE)     \
  V(static, STATIC)                 \
  V(default_method, DEFAULT_METHOD) \
  V(default_jsproperty, DEFAULT_JSPROPERTY)

inline JSVM_PropertyAttributes NapiPropertyAttrToJS(
    napi_property_attributes attr) {
  uint32_t js_attr = JSVM_DEFAULT;
  if (attr & napi_writable) js_attr |= JSVM_WRITABLE;
  if (attr & napi_enumerable) js_attr |= JSVM_ENUMERABLE;
  if (attr & napi_configurable) js_attr |= JSVM_CONFIGURABLE;
  if (attr & napi_static) js_attr |= JSVM_STATIC;
  return static_cast<JSVM_PropertyAttributes>(js_attr | JSVM_NO_RECEIVER_CHECK);
}

#define VALUE_TYPE(V)     \
  V(undefined, UNDEFINED) \
  V(null, NULL)           \
  V(boolean, BOOLEAN)     \
  V(number, NUMBER)       \
  V(string, STRING)       \
  V(symbol, SYMBOL)       \
  V(object, OBJECT)       \
  V(function, FUNCTION)   \
  V(external, EXTERNAL)   \
  V(bigint, BIGINT)

inline napi_valuetype NapiValueTypeFromJSValueType(JSVM_ValueType type) {
  switch (type) {
#define JS_TO_NAPI_VALUE_TYPE(output, input) \
  case JSVM_##input:                         \
    return napi_##output;
    VALUE_TYPE(JS_TO_NAPI_VALUE_TYPE);
#undef JS_TO_NAPI_VALUE_TYPE
  }
}

inline JSVM_ValueType JSValueTypeFromNapiType(napi_valuetype type) {
  switch (type) {
#define CONVERT_NAPI_VALUETYPE_TO_JS(input, output) \
  case napi_##input:                                \
    return JSVM_##output;
    VALUE_TYPE(CONVERT_NAPI_VALUETYPE_TO_JS)
#undef CONVERT_NAPI_VALUETYPE_TO_JS
  }
}

#define TYPEDARRAY_TYPE(V)        \
  V(int8, INT8)                   \
  V(uint8, UINT8)                 \
  V(uint8_clamped, UINT8_CLAMPED) \
  V(int16, INT16)                 \
  V(uint16, UINT16)               \
  V(int32, INT32)                 \
  V(uint32, UINT32)               \
  V(float32, FLOAT32)             \
  V(float64, FLOAT64)             \
  V(bigint64, BIGINT64)           \
  V(biguint64, BIGUINT64)

#define CALL_STATUS(V)                                \
  V(ok, OK)                                           \
  V(invalid_arg, INVALID_ARG)                         \
  V(object_expected, OBJECT_EXPECTED)                 \
  V(string_expected, STRING_EXPECTED)                 \
  V(name_expected, NAME_EXPECTED)                     \
  V(function_expected, FUNCTION_EXPECTED)             \
  V(number_expected, NUMBER_EXPECTED)                 \
  V(boolean_expected, BOOLEAN_EXPECTED)               \
  V(array_expected, ARRAY_EXPECTED)                   \
  V(generic_failure, GENERIC_FAILURE)                 \
  V(pending_exception, PENDING_EXCEPTION)             \
  V(cancelled, CANCELLED)                             \
  V(escape_called_twice, ESCAPE_CALLED_TWICE)         \
  V(handle_scope_mismatch, HANDLE_SCOPE_MISMATCH)     \
  V(callback_scope_mismatch, CALLBACK_SCOPE_MISMATCH) \
  V(queue_full, QUEUE_FULL)                           \
  V(closing, CLOSING)                                 \
  V(bigint_expected, BIGINT_EXPECTED)                 \
  V(date_expected, DATE_EXPECTED)                     \
  V(arraybuffer_expected, ARRAYBUFFER_EXPECTED)       \
  V(detachable_arraybuffer_expected, DETACHABLE_ARRAYBUFFER_EXPECTED)

inline napi_status JSStatusToNapi(JSVM_Status status) {
  switch (status) {
#define CONVERT_STATUS(out, in) \
  case JSVM_##in:               \
    return napi_##out;
    CALL_STATUS(CONVERT_STATUS)
#undef CONVERT_STATUS
    default:
      return static_cast<napi_status>(status);
  }
}

inline JSVM_TypedarrayType NapiTypedarrTypeToJSTypedarrType(
    napi_typedarray_type type) {
  switch (type) {
#define CONVERT_NAPI_TypedArrayType(input, output) \
  case napi_##input##_array:                       \
    return JSVM_##output##_ARRAY;
    TYPEDARRAY_TYPE(CONVERT_NAPI_TypedArrayType);
#undef CONVERTNapiTypedArrayType
  }
}

inline napi_typedarray_type JSTypedarrTypeToNapiType(JSVM_TypedarrayType type) {
  switch (type) {
#define CONVERT_JSTYPED_ARRAY_TYPE(output, input) \
  case JSVM_##input##_ARRAY:                      \
    return napi_##output##_array;
    TYPEDARRAY_TYPE(CONVERT_JSTYPED_ARRAY_TYPE);
#undef CONVERT_JSTYPED_ARRAY_TYPE
  }
}
}  // namespace harmonyimpl

struct napi_context__harmony {
  using FinalizerListIter =
      std::list<harmonyimpl::ExternalNativeInfo*>::const_iterator;
  using ReferenceListIter = std::list<harmonyimpl::Reference*>::const_iterator;

  napi_context__harmony(napi_env env, JSVM_Env js_vm_env)
      : env_{env},
        vm_env_{js_vm_env} {

        };
  ~napi_context__harmony() {
    for (auto it = ref_list_.begin(); it != ref_list_.end();) {
      auto next = std::next(it);
      (*it)->ClearReference();
      it = next;
    }
    for (auto& data : instance_data_) {
      harmonyimpl::ExternalNativeInfo::Delete(vm_env_, data.second, nullptr);
    }
    for (auto finalizer : std::vector<harmonyimpl::ExternalNativeInfo*>(
             std::begin(finalizer_list_), std::end(finalizer_list_))) {
      finalizer->CallFinalizer();
    }
    return;
  }

  auto AddFinalizer(harmonyimpl::ExternalNativeInfo* info) {
    return finalizer_list_.insert(finalizer_list_.end(), info);
  }

  void DeleteFinalizer(FinalizerListIter pos) {
    finalizer_list_.erase(pos);
    return;
  }

  auto AddReference(harmonyimpl::Reference* reference) {
    return ref_list_.insert(ref_list_.end(), reference);
  }

  void DeleteReference(ReferenceListIter pos) { ref_list_.erase(pos); }

  template <typename T, typename U = std::function<void(napi_env, JSVM_Value)>>
  void CallInToModule(T&& call) {
    [[maybe_unused]] int32_t opend_handle_scopes_old = open_handle_scopes_;
    napi_clear_last_error(env_);
    std::forward<T>(call)(env_);
    assert(opend_handle_scopes_old == open_handle_scopes_);
    return;
  }

  napi_env env_;
  JSVM_Env vm_env_;
  int32_t open_handle_scopes_ = 0;
  std::unordered_map<uint64_t, harmonyimpl::ExternalNativeInfo*> instance_data_;
  std::list<harmonyimpl::ExternalNativeInfo*> finalizer_list_;
  std::list<harmonyimpl::Reference*> ref_list_;
};

namespace harmonyimpl {}  // namespace harmonyimpl

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif

#endif
