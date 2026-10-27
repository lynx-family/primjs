// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License, Version 2.0, in the LICENSE file.

#include <algorithm>
#include <chrono>
#include <cstdlib>
#include <unordered_map>
#include <vector>

#include "gtest/gtest.h"
extern "C" {
#include "quickjs/include/libunicode.h"
}

namespace {
class NormalizationAllocator {
 public:
  explicit NormalizationAllocator(size_t fail_at = 0) : fail_at_(fail_at) {}
  ~NormalizationAllocator() {
    for (const auto& entry : live_) std::free(entry.first);
  }

  static void* Reallocate(void* opaque, void* pointer, size_t size, int) {
    auto* self = static_cast<NormalizationAllocator*>(opaque);
    if (size == 0) {
      self->live_.erase(pointer);
      std::free(pointer);
      return nullptr;
    }
    if (++self->calls_ == self->fail_at_) return nullptr;
    void* replacement = std::realloc(pointer, size);
    if (replacement) {
      self->live_.erase(pointer);
      self->live_[replacement] = size;
    }
    return replacement;
  }

  size_t live_allocations() const { return live_.size(); }

 private:
  size_t fail_at_;
  size_t calls_ = 0;
  std::unordered_map<void*, size_t> live_;
};

void ExpectNormalized(const std::vector<uint32_t>& input,
                      UnicodeNormalizationEnum form,
                      const std::vector<uint32_t>& expected) {
  NormalizationAllocator allocator;
  uint32_t* output = nullptr;
  const uint32_t empty = 0;
  const int length = unicode_normalize(
      &output, input.empty() ? &empty : input.data(), input.size(), form,
      &allocator, nullptr, NormalizationAllocator::Reallocate);
  ASSERT_EQ(length, expected.size());
  if (length != 0) {
    ASSERT_NE(output, nullptr);
    EXPECT_EQ(std::vector<uint32_t>(output, output + length), expected);
  }
  NormalizationAllocator::Reallocate(&allocator, output, 0, 0);
  EXPECT_EQ(allocator.live_allocations(), 0u);
}
}  // namespace

TEST(UnicodeNormalization, CanonicalCompatibilityAndHangulForms) {
  ExpectNormalized({0x01d5}, UNICODE_NFD, {'U', 0x0308, 0x0304});
  ExpectNormalized({'A', 0x030a}, UNICODE_NFC, {0x00c5});
  ExpectNormalized({0xfb03}, UNICODE_NFKD, {'f', 'f', 'i'});
  ExpectNormalized({0xff21, 0xfb03}, UNICODE_NFKC, {'A', 'f', 'f', 'i'});
  ExpectNormalized({0xac01}, UNICODE_NFD, {0x1100, 0x1161, 0x11a8});
  ExpectNormalized({0x1100, 0x1161, 0x11a8}, UNICODE_NFC, {0xac01});
}

TEST(UnicodeNormalization, EqualClassesStayStableAcrossStarterBoundaries) {
  ExpectNormalized({0x0315, 0x0301, 0x0300, 'x', 0x0315, 0x0301, 0x0300},
                   UNICODE_NFD,
                   {0x0301, 0x0300, 0x0315, 'x', 0x0301, 0x0300, 0x0315});
}

TEST(UnicodeNormalization, EmptyAndUnpairedSurrogateInputsArePreserved) {
  for (int form = UNICODE_NFC; form <= UNICODE_NFKD; ++form) {
    const auto normalization = static_cast<UnicodeNormalizationEnum>(form);
    ExpectNormalized({}, normalization, {});
    ExpectNormalized({0xd800, 'x', 0xdc00}, normalization,
                     {0xd800, 'x', 0xdc00});
  }
}

TEST(UnicodeNormalization, LongAlternatingClassesRemainCanonical) {
  constexpr size_t kPairs = 32768;
  std::vector<uint32_t> input = {'x'};
  for (size_t i = 0; i < kPairs; ++i) {
    input.push_back(0x0315);
    input.push_back(0x0300);
  }
  std::vector<uint32_t> expected = {'x'};
  expected.insert(expected.end(), kPairs, 0x0300);
  expected.insert(expected.end(), kPairs, 0x0315);
  const auto start = std::chrono::steady_clock::now();
  ExpectNormalized(input, UNICODE_NFD, expected);
  const auto elapsed = std::chrono::duration_cast<std::chrono::microseconds>(
      std::chrono::steady_clock::now() - start);
  RecordProperty("normalization_elapsed_us", static_cast<int>(elapsed.count()));
}

