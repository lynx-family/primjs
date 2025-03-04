#include "testlib.h"

#include <gtest/gtest.h>

#include <chrono>
#include <thread>
#include <unordered_map>
#include <unordered_set>

using namespace Napi;

class NAPITest : public test::NAPITestBase {};
TEST_P(NAPITest, RuntimeTest) {
  HandleScope hscope(env);

  auto v = env.RunScript("1");
  EXPECT_EQ(v.ToNumber().Int32Value(), 1);

  env.RunScript("x = 1");
  EXPECT_EQ(env.Global().Get("x").ToNumber().Int32Value(), 1);
}

TEST_P(NAPITest, StringTest) {
  HandleScope hscope(env);

  EXPECT_TRUE(checkValue(String::New(env, "foobar", 3), "'foo'"));
  EXPECT_TRUE(checkValue(String::New(env, "foobar"), "'foobar'"));

  EXPECT_EQ(String::New(env, "foobar", 3).Utf16Value(), u"foo");
  EXPECT_EQ(String::New(env, "foobar").Utf16Value(), u"foobar");

  EXPECT_EQ(String::New(env, u"foobar", 3).Utf8Value(), "foo");
  EXPECT_EQ(String::New(env, u"foobar", 6).Utf8Value(), "foobar");

  uint8_t utf8[] = {0xF0, 0x9F, 0x86, 0x97};
  EXPECT_TRUE(
      checkValue(String::New(env, reinterpret_cast<char*>(utf8), sizeof(utf8)),
                 "'\\uD83C\\uDD97'"));

  EXPECT_EQ(eval("'quux'").ToString().Utf8Value(), "quux");
  EXPECT_EQ(eval("'\\u20AC'").ToString().Utf8Value(), "\xe2\x82\xac");
}

TEST_P(NAPITest, PropertyDescriptorTest) {
  HandleScope hscope(env);
  Value res = env.RunScript(
      "(function () {     "
      "var object = {     "
      "  get foo() {      "
      "    return 17      "
      "  },               "
      "  bar: 42          "
      "  };               "
      "return object;})() ");
  Object fooDesc = Object::GetOwnPropertyDescriptor(napi_env(env), res,
                                                    String::New(env, "foo"));

  EXPECT_TRUE(fooDesc.Get("configurable").ToBoolean().Value());
  EXPECT_TRUE(fooDesc.Get("enumerable").ToBoolean().Value());
  EXPECT_TRUE(fooDesc.Get("value").IsUndefined());
  EXPECT_TRUE(fooDesc.Get("writable").IsUndefined());
  EXPECT_TRUE(fooDesc.Get("set").IsUndefined());
  EXPECT_TRUE(fooDesc.Get("get").IsFunction());

  Object barDesc = Object::GetOwnPropertyDescriptor(napi_env(env), res,
                                                    String::New(env, "bar"));
  EXPECT_TRUE(barDesc.Get("configurable").ToBoolean().Value());
  EXPECT_TRUE(barDesc.Get("enumerable").ToBoolean().Value());
  EXPECT_TRUE(barDesc.Get("value").ToNumber().Int32Value() == 42);
  EXPECT_TRUE(barDesc.Get("writable").ToBoolean());
  EXPECT_TRUE(barDesc.Get("set").IsUndefined());
  EXPECT_TRUE(barDesc.Get("get").IsUndefined());
}

TEST_P(NAPITest, ObjectTest) {
  HandleScope hscope(env);

  eval("x = {1:2, '3':4, 5:'six', 'seven':['eight', 'nine']}");
  Object obj = env.Global().Get("x").As<Object>();
  EXPECT_EQ(obj.GetPropertyNames().Length(), 4);
  EXPECT_TRUE(obj.Has("1"));
  EXPECT_TRUE(obj.Has(1));
  EXPECT_TRUE(obj.Has(String::New(env, "1")));

  EXPECT_TRUE(obj.HasOwnProperty("1"));
  EXPECT_TRUE(obj.HasOwnProperty(String::New(env, "1")));

  EXPECT_EQ(obj.Get(Number::New(env, 5)).ToString().Utf8Value(), "six");

  obj.Set("ten", 11);
  EXPECT_EQ(obj.GetPropertyNames().Length(), 5);
  EXPECT_TRUE(eval("x.ten === 11").ToBoolean());

  obj.Set("e_as_float", 2.71f);
  EXPECT_TRUE(eval("Math.abs(x.e_as_float - 2.71) < 0.001").ToBoolean());

  obj.Set("e_as_double", 2.71);
  EXPECT_TRUE(eval("x.e_as_double === 2.71").ToBoolean());

  uint8_t utf8[] = {0xF0, 0x9F, 0x86, 0x97};
  String nonAsciiName =
      String::New(env, reinterpret_cast<char*>(utf8), sizeof(utf8));
  obj.Set(nonAsciiName, "emoji");
  EXPECT_EQ(obj.GetPropertyNames().Length(), 8);
  EXPECT_TRUE(eval("x['\\uD83C\\uDD97'] == 'emoji'").ToBoolean());

  auto seven = obj.Get("seven");
  EXPECT_TRUE(seven.IsArray());

  obj = Object::New(env);
  obj.Set("roses", "red");
  obj["violets"] = "blue";
  auto oprop = Object::New(env);
  obj.Set("oprop", oprop);
  obj["aprop"] = Array::New(env, 1);

  EXPECT_TRUE(function("function (obj) { return "
                       "obj.roses == 'red' && "
                       "obj['violets'] == 'blue' && "
                       "typeof obj.oprop == 'object' && "
                       "Array.isArray(obj.aprop); }")
                  .Call({obj})
                  .ToBoolean());

  obj = function(
            "function () {"
            "  obj = {};"
            "  obj.a = 1;"
            "  Object.defineProperty(obj, 'b', {"
            "    enumerable: false,"
            "    value: 2"
            "  });"
            "  return obj;"
            "}")
            .Call({})
            .As<Object>();

  EXPECT_EQ(obj.Get("a").ToNumber().Int32Value(), 1);
  EXPECT_EQ(obj.Get("b").ToNumber().Int32Value(), 2);

  Array names = obj.GetPropertyNames();
  EXPECT_EQ(names.Length(), 1);
  EXPECT_EQ(names.Get(uint32_t(0)).ToString().Utf8Value(), "a");

  EXPECT_TRUE(obj.Delete("a").FromJust());
}

