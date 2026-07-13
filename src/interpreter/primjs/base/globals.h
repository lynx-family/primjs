// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_GLOBALS_H
#define PRIMJS_GLOBALS_H

#include <math.h>
#include <stdint.h>
#include <string.h>

#include <atomic>
#include <cstring>
#include <string_view>

#include "primjs/base/debug.h"
#include "primjs/base/globalDefinitions.h"
#include "primjs/base/macros.h"
#include "primjs/base/rtsTimmer.h"

namespace base {

constexpr size_t defaultStringTableSize = NOT_LP64(1024) LP64_ONLY(65536);
constexpr size_t minimumStringTableSize = 128;
constexpr size_t defaultSymbolTableSize = 32768;  // 2^15
constexpr size_t minimumSymbolTableSize = 1024;

constexpr intptr_t MaxRNILocalCapacity = 65536;

enum class WordSize : int {};

constexpr WordSize in_WordSize(int size) { return static_cast<WordSize>(size); }
constexpr int in_words(WordSize x) { return static_cast<int>(x); }

enum class ByteSize : int {};

constexpr ByteSize in_ByteSize(int size) { return static_cast<ByteSize>(size); }
constexpr int in_bytes(ByteSize x) { return static_cast<int>(x); }

constexpr ByteSize operator+(ByteSize x, ByteSize y) {
  return in_ByteSize(in_bytes(x) + in_bytes(y));
}
constexpr ByteSize operator-(ByteSize x, ByteSize y) {
  return in_ByteSize(in_bytes(x) - in_bytes(y));
}
constexpr ByteSize operator*(ByteSize x, int y) {
  return in_ByteSize(in_bytes(x) * y);
}

constexpr bool operator==(ByteSize x, int y) { return in_bytes(x) == y; }
constexpr bool operator!=(ByteSize x, int y) { return in_bytes(x) != y; }

// Use the following #define to get C++ field member offsets
#define offset_of(klass, field)                 \
  ([]() {                                       \
    alignas(16) char space[sizeof(klass)];      \
    klass *dummyObj = (klass *)space;           \
    char *c = (char *)(void *)&dummyObj->field; \
    return (size_t)(c - space);                 \
  }())

#define byte_offset_of(klass, field) in_ByteSize((int)offset_of(klass, field))

static constexpr size_t ALIGN_SIZE_WORD = 8U;

template <typename T>
inline constexpr T align_down(T x, size_t alignment) {
  return T(x & ~T(alignment - 1U));
}

template <typename T>
inline constexpr T align_up(T x, size_t alignment) {
  return align_down<T>(static_cast<T>(x + alignment - 1U), alignment);
}

template <typename T>
inline constexpr bool is_aligned(T x, size_t alignment) {
  return (x & T(alignment - 1U)) == 0;
}

inline constexpr size_t round_up_power_of_two(uint32_t value) {
  if (value != 0) {
    value--;
  }
  value |= value >> 1;
  value |= value >> 2;
  value |= value >> 4;
  value |= value >> 8;
  value |= value >> 16;
  return value + 1;
}

template <typename From, typename To>
inline To type_bit_cast(From const &value) {
  union CastData {
    From src;
    To dst;
  };
  CastData data;
  data.src = value;
  return data.dst;
}

inline int64_t bit_cast(double const &value) {
  return type_bit_cast<double, int64_t>(value);
}

template <typename T>
static T Acquire_Load(const volatile T *addr) {
  return ((volatile const std::atomic<T> *)addr)
      ->load(std::memory_order_acquire);
}

union Float64Union {
  double d;
  uint64_t u64;
};

#ifndef ATTRIBUTE_PRINTF
#define ATTRIBUTE_PRINTF(fmt, vargs) __attribute__((format(printf, fmt, vargs)))
#endif

template <typename T>
class Span {
 private:
  T *start_;
  size_t length_;

 public:
  using value_type = T;
  using iterator = T *;
  using const_iterator = const T *;

  constexpr Span() : start_(nullptr), length_(0) {}

  constexpr Span(T *data, size_t length) : start_(data), length_(length) {
    vmassert(length == 0 || data != nullptr, "must be not null");
  }

  int length() const {
    vmassert(length_ <= INT_MAX, "length overflow");
    return static_cast<int>(length_);
  }
  bool empty() const { return length_ == 0; }
  T *data() const { return start_; }

  T &operator[](size_t index) const {
    vmassert(index < length_, "index overflow");
    return start_[index];
  }
};

}  // namespace base
#endif  // PRIMJS_VM_GLOBALS_H
