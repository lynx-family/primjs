// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <gtest/gtest.h>
#include <stdio.h>

#include <cstdint>
#include <fstream>
#include <memory>
#include <string>
#include <thread>
#include <vector>

#include "code_cache.h"

namespace {

const char kCachePath[] = "test-code-cache.bin";
const uint64_t kHashA = CacheBlob::HashSource("source A", 8);
const uint64_t kHashB = CacheBlob::HashSource("source B", 8);

std::vector<uint8_t> Bytes(uint8_t content, int length) {
  return std::vector<uint8_t>(length, content);
}

bool Insert(CacheBlob* blob, const std::string& filename, uint64_t source_hash,
            uint8_t content, int length) {
  std::vector<uint8_t> data = Bytes(content, length);
  return blob->insert(filename, source_hash, data.data(), length);
}

std::vector<uint8_t> ReadFile(const std::string& path) {
  std::ifstream in(path, std::ios::binary);
  return std::vector<uint8_t>((std::istreambuf_iterator<char>(in)),
                              std::istreambuf_iterator<char>());
}

void WriteFile(const std::string& path, const std::vector<uint8_t>& bytes) {
  std::ofstream out(path, std::ios::binary | std::ios::trunc);
  out.write(reinterpret_cast<const char*>(bytes.data()), bytes.size());
}

class CodeCacheTest : public ::testing::Test {
 protected:
  void SetUp() override { remove(kCachePath); }
  void TearDown() override { remove(kCachePath); }

