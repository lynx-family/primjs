#ifndef GC_WORK_STACK_H
#define GC_WORK_STACK_H

#include "gc/mark_stack.h"
#include "gc/mrt_bitmap.h"
#include "gc/page_group.h"

struct LEPUSRuntime;

namespace ROS_GC {
class GCMarking;
}

class GCWorkStack {
  friend class ROS_GC::GCMarking;

 public:
  GCWorkStack(ROS_GC::PageList &bb, size_t workerID)
      : globalPageList_(bb), workerID_(workerID) {}

  virtual ~GCWorkStack(){};
#if CONMARK_CHECKER_ENABLE
  virtual void push_back(address_t ele) {
#else
  void push_back(address_t ele) {
#endif
    if (ele == 0) return;
#if ROS_DEBUG
    if ((ele % 8) != 0) {
      *(int *)(0xdead2) = 0;
    }
    if (*(int64_t *)(ele) == (int64_t)0xcccccccccccccccc) {
      if (!ROS_GC::IsAllocatedByAllocator(ele - ROS_GC::kHeaderSize)) {
        *(void **)(0xdead3) = 0;
      }
    }
#endif
    auto obj_header = ele - ROS_GC::kHeaderSize;
    ROS_GC::Bitmap *bit_map = ROS_GC::PageGroups::GetBitMapFromAddr(obj_header);
    bool shouldSkipMark = bit_map->MarkObject(obj_header);
    if (shouldSkipMark) {
      return;
    }
    if (UNLIKELY(inNode_->IsFull())) {
      globalPageList_.EnsureAvailNode(inNode_);
      ASSERT_CHECKER(inNode_->IsEmpty());
      ASSERT_CHECKER(!inNode_->Next());
      PostInNode();
    }
    inNode_->Push(ele);
  }

  void PostInNode();
  void PostTask();

  size_t get_workerid() { return workerID_; }
  void set_workerid(size_t id) { workerID_ = id; }

  bool empty() const { return (inNode_ == nullptr) || inNode_->IsEmpty(); }
  ROS_GC::PageList::Node *GetNode() { return inNode_; }

  void InitNode() {
    if (!inNode_) {
      globalPageList_.EnsureAvailNode(inNode_);
      ASSERT_CHECKER(inNode_->IsEmpty());
      ASSERT_CHECKER(!inNode_->Next());
    }
    if (!outNode_) {
      globalPageList_.EnsureAvailNode(outNode_);
      ASSERT_CHECKER(outNode_->IsEmpty());
      ASSERT_CHECKER(!outNode_->Next());
    }
  }

  void DeinitNode() {
    if (outNode_) {
      ASSERT_CHECKER(outNode_->IsEmpty());
      globalPageList_.PushFreeNode(outNode_);
      outNode_ = nullptr;
    }
    if (inNode_) {
      ASSERT_CHECKER(inNode_->IsEmpty());
      globalPageList_.PushFreeNode(inNode_);
      inNode_ = nullptr;
    }
  }

  ROS_GC::PageList::Node *PopOutNode() {
    if (!inNode_->IsEmpty()) {
      auto tmp = outNode_;
      outNode_ = inNode_;
      ASSERT_CHECKER(!outNode_->Next());
      inNode_ = tmp;
      ASSERT_CHECKER(!inNode_->Next());
    } else {
      if (UNLIKELY(!outNode_->IsEmpty())) {
        return outNode_;
      }
      return globalPageList_.PopRetiredNode();
    }
    ASSERT_CHECKER(!outNode_->IsEmpty());
    return outNode_;
  }

  void FinishNode(ROS_GC::PageList::Node *node) {
    node->Reset();
    if (node != outNode_) {
      globalPageList_.PushFreeNode(node);
    }
  }

  void RetireNode() {
    if (inNode_->IsEmpty()) {
      return;
    }
    globalPageList_.RetireNode(inNode_);
    PostTask();
    inNode_ = nullptr;
    globalPageList_.EnsureAvailNode(inNode_);
    ASSERT_CHECKER(inNode_->IsEmpty());
    ASSERT_CHECKER(!inNode_->Next());
  }

  void SetMarking(ROS_GC::GCMarking *marking) { marking_ = marking; }
  void SetRuntime(LEPUSRuntime *rt) { rt_ = rt; }
  LEPUSRuntime *GetRuntime() { return rt_; }

 protected:
  ROS_GC::GCMarking *marking_ = nullptr;
  LEPUSRuntime *rt_ = nullptr;
  ROS_GC::PageList &globalPageList_;
  ROS_GC::PageList::Node *inNode_ = nullptr;
  ROS_GC::PageList::Node *outNode_ = nullptr;
  size_t workerID_;
};

#ifdef CONMARK_CHECKER_ENABLE
class CheckGCWorkStack : public GCWorkStack {
 public:
  CheckGCWorkStack(ROS_GC::PageList &bb) : GCWorkStack(bb, 0) {}
  void push_back(address_t ele) override;
  void SetRos(void *ros) { ros_ = ros; }

  OriGCWorkStack &GetWorkStack() { return ori_stack_; }

 private:
  void *ros_;
  OriGCWorkStack ori_stack_;
};
#endif
#endif  // GC_WORK_STACK_H
