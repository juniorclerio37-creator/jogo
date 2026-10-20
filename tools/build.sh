#!/usr/bin/env bash
set -euo pipefail
cd /workspace/jogo
export HOME=/workspace/tooling/godot-home
mkdir -p build
./tools/check.sh
godot --headless --path . --export-debug Android build/brasil-quest-debug.apk
/workspace/tooling/android-sdk/build-tools/36.0.0/apksigner verify --verbose build/brasil-quest-debug.apk
godot --headless --path . --export-debug Linux build/brasil-quest.x86_64
sha256sum build/brasil-quest-debug.apk build/brasil-quest.x86_64 build/brasil-quest.pck > build/SHA256SUMS
