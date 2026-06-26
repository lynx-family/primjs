#!/usr/bin/env node
import fs from 'fs'
import path from 'path'
import { fileURLToPath } from 'url'

function parseArgs(argv) {
  const out = {}
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i]
    if (!arg.startsWith('--')) continue
    const key = arg.slice(2)
    const value = argv[i + 1]
    if (!value || value.startsWith('--')) {
      out[key] = true
    } else {
      out[key] = value
      i += 1
    }
  }
  return out
}

function readJson(file) {
  return JSON.parse(fs.readFileSync(file, 'utf8'))
}

function resolveDefaultRoot() {
  return path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..')
}

const args = parseArgs(process.argv.slice(2))
const pkgRoot = path.resolve(args.root || resolveDefaultRoot())
const manifestPath = path.join(pkgRoot, 'package.json')
const manifest = fs.existsSync(manifestPath) ? readJson(manifestPath) : {}
const packageName = args['package-name'] || process.env.WEAK_NODE_API_PACKAGE_NAME || manifest.name
const packageVersion = args.version || process.env.WEAK_NODE_API_PACKAGE_VERSION || manifest.version

if (!packageName || !packageVersion) {
  throw new Error('Missing package name or version for skeleton dependency sync')
}

const skeletonPackagePath = path.join(pkgRoot, 'templates', 'skeleton', 'package.json')
const skeletonPackage = readJson(skeletonPackagePath)
skeletonPackage.dependencies = {
  [packageName]: packageVersion,
}
fs.writeFileSync(skeletonPackagePath, `${JSON.stringify(skeletonPackage, null, 2)}\n`, 'utf8')
console.log(`[OK] Synced ${path.relative(pkgRoot, skeletonPackagePath)} dependency to ${packageName}@${packageVersion}`)
