
#include "js_native_api_harmony.h"

#include <ark_runtime/jsvm.h>
#include <ark_runtime/jsvm_types.h>
#include <assert.h>

#include <string>

#include "harmony/napi_env_harmony.h"
#include "js_native_api.h"
#include "js_native_api_types.h"
#include "napi_state.h"

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif

#include "basic/log/logging.h"

#if ENABLE_UNITTESTS
static std::string ConvertValueToStr(JSVM_Env env, JSVM_Value obj) {
  JSVM_Value json, str;
  OH_JSVM_JsonStringify(env, obj, &json);

  OH_JSVM_CoerceToString(env, json, &str);
  size_t len;
  OH_JSVM_GetValueStringUtf8(env, str, nullptr, 0, &len);
  std::string result;
  result.resize(len + 1);
  OH_JSVM_GetValueStringUtf8(env, str, result.data(), result.size(), nullptr);
  return result;
}

[[maybe_unused]] static void LogAllproperties(JSVM_Env env, JSVM_Value object) {
  JSVM_Value names;
  OH_JSVM_GetAllPropertyNames(env, object, JSVM_KEY_INCLUDE_PROTOTYPES,
                              JSVM_KEY_ALL_PROPERTIES,
                              JSVM_KEY_NUMBERS_TO_STRINGS, &names);
  LOGE(ConvertValueToStr(env, names));
  return;
}
#endif

namespace harmonyimpl {

static std::string GetExceptionMessage(JSVM_Env env, JSVM_Value exception) {
  std::string ret;
  JSVM_Value stack, message;
  OH_JSVM_GetNamedProperty(env, exception, "stack", &stack);
  OH_JSVM_GetNamedProperty(env, exception, "message", &message);
  char buffer[256];
  OH_JSVM_GetValueStringUtf8(env, message, buffer, sizeof(buffer), nullptr);
  ret += buffer;
  OH_JSVM_GetValueStringUtf8(env, stack, buffer, sizeof(buffer), nullptr);
  return ret + "\n" + buffer;
}

ExternalNativeInfo::ExternalNativeInfo(napi_env env, napi_finalize fcb,
                                       void *data, void *finalize_hint)
    : env_{env}, finalize_cb_{fcb}, data_{data}, hint_{finalize_hint} {
  pos_ = env_->ctx->AddFinalizer(this);
}

void ExternalNativeInfo::CallFinalizer() {
  if (finalize_cb_) {
    napi_finalize cb = std::exchange(finalize_cb_, cb);
    HandleScopeWrapper func_scope{env_->ctx->vm_env_};
    cb(env_, data_, hint_);
  }
  if (!is_finalized_) {
    env_->ctx->DeleteFinalizer(pos_);
    is_finalized_ = true;
  }
  finalize_cb_ = nullptr;
  return;
}

ExternalNativeInfo::~ExternalNativeInfo() {
  CallFinalizer();
  return;
}

void ExternalNativeInfo::Delete(JSVM_Env env, void *data, void *hint) {
  delete reinterpret_cast<ExternalNativeInfo *>(data);
}

ExternalNativeInfo *ExternalNativeInfo::Create(napi_env env, napi_finalize fcb,
                                               void *data, void *hint) {
  return new ExternalNativeInfo(env, fcb, data, hint);
}

Reference::Reference(napi_env env, JSVM_Value ref, uint32_t rc) : env_{env} {
  OH_JSVM_CreateReference(env->ctx->vm_env_, ref, rc, &ref_);
  iter_ = env->ctx->AddReference(this);
  return;
}

Reference::Reference(napi_env env, JSVM_Ref ref) : env_{env}, ref_{ref} {
  iter_ = env->ctx->AddReference(this);
}

Reference::~Reference() {
  if (ref_) {
    ClearReference();
  }
}

uint32_t Reference::Ref() {
  uint32_t rc = 0;
  if (ref_) {
    OH_JSVM_ReferenceRef(env_->ctx->vm_env_, ref_, &rc);
  }
  return rc;
}

uint32_t Reference::UnRef() {
  uint32_t rc = 0;
  if (ref_) OH_JSVM_ReferenceUnref(env_->ctx->vm_env_, ref_, &rc);
  return rc;
}

JSVM_Value Reference::GetValue() {
  JSVM_Value val = nullptr;
  if (ref_) {
    OH_JSVM_GetReferenceValue(env_->ctx->vm_env_, ref_, &val);
  }
  return val;
}

void Reference::ClearReference() {
  if (ref_) {
    JSVM_Ref old_ref = std::exchange(ref_, nullptr);
    env_->ctx->DeleteReference(iter_);
    OH_JSVM_DeleteReference(env_->ctx->vm_env_, old_ref);
  }
  return;
}

struct FunctionWrapper {
  FunctionWrapper(napi_env env, napi_callback cb, void *data)
      : env_{env}, cb_{cb}, data_{data} {}

  JSVM_Value Call(JSVM_CallbackInfo info) {
    napi_callback_info__harmony cbinfo{
        .jsvm_cb_info = info, .napi_data = data_, .thiz = nullptr};
    return NapiValueToJS(CallNapiFunction(env_, cb_, &cbinfo));
  }

  static napi_value CallNapiFunction(napi_env env, napi_callback cb,
                                     napi_callback_info info) {
    napi_value result = nullptr;
    env->ctx->CallInToModule([&](napi_env env) { result = cb(env, info); });
    return result;
  }

  static JSVM_Value NapiFunctionCallbackWrapper(JSVM_Env env,
                                                JSVM_CallbackInfo info) {
    FunctionWrapper *data;
    OH_JSVM_GetCbInfo(env, info, nullptr, nullptr, nullptr,
                      reinterpret_cast<void **>(&data));
    return data->Call(info);
  }

  static JSVM_Callback CreateVMCallback(napi_env env, napi_callback cb,
                                        void *data) {
    auto *ret = new JSVM_CallbackStruct;
    ret->callback = &FunctionWrapper::NapiFunctionCallbackWrapper;
    ret->data = new FunctionWrapper{env, cb, data};
    return ret;
  }

  static void VMCallbackFinalizer(void *finalize_data) {
    auto *cb_struct = reinterpret_cast<JSVM_CallbackStruct *>(finalize_data);
    delete reinterpret_cast<FunctionWrapper *>(cb_struct->data);
    delete cb_struct;
  }

