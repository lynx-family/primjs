# Copyright 2024 The Lynx Authors. All rights reserved.
# Licensed under the Apache License Version 2.0 that can be found in the
# LICENSE file in the root directory of this source tree.
#
# Be sure to run `pod lib lint XElement.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name = "PrimJS"
  s.version = "#{ ENV['POD_VERSION'] }"
  s.summary = "A short description of PrimJS."
  s.homepage = "https://github.com/lynx-family/primjs"

  s.version = '2.11.1-rc.1'

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description = <<-DESC
    TODO: Add long description of the pod here.
    DESC

  s.license = "MIT"
  s.author = { "pandazyp" => "2823543594@qq.com" }

  s.source = { :git => "https://github.com/lynx-family/primjs.git", :tag => s.version.to_s }

  s.compiler_flags = "-Wall", "-Wno-shorten-64-to-32", "-Os"
  s.ios.deployment_target = "9.0"
  s.pod_target_xcconfig = {
    "GCC_PREPROCESSOR_DEFINITIONS" => "OS_IOS=1 JSC_OBJC_API_ENABLED=1 ENABLE_CODECACHE",
    "CLANG_CXX_LANGUAGE_STANDARD" => "gnu++17",
    "HEADER_SEARCH_PATHS" => "\"$(PODS_TARGET_SRCROOT)/src\" \
                              \"${PODS_TARGET_SRCROOT}/src/interpreter\"",
  }
  s.default_subspecs = "quickjs"

  $enable_compatible_mm = 1
  $enable_primjs_snapshot = 1

  s.subspec "quickjs" do |sp|
    if $enable_primjs_snapshot == 1
      sp.pod_target_xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => "ENABLE_PRIMJS_SNAPSHOT ENABLE_COMPATIBLE_MM ENABLE_LEPUSNG LYNX_SIMPLIFY=0" }
    else
      sp.pod_target_xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => "ENABLE_LEPUSNG LYNX_SIMPLIFY=0" }
    end
    sp.header_dir = "quickjs/include"

    sp.public_header_files = ["src/interpreter/quickjs/include/*.h",
                              "src/gc/*.h"]

    sp.source_files = ["src/gc/*.{h,cc}",
                       "src/interpreter/quickjs/**/*.{h,cc}",
                       "src/interpreter/primjs/ios/embedded.S",
                       "src/inspector/interface.h"]
    sp.dependency "PrimJS/log"
  end

  s.subspec "quickjs_debugger" do |sp|
    if $enable_primjs_snapshot == 1
      sp.pod_target_xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => "ENABLE_PRIMJS_SNAPSHOT ENABLE_COMPATIBLE_MM ENABLE_LEPUSNG LYNX_SIMPLIFY=0 ENABLE_QUICKJS_DEBUGGER" }
    else
      sp.pod_target_xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => "ENABLE_LEPUSNG LYNX_SIMPLIFY=0 ENABLE_QUICKJS_DEBUGGER" }
    end
    sp.public_header_files = "src/inspector/*.h"
    sp.header_dir = "devtool/quickjs"
    sp.source_files = ["src/inspector/**/*.{h,cc}",
                       "src/interpreter/primjs/ios/embedded-inspector.S"]
    sp.exclude_files = ["src/inspector/interface.h"]
    sp.dependency "PrimJS/quickjs"
  end

  s.subspec "quickjs_heapprofiler" do |sp|
    sp.dependency "PrimJS/quickjs_debugger"
  end

  s.subspec "quickjs_profiler" do |sp|
    sp.dependency "PrimJS/quickjs_debugger"
  end

  s.subspec "napi" do |sp|
    # if codecache is wanted, uncomment the next line.
    # sp.pod_target_xcconfig   = { "GCC_PREPROCESSOR_DEFINITIONS" => "ENABLE_CODECACHE PROFILE_CODECACHE" }
    sp.pod_target_xcconfig = { "HEADER_SEARCH_PATHS" => "\"${PODS_ROOT}/PrimJS\"" }
    sp.subspec "core" do |ssp|
      ssp.source_files = ["src/napi/*.{h,cc}", "src/napi/common/*.{h,cc}"]
      ssp.public_header_files = ["src/napi/*.h", "src/napi/common/*.h"]
    end

    sp.subspec "env" do |ssp|
      ssp.source_files = "src/napi/env/*.{h,cc}"
      ssp.public_header_files = "src/napi/env/*.h"
      ssp.dependency "PrimJS/napi/core"
    end

    sp.subspec "quickjs" do |ssp|
      ssp.source_files = "src/napi/quickjs/*.{h,cc}"
      ssp.public_header_files = "src/napi/quickjs/napi_env_quickjs.h"
      ssp.dependency "PrimJS/napi/core"
      ssp.dependency "PrimJS/quickjs"
    end
    sp.subspec "jsc" do |ssp|
      # To test wasm with JavaScriptCore on Playground, uncomment the next line.
      # ssp.pod_target_xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => "JSC_OBJC_API_ENABLED=0 NAPI_ENABLE_WASM=1" }
      ssp.pod_target_xcconfig = { "GCC_PREPROCESSOR_DEFINITIONS" => "JSC_OBJC_API_ENABLED=0" }
      ssp.source_files = "src/napi/jsc/*.{h,cc}"
      ssp.public_header_files = "src/napi/jsc/napi_env_jsc.h"
      ssp.dependency "PrimJS/napi/core"
      ssp.dependency "PrimJS/log"
      ssp.dependency "PrimJS/quickjs"
      ssp.frameworks = "JavaScriptCore"
    end
  end

  s.subspec "log" do |sp|
    sp.header_mappings_dir = "src"
    sp.source_files = ["src/basic/log/logging.*",
                       "src/basic/log/primjs_logging.cc",
                       "src/interpreter/quickjs/include/base_export.h"]
  end
end
