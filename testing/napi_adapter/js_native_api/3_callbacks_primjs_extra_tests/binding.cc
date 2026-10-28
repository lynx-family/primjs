#include <gtest/gtest.h>
#include <string.h>

#include "../common.h"
#include "../entry_point.h"
#include "include/node_api.h"
#include "include/weak_napi_defines.h"
// New test for NAPI Adapter: Ensures that when recv is NULL, the return value
// napi_status of napi_call_function must be napi_invalid_arg
static napi_value RunCallbackWithNullRecv(napi_env env,
                                          napi_callback_info info) {
  size_t argc = 1;
  napi_value args[1];
  NAPI_CALL(env, napi_get_cb_info(env, info, &argc, args, NULL, NULL));

  napi_value cb = args[0];
  napi_status status = napi_call_function(env, NULL, cb, 0, NULL, NULL);
  EXPECT_EQ(status, napi_invalid_arg);
  return NULL;
}

EXTERN_C_START
napi_value Init(napi_env env, napi_value exports) {
  napi_property_descriptor desc[1] = {
      DECLARE_NAPI_PROPERTY("RunCallbackWithNullRecv", RunCallbackWithNullRecv),
  };
  NAPI_CALL(env, napi_define_properties(env, exports, 1, desc));
  return exports;
}
EXTERN_C_END
