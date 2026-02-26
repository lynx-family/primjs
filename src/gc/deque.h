/*
 * Copyright (c) [2020] Huawei Technologies Co., Ltd. All rights reserved.
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
#ifndef SRC_GC_ROSALLOC_DEQUE_H_
#define SRC_GC_ROSALLOC_DEQUE_H_

#include <cstddef>
#include <cstdint>

#include "gc/mem_map.h"

#define DEBUG_DEQUE __MRT_DEBUG_COND_FALSE
#define DEQUE_ASSERT(cond, msg) (void(0))

namespace ROS_GC {
// this deque is single-use, meaning we can use it, then after a while,
// we can discard its whole content
// under this assumption, clearing this data structure is really fast
// (each clear takes O(1) time)
// also, this assumes that the underlying memory does not need to be freed
// because we can reuse it after each clear
//
// it can be used like a queue or a stack
template <class ValType>
class SingleUseDeque {
 public:
  static constexpr size_t kValSize = sizeof(ValType);
  void Init(size_t mapSize) {
    static_assert(kValSize == sizeof(void *), "invalid val type");
    MemMap::Option opt = MemMap::kDefaultOptions;
    opt.tag = "alloc_ros_sud";
    opt.reqBase = nullptr;
    opt.reqRange = false;
    memMap = MemMap::MapMemory(mapSize, mapSize, opt);
    beginAddr = reinterpret_cast<address_t>(memMap->GetBaseAddr());
    endAddr = reinterpret_cast<address_t>(memMap->GetCurrEnd());
    Clear();
  }
  void Init(MemMap &other) {
    // init from another sud, that is, the two suds share the same mem map
    static_assert(kValSize == sizeof(void *), "invalid val type");
    memMap = &other;
    beginAddr = reinterpret_cast<address_t>(memMap->GetBaseAddr());
    endAddr = reinterpret_cast<address_t>(memMap->GetCurrEnd());
    Clear();
  }
  MemMap &GetMemMap() { return *memMap; }
  bool Empty() const { return topAddr < frontAddr; }
  void Push(ValType v) {
    topAddr += kValSize;
    DEQUE_ASSERT(topAddr < endAddr, "not enough memory");
    *reinterpret_cast<ValType *>(topAddr) = v;
  }
  ValType Top() const {
    DEQUE_ASSERT(topAddr >= frontAddr, "read empty queue");
    return *reinterpret_cast<ValType *>(topAddr);
  }
  void Pop() {
    DEQUE_ASSERT(topAddr >= frontAddr, "pop empty queue");
    topAddr -= kValSize;
  }
  ValType Front() const {
    DEQUE_ASSERT(frontAddr <= topAddr, "front reach end");
    return *reinterpret_cast<ValType *>(frontAddr);
  }
  void PopFront() {
    DEQUE_ASSERT(frontAddr <= topAddr, "pop front empty queue");
    frontAddr += kValSize;
  }
  void Clear() {
    frontAddr = beginAddr;
    topAddr = beginAddr - kValSize;
  }
  void Destruct(bool deleteMemMap = true) {
    if (deleteMemMap) {
      delete memMap;
    }
    memMap = nullptr;
  }

 private:
  MemMap *memMap = nullptr;
  address_t beginAddr = 0;
  address_t frontAddr = 0;
  address_t topAddr = 0;
  address_t endAddr = 0;
};

// this deque lives on the stack, hence local
// this is better than the above deque because it avoids visiting ram
// and it also avoids using unfreeable memory
// however, its capacity is limited
template <class ValType>
class LocalDeque {
 public:
  static_assert(sizeof(ValType) == sizeof(void *), "invalid val type");
  static constexpr int kLocalLength = ALLOCUTIL_PAGE_SIZE / sizeof(ValType);
  LocalDeque() : sud(nullptr) {}
  LocalDeque(SingleUseDeque<ValType> &singleUseDeque) : sud(&singleUseDeque) {}
  ~LocalDeque() = default;
  void SetSud(SingleUseDeque<ValType> &singleUseDeque) {
    sud = &singleUseDeque;
  }
  bool Empty() const {
    return (top < front) || (front == kLocalLength && sud->Empty());
  }
  void Push(ValType v) {
    if (LIKELY(top < kLocalLength - 1)) {
      array[++top] = v;
      return;
    } else if (top == kLocalLength - 1) {
      ++top;
      sud->Clear();
    }
    sud->Push(v);
  }
  ValType Top() const {
    if (LIKELY(top < kLocalLength)) {
      DEQUE_ASSERT(top >= front, "read empty queue");
      return array[top];
    }
    return sud->Top();
  }
  void Pop() {
    if (LIKELY(top < kLocalLength)) {
      DEQUE_ASSERT(top >= front, "pop empty queue");
      --top;
      return;
    }
    DEQUE_ASSERT(top == kLocalLength, "pop error");
    sud->Pop();
    if (front < kLocalLength) {
      // if front is already in sud, there is no need to dec top, since local is
      // no longer useful
      --top;
      return;
    }
  }
  ValType Front() const {
    if (LIKELY(front < kLocalLength)) {
      DEQUE_ASSERT(front <= top, "read empty queue front");
      return array[front];
    }
    DEQUE_ASSERT(top == kLocalLength, "queue front error");
    return sud->Front();
  }
  void PopFront() {
    if (LIKELY(front < kLocalLength)) {
      DEQUE_ASSERT(front <= top, "pop front empty queue");
      ++front;
      return;
    }
    DEQUE_ASSERT(front == kLocalLength, "pop front error");
    sud->PopFront();
  }

 private:
  int front = 0;
  int top = -1;
  SingleUseDeque<ValType> *sud;
  ValType array[kLocalLength];
};
}  // namespace ROS_GC

#endif  // SRC_GC_ROSALLOC_DEQUE_H_
