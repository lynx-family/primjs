// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_GC_POINTER_SET_H_
#define SRC_GC_POINTER_SET_H_

#include <cstddef>
#include <cstdint>
#include <memory>
#include <utility>

namespace ROS_GC {

// An open-addressing set of non-null pointers. Unlike std::unordered_set it
// does not allocate per element, which matters on hot paths that register
// every object needing finalization.
//
// Not thread-safe. Callbacks passed to ForEach() must not modify the set.
// Callbacks passed to RetainIf() and Drain() may insert into it, because the
// finalizers they run can register new objects.
class PointerSet {
 public:
  PointerSet() = default;
  PointerSet(const PointerSet &) = delete;
  PointerSet &operator=(const PointerSet &) = delete;

  // Returns false if `ptr` was already present.
  bool Insert(void *ptr) {
    if (2 * (size_ + 1) > capacity_) {
      Rehash(capacity_ == 0 ? kInitialCapacity : 2 * capacity_);
    }
    void **slot = FindSlot(slots_.get(), capacity_, ptr);
    if (*slot == ptr) return false;
    *slot = ptr;
    ++size_;
    return true;
  }

  template <typename Fn>
  void ForEach(Fn fn) const {
    for (size_t i = 0; i < capacity_; ++i) {
      if (slots_[i] != nullptr) fn(slots_[i]);
    }
  }

  // Keeps only the pointers for which `keep` returns true. Pointers that
  // `keep` inserts are kept without being passed to it.
  template <typename Predicate>
  void RetainIf(Predicate keep) {
    std::unique_ptr<void *[]> old_slots = std::move(slots_);
    const size_t old_capacity = capacity_;
    slots_.reset(new void *[old_capacity]());
    size_ = 0;
    for (size_t i = 0; i < old_capacity; ++i) {
      void *ptr = old_slots[i];
      if (ptr != nullptr && keep(ptr)) Insert(ptr);
    }
  }

  // Passes every pointer to `fn` and leaves the set empty. Pointers that `fn`
  // inserts are dropped without being passed to it.
  template <typename Fn>
  void Drain(Fn fn) {
    std::unique_ptr<void *[]> old_slots = std::move(slots_);
    const size_t old_capacity = capacity_;
    Clear();
    for (size_t i = 0; i < old_capacity; ++i) {
      if (old_slots[i] != nullptr) fn(old_slots[i]);
    }
    Clear();
  }

  void Clear() {
    slots_.reset();
    capacity_ = 0;
    size_ = 0;
  }

  size_t Size() const { return size_; }

  size_t MemoryUsage() const {
    return sizeof(*this) + capacity_ * sizeof(void *);
  }

 private:
  static constexpr size_t kInitialCapacity = 64;

  // `capacity` is a power of two and the load factor stays at or below 1/2,
  // so probing always reaches either `ptr` or an empty slot.
  static void **FindSlot(void **slots, size_t capacity, void *ptr) {
    const size_t mask = capacity - 1;
    for (size_t i = Hash(ptr) & mask;; i = (i + 1) & mask) {
      if (slots[i] == nullptr || slots[i] == ptr) return &slots[i];
    }
  }

  static size_t Hash(void *ptr) {
    // Fibonacci hashing spreads aligned addresses over the low bits.
    uint64_t h = static_cast<uint64_t>(reinterpret_cast<uintptr_t>(ptr)) *
                 0x9E3779B97F4A7C15ull;
    return static_cast<size_t>(h ^ (h >> 32));
  }

  void Rehash(size_t new_capacity) {
    std::unique_ptr<void *[]> new_slots(new void *[new_capacity]());
    for (size_t i = 0; i < capacity_; ++i) {
      void *ptr = slots_[i];
      if (ptr != nullptr) *FindSlot(new_slots.get(), new_capacity, ptr) = ptr;
    }
    slots_ = std::move(new_slots);
    capacity_ = new_capacity;
  }

  std::unique_ptr<void *[]> slots_;
  size_t capacity_ = 0;
  size_t size_ = 0;
};

}  // namespace ROS_GC

#endif  // SRC_GC_POINTER_SET_H_
