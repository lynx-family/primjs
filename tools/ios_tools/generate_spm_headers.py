#!/usr/bin/env python3
# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.
"""Generates the public header directories used by Package.swift.

Swift Package Manager allows a single public header directory per target and
cannot rename or re-root headers, so each target gets a directory of relative
symlinks under swiftpm/headers/<target>/. The layout follows the CocoaPods
rules for `public_header_files`, `header_dir` and `header_mappings_dir`
(Headers/Public/PrimJS/<header_dir>/<name>), which keeps the include paths
identical to the ones CocoaPods users have always used, e.g.
`quickjs/include/quickjs.h`, `quickjs/include/trace-gc.h`, `napi_env_quickjs.h`.

TARGETS below is the source of truth for what each SwiftPM target publishes.
When PrimJS.podspec changes its public headers, mirror the change here.

The script owns only the symlinks. Regular files in swiftpm/headers (the
hand-written umbrella header and module map that make `import PrimJS` work
from Swift) are left alone.

Usage:
  python3 tools/ios_tools/generate_spm_headers.py          # regenerate
  python3 tools/ios_tools/generate_spm_headers.py --check  # verify (CI)
"""

import argparse
import os
import sys
from dataclasses import dataclass
from pathlib import Path, PurePosixPath

ROOT = Path(__file__).resolve().parents[2]
OUTPUT = ROOT / "swiftpm" / "headers"


@dataclass(frozen=True)
class Headers:
    """A group of public headers, mapped the way CocoaPods maps a subspec.

    patterns:     globs relative to the repository root.
    exclude:      globs removed from the result.
    header_dir:   directory the headers are published under (flattened).
    mappings_dir: if set, the directory structure below it is preserved
                  instead of flattening.
    """

    patterns: tuple
    exclude: tuple = ()
    header_dir: str = None
    mappings_dir: str = None


# SwiftPM target -> public headers. Mirrors PrimJS.podspec:
#   PrimJS            = subspecs quickjs + log
#   PrimJSInspector   = subspec quickjs_debugger
#   PrimJSNAPI        = subspecs napi/core + napi/env + napi/quickjs
#   PrimJSNAPIJSC     = subspec napi/jsc
#   PrimJSNAPIAdapter = subspec napi/adapter
TARGETS = {
    "PrimJS": (
        Headers(
            patterns=("src/interpreter/quickjs/include/*.h", "src/gc/*.h"),
            header_dir="quickjs/include",
        ),
        Headers(
            patterns=(
                "src/basic/log/logging.h",
                "src/interpreter/quickjs/include/base_export.h",
            ),
            mappings_dir="src",
        ),
    ),
    "PrimJSInspector": (
        Headers(
            patterns=("src/inspector/*.h",),
            exclude=("src/inspector/interface.h",),
            header_dir="devtool/quickjs",
        ),
    ),
    "PrimJSNAPI": (
        Headers(
            patterns=(
                "src/napi/*.h",
                "src/napi/common/*.h",
                "src/napi/env/*.h",
                "src/napi/quickjs/napi_env_quickjs.h",
            ),
        ),
    ),
    "PrimJSNAPIJSC": (Headers(patterns=("src/napi/jsc/napi_env_jsc.h",)),),
    "PrimJSNAPIAdapter": (
        Headers(
            patterns=(
                "src/napi/adapter/js_native_api_adapter.h",
                "src/napi/adapter/primjs_weak_node_api_provider.h",
            ),
        ),
    ),
}


def expand(patterns):
    files = set()
    for pattern in patterns:
        matches = sorted(ROOT.glob(pattern))
        if not matches:
            sys.exit(f"error: {pattern!r} matches no files")
        files.update(p for p in matches if p.is_file())
    return files


def mapped_path(group, header):
    """Same rule as CocoaPods' PodTargetInstaller#header_mappings."""
    dest = PurePosixPath(group.header_dir) if group.header_dir else PurePosixPath()
    if group.mappings_dir:
        dest /= header.relative_to(ROOT / group.mappings_dir).parent.as_posix()
    return dest / header.name


def collect_mappings():
    """Returns {"<target>/<mapped path>": Path(real header)}."""
    mappings = {}
    for target, groups in TARGETS.items():
        for group in groups:
            for header in sorted(expand(group.patterns) - expand(group.exclude)):
                key = (PurePosixPath(target) / mapped_path(group, header)).as_posix()
                if key in mappings and mappings[key] != header:
                    sys.exit(f"error: {key} is produced by both {mappings[key]} and {header}")
                mappings[key] = header
    return mappings


def link_target(key, header):
    return os.path.relpath(header, OUTPUT / PurePosixPath(key).parent)


def read_links():
    """Symlinks currently in swiftpm/headers: {"<target>/<path>": link target}."""
    if not OUTPUT.is_dir():
        return {}
    return {p.relative_to(OUTPUT).as_posix(): os.readlink(p)
            for p in OUTPUT.rglob("*") if p.is_symlink()}


def remove_links():
    for key in read_links():
        (OUTPUT / key).unlink()
    # Drop directories left empty, deepest first.
    for directory in sorted(OUTPUT.rglob("*"), reverse=True):
        if directory.is_dir() and not any(directory.iterdir()):
            directory.rmdir()


def main():
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("--check", action="store_true",
                        help="exit non-zero when swiftpm/headers is out of date")
    args = parser.parse_args()

    mappings = collect_mappings()
    expected = {key: link_target(key, header) for key, header in mappings.items()}
    rel_output = OUTPUT.relative_to(ROOT).as_posix()

    if args.check:
        actual = read_links()
        problems = []
        problems += [f"missing:  {rel_output}/{k}" for k in sorted(expected.keys() - actual.keys())]
        problems += [f"stale:    {rel_output}/{k}" for k in sorted(actual.keys() - expected.keys())]
        problems += [f"changed:  {rel_output}/{k}" for k in sorted(expected.keys() & actual.keys())
                     if expected[k] != actual[k]]
        if problems:
            print("\n".join(problems), file=sys.stderr)
            script = Path(__file__).resolve().relative_to(ROOT).as_posix()
            sys.exit(f"{rel_output} is out of date; run `python3 {script}`")
        print(f"{rel_output} is up to date ({len(mappings)} headers)")
        return

    remove_links()
    for key, target in expected.items():
        link = OUTPUT / key
        link.parent.mkdir(parents=True, exist_ok=True)
        link.symlink_to(target)
    for target in TARGETS:
        count = sum(1 for k in expected if k.startswith(f"{target}/"))
        print(f"{target:<20} {count} headers")


if __name__ == "__main__":
    main()
