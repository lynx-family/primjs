/*
 * Copyright (c) [2020] Huawei Technologies Co.,Ltd.All rights reserved.
 *
 * OpenArkCompiler is licensed under Mulan PSL v2.
 * You can use this software according to the terms and conditions of the Mulan
 * PSL v2. You may obtain a copy of Mulan PSL v2 at:
 *
 *     http://license.coscl.org.cn/MulanPSL2
 *
 * THIS SOFTWARE IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OF ANY
 * KIND, EITHER EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
 * NON-INFRINGEMENT, MERCHANTABILITY OR FIT FOR A PARTICULAR PURPOSE. See the
 * Mulan PSL v2 for more details.
 */
#ifdef ENABLE_COMPATIBLE_MM
#include "gc/page_map.h"

#include <cstring>

#include "gc/alloc_config.h"

// Definitions of page map
namespace ROS_GC {
PageMap::PageMap()
    : spaceBeginAddr(0),
      spaceEndAddr(0),
      maxMapSize(0),
      pageMapSize(0),
      memMap(nullptr),
      map(nullptr) {}

PageMap::~PageMap() {
  spaceBeginAddr = 0;
  spaceEndAddr = 0;
  MemMap::DestroyMemMap(memMap);
  // memory will be released by memMap
  map = nullptr;
}

void PageMap::Init(address_t baseAddr, size_t maxSize, size_t size) {
  spaceBeginAddr = baseAddr;
  spaceEndAddr = baseAddr + size;
  maxMapSize = ALLOCUTIL_PAGE_BYTE2CNT(maxSize);
  pageMapSize = ALLOCUTIL_PAGE_BYTE2CNT(size);

  size_t reqSize = ALLOCUTIL_PAGE_RND_UP(maxMapSize);
  MemMap::Option opt = MemMap::kDefaultOptions;
  opt.tag = "rts_alloc_ros_pm";
  opt.reqBase = nullptr;
  opt.reqRange = false;
  memMap = MemMap::MapMemory(reqSize, reqSize, opt);
  map = static_cast<PageLabel *>(memMap->GetBaseAddr());
  if (UNLIKELY(map == nullptr)) {
    abort();
    // LOG(FATAL) << "page map initialisation failed";
  }
}

void PageMap::PrepareForConcurrentSweep() {
  if (map) {
    if (mapSnapShot) *(int *)(0xdead) = 0;
    void *rawPtr = malloc(memMap->GetMappedSize());
    memcpy(rawPtr, map, memMap->GetMappedSize());
    mapSnapShot = static_cast<PageLabel *>(rawPtr);
  }
}

void PageMap::ClearForConcurrentSweep() {
  if (mapSnapShot) {
    free(static_cast<void *>(mapSnapShot));
    mapSnapShot = nullptr;
  }
}

}  // namespace ROS_GC
#endif  // ENABLE_COMPATIBLE_MM
