// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef PRIMJS_BUFFER_CONTAINERS_H
#define PRIMJS_BUFFER_CONTAINERS_H

#include <stdlib.h>

#include <algorithm>
#include <map>
#include <unordered_map>
#include <vector>

#include "primjs/base/globals.h"
#include "primjs/base/threadBuffer_inl.h"
#include "rtsvm/vm/runtime/allocation.h"

namespace base {

template <typename K, typename V, typename Hash = std::hash<K>,
          typename KeyEqual = std::equal_to<K>>
class BufferUnorderedMap
    : public std::unordered_map<K, V, Hash, KeyEqual,
                                BufferAllocator<std::pair<const K, V>>> {
 public:
  explicit BufferUnorderedMap(TRAPS, size_t bucket_count = 0)
      : std::unordered_map<K, V, Hash, KeyEqual,
                           BufferAllocator<std::pair<const K, V>>>(
            bucket_count, Hash(), KeyEqual(),
            BufferAllocator<std::pair<const K, V>>(THREAD)) {}

  NONCOPYABLE(BufferUnorderedMap);
};

template <typename T>
class BufferVector {
 public:
  using iterator = T *;
  using const_iterator = const T *;
  using value_type = T;
  using reference = T &;
  using const_reference = const T &;
  using size_type = size_t;

  static constexpr size_t kInitSize = 16;

  explicit BufferVector(int n, TRAPS) : _thread(THREAD) {
    n = (n == 0) ? kInitSize : n;
    _data = _thread->alloc_buffer_array<T>(n);
    _end = _data;
    _capacity = _data + n;
  }

  size_t capacity() const { return _capacity - _data; }
  size_t size() const { return _end - _data; }
  bool empty() const { return _end == _data; }

  T &back() {
    vmassert(_end > _data, "empty");
    return *(_end - 1);
  }

  void pop_back() {
    vmassert(_end > _data, "empty");
    (--_end)->~T();
  }

  void push_back(T &&value) { emplace_back(std::move(value)); }

  ALWAYSINLINE void EnsureCapacity() {
    if (LIKELY(_end < _capacity)) return;
    Grow(capacity() + 1);
  }
  template <typename... Args>
  T &emplace_back(Args &&...args) {
    EnsureCapacity();
    T *ptr = _end++;
    new (ptr) T(std::forward<Args>(args)...);
    return *ptr;
  }

  template <typename... Args>
  void emplace(T *target, Args &&...args) {
    new (target) T(std::forward<Args>(args)...);
  }

  T &operator[](size_t index) const {
    vmassert(index < (_end - _data), "index overflow");
    return _data[index];
  }

  NOINLINE void Grow(size_t minimum) {
    T *old_data = _data;
    T *old_end = _end;
    size_t old_size = size();
    size_t new_capacity = std::max(capacity() * 2, minimum);
    _data = _thread->alloc_buffer_array<T>(new_capacity);
    _end = _data + old_size;
    if (old_data) {
      MoveToNewStorage(_data, old_data, old_end);
    }
    _capacity = _data + new_capacity;
  }

  inline void MoveToNewStorage(T *dst, T *src, const T *src_end) {
    for (; src < src_end; dst++, src++) {
      if constexpr (std::is_move_constructible_v<T>) {
        emplace(dst, std::move(*src));
      } else {
        emplace(dst, *src);
      }
    }
  }

  NONCOPYABLE(BufferVector);

 private:
  RTSThread *_thread;
  T *_data{nullptr};
  T *_end{nullptr};
  T *_capacity{nullptr};
};

}  // namespace base
#endif  // PRIMJS_BUFFER_CONTAINERS_H
