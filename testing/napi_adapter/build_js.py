#!/usr/bin/env python3
# Copyright 2024-2026 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.
import os
import subprocess
import glob

# Get the current directory
current_dir = os.path.dirname(os.path.abspath(__file__))

# Define the js_native_api directory path
js_native_api_dir = os.path.join(current_dir, "js_native_api")

# Find all subdirectories in js_native_api (excluding js_native_api itself)
subdirs = [d for d in os.listdir(js_native_api_dir) if os.path.isdir(os.path.join(js_native_api_dir, d))]

for subdir in subdirs:
    # Get the basename of the directory
    dir_basename = subdir
    
    # Define the full path to the subdirectory
    subdir_path = os.path.join(js_native_api_dir, subdir)
    
    # Create the build/export directory
    export_dir = os.path.join(subdir_path, "build", "export")
    if not os.path.exists(export_dir):
        os.makedirs(export_dir)
    
    # Create the index.js file
    index_js_path = os.path.join(export_dir, "index.js")
    with open(index_js_path, "w") as f:
        f.write('module.exports = global.napiLoaderForTest.load("%s");\n' % dir_basename)
    
    # Find all test*.js files in the subdirectory
    test_files = glob.glob(os.path.join(subdir_path, "test*.js"))
    
    # Execute browserify command
    browserify_cmd = [
        "browserify",
    ] + test_files + [
        "--require",
        "./build/export/",
        "-o",
        "build/test_bundler.js"
    ]
    
    # Run browserify in the subdirectory
    print("Running browserify for %s..." % subdir)
    
    # Use subprocess.Popen which is available in all Python versions
    process = subprocess.Popen(
        browserify_cmd,
        cwd=subdir_path,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True
    )
    
    # Get output and wait for process to complete
    stdout, stderr = process.communicate()
    returncode = process.returncode
    
    # Check if browserify command was successful
    if returncode != 0:
        print("Error running browserify for %s:" % subdir)
        print("Stdout: %s" % stdout)
        print("Stderr: %s" % stderr)
        exit(1)
    
    print("Successfully processed %s" % subdir)

print("All directories processed successfully!")