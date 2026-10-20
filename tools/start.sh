#!/usr/bin/env bash
set -euo pipefail
cd /workspace/jogo
export HOME=/workspace/tooling/godot-home
exec godot --path . "$@"
