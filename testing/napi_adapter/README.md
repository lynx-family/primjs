# N-API Adapter Unit Tests

## Overview
This directory contains unit tests for the PrimJS N-API Adapter, which bridges the compatibility differences between PrimJS N-API and standard open - source N-API implementations.

The test cases are ported from the official Node.js repository and adapted to work with PrimJS:
- JavaScript code is polyfilled using Browserify to handle Node.js-specific features.
- C++ bindings are modified to work with PrimJS's adapter layer.
- The build system uses GN for integration with PrimJS's build infrastructure.

## Prerequisites
- Node.js (v14 or higher)
- npm (v6 or higher)
- A configured PrimJS build environment
- Browserify (will be installed via npm)

## Building and Running Tests
```bash
# Install dependencies
npm install

# Run all tests
npm run test
```

## Test Structure
Tests are organized by N-API feature area in the `js_native_api` directory. Each subdirectory contains:
- A C++ test implementation (`.cc` file)
- A JavaScript test file (`.js`)
- A BUILD.gn file for integration with the build system

## Porting Test Cases from Node.js
To port additional test cases from the Node.js repository, follow these steps:

### 1. Copy Source Files
Copy the relevant `.c` and `.js` files from the Node.js test suite into the appropriate subdirectory under `js_native_api`.

### 2. Modify Source Files
- Update the include statement:
  ```cpp
  // Replace this:
  #include <js_native_api.h>

  // With this:
  #include "Headers/node_api.h"
  ```
- `entry.cc` has been changed to `entry.h`. Therefore, you no longer need to include `entry.cc` in the compilation file, but you need to include `entry.h` in the file where your `Init` function is located.
- Since all test cases are compiled into a single binary, symbol conflicts may occur between different test cases. Add namespaces to the same symbols for isolation.
- As three JS VMs need to be tested, if your test case uses global variables, ensure their states are cleared at the start of each JS VM test.

### 3. Modify JavaScript Test Files
#### 3.1 Handle Common Utilities Dependency
The `../../common` module contains shared test utilities, but it may not include all required functions. If your test case needs additional utilities:
1. Manually add the required functions to `../../common/index.js`.
2. Verify if the functionality can be polyfilled by Browserify using the [Browserify Compatibility Table](https://github.com/browserify/browserify#compatibility).

#### 3.2 Validate External Dependencies
Review all `require()` statements in test files:
- Replace the require statement for importing the addon `require(`./build/${common.buildType}/xxx`);` with `require(`./build/export`);`
- **External modules** (e.g., `fs`, `path`):
  - Keep them if Browserify can polyfill them (check [browserify/polyfill](https://github.com/browserify/polyfill)).
  - Remove or replace them with PrimJS-compatible alternatives if polyfill is not available.

### 4. Create Build Configuration
Add a `BUILD.gn` file in your new test directory with the following template:
```gn
import("//Primjs.gni")
import("//testing/test.gni")

unittest_set("<test_case_name>") {
  configs = [ "//:napi_public_config" ]
  defines = [ "NAPI_MODULE_NAME=<test_case_name>" ]
  sources = [ 
    "<test_case_file1>.c",
    "<test_case_file2>.c",
    ...
    "<test_case_fileN>.c",
   ]
}
```

### 5. Update Main Test Suite
Add your new test case to the dependencies in the `./BUILD.gn` file:
```gn
napi_adapter_testset {
  name = "napi_adapter_unittest"
  deps = [
    # ... existing tests ...
    ":<test_case_name>",  # Add your new test here
  ]
}
```

## License
This project is licensed under the Apache License 2.0. See the LICENSE file for details.

Portions of the test code are derived from the Node.js test suites (`test/js-native-api`, `test/node-api`), which are licensed under the MIT License. See THIRD-PARTY-NOTICES.md for details.