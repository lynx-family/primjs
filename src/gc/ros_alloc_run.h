#ifndef SRC_GC_ROS_ALLOC_RUN_H_
#define SRC_GC_ROS_ALLOC_RUN_H_

#include "gc/alloc_config.h"
#include "gc/sizes.h"
#include "gc/structs.h"

namespace ROS_GC {
using SlotPtrType = address_t;

class Slot {
 public:
  address_t GetNext() const {
    // possible extension
    return static_cast<address_t>(mNext);
  }
  void SetNext(address_t next) {
    // possible truncation
    mNext = static_cast<SlotPtrType>(next);
  }

 private:
  // This pointer occupies the first few bytes in a slot of a run;
  // it's important that this pointer is always set (as nullptr when it is the
  // last node) because we also use this as a flag to tell if it is allocated by
  // us. See IsAllocatedByAllocator.
  SlotPtrType mNext;
};

class FreeList {
 public:
  inline address_t GetHead() const { return static_cast<address_t>(mHead); }
  inline address_t GetTail() const { return static_cast<address_t>(mTail); }

  inline void SetHead(address_t addr) {
    mHead = static_cast<SlotPtrType>(addr);
  }
  inline void SetTail(address_t addr) {
    mTail = static_cast<SlotPtrType>(addr);
  }

  // insert a slot into the list, i.e., free a slot
  inline void Insert(address_t addr) {
    ROSIMPL_ASSERT(addr != 0, "cannot insert null slot into the list");

    Slot *slot = reinterpret_cast<Slot *>(addr);
    // this normally also clears 'allocated' bit, unless we do jsan
    slot->SetNext(mHead);
    SetHead(addr);

    if (UNLIKELY(mTail == 0)) {
      SetTail(addr);
    }
  }

  // fetch a slot from the list, i.e., alloc a slot
  inline address_t Fetch() {
    if (UNLIKELY(mHead == 0)) {
      return 0;
    }

    address_t addr = static_cast<address_t>(mHead);
    Slot *slot = reinterpret_cast<Slot *>(addr);
    SetHead(slot->GetNext());

    if (UNLIKELY(mHead == 0)) {
      SetTail(0);
    }
    return addr;
  }

  // add the other list to the beginning of this one, and clear the other list
  // the other list is not allowed to be empty
  inline void Prepend(FreeList &other) {
    ROSIMPL_ASSERT(other.GetHead() != 0, "prepending an empty list");
    Slot *tail = reinterpret_cast<Slot *>(other.GetTail());
    tail->SetNext(GetHead());
    SetHead(other.GetHead());

    if (mTail == 0) {
      SetTail(other.GetTail());
    }

    other.SetHead(0);
    other.SetTail(0);
  }

  void Init(address_t baseAddr, size_t slotSize, size_t slotCount);

 private:
  SlotPtrType mHead = 0;
  SlotPtrType mTail = 0;
};

// Used when enumerating objects.  Only call the visitor on objects that match
// this criterion.
enum class OnlyVisit : uint32_t {
  kVisitAll,          // Visit all objects
  kVisitFinalizable,  // Only visit objects with finalizable bit
  kVisitLast
};

class SweepContext;

using RunListPtrType = address_t;

class RunSlots {
 public:
  static constexpr uint8_t kIsLocalMask = 0x1;
  static constexpr uint8_t kHasShapeFinalizerMask = 0x2;
  static constexpr uint8_t kHasFinalizerMask = 0x10;
  static constexpr uint8_t kHasInitMask = 0x80;

  // run data structure size is a very vital part in heap fragmentation
  // we currently aim for a 64-byte run header in production mode
  // offset +0
  uint8_t mIdx;
  uint8_t flags;
  std::atomic<uint8_t> isInList{0};
  uint8_t magic;
  // uint8_t padding __attribute__((unused));
  //  offset +4
  uint32_t nFree;  // this number can tell us whether a run is full quickly
  // offset +8
  RunListPtrType mNext;  // +4
  RunListPtrType mPrev;  // +4
  FreeList freeList;     // +8
  // offset +24
  // +40; run header size 64 bytes, slots begin at offset +64
  // put a static check/warning to see if it's actually 40
  static const size_t maxSlots[RunConfig::kRunConfigs];

  static inline constexpr size_t GetHeaderSize() { return sizeof(RunSlots); }

  static inline constexpr size_t GetContentOffset() {
    return AllocUtilRndUp(GetHeaderSize(), kAllocAlign);
  }

  inline size_t GetRunSize() const { return ROSIMPL_RUN_SIZE(mIdx); }
  inline size_t GetMaxSlots() const { return maxSlots[mIdx]; };

