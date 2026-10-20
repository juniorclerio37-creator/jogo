#!/usr/bin/env bash
set -euo pipefail
cd /workspace/jogo
export HOME=/workspace/tooling/godot-home
mkdir -p "$HOME"
godot --version
godot --headless --path . --editor --import --quit
# Keep test saves separate from the actual player's passport.
HOME=/tmp/brasilquest-test-home godot --headless --path . --script tests/run.gd
