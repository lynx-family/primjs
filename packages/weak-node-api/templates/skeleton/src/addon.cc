#include <node_api.h>
#if defined(USE_WEAK_SUFFIX_NAPI)
#include "weak_napi_defines.h"
#endif
static napi_value Hello(napi_env env, napi_callback_info info) {
  napi_value out;
  napi_create_string_utf8(env, "hello from weak napi", NAPI_AUTO_LENGTH, &out);
  return out;
}
static napi_value HelloCb(napi_env env, napi_callback_info info) {
  return Hello(env, info);
}
static napi_value Init(napi_env env, napi_value exports) {
  napi_value fn;
  napi_create_function(env, "hello", NAPI_AUTO_LENGTH, HelloCb, nullptr, &fn);
  napi_set_named_property(env, exports, "hello", fn);
  return exports;
}
NAPI_MODULE_INIT() { return Init(env, exports); }
#if defined(USE_WEAK_SUFFIX_NAPI)
#include "weak_napi_undefs.h"
#endif
