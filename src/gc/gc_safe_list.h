// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#ifndef SRC_GC_QUICKJS_INCLUDE_LIST_H_
#define SRC_GC_QUICKJS_INCLUDE_LIST_H_

#ifdef __cplusplus
extern "C" {
#endif
#include "quickjs/include/list.h"
#ifdef __cplusplus
}
#endif
#include "gc/collector.h"

struct LEPUSContext;
/* add 'el' at the end of the list 'head' (= before element head) */
static inline void gc_list_add_tail(LEPUSContext *ctx, struct list_head *el,
                                    struct list_head *head, int offset) {
  auto prev = head->prev;
  auto next = head;

  if (prev != nullptr) {
    prev->next = el;
  } else {
    head->next = el;
  }
  el->next = next;
  next->prev = el;
  // not emptry list
  if (prev && (prev != head)) {
    el->prev = prev;
    auto prev_value = ((uint8_t *)(prev)-offset);
    WriteBarrierNoStore(ctx, (void *)prev_value);
  } else {
    el->prev = nullptr;
  }
}

static inline void gc_list_del(LEPUSRuntime *rt, struct list_head *el,
                               struct list_head *head, int offset) {
  struct list_head *prev, *next;
  prev = el->prev;
  next = el->next;

  if (prev != nullptr) {
    prev->next = next;
  } else {
    head->next = next;
  }
  if (next != head) {
    auto next_value = ((uint8_t *)(next)-offset);
    WriteBarrierNoStore(rt, (void *)next_value);
  }
  if (prev) {
    auto prev_value = ((uint8_t *)(prev)-offset);
    WriteBarrierNoStore(rt, (void *)prev_value);
    next->prev = prev;
  } else if (next != head) {
    next->prev = nullptr;
  } else {
    head->prev = head;
  }
  el->prev = nullptr; /* fail safe */
  el->next = nullptr; /* fail safe */
}

#endif  // SRC_GC_QUICKJS_INCLUDE_LIST_H_
