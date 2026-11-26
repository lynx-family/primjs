// Copyright 2026 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.
#include "basic/log/logging.h"
#include "gtest/gtest.h"

namespace primjs {
namespace general {
namespace logging {

TEST(LoggingTest, MinLogLevelAboveInfoSuppressesLowerSeverities) {
  SetMinLogLevel(LOG_ERROR);

  EXPECT_FALSE(LOG_IS_ON(INFO));
  EXPECT_FALSE(LOG_IS_ON(WARNING));
  EXPECT_TRUE(LOG_IS_ON(ERROR));

  SetMinLogLevel(LOG_INFO);
}

}  // namespace logging
}  // namespace general
}  // namespace primjs
