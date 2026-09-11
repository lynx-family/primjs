Param(
  [switch]$ReleaseOnly
)

# Windows PowerShell build script for WeakNodeAPI (MSVC x64)
# Requirements:
# - Visual Studio 17 2022 with C++ toolchain
# - CMake >= 3.25 in PATH
# Usage:
#   From the package root:
#     pwsh -File tools/cmake/build_windows_msvc.ps1

$ErrorActionPreference = 'Stop'

$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Join-Path $ScriptDir '..\..')
$PkgRoot = Get-Location
$BuildDir = Join-Path $PkgRoot 'build/win/x64'
$PrebuiltDir = Join-Path $PkgRoot 'prebuilt/win/x64'
$HeadersOut = Join-Path $PkgRoot 'prebuilt/win/include'

New-Item -ItemType Directory -Force -Path $BuildDir | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $PrebuiltDir 'Debug') | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $PrebuiltDir 'Release') | Out-Null
New-Item -ItemType Directory -Force -Path $HeadersOut | Out-Null

# Configure
cmake -S $PkgRoot -B $BuildDir -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release

# Build
if (-not $ReleaseOnly) {
  cmake --build $BuildDir --config Debug
}
cmake --build $BuildDir --config Release

# Copy artifacts
$Configs = @('Debug','Release')
foreach ($cfg in $Configs) {
  $dll = Join-Path $BuildDir "$cfg/WeakNodeAPI.dll"
  $lib = Join-Path $BuildDir "$cfg/WeakNodeAPI.lib"
  if (Test-Path $dll) { Copy-Item -Force $dll (Join-Path $PrebuiltDir "$cfg/WeakNodeAPI.dll") }
  if (Test-Path $lib) { Copy-Item -Force $lib (Join-Path $PrebuiltDir "$cfg/WeakNodeAPI.lib") }
}

# Sync headers
Copy-Item -Recurse -Force (Join-Path $PkgRoot 'include') $HeadersOut

Write-Host "[OK] Windows build completed. Artifacts:"
Write-Host "  - $PrebuiltDir/Debug/WeakNodeAPI.dll / .lib"
Write-Host "  - $PrebuiltDir/Release/WeakNodeAPI.dll / .lib"
Write-Host "  - $HeadersOut/**"
