require "json"

Pod::Spec.new do |s|
  pkg = JSON.parse(File.read(File.join(__dir__, "package.json")))

  s.name = "LynxWeakNodeAPI"
  s.version = ENV["POD_VERSION"] || pkg["version"]
  s.summary = "Weak-linked Node-API bridge for Lynx on iOS."
  s.description = <<-DESC
LynxWeakNodeAPI packages the generated weak-node-api sources, headers, and
optional PrimJS bridge sources for iOS.
  DESC
  s.homepage = pkg["homepage"]
  s.license = "Apache-2.0"
  s.author = { "Lynx Authors" => "lynx.authors@users.noreply.github.com" }
  s.source = {
    :git => pkg["repository"]["url"],
    :tag => "weak-node-api-v#{s.version}"
  }
  s.platform = :ios, "9.0"
  s.header_mappings_dir = "packages/weak-node-api"

  s.source_files = [
    "packages/weak-node-api/generated/*.{h,hpp,cc,cpp}",
    "packages/weak-node-api/headers/*.{h,hpp}",
    "packages/weak-node-api/shim/*.{h,hpp}",
    "packages/weak-node-api/defs_header/*.{h,hpp}"
  ]

  s.public_header_files = [
    "packages/weak-node-api/generated/*.{h,hpp}",
    "packages/weak-node-api/headers/*.{h,hpp}",
    "packages/weak-node-api/shim/*.{h,hpp}",
    "packages/weak-node-api/defs_header/*.{h,hpp}"
  ]

  s.subspec "primjs_bridge" do |sp|
    sp.source_files = [
      "src/napi/adapter/weak_napi_host_injector.cc",
      "src/napi/adapter/weak_node_api_host.h",
    ]
    sp.private_header_files = "src/napi/adapter/weak_node_api_host.h"
    sp.dependency "PrimJS/napi/adapter"
  end
end
