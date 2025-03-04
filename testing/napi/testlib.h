#ifndef TESTING_NAPI_TESTLIB_H_
#define TESTING_NAPI_TESTLIB_H_
#include <gtest/gtest.h>

#include <functional>
#include <memory>
#include <string>
#include <utility>

#include "napi/env/napi_env.h"
#include "napi/env/napi_runtime.h"
#include "napi/napi.h"

namespace test {
class NAPIRuntime {
 public:
  virtual ~NAPIRuntime() {
    napi_detach_runtime(_env);
    napi_free_env(_env);
  }
  Napi::Env Env() { return _env; }

 protected:
  napi_env _env;
  NAPIRuntime() {
    _env = napi_new_env();
    napi_runtime_configuration runtime_conf =
        napi_create_runtime_configuration();
    napi_attach_runtime_with_configuration(_env, runtime_conf);
    napi_delete_runtime_configuration(runtime_conf);
  }
};
}  // namespace test

#ifdef JS_ENGINE_V8
#include <libplatform/libplatform.h>
#include <v8.h>

#include "napi_env_v8.h"

namespace test {
class IsolateScopeWrapper {
 public:
  IsolateScopeWrapper(v8::Isolate* isolate) : _scope(isolate) {}

 private:
  v8::Isolate::Scope _scope;
};

class HandleScopeWrapper {
 public:
  HandleScopeWrapper(v8::Isolate* isolate) : _scope(isolate) {}

 private:
  v8::HandleScope _scope;
};

class ContextScopeWrapper {
 public:
  ContextScopeWrapper(v8::Local<v8::Context> context) : _scope(context) {}

 private:
  v8::Context::Scope _scope;
};

class NAPIRuntimeV8SingleMode : public NAPIRuntime {
 public:
  NAPIRuntimeV8SingleMode() : NAPIRuntime() {
    static std::once_flag flag;
    static std::unique_ptr<v8::Platform> platform =
        v8::platform::NewDefaultPlatform();
    std::call_once(flag, [] {
      v8::V8::InitializeICU();
      v8::V8::InitializePlatform(platform.get());
      v8::V8::Initialize();
    });

    _create_params.array_buffer_allocator =
        v8::ArrayBuffer::Allocator::NewDefaultAllocator();
    _isolate = v8::Isolate::New(_create_params);
    _isolate_scope = std::make_unique<IsolateScopeWrapper>(_isolate);
    _isolate_handle_scope = std::make_unique<HandleScopeWrapper>(_isolate);
    v8::Local<v8::Context> context = v8::Context::New(_isolate);
    _context = new v8::Local<v8::Context>(context);
    _context_scope = std::make_unique<ContextScopeWrapper>(context);
    napi_attach_v8(_env, context);
  }

  ~NAPIRuntimeV8SingleMode() override {
    napi_detach_v8(_env);
    _context_scope.reset();
    delete _context;
    _isolate_handle_scope.reset();
    _isolate_scope.reset();
    _isolate->Dispose();
    delete _create_params.array_buffer_allocator;
  }

 private:
  v8::Isolate* _isolate;
  std::unique_ptr<IsolateScopeWrapper> _isolate_scope;
  std::unique_ptr<HandleScopeWrapper> _isolate_handle_scope;
  v8::Local<v8::Context>* _context;
  std::unique_ptr<ContextScopeWrapper> _context_scope;
  v8::Isolate::CreateParams _create_params;
};
}  // namespace test

#endif

#ifdef JS_ENGINE_JSC
#include <JavaScriptCore/JavaScript.h>

#include "napi_env_jsc.h"

namespace test {
class NAPIRuntimeJSCSingleMode : public NAPIRuntime {
 public:
  NAPIRuntimeJSCSingleMode() : NAPIRuntime() {
    _context_group = JSContextGroupCreate();
    _global_context = JSGlobalContextCreateInGroup(_context_group, nullptr);
    napi_attach_jsc(_env, _global_context);
  }

  ~NAPIRuntimeJSCSingleMode() override {
    napi_detach_jsc(_env);
    JSGlobalContextRelease(_global_context);
    JSContextGroupRelease(_context_group);
  }

 private:
  JSContextGroupRef _context_group;
  JSGlobalContextRef _global_context;
};
}  // namespace test
#endif

#ifdef JS_ENGINE_QJS
#ifdef __cplusplus
extern "C" {
#endif  // __cplusplus
#include "quickjs/include/quickjs.h"
#ifdef __cplusplus
}
#endif  // __cplusplus
#include "napi/quickjs/napi_env_quickjs.h"

namespace test {
class NAPIRuntimeQJS : public NAPIRuntime {
 public:
  NAPIRuntimeQJS() : NAPIRuntime() {
    _rt = LEPUS_NewRuntime();
    _ctx = LEPUS_NewContext(_rt);
    napi_attach_quickjs(_env, _ctx);
  }

  ~NAPIRuntimeQJS() override {
    napi_detach_quickjs(_env);
    LEPUS_FreeContext(_ctx);
    LEPUS_FreeRuntime(_rt);
  }

 private:
  LEPUSRuntime* _rt;
  LEPUSContext* _ctx;
};
}  // namespace test

#endif

namespace test {
using RuntimeFactory =
    std::pair<std::string, std::function<std::unique_ptr<NAPIRuntime>()>>;

RuntimeFactory runtimeFactory[] = {
#ifdef JS_ENGINE_V8
    {"V8",
     [] {
       return std::unique_ptr<NAPIRuntime>(new NAPIRuntimeV8SingleMode());
     }},
#endif

#ifdef JS_ENGINE_JSC
    {"JSC",
     [] {
       return std::unique_ptr<NAPIRuntime>(new NAPIRuntimeJSCSingleMode());
     }},
#endif

#ifdef JS_ENGINE_QJS
    {"QJS", [] { return std::unique_ptr<NAPIRuntime>(new NAPIRuntimeQJS()); }}
#endif
};

class NAPITestBase : public ::testing::TestWithParam<RuntimeFactory> {
 private:
  RuntimeFactory _factory;
  std::unique_ptr<NAPIRuntime> _runtime;

 public:
  Napi::Value eval(const std::string& code) {
    return env.Global().Get("eval").As<Napi::Function>().Call(
        {Napi::String::New(env, code)});
  }

  Napi::Function function(const std::string& code) {
    Napi::Value v = eval("(" + code + ")").As<Napi::Function>();
    assert(v.IsFunction());
    return v.As<Napi::Function>();
  }

  bool checkValue(const Napi::Value& value, const std::string& jsValue) {
    return function("function(value) { return value == " + jsValue + "; }")
        .Call({value})
        .ToBoolean();
  }

  NAPITestBase()
      : _factory(GetParam()),
        _runtime(_factory.second()),
        env(_runtime->Env()) {}
  Napi::Env env;
};
}  // namespace test

#endif  // TESTING_NAPI_TESTLIB_H_
