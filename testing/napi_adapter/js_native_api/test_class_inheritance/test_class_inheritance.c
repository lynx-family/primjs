#include "../common.h"
#include "../entry_point.h"
#include "include/node_api.h"
#include "include/weak_napi_defines.h"

static napi_ref g_base_ctor_ref;
static napi_ref g_sub_ctor_ref;

static napi_value BaseConstructor(napi_env env, napi_callback_info info) {
  napi_value _this;
  NAPI_CALL(env, napi_get_cb_info(env, info, NULL, NULL, &_this, NULL));
  return _this;
}

static napi_value SubConstructor(napi_env env, napi_callback_info info) {
  napi_value _this;
  NAPI_CALL(env, napi_get_cb_info(env, info, NULL, NULL, &_this, NULL));
  return _this;
}

static napi_value BaseInstanceMethod(napi_env env, napi_callback_info info) {
  napi_value result;
  NAPI_CALL(env, napi_create_string_utf8(env, "baseInstance", NAPI_AUTO_LENGTH,
                                         &result));
  return result;
}

static napi_value BaseStaticMethod(napi_env env, napi_callback_info info) {
  napi_value result;
  NAPI_CALL(env, napi_create_string_utf8(env, "baseStatic", NAPI_AUTO_LENGTH,
                                         &result));
  return result;
}

static napi_value SetupInheritance(napi_env env, napi_callback_info info) {
  napi_value base_ctor;
  napi_value sub_ctor;

  NAPI_CALL(env, napi_get_reference_value(env, g_base_ctor_ref, &base_ctor));
  NAPI_CALL(env, napi_get_reference_value(env, g_sub_ctor_ref, &sub_ctor));

  // Get prototype properties of BaseClass and SubClass via napi_get_property.
  napi_value prototype_key;
  NAPI_CALL(env, napi_create_string_utf8(env, "prototype", NAPI_AUTO_LENGTH,
                                         &prototype_key));

  napi_value base_proto;
  napi_value sub_proto;
  NAPI_CALL(env, napi_get_property(env, base_ctor, prototype_key, &base_proto));
  NAPI_CALL(env, napi_get_property(env, sub_ctor, prototype_key, &sub_proto));

  // Get Object.setPrototypeOf from the global object via N-API.
  napi_value global;
  NAPI_CALL(env, napi_get_global(env, &global));

  napi_value object_key;
  NAPI_CALL(env, napi_create_string_utf8(env, "Object", NAPI_AUTO_LENGTH,
                                         &object_key));

  napi_value object_ctor;
  NAPI_CALL(env, napi_get_property(env, global, object_key, &object_ctor));

  napi_value set_proto_key;
  NAPI_CALL(env, napi_create_string_utf8(env, "setPrototypeOf",
                                         NAPI_AUTO_LENGTH, &set_proto_key));

  napi_value set_prototype_of;
  NAPI_CALL(env, napi_get_property(env, object_ctor, set_proto_key,
                                   &set_prototype_of));

  napi_valuetype func_type;
  NAPI_CALL(env, napi_typeof(env, set_prototype_of, &func_type));
  NAPI_ASSERT(env, func_type == napi_function,
              "Object.setPrototypeOf is not a function");

  // Call Object.setPrototypeOf(SubClass, BaseClass).
  napi_value argv[2];
  napi_value call_result;

  argv[0] = sub_ctor;
  argv[1] = base_ctor;
  NAPI_CALL(env, napi_call_function(env, object_ctor, set_prototype_of, 2, argv,
                                    &call_result));

  // Call Object.setPrototypeOf(SubClass.prototype, BaseClass.prototype).
  argv[0] = sub_proto;
  argv[1] = base_proto;
  NAPI_CALL(env, napi_call_function(env, object_ctor, set_prototype_of, 2, argv,
                                    &call_result));

  return NULL;
}

EXTERN_C_START
napi_value Init(napi_env env, napi_value exports) {
  napi_value base_ctor;
  napi_value sub_ctor;

  napi_property_descriptor base_props[] = {
      {"baseStatic", NULL, BaseStaticMethod, NULL, NULL, NULL,
       napi_default | napi_static, NULL},
  };

  NAPI_CALL(env, napi_define_class(env, "BaseClass", NAPI_AUTO_LENGTH,
                                   BaseConstructor, NULL,
                                   sizeof(base_props) / sizeof(*base_props),
                                   base_props, &base_ctor));

  NAPI_CALL(env, napi_define_class(env, "SubClass", NAPI_AUTO_LENGTH,
                                   SubConstructor, NULL, 0, NULL, &sub_ctor));

  napi_valuetype base_ctor_type;
  NAPI_CALL(env, napi_typeof(env, base_ctor, &base_ctor_type));
  NAPI_ASSERT(env, base_ctor_type == napi_function,
              "BaseClass is not a function");

  napi_valuetype sub_ctor_type;
  NAPI_CALL(env, napi_typeof(env, sub_ctor, &sub_ctor_type));
  NAPI_ASSERT(env, sub_ctor_type == napi_function,
              "SubClass is not a function");
  // If baseInstance is defined directly through napi_define_class's
  // napi_property_descriptor, V8's template signature check will throw an
  // Illegal invocation exception when a subclass instance invokes the
  // baseInstance method. Therefore, we must attach the base-class method to the
  // base prototype using napi_define_properties instead.
  {
    napi_value prototype_key;
    napi_value base_proto;
    NAPI_CALL(env, napi_create_string_utf8(env, "prototype", NAPI_AUTO_LENGTH,
                                           &prototype_key));
    NAPI_CALL(env,
              napi_get_property(env, base_ctor, prototype_key, &base_proto));

    napi_property_descriptor base_instance_prop[] = {
        {"baseInstance", NULL, BaseInstanceMethod, NULL, NULL, NULL,
         napi_default, NULL},
    };

    NAPI_CALL(env, napi_define_properties(
                       env, base_proto,
                       sizeof(base_instance_prop) / sizeof(*base_instance_prop),
                       base_instance_prop));
  }

  NAPI_CALL(env, napi_create_reference(env, base_ctor, 1, &g_base_ctor_ref));
  NAPI_CALL(env, napi_create_reference(env, sub_ctor, 1, &g_sub_ctor_ref));

  NAPI_CALL(env, napi_set_named_property(env, exports, "BaseClass", base_ctor));
  NAPI_CALL(env, napi_set_named_property(env, exports, "SubClass", sub_ctor));

  napi_property_descriptor export_props[] = {
      DECLARE_NAPI_PROPERTY("setupInheritance", SetupInheritance),
  };

  NAPI_CALL(env, napi_define_properties(
                     env, exports, sizeof(export_props) / sizeof(*export_props),
                     export_props));

  return exports;
}
EXTERN_C_END

#include "include/weak_napi_undefs.h"
