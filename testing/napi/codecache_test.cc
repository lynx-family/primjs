#include <chrono>
#include <fstream>
#include <iostream>
#include <sstream>
#include <thread>
#include <unordered_map>
#include <unordered_set>

#include "stdio.h"
#include "testlib.h"

using namespace Napi;
using namespace test;

void read_string(const char* filename, char** src) {
  std::ifstream file_in(filename);
  if (file_in.is_open()) {
    file_in.seekg(0, file_in.end);
    int length = static_cast<int>(file_in.tellg());
    file_in.seekg(0, file_in.beg);

    char* buffer = new char[length];
    file_in.read(buffer, length);
    *src = buffer;
  }
  file_in.close();
}

struct CacheStatus {
  int total_query_ = 0;
  int missed_query_ = 0;
  int expired_query_ = 0;
  bool update_ = false;
  int size_ = 0;
};
class Tester {
 public:
  Tester(bool print, std::unique_ptr<NAPIRuntime> runtime)
      : _print(print), _runtime(std::move(runtime)), _env(_runtime->Env()) {}
  virtual ~Tester() = default;
  void test_ExecutionTime();
  void test_All();

  void test_OutputCodeCache();
  void test_InputCodeCache();
  void test_AppendCache();
  void test_ReplaceCache();

 private:
  void analyze_cache_statistics();

  bool _print;
  std::unique_ptr<NAPIRuntime> _runtime;
  Napi::Env _env;
  CacheStatus _cache_status;
};

void Tester::test_All() {
  test_OutputCodeCache();
  test_InputCodeCache();
  test_AppendCache();
  test_ReplaceCache();
}

void Tester::analyze_cache_statistics() {
  std::vector<std::pair<std::string, int> >* status_vec =
      new std::vector<std::pair<std::string, int> >();
  _env.DumpCacheStatus(status_vec);
  if (status_vec->empty()) {
    std::cout << "Nothing to dump, check 'PROFILE_CODECACHE' is enabled or not."
              << std::endl;
    return;
  }
  _cache_status.total_query_ = status_vec->at(0).second;
  _cache_status.missed_query_ = status_vec->at(1).second;
  _cache_status.expired_query_ = status_vec->at(2).second;
  _cache_status.update_ = status_vec->at(3).second == 1;
  _cache_status.size_ = status_vec->at(4).second;

  if (!_print) return;
  std::cout << "Dumping cache statistics..." << std::endl;
  for (int i = 0; i < Env::CACHE_META_NUMS; ++i) {
    std::pair<std::string, int>& it = status_vec->at(i);
    std::cout << it.first << " : " << it.second << "." << std::endl;
  }

  for (size_t i = Env::CACHE_META_NUMS; i < status_vec->size(); ++i) {
    std::pair<std::string, int>& it = status_vec->at(i);
    std::cout << "  " << i - Env::CACHE_META_NUMS << ": [ name: " << it.first
              << ", " << it.second << " ] \n";
  }
  delete status_vec;
}

void Tester::test_OutputCodeCache() {
  _env.InitCodeCache(4096, "napi-test-cache.bin", [](bool t) {});
  HandleScope hscope(_env);

  const char* script =
      "function fabo(x) {"
      "  if (x < 2)  return x;"
      "  else        return fabo(x-1) + fabo(x-2);"
      "}"
      "fabo(10)";
  auto v = _env.RunScriptCache(script, "test.js");
  EXPECT_EQ(v.ToNumber().Int32Value(), 55);

  std::this_thread::sleep_for(std::chrono::milliseconds(100));

  const char* script2 =
      "function sort(x) {"
      "  for (var i = 0; i < x.length; ++i) {"
      "    for (var j = 0; j < x.length - i; ++j) {"
      "      if (x[j] > x[j + 1]) {"
      "        var temp = x[j];"
      "        x[j ] = x[j+1];"
      "        x[j+1] = temp;"
      "      }"
      "    }"
      "  }"
      "}"
      "var arr = [4, 3, 5, 10, 11, 0, 25, 99];"
      "sort(arr);"
      "arr + ' yes!'";

  v = _env.RunScriptCache(script2, "test2.js");

  std::this_thread::sleep_for(std::chrono::milliseconds(200));

  v = _env.RunScriptCache(script2, "test2.js");
  v = _env.RunScriptCache(script2, "test2.js");

  analyze_cache_statistics();
  EXPECT_EQ(_cache_status.total_query_, 4);
  EXPECT_EQ(_cache_status.missed_query_, 2);
  EXPECT_EQ(_cache_status.expired_query_, 0);
  EXPECT_TRUE(_cache_status.update_);

  _env.OutputCodeCache();
  // worker thread correctly finish their work
  std::this_thread::sleep_for(std::chrono::milliseconds(200));
}

