#!/usr/bin/env python3
# Copyright 2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.
"""Build and run the adapter suite from an internal or standalone checkout."""
import argparse
import os
import pathlib
import platform
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--gc', action='store_true')
    parser.add_argument('--out', default='out/napi_adapter')
    parser.add_argument('--gtest-filter', help='Select engine tests using a GoogleTest filter')
    options = parser.parse_args()
    if options.gc and not (platform.system() == 'Darwin' and platform.machine().lower() == 'arm64'):
        parser.error('--gc requires macOS arm64, where the snapshot and tracing GC backend is available')
    tests = pathlib.Path(__file__).resolve().parent
    root = tests.parents[1]
    if (root.parent / '.gn').is_file():
        root = root.parent
    target = '//' + tests.relative_to(root).as_posix() + ':napi_adapter_unittest'
    subprocess.run(['npm', 'run', 'bootstrap-deps'], cwd=tests, check=True)
    subprocess.run(['python3', str(tests / 'build_js.py')], check=True)
    args = 'enable_unittests=true is_asan=true use_lepusng=true use_rtti=true is_debug=true enable_compatible_mm=false'
    args += ' target_os="' + ('mac' if platform.system() == 'Darwin' else 'linux') + '"'
    if options.gc:
        args = args.replace('enable_compatible_mm=false', 'enable_compatible_mm=true')
        args += ' enable_tracing_gc=true force_gc=true'
    env = os.environ.copy()
    env['PATH'] = ':'.join([str(root / 'buildtools/gn'), str(root / 'buildtools/ninja'), env['PATH']])
    subprocess.run(['gn', 'gen', options.out, '--root-target=' + target, '--args=' + args], cwd=root, env=env, check=True)
    subprocess.run(['ninja', '-C', options.out, 'napi_adapter_unittest'], cwd=root, env=env, check=True)
    env['ASAN_OPTIONS'] = 'detect_container_overflow=0' + (':detect_leaks=0' if platform.system() == 'Linux' else '')
    command = [str(root / options.out / 'napi_adapter_unittest')]
    if options.gtest_filter:
        command.append('--gtest_filter=' + options.gtest_filter)
    subprocess.run(command, cwd=root, env=env, check=True)


if __name__ == '__main__':
    main()
