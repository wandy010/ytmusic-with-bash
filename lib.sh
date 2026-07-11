#!/usr/bin/env bash

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/ytmusic"
SOCKET="/tmp/mpv-socket"
PLAYLIST="$CACHE/playlist.txt"

mkdir -p "$CACHE"

mpv_send() {
    echo "$1" | socat - "$SOCKET" 2>/dev/null || true
}
