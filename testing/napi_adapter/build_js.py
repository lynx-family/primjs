#!/usr/bin/env python3
# Copyright 2024-2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.
"""Bundle every migrated Node-API feature suite, failing on missing inputs."""
import argparse
import json
import pathlib
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--stamp', type=pathlib.Path)
    options = parser.parse_args()
    root = pathlib.Path(__file__).resolve().parent
    browserify = root / 'node_modules/.bin/browserify'
    if not browserify.is_file():
        manager = json.loads((root / 'package.json').read_text(encoding='utf-8'))['packageManager']
        subprocess.run(['npx', '--yes', manager, 'install', '--frozen-lockfile'],
                       cwd=root, check=True)
    suites = sorted(p for p in (root / 'js_native_api').iterdir() if p.is_dir())
    if not suites:
        raise RuntimeError('No Node-API test suites found')
    for suite in suites:
        tests = sorted(suite.glob('test*.js'))
        if not tests:
            raise RuntimeError('No JavaScript cases in ' + str(suite))
        export = suite / 'build/export'
        export.mkdir(parents=True, exist_ok=True)
        (export / 'index.js').write_text(
            'module.exports = global.napiLoaderForTest.load("' + suite.name + '");\n',
            encoding='utf-8')
        subprocess.run([str(browserify), *(str(p) for p in tests),
                        '--require', './build/export/', '-o', 'build/test_bundler.js'],
                       cwd=suite, check=True)
    print('Bundled ' + str(len(suites)) + ' Node-API suites', flush=True)
    if options.stamp:
        options.stamp.parent.mkdir(parents=True, exist_ok=True)
        options.stamp.write_text('Node-API bundles ready\n', encoding='utf-8')


if __name__ == '__main__':
    main()
