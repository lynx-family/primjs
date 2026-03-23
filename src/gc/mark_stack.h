#ifndef MARKSTACK_H
#define MARKSTACK_H

#include <cstdint>
#include <cstring>
#include <iterator>
#include <mutex>
#ifndef _WIN32
#include <sys/mman.h>
#endif

#include "gc/alloc_config.h"

#ifdef ROS_DEBUG
#define ASSERT_CHECKER(cond) \
  if (!(cond)) {             \
    *((int *)0xdead) = 0;    \
  }
#else
#define ASSERT_CHECKER(cond) ((void)0)
#endif

namespace ROS_GC {

template <typename T>
class LockList {
  friend class PageList;

 public:
  LockList() : head(nullptr) {}
  ~LockList() = default;

  void Reset() { head = nullptr; }

  void Push(T *n) {
    std::lock_guard<std::mutex> l(lock);
    n->next = head;
    head = n;
  }
  void PushUnsafe(T *n) {
    n->next = head;
    head = n;
  }
  void PushList(T *list) {
    std::lock_guard<std::mutex> l(lock);
    if (UNLIKELY(head == nullptr)) {
      head = list;
      return;
    }
    T *cur = list;
    while (cur != nullptr) {
      T *next = cur->next;
      PushUnsafe(cur);
      cur = next;
    }
  }

  T *Pop() {
    std::lock_guard<std::mutex> l(lock);
    T *old = head;
    if (old == nullptr) {
      return nullptr;
    }
    head = old->next;
    old->next = nullptr;
    return old;
  }

 private:
  std::mutex lock;
  T *head;
};

template <typename T>
class LockFreeList {
  friend class PageList;

 public:
  LockFreeList() : head(nullptr) {}
  ~LockFreeList() = default;

  void Reset() { head = nullptr; }

  void Push(T *n) {
    T *old = head.load(std::memory_order_acquire);
    do {
      n->next = old;
    } while (!head.compare_exchange_weak(old, n, std::memory_order_release,
                                         std::memory_order_acquire));
  }

  void PushList(T *list) {
    if (UNLIKELY(head == nullptr)) {
      head = list;
      return;
    }
    T *cur = list;
    while (cur != nullptr) {
      T *next = cur->next;
      Push(cur);
      cur = next;
    }
  }

  T *Pop() {
    T *old = head.load(std::memory_order_acquire);
    do {
      if (old == nullptr) {
        return nullptr;
      }
    } while (!head.compare_exchange_weak(
        old, old->next, std::memory_order_release, std::memory_order_acquire));
    old->next = nullptr;
    return old;
  }

 private:
  std::atomic<T *> head;
};

// used to buffer modified field of rts write
class PageList {
  static constexpr size_t kInitialPages =
      16;  // 16 pages of initial barrier buffer
  static constexpr size_t kAllocatedPages = 2;
  static constexpr size_t kNodeSize = 504;
  static constexpr size_t kMaxPageSize = 100;

 public:
  PageList() = default;
  ~PageList() { Reset(); };

  class Node {
    friend class PageList;
    friend class LockList<Node>;
    friend class LockFreeList<Node>;

   public:
    Node() {
      top = reinterpret_cast<address_t *>(this + 1);
      next = nullptr;
    }
    ~Node() = default;
    bool IsEmpty() const {
      return reinterpret_cast<size_t>(top) ==
             (reinterpret_cast<size_t>(this) + sizeof(Node));
    }
    bool IsFull() const {
      static_assert((sizeof(Node) % sizeof(address_t *)) == 0,
                    "Satb node must be aligned");
      return reinterpret_cast<size_t>(top) ==
             (reinterpret_cast<size_t>(this) + kNodeSize);
    }
    void Push(address_t obj) {
      ASSERT_CHECKER(!IsFull());
      *top = obj;
      top++;
    }
    void Reset() { top = reinterpret_cast<address_t *>(this + 1); }

    address_t *Begin() const {
      return reinterpret_cast<address_t *>(const_cast<Node *>(this + 1));
    }
    address_t *End() const { return top; }
    size_t Size() const { return static_cast<size_t>(End() - Begin()); }
    Node *Next() const { return next; }

