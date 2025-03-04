// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

#include <iostream>

#include "basic/log/logging.h"

namespace primjs {
namespace general {
namespace logging {
void Log(LogMessage *msg) {
  std::cout << msg->stream().str() << std::endl;
  return;
}
}  // namespace logging
}  // namespace general

}  // namespace primjs