namespace ObjectWrapTest {

class InstanceData {
 public:
  const static uint64_t KEY = 0xdeadbeef;
  ObjectReference testStaticContextRef;
  std::string s_staticMethodText;
};

Value StaticGetter(const CallbackInfo& info) {
  return info.Env()
      .GetInstanceData<InstanceData>()
      ->testStaticContextRef.Value()
      .Get("value");
}

void StaticSetter(const CallbackInfo& info, const Value& value) {
  info.Env().GetInstanceData<InstanceData>()->testStaticContextRef.Value().Set(
      "value", value);
}

Value TestStaticMethod(const CallbackInfo& info) {
  std::string str = info[0].ToString();
  return String::New(info.Env(), str + " static");
}

Value TestStaticMethodInternal(const CallbackInfo& info) {
  std::string str = info[0].ToString();
  return String::New(info.Env(), str + " static internal");
}

class Test : public ScriptWrappable {
 public:
  Test(const CallbackInfo& info) {
    // Create an own instance property.
    info.This().As<Object>().DefineProperty(PropertyDescriptor::Accessor(
        info.Env(), info.This().As<Object>(), "ownProperty", OwnPropertyGetter,
        OwnPropertySetter, napi_enumerable, this));

    buffer_ = Persistent(Uint8Array::New(info.Env(), 233));
  }

  static void OwnPropertySetter(const CallbackInfo& info, const Value& value) {
    static_cast<Test*>(info.Data())->Setter(info, value);
  }

  static Value OwnPropertyGetter(const CallbackInfo& info) {
    return static_cast<Test*>(info.Data())->Getter(info);
  }

  void Setter(const CallbackInfo& /*info*/, const Value& value) {
    value_ = value.ToString();
  }

  Value Getter(const CallbackInfo& info) {
    return String::New(info.Env(), value_);
  }

  Value TestMethod(const CallbackInfo& info) {
    std::string str = info[0].ToString();
    return String::New(info.Env(), str + " instance");
  }

  Value TestMethodInternal(const CallbackInfo& info) {
    std::string str = info[0].ToString();
    return String::New(info.Env(), str + " instance internal");
  }

  Value ToStringTag(const CallbackInfo& info) {
    return String::From(info.Env(), "TestTag");
  }

  // creates dummy array, returns `([value])[Symbol.iterator]()`
  Value Iterator(const CallbackInfo& info) {
    Array array = Array::New(info.Env());
    array.Set(array.Length(), String::From(info.Env(), value_));
    return array.Get(Symbol::WellKnown(info.Env(), "iterator"))
        .As<Function>()
        .Call(array, {});
  }

  static Value TestStaticMethodT(const CallbackInfo& info) {
    return String::New(
        info.Env(),
        info.Env().GetInstanceData<InstanceData>()->s_staticMethodText);
  }

  static Value TestStaticVoidMethodT(const CallbackInfo& info) {
    info.Env().GetInstanceData<InstanceData>()->s_staticMethodText =
        info[0].ToString();
    return Value();
  }

  static Function Initialize(Env env) {
    using Wrapped = ObjectWrap<Test>;
    Symbol kTestStaticValueInternal =
        Symbol::New(env, "kTestStaticValueInternal");
    Symbol kTestStaticAccessorInternal =
        Symbol::New(env, "kTestStaticAccessorInternal");
    Symbol kTestStaticMethodInternal =
        Symbol::New(env, "kTestStaticMethodInternal");

    Symbol kTestValueInternal = Symbol::New(env, "kTestValueInternal");
    Symbol kTestAccessorInternal = Symbol::New(env, "kTestAccessorInternal");
    Symbol kTestMethodInternal = Symbol::New(env, "kTestMethodInternal");

    return Wrapped::DefineClass(
               env, "Test",
               {
                   // expose symbols for testing
                   Wrapped::StaticValue("kTestStaticValueInternal",
                                        kTestStaticValueInternal),
                   Wrapped::StaticValue("kTestStaticAccessorInternal",
                                        kTestStaticAccessorInternal),
                   Wrapped::StaticValue("kTestStaticMethodInternal",
                                        kTestStaticMethodInternal),
                   Wrapped::StaticValue("kTestValueInternal",
                                        kTestValueInternal),
                   Wrapped::StaticValue("kTestAccessorInternal",
                                        kTestAccessorInternal),

                   Wrapped::StaticValue("kTestMethodInternal",
                                        kTestMethodInternal),

                   // test data
                   Wrapped::StaticValue("testStaticValue",
                                        String::New(env, "value"),
                                        napi_enumerable),
                   Wrapped::StaticValue(kTestStaticValueInternal,
                                        Number::New(env, 5), napi_default),

                   Wrapped::StaticAccessor("testStaticGetter", &StaticGetter,
                                           nullptr, napi_enumerable),
                   Wrapped::StaticAccessor("testStaticSetter", nullptr,
                                           &StaticSetter, napi_default),
                   Wrapped::StaticAccessor("testStaticGetSet", &StaticGetter,
                                           &StaticSetter, napi_enumerable),
                   Wrapped::StaticAccessor(kTestStaticAccessorInternal,
                                           &StaticGetter, &StaticSetter,
                                           napi_enumerable),

                   Wrapped::StaticMethod("testStaticMethod", &TestStaticMethod,
                                         napi_enumerable),
                   Wrapped::StaticMethod(kTestStaticMethodInternal,
                                         &TestStaticMethodInternal,
                                         napi_default),

                   Wrapped::InstanceValue("testValue",
                                          Napi::Boolean::New(env, true),
                                          napi_enumerable),
                   Wrapped::InstanceValue(kTestValueInternal,
                                          Napi::Boolean::New(env, false),
                                          napi_enumerable),

                   Wrapped::InstanceAccessor("testGetter", &Test::Getter,
                                             nullptr, napi_enumerable),
                   Wrapped::InstanceAccessor("testSetter", nullptr,
                                             &Test::Setter, napi_default),
                   Wrapped::InstanceAccessor("testGetSet", &Test::Getter,
                                             &Test::Setter, napi_enumerable),
                   Wrapped::InstanceAccessor(kTestAccessorInternal,
                                             &Test::Getter, &Test::Setter,
                                             napi_enumerable),

                   Wrapped::InstanceMethod("testMethod", &Test::TestMethod,
                                           napi_enumerable),
                   Wrapped::InstanceMethod(kTestMethodInternal,
                                           &Test::TestMethodInternal,
                                           napi_default),

                   // conventions
                   Wrapped::InstanceAccessor(
                       Napi::Symbol::WellKnown(env, "toStringTag"),
                       &Test::ToStringTag, nullptr, napi_enumerable),
                   Wrapped::InstanceMethod(
                       Napi::Symbol::WellKnown(env, "iterator"),
                       &Test::Iterator, napi_default),
               })
        .Get(env);
  }

