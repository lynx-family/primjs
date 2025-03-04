/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */

// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "napi_env.h"

#include <algorithm>
#include <cassert>
#include <cstring>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include "napi.h"
#include "napi/common/napi_state.h"
#include "napi_module.h"

#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif
struct napi_env_data__ {
  void AddCleanupHook(void (*fun)(void* arg), void* arg) {
    cleanup_hooks.insert(CleanupHook{fun, arg, cleanup_hooks.size()});
  }

  void RemoveCleanupHook(void (*fun)(void* arg), void* arg) {
    cleanup_hooks.erase(CleanupHook{fun, arg, 0});
  }

  ~napi_env_data__() { RunCleanup(); }

  struct CleanupHook {
    void (*fun)(void*);
    void* arg;
    uint64_t insertion_order_counter;

    struct Equal {
      bool operator()(const CleanupHook& lhs, const CleanupHook& rhs) const {
        return lhs.fun == rhs.fun && lhs.arg == rhs.arg;
      }
    };

    struct Hash {
      std::size_t operator()(CleanupHook const& s) const {
        std::size_t h1 =
            std::hash<uintptr_t>{}(reinterpret_cast<uintptr_t>(s.fun));
        std::size_t h2 =
            std::hash<uintptr_t>{}(reinterpret_cast<uintptr_t>(s.arg));
        return h1 ^ (h2 << 1);
      }
    };
  };

  void RunCleanup() {
    while (!cleanup_hooks.empty()) {
      // Copy into a vector, since we can't sort an unordered_set in-place.
      std::vector<CleanupHook> callbacks(cleanup_hooks.begin(),
                                         cleanup_hooks.end());
      // We can't erase the copied elements from `cleanup_hooks_` yet, because
      // we need to be able to check whether they were un-scheduled by another
      // hook.

      std::sort(callbacks.begin(), callbacks.end(),
                [](const CleanupHook& a, const CleanupHook& b) {
                  // Sort in descending order so that the most recently inserted
                  // callbacks are run first.
                  return a.insertion_order_counter > b.insertion_order_counter;
                });

      for (const auto& cb : callbacks) {
        if (cleanup_hooks.count(cb) == 0) {
          // This hook was removed from the `cleanup_hooks_` set during another
          // hook that was run earlier. Nothing to do here.
          continue;
        }

        cb.fun(cb.arg);
        cleanup_hooks.erase(cb);
      }
    }
  }

  std::unordered_set<CleanupHook, CleanupHook::Hash, CleanupHook::Equal>
      cleanup_hooks;
};

namespace {
class ModuleRegistry {
 public:
  static const uint64_t KEY = 0xCEAC485602B84617;
  Napi::ObjectReference loader;
  std::unordered_map<std::string, Napi::ObjectReference> loaded_modules;
};

static Napi::Value LoadModule(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  Napi::Value modname = info[0];

  if (!modname.IsString()) {
    Napi::TypeError::New(env, "Expect 1st argument to be string")
        .ThrowAsJavaScriptException();
    return Napi::Value();
  }

  std::string modname_str = info[0].As<Napi::String>().Utf8Value();

  auto* registry = env.GetInstanceData<ModuleRegistry>();
  auto it = registry->loaded_modules.find(modname_str);
  if (it != registry->loaded_modules.end()) {
    return it->second.IsEmpty() ? env.Undefined() : it->second.Value();
  }

  const napi_module* module = napi_find_module(modname_str.c_str());

  if (!module) {
    Napi::Error::New(env,
                     ("NAPI Module [" + modname_str + "] not found").c_str())
        .ThrowAsJavaScriptException();
    return Napi::Value();
  }

  napi_value result = module->nm_register_func(env, Napi::Object::New(env));

  if (result != nullptr) {
    Napi::Object exports = Napi::Object(env, result);
    registry->loaded_modules[modname_str].Reset(exports, 1);
    return exports;
  } else {
    // error happened
    registry->loaded_modules[modname_str] = Napi::ObjectReference();
    return Napi::Value();
  }
}

}  // namespace

napi_status napi_get_version(napi_env env, uint32_t* version) {
  *version = PRIMJS_NAPI_VERSION;
  return napi_clear_last_error(env);
}

napi_status napi_add_env_cleanup_hook(napi_env env, void (*fun)(void* arg),
                                      void* arg) {
  env->state->env_data->AddCleanupHook(fun, arg);
  return napi_clear_last_error(env);
}

napi_status napi_remove_env_cleanup_hook(napi_env env, void (*fun)(void* arg),
                                         void* arg) {
  env->state->env_data->RemoveCleanupHook(fun, arg);
  return napi_clear_last_error(env);
}

// Warning: Keep in-sync with napi_status enum
static const char* error_messages[] = {
    nullptr,
    "Invalid argument",
    "An object was expected",
    "A string was expected",
    "A string or symbol was expected",
    "A function was expected",
    "A number was expected",
    "A boolean was expected",
    "An array was expected",
    "Unknown failure",
    "An exception is pending",
    "The async work item was cancelled",
    "napi_escape_handle already called on scope",
    "Invalid handle scope usage",
    "Invalid callback scope usage",
    "Thread-safe function queue is full",
    "Thread-safe function handle is closing",
    "A bigint was expected",
    "A date was expected",
    "An arraybuffer was expected",
    "A detachable arraybuffer was expected",
    "Conflict napi instance data key"};

#define NAPI_ARRAYSIZE(array) (sizeof(array) / sizeof(array[0]))

napi_status napi_get_last_error_info(napi_env env,
                                     const napi_extended_error_info** result) {
  // you must update this assert to reference the last message
  // in the napi_status enum each time a new error message is added.
  // We don't have a napi_status_last as this would result in an ABI
  // change each time a message was added.
  const int last_status = napi_conflict_instance_data;

  static_assert(NAPI_ARRAYSIZE(error_messages) == last_status + 1,
                "Count of error messages must match count of error values");
  assert(env->state->last_error.error_code <= last_status);

  // Wait until someone requests the last error information to fetch the error
  // message string
  env->state->last_error.error_message =
      error_messages[env->state->last_error.error_code];

  *result = &(env->state->last_error);
  return napi_ok;
}

napi_status napi_get_loader(napi_env _env, napi_value* result) {
  Napi::Env env(_env);
  auto* registry = env.GetInstanceData<ModuleRegistry>();
  if (registry && !registry->loader.IsEmpty()) {
    *result = registry->loader.Value();
    return napi_clear_last_error(env);
  }
  registry = new ModuleRegistry();
  env.SetInstanceData(registry);

  Napi::Object exports = Napi::Object::New(env);
  exports["load"] = Napi::Function::New(env, &LoadModule, "load");
  registry->loader.Reset(exports, 1);

  *result = exports;
  return napi_clear_last_error(env);
}

napi_env napi_new_env() {
  napi_env env = new napi_env__{};
  env->state = new napi_state__{};
  env->state->env_data = new napi_env_data__{};

#define SET_METHOD(API) env->napi_##API = napi_##API;

  FOR_EACH_NAPI_ENV_CALL(SET_METHOD)

#undef SET_METHOD
  return env;
}

void napi_free_env(napi_env env) {
  delete env->state->env_data;
  delete env->state;
  delete env;
}

void napi_setup_loader(napi_env _env, const char* name) {
  Napi::Env env(_env);
  Napi::HandleScope scope(env);

  env.Global().Set(name, env.Loader());
}
