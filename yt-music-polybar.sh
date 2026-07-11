#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

if [ -S "$SOCKET" ]; then
    paused=$(mpv_send '{"command":["get_property","pause"]}' | jq -r '.data // "false"')
    if [ "$paused" = "true" ]; then
        echo "󰐊"
    else
        echo "󰏤"
    fi
else
    echo ""
fi