void Tester::test_InputCodeCache() {
  HandleScope hscope(_env);

  _env.InitCodeCache(4096, "napi-test-cache.bin", [](bool t) {});
  // worker thread correctly finish their work
  std::this_thread::sleep_for(std::chrono::milliseconds(400));
  // _env.DumpCacheStatus();
  const char* script =
      "function fabo(x) {"
      "  if (x < 2)  return x;"
      "  else        return fabo(x-1) + fabo(x-2);"
      "}"
      "fabo(10)";
  auto v = _env.RunScriptCache(script, "test.js");
  EXPECT_EQ(v.ToNumber().Int32Value(), 55);

  const char* script2 =
      "function sort(x) {"
      "  for (var i = 0; i < x.length; ++i) {"
      "    for (var j = 0; j < x.length - i; ++j) {"
      "      if (x[j] > x[j + 1]) {"
      "        var temp = x[j];"
      "        x[j ] = x[j+1];"
      "        x[j+1] = temp;"
      "      }"
      "    }"
      "  }"
      "}"
      "var arr = [4, 3, 5, 10, 11, 0, 25, 99];"
      "sort(arr);"
      "arr + ' yes!'";

  v = _env.RunScriptCache(script2, "test2.js");

  v = _env.RunScriptCache(script2, "test2.js");
  v = _env.RunScriptCache(script2, "test2.js");

  analyze_cache_statistics();
  EXPECT_EQ(_cache_status.total_query_, 4);
  EXPECT_EQ(_cache_status.missed_query_, 0);
  EXPECT_EQ(_cache_status.expired_query_, 0);
  EXPECT_FALSE(_cache_status.update_);

  _env.OutputCodeCache();

  std::this_thread::sleep_for(std::chrono::milliseconds(200));
  // _env.DumpCacheStatus();
}

void Tester::test_AppendCache() {
  _env.InitCodeCache(4096, "napi-test-cache.bin", [](bool t) {});

  std::this_thread::sleep_for(std::chrono::milliseconds(100));
  // _env.DumpCacheStatus();
  const char* script =
      "function ffun(x) {"
      "  return x + 1;"
      "}"
      "ffun(10)";
  auto v = _env.RunScriptCache(script, "base.js");
  EXPECT_EQ(v.ToNumber().Int32Value(), 11);

  std::this_thread::sleep_for(std::chrono::milliseconds(100));

  script =
      "function fabo(x) {"
      "  if (x < 2)  return x;"
      "  else        return fabo(x-1) + fabo(x-2);"
      "}"
      "fabo(10)";
  v = _env.RunScriptCache(script, "test.js");
  EXPECT_EQ(v.ToNumber().Int32Value(), 55);

  analyze_cache_statistics();
  EXPECT_EQ(_cache_status.total_query_, 2);
  EXPECT_EQ(_cache_status.missed_query_, 1);
  EXPECT_EQ(_cache_status.expired_query_, 0);
  EXPECT_TRUE(_cache_status.update_);

  _env.OutputCodeCache();

  std::this_thread::sleep_for(std::chrono::milliseconds(100));
}

void Tester::test_ReplaceCache() {
  _env.InitCodeCache(2560, "napi-test-cache.bin", [](bool t) {});

  std::this_thread::sleep_for(std::chrono::milliseconds(100));
  // _env.DumpCacheStatus();
  const char* script =
      "function ffun(x) {"
      "  return (x + 3) * 2;"
      "}"
      "ffun(10)";
  auto v = _env.RunScriptCache(script, "base2.js");
  EXPECT_EQ(v.ToNumber().Int32Value(), 26);

  std::this_thread::sleep_for(std::chrono::milliseconds(100));
  analyze_cache_statistics();

  EXPECT_EQ(_cache_status.total_query_, 1);
  EXPECT_EQ(_cache_status.missed_query_, 1);
  EXPECT_EQ(_cache_status.expired_query_, 0);
  EXPECT_TRUE(_cache_status.update_);

  _env.OutputCodeCache();
  std::this_thread::sleep_for(std::chrono::milliseconds(100));
}

void Tester::test_ExecutionTime() {
  _env.InitCodeCache(1 << 18, "napi-test-cache.bin", [](bool t) {});
  std::this_thread::sleep_for(std::chrono::milliseconds(100));
  char* script = nullptr;
  const char* filename = "new_raytrace.js";
  read_string(filename, &script);
  if (script != nullptr) {
    auto v = _env.RunScriptCache(script, filename);
  } else {
    std::cout << " can not read source file : " << filename << std::endl;
  }
  std::cout << "in execution " << filename << std::endl;
  std::this_thread::sleep_for(std::chrono::milliseconds(100));
  analyze_cache_statistics();
  _env.OutputCodeCache();
  std::this_thread::sleep_for(std::chrono::milliseconds(100));
}

void DoTest(bool print_cache_status, NAPIRuntime* runtime) {
  remove("napi-test-cache.bin");
  Tester tester(print_cache_status, std::unique_ptr<NAPIRuntime>(runtime));
  tester.test_All();
}

int main(int argc, char** argv) {
  bool print_cache_status = false;
  bool test_qjs = false;
  bool test_v8 = false;
  for (int i = 1; i < argc; ++i) {
    if (strcmp(argv[i], "-p") == 0) {
      print_cache_status = true;
    } else if (strcmp(argv[i], "--V8") == 0) {
      test_v8 = true;
    } else if (strcmp(argv[i], "--QJS") == 0) {
      test_qjs = true;
    }
  }

  if (test_qjs) {
    std::cout << "----- Testing QuickJs -----" << std::endl;
    DoTest(print_cache_status, new NAPIRuntimeQJS());
  }

  if (test_v8) {
    std::cout << "----- Testing V8 -----" << std::endl;
    DoTest(print_cache_status, new NAPIRuntimeV8SingleMode());
  }

  std::cout << "----- All tests passed -----" << std::endl;
}