 private:
  std::string value_;

  Reference<Napi::Uint8Array> buffer_;
};

Function InitObjectWrap(Env env) {
  env.SetInstanceData(
      new InstanceData{.testStaticContextRef = Persistent(Object::New(env))});

  return Test::Initialize(env);
}

}  // namespace ObjectWrapTest

TEST_P(NAPITest, ObjectWrapTest) {
  HandleScope hscope(env);
  Function TestClazz = ObjectWrapTest::InitObjectWrap(env);
  env.Global()["Test"] = TestClazz;
  eval("var error;");

  {
    EXPECT_TRUE(eval("typeof Test === 'function'").ToBoolean());
    EXPECT_TRUE(eval("Test.bind != null").ToBoolean());
    eval("try { Test(); } catch (e) { error = e; }");
    EXPECT_TRUE(eval("error != null").ToBoolean());
    eval("error = undefined;");
    EXPECT_TRUE(eval("new Test().constructor.name === 'Test'").ToBoolean());
  }

  {
    Object obj = TestClazz.New({});
    env.Global()["obj"] = obj;

    {
      // has check
      EXPECT_TRUE(obj.Has("testValue"));
      EXPECT_TRUE(obj.Has("testSetter"));
      EXPECT_TRUE(obj.Has("testGetter"));
      EXPECT_TRUE(obj.Has("testMethod"));
      EXPECT_TRUE(obj.Has(TestClazz.Get("kTestValueInternal")));
      EXPECT_TRUE(obj.Has(TestClazz.Get("kTestAccessorInternal")));
      EXPECT_TRUE(obj.Has(TestClazz.Get("kTestMethodInternal")));
    }

    // value
    {
      EXPECT_TRUE(eval("obj.testValue === true").ToBoolean());
      EXPECT_TRUE(eval("obj[Test.kTestValueInternal] === false").ToBoolean());
    }

    // read-only, write-only
    {
      obj["testSetter"] = "instance getter";
      EXPECT_EQ(obj.Get("testGetter").ToString().Utf8Value(),
                "instance getter");
      eval("obj.testSetter = 'instance getter 2';");
      EXPECT_TRUE(eval("obj.testGetter === 'instance getter 2'").ToBoolean());
    }

    // read write-only
    {
      eval("error = undefined;");
      EXPECT_TRUE(obj.Get("testSetter").IsUndefined());
      eval(
          "'use strict'; try { const read = obj.testSetter; }"
          " catch (e) { error = e; }");
      EXPECT_TRUE(eval("error === undefined").ToBoolean());
      EXPECT_TRUE(eval("obj.testSetter === undefined").ToBoolean());
    }

    // write read-only
    {
      eval("error = undefined;");
      eval(
          "'use strict'; try { obj.testGetter = 'write'; }"
          " catch (e) { error = e; }");
      EXPECT_TRUE(eval("error.name === 'TypeError'").ToBoolean());
    }

    // rw
    {
      obj["testGetSet"] = "instance getset";
      EXPECT_EQ(obj.Get("testGetSet").ToString().Utf8Value(),
                "instance getset");

      eval("'use strict'; obj.testGetSet = 'instance getset 3';");
      EXPECT_TRUE(eval("obj.testGetSet === 'instance getset 3'").ToBoolean());
    }

    // rw symbol
    {
      Symbol sym = TestClazz.Get("kTestAccessorInternal").As<Symbol>();
      EXPECT_TRUE(sym.IsSymbol());

      obj.Set(sym, "instance internal getset");
      EXPECT_EQ(obj.Get(sym).ToString().Utf8Value(),
                "instance internal getset");

      eval(
          "'use strict'; obj[Test.kTestAccessorInternal] = 'instance internal "
          "getset 3';");
      EXPECT_TRUE(eval("obj[Test.kTestAccessorInternal] === 'instance internal "
                       "getset 3'")
                      .ToBoolean());
    }

    // own property
    {
      eval("'use strict'; obj.testSetter = 'own property value';");
      EXPECT_TRUE(
          eval("Object.getOwnPropertyNames(obj).indexOf('ownProperty') >= 0")
              .ToBoolean());
      EXPECT_TRUE(eval("obj.ownProperty === 'own property value'").ToBoolean());

      eval("'use strict'; obj.ownProperty = 'own property value 2';");
      EXPECT_TRUE(
          eval("obj.ownProperty === 'own property value 2'").ToBoolean());
    }

    // test methods
    {
      EXPECT_EQ(obj.Get("testMethod")
                    .As<Function>()
                    .Call(obj, {String::New(env, "method")})
                    .ToString()
                    .Utf8Value(),
                "method instance");
      EXPECT_EQ(obj.Get(TestClazz.Get("kTestMethodInternal"))
                    .As<Function>()
                    .Call(obj, {String::New(env, "method")})
                    .ToString()
                    .Utf8Value(),
                "method instance internal");

      EXPECT_EQ(eval("obj.testMethod('method 2')").ToString().Utf8Value(),
                "method 2 instance");
      EXPECT_EQ(eval("obj[Test.kTestMethodInternal]('method 2')")
                    .ToString()
                    .Utf8Value(),
                "method 2 instance internal");
    }

    // test enumerables
    {
      EXPECT_EQ(eval("Object.keys(obj).length").ToNumber().Uint32Value(), 1);
      EXPECT_TRUE(eval("Object.keys(obj).includes('ownProperty')").ToBoolean());

      eval("var keys = []; for (var key in obj) { keys.push(key); }");
      if (std::get<0>(GetParam()) == "JSC") {
        // JSC always has 'constructor' in keys
        EXPECT_EQ(eval("keys.length").ToNumber().Uint32Value(), 6);
      } else {
        EXPECT_EQ(eval("keys.length").ToNumber().Uint32Value(), 5);
      }
      EXPECT_TRUE(eval("keys.includes('testGetSet')").ToBoolean());
      EXPECT_TRUE(eval("keys.includes('testGetter')").ToBoolean());
      EXPECT_TRUE(eval("keys.includes('testValue')").ToBoolean());
      EXPECT_TRUE(eval("keys.includes('testMethod')").ToBoolean());
      EXPECT_TRUE(eval("keys.includes('ownProperty')").ToBoolean());
    }

    // test @@toStringTag
    {
      // EXPECT_EQ(obj.ToString().Utf8Value(), "[object TestTag]");
      // EXPECT_EQ(eval("'' + obj").ToString().Utf8Value(), "[object
      // TestTag]");
    }

    // test @@iterator
    {
      obj["testSetter"] = "iterator";
      EXPECT_EQ(eval("[...obj].join('')").ToString().Utf8Value(), "iterator");
    }
  }

  // static value
  {
    EXPECT_TRUE(eval("Test.testStaticValue === 'value'").ToBoolean());
    EXPECT_TRUE(eval("Test[Test.kTestStaticValueInternal] === 5").ToBoolean());
  }

  // static read-only, write-only
  {
    TestClazz["testStaticSetter"] = "static getter";
    EXPECT_EQ(TestClazz.Get("testStaticGetter").ToString().Utf8Value(),
              "static getter");
    eval("Test.testStaticSetter = 'static getter 2';");
    EXPECT_TRUE(
        eval("Test.testStaticGetter === 'static getter 2'").ToBoolean());
  }

  // static read write-only
  {
    eval("error = undefined;");
    EXPECT_TRUE(TestClazz.Get("testStaticSetter").IsUndefined());
    eval(
        "'use strict'; try { const read = Test.testStaticSetter; }"
        " catch (e) { error = e; }");
    EXPECT_TRUE(eval("error === undefined").ToBoolean());
    EXPECT_TRUE(eval("Test.testStaticSetter === undefined").ToBoolean());
  }

  // static write read-only
  {
    eval("error = undefined;");
    eval(
        "'use strict'; try { Test.testStaticGetter = 'write'; }"
        " catch (e) { error = e; }");
    EXPECT_TRUE(eval("error.name === 'TypeError'").ToBoolean());
  }

  // static rw
  {
    TestClazz["testStaticGetSet"] = "static getset";
    EXPECT_EQ(TestClazz.Get("testStaticGetSet").ToString().Utf8Value(),
              "static getset");

    eval("'use strict'; Test.testStaticGetSet = 'static getset 3';");
    EXPECT_TRUE(
        eval("Test.testStaticGetSet === 'static getset 3'").ToBoolean());
  }

  // static rw symbol
  {
    Symbol sym = TestClazz.Get("kTestStaticAccessorInternal").As<Symbol>();
    EXPECT_TRUE(sym.IsSymbol());

    TestClazz.Set(sym, "static internal getset");
    EXPECT_EQ(TestClazz.Get(sym).ToString().Utf8Value(),
              "static internal getset");

    eval(
        "'use strict'; Test[Test.kTestStaticAccessorInternal] = 'static "
        "internal "
        "getset 3';");
    EXPECT_TRUE(eval("Test[Test.kTestStaticAccessorInternal] === 'static "
                     "internal getset 3'")
                    .ToBoolean());
  }

  // test static methods
  {
    EXPECT_EQ(TestClazz.Get("testStaticMethod")
                  .As<Function>()
                  .Call(TestClazz, {String::New(env, "method")})
                  .ToString()
                  .Utf8Value(),
              "method static");
    EXPECT_EQ(TestClazz.Get(TestClazz.Get("kTestStaticMethodInternal"))
                  .As<Function>()
                  .Call(TestClazz, {String::New(env, "method")})
                  .ToString()
                  .Utf8Value(),
              "method static internal");

    EXPECT_EQ(eval("Test.testStaticMethod('method 2')").ToString().Utf8Value(),
              "method 2 static");
    EXPECT_EQ(eval("Test[Test.kTestStaticMethodInternal]('method 2')")
                  .ToString()
                  .Utf8Value(),
              "method 2 static internal");
  }

  // test static enumerables
  {
    EXPECT_EQ(
        eval("Object.keys(Test)").ToString().Utf8Value(),
        "testStaticValue,testStaticGetter,testStaticGetSet,testStaticMethod");

    eval("var keys = []; for (var key in Test) { keys.push(key); }");
    EXPECT_EQ(
        eval("keys").ToString().Utf8Value(),
        "testStaticValue,testStaticGetter,testStaticGetSet,testStaticMethod");
  }

  EXPECT_TRUE(eval("Test.prototype.testMethod").IsFunction());
}

