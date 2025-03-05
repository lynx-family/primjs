# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

import platform
import os

machine = platform.machine().lower()
machine = "x86_64" if machine == "amd64" else machine
system = platform.system().lower()

deps = {
    "build": {
        "type": "git",
        "url": "https://github.com/lynx-family/buildroot.git",
        "commit": "b74a2ad3759ed710e67426eb4ce8e559405ed63f",
        "ignore_in_git": True,
        "condition": system in ["linux", "darwin", "windows"],
    },
    "build/linux/debian_sid_amd64-sysroot": {
        "type": "http",
        "url": "https://commondatastorage.googleapis.com/chrome-linux-sysroot/toolchain/79a7783607a69b6f439add567eb6fcb48877085c/debian_sid_amd64_sysroot.tar.xz",
        "ignore_in_git": True,
        "condition": machine == "x86_64" and system == "linux",
        "require": ["build"],
    },
    "buildtools/gn": {
        "type": "http",
        "url": f"https://github.com/lynx-family/buildtools/releases/download/gn-cc28efe6/buildtools-gn-{system}-{machine}.tar.gz",
        "ignore_in_git": True,
        "condition": system in ["linux", "darwin", "windows"],
    },
    "buildtools/ninja": {
        "type": "http",
        "url": {
            "linux": "https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip",
            "darwin": "https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-mac.zip",
            "windows": "https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-win.zip",
        }.get(system, None),
        "sha256": {
            "linux": "b901ba96e486dce377f9a070ed4ef3f79deb45f4ffe2938f8e7ddc69cfb3df77",
            "darwin": "482ecb23c59ae3d4f158029112de172dd96bb0e97549c4b1ca32d8fad11f873e",
            "windows": "524b344a1a9a55005eaf868d991e090ab8ce07fa109f1820d40e74642e289abc",
        }.get(system, None),
        "ignore_in_git": True,
        "condition": system in ["linux", "darwin", "windows"],
    },
    "buildtools/cmake": {
        "type": "http",
        "url": {
            "linux": "https://cmake.org/files/v3.18/cmake-3.18.1-Linux-x86_64.tar.gz",
            "darwin": "https://dl.google.com/android/repository/ba34c321f92f6e6fd696c8354c262c122f56abf8.cmake-3.18.1-darwin.zip",
        }.get(system, None),
        "sha256": {
            "linux": "537de8ad3a7fb4ec9b8517870db255802ad211aec00002c651e178848f7a769e",
            "darwin": "b15d6d7ab5615a48bb14962f5a931be6cd9a0c187f4bd6be404bdd46a7bef60b",
        }.get(system, None),
        "ignore_in_git": True,
        "condition": system in ["linux", "darwin"],
    },
    "buildtools/llvm": {
        "type": "http",
        "url": f"https://github.com/lynx-family/buildtools/releases/download/llvm-020d2fb7/buildtools-llvm-{system}-{machine}.tar.gz",
        "ignore_in_git": True,
        "decompress": True,
        "condition": system in ["linux", "darwin"],
    },
    "change_executable_permission": {
        "type": "action",
        "cwd": root_dir,
        "commands": [
            "chmod +x buildtools/ninja/ninja",
            "chmod +x buildtools/gn/gn",
            "chmod +x buildtools/cmake/bin/cmake",
        ],
        "require": ["buildtools/ninja", "buildtools/gn", "buildtools/cmake"],
        "condition": system in ["linux", "darwin"],
    },
    "third_party/gyp": {
        "type": "git",
        "url": "https://chromium.googlesource.com/external/gyp",
        "commit": "9d09418933ea2f75cc416e5ce38d15f62acd5c9a",
        "ignore_in_git": True,
        "condition": system in ["linux", "darwin", "windows"],
    },
    "third_party/v8/include": {
        "type": "http",
        "url": f"https://github.com/lynx-family/v8-build/releases/download/11.1.277.1/v8_include_headers.zip",
        "ignore_in_git": True,
    },
    "third_party/v8/darwin/lib": {
        "type": "http",
        "url": f"https://github.com/lynx-family/v8-build/releases/download/11.1.277.1/v8_lib_macOS.zip",
        "ignore_in_git": True,
        "condition": system in ["darwin"],
    },
    "third_party/v8/linux/lib": {
        "type": "http",
        "url": f"https://github.com/lynx-family/v8-build/releases/download/11.1.277.1/v8_lib_linux.zip",
        "ignore_in_git": True,
        "condition": system in ["linux"],
    },
    "Android/app/libs/v8so-release.aar": {
        "type": "http",
        "url": f"https://github.com/lynx-family/v8-build/releases/download/11.1.277.1/v8so-release.aar",
        "ignore_in_git": True,
        "decompress": False,
    },
    # The libcxx and libcxxabi are pulled from llvm upstream.
    # They are used when `use_flutter_cxx` is true.
    "third_party/libcxx": {
        "type": "git",
        "url": "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxx",
        "commit": "64d36e572d3f9719c5d75011a718f33f11126851",
        "ignore_in_git": True,
    },
    "third_party/libcxxabi": {
        "type": "git",
        "url": "https://chromium.googlesource.com/external/github.com/llvm/llvm-project/libcxxabi",
        "commit": "9572e56a12c88c011d504a707ca94952be4664f9",
        "ignore_in_git": True,
    },
    "third_party/googletest": {
        "type": "git",
        "url": "https://github.com/google/googletest.git",
        "commit": "04cf2989168a3f9218d463bea6f15f8ade2032fd",
        "ignore_in_git": True,
    },
    "third_party/test262": {
        "type": "git",
        "url": "https://github.com/tc39/test262",
        "commit": "997888324e42013578eb935c2a18a2027ecb8c81",
        "ignore_in_git": True,
        "patches": os.path.join(
            root_dir,
            "patches",
            "test262",
            "0001-Avoid-excessive-U-in-error-messages.patch",
        ),
    },
}
