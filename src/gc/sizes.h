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
#ifndef SRC_GC_SIZES_H_
#define SRC_GC_SIZES_H_

#include <atomic>
#include <cstddef>
#include <cstdint>
#include <cstdlib>
#include <vector>

using offset_t = intptr_t;
using address_t = uintptr_t;
namespace ROS_GC {
// Paranoid assertions. Please find clues in language specifications or ABIs
// that these predicates must hold.
#ifndef _WIN32
#if defined(__aarch64__)
static_assert(
    sizeof(uint64_t) == sizeof(size_t),
    "size_t does not have the same size as uint64_t. We are probably not "
    "working on a 64-bit platform.");

static_assert(
    sizeof(int64_t) == sizeof(ssize_t),
    "ssize_t does not have the same size as int64_t. We are probably not "
    "working on a 64-bit platform.");
#elif defined(__arm__)
static_assert(
    sizeof(uint32_t) == sizeof(size_t),
    "size_t does not have the same size as uint32_t. We are probably not "
    "working on a 32-bit platform.");

static_assert(
    sizeof(int32_t) == sizeof(ssize_t),
    "ssize_t does not have the same size as int32_t. We are probably not "
    "working on a 64-bit platform.");
#endif

static_assert(sizeof(uintptr_t) == sizeof(size_t),
              "size_t does not have the same size as uintptr_t.");

static_assert(sizeof(intptr_t) == sizeof(ssize_t),
              "ssize_t does not have the same size as intptr_t.");
#endif  // _WIN32

// AArch64-specific sizes.
const size_t kHWordBytes = 2;
const size_t kWordBytes = 4;
const size_t kDWordBytes = 8;
const size_t kQWordBytes = 16;

// Every GC heap object uses the same layout:
//
//   [8-byte metadata][payload]
//
// Memory tracking stores an 8-bit slot index in metadata instead of adding a
// pointer-sized word to every allocation.
const size_t kHeaderSize = kDWordBytes;

// The offset of the reference count field.
const offset_t kOffsetRefCount = -kWordBytes;
// The offset of the GC header.
const offset_t kOffsetGCHeader = -kDWordBytes;

// Metadata bit layout:
//
//   63       allocated by the allocator
//   62..32   payload size
//   31..14   unused
//   13..6    memory accounting slot index
//   5..0     allocation tag
//
// kColorBit is a legacy alias in the low word and is not an additional field in
// this encoding.
static constexpr uint64_t kAllocatedBit = 0x80000000;
static constexpr uint64_t kAllocatedBit64 = 0x8000000000000000;
static constexpr uint32_t kPayloadSizeBits = 31;
static constexpr uint32_t kPayloadSizeMask =
    (static_cast<uint32_t>(1) << kPayloadSizeBits) - 1;
static constexpr uint32_t kMemorySlotBits = 8;
static constexpr uint32_t kMemorySlotShift = 6;
static constexpr uint32_t kMemorySlotMask =
    ((static_cast<uint32_t>(1) << kMemorySlotBits) - 1) << kMemorySlotShift;
static_assert(kMemorySlotShift >= 6,
              "memory slot must not overlap the allocation tag");
static_assert(kMemorySlotShift + kMemorySlotBits <= 32,
              "memory slot must fit in the GC header low word");
// Actually, this bit is redundant, however the write-barrier can optimize
// performance by using it
static constexpr uint64_t kColorBit = 0x2;
static constexpr uint64_t kMaskBit = ~(kAllocatedBit | kColorBit);

static inline uint32_t &GCHeaderLVal(address_t objAddr) {
  return *((uint32_t *)(objAddr));
}

static inline uint32_t GCHeader(address_t objAddr) {
  return *((uint32_t *)(objAddr));
}

static inline void InitWithAllocatedBit(address_t objAddr) {
  std::atomic<uint32_t> *atomic_ptr =
      reinterpret_cast<std::atomic<uint32_t> *>(objAddr + 4);
  std::atomic_fetch_or_explicit(atomic_ptr,
                                static_cast<uint32_t>(kAllocatedBit),
                                std::memory_order_acq_rel);
}

static inline void ClearAllocatedBit(address_t objAddr) {
  std::atomic<uint32_t> *atomic_ptr =
      reinterpret_cast<std::atomic<uint32_t> *>(objAddr + 4);
  std::atomic_fetch_and_explicit(atomic_ptr,
                                 static_cast<uint32_t>(~kAllocatedBit),
                                 std::memory_order_acq_rel);
}

static inline bool IsAllocatedByAllocator(address_t objAddr) {
  std::atomic<uint32_t> *atomic_ptr =
      reinterpret_cast<std::atomic<uint32_t> *>(objAddr + 4);
  return (std::atomic_load_explicit(atomic_ptr, std::memory_order_acquire) &
          kAllocatedBit) != 0;
}

static inline bool IsColored(address_t objAddr) {
  return (GCHeader(objAddr) & kColorBit) != 0;
}

static inline void SetColor(address_t objAddr) {
  GCHeaderLVal(objAddr) |= kColorBit;
}

static inline void ClearColorBit(address_t objAddr) {
  GCHeaderLVal(objAddr) &= ~kColorBit;
}

static inline bool HasChildRef(address_t objAddr) {
  return true;
  // return (GCHeader(objAddr) & kHasChildRef) != 0;
}

// Object reference field iteration utilities, used in
// Recursive RC update when release
// Backup tracing mark/sweep
static const uint64_t kNotRefBits = 0;
static const uint64_t kNormalRefBits = 1;
static const uint64_t kWeakRefBits = 2;
static const uint64_t kUnownedRefBits = 3;
static const uint64_t kRefBitsMask = 3;
static const uint32_t kBitsPerRefWord = 2;

constexpr uint32_t kBitsPerByte = 8;
static const uint32_t kRefWordPerMapWord =
    ((sizeof(uint64_t) * kBitsPerByte) / kBitsPerRefWord);

}  // namespace ROS_GC

