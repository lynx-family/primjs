#ifndef SRC_GC_MRT_BITMAP_H_
#define SRC_GC_MRT_BITMAP_H_

#include <cstdint>
#include <cstring>

#include "gc/alloc_config.h"
#include "gc/alloc_utils.h"
#include "gc/mark_stack.h"
#include "gc/sizes.h"

// set 1 to enable bitmap debug functions
#define MRT_DEBUG_BITMAP 0
namespace ROS_GC {
static constexpr size_t kLogObjAlignment = 4;
static constexpr size_t kLogBitsPerByte = 3;   // 8 bit per byte
static constexpr size_t kLogBytesPerWord = 2;  // 4 byte per word
static constexpr size_t kLogBitsPerWord = kLogBitsPerByte + kLogBytesPerWord;

static constexpr size_t kBitsPerWord =
    sizeof(uint32_t) * 8;  // 8 bits per byte.

class Bitmap {
 public:
  Bitmap(PageList &bb, PageList::Node *&n)
      : spaceStart(0),
        spaceEnd(0),
        curEnd(0),
        isInitialized(false),
        bitmapBegin(nullptr),
        bitmapSize(0),
        barrierBuffer(bb),
        node(n) {}
  ~Bitmap();
  // for initialization
  bool Initialized() const { return isInitialized; }

  void Initialize(size_t maxHeapBytes, size_t start_, size_t spaceCapacity,
                  bool isForHuge);
  __attribute__((always_inline)) void ResetBitmap() {
    if (bitmapBegin != nullptr) {
#ifdef __ANDROID__
      int result = madvise(bitmapBegin, bitmapSize, MADV_DONTNEED);
      if (result != 0) {
        // must terminate process, bitmap reset fail will cause unpredictable
        // behavior
        abort();
        size_t curBitmapSize =
            kBitMapSize;  // GetBitmapSizeByHeap(curEnd - spaceStart);
        memset(reinterpret_cast<void *>(bitmapBegin), 0, curBitmapSize);
      }
#else
      size_t curBitmapSize =
          bitmapSize;  // GetBitmapSizeByHeap(curEnd - spaceStart);
      (void)memset(reinterpret_cast<void *>(bitmapBegin), 0, curBitmapSize);
#endif
    }
  }

  // return true if object already marked, false if unmarked
  __attribute__((always_inline)) bool MarkObject(address_t addr) {
    uint32_t lineIndex;
    uint32_t bitMask;
    GetLocation(addr, lineIndex, bitMask,
                AllocUtilRndDown(addr, kRosDefaultPageGroupSize));
    std::atomic<uint32_t> *line = bitmapBegin + lineIndex;
    ROSIMPL_ASSERT(line < (bitmapBegin + bitmapSize), "invalide line addr");
    uint32_t old;
    uint32_t old_cas;
    do {
      old = line->load(std::memory_order_relaxed);
      if ((old & bitMask) != 0) {
        return true;
      }
      old_cas = old;
      auto new_val = old_cas | bitMask;
      std::atomic_compare_exchange_strong_explicit(line, &old, new_val,
                                                   std::memory_order_release,
                                                   std::memory_order_relaxed);
    } while (old != old_cas);
    return false;
  }

  __attribute__((always_inline)) void UnMarkObject(address_t addr) {
    uint32_t lineIndex;
    uint32_t bitMask;
    GetLocation(addr, lineIndex, bitMask,
                AllocUtilRndDown(addr, kRosDefaultPageGroupSize));
    std::atomic<uint32_t> *line = bitmapBegin + lineIndex;
    ROSIMPL_ASSERT(line < (bitmapBegin + bitmapSize), "invalide line addr");
    uint32_t old;
    uint32_t old_cas;
    do {
      old = line->load(std::memory_order_relaxed);
      if ((old & bitMask) == 0) {
        return;
      }
      old_cas = old;
      auto new_val = old_cas & ~bitMask;
      std::atomic_compare_exchange_strong_explicit(line, &old, new_val,
                                                   std::memory_order_release,
                                                   std::memory_order_relaxed);
    } while (old != old_cas);
  }