TEST_P(NAPITest, ArrayTest) {
  HandleScope hscope(env);
  eval("x = {1:2, '3':4, 5:'six', 'seven':['eight', 'nine']}");

  auto x = env.Global().Get("x").As<Object>();
  auto names = x.GetPropertyNames();
  auto length = names.Length();
  EXPECT_EQ(length, 4);

  std::unordered_set<std::string> str_names;
  for (size_t i = 0; i < length; i++) {
    Value n = names[i];
    EXPECT_TRUE(n.IsString());
    str_names.insert(n.As<String>().Utf8Value());
  }

  EXPECT_EQ(str_names.size(), 4);
  EXPECT_EQ(str_names.count("1"), 1);
  EXPECT_EQ(str_names.count("3"), 1);
  EXPECT_EQ(str_names.count("5"), 1);
  EXPECT_EQ(str_names.count("seven"), 1);

  Object seven = x.Get("seven").As<Object>();
  EXPECT_TRUE(seven.IsArray());
  Array arr = seven.As<Array>();

  EXPECT_EQ(arr.Length(), 2);
  EXPECT_EQ(arr.Get(size_t(0)).ToString().Utf8Value(), "eight");
  EXPECT_EQ(arr.Get(size_t(1)).ToString().Utf8Value(), "nine");
  EXPECT_EQ(arr.Get(size_t(2)).ToString().Utf8Value(), "undefined");

  EXPECT_EQ(seven.Get("0").ToString().Utf8Value(), "eight");
  EXPECT_EQ(seven.Get("1").ToString().Utf8Value(), "nine");
  seven["1"] = "modified";
  EXPECT_EQ(seven.Get("1").ToString().Utf8Value(), "modified");
  EXPECT_EQ(arr.Get(size_t(1)).ToString().Utf8Value(), "modified");
  seven.Set(String::New(env, "0"), "modified2");
  EXPECT_EQ(seven.Get("0").ToString().Utf8Value(), "modified2");
  EXPECT_EQ(arr.Get(size_t(0)).ToString().Utf8Value(), "modified2");

  Array alpha = Array::New(env, 4);
  EXPECT_TRUE(alpha.Get(size_t(0)).IsUndefined());
  EXPECT_TRUE(alpha.Get(size_t(3)).IsUndefined());
  EXPECT_EQ(alpha.Length(), 4);
  alpha.Set(size_t(0), "a");
  alpha.Set(size_t(1), "b");
  EXPECT_EQ(alpha.Length(), 4);
  alpha.Set(size_t(2), "c");
  alpha.Set(size_t(3), "d");
  EXPECT_EQ(alpha.Length(), 4);

  EXPECT_TRUE(
      function(
          "function (arr) { return "
          "arr.length == 4 && "
          "['a','b','c','d'].every(function(v,i) { return v === arr[i]}); }")
          .Call({alpha})
          .ToBoolean());
}