  napi_env env_;
  napi_callback cb_;
  void *data_;
};

static JSVM_PropertyDescriptor NapiPropertyDescToJS(
    napi_env env, const napi_property_descriptor &desc) {
  return {
      .utf8name = desc.utf8name,
      .name = NapiValueToJS(desc.name),
      .method = desc.method ? FunctionWrapper::CreateVMCallback(
                                  env, desc.method, desc.data)
                            : nullptr,
      .getter = desc.getter ? FunctionWrapper::CreateVMCallback(
                                  env, desc.getter, desc.data)
                            : nullptr,
      .setter = desc.setter ? FunctionWrapper::CreateVMCallback(
                                  env, desc.setter, desc.data)
                            : nullptr,
      .value = NapiValueToJS(desc.value),
      .attributes = NapiPropertyAttrToJS(desc.attributes),
  };
}

static void FreeJSVMPropertyDesc(const JSVM_PropertyDescriptor &desc) {
  if (desc.getter) FunctionWrapper::VMCallbackFinalizer(desc.getter);
  if (desc.method) FunctionWrapper::VMCallbackFinalizer(desc.method);
  if (desc.setter) FunctionWrapper::VMCallbackFinalizer(desc.setter);
  return;
}

struct ConstructorWrapper {
 public:
  static ConstructorWrapper *Create(
      napi_env env, napi_callback cb, void *data, size_t property_cnt,
      const napi_property_descriptor *napi_props) {
    return new ConstructorWrapper(env, cb, data, property_cnt, napi_props);
  }

  static void Finalizer(void *finalize_data) {
    delete reinterpret_cast<ConstructorWrapper *>(finalize_data);
    return;
  }

  JSVM_Callback GetJsConstructorCallBack() const {
    return js_constructor_.get();
  }

  size_t GetPropertyCnt() const { return property_count_; }
  const JSVM_PropertyDescriptor *GetProperties() const { return props_.data(); }

  void SetPrototype(JSVM_Value prototype) {
    proto_ = new Reference(env_, prototype, 1);
    return;
  }

 private:
  ConstructorWrapper(napi_env env, napi_callback constructor, void *data,
                     size_t property_cnt, const napi_property_descriptor *props)
      : env_{env},
        constructor_{constructor},
        data_{data},
        property_count_{property_cnt} {
    js_constructor_ = std::make_unique<JSVM_CallbackStruct>();
    js_constructor_->callback = &ConstructorCallbackWrapper;
    js_constructor_->data = this;

    props_.resize(property_count_);
    for (size_t i = 0; i < property_count_; ++i) {
      props_[i] = NapiPropertyDescToJS(env, props[i]);
    }
    return;
  }
  ~ConstructorWrapper() {
    delete proto_;
    for (size_t i = 0; i < property_count_; ++i) {
      FreeJSVMPropertyDesc(props_[i]);
    }
  }

  JSVM_Value CallNapiConstructor(JSVM_CallbackInfo cbinfo) {
    // JSVM_Value thiz;
    // auto *js_env = env_->ctx->js_vm_env_;
    // OH_JSVM_CreateObject(js_env, &thiz);
    napi_callback_info__harmony napi_cbinfo = {
        .jsvm_cb_info = cbinfo, .napi_data = data_, .thiz = nullptr};
    auto ret = NapiValueToJS(
        FunctionWrapper::CallNapiFunction(env_, constructor_, &napi_cbinfo));

    if (ret) {
      OH_JSVM_ObjectSetPrototypeOf(env_->ctx->vm_env_, ret, proto_->GetValue());
    }
    return ret;
  }

  static JSVM_Value ConstructorCallbackWrapper(JSVM_Env env,
                                               JSVM_CallbackInfo cbinfo) {
    ConstructorWrapper *class_data;
    OH_JSVM_GetCbInfo(env, cbinfo, nullptr, nullptr, nullptr,
                      (void **)&class_data);
    return class_data->CallNapiConstructor(cbinfo);
  }

  napi_env env_;
  napi_callback constructor_;
  void *data_;
  Reference *proto_;

