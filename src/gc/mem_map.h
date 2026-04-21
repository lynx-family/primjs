#ifndef SRC_GC_ALLOC_MEM_MAP_H_
#define SRC_GC_ALLOC_MEM_MAP_H_

#ifndef _WIN32
#include <sys/mman.h>
#endif

#include "gc/alloc_utils.h"

namespace ROS_GC {
class MemMap {
 public:
  static const bool kEnableRange = true;
  static const bool kEnableRandomMemStart = true;
#ifndef _WIN32
  static const int kDefaultMemFlags = MAP_PRIVATE | MAP_ANONYMOUS;
  static const int kDefaultMemProt = PROT_READ | PROT_WRITE;
#else
  static const int kDefaultMemFlags = 0;
  static const int kDefaultMemProt = 0;
#endif

  struct Option {     // optional args for mem map
    const char *tag;  // name to identify the mapped memory
    void *reqBase;    // a hint to mmap about start addr, not guaranteed
    int flags;        // mmap flags
    int prot;         // initial access flags
    bool protAll;     // applying prot to all pages in range
    bool reqRange;    // request mapping within the following range (guaranteed)
    address_t
        lowestAddr;  // lowest start addr (only used when reqRange == true)
    address_t
        highestAddr;  // highest end addr (only used when reqRange == true)
    bool isRandom;    // randomise start addr (only used when reqRange == true)
  };
  // ---------------------------------------------------
  // NOTE: Don't forget update 'duplicateFunc.s'
  // if you changed HEAP_START or HEAP_END.
  // ---------------------------------------------------

// The first 64KB is protected by SELinux.
#define HEAP_START (1u << 16)
#define HEAP_END (1ul << 31)    // max of 2GB space
#define PERM_BEGIN (9ul << 28)  // perm start from 2.25G
#define PERM_END (3ul << 30)    // perm end at 3G

  // by default, it tries to map memory in low addr space, with a random start
  static constexpr Option kDefaultOptions = {
      "rts_unnamed",   nullptr,  kDefaultMemFlags,
      kDefaultMemProt, false,    true,
      HEAP_START,      HEAP_END, true};

  // the only way to get a MemMap
  static MemMap *MapMemory(size_t reqSize, size_t initSize,
                           const Option &opt = kDefaultOptions);
  static MemMap *CreateAlignedMemory(size_t reqSize, size_t max_capacity,
                                     const Option &opt = kDefaultOptions);

  // destroy a MemMap
  static void DestroyMemMap(MemMap *&memMap) noexcept {
    if (memMap != nullptr) {
      delete memMap;
      memMap = nullptr;
    }
  }

  void *GetBaseAddr() const { return memBaseAddr; }
  void *GetCurrEnd() const { return memCurrEndAddr; }
  void *GetMappedEndAddr() const { return memMappedEndAddr; }
  size_t GetCurrSize() const { return memCurrSize; }
  size_t GetMappedSize() const { return memMappedSize; }

  inline bool IsAddrInCurrentRange(address_t addr) const {
    return reinterpret_cast<size_t>(
               addr - reinterpret_cast<address_t>(memBaseAddr)) < memCurrSize;
  }

  // change the access flags of the memory in given range
  bool ProtectMem(address_t addr, size_t size, int prot) const;
  bool ProtectAllMem() const;
  bool UnProtectAllMem() const;

  // grow the size of the usable memory
  bool Extend(size_t reqSize);

  // madvise released memory in the range [releaseBeginAddr, releaseBeginAddr +
  // size)
  bool ReleaseMem(address_t releaseBeginAddr, size_t size) const;

  // resize the memory map by releasing the pages at the end (munmap)
  bool Shrink(size_t newSize);

  ~MemMap();
  MemMap(const MemMap &that) = delete;
  MemMap(MemMap &&that) = delete;
  MemMap &operator=(const MemMap &that) = delete;
  MemMap &operator=(MemMap &&that) = delete;

 private:
  // Map in the specified range.
  // The return addr is guaranteed to be in [lowestAddr, highestAddr - reqSize)
  // if successful.
  static void *MemMapInRange(address_t lowestAddr, address_t highestAddr,
                             size_t reqSize, int prot, int flags, int fd = -1,
                             int offset = 0);
  static void *MemMapInRangeInternal(address_t hint, address_t lowestAddr,
                                     address_t highestAddr, size_t reqSize,
                                     int prot, int flags, int fd, int offset);
  static bool ProtectMemInternal(void *addr, size_t size, int prot);

  void *memBaseAddr;       // start of the mapped memory
  void *memCurrEndAddr;    // end of the memory **in use**
  void *memMappedEndAddr;  // end of the mapped memory, always >= currEndAddr
  size_t memCurrSize;      // size of the memory **in use**
  size_t memMappedSize;    // size of the mapped memory, always >= currSize
  bool protOnce;
  const int memProt;  // memory accessibility flags

  // MemMap is created via factory method
  MemMap(void *baseAddr, size_t initSize, size_t mappedSize, bool protAll,
         int prot);

  void UpdateCurrEndAddr();
};  // class MemMap
}  // namespace ROS_GC
#endif  // SRC_GC_ALLOC_MEM_MAP_H_