  inline RunSlots *GetNext() {
    return reinterpret_cast<RunSlots *>(static_cast<address_t>(mNext));
  }
  inline RunSlots *GetPrev() {
    return reinterpret_cast<RunSlots *>(static_cast<address_t>(mPrev));
  }
  inline void SetNext(const RunSlots *run) {
    mNext = static_cast<RunListPtrType>(reinterpret_cast<address_t>(run));
  }
  inline void SetPrev(const RunSlots *run) {
    mPrev = static_cast<RunListPtrType>(reinterpret_cast<address_t>(run));
  }
  inline float Value() const {
    // the "value" of a run depends on its current utilization
    return 1 - static_cast<float>(nFree) / GetMaxSlots();
  }

  inline void SetLocalFlag(bool val) {
    flags = val ? (flags | kIsLocalMask) : (flags & ~kIsLocalMask);
  }

  inline void SetInList(bool val) { isInList = val; }

  inline void SetInit() { flags |= kHasInitMask; }

  inline void SetHasFinalizer() { flags |= kHasFinalizerMask; }

  inline bool IsLocal() const { return (flags & kIsLocalMask) != 0; }

  inline bool IsInList() const { return isInList; }

  inline bool HasInit() const { return (flags & kHasInitMask) != 0; }

  inline bool HasFinalizer() const { return (flags & kHasFinalizerMask) != 0; }

  explicit RunSlots(uint32_t idx);
  ~RunSlots() {
#ifdef ROSIMPL_MEMSET_AT_FREE
    memset(this, 0, 4096 * RunConfig::kCfgs[mIdx].numPagesPerRun);
#endif
  }
  void Init();

  inline bool IsEmpty() const { return (nFree == GetMaxSlots()); }
  inline bool IsFull() const { return (nFree == 0); }

  inline address_t GetBaseAddress() const {
    return reinterpret_cast<address_t>(this) + GetContentOffset();
  }

  inline address_t AllocSlot() {
    address_t addr = reinterpret_cast<address_t>(freeList.Fetch());
    if (LIKELY(addr != 0)) {
      --nFree;
    }
    return addr;
  }
  inline void FreeSlot(address_t addr) {
    freeList.Insert(addr);
    ++nFree;
  }

  // sweep this run page if it is not swept.
  // return true if swept run to empty (need free)
  // bool Sweep(RosAllocImpl &allocator);
  // bool DoSweep(RosAllocImpl &allocator, SweepContext &context, size_t
  // pageIndex);

  // return true if the given address represents an allocated slot
  bool IsLiveObjAddr(address_t objAddr) const;
  void TryToRecordValidObjAddr(RootSet *rootSet, address_t addr) const;
  // NOTE: when `onlyVisit` is present, `hint` is the maximum number of objects
  // in the run that matches the criterion.  This method will return immediately
  // after `hint` slots are visited.
#ifndef _WIN32
  void ForEachObj(HeapAliveObjsVisitor &visitor,
                  size_t hint = std::numeric_limits<size_t>::max());
#endif

  void FreeIterator(std::function<void(address_t, address_t, size_t)> visitor);
};

// this implements a partially sorted list, according to a node's "Value", in
// descending order this supports these operations:
//   Insert: insert into one of the three parts of the list, according to the
//   "Value" Erase: erase a node from the list Fetch: fetch a node from the
//   middle part of the list, which is considered the ideal choice
//
// this list is sorted based on the assumption: each node's value only slowly
// decreases, not incs
//
// with this assumption, we never need to do any log(n) or whatever
// time-consuming operation
template <typename NodeType>
class ThreeTierList {
 public:
  static constexpr float kFirstTierBar = 0.6;
  static constexpr float kSecondTierBar = 0.3;
  static constexpr bool kPreferFirstTier = false;

  ThreeTierList()
      : firstTierHead(nullptr),
        secondTierHead(nullptr),
        secondTierTail(nullptr),
        thirdTierHead(nullptr) {}

  ~ThreeTierList() { Release(); }

  void Release() {
    firstTierHead = nullptr;
    secondTierHead = nullptr;
    secondTierTail = nullptr;
    thirdTierHead = nullptr;
  }

  NodeType *GetList() {
    NodeType *it = firstTierHead;
    if (it == nullptr) {
      it = secondTierHead;
      if (it == nullptr) it = thirdTierHead;
    }
    return it;
  }

  // insert a node
  void Insert(NodeType &n) {
    ROSIMPL_ASSERT(!n.IsInList(), "inserting node already in list");
    if (secondTierHead == nullptr) {
      ROSIMPL_ASSERT(firstTierHead == nullptr,
                     "list must be empty, no first tier head");
      ROSIMPL_ASSERT(thirdTierHead == nullptr,
                     "list must be empty, no third tier head");
      ROSIMPL_ASSERT(secondTierTail == nullptr,
                     "list must be empty, no second tier tail");
      n.SetNext(nullptr);
      n.SetPrev(nullptr);
      secondTierHead = &n;
      secondTierTail = &n;
      n.SetInList(true);
      return;
    }
    if (n.Value() > kFirstTierBar) {
      ROSIMPL_ASSERT(n.Value() <= 1, "invalid node value");
      InsertFirst(n);
    } else if (n.Value() > kSecondTierBar) {
      InsertSecond(n);
    } else {
      ROSIMPL_ASSERT(n.Value() >= 0, "negative node value");
      InsertThird(n);
    }
    n.SetInList(true);
  }

