#ifdef ENABLE_COMPATIBLE_MM
#include "gc/mem_map.h"

#include <unistd.h>

#include <algorithm>
#ifndef _WIN32
#include <sys/mman.h>
#endif
#include "gc/alloc_config.h"
#include "gc/sizes.h"

#if defined(ANDROID) || defined(__ANDROID__)
#include <sys/prctl.h>
#define PR_SET_VMA 0x53564d41
#define PR_SET_VMA_ANON_NAME 0
#endif

namespace ROS_GC {
using namespace std;

// not thread safe, do not call from multiple threads
MemMap *MemMap::MapMemory(size_t reqSize, size_t initSize, const Option &opt) {
  void *mappedAddr = nullptr;
  reqSize = AllocUtilRndUp<size_t>(reqSize, sysconf(_SC_PAGE_SIZE));
#ifndef _WIN32
  mappedAddr = mmap(opt.reqBase, reqSize, opt.prot, opt.flags, -1, 0);
#endif
  // bool failure = false;
  if (mappedAddr == MAP_FAILED) {
    return nullptr;
  }
#if defined(ANDROID) || defined(__ANDROID__)
  prctl(PR_SET_VMA, PR_SET_VMA_ANON_NAME, mappedAddr, reqSize, opt.tag);
#endif

  return new MemMap(mappedAddr, initSize, reqSize, opt.protAll, opt.prot);
}

MemMap *MemMap::CreateAlignedMemory(size_t req_size, size_t max_capacity,
                                    const Option &opt) {
  void *mapped_addr = nullptr;
  req_size = AllocUtilRndUp(req_size, sysconf(_SC_PAGE_SIZE));
  // It's expected behavior that this static variable may cause multi-runtimes
  // memory focused on a certain range.
  // The advantages:
  //    1. better memory locality helps improving performance
  //    2. contiguous memory helps analyze issues
  //    3. avoid memory fragmentation
  static void *lastMmapEnd = 0;
  void *hint = opt.reqBase == nullptr ? lastMmapEnd : opt.reqBase;
#ifndef _WIN32
  mapped_addr = mmap(hint, req_size + kRosDefaultPageGroupSize, opt.prot,
                     opt.flags, -1, 0);
#endif

  if (mapped_addr != MAP_FAILED) {
    auto aligned_addr = AllocUtilRndUp(reinterpret_cast<address_t>(mapped_addr),
                                       kRosDefaultPageGroupSize);
    auto aligned_size = aligned_addr - reinterpret_cast<address_t>(mapped_addr);
    if (aligned_size) {
      ALLOCUTIL_MEM_UNMAP(mapped_addr, aligned_size);
    }
    ALLOCUTIL_MEM_UNMAP(aligned_addr + req_size,
                        kRosDefaultPageGroupSize - aligned_size);

    lastMmapEnd = (void *)(aligned_addr + req_size);
#if defined(ANDROID) || defined(__ANDROID__)
    prctl(PR_SET_VMA, PR_SET_VMA_ANON_NAME, aligned_addr, req_size, opt.tag);
#endif
    return new MemMap(reinterpret_cast<void *>(aligned_addr), max_capacity,
                      req_size, opt.protAll, opt.prot);
  }
  return nullptr;
}

MemMap::MemMap(void *baseAddr, size_t initSize, size_t mappedSize, bool protAll,
               int prot)
    : memBaseAddr(baseAddr),
      memCurrSize(initSize),
      memMappedSize(mappedSize),
      protOnce(protAll),
      memProt(prot) {
  memCurrEndAddr = reinterpret_cast<void *>(
      reinterpret_cast<address_t>(memBaseAddr) + memCurrSize);
  memMappedEndAddr = reinterpret_cast<void *>(
      reinterpret_cast<address_t>(memBaseAddr) + memMappedSize);
}

bool MemMap::ProtectMemInternal(void *addr, size_t size, int prot) {
  int ret = mprotect(addr, size, prot);
  ROSIMPL_ASSERT(!ret, "mprotect failed");
  return (ret == 0);
}
bool MemMap::ProtectAllMem() const {
  return ProtectMemInternal(reinterpret_cast<void *>(memBaseAddr),
                            memMappedSize, PROT_READ);
}

bool MemMap::UnProtectAllMem() const {
  return ProtectMemInternal(reinterpret_cast<void *>(memBaseAddr),
                            memMappedSize, PROT_READ | PROT_WRITE);
}
bool MemMap::ProtectMem(address_t addr, size_t size, int prot) const {
  if (addr >= reinterpret_cast<address_t>(memBaseAddr) &&
      addr + size <= reinterpret_cast<address_t>(memCurrEndAddr)) {
    return ProtectMemInternal(reinterpret_cast<void *>(addr), size, prot);
  }
  return false;
}

void MemMap::UpdateCurrEndAddr() {
  address_t startAddr = (reinterpret_cast<address_t>(memBaseAddr));
  memCurrEndAddr = reinterpret_cast<void *>(startAddr + memCurrSize);
}

bool MemMap::Extend(size_t reqSize) {
  if (memCurrSize >= memMappedSize) {
    abort();
    return false;
  }
  size_t newCurrSize = memCurrSize + reqSize;
  if (newCurrSize > memMappedSize) {
    abort();
    return false;
  }
  if (!protOnce && !ProtectMemInternal(memCurrEndAddr, reqSize, memProt)) {
    abort();
    return false;
  }
  memCurrSize = newCurrSize;
  UpdateCurrEndAddr();
  return true;
}

bool MemMap::ReleaseMem(address_t releaseBeginAddr, size_t size) const {
  abort();
  address_t baseAddr = reinterpret_cast<address_t>(memBaseAddr);
  address_t currEndAddr = reinterpret_cast<address_t>(memCurrEndAddr);
  address_t releaseEndAddr = releaseBeginAddr + size;
  if (releaseBeginAddr < baseAddr || releaseEndAddr > currEndAddr) {
    return false;
  }
  ALLOCUTIL_MEM_MADVISE(releaseBeginAddr, size, MADV_ARGUMENT);
  return true;
}

// resize the memory map by releasing the pages at the end (munmap)
bool MemMap::Shrink(size_t newSize) {
  if (newSize >= memMappedSize) {
    return false;
  }
  address_t newEndAddr = reinterpret_cast<address_t>(memBaseAddr) + newSize;
  memMappedEndAddr = reinterpret_cast<void *>(newEndAddr);
  ALLOCUTIL_MEM_UNMAP(memMappedEndAddr, memMappedSize - newSize);
  memMappedSize = newSize;
  memCurrSize = std::min(newSize, memCurrSize);
  return true;
}

void *MemMap::MemMapInRange(address_t lowestAddr, address_t highestAddr,
                            size_t reqSize, int prot, int flags, int fd,
                            int offset) {
  lowestAddr = AllocUtilRndUp<address_t>(lowestAddr, ALLOCUTIL_PAGE_SIZE);
  highestAddr = AllocUtilRndDown<address_t>(highestAddr, ALLOCUTIL_PAGE_SIZE);
  if (lowestAddr >= highestAddr || highestAddr - lowestAddr < reqSize) {
    return MAP_FAILED;
  }
  void *mappedAddr = nullptr;
  highestAddr -= reqSize;
  AllocUtilRand<address_t> randAddr(lowestAddr, highestAddr);
  if (kEnableRandomMemStart) {
    // The hint doesn't guarantee the actually mapped address is in the
    // specified range. If the hint address is already occupied, mmap will try
    // other arbitrary addresses. We need to check the result, and repeat if
    // fails.
    int repeat = 10;
    while (mappedAddr == MAP_FAILED && (--repeat) != 0) {
      address_t hint = AllocUtilRndUp(randAddr.next(), ALLOCUTIL_PAGE_SIZE);
      mappedAddr = MemMapInRangeInternal(hint, lowestAddr, highestAddr, reqSize,
                                         prot, flags | MAP_FIXED, fd, offset);
    }
  }
  if (mappedAddr == MAP_FAILED) {
    for (address_t addr = lowestAddr; addr <= highestAddr;
         addr += ALLOCUTIL_PAGE_SIZE) {
      mappedAddr = MemMapInRangeInternal(addr, lowestAddr, highestAddr, reqSize,
                                         prot, flags | MAP_FIXED, fd, offset);
      if (mappedAddr != MAP_FAILED) {
        break;
      }
    }
  }
  return mappedAddr;
}

void *MemMap::MemMapInRangeInternal(address_t hint, address_t lowestAddr,
                                    address_t highestAddr, size_t reqSize,
                                    int prot, int flags, int fd, int offset) {
  void *mappedAddr = nullptr;
#ifndef _WIN32
  mappedAddr =
      mmap(reinterpret_cast<void *>(hint), reqSize, prot, flags, fd, offset);
#endif
  if (mappedAddr == MAP_FAILED) {
    // LOG2FILE(kLogTypeAllocator) <<
    //   FormatString("map memory at %p: hint %p, low %p, high %p, size %zu,
    //   prot %x, flags %x, fd %d, offset %d",
    //              mappedAddr, hint, lowestAddr, highestAddr, reqSize, prot,
    //              flags, fd, offset);
  } else if (reinterpret_cast<address_t>(mappedAddr) < lowestAddr ||
             reinterpret_cast<address_t>(mappedAddr) > highestAddr) {
    ALLOCUTIL_MEM_UNMAP(mappedAddr, reqSize);  // roll back
#ifndef _WIN32
    mappedAddr = MAP_FAILED;
#endif
  }
  return mappedAddr;
}

MemMap::~MemMap() {
  ALLOCUTIL_MEM_UNMAP(memBaseAddr, memMappedSize);
  memBaseAddr = nullptr;
  memCurrEndAddr = nullptr;
  memMappedEndAddr = nullptr;
}
}  // namespace ROS_GC
#endif  // ENABLE_COMPATIBLE_MM