TEST_P(NAPITest, FunctionTest) {
  HandleScope hscope(env);

  Function f = function("() => 1");
  { f = function("() => 2"); }

  EXPECT_EQ(f.Call({}).ToNumber().Int32Value(), 2);

  // This tests all the function argument converters, and all the
  // non-lvalue overloads of call().
  f = function(
      "function(n, b, d, df, i, s1, s2, s3, s_sun, s_bad, o, a, f, v) { "
      "return "
      "n === null && "
      "b === true && "
      "d === 3.14 && "
      "Math.abs(df - 2.71) < 0.001 && "
      "i === 17 && "
      "s1 == 's1' && "
      "s2 == 's2' && "
      "s3 == 's3' && "
      "s_sun == 's\\u2600' && "
      "typeof s_bad == 'string' && "
      "typeof o == 'object' && "
      "Array.isArray(a) && "
      "typeof f == 'function' && "
      "v == 42 }");

  EXPECT_TRUE(
      f.Call({env.Null(), Napi::Boolean::New(env, true), Number::New(env, 3.14),
              Number::New(env, 2.71f), Number::New(env, 17),
              String::New(env, "s1"), String::New(env, "s2"),
              String::New(env, "s3"), String::New(env, u8"s\u2600"),
              // invalid UTF8 sequence due to unexpected continuation byte
              String::New(env, "s\x80"), Object::New(env), Array::New(env, 1),
              function("function(){}"), Number::New(env, 42)})
          .ToBoolean());

  Function flv = function(
      "function(s, o, a, f, v) { return "
      "s == 's' && "
      "typeof o == 'object' && "
      "Array.isArray(a) && "
      "typeof f == 'function' && "
      "v == 42 }");

  String s = String::New(env, "s");
  Object o = Object::New(env);
  Array a = Array::New(env, 1);
  Value v = Value::From(env, 42);
  EXPECT_TRUE(flv.Call({s, o, a, f, v}).ToBoolean());
}

TEST_P(NAPITest, FunctionThisTest) {
  Function checkPropertyFunction =
      function("function () { return this.a === 'a_property'; }");

  Object jsObject = Object::New(env);
  jsObject.Set("a", "a_property");

  class APropertyObject : public ScriptWrappable {
   public:
    APropertyObject(const CallbackInfo& info) {}

    static Class Create(Env env) {
      using Wrapped = ObjectWrap<APropertyObject>;

      return Wrapped::DefineClass(
          env, "Base",
          {
              Wrapped::InstanceAccessor("a", &APropertyObject::GetA),
          });
    }

   private:
    Value GetA(const CallbackInfo& info) {
      return String::New(info.Env(), "a_property");
    }
  };
  Object objectWrap = APropertyObject::Create(env).Get(env).New({});
  EXPECT_TRUE(checkPropertyFunction.Call(jsObject, {}).ToBoolean());
  EXPECT_TRUE(checkPropertyFunction.Call(objectWrap, {}).ToBoolean());
  EXPECT_FALSE(checkPropertyFunction.Call(Array::New(env, 5), {}).ToBoolean());
  EXPECT_FALSE(checkPropertyFunction.Call({}).ToBoolean());
}

TEST_P(NAPITest, FunctionConstructorTest) {
  Function ctor = function(
      "function (a) {"
      "  if (typeof a !== 'undefined') {"
      "   this.pika = a;"
      "  }"
      "}");
  ctor.Get("prototype").As<Object>()["pika"] = "chu";
  auto empty = ctor.New({});
  EXPECT_TRUE(empty.IsObject());
  EXPECT_EQ(empty.Get("pika").ToString().Utf8Value(), "chu");
  auto who = ctor.New({String::New(env, "who")});
  EXPECT_TRUE(who.IsObject());
  EXPECT_EQ(who.Get("pika").ToString().Utf8Value(), "who");

  auto instanceof = function("function (o ,b) { return o instanceof b; }");
  EXPECT_TRUE(instanceof.Call({empty, ctor}).ToBoolean());
  EXPECT_TRUE(instanceof.Call({who, ctor}).ToBoolean());

  auto dateCtor = env.Global().Get("Date").As<Function>();
  auto date = dateCtor.New({});
  EXPECT_TRUE(date.IsObject());
  EXPECT_TRUE(instanceof.Call({date, dateCtor}).ToBoolean());
  std::this_thread::sleep_for(std::chrono::milliseconds(50));
  EXPECT_GE(
      function("function (d) { return (new Date()).getTime() - d.getTime(); }")
          .Call({date})
          .ToNumber()
          .Uint32Value(),
      50);
}