TEST(UnicodeNormalization, AllocationFailuresReleaseAllWorkspace) {
  const std::vector<uint32_t> input(512, 0xfb03);
  for (size_t fail_at = 1; fail_at <= 6; ++fail_at) {
    SCOPED_TRACE(fail_at);
    NormalizationAllocator allocator(fail_at);
    uint32_t* output = nullptr;
    const int length = unicode_normalize(&output, input.data(), input.size(),
                                         UNICODE_NFKD, &allocator, nullptr,
                                         NormalizationAllocator::Reallocate);
    if (length < 0) {
      EXPECT_EQ(output, nullptr);
      EXPECT_EQ(allocator.live_allocations(), 0u);
    } else {
      ASSERT_EQ(length, 1536);
      for (int i = 0; i < length; i += 3) {
        EXPECT_EQ(output[i], 'f');
        EXPECT_EQ(output[i + 1], 'f');
        EXPECT_EQ(output[i + 2], 'i');
      }
      NormalizationAllocator::Reallocate(&allocator, output, 0, 0);
      EXPECT_EQ(allocator.live_allocations(), 0u);
    }
  }
}

TEST(UnicodeNormalization, LargeRunsMatchIndependentClassOrdering) {
  const uint32_t marks[] = {0x0315, 0x0301, 0x0334, 0x0300, 0x0345, 0x0316};
  const auto combining_class = [](uint32_t point) {
    switch (point) {
      case 0x0334:
        return 1;
      case 0x0316:
        return 220;
      case 0x0300:
      case 0x0301:
        return 230;
      case 0x0315:
        return 232;
      default:
        return 240;
    }
  };
  for (size_t length : {1, 31, 32, 33, 4096}) {
    SCOPED_TRACE(length);
    std::vector<uint32_t> run;
    for (size_t i = 0; i < length; ++i) run.push_back(marks[(i * 5) % 6]);
    auto sorted = run;
    std::stable_sort(sorted.begin(), sorted.end(), [&](uint32_t a, uint32_t b) {
      return combining_class(a) < combining_class(b);
    });
    // Leading non-starters and a second run must not cross either starter.
    auto input = run;
    input.push_back('x');
    input.insert(input.end(), run.begin(), run.end());
    input.push_back('y');
    auto expected = sorted;
    expected.push_back('x');
    expected.insert(expected.end(), sorted.begin(), sorted.end());
    expected.push_back('y');
    ExpectNormalized(input, UNICODE_NFD, expected);
  }
}

TEST(UnicodeNormalization, ScratchAllocationFailureReleasesMainBuffer) {
  std::vector<uint32_t> input;
  for (size_t i = 0; i < 64; ++i) {
    input.push_back(0x0315);
    input.push_back(0x0300);
  }
  NormalizationAllocator allocator(2);
  uint32_t* output = nullptr;
  EXPECT_EQ(unicode_normalize(&output, input.data(), input.size(), UNICODE_NFD,
                              &allocator, nullptr,
                              NormalizationAllocator::Reallocate),
            -1);
  EXPECT_EQ(output, nullptr);
  EXPECT_EQ(allocator.live_allocations(), 0u);
}

TEST(UnicodeNormalization, DefaultAllocatorHandlesNullEmptyAndOwnedOutput) {
  uint32_t* output = nullptr;
  EXPECT_EQ(unicode_normalize(&output, nullptr, 0, UNICODE_NFC, nullptr,
                              nullptr, nullptr),
            0);
  EXPECT_EQ(output, nullptr);
  const uint32_t input[] = {'A', 0x030a};
  ASSERT_EQ(unicode_normalize(&output, input, 2, UNICODE_NFC, nullptr, nullptr,
                              nullptr),
            1);
  ASSERT_NE(output, nullptr);
  EXPECT_EQ(output[0], 0x00c5u);
  std::free(output);
}
