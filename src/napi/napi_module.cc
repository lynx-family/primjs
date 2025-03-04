/**
 * Copyright (c) 2017 Node.js API collaborators. All Rights Reserved.
 *
 * Use of this source code is governed by a MIT license that can be
 * found in the LICENSE file in the root of the source tree.
 */
// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "napi_module.h"

#include <atomic>
#include <cstring>
#include <mutex>
#ifdef USE_PRIMJS_NAPI
#include "primjs_napi_defines.h"
#endif
class spin_lock {
  std::atomic_flag locked = ATOMIC_FLAG_INIT;

 public:
  void lock() {
    while (locked.test_and_set(std::memory_order_acquire)) {
    }
  }
  void unlock() { locked.clear(std::memory_order_release); }
};

// do not use std::mutex
// it will increase AAR size by 70kb
static spin_lock mod_lock;

static napi_module* modlist = nullptr;

void napi_module_register_xx(napi_module* mod) {
  std::lock_guard<spin_lock> lock(mod_lock);

  mod->nm_link = modlist;
  modlist = mod;
}

const napi_module* napi_find_module(const char* name) {
  std::lock_guard<spin_lock> lock(mod_lock);

  for (const napi_module* m = modlist; m; m = m->nm_link) {
    if (std::strcmp(name, m->nm_modname) == 0) {
      return m;
    }
  }
  return nullptr;
}
