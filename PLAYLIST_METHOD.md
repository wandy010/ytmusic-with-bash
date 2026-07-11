# Cómo se crea la playlist del Radio Mix de YouTube Music

El problema original era que `mpv --input-ipc-server` con una URL directa tipo
`https://music.youtube.com/watch?v=ID&list=RDID` no cargaba el mix como playlist
(playlist-count = 1), por lo que `playlist-next` y `playlist-prev` daban error.

## Solución: extraer la playlist real con yt-dlp

Se usa `yt-dlp` con `--flat-playlist` para obtener los IDs de las siguientes
canciones del radio mix sin descargar nada, solo listando:

```bash
yt-dlp --flat-playlist --playlist-end 50 \
  --print "https://music.youtube.com/watch?v=%(id)s" \
  "https://music.youtube.com/watch?v=${ID}&list=RD${ID}" 2>/dev/null \
  > "$CACHE/playlist.txt"
```

### Explicación de flags:
- `--flat-playlist`: No descarga metadata, solo lista los elementos
- `--playlist-end 50`: Limita a 50 canciones
- `--print "https://music.youtube.com/watch?v=%(id)s"`: Imprime la URL completa
  de cada canción en el formato que mpv entiende
- `2>/dev/null`: Silencia warnings de yt-dlp

### Luego se pasa a mpv como archivo playlist:
```bash
mpv --no-video --volume=40 \
  --input-ipc-server=/tmp/mpv-socket \
  --playlist="$CACHE/playlist.txt"
```

Con `--playlist`, mpv reconoce el archivo como lista de reproducción real,
incrementa `playlist-count` y permite `playlist-next` / `playlist-prev` / `cycle pause`
a través del socket IPC.

### Código completo en bar_busq.sh (sección 5):
```bash
# ─── 5. Reproducir (Radio Mix como playlist real) ───
pkill -f "mpv.*--no-video.*music\.youtube" 2>/dev/null || true
rm -f /tmp/mpv-socket
sleep 0.2

notify-send -u low "󰎆 Reproduciendo" "$TITLE — $ARTIST"

PLAY="$CACHE/play.sh"
cat > "$PLAY" << PLAYSHELL
#!/usr/bin/env bash
clear

echo "  ╔══════════════════════════════════════════╗"
echo "  ║         󰎆  YT Music Player              ║"
echo "  ╠══════════════════════════════════════════╣"
echo "  ║  $TITLE"
echo "  ║  $ARTIST"
echo "  ╠══════════════════════════════════════════╣"
echo "  ║  Channel: $ARTIST"
echo "  ║  Music URL: https://music.youtube.com/watch?v=${ID}&list=RD${ID}"
echo "  ╚══════════════════════════════════════════╝"
echo ""
echo "  [q] Quit  [Space] Pause  [n] Next  [p] Prev"
echo ""

yt-dlp --flat-playlist --playlist-end 50 \
  --print "https://music.youtube.com/watch?v=%(id)s" \
  "https://music.youtube.com/watch?v=${ID}&list=RD${ID}" 2>/dev/null > "$CACHE/playlist.txt"

mpv --no-video --volume=40 \
  --input-ipc-server=/tmp/mpv-socket \
  --title="󰎆 $TITLE — $ARTIST" \
  --playlist="$CACHE/playlist.txt"

rm -f /tmp/mpv-socket "$CACHE/playlist.txt"
PLAYSHELL
chmod +x "$PLAY"
```

### Archivos de control via socket:
- `yt-music-toggle.sh` → `{ "command": ["cycle", "pause"] }`
- `yt-music-next.sh` → `{ "command": ["playlist-next"] }`
- `yt-music-prev.sh` → `{ "command": ["playlist-prev"] }`
- `yt-music-stop.sh` → `{ "command": ["stop"] }`
- `yt-music-title.sh` → `{ "command": ["get_property", "media-title"] }`
- `yt-music-status.sh` → `{ "command": ["get_property", "pause"] }`