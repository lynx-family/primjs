# Copyright (c) 2025 The Lynx Authors.
# Licensed under the Apache License Version 2.0 that can be found in the LICENSE file in the root directory of this source tree.
# Derived work includes upstream generated headers/content; see NOTICE.md for details.

param()

$ErrorActionPreference = 'Stop'

function Write-Info {
  param([string]$Message)
  Write-Host "[cmake] $Message"
}

function Write-Warn {
  param([string]$Message)
  Write-Host "[cmake][WARN] $Message"
}

function Fail {
  param(
    [string]$Message,
    [int]$ExitCode = 1
  )
  Write-Host "[cmake][ERROR] $Message" -ForegroundColor Red
  exit $ExitCode
}

# Resolve OSS root directory based on script location (two levels up from tools/cmake).
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$rootDir = Split-Path -Parent (Split-Path -Parent $scriptDir)
if (-not (Test-Path $rootDir)) {
  Fail "Failed to resolve OSS root directory from script location."
}

Write-Info "Resolved OSS root: $rootDir"

# Pre-check required tools: cmake and npm must be available on PATH.
if (-not (Get-Command cmake -ErrorAction SilentlyContinue)) {
  Fail "CMake not found on PATH. Please install CMake 3.24+ and ensure 'cmake' is available."
}

if (Get-Command node -ErrorAction SilentlyContinue) {
  Write-Info "Node.js found: $(node -v)"
} else {
  Fail "node not found on PATH. Please install Node.js."
}

if (-not (Get-Command npm -ErrorAction SilentlyContinue)) {
  Fail "npm not found on PATH. Please install Node.js (>=22) and ensure 'npm' is available."
}

# This script builds both the default and weak_suffix variants of the
# WeakNodeAPI DLL in a single run. Headers enable weak suffix remapping by
# default, so the default variant explicitly passes USE_WEAK_SUFFIX_NAPI=OFF.

# Run header preparation step from OSS root.
Write-Info "Running 'npm run prepare:headers'..."
Push-Location $rootDir
try {
  Write-Info "Installing dependencies..."
  & npm install
  if ($LASTEXITCODE -ne 0) {
    Fail "'npm install' failed with exit code $LASTEXITCODE."
  }

  & npm run prepare:headers
  if ($LASTEXITCODE -ne 0) {
    Fail "'npm run prepare:headers' failed with exit code $LASTEXITCODE. See logs above for details."
  }
} finally {
  Pop-Location
}

# Configure common CMake settings for MSVC x64 using Visual Studio 2022 generator.
$generator = 'Visual Studio 17 2022'
$buildDir = Join-Path $rootDir 'build/win_x64'
if (-not (Test-Path $buildDir)) {
  New-Item -ItemType Directory -Path $buildDir -Force | Out-Null
}

# Build both Debug and Release configurations for each variant.
$buildConfigs = @('Debug', 'Release')

function Find-Artifact {
  param(
    [string]$Config,
    [string]$Extension
  )

  # Preferred output directory, as configured in CMakeLists.txt.
  $primaryDir = Join-Path $rootDir "build/win/x64/$Config"
  $primaryPath = Join-Path $primaryDir "WeakNodeAPI$Extension"
  if (Test-Path $primaryPath) {
    return $primaryPath
  }

  # Fallback: typical Visual Studio layout under the build directory.
  $fallbackDir = Join-Path $buildDir $Config
  $fallbackPath = Join-Path $fallbackDir "WeakNodeAPI$Extension"
  if (Test-Path $fallbackPath) {
    return $fallbackPath
  }

  # Last resort: search recursively under build/win_x64.
  $pattern = "WeakNodeAPI$Extension"
  $found = Get-ChildItem -Path $buildDir -Filter $pattern -Recurse -ErrorAction SilentlyContinue | Select-Object -First 1
  if ($found) {
    return $found.FullName
  }

  return $null
}

# Define the two variants we always build: default and weak_suffix.
$variants = @(
  @{ Name = 'default';     UseWeakSuffix = $false; PrebuiltBaseDir = (Join-Path $rootDir 'prebuilt/win/x64') },
  @{ Name = 'weak_suffix'; UseWeakSuffix = $true;  PrebuiltBaseDir = (Join-Path $rootDir 'prebuilt/win/weak_suffix/x64') }
)