  // fetch a node, ideally from the second tier
  NodeType *Fetch() {
    if (secondTierHead == nullptr) {
      ROSIMPL_ASSERT(firstTierHead == nullptr,
                     "list must be empty, no first tier head");
      ROSIMPL_ASSERT(thirdTierHead == nullptr,
                     "list must be empty, no third tier head");
      ROSIMPL_ASSERT(secondTierTail == nullptr,
                     "list must be empty, no second tier tail");
      return nullptr;
    }

    NodeType *n = secondTierHead;
    EraseSecond();
    if (n->GetNext() != nullptr) {
      n->GetNext()->SetPrev(n->GetPrev());
    }
    if (n->GetPrev() != nullptr) {
      n->GetPrev()->SetNext(n->GetNext());
    }
    n->SetNext(nullptr);
    n->SetPrev(nullptr);
    n->SetInList(false);
    return n;
  }

  // erase a particular node from the list
  void Erase(NodeType &n) {
    ROSIMPL_ASSERT(n.IsInList(), "erasing node not in list");

    if (&n == firstTierHead) {
      firstTierHead = firstTierHead->GetNext();
      if (firstTierHead != nullptr && firstTierHead == secondTierHead) {
        firstTierHead = nullptr;
      }
    } else if (&n == secondTierHead) {
      EraseSecond();
    } else if (&n == secondTierTail) {
      ROSIMPL_ASSERT(secondTierTail != secondTierHead,
                     "must not be second tier head");
      secondTierTail = secondTierTail->GetPrev();
    } else if (&n == thirdTierHead) {
      thirdTierHead = thirdTierHead->GetNext();
    }
    if (n.GetNext() != nullptr) {
      n.GetNext()->SetPrev(n.GetPrev());
    }
    if (n.GetPrev() != nullptr) {
      n.GetPrev()->SetNext(n.GetNext());
    }
    n.SetNext(nullptr);
    n.SetPrev(nullptr);
    n.SetInList(false);
  }

 private:
  NodeType *firstTierHead;
  NodeType *secondTierHead;
  NodeType *secondTierTail;
  NodeType *thirdTierHead;

  inline void InsertFirst(NodeType &n) {
    // insert into first tier
    if (firstTierHead != nullptr) {
      n.SetNext(firstTierHead);
      n.SetPrev(nullptr);
      firstTierHead->SetPrev(&n);
      firstTierHead = &n;
    } else {
      n.SetNext(secondTierHead);
      n.SetPrev(nullptr);
      secondTierHead->SetPrev(&n);
      firstTierHead = &n;
    }
  }

  inline void InsertSecond(NodeType &n) {
    // insert into second tier
    n.SetNext(secondTierHead);
    NodeType *prev = secondTierHead->GetPrev();
    n.SetPrev(prev);
    if (prev != nullptr) {
      prev->SetNext(&n);
    }
    secondTierHead->SetPrev(&n);
    secondTierHead = &n;
  }

  inline void InsertThird(NodeType &n) {
    // insert into third tier
    if (thirdTierHead != nullptr) {
      n.SetNext(thirdTierHead);
      n.SetPrev(thirdTierHead->GetPrev());
      thirdTierHead->GetPrev()->SetNext(&n);
      thirdTierHead->SetPrev(&n);
      thirdTierHead = &n;
    } else {
      n.SetNext(nullptr);
      n.SetPrev(secondTierTail);
      secondTierTail->SetNext(&n);
      thirdTierHead = &n;
    }
  }

  // remove the first node in the second tier
  void EraseSecond() {
    if (secondTierHead != secondTierTail) {
      secondTierHead = secondTierHead->GetNext();
      return;
    }
    // last one in the second tier
    NodeType *newHead = nullptr;
    if (kPreferFirstTier == true) {
      // move a node from first tier to second tier
      newHead = secondTierHead->GetPrev();
      if (newHead == firstTierHead && firstTierHead != nullptr) {
        firstTierHead = nullptr;
      } else if (newHead == nullptr) {
        newHead = secondTierHead->GetNext();
        if (newHead == thirdTierHead && thirdTierHead != nullptr) {
          thirdTierHead = thirdTierHead->GetNext();
        }
      }
    } else {
      // move a node from third tier to second tier
      newHead = secondTierHead->GetNext();
      if (newHead == thirdTierHead && thirdTierHead != nullptr) {
        thirdTierHead = thirdTierHead->GetNext();
      } else if (newHead == nullptr) {
        newHead = secondTierHead->GetPrev();
        if (newHead == firstTierHead && firstTierHead != nullptr) {
          firstTierHead = nullptr;
        }
      }
    }
    secondTierHead = newHead;
    secondTierTail = newHead;
  }
};
}  // namespace ROS_GC

#endif  // RTS_GC_ROSALLOC_RUN_H