struct LEPUSRuntime;
class OriGCWorkStack {
 public:
  typedef std::vector<address_t>::iterator iterator;
  typedef address_t value_type;
  OriGCWorkStack(LEPUSRuntime *rt) : rt_(rt) {}
  OriGCWorkStack() : rt_(nullptr) { (void)rt_; }
  virtual ~OriGCWorkStack(){};
  virtual void push_back(address_t ele) {
    if (ele == 0) return;
#if ROS_DEBUG
    if ((ele % 8) != 0) {
      *(int *)(0xdead2) = 0;
    }
    if (*(int64_t *)(ele) == (int64_t)0xcccccccccccccccc) {
      void *parent = nullptr;
      if (!ROS_GC::IsAllocatedByAllocator(ele - ROS_GC::kHeaderSize)) {
        *(void **)(0xdead3) = 0;
      }
    }
#endif
    workStack.push_back(ele);
  }
  std::vector<address_t>::iterator begin() { return workStack.begin(); }

  size_t size() { return workStack.size(); }
  void resize(size_t n) { workStack.resize(n); }

  bool empty() { return workStack.empty(); }
  address_t back() { return workStack.back(); }
  address_t operator[](size_t i) { return workStack[i]; }
  void pop_back() { workStack.pop_back(); }
  void reserve(size_t n) { workStack.reserve(n); }
  void insert(iterator dst_begin, iterator src_begin, iterator src_end) {
    workStack.insert(dst_begin, src_begin, src_end);
  }
  address_t front() { return workStack.front(); }
  iterator end() { return workStack.end(); }
  void clear() { workStack.clear(); }
  void set_workerid(size_t id) { workerID_ = id; }
  size_t get_workerid() { return workerID_; }

 protected:
  LEPUSRuntime *rt_;
  std::vector<address_t> workStack;
  size_t workerID_;
};
#endif
