/*
 * Copyright (c) 2024 The Lynx Authors. All rights reserved.
 */
#ifndef PRIMJS_ZONE_H
#define PRIMJS_ZONE_H

#include <stdlib.h>

#include <algorithm>

#include "primjs/base/globals.h"

namespace base {

struct ZonePage {
  size_t size;
  size_t use_size;
  ZonePage *next;
};

class Zone {
 private:
  ZonePage *_pages;
  uint8_t *_current;
  uint8_t *_end;
  size_t _page_size;

  void new_page(size_t size);
  void *mmap_page(size_t size);

 public:
  static constexpr size_t ZONE_DEFAULT_SIZE = 4096;

  Zone(size_t page_size)
      : _pages(nullptr),
        _current(nullptr),
        _end(nullptr),
        _page_size(page_size) {}

  Zone() : Zone(ZONE_DEFAULT_SIZE) {}
  ~Zone();

  void *alloc(size_t size) {
    vmassert(size != 0, "zone alloc size is null");
    size = align_up<size_t>(size, ALIGN_SIZE_WORD);
    if (_current == nullptr || (_current + size) >= _end) {
      size_t new_size = (size > _page_size) ? size : _page_size;
      new_page(new_size);
    }
    uint8_t *res = _current;
    _current += size;
    return res;
  }

  template <typename T>
  T *alloc_array(size_t len) {
    auto size = len * sizeof(T);
    return reinterpret_cast<T *>(alloc(size));
  }

  template <typename T>
  T *realloc_array(uint8_t *p, size_t len, size_t new_len) {
    auto size = len * sizeof(T);
    if (UNLIKELY(_current == nullptr)) {
      return alloc_array<T>(new_len);
    }
    uint8_t *old_address = _current - size;
    if (p == old_address) {
      if ((_current + size) >= _end) {
        return alloc_array<T>(new_len);
      }
      alloc_array<T>(new_len - len);
      return reinterpret_cast<T *>(p);
    }
    return alloc_array<T>(new_len);
  }

  void *alloc_with_zero_size(size_t size) {
    if (size == 0) {
      return nullptr;
    }
    return alloc(size);
  }

  void *allocz_with_zero_size(size_t size) {
    if (size == 0) {
      return nullptr;
    }
    return allocz(size);
  }

  void *allocz(size_t size);
  size_t size();
  bool contains(void *addr);
  void set_current_page_use_size() {
    if (_pages == nullptr) {
      return;
    }
    _pages->use_size = reinterpret_cast<uintptr_t>(_current) -
                       reinterpret_cast<uintptr_t>(_pages);
  }
};

template <typename T>
class ZoneAllocator {
 private:
  Zone *_zone;

 public:
  using value_type = T;

  explicit ZoneAllocator(Zone *zone) : _zone(zone) {}

  template <typename K>
  ZoneAllocator(const ZoneAllocator<K> &o) : ZoneAllocator<T>(o.zone()) {}

  Zone *zone() const { return _zone; }

  T *allocate(size_t length) {
    auto alloc_size = sizeof(T) * length;
    return reinterpret_cast<T *>(_zone->alloc(alloc_size));
  }

  void deallocate(T *p, size_t length) {
    // nothing for free zone
  }

  bool operator==(ZoneAllocator const &o) const { return _zone == o._zone; }

  bool operator!=(ZoneAllocator const &o) const { return _zone != o._zone; }
};

class StackSpace : public AllStatic {
 public:
  static uint8_t *Alloc(size_t size) {
    void *res = malloc(size);
#if ASSERT
    memset(res, 0xF3, size);
#endif  // ASSERT
    return (uint8_t *)res;
  }

  static void Free(uint8_t *addr) { free(addr); }
};

class ZoneObject {
 public:
  void *operator new(size_t size, Zone *zone);
  ALWAYSINLINE void operator delete(void *p) { unreachable(); }
};
}  // namespace base
#endif  // PRIMJS_ZONE_H
