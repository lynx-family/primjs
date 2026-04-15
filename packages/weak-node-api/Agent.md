Overview
- Provides weak-linked Node-API headers and a scaffolding CLI for Lynx scenarios
- Employs weak symbols plus optional renaming to avoid conflicts with other N-API providers in the same process
- User-facing package consumption requires Node.js 18+

Quick Start
- Recommended: npm exec -y -p @lynx-js/weak-node-api create-weak-node-api
- Alternative (npx): npx -y -p @lynx-js/weak-node-api create-weak-node-api
- Local project flow: npm init -y && npm i -D @lynx-js/weak-node-api && npm exec create-weak-node-api
- Choose a platform (Android/iOS/HarmonyOS/macOS) to generate a project with CMakeLists.txt, a sample addon, and dependency fetch scripts

Headers and Include Paths
- Consumers include headers/ from this package

Symbol Renaming
- Controlled by the compile-time macro USE_WEAK_SUFFIX_NAPI
- Enabled by default on HarmonyOS; optional on other platforms
- In sources: include weak_napi_defines.h after the last include; include weak_napi_undefs.h at the end of the file

Platform linking strategy
- Android/HarmonyOS: link the cloud-fetched libnapi_adapter.so
- iOS/macOS: dynamic symbol lookup (e.g. -Wl,-undefined,dynamic_lookup)

Maintainer hints
- Refresh headers: npm install && npm run prepare:headers
- Validate scaffolding locally: node scripts/create.mjs
- On release, update both package.json and templates/skeleton/package.json so scaffolded projects use the intended package version
- Run npm run bootstrap locally before submitting the release commit so publish can stay as a pure npm publish step
