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

#include "inspector/debugger/debugger_queue.h"

struct node *InitNode(const char *content) {
  struct node *new_node;
  if (content && (new_node = (struct node *)(malloc(sizeof(struct node))))) {
    new_node->content =
        reinterpret_cast<char *>(malloc(sizeof(char) * (strlen(content) + 1)));
    if (new_node->content) {
      strcpy(new_node->content, content);
      new_node->p_next = nullptr;
      return new_node;
    }
  }
  return nullptr;
}

void DeleteQueue(struct qjs_queue *q) {
  struct node *head_node = q->p_head;
  while (head_node) {
    struct node *node = head_node;
    head_node = head_node->p_next;
    free(node->content);
    free(node);
  }
  free(q);
}

struct qjs_queue *InitQueue() {
  struct qjs_queue *q;
  q = (struct qjs_queue *)malloc(sizeof(struct qjs_queue));
  if (q) {
    q->p_head = NULL;
    q->p_tail = NULL;
  }
  return q;
}

void PushBackQueue(struct qjs_queue *q, const char *content) {
  struct node *new_node;
  new_node = InitNode(content);
  if (q->p_head == NULL) {
    q->p_head = new_node;
    q->p_tail = new_node;
  } else {
    q->p_tail->p_next = new_node;
    q->p_tail = new_node;
  }
}

char *GetFrontQueue(struct qjs_queue *q) {
  char *content = NULL;
  if (q->p_head == NULL) {
    content = nullptr;
  } else {
    content = q->p_head->content;
  }
  return content;
}

void PopFrontQueue(struct qjs_queue *q) {
  if (q->p_head) {
    struct node *head_node = q->p_head;
    q->p_head = q->p_head->p_next;
    free(head_node);
  }
}

bool QueueIsEmpty(struct qjs_queue *q) { return !(q->p_head); }
