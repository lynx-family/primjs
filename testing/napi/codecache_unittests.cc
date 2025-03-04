#include <gtest/gtest.h>
#include <stdio.h>

#include <iostream>
#include <queue>
#include <string>
#include <thread>

#include "code_cache.h"

namespace {
class WorkerThread {
 public:
  using Task = std::function<void()>;

  WorkerThread(size_t stack_size = 0) : stopped_(false) {
#if !defined(OS_WIN)
#if WIN32
    thread_.p = nullptr;
    thread_.x = 0;
#else
    thread_ = (pthread_t)((unsigned long long)0);
#endif
    pthread_attr_t thread_attr;
    pthread_attr_init(&thread_attr);

    if (stack_size) {
      pthread_attr_setstacksize(&thread_attr, stack_size);
    }

    int ret = pthread_create(
        &thread_, &thread_attr,
        [](void* data) -> void* {
          static_cast<WorkerThread*>(data)->Run();
          return nullptr;
        },
        this);
    (void)ret;
    assert(ret == 0);

    pthread_attr_destroy(&thread_attr);
#endif
  }

  ~WorkerThread() { Stop(); }

  void Stop() {
#if !defined(OS_WIN)
#if WIN32
    if (nullptr != thread_.p)
#else
    if ((pthread_t)((unsigned long long)0) != thread_)
#endif
    {
      {
        std::lock_guard<std::mutex> lock(mutex_);
        stopped_ = true;
        cond_.notify_one();
      }
      ::pthread_join(thread_, nullptr);
#if WIN32
      thread_.p = nullptr;
      thread_.x = 0;
#else
      thread_ = (pthread_t)((unsigned long long)0);
#endif
    }
#endif
  }

  void PostTask(Task task) {
    std::lock_guard<std::mutex> lock(mutex_);
    bool empty = queue_.empty();
    queue_.push(std::move(task));
    if (empty) {
      cond_.notify_one();
    }
  }

 private:
  void Run() {
    while (true) {
      Task task;
      {
        std::unique_lock<std::mutex> lock(mutex_);
        cond_.wait(lock, [this] { return !queue_.empty() || stopped_; });
        if (stopped_) {
          break;
        }
        task = std::move(queue_.front());
        queue_.pop();
      }
      task();
    }
  }

#if !defined(OS_WIN)
  pthread_t thread_;
#endif
  std::mutex mutex_;
  std::condition_variable cond_;
  std::queue<Task> queue_;
  bool stopped_;
};
}  // namespace

class CodeCacheTest : public ::testing::Test {
 protected:
  std::unique_ptr<CacheBlob> blob_;

 private:
  std::unique_ptr<WorkerThread> worker_;
  static const std::string cache_path_;

 public:
  CodeCacheTest()
      : blob_(new CacheBlob(cache_path_)), worker_(new WorkerThread()) {}

  void RemoveCacheFile() { remove(cache_path_.c_str()); }

  void WriteCodeCache(const std::string& filename, uint8_t* data, int len) {
    uint8_t* buf = new uint8_t[len];
    memcpy(buf, data, len);
    worker_->PostTask([=]() {
      if (!blob_->insert(filename, buf, len)) {
        delete[] buf;
      }
    });
    delete[] data;
    // To avoid that the whole process exit quickly
    // which make the task skipped.
    std::this_thread::sleep_for(std::chrono::milliseconds(1));
  }

  void ReInitCacheBlob(int max_size = 0) {
    blob_->output();
    // Wait for blob to finish its file operations.
    std::this_thread::sleep_for(std::chrono::milliseconds(1));
    if (max_size) {
      blob_.reset(new CacheBlob(cache_path_, max_size));
    } else {
      blob_.reset(new CacheBlob(cache_path_));
    }
  }

  void InputCacheFile() {
    CacheBlob* blob = blob_.get();
    worker_->PostTask([blob]() { blob->input(); });
    // Wait for blob to finish its file operations.
    std::this_thread::sleep_for(std::chrono::milliseconds(1));
  }

  bool CheckCacheFileExist() {
    FILE* file_in = fopen(cache_path_.c_str(), "r");
    return file_in != NULL;
  }

  void WriteTestContent(const std::string& filename, uint8_t content, int len) {
    uint8_t* data = new uint8_t[len];
    memset(data, content, len);
    WriteCodeCache(filename, data, len);
  }

  void StopWorker() { worker_->Stop(); }
};

const std::string CodeCacheTest::cache_path_ = "test-code-cache.bin";

TEST_F(CodeCacheTest, BlobInit) {
  uint8_t* data0 = new uint8_t[16];
  memset(data0, 1, 16);
  std::string f1("f1.js");
  WriteCodeCache(f1, data0, 16);

  int len = 0;
  const CachedData* r0 = blob_->find(f1, &len);
  ASSERT_NE(nullptr, r0);
  ASSERT_EQ(16, len);
  ASSERT_EQ(1, r0->data_[0]);

  uint8_t* data1 = new uint8_t[1024];
  memset(data1, 2, 1024);
  WriteCodeCache(f1, data1, 1024);

  r0 = blob_->find(f1, &len);
  ASSERT_NE(nullptr, r0);
  ASSERT_EQ(1024, len);
  ASSERT_EQ(2, r0->data_[0]);

  std::string f2("f2.js");
  ASSERT_EQ(blob_->find(f2, &len), nullptr);
  ASSERT_EQ(len, 0);
}

