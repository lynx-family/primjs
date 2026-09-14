// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <gtest/gtest.h>
#include <stdio.h>

#include <cstring>
#include <memory>
#include <string>
#include <vector>

#include "napi/common/code_cache.h"
#include "testlib.h"

namespace {

const char kCachePath[] = "test-script-code-cache.bin";
const char kFilename[] = "app.js";
const char kScriptOne[] = "function answer() { return 1; } answer()";
const char kScriptTwo[] = "function answer() { return 2; } answer()";

uint64_t Hash(const char* script) {
  return CacheBlob::HashSource(script, strlen(script));
}

int32_t RunWithCache(Napi::Env env, const char* script) {
  Napi::HandleScope scope(env);
  Napi::Value value = env.RunScriptCache(script, kFilename);
  EXPECT_FALSE(env.IsExceptionPending());
  return value.ToNumber().Int32Value();
}

std::string RunWithCacheToString(Napi::Env env, const char* script) {
  Napi::HandleScope scope(env);
  Napi::Value value = env.RunScriptCache(script, kFilename);
  EXPECT_FALSE(env.IsExceptionPending());
  return value.ToString().Utf8Value();
}

// Runs under every engine linked into the binary.
class CodeCacheScriptTest
    : public ::testing::TestWithParam<test::RuntimeFactory> {
 protected:
  void SetUp() override {
    if (GetParam().first == "JSC") {
      GTEST_SKIP() << "JavaScriptCore has no code cache";
    }
    remove(kCachePath);
  }
  void TearDown() override { remove(kCachePath); }

  std::unique_ptr<test::NAPIRuntime> NewRuntime(bool* loaded = nullptr) {
    std::unique_ptr<test::NAPIRuntime> runtime = GetParam().second();
    bool result = runtime->Env().InitCodeCache(1 << 20, kCachePath);
    if (loaded != nullptr) *loaded = result;
    return runtime;
  }

  bool Prepare(const char* script, const char* filename = kFilename) {
    std::unique_ptr<test::NAPIRuntime> compiler = GetParam().second();
    return compiler->Env().PrepareCodeCache(1 << 20, kCachePath, filename,
                                            script, strlen(script));
  }
};

INSTANTIATE_TEST_SUITE_P(
    Engines, CodeCacheScriptTest, ::testing::ValuesIn(test::runtimeFactory),
    [](const ::testing::TestParamInfo<test::RuntimeFactory>& info) {
      return info.param.first;
    });

TEST_P(CodeCacheScriptTest, CachedBytecodeIsConsumedOnHit) {
  std::unique_ptr<test::NAPIRuntime> runtime = NewRuntime();
  Napi::Env env = runtime->Env();
  EXPECT_EQ(RunWithCache(env, kScriptOne), 1);

  std::vector<uint8_t> bytecode_one;
  std::shared_ptr<CacheBlob> blob = CacheBlob::Open(kCachePath, 1 << 20);
  ASSERT_TRUE(blob->find(kFilename, Hash(kScriptOne), &bytecode_one));

  // A hit must run the bytecode, not the source.
  ASSERT_TRUE(blob->insert(kFilename, Hash(kScriptTwo), bytecode_one.data(),
                           static_cast<int>(bytecode_one.size())));
  EXPECT_EQ(RunWithCache(env, kScriptTwo), 1);
}

TEST_P(CodeCacheScriptTest, ChangedSourceUnderSameNameIsRecompiled) {
  std::unique_ptr<test::NAPIRuntime> runtime = NewRuntime();
  Napi::Env env = runtime->Env();
  EXPECT_EQ(RunWithCache(env, kScriptOne), 1);
  EXPECT_EQ(RunWithCache(env, kScriptTwo), 2);
  EXPECT_EQ(RunWithCache(env, kScriptOne), 1);

  std::vector<uint8_t> out;
  std::shared_ptr<CacheBlob> blob = CacheBlob::Open(kCachePath, 1 << 20);
  EXPECT_TRUE(blob->find(kFilename, Hash(kScriptOne), &out));
  EXPECT_FALSE(blob->find(kFilename, Hash(kScriptTwo), &out));
}

TEST_P(CodeCacheScriptTest, UnloadableBytecodeIsReplaced) {
  std::unique_ptr<test::NAPIRuntime> runtime = NewRuntime();
  Napi::Env env = runtime->Env();
  std::shared_ptr<CacheBlob> blob = CacheBlob::Open(kCachePath, 1 << 20);
  std::vector<uint8_t> garbage(64, 0x7F);
  ASSERT_TRUE(blob->insert(kFilename, Hash(kScriptOne), garbage.data(),
                           static_cast<int>(garbage.size())));

  EXPECT_EQ(RunWithCache(env, kScriptOne), 1);

  std::vector<uint8_t> out;
  ASSERT_TRUE(blob->find(kFilename, Hash(kScriptOne), &out));
  EXPECT_NE(out, garbage);
  EXPECT_EQ(RunWithCache(env, kScriptOne), 1);
}

TEST_P(CodeCacheScriptTest, CacheSurvivesRuntimeRestart) {
  std::vector<uint8_t> bytecode;
  bool loaded = true;
  {
    std::unique_ptr<test::NAPIRuntime> runtime = NewRuntime(&loaded);
    EXPECT_FALSE(loaded);
    EXPECT_EQ(RunWithCache(runtime->Env(), kScriptOne), 1);
    std::shared_ptr<CacheBlob> blob = CacheBlob::Open(kCachePath, 1 << 20);
    ASSERT_TRUE(blob->find(kFilename, Hash(kScriptOne), &bytecode));
    runtime->Env().OutputCodeCache();
  }

  std::unique_ptr<test::NAPIRuntime> runtime = NewRuntime(&loaded);
  EXPECT_TRUE(loaded);
  std::vector<uint8_t> reloaded;
  std::shared_ptr<CacheBlob> blob = CacheBlob::Open(kCachePath, 1 << 20);
  ASSERT_TRUE(blob->find(kFilename, Hash(kScriptOne), &reloaded));
  EXPECT_EQ(reloaded, bytecode);
  EXPECT_EQ(RunWithCache(runtime->Env(), kScriptOne), 1);
}

TEST_P(CodeCacheScriptTest, PreparedCacheServesTheFirstRun) {
  ASSERT_TRUE(Prepare(kScriptOne));

  // Only a first run that consumes the file can answer 1 for script two.
  {
    std::shared_ptr<CacheBlob> blob = CacheBlob::Open(kCachePath, 1 << 20);
    std::vector<uint8_t> prepared;
    ASSERT_TRUE(blob->input());
    ASSERT_TRUE(blob->find(kFilename, Hash(kScriptOne), &prepared));
    ASSERT_TRUE(blob->insert(kFilename, Hash(kScriptTwo), prepared.data(),
                             static_cast<int>(prepared.size())));
    ASSERT_TRUE(blob->output());
  }

  std::unique_ptr<test::NAPIRuntime> runtime = NewRuntime();
  EXPECT_EQ(RunWithCache(runtime->Env(), kScriptTwo), 1);
}

TEST_P(CodeCacheScriptTest, PreparedBytecodeNamesTheScriptInStackTraces) {
  const char* script = "function where() { return new Error().stack; } where()";
  ASSERT_TRUE(Prepare(script));

  std::unique_ptr<test::NAPIRuntime> runtime = NewRuntime();
  EXPECT_NE(RunWithCacheToString(runtime->Env(), script).find(kFilename),
            std::string::npos);
}

TEST_P(CodeCacheScriptTest, ColdCacheNamesTheScriptInStackTraces) {
  const char* script = "function where() { return new Error().stack; } where()";
  std::unique_ptr<test::NAPIRuntime> runtime = NewRuntime();
  EXPECT_NE(RunWithCacheToString(runtime->Env(), script).find(kFilename),
            std::string::npos);
}

TEST_P(CodeCacheScriptTest, PrepareKeepsEntriesOfOtherScripts) {
  ASSERT_TRUE(Prepare(kScriptTwo, "other.js"));
  ASSERT_TRUE(Prepare(kScriptOne));

  // Keeps the blob loaded from the file alive for the lookups below.
  std::unique_ptr<test::NAPIRuntime> runtime = NewRuntime();
  std::vector<uint8_t> out;
  std::shared_ptr<CacheBlob> blob = CacheBlob::Open(kCachePath, 1 << 20);
  EXPECT_TRUE(blob->find("other.js", Hash(kScriptTwo), &out));
  EXPECT_TRUE(blob->find(kFilename, Hash(kScriptOne), &out));
}

// What an engine adapter built against the old function table observes.
TEST_P(CodeCacheScriptTest, LegacySlotsNeitherServeNorStoreEntries) {
  std::unique_ptr<test::NAPIRuntime> runtime = NewRuntime();
  Napi::Env env = runtime->Env();
  EXPECT_EQ(RunWithCache(env, kScriptOne), 1);

  napi_env raw_env = env;
  const uint8_t* data = reinterpret_cast<const uint8_t*>(kScriptOne);
  int length = 0;
  EXPECT_EQ(raw_env->napi_get_code_cache(raw_env, kFilename, &data, &length),
            napi_ok);
  EXPECT_EQ(data, nullptr);
  EXPECT_EQ(length, -1);

  std::shared_ptr<CacheBlob> blob = CacheBlob::Open(kCachePath, 1 << 20);
  int size_before = blob->size();
  std::vector<uint8_t> bytecode(16, 0x7F);
  EXPECT_NE(
      raw_env->napi_store_code_cache(raw_env, "legacy.js", bytecode.data(),
                                     static_cast<int>(bytecode.size())),
      napi_ok);
  EXPECT_EQ(blob->size(), size_before);

  auto compile_slot = raw_env->napi_compile_code_cache;
  raw_env->napi_compile_code_cache = nullptr;
  EXPECT_FALSE(env.PrepareCodeCache(1 << 20, kCachePath, "prepared.js",
                                    kScriptOne, strlen(kScriptOne)));
  raw_env->napi_compile_code_cache = compile_slot;
}

#ifdef JS_ENGINE_V8
size_t NativeContextCountAfterGC(v8::Isolate* isolate) {
  isolate->LowMemoryNotification();
  v8::HeapStatistics stats;
  isolate->GetHeapStatistics(&stats);
  return stats.number_of_native_contexts();
}

// Runs `script` through the cache in a context of its own, the way every
// worker sharing one isolate does, then tears the context down.
void RunWithCacheInTemporaryContext(v8::Isolate* isolate, const char* script) {
  v8::HandleScope handles(isolate);
  v8::Local<v8::Context> context = v8::Context::New(isolate);
  v8::Context::Scope context_scope(context);
  napi_env raw_env = napi_new_env();
  napi_runtime_configuration config = napi_create_runtime_configuration();
  napi_attach_runtime_with_configuration(raw_env, config);
  napi_delete_runtime_configuration(config);
  napi_attach_v8(raw_env, context);
  {
    Napi::Env env(raw_env);
    Napi::HandleScope scope(env);
    env.InitCodeCache(1 << 20, kCachePath);
    env.RunScriptCache(script, kFilename);
    EXPECT_FALSE(env.IsExceptionPending());
  }
  napi_detach_runtime(raw_env);
  napi_detach_v8(raw_env);
  napi_free_env(raw_env);
}

TEST(CodeCacheV8Test, MissDoesNotKeepTheContextAlive) {
  remove(kCachePath);
  test::NAPIRuntimeV8SingleMode runtime;
  runtime.Env().InitCodeCache(1 << 20, kCachePath);
  v8::Isolate* isolate = v8::Isolate::GetCurrent();
  size_t before = NativeContextCountAfterGC(isolate);

  // A different source each time, so every run misses and creates a cache.
  for (int i = 0; i < 4; ++i) {
    std::string script =
        "function answer() { return " + std::to_string(i) + "; } answer()";
    RunWithCacheInTemporaryContext(isolate, script.c_str());
  }

  EXPECT_EQ(NativeContextCountAfterGC(isolate), before);
}
#endif  // JS_ENGINE_V8

}  // namespace
