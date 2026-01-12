#!/usr/bin/env node
/*
Copyright (c) 2025 The Lynx Authors.
Licensed under the Apache License Version 2.0 that can be found in the LICENSE file in the root directory of this source tree.
Derived work includes upstream generated headers/content; see NOTICE.md for details.
*/
import fs from "node:fs";
import path from "node:path";
import cp from "node:child_process";

const root = process.cwd();
const includeDst = path.join(root, "include");
const defsHeaderDir = path.join(root, "defs_header");
const generatedDst = path.join(root, "generated");

let cachedUpstreamMeta = null;

// Resolve the installed upstream npm package `weak-node-api` and expose its
// package root + version for attribution.
function resolveWeakNodeApiMeta() {
  if (cachedUpstreamMeta) return cachedUpstreamMeta;

  try {
    const res = cp.spawnSync(
      process.execPath,
      ["-p", "require.resolve('weak-node-api')"],
      { cwd: root, encoding: "utf-8" },
    );
    if (res.status !== 0) {
      throw new Error(res.stderr || `node -p require.resolve(...) exited with ${res.status}`);
    }
    const entryPath = res.stdout.trim();
    if (!entryPath) {
      throw new Error("require.resolve('weak-node-api') returned empty output.");
    }

    let upstreamRoot = path.dirname(entryPath);
    // Walk up to find the package.json that defines the weak-node-api package.
    while (!fs.existsSync(path.join(upstreamRoot, "package.json"))) {
      const parent = path.dirname(upstreamRoot);
      if (parent === upstreamRoot) break;
      upstreamRoot = parent;
    }

    const pkgJsonPath = path.join(upstreamRoot, "package.json");
    if (!fs.existsSync(pkgJsonPath)) {
      throw new Error(`Could not locate package.json for weak-node-api near ${entryPath}`);
    }

    const raw = fs.readFileSync(pkgJsonPath, "utf-8");
    const pkg = JSON.parse(raw);
    const version = typeof pkg.version === "string" && pkg.version.length > 0 ? pkg.version : "<unknown>";

    cachedUpstreamMeta = { upstreamRoot, upstreamVersion: version };
    return cachedUpstreamMeta;
  } catch (e) {
    throw new Error(
      [
        "Failed to resolve the upstream npm package 'weak-node-api'.",
        "Make sure it is installed as a dependency/devDependency of this package:",
        "  npm install --save-dev weak-node-api",
        "",
        `Underlying error: ${e && e.message ? e.message : e}`,
      ].join("\n"),
    );
  }
}

function getUpstreamVersion() {
  try {
    const { upstreamVersion } = resolveWeakNodeApiMeta();
    return upstreamVersion || "<unknown>";
  } catch {
    return "<unknown>";
  }
}

function copyDirRecursive(srcDir, dstDir) {
  const stat = fs.statSync(srcDir);
  if (!stat.isDirectory()) {
    throw new Error(`Expected directory: ${srcDir}`);
  }
  fs.mkdirSync(dstDir, { recursive: true });
  const entries = fs.readdirSync(srcDir, { withFileTypes: true });
  for (const entry of entries) {
    const srcPath = path.join(srcDir, entry.name);
    const dstPath = path.join(dstDir, entry.name);
    if (entry.isDirectory()) {
      copyDirRecursive(srcPath, dstPath);
    } else if (entry.isFile()) {
      fs.copyFileSync(srcPath, dstPath);
    }
  }
}