  std::unique_ptr<JSVM_CallbackStruct> js_constructor_;
  size_t property_count_;
  std::vector<JSVM_PropertyDescriptor> props_;
};

static napi_status CheckAndSetException(napi_env env, JSVM_Status status,
                                        const char *func) {
  auto *vm_env = env->ctx->vm_env_;
  const JSVM_ExtendedErrorInfo *error;
  OH_JSVM_GetLastErrorInfo(vm_env, &error);
  std::string error_message(error->errorMessage);
  auto error_code = error->errorCode;
  LOGE("JSVM_Call  " << func << " failed, return status: " << status
                     << ", error code is " << error_code
                     << ", error message is " << error_message);
  return JSStatusToNapi(status);
}

#define CALL_JSVM(func_call)                                \
  if (auto jsvm_ret = (func_call); jsvm_ret != JSVM_OK) {   \
    return CheckAndSetException(env, jsvm_ret, #func_call); \
  }

static napi_status napi_get_undefined(napi_env env, napi_value *result) {
  JSVM_Value js_undef;
  CALL_JSVM(OH_JSVM_GetUndefined(env->ctx->vm_env_, &js_undef))
  *result = JSValueToNapi(js_undef);
  return napi_clear_last_error(env);
}

static napi_status napi_get_null(napi_env env, napi_value *result) {
  JSVM_Value js_nul;
  CALL_JSVM(OH_JSVM_GetNull(env->ctx->vm_env_, &js_nul));
  *result = JSValueToNapi(js_nul);
  return napi_clear_last_error(env);
}

static napi_status napi_get_global(napi_env env, napi_value *result) {
  JSVM_Value global;
  CALL_JSVM(OH_JSVM_GetGlobal(env->ctx->vm_env_, &global));
  *result = JSValueToNapi(global);
  return napi_clear_last_error(env);
}

static napi_status napi_get_boolean(napi_env env, bool value,
                                    napi_value *result) {
  JSVM_Value boolean;
  CALL_JSVM(OH_JSVM_GetBoolean(env->ctx->vm_env_, value, &boolean));
  *result = JSValueToNapi(boolean);
  return napi_clear_last_error(env);
}

static napi_status napi_create_object(napi_env env, napi_value *result) {
  JSVM_Value object;
  CALL_JSVM(OH_JSVM_CreateObject(env->ctx->vm_env_, &object));
  *result = JSValueToNapi(object);
  return napi_clear_last_error(env);
}

static napi_status napi_create_array(napi_env env, napi_value *result) {
  JSVM_Value object;
  CALL_JSVM(OH_JSVM_CreateArray(env->ctx->vm_env_, &object));
  *result = JSValueToNapi(object);
  return napi_clear_last_error(env);
}

static napi_status napi_create_array_with_length(napi_env env, size_t length,
                                                 napi_value *result) {
  JSVM_Value array;
  CALL_JSVM(OH_JSVM_CreateArrayWithLength(env->ctx->vm_env_, length, &array))
  *result = JSValueToNapi(array);
  return napi_clear_last_error(env);
}

static napi_status napi_create_double(napi_env env, double value,
                                      napi_value *result) {
  JSVM_Value ret;
  CALL_JSVM(OH_JSVM_CreateDouble(env->ctx->vm_env_, value, &ret));
  *result = JSValueToNapi(ret);
  return napi_clear_last_error(env);
}

static napi_status napi_create_int32(napi_env env, int32_t value,
                                     napi_value *result) {
  JSVM_Value ret;
  CALL_JSVM(OH_JSVM_CreateInt32(env->ctx->vm_env_, value, &ret));
  *result = JSValueToNapi(ret);
  return napi_clear_last_error(env);
}

static napi_status napi_create_uint32(napi_env env, uint32_t value,
                                      napi_value *result) {
  JSVM_Value ret;
  CALL_JSVM(OH_JSVM_CreateUint32(env->ctx->vm_env_, value, &ret));
  *result = JSValueToNapi(ret);
  return napi_clear_last_error(env);
}

static napi_status napi_create_int64(napi_env env, int64_t value,
                                     napi_value *result) {
  JSVM_Value ret;
  CALL_JSVM(OH_JSVM_CreateInt64(env->ctx->vm_env_, value, &ret));
  *result = JSValueToNapi(ret);
  return napi_clear_last_error(env);
}

static napi_status napi_create_string_latin1(napi_env env, const char *str,
                                             size_t length,
                                             napi_value *result) {
  JSVM_Value ret;
  CALL_JSVM(OH_JSVM_CreateStringLatin1(env->ctx->vm_env_, str, length, &ret));
  *result = JSValueToNapi(ret);
  return napi_clear_last_error(env);
}

static napi_status napi_create_string_utf8(napi_env env, const char *str,
                                           size_t length, napi_value *result) {
  JSVM_Value ret;
  CALL_JSVM(OH_JSVM_CreateStringUtf8(env->ctx->vm_env_, str, length, &ret));
  *result = JSValueToNapi(ret);
  return napi_clear_last_error(env);
}

static napi_status napi_create_string_utf16(napi_env env, const char16_t *str,
                                            size_t length, napi_value *result) {
  JSVM_Value ret;
  CALL_JSVM(OH_JSVM_CreateStringUtf16(env->ctx->vm_env_, str, length, &ret));
  *result = JSValueToNapi(ret);
  return napi_clear_last_error(env);
}

static napi_status napi_create_symbol(napi_env env, napi_value descripton,
                                      napi_value *result) {
  JSVM_Value ret;
  CALL_JSVM(
      OH_JSVM_CreateSymbol(env->ctx->vm_env_, NapiValueToJS(descripton), &ret));
  *result = JSValueToNapi(ret);
  return napi_clear_last_error(env);
}

static napi_status napi_create_function(napi_env env, const char *utf8name,
                                        size_t length, napi_callback cb,
                                        void *data, napi_value *result) {
  JSVM_Value func;
  auto *jsvm_cb = FunctionWrapper::CreateVMCallback(env, cb, data);

  CALL_JSVM(OH_JSVM_CreateFunction(env->ctx->vm_env_, utf8name, length, jsvm_cb,
                                   &func));
  CALL_JSVM(OH_JSVM_AddFinalizer(
      env->ctx->vm_env_, func, reinterpret_cast<void *>(jsvm_cb),
      [](JSVM_Env env, void *data, void *hint) {
        FunctionWrapper::VMCallbackFinalizer(data);
      },
      nullptr, nullptr));
  *result = JSValueToNapi(func);
  return napi_clear_last_error(env);
}

static napi_status napi_create_error(napi_env env, napi_value code,
                                     napi_value msg, napi_value *result) {
  JSVM_Value js_result;
  CALL_JSVM(OH_JSVM_CreateError(env->ctx->vm_env_, NapiValueToJS(code),
                                NapiValueToJS(msg), &js_result));
  *result = JSValueToNapi(js_result);
  return napi_clear_last_error(env);
}

static napi_status napi_create_type_error(napi_env env, napi_value code,
                                          napi_value msg, napi_value *result) {
  JSVM_Value js_result;
  CALL_JSVM(OH_JSVM_CreateTypeError(env->ctx->vm_env_, NapiValueToJS(code),
                                    NapiValueToJS(msg), &js_result));
  *result = JSValueToNapi(js_result);
  return napi_clear_last_error(env);
}

static napi_status napi_create_range_error(napi_env env, napi_value code,
                                           napi_value msg, napi_value *result) {
  JSVM_Value js_result;
  CALL_JSVM(OH_JSVM_CreateRangeError(env->ctx->vm_env_, NapiValueToJS(code),
                                     NapiValueToJS(msg), &js_result));
  *result = JSValueToNapi(js_result);
  return napi_clear_last_error(env);
}

static napi_status napi_typeof(napi_env env, napi_value value,
                               napi_valuetype *result) {
  JSVM_ValueType type;
  CALL_JSVM(OH_JSVM_Typeof(env->ctx->vm_env_, NapiValueToJS(value), &type));
  *result = NapiValueTypeFromJSValueType(type);
  return napi_clear_last_error(env);
}

static napi_status napi_get_value_double(napi_env env, napi_value value,
                                         double *result) {
  CALL_JSVM(
      OH_JSVM_GetValueDouble(env->ctx->vm_env_, NapiValueToJS(value), result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_value_int32(napi_env env, napi_value value,
                                        int32_t *result) {
  CALL_JSVM(
      OH_JSVM_GetValueInt32(env->ctx->vm_env_, NapiValueToJS(value), result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_value_uint32(napi_env env, napi_value value,
                                         uint32_t *result) {
  CALL_JSVM(
      OH_JSVM_GetValueUint32(env->ctx->vm_env_, NapiValueToJS(value), result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_value_int64(napi_env env, napi_value value,
                                        int64_t *result) {
  CALL_JSVM(
      OH_JSVM_GetValueInt64(env->ctx->vm_env_, NapiValueToJS(value), result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_value_bool(napi_env env, napi_value value,
                                       bool *result) {
  CALL_JSVM(
      OH_JSVM_GetValueBool(env->ctx->vm_env_, NapiValueToJS(value), result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_value_string_latin1(napi_env env, napi_value value,
                                                char *buf, size_t bufsize,
                                                size_t *result) {
  CALL_JSVM(OH_JSVM_GetValueStringLatin1(
      env->ctx->vm_env_, NapiValueToJS(value), buf, bufsize, result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_value_string_utf8(napi_env env, napi_value value,
                                              char *buf, size_t bufsize,
                                              size_t *result) {
  CALL_JSVM(OH_JSVM_GetValueStringUtf8(env->ctx->vm_env_, NapiValueToJS(value),
                                       buf, bufsize, result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_value_string_utf16(napi_env env, napi_value value,
                                               char16_t *buf, size_t bufsize,
                                               size_t *result) {
  CALL_JSVM(OH_JSVM_GetValueStringUtf16(env->ctx->vm_env_, NapiValueToJS(value),
                                        buf, bufsize, result));
  return napi_clear_last_error(env);
}

static napi_status napi_coerce_to_bool(napi_env env, napi_value value,
                                       napi_value *result) {
  JSVM_Value js_result;
  CALL_JSVM(
      OH_JSVM_CoerceToBool(env->ctx->vm_env_, NapiValueToJS(value), &js_result))
  *result = JSValueToNapi(js_result);
  return napi_clear_last_error(env);
}

static napi_status napi_coerce_to_number(napi_env env, napi_value value,
                                         napi_value *result) {
  CALL_JSVM(OH_JSVM_CoerceToNumber(env->ctx->vm_env_, NapiValueToJS(value),
                                   reinterpret_cast<JSVM_Value *>(result)));
  return napi_clear_last_error(env);
}

static napi_status napi_coerce_to_object(napi_env env, napi_value value,
                                         napi_value *result) {
  CALL_JSVM(OH_JSVM_CoerceToObject(env->ctx->vm_env_, NapiValueToJS(value),
                                   reinterpret_cast<JSVM_Value *>(result)));
  return napi_clear_last_error(env);
}

static napi_status napi_coerce_to_string(napi_env env, napi_value value,
                                         napi_value *result) {
  CALL_JSVM(OH_JSVM_CoerceToString(env->ctx->vm_env_, NapiValueToJS(value),
                                   reinterpret_cast<JSVM_Value *>(result)));
  return napi_clear_last_error(env);
}

static napi_status napi_get_prototype(napi_env env, napi_value object,
                                      napi_value *result) {
  CALL_JSVM(OH_JSVM_GetPrototype(env->ctx->vm_env_, NapiValueToJS(object),
                                 NapiValuePointerToJS(result)));
  return napi_clear_last_error(env);
}

static napi_status napi_get_property_names(napi_env env, napi_value object,
                                           napi_value *result) {
  CALL_JSVM(OH_JSVM_GetPropertyNames(env->ctx->vm_env_, NapiValueToJS(object),
                                     NapiValuePointerToJS(result)));
  return napi_clear_last_error(env);
}

static napi_status napi_set_property(napi_env env, napi_value object,
                                     napi_value key, napi_value value) {
  CALL_JSVM(OH_JSVM_SetProperty(env->ctx->vm_env_, NapiValueToJS(object),
                                NapiValueToJS(key), NapiValueToJS(value)));
  return napi_clear_last_error(env);
}

static napi_status napi_has_property(napi_env env, napi_value object,
                                     napi_value key, bool *result) {
  CALL_JSVM(OH_JSVM_HasProperty(env->ctx->vm_env_, NapiValueToJS(object),
                                NapiValueToJS(key), result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_property(napi_env env, napi_value object,
                                     napi_value key, napi_value *result) {
  CALL_JSVM(OH_JSVM_GetProperty(env->ctx->vm_env_, NapiValueToJS(object),
                                NapiValueToJS(key),
                                NapiValuePointerToJS(result)));
  return napi_clear_last_error(env);
}

static napi_status napi_delete_property(napi_env env, napi_value object,
                                        napi_value key, bool *result) {
  CALL_JSVM(OH_JSVM_DeleteProperty(env->ctx->vm_env_, NapiValueToJS(object),
                                   NapiValueToJS(key), result));
  return napi_clear_last_error(env);
}

static napi_status napi_has_own_property(napi_env env, napi_value object,
                                         napi_value key, bool *result) {
  CALL_JSVM(OH_JSVM_HasOwnProperty(env->ctx->vm_env_, NapiValueToJS(object),
                                   NapiValueToJS(key), result));
  return napi_clear_last_error(env);
}

static napi_status napi_set_named_property(napi_env env, napi_value object,
                                           const char *utf8name,
                                           napi_value value) {
  CALL_JSVM(OH_JSVM_SetNamedProperty(env->ctx->vm_env_, NapiValueToJS(object),
                                     utf8name, NapiValueToJS(value)));
  return napi_clear_last_error(env);
}

static napi_status napi_has_named_property(napi_env env, napi_value object,
                                           const char *utf8name, bool *result) {
  CALL_JSVM(OH_JSVM_HasNamedProperty(env->ctx->vm_env_, NapiValueToJS(object),
                                     utf8name, result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_named_property(napi_env env, napi_value object,
                                           const char *utf8name,
                                           napi_value *result) {
  CALL_JSVM(OH_JSVM_GetNamedProperty(env->ctx->vm_env_, NapiValueToJS(object),
                                     utf8name, NapiValuePointerToJS(result)));
  return napi_clear_last_error(env);
}

static napi_status napi_set_element(napi_env env, napi_value object,
                                    uint32_t idx, napi_value value) {
  CALL_JSVM(OH_JSVM_SetElement(env->ctx->vm_env_, NapiValueToJS(object), idx,
                               NapiValueToJS(value)));
  return napi_clear_last_error(env);
}

static napi_status napi_get_element(napi_env env, napi_value object,
                                    uint32_t idx, napi_value *resutl) {
  CALL_JSVM(OH_JSVM_GetElement(env->ctx->vm_env_, NapiValueToJS(object), idx,
                               NapiValuePointerToJS(resutl)));
  return napi_clear_last_error(env);
}

static napi_status napi_has_element(napi_env env, napi_value object,
                                    uint32_t idx, bool *result) {
  CALL_JSVM(OH_JSVM_HasElement(env->ctx->vm_env_, NapiValueToJS(object), idx,
                               result));
  return napi_clear_last_error(env);
}

static napi_status napi_delete_element(napi_env env, napi_value object,
                                       uint32_t idx, bool *result) {
  CALL_JSVM(OH_JSVM_DeleteElement(env->ctx->vm_env_, NapiValueToJS(object), idx,
                                  result));
  return napi_clear_last_error(env);
}

static napi_status napi_define_properties(
    napi_env env, napi_value object, size_t property_count,
    const napi_property_descriptor *properties) {
  struct js_define_props_data {
    size_t size;
    JSVM_PropertyDescriptor *props;
  };
  JSVM_PropertyDescriptor *property_descs =
      new JSVM_PropertyDescriptor[property_count];
  for (size_t i = 0; i < property_count; ++i) {
    property_descs[i] = NapiPropertyDescToJS(env, properties[i]);
  }
  auto *finalize_data =
      new js_define_props_data{property_count, property_descs};

  CALL_JSVM(OH_JSVM_DefineProperties(env->ctx->vm_env_, NapiValueToJS(object),
                                     property_count, property_descs));

  CALL_JSVM(OH_JSVM_AddFinalizer(
      env->ctx->vm_env_, NapiValueToJS(object), finalize_data,
      [](JSVM_Env env, void *finalizeData, void *finalizeHint) {
        auto *data = reinterpret_cast<js_define_props_data *>(finalizeData);
        for (size_t i = 0; i < data->size; ++i) {
          FreeJSVMPropertyDesc(data->props[i]);
        }
        delete[] data->props;
        delete data;
      },
      nullptr, nullptr));
  return napi_clear_last_error(env);
}

static napi_status napi_is_array(napi_env env, napi_value value, bool *result) {
  CALL_JSVM(OH_JSVM_IsArray(env->ctx->vm_env_, NapiValueToJS(value), result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_array_length(napi_env env, napi_value value,
                                         uint32_t *result) {
  CALL_JSVM(
      OH_JSVM_GetArrayLength(env->ctx->vm_env_, NapiValueToJS(value), result));
  return napi_clear_last_error(env);
}

static napi_status napi_strict_equals(napi_env env, napi_value lhs,
                                      napi_value rhs, bool *result) {
  CALL_JSVM(OH_JSVM_StrictEquals(env->ctx->vm_env_, NapiValueToJS(lhs),
                                 NapiValueToJS(rhs), result));
  return napi_clear_last_error(env);
}

static napi_status napi_call_function(napi_env env, napi_value recv,
                                      napi_value func, size_t argc,
                                      const napi_value *argv,
                                      napi_value *result) {
  CALL_JSVM(OH_JSVM_CallFunction(
      env->ctx->vm_env_, NapiValueToJS(recv), NapiValueToJS(func), argc,
      ConstNapiValuePointerToJS(argv), NapiValuePointerToJS(result)));
  return napi_clear_last_error(env);
}

static napi_status napi_new_instance(napi_env env, napi_value constructor,
                                     size_t argc, const napi_value *argv,
                                     napi_value *result) {
  CALL_JSVM(OH_JSVM_NewInstance(env->ctx->vm_env_, NapiValueToJS(constructor),
                                argc, ConstNapiValuePointerToJS(argv),
                                NapiValuePointerToJS(result)));
  return napi_clear_last_error(env);
}

static napi_status napi_instanceof(napi_env env, napi_value object,
                                   napi_value constructor, bool *result) {
  CALL_JSVM(OH_JSVM_Instanceof(env->ctx->vm_env_, NapiValueToJS(object),
                               NapiValueToJS(constructor), result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_cb_info(napi_env env, napi_callback_info cbinfo,
                                    size_t *argc, napi_value *argv,
                                    napi_value *this_arg, void **data) {
  if (data) {
    *data = cbinfo->napi_data;
  }

  if (cbinfo->thiz) {
    CALL_JSVM(OH_JSVM_GetCbInfo(env->ctx->vm_env_, cbinfo->jsvm_cb_info, argc,
                                NapiValuePointerToJS(argv), nullptr, nullptr));
    if (this_arg) *this_arg = JSValueToNapi(cbinfo->thiz);
  } else {
    CALL_JSVM(OH_JSVM_GetCbInfo(env->ctx->vm_env_, cbinfo->jsvm_cb_info, argc,
                                NapiValuePointerToJS(argv),
                                NapiValuePointerToJS(this_arg), nullptr));
  }

  return napi_clear_last_error(env);
}

static napi_status napi_get_new_target(napi_env env, napi_callback_info cbinfo,
                                       napi_value *result) {
  CALL_JSVM(OH_JSVM_GetNewTarget(env->ctx->vm_env_, cbinfo->jsvm_cb_info,
                                 NapiValuePointerToJS(result)));
  return napi_clear_last_error(env);
}

static napi_status napi_define_class(napi_env env, const char *utf8name,
                                     size_t length, napi_callback constructor,
                                     void *data, size_t property_count,
                                     const napi_property_descriptor *properties,
                                     napi_class super_clazz,
                                     napi_class *result) {
  auto *js_env = env->ctx->vm_env_;

  auto *native_class_data = ConstructorWrapper::Create(
      env, constructor, data, property_count, properties);

  JSVM_Value result_clazz;

  CALL_JSVM(OH_JSVM_DefineClass(
      js_env, utf8name, length, native_class_data->GetJsConstructorCallBack(),
      property_count, native_class_data->GetProperties(), &result_clazz));

  CALL_JSVM(OH_JSVM_AddFinalizer(
      js_env, result_clazz, native_class_data,
      [](JSVM_Env env, void *finalize_data, void *finalize_hint) {
        ConstructorWrapper::Finalizer(finalize_data);
      },
      nullptr, nullptr));

  JSVM_Value prototype;
  static const char *proto_name = "prototype";
  CALL_JSVM(
      OH_JSVM_GetNamedProperty(js_env, result_clazz, proto_name, &prototype));

  if (super_clazz) {
    OH_JSVM_ObjectSetPrototypeOf(js_env, result_clazz,
                                 super_clazz->GetFunction());
    OH_JSVM_ObjectSetPrototypeOf(js_env, prototype,
                                 super_clazz->GetPrototype());
  }

  *result = new napi_class__harmony(js_env, result_clazz, prototype);
  native_class_data->SetPrototype(prototype);

  return napi_clear_last_error(env);
}

static napi_status napi_release_class(napi_env env, napi_class clazz) {
  delete reinterpret_cast<napi_class__harmony *>(clazz);
  return napi_ok;
}

static napi_status napi_class_get_function(napi_env env, napi_class clazz,
                                           napi_value *result) {
  *result = JSValueToNapi(clazz->GetFunction());
  return napi_ok;
}

static napi_status napi_wrap(napi_env env, napi_value js_object,
                             void *native_object, napi_finalize finalize_cb,
                             void *finalize_hint, napi_ref *result) {
  auto *napi_wrap_data = ExternalNativeInfo::Create(
      env, finalize_cb, native_object, finalize_hint);
  JSVM_Ref ref;
  CALL_JSVM(OH_JSVM_Wrap(env->ctx->vm_env_, NapiValueToJS(js_object),
                         napi_wrap_data, ExternalNativeInfo::Delete, nullptr,
                         &ref));
  if (result) *result = JSRefToNapi(new Reference(env, ref));

  return napi_clear_last_error(env);
}

static napi_status napi_unwrap(napi_env env, napi_value js_object,
                               void **result) {
  if (result == nullptr) return napi_clear_last_error(env);
  ExternalNativeInfo *napi_finalizer = nullptr;
  *result = nullptr;
  auto status = OH_JSVM_Unwrap(env->ctx->vm_env_, NapiValueToJS(js_object),
                               (void **)&napi_finalizer);
  if (status == JSVM_OK && napi_finalizer) {
    *result = (void *)napi_finalizer->Data();
  }
  return napi_clear_last_error(env);
}

static napi_status napi_remove_wrap(napi_env env, napi_value js_object,
                                    void **result) {
  ExternalNativeInfo *native_info;
  CALL_JSVM(OH_JSVM_RemoveWrap(env->ctx->vm_env_, NapiValueToJS(js_object),
                               (void **)(&native_info)));
  native_info->ClearFinalizer();
  ExternalNativeInfo::Delete(nullptr, native_info, nullptr);
  return napi_clear_last_error(env);
}

static napi_status napi_create_external(napi_env env, void *data,
                                        napi_finalize finalize_cb,
                                        void *finalize_hint,
                                        napi_value *result) {
  JSVM_Value js_value;

  CALL_JSVM(OH_JSVM_CreateExternal(
      env->ctx->vm_env_,
      ExternalNativeInfo::Create(env, finalize_cb, data, finalize_hint),
      ExternalNativeInfo::Delete, nullptr, &js_value));

  *result = JSValueToNapi(js_value);
  return napi_clear_last_error(env);
}

static napi_status napi_get_value_external(napi_env env, napi_value value,
                                           void **result) {
  ExternalNativeInfo *native_info;
  CALL_JSVM(OH_JSVM_GetValueExternal(env->ctx->vm_env_, NapiValueToJS(value),
                                     (void **)&native_info));
  *result = native_info->Data();
  return napi_clear_last_error(env);
}

static napi_status napi_create_reference(napi_env env, napi_value value,
                                         uint32_t initial_refcount,
                                         napi_ref *result) {
  if (result)
    *result =
        JSRefToNapi(new Reference(env, NapiValueToJS(value), initial_refcount));
  return napi_clear_last_error(env);
}

static napi_status napi_delete_reference(napi_env env, napi_ref ref) {
  delete NapiRefToJS(ref);
  return napi_clear_last_error(env);
}

static napi_status napi_reference_ref(napi_env env, napi_ref ref,
                                      uint32_t *result) {
  *result = NapiRefToJS(ref)->Ref();
  return napi_clear_last_error(env);
}

static napi_status napi_reference_unref(napi_env env, napi_ref ref,
                                        uint32_t *result) {
  *result = NapiRefToJS(ref)->UnRef();
  return napi_clear_last_error(env);
}

static napi_status napi_get_reference_value(napi_env env, napi_ref ref,
                                            napi_value *result) {
  *result = JSValueToNapi(NapiRefToJS(ref)->GetValue());
  return napi_clear_last_error(env);
}

static napi_status napi_open_handle_scope(napi_env env,
                                          napi_handle_scope *result) {
  JSVM_HandleScope handle;
  CALL_JSVM(OH_JSVM_OpenHandleScope(env->ctx->vm_env_, &handle));
  *result = JSHandleScopeToNapi(handle);
  env->ctx->open_handle_scopes_++;
  return napi_clear_last_error(env);
}

static napi_status napi_close_handle_scope(napi_env env,
                                           napi_handle_scope result) {
  JSVM_HandleScope js_handle = NapiHandleScopeToJS(result);
  CALL_JSVM(OH_JSVM_CloseHandleScope(env->ctx->vm_env_, js_handle));
  env->ctx->open_handle_scopes_--;
  return napi_clear_last_error(env);
}

static napi_status napi_open_escapable_handle_scope(
    napi_env env, napi_escapable_handle_scope *result) {
  JSVM_EscapableHandleScope handle;
  CALL_JSVM(OH_JSVM_OpenEscapableHandleScope(env->ctx->vm_env_, &handle));
  *result = JSEscapableHandleToNapi(handle);

  env->ctx->open_handle_scopes_++;
  return napi_clear_last_error(env);
}

static napi_status napi_close_escapable_handle_scope(
    napi_env env, napi_escapable_handle_scope result) {
  JSVM_EscapableHandleScope js_handle = NapiEscapableHandleToJS(result);

  CALL_JSVM(OH_JSVM_CloseEscapableHandleScope(env->ctx->vm_env_, js_handle));
  env->ctx->open_handle_scopes_--;
  return napi_clear_last_error(env);
}

static napi_status napi_escape_handle(napi_env env,
                                      napi_escapable_handle_scope scope,
                                      napi_value escape, napi_value *result) {
  JSVM_Value ret;
  CALL_JSVM(OH_JSVM_EscapeHandle(env->ctx->vm_env_,
                                 NapiEscapableHandleToJS(scope),
                                 NapiValueToJS(escape), &ret));
  *result = JSValueToNapi(ret);
  return napi_clear_last_error(env);
}

static napi_status napi_throw_(napi_env env, napi_value error) {
  CALL_JSVM(OH_JSVM_Throw(env->ctx->vm_env_, NapiValueToJS(error)));

  return napi_clear_last_error(env);
}

static napi_status napi_throw_error(napi_env env, const char *code,
                                    const char *msg) {
  CALL_JSVM(OH_JSVM_ThrowError(env->ctx->vm_env_, code, msg));
  return napi_clear_last_error(env);
}

static napi_status napi_throw_type_error(napi_env env, const char *code,
                                         const char *msg) {
  CALL_JSVM(OH_JSVM_ThrowTypeError(env->ctx->vm_env_, code, msg));
  return napi_clear_last_error(env);
}

static napi_status napi_throw_range_error(napi_env env, const char *code,
                                          const char *msg) {
  CALL_JSVM(OH_JSVM_ThrowRangeError(env->ctx->vm_env_, code, msg));
  return napi_clear_last_error(env);
}

static napi_status napi_is_error(napi_env env, napi_value value, bool *result) {
  CALL_JSVM(OH_JSVM_IsError(env->ctx->vm_env_, NapiValueToJS(value), result));
  return napi_clear_last_error(env);
}

static napi_status napi_is_exception_pending(napi_env env, bool *result) {
  CALL_JSVM(OH_JSVM_IsExceptionPending(env->ctx->vm_env_, result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_and_clear_last_exception(napi_env env,
                                                     napi_value *result) {
  JSVM_Value ret;
  CALL_JSVM(OH_JSVM_GetAndClearLastException(env->ctx->vm_env_, &ret));
  *result = JSValueToNapi(ret);
  LOGE("JSVM Exception: " << GetExceptionMessage(env->ctx->vm_env_, ret));
  return napi_clear_last_error(env);
}
static napi_status napi_is_arraybuffer(napi_env env, napi_value value,
                                       bool *result) {
  CALL_JSVM(
      OH_JSVM_IsArraybuffer(env->ctx->vm_env_, NapiValueToJS(value), result))
  return napi_clear_last_error(env);
}

static napi_status napi_create_arraybuffer(napi_env env, size_t byte_length,
                                           void **data, napi_value *result) {
  JSVM_Value ab;
  void *data_buffer = nullptr;
  CALL_JSVM(OH_JSVM_AllocateArrayBufferBackingStoreData(
      byte_length, JSVM_UNINITIALIZED, &data_buffer));

  CALL_JSVM(OH_JSVM_CreateArrayBufferFromBackingStoreData(
      env->ctx->vm_env_, data_buffer, byte_length, 0, byte_length, &ab));
  CALL_JSVM(OH_JSVM_AddFinalizer(
      env->ctx->vm_env_, ab, data_buffer,
      [](JSVM_Env env, void *finalize_data, void *finalize_hint) {
        OH_JSVM_FreeArrayBufferBackingStoreData(finalize_data);
      },
      nullptr, nullptr));
  *result = JSValueToNapi(ab);
  *data = data_buffer;
  return napi_clear_last_error(env);
}

static napi_status napi_create_external_arraybuffer(
    napi_env env, void *external_data, size_t byte_length,
    napi_finalize finalize_cb, void *finalize_hint, napi_value *result) {
  return napi_invalid_arg;
}

static napi_status napi_get_arraybuffer_info(napi_env env,
                                             napi_value arraybuffer,
                                             void **data, size_t *byte_length) {
  CALL_JSVM(OH_JSVM_GetArraybufferInfo(
      env->ctx->vm_env_, NapiValueToJS(arraybuffer), data, byte_length));
  return napi_clear_last_error(env);
}

static napi_status napi_is_typedarray(napi_env env, napi_value value,
                                      bool *result) {
  CALL_JSVM(
      OH_JSVM_IsTypedarray(env->ctx->vm_env_, NapiValueToJS(value), result));
  return napi_clear_last_error(env);
}

static napi_status napi_create_typedarray(
    napi_env env, napi_typedarray_type type, size_t length,
    napi_value array_buffer, size_t byte_offset, napi_value *result) {
  JSVM_Value ta;
  CALL_JSVM(OH_JSVM_CreateTypedarray(
      env->ctx->vm_env_, NapiTypedarrTypeToJSTypedarrType(type), length,
      NapiValueToJS(array_buffer), byte_offset, &ta));
  *result = JSValueToNapi(ta);
  return napi_clear_last_error(env);
}

static napi_status napi_is_typedarray_of(napi_env env, napi_value typedarray,
                                         napi_typedarray_type napi_type,
                                         bool *result) {
  JSVM_TypedarrayType type;
  CALL_JSVM(OH_JSVM_GetTypedarrayInfo(env->ctx->vm_env_,
                                      NapiValueToJS(typedarray), &type, nullptr,
                                      nullptr, nullptr, nullptr));
  *result = (type == NapiTypedarrTypeToJSTypedarrType(napi_type));
  return napi_clear_last_error(env);
}

static napi_status napi_get_typedarray_info(napi_env env,
                                            napi_value typed_array,
                                            napi_typedarray_type *type,
                                            size_t *length, void **data,
                                            napi_value *array_buffer,
                                            size_t *byte_offset) {
  JSVM_TypedarrayType js_type;
  JSVM_Value arr_buf;
  CALL_JSVM(OH_JSVM_GetTypedarrayInfo(env->ctx->vm_env_,
                                      NapiValueToJS(typed_array), &js_type,
                                      length, data, &arr_buf, byte_offset));
  if (type) {
    *type = JSTypedarrTypeToNapiType(js_type);
  }
  if (array_buffer) {
    *array_buffer = JSValueToNapi(arr_buf);
  }
  return napi_clear_last_error(env);
}

static napi_status napi_create_dataview(napi_env env, size_t length,
                                        napi_value arraybuffer,
                                        size_t byte_offset,
                                        napi_value *result) {
  JSVM_Value dataview;
  CALL_JSVM(OH_JSVM_CreateDataview(env->ctx->vm_env_, length,
                                   NapiValueToJS(arraybuffer), byte_offset,
                                   &dataview));
  *result = JSValueToNapi(dataview);
  return napi_clear_last_error(env);
}

static napi_status napi_is_dataview(napi_env env, napi_value value,
                                    bool *result) {
  CALL_JSVM(
      OH_JSVM_IsDataview(env->ctx->vm_env_, NapiValueToJS(value), result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_dataview_info(napi_env env, napi_value dataview,
                                          size_t *byteLength, void **data,
                                          napi_value *array_buffer,
                                          size_t *byte_offset) {
  JSVM_Value js_ab;
  CALL_JSVM(OH_JSVM_GetDataviewInfo(env->ctx->vm_env_, NapiValueToJS(dataview),
                                    byteLength, data, &js_ab, byte_offset));
  *array_buffer = JSValueToNapi(js_ab);
  return napi_clear_last_error(env);
}

static napi_status napi_create_promise(napi_env env, napi_deferred *deferred,
                                       napi_value *result) {
  JSVM_Deferred js_deferred;
  JSVM_Value promise;
  CALL_JSVM(OH_JSVM_CreatePromise(env->ctx->vm_env_, &js_deferred, &promise));
  *deferred = JSDeferredToNapi(js_deferred);
  *result = JSValueToNapi(promise);
  return napi_clear_last_error(env);
}

static napi_status napi_release_deferred(napi_env env, napi_deferred deferred,
                                         napi_value resolution,
                                         napi_deferred_release_mode mode) {
  switch (mode) {
    case napi_deferred_resolve: {
      CALL_JSVM(OH_JSVM_ResolveDeferred(env->ctx->vm_env_,
                                        NapiDeferredToJS(deferred),
                                        NapiValueToJS(resolution)));
    } break;
    case napi_deferred_reject: {
      CALL_JSVM(OH_JSVM_RejectDeferred(env->ctx->vm_env_,
                                       NapiDeferredToJS(deferred),
                                       NapiValueToJS(resolution)));
    } break;
    default:
      break;
  }
  return napi_clear_last_error(env);
}

static napi_status napi_is_promise(napi_env env, napi_value value,
                                   bool *result) {
  CALL_JSVM(OH_JSVM_IsPromise(env->ctx->vm_env_, NapiValueToJS(value), result));
  return napi_clear_last_error(env);
}

static napi_status_primjs napi_run_script(napi_env env, const char *script,
                                          size_t length, const char *filename,
                                          napi_value *result) {
  JSVM_Value sourceCodeValue, js_result;
  JSVM_Script js_script;
  CALL_JSVM(OH_JSVM_CreateStringUtf8(env->ctx->vm_env_, script, length,
                                     &sourceCodeValue));
  if (filename == nullptr) {
    CALL_JSVM(OH_JSVM_CompileScript(env->ctx->vm_env_, sourceCodeValue, nullptr,
                                    0, true, nullptr, &js_script));
  } else {
    JSVM_ScriptOrigin origin{.sourceMapUrl = nullptr,
                             .resourceName = filename,
                             .resourceLineOffset = 0,
                             .resourceColumnOffset = 0};
    OH_JSVM_CompileScriptWithOrigin(env->ctx->vm_env_, sourceCodeValue, nullptr,
                                    0, true, nullptr, &origin, &js_script);
  }

  CALL_JSVM(OH_JSVM_RunScript(env->ctx->vm_env_, js_script, &js_result));
  *result = JSValueToNapi(js_result);
  return napi_clear_last_error(env);
}

static napi_status napi_adjust_external_memory(napi_env env,
                                               int64_t change_in_bytes,
                                               int64_t *adjusted_value) {
  CALL_JSVM(OH_JSVM_AdjustExternalMemory(env->ctx->vm_env_, change_in_bytes,
                                         adjusted_value));
  return napi_clear_last_error(env);
}

static napi_status napi_add_finalizer(napi_env env, napi_value js_object,
                                      void *native_object,
                                      napi_finalize finalize_cb,
                                      void *finalize_hint, napi_ref *result) {
  auto *napi_finalizer_data = ExternalNativeInfo::Create(
      env, finalize_cb, native_object, finalize_hint);
  JSVM_Ref ref;
  CALL_JSVM(OH_JSVM_AddFinalizer(env->ctx->vm_env_, NapiValueToJS(js_object),
                                 napi_finalizer_data,
                                 ExternalNativeInfo::Delete, nullptr, &ref));
  if (result) {
    *result = JSRefToNapi(new Reference(env, ref));
  }
  return napi_clear_last_error(env);
}

static napi_status napi_set_instance_data(napi_env env, uint64_t key,
                                          void *data, napi_finalize finalize_cb,
                                          void *finalize_hint) {
  // TODO:@zhangyuping
  auto &map = env->ctx->instance_data_;
  map[key] = ExternalNativeInfo::Create(env, finalize_cb, data, finalize_hint);
  return napi_clear_last_error(env);
}

static napi_status napi_get_instance_data(napi_env env, uint64_t key,
                                          void **data) {
  auto &map = env->ctx->instance_data_;
  if (auto itr = map.find(key); itr != map.end()) {
    *data = itr->second->Data();
  } else {
    *data = nullptr;
  }
  return napi_clear_last_error(env);
}

static napi_status napi_open_context_scope(napi_env env,
                                           napi_context_scope *result) {
  *result = reinterpret_cast<napi_context_scope>(1);
  return napi_clear_last_error(env);
}

static napi_status napi_close_context_scope(napi_env env,
                                            napi_context_scope result) {
  return napi_clear_last_error(env);
}

static napi_status napi_equals(napi_env env, napi_value lhs, napi_value rhs,
                               bool *result) {
  CALL_JSVM(OH_JSVM_Equals(env->ctx->vm_env_, NapiValueToJS(lhs),
                           NapiValueToJS(rhs), result));
  return napi_clear_last_error(env);
}

static napi_status napi_get_unhandled_rejection_exception(napi_env env,
                                                          napi_value *result) {
  // TODO: @zhangyuping.ypz
  return napi_ok;
}

static napi_status napi_get_own_property_descriptor(napi_env env,
                                                    napi_value obj,
                                                    napi_value prop,
                                                    napi_value *result) {
  napi_value global, js_object, js_getOwnPropertyDescriptor_func;
  napi_get_global(env, &global);
  napi_get_named_property(env, global, "Object", &js_object);
  napi_get_named_property(env, js_object, "getOwnPropertyDescriptor",
                          &js_getOwnPropertyDescriptor_func);
  napi_value args[] = {obj, prop};
  napi_call_function(env, global, js_getOwnPropertyDescriptor_func,
                     sizeof(args) / sizeof(args[0]), args, result);
  return napi_clear_last_error(env);
}

#ifdef ENABLE_CODECACHE
static napi_status napi_gen_code_cache(napi_env env, const char *script,
                                       size_t script_len, const uint8_t **data,
                                       int *length) {
  JSVM_Value sourcecode;
  JSVM_Script js_script;
  CALL_JSVM(OH_JSVM_CreateStringUtf8(env->ctx->vm_env_, script, script_len,
                                     &sourcecode));
  CALL_JSVM(OH_JSVM_CompileScript(env->ctx->vm_env_, sourcecode, nullptr, 0,
                                  true, nullptr, &js_script));
  CALL_JSVM(OH_JSVM_CreateCodeCache(env->ctx->vm_env_, js_script, data,
                                    reinterpret_cast<size_t *>(length)));
  return napi_clear_last_error(env);
}

static napi_status napi_run_code_cache(napi_env env, const uint8_t *data,
                                       int32_t length, napi_value *result) {
  JSVM_CodeCache code_cache{.cache = (uint8_t *)data,
                            .length = static_cast<size_t>(length)};
  JSVM_CompileOptions options[] = {
      JSVM_CompileOptions{
          .id = JSVM_COMPILE_MODE,
          .content = {.num = JSVM_COMPILE_MODE_CONSUME_CODE_CACHE}},
      JSVM_CompileOptions{.id = JSVM_COMPILE_CODE_CACHE,
                          .content =
                              {
                                  .ptr = &code_cache,
                              }},
  };
  JSVM_Script script;
  CALL_JSVM(OH_JSVM_CompileScriptWithOptions(
      env->ctx->vm_env_, nullptr, sizeof(options) / sizeof(options[0]), options,
      &script));
  CALL_JSVM(OH_JSVM_RunScript(env->ctx->vm_env_, script,
                              NapiValuePointerToJS(result)));
  return napi_clear_last_error(env);
}

static napi_status napi_run_script_cache(napi_env env, const char *script,
                                         size_t length, const char *filename,
                                         napi_value *result) {
  int32_t len = -1;
  const uint8_t *data = nullptr;
  env->napi_get_code_cache(env, filename, &data, &len);
  if (len == 0) {
    if (napi_gen_code_cache(env, script, length, &data, &len) != napi_ok) {
      return napi_pending_exception;
    }
    env->napi_store_code_cache(env, filename, data, len);
  }
  if (data) {
    return napi_run_code_cache(env, data, len, result);
  }
  return napi_run_script(env, script, length, filename, result);
}
#endif
}  // namespace harmonyimpl

EXTERN_C_START

void napi_attach_harmony(napi_env env, JSVM_Env js_env) {
#define SET_METHOD(API) env->napi_##API = &harmonyimpl::napi_##API;
  FOR_EACH_NAPI_ENGINE_CALL(SET_METHOD)
#undef SET_METHOD
  env->ctx = new napi_context__harmony(env, js_env);
  return;
}

void napi_detach_harmony(napi_env env) {
  delete env->ctx;
  env->ctx = nullptr;
  return;
}

EXTERN_C_END

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_undefs.h"
#endif