    template <typename T>
    void GetObjects(T &stack) const {
      address_t *start =
          reinterpret_cast<address_t *>(const_cast<Node *>(this + 1));
      ROSIMPL_ASSERT(top <= reinterpret_cast<address_t *>(
                                reinterpret_cast<uintptr_t>(this) + kNodeSize),
                     "invalid node");
      (void)std::copy(start, top, std::back_inserter(stack));
    }

   private:
    address_t *top;
    Node *next;
  };

  struct Page {
    Page *next;
  };

  Node *CreateFreeNodeList(size_t bytes) {
    std::lock_guard<std::mutex> l(lock);
    auto node = freeNodes.Pop();
    if (node != nullptr) {
      return node;
    }
    Page *page = GetPages(bytes);
    Node *list = ConstructFreeNodeList(page, bytes);
    Node *next = list->next;
    list->next = nullptr;
    freeNodes.PushList(next);
    return list;
  }

  void EnsureAvailNode(Node *&node) {
    if (node == nullptr) {
      node = freeNodes.Pop();
    } else if (node->IsFull()) {
      // means current node is full
      retiredNodes.Push(node);
      node = freeNodes.Pop();
    } else {
      // not null & have slots
      return;
    }
    if (node == nullptr) {
      node = CreateFreeNodeList(kAllocatedPages * kPageSize);
      ASSERT_CHECKER(node != nullptr);
    }
  }

  void Init() {
    ASSERT_CHECKER(area.head == nullptr);
    std::lock_guard<std::mutex> l(lock);
    size_t initalBytes = kInitialPages * kPageSize;
    Page *page = GetPages(initalBytes);
    Node *list = ConstructFreeNodeList(page, initalBytes);
    freeNodes.head = list;
    retiredNodes.head = nullptr;
  }
  void RetireNode(Node *node) {
    if (node) retiredNodes.Push(node);
  }

  void ResetIfNeeded() {
    if (pageCount <= kMaxPageSize) {
      return;
    }
    Reset();
    Init();
  }

  void Reset() {
#ifndef _WIN32
    if (area.head == nullptr) return;
    Page *list = area.head;
    while (list->next != nullptr) {
      Page *next = list->next;
      munmap(reinterpret_cast<void *>(list), kAllocatedPages * kPageSize);
      list = next;
    }
    munmap(reinterpret_cast<void *>(list), kInitialPages * kPageSize);
    area.head = nullptr;
    freeNodes.head = nullptr;
    retiredNodes.head = nullptr;
    pageCount = 0;
#endif
  }
  Node *PopRetiredNode() { return retiredNodes.Pop(); }

  void PushFreeNode(Node *node) { freeNodes.Push(node); }

  size_t GetPageCount() const { return pageCount; }

 private:
  Page *GetPages(size_t bytes) {
#ifndef _WIN32
    Page *page = reinterpret_cast<Page *>(mmap(
        0, bytes, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0));
    page->next = nullptr;
    area.Push(page);
    pageCount++;
    return page;
#else
    return nullptr;
#endif  // _WIN32
  }
  Node *ConstructFreeNodeList(const Page *page, size_t bytes) const {
    address_t start = reinterpret_cast<address_t>(page) + sizeof(Page);
    address_t end = reinterpret_cast<address_t>(page) + bytes;
    Node *cur = nullptr;
    Node *head = nullptr;
    while (start <= (end - kNodeSize)) {
      Node *node = new (reinterpret_cast<void *>(start)) Node();
      if (cur == nullptr) {
        cur = node;
        head = node;
      } else {
        cur->next = node;
        cur = node;
      }
      start += kNodeSize;
    }
    return head;
  }

  size_t pageCount;
  std::mutex lock;
  LockFreeList<Page>
      area;  // allocatable area, first area is 8 * 4k = 32k, the rest is 4k
  LockList<Node> freeNodes;  // free nodes, rts-thread will acquire nodes from
                             // this list to record old value writes
  LockList<Node> retiredNodes;  // has been filled by rts-thread, ready for scan
};

};      // namespace ROS_GC
#endif  // MARK_STACK_H