TEST_P(NAPITest, InheritanceTest) {
  class Base : public ScriptWrappable {
   public:
    Base(const CallbackInfo& info) {
      this->obj.Reset(info[0].As<Object>(), 1);
    };

    static Class Create(Env env) {
      using Wrapped = ObjectWrap<Base>;

      return Wrapped::DefineClass(
          env, "Base",
          {Wrapped::InstanceMethod("add", &Base::Add),
           Wrapped::InstanceAccessor("num", &Base::GetNum, &Base::SetNum),
           Wrapped::InstanceAccessor("obj", &Base::GetObj),
           Wrapped::StaticValue("SBase", String::New(env, "SBase"))});
    }

    Value Add(const CallbackInfo& info) {
      add();
      return info.Env().Undefined();
    }

    Value GetNum(const CallbackInfo& info) {
      return Number::New(info.Env(), num);
    }

    void SetNum(const CallbackInfo& info, const Value& value) {
      num = value.As<Number>();
    }

    Value GetObj(const CallbackInfo& info) { return this->obj.Value(); }

    ObjectReference obj;

    void add() { num++; }
    int num = 0;
  };

  class Sub : public Base {
   public:
    static Class Create(Env env, const Class& BaseClass) {
      using Wrapped = ObjectWrap<Sub>;
      return Wrapped::DefineClass(
          env, "Sub",
          {Wrapped::InstanceMethod("sub", &Sub::SubTract),
           Wrapped::StaticValue("SSub", String::New(env, "SSub"))},
          nullptr, BaseClass);
    }
    Sub(const CallbackInfo& info) : Base(info){};

    void subtract() { num--; }

    Value SubTract(const CallbackInfo& info) {
      subtract();
      return info.Env().Undefined();
    }
  };

  HandleScope hscope(env);

  auto fun =
      env.RunScript(
             "(function bench(Base, Sub) {"
             "  const base = new Base({ a: 3 });"
             "  const sub = new Sub({ b : 2 });"
             "  base.add();"
             "  sub.add();"
             "  sub.sub();"
             "  return JSON.stringify([sub instanceof Sub, sub instanceof "
             "Base, base instanceof Sub, base instanceof Base, sub.num, "
             "base.num]);"
             "})")
          .As<Function>();
  auto BaseClass = Base::Create(env);
  auto SubClass = Sub::Create(env, BaseClass);
  auto BaseCons = BaseClass.Get(env);
  auto SubCons = SubClass.Get(env);
  env.Global().Set("Base", BaseCons);
  env.Global().Set("Sub", SubCons);
  EXPECT_EQ(fun.Call({BaseCons, SubCons}).As<String>().Utf8Value(),
            "[true,true,false,true,0,1]");
  EXPECT_EQ(BaseCons.Get("SBase").ToString().Utf8Value(), "SBase");
  EXPECT_EQ(SubCons.Get("SBase").ToString().Utf8Value(), "SBase");
  EXPECT_EQ(SubCons.Get("SSub").ToString().Utf8Value(), "SSub");

  EXPECT_TRUE(eval("Base.prototype.add").IsFunction());
  EXPECT_TRUE(eval("Object.prototype.hasOwnProperty.call(Sub.prototype, 'sub')")
                  .ToBoolean());

  EXPECT_TRUE(eval("Sub.prototype.sub").IsFunction());

  EXPECT_FALSE(eval("null instanceof Sub").ToBoolean());
}

TEST_P(NAPITest, InstanceData) {
  const static uint64_t KEY = 0xaabbcc;
  class InstanceData {
   public:
    int value = 233;
    ObjectReference object;
    static Value GetInstanceData(const CallbackInfo& info) {
      auto env = info.Env();
      return Number::New(env, env.GetInstanceData<InstanceData>(KEY)->value);
    }
  };

  env.AddCleanupHook<uint32_t>(
      [](uint32_t* num) {
        EXPECT_EQ(*num, 42);
        delete num;
      },
      new uint32_t(42));
  auto* d = new InstanceData();
  env.SetInstanceData(KEY, d);

  env.Global().Set("fun", Function::New(env, InstanceData::GetInstanceData));

  auto fun = env.RunScript(
                    "(function bench() {"
                    "  return fun();"
                    "})")
                 .As<Function>();
  d->object.Reset(fun, 1);
  EXPECT_EQ(fun.Call({}).As<Number>().Uint32Value(), 233);
  auto func = [](int*) { throw std::runtime_error("should not call"); };
  int a = 33;
  env.AddCleanupHook<int>(func, &a);
  env.RemoveCleanupHook<int>(func, &a);
}

