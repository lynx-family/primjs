// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#ifndef SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_QUEUE_H_
#define SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_QUEUE_H_

#include <stdlib.h>

#define DEFAULT_INIT_SIZE 2048

#ifdef ENABLE_GC_DEBUG_TOOLS
#include <cstdio>
#ifdef __cplusplus
extern "C" {
#endif
bool check_valid_ptr(void *runtime, void *ptr);
#ifdef __cplusplus
}
#endif
#endif

// rear is emptry, capacity == size - 1
class Queue {
 public:
  Queue(void *runtime, int initial_size);
  explicit Queue(void *runtime);
  ~Queue();

  bool IsEmpty();
  bool IsFull();
  void EnQueue(void *ptr);
  void *DeQueue();
  void *Front();
  void ResizeQueue();
  // void Display();
  int GetCount() { return count; }
  int GetSize() { return size; }
  const void *GetQueue() { return queue; }
  void Split(int cnt, Queue *q) {
    for (int i = 0; i < cnt; i++) {
      q->EnQueue(DeQueue());
    }
  }

 private:
  void **queue;
  void *rt_;
  int front;
  int rear;
  int count;
  int size;
};

#endif  // SRC_INTERPRETER_QUICKJS_INCLUDE_QUICKJS_QUEUE_H_
