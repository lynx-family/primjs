// Copyright 2024 The Lynx Authors. All rights reserved.
// Licensed under the Apache License Version 2.0 that can be found in the
// LICENSE file in the root directory of this source tree.

package com.lynx.primjs.wasm;

import android.util.Log;

public class RegisterWebAssembly {
  public static long registerWebAssembly() {
    long funcPtr = 0;
    try {
      Log.i("primjs", "Loading libwasm.so ...");
      System.loadLibrary("wasm");
      funcPtr = loadWasmFactory();
    } catch (Exception e) {
      Log.e("primjs",
          "No libwasm.so found in the host [ " + e.getMessage() + ", " + e.getCause() + " ]");
    }
    return funcPtr;
  }

  private static native long loadWasmFactory();
}