TEST_P(NAPITest, TypeChecking) {
  class Base : public ScriptWrappable {
   public:
    Base(const CallbackInfo& info){};

    static Class Create(Env env) {
      using Wrapped = ObjectWrap<Base>;

      return Wrapped::DefineClass(
          env, "Base",
          {Wrapped::InstanceAccessor("num", &Base::GetNum, &Base::SetNum)});
    }

    Value GetNum(const CallbackInfo& info) {
      return Number::New(info.Env(), num);
    }

    void SetNum(const CallbackInfo& info, const Value& value) {
      num = value.As<Number>();
    }

    int num = 0;
  };

  class Sub : public Base {
   public:
    static Class Create(Env env, const Class& BaseClass) {
      using Wrapped = ObjectWrap<Sub>;
      return Wrapped::DefineClass(
          env, "Sub", {Wrapped::InstanceAccessor("sub", &Sub::GetSub)}, nullptr,
          BaseClass);
    }
    Sub(const CallbackInfo& info) : Base(info){};

    bool isSub = true;
    Value GetSub(const CallbackInfo& info) {
      return Napi::Boolean::New(info.Env(), isSub);
    }
  };

  class Other : public ScriptWrappable {
   public:
    Other(const CallbackInfo& info){};

    static Class Create(Env env) {
      using Wrapped = ObjectWrap<Other>;

      return Wrapped::DefineClass(
          env, "Other",
          {Wrapped::InstanceAccessor("str", &Other::GetStr, &Other::SetStr)});
    }

    Value GetStr(const CallbackInfo& info) {
      return String::New(info.Env(), str);
    }

    void SetStr(const CallbackInfo& info, const Value& value) {
      str = value.As<String>();
    }

    std::string str;
  };

  class JSModule {
   public:
    class ValueWrap {
     public:
      ValueWrap(JSModule* module, int val, std::string name)
          : val_(val), name_(name), module_(module) {}
      int value() { return val_; }
      std::string& name() { return name_; }
      JSModule* GetJSModule() { return module_; }

     private:
      int val_;
      std::string name_;
      JSModule* module_;
    };

    JSModule() {
      methodMap_["prop1"] = std::make_shared<ValueWrap>(this, 1, "prop1");
      methodMap_["prop2"] = std::make_shared<ValueWrap>(this, 2, "prop2");
      methodMap_["prop3"] = std::make_shared<ValueWrap>(this, 3, "prop3");
      methodMap_["prop4"] = std::make_shared<ValueWrap>(this, 4, "prop4");
    }

    const std::unordered_map<std::string, std::shared_ptr<ValueWrap>>&
    GetMap() {
      return methodMap_;
    }

    Napi::Value GetConstructor() { return constructor_; }

    void SetConstructor(Value constructor) { constructor_ = constructor; }

    Value invokeMethod(Env env, ValueWrap* val) {
      return Napi::Number::From(env, val->value());
    }

   private:
    Value constructor_;
    std::unordered_map<std::string, std::shared_ptr<ValueWrap>> methodMap_;
  };

  class JSModuleWrap : public ScriptWrappable {
   public:
    JSModuleWrap(const CallbackInfo& info) {
      Napi::External value = info[0].As<Napi::External>();
      js_module_ = reinterpret_cast<JSModule*>(value.Data());
    };

    static Value CreateFromJSModule(Env env,
                                    std::shared_ptr<JSModule>& module) {
      Value constructor = module->GetConstructor();
      Napi::External v =
          Napi::External::New(env, module.get(), nullptr, nullptr);

      Napi::Value arg = Napi::Value::From(env, v);
      if (constructor.IsFunction()) {
        return constructor.As<Function>().New({arg});
      }
      using Wrapped = ObjectWrap<JSModuleWrap>;
      std::vector<Wrapped::PropertyDescriptor> properties;
      auto moduleMap = module->GetMap();
      for (auto it : moduleMap) {
        properties.push_back(Wrapped::InstanceAccessor(
            Napi::String::New(env, it.first.c_str()), &JSModuleWrap::GetValue,
            nullptr, napi_default, it.second.get()));
      }
      auto construtor =
          Wrapped::DefineClass(env, "JSModuleWrap", properties).Get(env);
      module->SetConstructor(Value::From(env, construtor));
      return construtor.New({arg});
    }

    Value GetValue(const CallbackInfo& info) {
      Value thisValue = info.This();
      Env env = info.Env();
      auto obj = thisValue.As<Object>();
      JSModuleWrap* moduleWrap = ObjectWrap<JSModuleWrap>::Unwrap(obj);
      if (!moduleWrap) {
        Error::New(info.Env(), "js module wrap is not an object")
            .ThrowAsJavaScriptException();
        return Value();
      }

      Function func = Function::New(
          env,
          [](const CallbackInfo& info) -> Value {
            JSModule::ValueWrap* value =
                reinterpret_cast<JSModule::ValueWrap*>(info.Data());
            return value->GetJSModule()->invokeMethod(info.Env(), value);
          },
          "GetValueCallback", info.Data());
      return Napi::Value::From(info.Env(), func);
    }

   private:
    JSModule* js_module_;
  };

  HandleScope hscope(env);

  env.Global()["test"] =
      Function::New(env, [](const CallbackInfo& info) -> Value {
        auto env = info.Env();
        auto value = info[0];
        if (!value.IsObject()) {
          Error::New(env, "not an object").ThrowAsJavaScriptException();
          return Value();
        }
        auto obj = value.As<Object>();
        {
          Other* ptr = ObjectWrap<Other>::Unwrap(obj);
          if (ptr) {
            return String::New(env, "Other");
          }
        }
        {
          Sub* ptr = ObjectWrap<Sub>::Unwrap(obj);
          if (ptr) {
            return String::New(env, "Sub");
          }
        }
        {
          Base* ptr = ObjectWrap<Base>::Unwrap(obj);
          if (ptr) {
            return String::New(env, "Base");
          }
        }
        return String::New(env, "???");
      });
  auto BaseClass = Base::Create(env);
  auto SubClass = Sub::Create(env, BaseClass);
  auto OtherClass = Other::Create(env);
  env.Global()["Base"] = BaseClass.Get(env);
  env.Global()["Sub"] = SubClass.Get(env);
  env.Global()["Other"] = OtherClass.Get(env);

#ifdef NAPI_CPP_RTTI
  auto str = env.RunScript(
                    "(function() {"
                    "  return test(new Base()) + test(new Sub()) + "
                    "test(new Other()) + test({});"
                    "})()")
                 .As<String>()
                 .Utf8Value();
  EXPECT_EQ(str, "BaseSubOther???");
#endif

  std::shared_ptr<JSModule> module = std::make_shared<JSModule>();
  env.Global()["JSMoudle"] = JSModuleWrap::CreateFromJSModule(env, module);

  auto val = env.RunScript(
                    "(function() {"
                    " return JSMoudle.prop2() + JSMoudle.prop1() + "
                    "JSMoudle.prop3() + JSMoudle.prop4();"
                    "})()")
                 .As<Number>();
  EXPECT_EQ(val.Int32Value(), 10);
}

TEST_P(NAPITest, Exception) {
  auto functionThatCatch =
      Function::New(env, [](const CallbackInfo& info) -> Value {
        auto env = info.Env();
        auto val = info[0];
        val.As<Function>().Call(0, nullptr);
        if (env.IsExceptionPending()) {
          return String::New(env, std::string("caught ") +
                                      env.GetAndClearPendingException()
                                          .As<Napi::Error>()
                                          .Get("message")
                                          .ToString()
                                          .Utf8Value() +
                                      " in native");
        }

        return String::New(env, "no throw");
      });
  auto functionThatThrow =
      Function::New(env, [](const CallbackInfo& info) -> Value {
        Error::New(info.Env(), "exception from native")
            .ThrowAsJavaScriptException();
        return Value();
      });

  auto jsFuncThatThrow =
      env.RunScript("(function () { throw new Error('exception from js'); })")
          .As<Function>();

  auto jsFuncThatCatch =
      env.RunScript(
             "(function (fn) { try { fn(); } catch (err) { "
             "return 'caught ' + err.message + ' in js'; } })")
          .As<Function>();

  EXPECT_EQ(functionThatCatch.Call({functionThatThrow}).ToString().Utf8Value(),
            "caught exception from native in native");
  EXPECT_EQ(jsFuncThatCatch.Call({jsFuncThatThrow}).ToString().Utf8Value(),
            "caught exception from js in js");
  EXPECT_EQ(functionThatCatch.Call({jsFuncThatThrow}).ToString().Utf8Value(),
            "caught exception from js in native");
  EXPECT_EQ(jsFuncThatCatch.Call({functionThatThrow}).ToString().Utf8Value(),
            "caught exception from native in js");
}

namespace {
Napi::Value Add(const Napi::CallbackInfo& info) {
  Napi::Env env = info.Env();
  auto v = info[0];
  if (!v.IsNumber()) {
    return Napi::Value::From(env, 24);
  }

  return Napi::Value::From(env, v.As<Napi::Number>().Int32Value() + 1);
}

Napi::Object ModAInit(Napi::Env env, Napi::Object exports) {
  exports["num"] = 33;
  exports["add"] = Napi::Function::New(env, &Add, "add");
  return exports;
}
}  // namespace

NODE_API_MODULE(mod_a, ModAInit)

TEST_P(NAPITest, Module) {
  HandleScope hscope(env);

  napi_setup_loader(env, "loaderA");

  auto num = env.RunScript(
                    "const mod_a = loaderA.load('mod_a');\n"
                    "mod_a.add(mod_a.num)")
                 .As<Number>()
                 .Int32Value();
  EXPECT_EQ(num, 34);
}

