#!/usr/bin/env node
import { fileURLToPath } from 'url'
import path from 'path'
import fs from 'fs'
import readline from 'readline'

function resolvePkgRoot() {
  const p = path.dirname(fileURLToPath(import.meta.url))
  return path.resolve(p, '..')
}

function prompt(rl, q) {
  return new Promise(res => rl.question(q, ans => res(ans)))
}

function readPipeAnswers() {
  if (process.stdin.isTTY) return null
  const input = fs.readFileSync(0, 'utf8')
  return input.split(/\r?\n/)
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

function toCppSymbolName(name) {
  let out = name.replace(/[^A-Za-z0-9_]/g, '_')
  if (!out || /^[0-9]/.test(out)) out = `_${out}`
  return out
}

async function main() {
  const pkgRoot = resolvePkgRoot()
  const templatesRoot = path.join(pkgRoot, 'templates')
  const pipeAnswers = readPipeAnswers()
  let projectName
  if (pipeAnswers) {
    projectName = (pipeAnswers.shift() || '').trim() || 'weak-napi-addon'
  } else {
    const rl = readline.createInterface({ input: process.stdin, output: process.stdout })
    try {
      projectName = (await prompt(rl, 'Project name (default: weak-napi-addon): ')).trim() || 'weak-napi-addon'
    } finally {
      rl.close()
    }
  }
  const projectSymbol = toCppSymbolName(projectName)
  const replacements = {
    '__PROJECT_NAME__': projectName,
    '__PROJECT_SYMBOL__': projectSymbol
  }
  const targetDir = path.resolve(process.cwd(), projectName)
  if (fs.existsSync(targetDir) && fs.readdirSync(targetDir).length > 0) {
    console.error(`Target directory exists and is not empty: ${targetDir}`)
    process.exit(1)
  }
  ensureDir(targetDir)
  copyDir(path.join(templatesRoot, 'skeleton'), targetDir)
  const cmakeTpl = fs.readFileSync(path.join(templatesRoot, 'CMakeLists.txt.tpl'), 'utf8')
  const cmakeOut = replaceAll(cmakeTpl, replacements)
  writeFile(path.join(targetDir, 'CMakeLists.txt'), cmakeOut)
  const pkgJsonPath = path.join(targetDir, 'package.json')
  if (fs.existsSync(pkgJsonPath)) {
    const pkgJson = fs.readFileSync(pkgJsonPath, 'utf8')
    writeFile(pkgJsonPath, replaceAll(pkgJson, replacements))
  }
  for (const sourcePath of [
    path.join(targetDir, 'src/addon.cc'),
    path.join(targetDir, 'src/addon.h'),
    path.join(targetDir, 'src/addon_use.h')
  ]) {
    if (fs.existsSync(sourcePath)) {
      writeFile(sourcePath, replaceAll(fs.readFileSync(sourcePath, 'utf8'), replacements))
    }
  }
  const readmeTpl = fs.readFileSync(path.join(templatesRoot, 'README.tpl.md'), 'utf8')
  const readmeOut = replaceAll(readmeTpl, replacements)
  writeFile(path.join(targetDir, 'README.md'), readmeOut)

  const agentTplPath = path.join(templatesRoot, 'Agent.tpl.md')
  if (fs.existsSync(agentTplPath)) {
    const agentTpl = fs.readFileSync(agentTplPath, 'utf8')
    const agentOut = replaceAll(agentTpl, replacements)
    writeFile(path.join(targetDir, 'Agent.md'), agentOut)
  }
  console.log(`Created: ${targetDir}`)
  console.log('Next steps:')
  console.log('- Implement your N-API logic in src/addon.cc')
  console.log('- Run npm install')
  console.log('- Build the desired platform with CMake and the appropriate toolchain; see README.md for commands')
}

main().catch(e => {
  console.error(e)
  process.exit(1)
})
