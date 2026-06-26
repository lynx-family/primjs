#!/usr/bin/env node
import fs from 'fs'
import path from 'path'
import { spawnSync } from 'child_process'

function fail(message) {
  console.error(message)
  process.exit(1)
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'))
}

function ensureDir(dir) {
  fs.mkdirSync(dir, { recursive: true })
}

function copyIfExists(from, to) {
  if (fs.existsSync(from)) {
    ensureDir(path.dirname(to))
    fs.copyFileSync(from, to)
  }
}

function run(command, args, cwd) {
  const result = spawnSync(command, args, {
    cwd,
    stdio: 'inherit'
  })
  if (result.status !== 0) {
    fail(`Command failed: ${command} ${args.join(' ')}`)
  }
}

function createPodspec({ outDir, name, version, summary, homepage, license, author }) {
  const podspec = `Pod::Spec.new do |s|
  s.name = "${name}"
  s.version = "${version}"
  s.summary = "${summary}"
  s.description = <<-DESC
${summary}
  DESC
  s.homepage = "${homepage}"
  s.license = { :type => "${license}" }
  s.author = { "${author}" => "author@example.com" }
  s.source = { :path => "." }
  s.ios.deployment_target = "12.0"
  s.osx.deployment_target = "10.15"
  s.vendored_frameworks = "${name}.xcframework"
  s.public_header_files = "include/*.h"
  s.preserve_paths = "include/*.h"
  s.dependency "LynxWeakNodeAPI/core"
end
`
  fs.writeFileSync(path.join(outDir, `${name}.podspec`), podspec)
}

function main() {
  const projectRoot = process.cwd()
  const pkg = readJson(path.join(projectRoot, 'package.json'))
  const name = pkg.name || path.basename(projectRoot)
  const version = pkg.version || '0.1.0'
  const summary = pkg.description || `${name} N-API addon`
  const homepage = pkg.homepage || 'https://example.com'
  const license = pkg.license || 'Apache-2.0'
  const author = pkg.author || name

  const candidates = [
    {
      library: path.join(projectRoot, 'dist/ios/iphoneos', `lib${name}.a`),
      headers: path.join(projectRoot, 'dist/ios/iphoneos/include')
    },
    {
      library: path.join(projectRoot, 'dist/ios/iphonesimulator', `lib${name}.a`),
      headers: path.join(projectRoot, 'dist/ios/iphonesimulator/include')
    },
    {
      library: path.join(projectRoot, 'dist/macos/macosx', `lib${name}.a`),
      headers: path.join(projectRoot, 'dist/macos/macosx/include')
    }
  ].filter(candidate => fs.existsSync(candidate.library) && fs.existsSync(candidate.headers))

  if (candidates.length === 0) {
    fail('No Apple static libraries found under dist/. Build iOS/macOS first.')
  }

  const outDir = path.join(projectRoot, 'dist/apple')
  const xcframeworkPath = path.join(outDir, `${name}.xcframework`)
  ensureDir(outDir)
  fs.rmSync(xcframeworkPath, { recursive: true, force: true })

  const args = ['-create-xcframework']
  for (const candidate of candidates) {
    args.push('-library', candidate.library, '-headers', candidate.headers)
  }
  args.push('-output', xcframeworkPath)
  run('xcodebuild', args, projectRoot)

  copyIfExists(path.join(projectRoot, 'src/addon_use.h'), path.join(outDir, 'include/addon_use.h'))

  createPodspec({
    outDir,
    name,
    version,
    summary,
    homepage,
    license,
    author
  })

  console.log(`Created Apple package artifacts in ${outDir}`)
}

main()
