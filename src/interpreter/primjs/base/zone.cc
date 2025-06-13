// Copyright 2025 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "primjs/base/zone.h"

#include <sys/mman.h>
#include <unistd.h>

#include <string>

namespace base {

Zone::~Zone() {
  ZonePage *page = _pages;
  while (page != nullptr) {
    ZonePage *next = page->next;
#ifndef ASSERT
    munmap(page, page->size);
#else
    free(page);
#endif  // ASSERT
    page = next;
  }
  _pages = nullptr;
  _current = nullptr;
  _end = nullptr;
}

bool Zone::contains(void *addr) {
  uintptr_t p_addr = (uintptr_t)addr;
  ZonePage *page = _pages;
  set_current_page_use_size();
  while (page != nullptr) {
    auto start = reinterpret_cast<uintptr_t>(page) + sizeof(ZonePage);
    auto end = reinterpret_cast<uintptr_t>(page) + page->use_size;
    if ((p_addr >= start) && (p_addr < end)) {
      return true;
    }
    page = page->next;
  }
  return false;
}

void *Zone::mmap_page(size_t size) {
#ifndef ASSERT
  void *ret = mmap(nullptr, size, PROT_READ | PROT_WRITE,
                   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  vmassert(ret != nullptr, "mmap failed");
#else
  void *ret = malloc(size);
  vmassert(ret != nullptr, "malloc failed");
#endif
  vmassert(reinterpret_cast<uintptr_t>(ret) % 8 == 0,
           "Address not 8-byte aligned");
  return ret;
}

void Zone::new_page(size_t size) {
  size_t real_size = size + sizeof(ZonePage);
  size_t page_size = getpagesize();
  size_t mmap_size = align_up<size_t>(real_size, page_size);

  ZonePage *page = reinterpret_cast<ZonePage *>(mmap_page(mmap_size));
  vmassert(page != nullptr, "page is nullptr");
#ifdef ASSERT
  memset((void *)page, 0xF3, mmap_size);
#endif
  page->next = _pages;
  page->use_size = 0;
  page->size = mmap_size;
  set_current_page_use_size();
  _pages = page;
  _current = reinterpret_cast<uint8_t *>(page + 1);
  _end = reinterpret_cast<uint8_t *>(page) + mmap_size;
}

size_t Zone::size() {
  size_t size = 0;
  ZonePage *page = _pages;
  while (page != nullptr) {
    size += page->size;
    page = page->next;
  }
  return size;
}

void *Zone::allocz(size_t size) {
  uint8_t *res = static_cast<uint8_t *>(alloc(size));
  if (res != nullptr) {
    memset(res, 0, size);
  }
  return res;
}
}  // namespace base
