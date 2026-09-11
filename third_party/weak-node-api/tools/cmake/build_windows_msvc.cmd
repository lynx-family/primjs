@echo off
setlocal ENABLEDELAYEDEXPANSION

REM Windows build script for WeakNodeAPI (MSVC x64)
REM Requirements:
REM - Visual Studio 17 2022 with C++ toolchain installed
REM - CMake >= 3.25 in PATH
REM Usage:
REM   Double-click or run from a Developer Command Prompt in the package root:
REM   tools\cmake\build_windows_msvc.cmd

set SCRIPT_DIR=%~dp0
pushd "%SCRIPT_DIR%..\.." >nul
set PKG_ROOT=%CD%

set BUILD_DIR=%PKG_ROOT%\build\win\x64
set PREBUILT_DIR=%PKG_ROOT%\prebuilt\win\x64

if not exist "%BUILD_DIR%" mkdir "%BUILD_DIR%"
if not exist "%PREBUILT_DIR%\Debug" mkdir "%PREBUILT_DIR%\Debug"
if not exist "%PREBUILT_DIR%\Release" mkdir "%PREBUILT_DIR%\Release"
if not exist "%PKG_ROOT%\prebuilt\win\include" mkdir "%PKG_ROOT%\prebuilt\win\include"

REM Configure project with Visual Studio 17 2022 (x64)
cmake -S "%PKG_ROOT%" -B "%BUILD_DIR%" -G "Visual Studio 17 2022" -A x64 -DCMAKE_BUILD_TYPE=Release
if errorlevel 1 (
  echo [ERROR] CMake configure failed.
  popd >nul
  exit /b 1
)

REM Build Debug and Release
cmake --build "%BUILD_DIR%" --config Debug
if errorlevel 1 (
  echo [ERROR] Build Debug failed.
  popd >nul
  exit /b 1
)
cmake --build "%BUILD_DIR%" --config Release
if errorlevel 1 (
  echo [ERROR] Build Release failed.
  popd >nul
  exit /b 1
)

REM Copy artifacts to prebuilt directory
for %%C in (Debug Release) do (
  if exist "%BUILD_DIR%\%%C\WeakNodeAPI.dll" copy /Y "%BUILD_DIR%\%%C\WeakNodeAPI.dll" "%PREBUILT_DIR%\%%C\WeakNodeAPI.dll" >nul
  if exist "%BUILD_DIR%\%%C\WeakNodeAPI.lib" copy /Y "%BUILD_DIR%\%%C\WeakNodeAPI.lib" "%PREBUILT_DIR%\%%C\WeakNodeAPI.lib" >nul
)

REM Sync public headers to prebuilt/win/include (optional; reuse include/ otherwise)
xcopy /E /I /Y "%PKG_ROOT%\include" "%PKG_ROOT%\prebuilt\win\include" >nul

popd >nul

echo [OK] Windows build completed. Artifacts:
echo   - %PREBUILT_DIR%\Debug\WeakNodeAPI.dll / .lib
echo   - %PREBUILT_DIR%\Release\WeakNodeAPI.dll / .lib
echo   - %PKG_ROOT%\prebuilt\win\include\**
exit /b 0
