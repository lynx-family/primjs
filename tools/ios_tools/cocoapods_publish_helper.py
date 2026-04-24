#!/usr/bin/env python3
# Copyright 2025 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.

import argparse
import hashlib
import json
from pathlib import Path
import shutil
import subprocess
import zipfile


ROOT_DIR = Path(__file__).resolve().parents[2]
PKG_DIR = ROOT_DIR / "packages" / "weak-node-api"
DIST_DIR = PKG_DIR / "dist" / "ios"
POD_NAME = "LynxWeakNodeAPI"
PODSPEC_PATH = PKG_DIR / f"{POD_NAME}.podspec"
PODSPEC_JSON_PATH = DIST_DIR / f"{POD_NAME}.podspec.json"

COPY_DIRS = [
    "packages/weak-node-api/generated",
    "packages/weak-node-api/headers",
    "packages/weak-node-api/shim",
    "packages/weak-node-api/defs_header",
]

COPY_FILES = [
    "packages/weak-node-api/LICENSE",
    "packages/weak-node-api/NOTICE.md",
    "packages/weak-node-api/THIRD-PARTY-NOTICES.md",
    "src/napi/adapter/primjs_weak_node_api_installer.h",
    "src/napi/adapter/weak_napi_host_injector.cc",
    "src/napi/adapter/weak_node_api_host.h",
]


def run_command(command, cwd=None):
    command = "set -e\n" + command
    print(f"run command in {cwd or ROOT_DIR}: {command}")
    subprocess.run(["bash", "-c", command], cwd=cwd or ROOT_DIR, check=True, text=True)


def ensure_exists(path: Path):
    if not path.exists():
        raise FileNotFoundError(f"Required path does not exist: {path}")


def copy_tree(src_root: Path, dst_root: Path):
    ensure_exists(src_root)
    shutil.copytree(src_root, dst_root, dirs_exist_ok=True)


def copy_file(src: Path, dst: Path):
    ensure_exists(src)
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dst)


def stage_publish_tree(stage_dir: Path):
    if stage_dir.exists():
      shutil.rmtree(stage_dir)
    stage_dir.mkdir(parents=True, exist_ok=True)

    for rel_dir in COPY_DIRS:
        src = ROOT_DIR / rel_dir
        dst = stage_dir / rel_dir
        copy_tree(src, dst)

    for rel_file in COPY_FILES:
        src = ROOT_DIR / rel_file
        dst = stage_dir / rel_file
        copy_file(src, dst)


def create_zip_from_stage(stage_dir: Path, zip_path: Path):
    if zip_path.exists():
        zip_path.unlink()
    zip_path.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(zip_path, "w", compression=zipfile.ZIP_DEFLATED) as zf:
        for path in sorted(stage_dir.rglob("*")):
            if path.is_file():
                zf.write(path, path.relative_to(stage_dir))


def sha256sum(path: Path) -> str:
    h = hashlib.sha256()
    with path.open("rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def generate_podspec_json(version: str, release_tag: str, release_repo: str, zip_name: str, zip_sha256: str):
    if not PODSPEC_PATH.exists():
        raise FileNotFoundError(f"Podspec not found: {PODSPEC_PATH}")

    DIST_DIR.mkdir(parents=True, exist_ok=True)
    run_command(
        f"POD_VERSION={version} bundle exec pod ipc spec {PODSPEC_PATH} > {PODSPEC_JSON_PATH}",
        cwd=ROOT_DIR,
    )

    with PODSPEC_JSON_PATH.open("r", encoding="utf-8") as f:
        content = json.load(f)

    if content.get("version") != version:
        raise RuntimeError(
            f"Podspec version mismatch: expected {version}, got {content.get('version')}"
        )

    release_url = f"https://github.com/{release_repo}/releases/download/{release_tag}/{zip_name}"
    content["source"] = {"http": release_url, "sha256": zip_sha256}

    with PODSPEC_JSON_PATH.open("w", encoding="utf-8") as f:
        json.dump(content, f, indent=2)
        f.write("\n")


def prepare_source(version: str, release_tag: str, release_repo: str):
    print("Preparing LynxWeakNodeAPI CocoaPods source package")
    stage_dir = DIST_DIR / "stage"
    zip_name = f"{POD_NAME}-{version}.zip"
    zip_path = DIST_DIR / zip_name

    stage_publish_tree(stage_dir)
    create_zip_from_stage(stage_dir, zip_path)
    generate_podspec_json(
        version=version,
        release_tag=release_tag,
        release_repo=release_repo,
        zip_name=zip_name,
        zip_sha256=sha256sum(zip_path),
    )
    print(f"Created zip: {zip_path}")
    print(f"Created podspec json: {PODSPEC_JSON_PATH}")


def publish_podspec():
    if not PODSPEC_JSON_PATH.exists():
        raise FileNotFoundError(f"Missing generated podspec json: {PODSPEC_JSON_PATH}")

    run_command("bundle exec pod repo add-cdn trunk https://cdn.cocoapods.org/ || true", cwd=ROOT_DIR)
    run_command(
        f"COCOAPODS_TRUNK_TOKEN=$COCOAPODS_TRUNK_TOKEN bundle exec pod trunk push {PODSPEC_JSON_PATH} "
        "--verbose --skip-import-validation --allow-warnings --skip-tests",
        cwd=ROOT_DIR,
    )


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--prepare-source", action="store_true")
    parser.add_argument("--publish", action="store_true")
    parser.add_argument("--version", type=str)
    parser.add_argument("--tag", type=str)
    parser.add_argument("--release-repo", type=str, default="lynx-family/primjs")
    args = parser.parse_args()

    if args.prepare_source:
        if not args.version or not args.tag:
            raise ValueError("--prepare-source requires --version and --tag")
        prepare_source(args.version, args.tag, args.release_repo)
    elif args.publish:
        publish_podspec()
    else:
        raise ValueError("Please specify --prepare-source or --publish")


if __name__ == "__main__":
    main()
