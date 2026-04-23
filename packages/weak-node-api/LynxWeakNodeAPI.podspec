require "json"

Pod::Spec.new do |s|
  pkg = JSON.parse(File.read(File.join(__dir__, "package.json")))

  s.name = "LynxWeakNodeAPI"
  s.version = ENV["POD_VERSION"] || pkg["version"]
  s.summary = "Weak-linked Node-API bridge for Lynx on iOS."
  s.description = <<-DESC
LynxWeakNodeAPI packages the generated weak-node-api sources and headers for
iOS. PrimJS consumes this pod from its adapter subspec instead of embedding the
generated weak-node-api sources directly in PrimJS.podspec.
  DESC
  s.homepage = pkg["homepage"]
  s.license = { :type => "Apache-2.0", :file => "LICENSE" }
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
    "packages/weak-node-api/shim/*.{h,hpp}"
  ]

  s.public_header_files = [
    "packages/weak-node-api/generated/*.{h,hpp}",
    "packages/weak-node-api/headers/*.{h,hpp}",
    "packages/weak-node-api/shim/*.{h,hpp}"
  ]
end
