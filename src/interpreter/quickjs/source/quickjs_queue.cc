// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include "quickjs/include/quickjs_queue.h"
#ifndef _WIN32
#include <sys/mman.h>

#ifdef ENABLE_GC_DEBUG_TOOLS
#define DCHECK(condition) \
  if (!(condition)) abort();
#else
#define DCHECK(condition) ((void)0)
#endif

#define PAGESIZE 16384
#define SIZE_T_ONE ((size_t)1)
#define page_align(S) \
  (((S) + (PAGESIZE - SIZE_T_ONE)) & ~(PAGESIZE - SIZE_T_ONE))

Queue::Queue(void *runtime, int initial_size)
    : rt_(runtime), front(0), rear(0), count(0) {
  if (initial_size < 0) {
    abort();  // assert("Queue's initial_size is negative");
  }
  int mmap_size = (initial_size / 1024 + 1) * 1024 * sizeof(queue[0]);
  mmap_size = page_align(mmap_size);
  queue = reinterpret_cast<void **>(mmap(0, mmap_size, PROT_READ | PROT_WRITE,
                                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0));
  if ((void *)queue == MAP_FAILED) {
    abort();
  }
  size = mmap_size / sizeof(queue[0]);
}

Queue::Queue(void *runtime) : rt_(runtime), front(0), rear(0), count(0) {
  int mmap_size = (DEFAULT_INIT_SIZE / 1024 + 1) * 1024 * sizeof(queue[0]);
  mmap_size = page_align(mmap_size);
  queue = reinterpret_cast<void **>(mmap(0, mmap_size, PROT_READ | PROT_WRITE,
                                         MAP_PRIVATE | MAP_ANONYMOUS, -1, 0));
  if (reinterpret_cast<void *>(queue) == MAP_FAILED) {
    abort();
  }
  size = mmap_size / sizeof(queue[0]);
  (void)rt_;
}

Queue::~Queue() {
  if (queue && munmap(queue, size * sizeof(queue[0])) != 0) {
    abort();
  }
}

bool Queue::IsEmpty() { return count == 0; }

bool Queue::IsFull() { return count == size - 1; }

void Queue::EnQueue(void *ptr) {
  if (!ptr) return;
#ifdef ENABLE_GC_DEBUG_TOOLS
  DCHECK(check_valid_ptr(rt_, ptr));
#endif
  // queue is full
  if (IsFull()) {
    ResizeQueue();
  }
  queue[rear] = ptr;
  if (rear == size - 1) {
    rear = 0;
  } else {
    rear++;
  }
  count++;
}

void *Queue::DeQueue() {
  // if (IsEmpty()) {
  //   return nullptr;
  // }
  void *ret = queue[front];
  count--;
  if (count == 0) {
    front = 0;
    rear = 0;
  } else if (front == size - 1) {
    front = 0;
  } else {
    front++;
  }
  return ret;
}

void *Queue::Front() { return queue[front]; }

void Queue::ResizeQueue() {
  int new_size = 2 * size;
  void **new_queue = reinterpret_cast<void **>(
      mmap(0, (new_size * sizeof(queue[0])), PROT_READ | PROT_WRITE,
           MAP_PRIVATE | MAP_ANONYMOUS, -1, 0));
  if (reinterpret_cast<void *>(new_queue) == MAP_FAILED) {
    abort();
  }
  if (rear < front) {
    rear = rear + size;
  }
  for (int i = front; i < rear; i++) {
    new_queue[i] = queue[i % size];
  }

  if (queue && munmap(queue, size * sizeof(queue[0])) != 0) {
    abort();
  }
  size = new_size;
  queue = new_queue;
}
#endif

/*void Queue::Display() {
  printf("-------- display queue --------\n");
  printf("size: %d, count: %d, front: %d, rear: %d\n", size, count, front,
         rear);
  if (rear >= front) {
    for (int i = front; i < rear; i++) {
      printf("current_ptr: %p\n", queue[i]);
    }
  } else {
    for (int i = front; i < size; i++) {
      printf("current_ptr: %p\n", queue[i]);
    }
    for (int i = 0; i < rear; i++) {
      printf("current_ptr: %p\n", queue[i]);
    }
  }
}*/