function resolveNodeAddonApiInclude() {
  let base;
  try {
    // eslint-disable-next-line no-eval
    const hasResolve = eval("import.meta.resolve");
    if (hasResolve) {
      // @ts-ignore
      base = import.meta.resolve("node-addon-api");
    }
  } catch {}
  if (!base) {
    try {
      const res = cp.spawnSync(process.execPath, ["-p", "require.resolve('node-addon-api')"], {
        encoding: "utf-8",
      });
      if (res.status === 0) base = res.stdout.trim();
    } catch {}
  }
  if (base) {
    let dir = path.dirname(base);
    // Walk up to find the package.json that defines the node-addon-api package root
    while (!fs.existsSync(path.join(dir, "package.json"))) {
      const parent = path.dirname(dir);
      if (parent === dir) break;
      dir = parent;
    }
    const candidates = [dir, path.join(dir, "include")];
    for (const c of candidates) {
      const ok = ["napi.h", "napi-inl.h", "napi-inl.deprecated.h"].every((f) =>
        fs.existsSync(path.join(c, f)),
      );
      if (ok) return c;
    }
    throw new Error(`Failed to locate node-addon-api headers near ${dir}. Install node-addon-api first.`);
  }
  throw new Error("Cannot resolve node-addon-api. Please `npm i node-addon-api` before running prepare:headers.");
}

function copyNodeAddonApiHeaders(srcDir) {
  fs.mkdirSync(includeDst, { recursive: true });
  const files = ["napi.h", "napi-inl.h", "napi-inl.deprecated.h"];
  for (const f of files) {
    const from = path.join(srcDir, f);
    if (!fs.existsSync(from)) {
      throw new Error(`Missing header from node-addon-api: ${from}`);
    }
    const to = path.join(includeDst, f);
    fs.copyFileSync(from, to);
  }
  // also copy our defs headers
  for (const f of ["weak_napi_defines.h", "weak_napi_undefs.h"]) {
    const from = path.join(defsHeaderDir, f);
    const to = path.join(includeDst, f);
    if (!fs.existsSync(from)) {
      throw new Error(`Missing macro header: ${from}`);
    }
    fs.copyFileSync(from, to);
  }
}

function processFile(filePath) {
  const base = path.basename(filePath);
  // Skip macro headers and napi-inl* files themselves
  if (
    base === "weak_napi_defines.h" ||
    base === "weak_napi_undefs.h" ||
    base === "napi-inl.h" ||
    base === "napi-inl.deprecated.h"
  ) {
    return;
  }

  let content = fs.readFileSync(filePath, "utf-8");
  // Normalize: #include <node_api.h> -> #include "../include/node_api.h"
  content = content.replace(/#\s*include\s*<node_api.h>/g, '#include "../include/node_api.h"');

  // Comment style and insertion for generated/* files attribution
  const isInGenerated = filePath.startsWith(generatedDst);
  const version = getUpstreamVersion();
  const attributionHeader = [
    "/*",
    `Derived from weak-node-api@${version} (npm package maintained in callstackincubator/react-native-node-api).`,
    "Local modifications include symbol renaming via weak_napi_defines.h/weak_napi_undefs.h and include/path adjustments.",
    "See NOTICE.md for upstream attribution and licensing details.",
    "*/",
    "",
  ].join("\n");

  const defineLine = isInGenerated
    ? '#include "../include/weak_napi_defines.h"'
    : '#include "weak_napi_defines.h"';
  const undefLine = isInGenerated
    ? '#include "../include/weak_napi_undefs.h"'
    : '#include "weak_napi_undefs.h"';

  const lines = content.split("\n");
  const newLines = [...lines];

  // Insert attribution header at the very top for generated files (idempotent)
  if (isInGenerated && !content.includes("Derived from weak-node-api@")) {
    newLines.unshift(attributionHeader);
  }

  if (base === "napi.h") {
    // Find the line that contains "#include \"napi-inl.h\"" and insert the define after the previous #include
    let napiInlIndex = -1;
    for (let i = 0; i < newLines.length; i++) {
      if (newLines[i].trim() === '#include "napi-inl.h"') {
        napiInlIndex = i;
        break;
      }
    }
    if (napiInlIndex >= 0) {
      let prevIncludeIndex = -1;
      for (let i = napiInlIndex - 1; i >= 0; i--) {
        if (newLines[i].trim().startsWith("#include")) {
          prevIncludeIndex = i;
          break;
        }
      }
      if (prevIncludeIndex >= 0) {
        newLines.splice(prevIncludeIndex + 1, 0, defineLine);
      } else {
        newLines.unshift(defineLine);
      }
    } else {
      // If napi-inl.h is not found, insert the define at the top of the file
      newLines.unshift(defineLine);
    }
  } else {
    // Other files: insert after the last #include; if there is no #include, insert at the top of the file
    let lastIncludeIndex = -1;
    for (let i = newLines.length - 1; i >= 0; i--) {
      if (newLines[i].trim().startsWith("#include")) {
        lastIncludeIndex = i;
        break;
      }
    }
    if (lastIncludeIndex >= 0) {
      newLines.splice(lastIncludeIndex + 1, 0, defineLine);
    } else {
      newLines.unshift(defineLine);
    }
  }

  // Append the undefs at the end of the file and ensure it ends with a trailing newline
  if (newLines.length > 0 && newLines[newLines.length - 1].trim() !== "") {
    newLines.push("");
  }
  newLines.push(undefLine);
  newLines.push("");

  const newContent = newLines.join("\n");
  fs.writeFileSync(filePath, newContent, "utf-8");
}

function processDirectoryRecursive(dir) {
  if (!fs.existsSync(dir)) return;
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  for (const entry of entries) {
    const p = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      processDirectoryRecursive(p);
    } else if (
      entry.isFile() &&
      (p.endsWith(".h") || p.endsWith(".hpp") || p.endsWith(".c") || p.endsWith(".cpp"))
    ) {
      processFile(p);
    }
  }
}

