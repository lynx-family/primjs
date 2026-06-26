Overview
- Provides weak-linked Node-API headers and a scaffolding CLI for Lynx scenarios
- Employs weak symbols plus optional renaming to avoid conflicts with other N-API providers in the same process
- User-facing package consumption requires Node.js 18+

Quick Start
- Recommended: npm exec -y --package=@lynx-js/weak-node-api -- create-weak-node-api
- Alternative (npx): npx -y -p @lynx-js/weak-node-api create-weak-node-api
- Local project flow: npm init -y && npm i -D @lynx-js/weak-node-api && npm exec create-weak-node-api
- The scaffolder asks for a project name only, then generates one cross-platform CMake project with Android/iOS/HarmonyOS/macOS branches. Build the desired platform by configuring CMake with the corresponding toolchain/generator. Windows support is coming soon.

Headers and Include Paths
- Consumers include headers/ from this package

Symbol Renaming
- Controlled by the compile-time macro USE_WEAK_SUFFIX_NAPI
- Enabled by default on HarmonyOS and macOS; optional on other platforms
- In sources: include weak_napi_defines.h after the last include; include weak_napi_undefs.h at the end of the file

Addon registration model
- Static loading means the addon is linked into the host process and auto-registers when the image is loaded
- Dynamic loading means the host loads a shared addon and may find the exported Node-API entry point with dlsym/GetProcAddress
- Scaffolded addons emit both paths from one unified registration block; do not reintroduce platform-specific NODE_API_MODULE vs attribute-constructor branches

Platform linking strategy
- Android/HarmonyOS: link the cloud-fetched libnapi_adapter.so
- Windows: coming soon
- iOS/macOS: build static libraries; scaffolded addons use one unified registration block across platforms: auto-register when loaded and export the standard dynamic Node-API C entry points. For Apple static integration, the host includes generated addon_use.h from exactly one .cc/.mm file so `NAPI_USE` retains the auto-registration symbol

Maintainer hints
- Refresh headers: npm install && npm run prepare:headers
- Validate scaffolding locally: node scripts/create.mjs
- On release, the publish flow updates templates/skeleton/package.json automatically so scaffolded projects use the package name and version being released
- Generated outputs under headers/ and generated/ are produced by npm run prepare:headers and are not committed
- The Android/HarmonyOS/iOS GitHub release workflows run npm install and npm run prepare:headers before packaging/publishing
