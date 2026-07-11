#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

mpv_send '{"command":["stop"]}'
sleep 0.2
pkill -f "mpv.*--no-video" 2>/dev/null || true
rm -f "$SOCKET" "$PLAYLIST"
