// Copyright 2012 the V8 project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef V8_UTILS_BIT_VECTOR_H_
#define V8_UTILS_BIT_VECTOR_H_

#include <algorithm>

#include "primjs/base/zone.h"

namespace base {

class BitVector : public ZoneObject {
 public:
  static constexpr int kDataBits = sizeof(void *) * 8;
  static constexpr int kDataBitShift = 3 + LogBytesPerWord;

  BitVector() = default;

  BitVector(int length, Zone *zone) : length_(length) {
    int data_length = (length + kDataBits - 1) >> kDataBitShift;
    if (data_length > 1) {
      data_.ptr_ = zone->alloc_array<uintptr_t>(data_length);
      std::fill_n(data_.ptr_, data_length, 0);
      data_begin_ = data_.ptr_;
      data_end_ = data_begin_ + data_length;
    }
  }

  BitVector(const BitVector &other, Zone *zone)
      : length_(other.length_), data_(other.data_.inline_) {
    if (!other.is_inline()) {
      int data_length = other.data_length();
      vmassert(1 < data_length, "must be");
      data_.ptr_ = zone->alloc_array<uintptr_t>(data_length);
      data_begin_ = data_.ptr_;
      data_end_ = data_begin_ + data_length;
      std::copy_n(other.data_begin_, data_length, data_begin_);
    }
  }

  // Disallow copy and copy-assignment.
  BitVector(const BitVector &) = delete;
  BitVector &operator=(const BitVector &) = delete;

  BitVector(BitVector &&other) { *this = std::move(other); }

  BitVector &operator=(BitVector &&other) {
    length_ = other.length_;
    data_ = other.data_;
    if (other.is_inline()) {
      data_begin_ = &data_.inline_;
      data_end_ = data_begin_ + other.data_length();
    } else {
      data_begin_ = other.data_begin_;
      data_end_ = other.data_end_;
      // Reset other to inline.
      other.length_ = 0;
      other.data_begin_ = &other.data_.inline_;
      other.data_end_ = other.data_begin_ + 1;
    }
    return *this;
  }

  void CopyFrom(const BitVector &other) {
    vmassert(other.length() == length(), "must be");
    vmassert(is_inline() == other.is_inline(), "must be");
    std::copy_n(other.data_begin_, data_length(), data_begin_);
  }

  void Resize(int new_length, Zone *zone) {
    vmassert(new_length > length(), "must be");
    int old_data_length = data_length();
    vmassert(1 <= old_data_length, "must be");
    int new_data_length = (new_length + kDataBits - 1) >> kDataBitShift;
    if (new_data_length > old_data_length) {
      uintptr_t *new_data = zone->alloc_array<uintptr_t>(new_data_length);

      // Copy over the data.
      std::copy_n(data_begin_, old_data_length, new_data);
      // Zero out the rest of the data.
      std::fill(new_data + old_data_length, new_data + new_data_length, 0);

      data_begin_ = new_data;
      data_end_ = new_data + new_data_length;
    }
    length_ = new_length;
  }

  bool Contains(int i) const {
    vmassert(i >= 0 && i < length(), "must be");
    return (data_begin_[word(i)] & bit(i)) != 0;
  }

  void Add(int i) {
    vmassert(i >= 0 && i < length(), "must be");
    data_begin_[word(i)] |= bit(i);
  }

  void AddAll() {
    // TODO(leszeks): This sets bits outside of the length of this bit-vector,
    // which is observable if we resize it or copy from it. If this is a
    // problem, we should clear the high bits either on add, or on resize/copy.
    memset(data_begin_, -1, sizeof(*data_begin_) * data_length());
  }

  void Remove(int i) {
    vmassert(i >= 0 && i < length(), "must be");
    data_begin_[word(i)] &= ~bit(i);
  }

  void Union(const BitVector &other) {
    vmassert(other.length() == length(), "mst be");
    for (int i = 0; i < data_length(); i++) {
      data_begin_[i] |= other.data_begin_[i];
    }
  }

  bool UnionIsChanged(const BitVector &other) {
    vmassert(other.length() == length(), "must be");
    bool changed = false;
    for (int i = 0; i < data_length(); i++) {
      uintptr_t old_data = data_begin_[i];
      data_begin_[i] |= other.data_begin_[i];
      if (data_begin_[i] != old_data) changed = true;
    }
    return changed;
  }

  void Intersect(const BitVector &other) {
    vmassert(other.length() == length(), "must be");
    for (int i = 0; i < data_length(); i++) {
      data_begin_[i] &= other.data_begin_[i];
    }
  }

  bool IntersectIsChanged(const BitVector &other) {
    vmassert(other.length() == length(), "must be");
    bool changed = false;
    for (int i = 0; i < data_length(); i++) {
      uintptr_t old_data = data_begin_[i];
      data_begin_[i] &= other.data_begin_[i];
      if (data_begin_[i] != old_data) changed = true;
    }
    return changed;
  }

  void Subtract(const BitVector &other) {
    vmassert(other.length() == length(), "must be");
    for (int i = 0; i < data_length(); i++) {
      data_begin_[i] &= ~other.data_begin_[i];
    }
  }

  void Clear() { std::fill_n(data_begin_, data_length(), 0); }

  bool Equals(const BitVector &other) const {
    return std::equal(data_begin_, data_end_, other.data_begin_);
  }

  int length() const { return length_; }

 private:
  union DataStorage {
    uintptr_t *ptr_;    // valid if >1 machine word is needed
    uintptr_t inline_;  // valid if <=1 machine word is needed

    explicit DataStorage(uintptr_t value) : inline_(value) {}
  };

  bool is_inline() const { return data_begin_ == &data_.inline_; }
  int data_length() const { return static_cast<int>(data_end_ - data_begin_); }

  inline static int word(int index) { return index >> kDataBitShift; }
  inline static uintptr_t bit(int index) {
    return uintptr_t{1} << (index & (kDataBits - 1));
  }

  int length_ = 0;
  DataStorage data_{0};
  uintptr_t *data_begin_ = &data_.inline_;
  uintptr_t *data_end_ = &data_.inline_ + 1;
};

}  // namespace base

#endif  // V8_UTILS_BIT_VECTOR_H_
