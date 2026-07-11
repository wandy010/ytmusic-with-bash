#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

MAX=40
title=$(mpv_send '{"command":["get_property","media-title"]}' | jq -r '.data // empty')
[[ -z "$title" ]] && exit 0

if [ ${#title} -gt "$MAX" ]; then
    echo "${title:0:$((MAX-1))}…"
else
    echo "$title"
fi
