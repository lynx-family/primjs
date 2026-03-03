/*
 * QuickJS Javascript Engine
 *
 * Copyright (c) 2017-2019 Fabrice Bellard
 * Copyright (c) 2017-2019 Charlie Gordon
 *
 * Permission is hereby granted, free of charge, to any person
 * obtaining a copy of this software and associated documentation
 * files (the "Software"), to deal in the Software without
 * restriction, including without limitation the rights to use,
 * copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the
 * Software is furnished to do so, subject to the following
 * conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 * OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 * HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 * FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 */
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#ifndef SRC_INSPECTOR_DEBUGGER_DEBUGGER_QUEUE_H_
#define SRC_INSPECTOR_DEBUGGER_DEBUGGER_QUEUE_H_

#ifdef __cplusplus
extern "C" {
#endif

#define LENTH 10240

#include <stdlib.h>
#include <string.h>
/**
 * queue need by debugger to save protocol messages
 */
struct node {
  char *content;
  struct node *p_next;
};

struct qjs_queue {
  struct node *p_head;
  struct node *p_tail;
};

struct node *InitNode(const char *content);

void PushBackQueue(struct qjs_queue *q,
                   const char *content);  // put message to the queue

struct qjs_queue *InitQueue(void);  // init message queue

void PopFrontQueue(
    struct qjs_queue *q);  // get message from the queue, and pop the front

char *GetFrontQueue(struct qjs_queue *q);  // get message from the queue

void DeleteQueue(struct qjs_queue *q);  // delete the queue

bool QueueIsEmpty(struct qjs_queue *q);  // return if the queue is empty

#ifdef __cplusplus
}
#endif

#endif  // SRC_INSPECTOR_DEBUGGER_DEBUGGER_QUEUE_H_