TEST_P(NAPITest, UncaughtException) {
  std::string err_message;

  napi_runtime_configuration conf = napi_create_runtime_configuration();
  napi_runtime_config_uncaught_handler(
      conf,
      [](napi_env env, napi_value exception, void* data) {
        *reinterpret_cast<std::string*>(data) =
            Napi::Value(env, exception).ToString().Utf8Value();
      },
      &err_message);
  napi_detach_runtime(static_cast<napi_env>(env));
  napi_attach_runtime_with_configuration(env, conf);
  napi_delete_runtime_configuration(conf);

  {
    HandleScope hscope(env);
    ErrorScope escope(env);
    env.RunScript("throw new Error('are you ok?');");
  }

  EXPECT_EQ(err_message, "Error: are you ok?");
}

TEST_P(NAPITest, External) {
  int* num = new int(233);

  Napi::External v = Napi::External::New(
      env, num,
      [](napi_env, void* data, void*) {
        int* num = reinterpret_cast<int*>(data);
        EXPECT_EQ(*num, 233);
        delete num;
      },
      nullptr);

  EXPECT_EQ(v.Data(), num);
}

TEST_P(NAPITest, Equals) {
  if (std::get<0>(GetParam()) != "QJS") {
    // FIXME quickjs have no such functions
    EXPECT_TRUE(
        Napi::Number::New(env, 233).StrictEquals(Napi::Number::New(env, 233)));
    auto obj = Napi::Object::New(env);
    EXPECT_TRUE(obj.StrictEquals(obj));
    EXPECT_TRUE(
        Napi::Number::New(env, 233).Equals(Napi::String::New(env, "233")));
  }
}

TEST_P(NAPITest, InvalidUTF8String) {
#ifdef ENABLE_MONITOR
  if (std::get<0>(GetParam()) != "QJS") {
    std::map<std::vector<uint8_t>, std::string> testcases = {
        {{0xfc, 0xB0, 0x80, 0x80, 0x80, 0x80, 0x61}, "������a"},
        {{32, 128, 33, 34}, " �!\""},
        {{0xe6, 0x88, 0x61}, "�a"},
        {{0xf4, 0x90, 0x80, 0x80}, "����"},
        {{0xf0, 0x9f, 0x98, 0x81}, "😁"},
        {{0xC0, 0xBF}, "��"}};

    for (auto& i : testcases) {
      std::string str(i.first.begin(), i.first.end());
      auto napi_string = Napi::String::New(env, str.c_str(), str.length());
      EXPECT_EQ(napi_string.Utf8Value(), i.second);
    }
  }
#endif
}

TEST_P(NAPITest, RunScriptWithLength) {
  std::string src = "123456";
  auto ret = env.RunScript(src.c_str(), 3, "");
  EXPECT_EQ(ret.ToString().Utf8Value(), "123");
}

INSTANTIATE_TEST_SUITE_P(
    EngineTest, NAPITest, ::testing::ValuesIn(test::runtimeFactory),
    [](const testing::TestParamInfo<NAPITest::ParamType>& info) {
      return std::get<0>(info.param);
    });

TEST_P(NAPITest, NapiCreateExteranArrayBuffer) {
  {
    HandleScope hscope(env);
    size_t length = 8;
    uint8_t* data = new uint8_t[length];
    for (size_t i = 0; i < length; i++) {
      data[i] = static_cast<uint8_t>(i);
    }

    Napi::ArrayBuffer arrayBuffer = Napi::ArrayBuffer::New(
        env, data, length,
        [](napi_env, void* data, void*) {
          delete[] static_cast<uint8_t*>(data);
        },
        nullptr);

    EXPECT_EQ(arrayBuffer.ByteLength(), length);
    uint8_t* arrayData = static_cast<uint8_t*>(arrayBuffer.Data());
    for (size_t i = 0; i < length; i++) {
      EXPECT_EQ(arrayData[i], static_cast<uint8_t>(i));
    }

    // Modify the data and check if the changes are reflected
    for (size_t i = 0; i < length; i++) {
      arrayData[i] = static_cast<uint8_t>(length - i);
    }

    for (size_t i = 0; i < length; i++) {
      EXPECT_EQ(arrayData[i], static_cast<uint8_t>(length - i));
    }
  }

  {
    HandleScope scope{env};
    size_t length = 8;
    auto arrayBuffe = Napi::ArrayBuffer::New(env, length);
    EXPECT_NE(arrayBuffe.Data(), nullptr);
    EXPECT_EQ(arrayBuffe.ByteLength(), length);
  }
}

TEST_P(NAPITest, NapiTypedArrayTest) {
  HandleScope hscope(env);

  // Create a TypedArray from an ArrayBuffer
  size_t length = 8;
  uint8_t* data = new uint8_t[length];
  for (size_t i = 0; i < length; i++) {
    data[i] = static_cast<uint8_t>(i);
  }

  Napi::ArrayBuffer arrayBuffer = Napi::ArrayBuffer::New(
      env, data, length,
      [](napi_env, void* data, void*) { delete[] static_cast<uint8_t*>(data); },
      nullptr);

  Napi::Uint8Array typedArray =
      Napi::Uint8Array::New(env, length, arrayBuffer, 0);

  EXPECT_EQ(typedArray.ByteLength(), length);
  EXPECT_EQ(typedArray.ArrayBuffer(), arrayBuffer);

  for (size_t i = 0; i < length; i++) {
    EXPECT_EQ(typedArray[i], static_cast<uint8_t>(i));
  }

  // Modify the TypedArray and check if the changes are reflected in the
  // ArrayBuffer
  for (size_t i = 0; i < length; i++) {
    typedArray[i] = static_cast<uint8_t>(i * 2);
  }

  uint8_t* arrayData = static_cast<uint8_t*>(arrayBuffer.Data());
  for (size_t i = 0; i < length; i++) {
    EXPECT_EQ(arrayData[i], static_cast<uint8_t>(i * 2));
  }

  {
    void* target_data;
    napi_value ab;

    NAPI_ENV_CALL(get_typedarray_info, static_cast<napi_env>(env),
                  static_cast<napi_value>(typedArray), nullptr, nullptr,
                  &target_data, &ab, nullptr);
    EXPECT_EQ(target_data, data);
    EXPECT_EQ(arrayBuffer, Napi::Value(env, ab));
  }
}