  __attribute__((always_inline)) bool IsObjectMarked(address_t addr) const {
    uint32_t lineIndex;
    uint32_t bitMask;
    GetLocation(addr, lineIndex, bitMask,
                AllocUtilRndDown(addr, kRosDefaultPageGroupSize));
    std::atomic<uint32_t> *line = bitmapBegin + lineIndex;
    uint32_t word = line->load(std::memory_order_acquire);
    return (word & bitMask) != 0;
  }

  __attribute__((always_inline)) bool IsObjectMarkedNoAtomic(
      address_t addr) const {
    uint32_t lineIndex;
    uint32_t bitMask;

    uint32_t offset = static_cast<uint32_t>(addr - spaceStart);

    // lower bitmap word in the bitmapWords array encodes lower address
    lineIndex = (offset >> kLogBitsPerWord) >> kLogObjAlignment;

    uint32_t *line = (uint32_t *)bitmapBegin + lineIndex;
    uint32_t word = *line;
    if (word == 0) {
      return false;
    }

    // higher bits in each word encodes lower address
    unsigned int bitIndex =
        kBitsPerWord - 1 - ((offset >> kLogObjAlignment) & (kBitsPerWord - 1));
    bitMask = static_cast<uint32_t>(1) << bitIndex;

    return (word & bitMask) != 0;
  }

  __attribute__((always_inline)) void PushBarrierRef(address_t value) {
    barrierBuffer.EnsureAvailNode(node);
    node->Push(value);
  }

 private:
  __attribute__((always_inline)) bool AddrInRange(address_t addr) const {
    return (addr >= spaceStart) && (addr <= spaceEnd);
  }

  __attribute__((always_inline)) void CheckAddr(address_t addr) const {
    if (!AddrInRange(addr)) {
      abort();
    }
  }

  // round value up to alignValue
  __attribute__((always_inline)) uint32_t AlignRight(
      uint32_t value, uint32_t alignValue) const noexcept {
    return (value + alignValue - 1) & ~(alignValue - 1);
  }

  __attribute__((always_inline)) size_t GetBitmapSizeByHeap(size_t heapBytes) {
    size_t nBytes;
    size_t nBits;

    if ((heapBytes & ((static_cast<uint32_t>(1) << kLogObjAlignment) - 1)) ==
        0) {
      nBits = heapBytes >> kLogObjAlignment;
    } else {
      nBits = (heapBytes >> kLogObjAlignment) + 1;
    }

    nBytes = AlignRight(static_cast<uint32_t>(nBits), kBitsPerWord) >>
             kLogBitsPerByte;
    return nBytes;
  }

  // get index in the bitmap array and bit mask in the word.
  __attribute__((always_inline)) void GetLocation(address_t addr,
                                                  uint32_t &lineIndex,
                                                  uint32_t &bitMask,
                                                  address_t header) const {
    ROSIMPL_ASSERT(AddrInRange(addr), "addr is out of range");
#if MRT_DEBUG_BITMAP
    CheckAddr(addr);
#endif
    uint32_t offset = static_cast<uint32_t>(addr - header);

    // lower bitmap word in the bitmapWords array encodes lower address
    lineIndex = (offset >> kLogBitsPerWord) >> kLogObjAlignment;

    // higher bits in each word encodes lower address
    unsigned int bitIndex =
        kBitsPerWord - 1 - ((offset >> kLogObjAlignment) & (kBitsPerWord - 1));
    bitMask = static_cast<uint32_t>(1) << bitIndex;
  }

  // the start and end of memory space covered by the bitmap.
  address_t spaceStart;
  address_t spaceEnd;
  address_t curEnd;
  bool isInitialized;
  std::atomic<uint32_t> *bitmapBegin;
  size_t bitmapSize;
  PageList &barrierBuffer;
  PageList::Node *&node;
};
}  // namespace ROS_GC

#endif  // SRC_GC_MRT_BITMAP_H_