function main() {
  const { upstreamRoot, upstreamVersion } = resolveWeakNodeApiMeta();
  const upstreamIncludePreferred = path.join(upstreamRoot, "include");
  const upstreamGeneratedPreferred = path.join(upstreamRoot, "generated");

  // Assert that the upstream include directory exists so that the upstream npm package contents are available
  if (!fs.existsSync(upstreamIncludePreferred) || !fs.statSync(upstreamIncludePreferred).isDirectory()) {
    throw new Error(
      [
        `Upstream headers not found at: ${upstreamIncludePreferred}`,
        "The npm package 'weak-node-api' is used as the upstream source.",
        "Ensure it is installed and that the selected version publishes an 'include/' directory.",
        `Currently resolved upstream version: weak-node-api@${upstreamVersion}`,
      ].join("\n"),
    );
  }

  // (1) Copy the entire upstream include/ directory into the local include/ directory
  console.log(`Copying upstream include from ${upstreamIncludePreferred} to ${includeDst}...`);
  copyDirRecursive(upstreamIncludePreferred, includeDst);

  // (1.5) If the upstream generated/ directory exists, recursively copy it into the local generated/ directory
  if (fs.existsSync(upstreamGeneratedPreferred) && fs.statSync(upstreamGeneratedPreferred).isDirectory()) {
    console.log(`Copying upstream generated from ${upstreamGeneratedPreferred} to ${generatedDst}...`);
    copyDirRecursive(upstreamGeneratedPreferred, generatedDst);
  } else {
    console.log(`Upstream generated directory not found, skipping: ${upstreamGeneratedPreferred}`);
  }

  // (2) Resolve the node-addon-api package, copy three header files (overwriting existing ones), and then copy the macro headers
  const nodeAddonApiInclude = resolveNodeAddonApiInclude();
  console.log(`Merging node-addon-api headers from ${nodeAddonApiInclude} into ${includeDst}...`);
  copyNodeAddonApiHeaders(nodeAddonApiInclude);

  // (3) Apply directory-wide insertion logic to all .h/.hpp/.c/.cpp files under include/ and generated/ (if present)
  console.log(`Applying weak macro insertion across ${includeDst}...`);
  processDirectoryRecursive(includeDst);
  if (fs.existsSync(generatedDst) && fs.statSync(generatedDst).isDirectory()) {
    console.log(`Applying weak macro insertion across ${generatedDst}...`);
    processDirectoryRecursive(generatedDst);
  }

  console.log(`Prepared headers under ${includeDst} (upstream weak-node-api@${upstreamVersion}).`);
}

main();