foreach ($variant in $variants) {
  $name = $variant.Name
  $useWeakSuffix = [bool]$variant.UseWeakSuffix
  $prebuiltBaseDir = $variant.PrebuiltBaseDir

  if ($useWeakSuffix) {
    Write-Info "===== Building Windows weak_suffix variant (USE_WEAK_SUFFIX_NAPI=ON) ====="
  } else {
    Write-Info "===== Building Windows default variant (USE_WEAK_SUFFIX_NAPI=OFF) ====="
  }

  $configureArgs = @(
    '-S', $rootDir,
    '-B', $buildDir,
    '-G', $generator,
    '-A', 'x64'
  )
  $useWeakSuffixCMakeValue = if ($useWeakSuffix) { 'ON' } else { 'OFF' }
  $configureArgs += "-DUSE_WEAK_SUFFIX_NAPI=$useWeakSuffixCMakeValue"

  Write-Info "Configuring CMake project for generator '$generator' (x64, variant=$name)..."
  Push-Location $rootDir
  try {
    & cmake @configureArgs
    if ($LASTEXITCODE -ne 0) {
      Fail "CMake configuration failed for variant '$name' with exit code $LASTEXITCODE. Ensure Visual Studio 2022 (with 'Desktop development with C++') and CMake 3.24+ are installed."
    }
  } finally {
    Pop-Location
  }

  foreach ($config in $buildConfigs) {
    Write-Info "Building $config configuration (variant=$name)..."
    & cmake '--build' $buildDir '--config' $config '--' '/m'
    if ($LASTEXITCODE -ne 0) {
      Fail "Build failed for configuration $config (variant=$name) with exit code $LASTEXITCODE."
    }
  }

  foreach ($config in $buildConfigs) {
    $dllPath = Find-Artifact -Config $config -Extension '.dll'
    if (-not $dllPath) {
      Fail "Failed to locate WeakNodeAPI.dll for configuration $config under '$buildDir' (variant=$name)."
    }

    # Import library (.lib) is optional; try to locate it as well.
    $libPath = Find-Artifact -Config $config -Extension '.lib'

    $distDir = Join-Path $prebuiltBaseDir $config
    if (Test-Path $distDir) {
      Remove-Item -Path $distDir -Recurse -Force
    }
    New-Item -ItemType Directory -Path $distDir -Force | Out-Null

    $dllTarget = Join-Path $distDir 'WeakNodeAPI.dll'
    Write-Info "Packaging '$dllPath' to '$dllTarget'"
    Copy-Item -Path $dllPath -Destination $dllTarget -Force

    if ($libPath) {
      $libTarget = Join-Path $distDir 'WeakNodeAPI.lib'
      Write-Info "Packaging import library '$libPath' to '$libTarget'"
      Copy-Item -Path $libPath -Destination $libTarget -Force
    } else {
      Write-Warn "Import library WeakNodeAPI.lib not found for configuration $config (variant=$name); skipping .lib packaging."
    }

    # Export file (.exp) is useful for linking; try to locate it.
    $expPath = Find-Artifact -Config $config -Extension '.exp'
    if ($expPath) {
      $expTarget = Join-Path $distDir 'WeakNodeAPI.exp'
      Write-Info "Packaging export file '$expPath' to '$expTarget'"
      Copy-Item -Path $expPath -Destination $expTarget -Force
    }

    # PDB file (.pdb) is useful for debugging; try to locate it.
    $pdbPath = Find-Artifact -Config $config -Extension '.pdb'
    if ($pdbPath) {
      $pdbTarget = Join-Path $distDir 'WeakNodeAPI.pdb'
      Write-Info "Packaging pdb file '$pdbPath' to '$pdbTarget'"
      Copy-Item -Path $pdbPath -Destination $pdbTarget -Force
    }

    Write-Info "$config configuration done: '$dllTarget' (variant=$name)"
  }
}

Write-Info 'All Windows configurations built successfully!'
Write-Info ("- Default Debug:   {0}" -f (Join-Path $rootDir 'prebuilt/win/x64/Debug/WeakNodeAPI.dll'))
Write-Info ("- Default Release: {0}" -f (Join-Path $rootDir 'prebuilt/win/x64/Release/WeakNodeAPI.dll'))
Write-Info ("- Weak Debug:      {0}" -f (Join-Path $rootDir 'prebuilt/win/weak_suffix/x64/Debug/WeakNodeAPI.dll'))
Write-Info ("- Weak Release:    {0}" -f (Join-Path $rootDir 'prebuilt/win/weak_suffix/x64/Release/WeakNodeAPI.dll'))

exit 0