  bool CacheFileExists() {
    FILE* file = fopen(kCachePath, "rb");
    if (file == nullptr) return false;
    fclose(file);
    return true;
  }
};

TEST_F(CodeCacheTest, FindReturnsCopyOfInsertedData) {
  CacheBlob blob(kCachePath);
  ASSERT_TRUE(Insert(&blob, "f1.js", kHashA, 1, 16));

  std::vector<uint8_t> out;
  ASSERT_TRUE(blob.find("f1.js", kHashA, &out));
  EXPECT_EQ(out, Bytes(1, 16));
  EXPECT_EQ(blob.size(), 16);

  EXPECT_FALSE(blob.find("missing.js", kHashA, &out));
  EXPECT_TRUE(out.empty());
}

TEST_F(CodeCacheTest, ChangedSourceMissesUntilReplaced) {
  CacheBlob blob(kCachePath);
  ASSERT_TRUE(Insert(&blob, "f1.js", kHashA, 1, 16));

  std::vector<uint8_t> out;
  EXPECT_FALSE(blob.find("f1.js", kHashB, &out));
  EXPECT_TRUE(out.empty());

  ASSERT_TRUE(Insert(&blob, "f1.js", kHashB, 2, 1024));
  ASSERT_TRUE(blob.find("f1.js", kHashB, &out));
  EXPECT_EQ(out, Bytes(2, 1024));
  EXPECT_FALSE(blob.find("f1.js", kHashA, &out));
  EXPECT_EQ(blob.size(), 1024);
}

TEST_F(CodeCacheTest, RejectsInvalidInput) {
  CacheBlob blob(kCachePath, 64);
  std::vector<uint8_t> data = Bytes(1, 8);
  EXPECT_FALSE(blob.insert("f.js", kHashA, nullptr, 8));
  EXPECT_FALSE(blob.insert("f.js", kHashA, data.data(), 0));
  EXPECT_FALSE(Insert(&blob, "f.js", kHashA, 1, 65));
  EXPECT_TRUE(Insert(&blob, "f.js", kHashA, 1, 64));
}

TEST_F(CodeCacheTest, EvictsLeastUsedWhenFull) {
  CacheBlob blob(kCachePath, 100);
  ASSERT_TRUE(Insert(&blob, "hot.js", kHashA, 1, 40));
  ASSERT_TRUE(Insert(&blob, "cold.js", kHashA, 2, 40));
  std::vector<uint8_t> out;
  ASSERT_TRUE(blob.find("hot.js", kHashA, &out));

  ASSERT_TRUE(Insert(&blob, "new.js", kHashA, 3, 40));
  EXPECT_TRUE(blob.find("hot.js", kHashA, &out));
  EXPECT_FALSE(blob.find("cold.js", kHashA, &out));
  EXPECT_TRUE(blob.find("new.js", kHashA, &out));
  EXPECT_EQ(blob.size(), 80);
}

TEST_F(CodeCacheTest, OutputAndInputRoundTrip) {
  {
    CacheBlob blob(kCachePath);
    ASSERT_TRUE(Insert(&blob, "f0.js", kHashA, 0, 16));
    ASSERT_TRUE(Insert(&blob, "f1.js", kHashB, 1, 1024));
    blob.output();
  }
  ASSERT_TRUE(CacheFileExists());

  CacheBlob blob(kCachePath);
  ASSERT_TRUE(blob.input());
  EXPECT_TRUE(blob.input());
  EXPECT_EQ(blob.size(), 1040);
  std::vector<uint8_t> out;
  ASSERT_TRUE(blob.find("f0.js", kHashA, &out));
  EXPECT_EQ(out, Bytes(0, 16));
  ASSERT_TRUE(blob.find("f1.js", kHashB, &out));
  EXPECT_EQ(out, Bytes(1, 1024));
  EXPECT_FALSE(blob.find("f1.js", kHashA, &out));
}

TEST_F(CodeCacheTest, OutputOnlyWritesWhenDirty) {
  CacheBlob blob(kCachePath);
  blob.output();
  EXPECT_FALSE(CacheFileExists());

  ASSERT_TRUE(Insert(&blob, "f0.js", kHashA, 0, 16));
  blob.output();
  ASSERT_TRUE(CacheFileExists());

  remove(kCachePath);
  blob.output();
  EXPECT_FALSE(CacheFileExists());

  std::vector<uint8_t> out;
  ASSERT_TRUE(blob.find("f0.js", kHashA, &out));
  blob.output();
  EXPECT_FALSE(CacheFileExists());
}

TEST_F(CodeCacheTest, InputMergesEntriesInsertedBeforeLoad) {
  {
    CacheBlob blob(kCachePath);
    ASSERT_TRUE(Insert(&blob, "f0.js", kHashA, 0, 16));
    ASSERT_TRUE(Insert(&blob, "f1.js", kHashA, 1, 16));
    blob.output();
  }

  CacheBlob blob(kCachePath);
  ASSERT_TRUE(Insert(&blob, "f0.js", kHashB, 2, 32));
  ASSERT_TRUE(blob.input());
  EXPECT_EQ(blob.size(), 48);
  std::vector<uint8_t> out;
  ASSERT_TRUE(blob.find("f0.js", kHashB, &out));
  EXPECT_EQ(out, Bytes(2, 32));
  ASSERT_TRUE(blob.find("f1.js", kHashA, &out));
}

TEST_F(CodeCacheTest, TruncatedFileIsRejectedAndRewritten) {
  {
    CacheBlob blob(kCachePath);
    ASSERT_TRUE(Insert(&blob, "f0.js", kHashA, 0, 512));
    ASSERT_TRUE(Insert(&blob, "f1.js", kHashA, 1, 512));
    blob.output();
  }
  std::vector<uint8_t> bytes = ReadFile(kCachePath);
  ASSERT_GT(bytes.size(), 700u);
  bytes.resize(700);
  WriteFile(kCachePath, bytes);

  CacheBlob blob(kCachePath);
  EXPECT_FALSE(blob.input());
  EXPECT_EQ(blob.size(), 0);

  blob.output();
  CacheBlob reloaded(kCachePath);
  EXPECT_TRUE(reloaded.input());
  EXPECT_EQ(reloaded.size(), 0);
}

TEST_F(CodeCacheTest, CorruptedDataIsRejected) {
  {
    CacheBlob blob(kCachePath);
    ASSERT_TRUE(Insert(&blob, "f0.js", kHashA, 0, 512));
    blob.output();
  }
  std::vector<uint8_t> bytes = ReadFile(kCachePath);
  bytes[bytes.size() / 2] ^= 0xFF;
  WriteFile(kCachePath, bytes);

  CacheBlob blob(kCachePath);
  EXPECT_FALSE(blob.input());
  EXPECT_EQ(blob.size(), 0);
}

TEST_F(CodeCacheTest, ForeignFormatIsRejected) {
  WriteFile(kCachePath, Bytes(0x42, 4096));
  CacheBlob blob(kCachePath);
  EXPECT_FALSE(blob.input());
  EXPECT_EQ(blob.size(), 0);
}

TEST_F(CodeCacheTest, OpenSharesOneBlobPerPath) {
  std::shared_ptr<CacheBlob> first = CacheBlob::Open(kCachePath, 4096);
  std::shared_ptr<CacheBlob> second = CacheBlob::Open(kCachePath, 1);
  EXPECT_EQ(first, second);
  EXPECT_NE(first, CacheBlob::Open("other-code-cache.bin", 4096));

  ASSERT_TRUE(Insert(first.get(), "f0.js", kHashA, 0, 16));
  std::vector<uint8_t> out;
  EXPECT_TRUE(second->find("f0.js", kHashA, &out));

  first.reset();
  second.reset();
  std::shared_ptr<CacheBlob> fresh = CacheBlob::Open(kCachePath, 4096);
  EXPECT_FALSE(fresh->find("f0.js", kHashA, &out));
}

TEST_F(CodeCacheTest, ConcurrentAccessFromSeveralThreads) {
  std::shared_ptr<CacheBlob> blob = CacheBlob::Open(kCachePath, 1 << 20);
  std::vector<std::thread> threads;
  for (int t = 0; t < 4; ++t) {
    threads.emplace_back([blob, t] {
      const std::string filename = "worker" + std::to_string(t) + ".js";
      for (int i = 0; i < 200; ++i) {
        ASSERT_TRUE(
            Insert(blob.get(), filename, kHashA, static_cast<uint8_t>(t), 256));
        std::vector<uint8_t> out;
        ASSERT_TRUE(blob->find(filename, kHashA, &out));
        EXPECT_EQ(out, Bytes(static_cast<uint8_t>(t), 256));
        blob->find("worker0.js", kHashA, &out);
        if (i % 50 == 0) blob->output();
      }
    });
  }
  for (auto& thread : threads) thread.join();
  EXPECT_EQ(blob->size(), 4 * 256);
}

}  // namespace