TEST_F(CodeCacheTest, ReadFile) {
  std::string f0("f0.js");
  std::string f1("f1.js");
  std::string f2("f2.js");

  int len0 = 16;
  int len1 = 1024;
  int len2 = 512;
  WriteTestContent(f0, 0, len0);
  WriteTestContent(f1, 1, len1);
  WriteTestContent(f2, 2, len2);

  ReInitCacheBlob(4096);
  ASSERT_TRUE(CheckCacheFileExist());

  InputCacheFile();
  const CachedData* data = nullptr;
  int len = -1;
  data = blob_->find(f0, &len);
  ASSERT_EQ(len0, len);
  ASSERT_NE(data, nullptr);
  ASSERT_EQ(data->data_[0], 0);

  len = -1;
  data = blob_->find(f2, &len);
  ASSERT_EQ(len2, len);
  ASSERT_NE(data, nullptr);
  ASSERT_EQ(data->data_[0], 2);
}

TEST_F(CodeCacheTest, Replace) {
  ReInitCacheBlob(64);

  std::string f0("f0.js");
  std::string f1("f1.js");
  std::string f2("f2.js");

  int len0 = 16;
  int len1 = 8;
  int len2 = 24;

  WriteTestContent(f0, 0, len0);
  WriteTestContent(f1, 1, len1);
  WriteTestContent(f2, 2, len2);

  std::string ft("ft.js");
  int lent = 24;
  WriteTestContent(ft, 't', lent);

  ASSERT_EQ(64, blob_->size());

  // Check whether f1 is replaced by ft
  int len = -1;
  auto data = blob_->find(ft, &len);
  ASSERT_EQ(lent, len);
  ASSERT_NE(data, nullptr);
  ASSERT_EQ(data->data_[0], 't');

  len = -1;
  data = blob_->find(f1, &len);
  ASSERT_EQ(0, len);
  ASSERT_EQ(nullptr, data);

  // heat f0 & f2.
  blob_->find(f0, &len);
  blob_->find(f0, &len);
  blob_->find(f2, &len);
  blob_->find(f2, &len);

  // ft is removed.
  WriteTestContent(f1, 'a', len1);
  ASSERT_EQ(blob_->size(), 48);
  ASSERT_EQ(nullptr, blob_->find(ft, &len));

  len = -1;
  data = blob_->find(f1, &len);
  ASSERT_NE(nullptr, data);
  ASSERT_EQ('a', data->data_[0]);
  ASSERT_EQ(len1, data->length_);
}

TEST_F(CodeCacheTest, Update) {
  ReInitCacheBlob(32);
  std::string f0("f0.js");
  std::string f1("f1.js");
  int len0 = 24;
  int len1 = 4;

  WriteTestContent(f0, 0, len0);
  WriteTestContent(f1, 1, len1);

  // update f1
  WriteTestContent(f1, 'a', len1);
  int len = -1;
  auto data = blob_->find(f1, &len);
  ASSERT_EQ(len1, len);
  ASSERT_NE(nullptr, data);
  ASSERT_EQ(data->data_[0], 'a');

  // update f1 and remove f0
  len1 = 28;
  WriteTestContent(f1, 'b', len1);
  len = -1;
  ASSERT_EQ(nullptr, blob_->find(f0, &len));
  ASSERT_EQ(0, len);
  ASSERT_EQ(len1, blob_->size());

  len = -1;
  data = blob_->find(f1, &len);
  ASSERT_NE(nullptr, data->data_);
  ASSERT_EQ(len1, data->length_);
  ASSERT_EQ('b', data->data_[0]);
}

TEST_F(CodeCacheTest, Remove) {
  ReInitCacheBlob(32);

  std::string f0("f0.js");
  std::string f1("f1.js");

  int len0 = 24;
  int len1 = 8;

  WriteTestContent(f0, 'a', len0);
  WriteTestContent(f1, 'b', len1);

  int len = -1;
  auto data = blob_->find(f0, &len);
  ASSERT_NE(nullptr, data);
  ASSERT_EQ(len0, len);

  blob_->remove(f0);
  len = -1;
  data = blob_->find(f0, &len);
  ASSERT_EQ(nullptr, data);
  ASSERT_EQ(0, len);
  ASSERT_EQ(len1, blob_->size());
}

TEST_F(CodeCacheTest, Boundary) {
  std::string f0("f0.js");
  std::string f1("f1.js");

  uint8_t* d = new uint8_t[8];
  // illegal inputs.
  ASSERT_FALSE(blob_->insert(f0, nullptr, 16));
  ASSERT_FALSE(blob_->insert(f0, d, 0));
  ASSERT_TRUE(blob_->insert(f0, d, 16));
}
