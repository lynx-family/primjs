#!/usr/bin/env node
import { fileURLToPath } from 'url'
import path from 'path'
import fs from 'fs'
import readline from 'readline'

function resolvePkgRoot() {
  const p = path.dirname(fileURLToPath(import.meta.url))
  return path.resolve(p, '..')
}

function prompt(q) {
  const rl = readline.createInterface({ input: process.stdin, output: process.stdout })
  return new Promise(res => rl.question(q, ans => { rl.close(); res(ans) }))
}

function ensureDir(p) {
  if (!fs.existsSync(p)) fs.mkdirSync(p, { recursive: true })
}

function copyDir(src, dest) {
  ensureDir(dest)
  for (const e of fs.readdirSync(src, { withFileTypes: true })) {
    const s = path.join(src, e.name)
    const d = path.join(dest, e.name)
    if (e.isDirectory()) copyDir(s, d)
    else fs.copyFileSync(s, d)
  }
}

function writeFile(p, content) {
  ensureDir(path.dirname(p))
  fs.writeFileSync(p, content)
}

function replaceAll(s, map) {
  let out = s
  for (const [k, v] of Object.entries(map)) out = out.split(k).join(v)
  return out
}

async function main() {
  const pkgRoot = resolvePkgRoot()
  const templatesRoot = path.join(pkgRoot, 'templates')
  const projectName = (await prompt('Project name (default: weak-napi-addon): ')).trim() || 'weak-napi-addon'
  const platformInput = (await prompt('Target platform (android/ios/harmony/mac): ')).trim().toLowerCase()
  const valid = ['android', 'ios', 'harmony', 'mac']
  if (!valid.includes(platformInput)) {
    console.error('Invalid platform. Supported: android / ios / harmony / mac')
    process.exit(1)
  }
  const targetDir = path.resolve(process.cwd(), projectName)
  if (fs.existsSync(targetDir) && fs.readdirSync(targetDir).length > 0) {
    console.error(`Target directory exists and is not empty: ${targetDir}`)
    process.exit(1)
  }
  ensureDir(targetDir)
  copyDir(path.join(templatesRoot, 'skeleton'), targetDir)
  const cmakeTpl = fs.readFileSync(path.join(templatesRoot, 'CMakeLists.txt.tpl'), 'utf8')
  const defaultWeak = platformInput === 'harmony' ? 'ON' : 'OFF'
  const cmakeOut = replaceAll(cmakeTpl, {
    '__PROJECT_NAME__': projectName,
    '__PLATFORM__': platformInput,
    '__DEFAULT_USE_WEAK__': defaultWeak
  })
  writeFile(path.join(targetDir, 'CMakeLists.txt'), cmakeOut)
  const pkgJsonPath = path.join(targetDir, 'package.json')
  if (fs.existsSync(pkgJsonPath)) {
    const pkgJson = fs.readFileSync(pkgJsonPath, 'utf8')
    writeFile(pkgJsonPath, replaceAll(pkgJson, { '__PROJECT_NAME__': projectName }))
  }
  const readmeTpl = fs.readFileSync(path.join(templatesRoot, 'README.tpl.md'), 'utf8')
  const readmeOut = replaceAll(readmeTpl, {
    '__PROJECT_NAME__': projectName,
    '__PLATFORM__': platformInput
  })
  writeFile(path.join(targetDir, 'README.md'), readmeOut)

  const agentTplPath = path.join(templatesRoot, 'Agent.tpl.md')
  if (fs.existsSync(agentTplPath)) {
    const agentTpl = fs.readFileSync(agentTplPath, 'utf8')
    const agentOut = replaceAll(agentTpl, {
      '__PROJECT_NAME__': projectName,
      '__PLATFORM__': platformInput
    })
    writeFile(path.join(targetDir, 'Agent.md'), agentOut)
  }
  console.log(`Created: ${targetDir}`)
  console.log('Next steps:')
  console.log('- Implement your N-API logic in src/addon.cc')
  console.log('- Build with CMake and the appropriate toolchain for your platform')
}

main().catch(e => {
  console.error(e)
  process.exit(1)
})
