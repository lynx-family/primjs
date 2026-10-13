// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// Smoke test for the Swift Package Manager build. `swift build` only archives
// the library targets, so this is what links the pre-generated snapshot
// (embedded.S) and runs the template interpreter. Includes use the CocoaPods
// paths reproduced by swiftpm/headers.

#import <XCTest/XCTest.h>

#include "napi.h"
#include "napi_env.h"
#include "napi_env_quickjs.h"
#include "quickjs/include/quickjs.h"
#include "quickjs/include/trace-gc.h"

@interface PrimJSTests : XCTestCase
@end

@implementation PrimJSTests {
  LEPUSRuntime *_runtime;
  LEPUSContext *_context;
}

- (void)setUp {
  _runtime = LEPUS_NewRuntime();
  _context = LEPUS_NewContext(_runtime);
}

- (void)tearDown {
  LEPUS_FreeContext(_context);
  LEPUS_FreeRuntime(_runtime);
}

- (void)testEvaluatesScript {
  // ENABLE_COMPATIBLE_MM (from the podspec) means tracing GC plus the
  // template interpreter, i.e. the embedded snapshot is exercised here.
  XCTAssertTrue(LEPUS_IsGCMode(_context));

  const char *script = "let sum = 0; for (let i = 0; i < 1000; i++) sum += i; sum";
  HandleScope scope(_context);
  LEPUSValue value = LEPUS_Eval(_context, script, strlen(script), "<test>",
                                LEPUS_EVAL_TYPE_GLOBAL);
  scope.PushHandle(&value, HANDLE_TYPE_LEPUS_VALUE);
  XCTAssertFalse(LEPUS_IsException(value));

  int32_t result = 0;
  XCTAssertEqual(LEPUS_ToInt32(_context, &result, value), 0);
  XCTAssertEqual(result, 499500);
}

- (void)testNodeAPIOnQuickJS {
  napi_env env = napi_new_env();
  napi_attach_quickjs(env, _context);
  {
    Napi::HandleScope scope(env);
    Napi::Value result = Napi::Env(env).RunScript("6 * 7");
    XCTAssertEqual(result.As<Napi::Number>().Int32Value(), 42);
  }
  napi_detach_quickjs(env);
  napi_free_env(env);
}

@end
