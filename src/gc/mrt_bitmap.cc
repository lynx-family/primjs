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
#include "gc/mrt_bitmap.h"

namespace ROS_GC {

void Bitmap::Initialize(size_t maxHeapBytes, size_t start_,
                        size_t spaceCapacity, bool isForHuge) {
  if (isInitialized) abort();

  spaceStart = start_;
  spaceEnd = spaceStart + maxHeapBytes;
  curEnd = spaceStart + spaceCapacity;

  // todo, this may result in some memory wastage
  if (isForHuge)
    bitmapSize = kPageSize;
  else
    bitmapSize = kBitMapSize;  // GetBitmapSizeByHeap(maxHeapBytes);

  // use kPageSize to store Bitmap self for performance. actually, just need
  // sizeof(BitMap).
  bitmapBegin = reinterpret_cast<std::atomic<uint32_t> *>(curEnd + kPageSize);
  isInitialized = true;
}

Bitmap::~Bitmap() { bitmapBegin = nullptr; }

#if MRT_DEBUG_BITMAP
void Bitmap::CopyBitmap(const Bitmap &bitmap) {
  if (bitmapBegin != nullptr) {
    if (munmap(bitmapBegin, AlignRight(bitmapSize, kPageSize)) != 0) {
    }
    bitmapBegin = nullptr;
  }
  isInitialized = bitmap.Initialized();
  bitmapSize = bitmap.Size();
  if (isInitialized) {
    void *result = nullptr;
#ifndef _WIN32
    result = mmap(nullptr, AlignRight(bitmapSize, kPageSize),
                  PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
#endif
    if (result == MAP_FAILED) {
    }
    bitmapBegin = reinterpret_cast<atomic<uint32_t> *>(result);
    if (memcpy_s(bitmapBegin, bitmapSize, bitmap.bitmapBegin, bitmapSize) !=
        EOK) {
    }
  }
}
#endif
}  // namespace ROS_GC
#endif  // ENABLE_COMPATIBLE_MM
