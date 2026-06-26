#!/usr/bin/env node
import fs from 'fs'
import path from 'path'
import https from 'https'
import { spawn } from 'child_process'

function resolveScriptDir() {
  return path.dirname(new URL(import.meta.url).pathname)
}

function loadArtifactSources() {
  const scriptDir = resolveScriptDir()
  const file = path.join(scriptDir, 'artifact-sources.json')
  if (!fs.existsSync(file)) {
    throw new Error(`Missing artifact source config: ${file}`)
  }
  return JSON.parse(fs.readFileSync(file, 'utf8'))
}

function parseArgs() {
  const args = process.argv.slice(2)
  const out = {}
  for (let i = 0; i < args.length; i++) {
    const k = args[i]
    const v = args[i + 1]
    if (k === '--platform') out.platform = v
    if (k === '--out') out.out = v
  }
  return out
}

function download(url, dest) {
  return new Promise((resolve, reject) => {
    if (fs.existsSync(dest) && fs.statSync(dest).size > 0) return resolve()
    const file = fs.createWriteStream(dest)
    https.get(url, res => {
      if (res.statusCode && res.statusCode >= 300 && res.statusCode < 400 && res.headers.location) {
        file.close()
        fs.unlinkSync(dest)
        return resolve(download(res.headers.location, dest))
      }
      res.pipe(file)
      file.on('finish', () => file.close(resolve))
      file.on('error', reject)
    }).on('error', reject)
  })
}

function unzipSingle(archive, innerPath, dest) {
  return new Promise((resolve, reject) => {
    const p = spawn('unzip', ['-p', archive, innerPath])
    const w = fs.createWriteStream(dest)
    p.stdout.pipe(w)
    p.on('error', reject)
    p.on('close', code => code === 0 ? resolve() : reject(new Error('unzip failed')))
  })
}

function tarExtractSingle(archive, innerPath, dest, extraArgs = []) {
  return new Promise((resolve, reject) => {
    const p = spawn('tar', [...extraArgs, '-xOf', archive, innerPath])
    const w = fs.createWriteStream(dest)
    p.stdout.pipe(w)
    p.on('error', reject)
    p.on('close', code => code === 0 ? resolve() : reject(new Error('tar extract failed')))
  })
}

async function extractSingle({ archive, innerPaths, dest }) {
  let lastErr = null
  for (const innerPath of innerPaths) {
    // Try ZIP-style extraction first (AAR is a ZIP; some HARs may also be ZIP).
    try {
      await unzipSingle(archive, innerPath, dest)
      return
    } catch (e) {
      lastErr = e
      try { if (fs.existsSync(dest)) fs.unlinkSync(dest) } catch {}
    }

    // Try TAR-style extraction (HAR is commonly a tar archive, often with a "package/" prefix).
    try {
      await tarExtractSingle(archive, innerPath, dest)
      return
    } catch (e) {
      lastErr = e
      try { if (fs.existsSync(dest)) fs.unlinkSync(dest) } catch {}
    }

    // Some environments require explicit gzip flag.
    try {
      await tarExtractSingle(archive, innerPath, dest, ['-z'])
      return
    } catch (e) {
      lastErr = e
      try { if (fs.existsSync(dest)) fs.unlinkSync(dest) } catch {}
    }
  }
  const tried = innerPaths.map(p => `- ${p}`).join('\n')
  throw new Error(`Failed to extract requested file from archive.\nTried paths:\n${tried}\nLast error: ${lastErr?.message || lastErr}`)
}

async function main() {
  const { platform, out } = parseArgs()
  if (!platform || !out) {
    console.error('--platform and --out are required')
    process.exit(1)
  }
  const sources = loadArtifactSources()
  fs.mkdirSync(out, { recursive: true })
  if (platform === 'android') {
    const url = sources.android?.packageUrl
    const inner = sources.android?.libraryPath
    if (!url || !inner) {
      throw new Error('Missing android.packageUrl or android.libraryPath in artifact-sources.json')
    }
    const archive = path.join(out, 'android-package.aar')
    if (!fs.existsSync(path.join(out, 'libnapi_adapter.so'))) {
      await download(url, archive)
      const dest = path.join(out, 'libnapi_adapter.so')
      await unzipSingle(archive, inner, dest)
    }
  } else if (platform === 'harmony') {
    const url = sources.harmony?.packageUrl
    const innerPaths = sources.harmony?.libraryPaths
    if (!url || !Array.isArray(innerPaths) || innerPaths.length === 0) {
      throw new Error('Missing harmony.packageUrl or harmony.libraryPaths in artifact-sources.json')
    }
    const archive = path.join(out, 'harmony-package.har')
    if (!fs.existsSync(path.join(out, 'libnapi_adapter.so'))) {
      await download(url, archive)
      const dest = path.join(out, 'libnapi_adapter.so')
      await extractSingle({
        archive,
        dest,
        innerPaths
      })
    }
  } else if (platform === 'win') {
    const url = sources.win?.packageUrl
    const dllPath = sources.win?.dllPath || sources.win?.libraryPath
    const importLibraryPath = sources.win?.importLibraryPath
    if (!url || !dllPath || !importLibraryPath) {
      throw new Error('Missing win.packageUrl, win.dllPath/libraryPath, or win.importLibraryPath in artifact-sources.json')
    }
    const archive = path.join(out, 'windows-package.zip')
    const dllDest = path.join(out, 'lynx.dll')
    const importLibraryDest = path.join(out, 'lynx.dll.lib')
    if (!fs.existsSync(dllDest) || !fs.existsSync(importLibraryDest)) {
      await download(url, archive)
      if (!fs.existsSync(dllDest)) {
        await unzipSingle(archive, dllPath, dllDest)
      }
      if (!fs.existsSync(importLibraryDest)) {
        await unzipSingle(archive, importLibraryPath, importLibraryDest)
      }
    }
  } else {
    console.log('iOS/macOS: no dynamic library needs to be downloaded')
  }
}

main().catch(e => {
  console.error(e)
  process.exit(1)
})
