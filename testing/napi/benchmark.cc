#include <gtest/gtest.h>

#include "testlib.h"

class NAPIBench : public test::NAPITestBase {};

static int METHOD_COUNT = 30;
static int CALL_COUNT = 1e6;

TEST_P(NAPIBench, PureJS_1e6) {
  Napi::HandleScope hscope(env);

  auto fun = env.RunScript(
                    "(function bench(methodCount, count) {"
                    "  function BenchObject() {"
                    "    this.num = 0;"
                    "  }"
                    "  for (let i = 0; i < methodCount; i++) {"
                    "    BenchObject.prototype['method' + i] = "
                    "function (a) { if (typeof a !== 'number') return 0; "
                    "this.num++; return this.num + a; };"
                    "  }"
                    "  const obj = new BenchObject();"
                    "  for (let i = 0; i < count; i++) {"
                    "    obj.method10(10);"
                    "  }"
                    "})")
                 .As<Napi::Function>();

  fun.Call({Napi::Number::New(env, METHOD_COUNT),
            Napi::Number::New(env, CALL_COUNT)});
}

TEST_P(NAPIBench, JS_ClassStyle_1e6) {
  Napi::HandleScope hscope(env);

  std::string script =
      "(function bench(methodCount, count) {"
      " class BenchObject {"
      "  constructor() { this.num = 0; }";
  for (int i = 0; i < METHOD_COUNT; i++) {
    script += "  method" + std::to_string(i) +
              "(a) { if (typeof a !== 'number') return 0; "
              "this.num++; return this.num + a; }";
  }
  script +=
      "}"
      "  const obj = new BenchObject();"
      "  for (let i = 0; i < count; i++) {"
      "    obj.method10(10);"
      "  }"
      "})";
  auto fun = env.RunScript(script.c_str()).As<Napi::Function>();

  fun.Call({Napi::Number::New(env, METHOD_COUNT),
            Napi::Number::New(env, CALL_COUNT)});
}

TEST_P(NAPIBench, ObjectWrap_1e6) {
  class BenchObject : public Napi::ScriptWrappable {
   public:
    BenchObject(const Napi::CallbackInfo& info) {}

    Napi::Value Method(const Napi::CallbackInfo& info) {
      auto val = info[0];
      if (!val.IsNumber()) {
        return Napi::Number::New(info.Env(), 0);
      }
      num++;
      return Napi::Number::New(info.Env(),
                               val.As<Napi::Number>().Uint32Value() + num);
    }

    int num = 0;

    static Napi::Function Create(Napi::Env env, size_t methodCount) {
      using Wrapped = Napi::ObjectWrap<BenchObject>;
      std::vector<std::string> names(methodCount);
      std::vector<Wrapped::PropertyDescriptor> props;

      for (size_t i = 0; i < methodCount; i++) {
        names[i] = std::string("method") + std::to_string(i);
        props.push_back(
            Wrapped::InstanceMethod(names[i].c_str(), &BenchObject::Method));
      }
      return Wrapped::DefineClass(env, "BenchObject", props).Get(env);
    }
  };

  Napi::HandleScope hscope(env);

  auto fun = env.RunScript(
                    "(function bench(BenchObject, count) {"
                    "  const obj = new BenchObject();"
                    "  for (let i = 0; i < count; i++) {"
                    "    obj.method1(10);"
                    "  }"
                    "})")
                 .As<Napi::Function>();
  auto BenchObjectClass = BenchObject::Create(env, METHOD_COUNT);

  fun.Call({BenchObjectClass, Napi::Number::New(env, CALL_COUNT)});
}

INSTANTIATE_TEST_SUITE_P(
    EngineTest, NAPIBench, ::testing::ValuesIn(test::runtimeFactory),
    [](const testing::TestParamInfo<NAPIBench::ParamType>& info) {
      return std::get<0>(info.param);
    });
