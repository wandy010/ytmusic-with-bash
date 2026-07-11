#!/usr/bin/env bash
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "$SCRIPT_DIR/lib.sh"

TMPFILE=""
cleanup() { rm -f "$TMPFILE" "${TMPFILE}_clean"; }
trap cleanup EXIT

INPUT_RESULT="/tmp/ytmusic_input"
RESULT_FILE="/tmp/ytmusic_selected_id"

get_query() {
    INPUT_SCRIPT="$CACHE/input_sel.sh"
    export INPUT_RESULT

    cat > "$INPUT_SCRIPT" << 'INPUTEOF'
#!/usr/bin/env bash
clear
echo -e "\e[1;35m"
echo "  ╔════════════════════════════════╗"
echo "  ║      󰎆  YT Music Terminal      ║"
echo "  ╠════════════════════════════════╣"
echo -e "  ║  \e[0m   Type name of the song    \e[1;35m  ║"
echo -e "  ╚════════════════════════════════╝\e[0m"
echo ""
echo -ne "\e[1;35m  ╰─\e[0m \e[38;5;183m> \e[0m"
read -r QUERY
echo "$QUERY" > "$INPUT_RESULT"
INPUTEOF
    chmod +x "$INPUT_SCRIPT"

    bspc rule -a Alacritty_Temporal_query -o state=floating center=true rectangle=340x180+0+0 --one-shot
    alacritty --class Alacritty_Temporal_query -e "$INPUT_SCRIPT" &
    ALAC_PID=$!

    while kill -0 "$ALAC_PID" 2>/dev/null; do sleep 0.1; done

    QUERY=$(cat "$INPUT_RESULT" 2>/dev/null | xargs)
    rm -f "$INPUT_RESULT" "$INPUT_SCRIPT"

    [[ -z "$QUERY" ]] && exit 0
}

search() {
    JSON_BODY=$(jq -nc --arg query "$QUERY" '{
        context: { client: { clientName: "WEB_REMIX", clientVersion: "1.20260204.03.00" } },
        query: $query
    }')

    RESPONSE=$(curl -s -X POST \
        "https://music.youtube.com/youtubei/v1/search?prettyPrint=false" \
        -H "Content-Type: application/json" \
        -d "$JSON_BODY")

    TMPFILE=$(mktemp /tmp/ytmusic.XXXXXX)

    echo "$RESPONSE" | jq -r '
        [.. | .musicCardShelfRenderer? | select(. != null) |
            (.buttons[0].buttonRenderer.command.watchEndpoint.videoId // .onTap.watchEndpoint.videoId) as $id |
            select($id != null) |
            "\(.title.runs[0].text) │ \(
                [(.subtitle.runs // .header.musicCardShelfHeaderBasicRenderer.title.runs)[].text
                | select(. != "Video" and . != "Song" and . != "Canción" and . != " • "
                    and (test("^[0-9,]+ views$") | not)
                    and (test("^[0-9]+:[0-9]+$") | not))
                ][0] // "Artista"
            ) │ \($id)"],
        [.. | .musicResponsiveListItemRenderer? | select(.playlistItemData.videoId != null) |
            "\(.flexColumns[0].musicResponsiveListItemFlexColumnRenderer.text.runs[0].text) │ \(
                [.flexColumns[1].musicResponsiveListItemFlexColumnRenderer.text.runs[].text
                | select(. != "Video" and . != "Song" and . != "Canción" and . != " • "
                    and (test("^[0-9,]+ views$") | not)
                    and (test("^[0-9]+:[0-9]+$") | not))
                ][0] // "Artista"
            ) │ \(.playlistItemData.videoId)"]
        | .[]' 2>/dev/null > "$TMPFILE"

    grep -E '^[^│]+ │ [^│]+ │ [a-zA-Z0-9_-]+$' "$TMPFILE" | \
        awk -F' │ ' '!seen[$3]++' | head -n 5 > "${TMPFILE}_clean"
    mv "${TMPFILE}_clean" "$TMPFILE"

    [[ ! -s "$TMPFILE" ]] && {
        notify-send -u critical "ytmusic" "Sin resultados para: $QUERY"
        exit 0
    }
}

select_song() {
    FZF_SCRIPT="$CACHE/fzf_sel.sh"
    TMPFILE_FZF=$(mktemp /tmp/ytmusic_fzf.XXXXXX)

    awk -F' │ ' '{
        n = split($1, a, " ")
        title = ""
        for(i=1; i<=6 && i<=n; i++) title = title (i>1 ? " " : "") a[i]
        if(n > 6) title = title "…"
        n = split($2, a, " ")
        artist = ""
        for(i=1; i<=6 && i<=n; i++) artist = artist (i>1 ? " " : "") a[i]
        if(n > 6) artist = artist "…"
        print title " — " artist " │ " $3
    }' "$TMPFILE" > "$TMPFILE_FZF"

    export TMPFILE_FZF RESULT_FILE

    cat > "$FZF_SCRIPT" << 'FZFEOF'
#!/usr/bin/env bash
cat "$TMPFILE_FZF" | fzf \
    --prompt="🎵  " --delimiter="│" --with-nth=1 \
    --height=100% --layout=reverse --border=rounded --info=inline \
    --color='bg:#1e1e2e,fg:#cdd6f4,hl:#f5c2e7,fg+:#f5c2e7,bg+:#313244,info:#89b4fa,prompt:#f5c2e7,header:#89b4fa,border:#45475a' \
    | awk -F' │ ' '{gsub(/^[[:space:]]+|[[:space:]]+$/, "", $NF); print $NF}' > "$RESULT_FILE"
FZFEOF
    chmod +x "$FZF_SCRIPT"

    bspc rule -a Alacritty_Temporal_fzf -o state=floating center=true rectangle=800x300+0+0 --one-shot
    alacritty --class Alacritty_Temporal_fzf -e "$FZF_SCRIPT" &
    ALAC_PID=$!

    while kill -0 "$ALAC_PID" 2>/dev/null; do sleep 0.1; done

    SELECTED_ID=$(cat "$RESULT_FILE" 2>/dev/null)
    rm -f "$RESULT_FILE" "$TMPFILE_FZF" "$FZF_SCRIPT"

    [[ -z "$SELECTED_ID" ]] && exit 0

    LINE=$(grep -n -F "$SELECTED_ID" "$TMPFILE" | head -1 | cut -d: -f1)
    [[ -z "$LINE" ]] && exit 0

    ID=$(sed -n "${LINE}p" "$TMPFILE" | awk -F' │ ' '{print $3}')
    URL="https://music.youtube.com/watch?v=${ID}&list=RD${ID}"
    TITLE=$(sed -n "${LINE}p" "$TMPFILE" | awk -F' │ ' '{print $1}')
    ARTIST=$(sed -n "${LINE}p" "$TMPFILE" | awk -F' │ ' '{print $2}')
}

play() {
    pkill -f "mpv.*--no-video" 2>/dev/null || true
    rm -f "$SOCKET"
    sleep 0.3

    notify-send -u low "󰎆 Reproduciendo" "$TITLE — $ARTIST"

    yt-dlp --flat-playlist --playlist-end 50 \
        --print "https://music.youtube.com/watch?v=%(id)s" \
        "$URL" 2>/dev/null > "$PLAYLIST"

    bspc rule -a Alacritty_Temporal desktop='^1' --one-shot
    alacritty --class Alacritty_Temporal -e mpv --no-video --volume=40 \
        --input-ipc-server="$SOCKET" \
        --playlist="$PLAYLIST" &
    disown
}

main() {
    get_query
    search
    select_song
    play
}

main "$@"
