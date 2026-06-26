#include "addon.h"

#if defined(USE_WEAK_SUFFIX_NAPI)
#include "weak_napi_defines.h"
#endif

namespace __PROJECT_SYMBOL__ {

Napi::Value Hello(const Napi::CallbackInfo& info) {
  return Napi::String::New(info.Env(), "hello from weak napi");
}

Napi::Object Init(Napi::Env env, Napi::Object exports) {
  exports.Set("hello", Napi::Function::New(env, Hello));
  return exports;
}

}  // namespace __PROJECT_SYMBOL__

static Napi::Object Init(Napi::Env env, Napi::Object exports) {
  return __PROJECT_SYMBOL__::Init(env, exports);
}

#if defined(_MSC_VER)
#define LYNX_NAPI_MODULE_EXPORT __declspec(dllexport)
#define LYNX_NAPI_C_CTOR(fn)               \
  extern "C" void fn(void);                \
  namespace {                              \
  struct fn##_runner {                     \
    fn##_runner() { fn(); }                \
  };                                       \
  static fn##_runner fn##_runner_instance; \
  }                                        \
  extern "C" void fn(void)
#else
#define LYNX_NAPI_MODULE_EXPORT __attribute__((visibility("default"), weak))
#define LYNX_NAPI_C_CTOR(fn)                             \
  extern "C" void fn(void) __attribute__((constructor)); \
  extern "C" void fn(void)
#endif

#define LYNX_NAPI_AUTO_REGISTER_MODULE(modname, addon_name, regfunc)        \
  EXTERN_C_START                                                            \
  static napi_module _napi_module_##modname = {                             \
      NAPI_MODULE_VERSION, 0, __FILE__, regfunc, addon_name, NULL, {NULL}}; \
  EXTERN_C_END                                                              \
  LYNX_NAPI_C_CTOR(_napi_register_xx_##modname) {                           \
    napi_module_register(&_napi_module_##modname);                          \
  }

static napi_value RegisterNodeApiModule(napi_env env, napi_value exports) {
  return Napi::RegisterModule(env, exports, Init);
}

EXTERN_C_START
LYNX_NAPI_MODULE_EXPORT int32_t NAPI_CDECL
NODE_API_MODULE_GET_API_VERSION(void) {
  return NAPI_VERSION;
}

LYNX_NAPI_MODULE_EXPORT napi_value NAPI_CDECL
NAPI_MODULE_INITIALIZER(napi_env env, napi_value exports) {
  return RegisterNodeApiModule(env, exports);
}
EXTERN_C_END

LYNX_NAPI_AUTO_REGISTER_MODULE(__PROJECT_SYMBOL__,
                               __PROJECT_SYMBOL__::kAddonName,
                               RegisterNodeApiModule)

#if defined(USE_WEAK_SUFFIX_NAPI)
#include "weak_napi_undefs.h"
#endif
