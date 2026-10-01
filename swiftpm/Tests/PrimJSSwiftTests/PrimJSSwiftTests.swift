// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

// Swift consumer: `import PrimJS` goes through the generated Clang module
// (swiftpm/headers/PrimJS/module.modulemap), which exposes the C API only.

import PrimJS
import XCTest

final class PrimJSSwiftTests: XCTestCase {
  func testEvaluatesScript() throws {
    let runtime = try XCTUnwrap(LEPUS_NewRuntime())
    defer { LEPUS_FreeRuntime(runtime) }
    let context = try XCTUnwrap(LEPUS_NewContext(runtime))
    defer { LEPUS_FreeContext(context) }

    let script = "const add = (a, b) => a + b; add(40, 2)"
    let value = LEPUS_Eval(context, script, script.utf8.count, "<PrimJSSwiftTests>", 0)
    XCTAssertEqual(LEPUS_IsException(value), 0)

    var result: Int32 = 0
    XCTAssertEqual(LEPUS_ToInt32(context, &result, value), 0)
    XCTAssertEqual(result, 42)
  }
}
