# ytconsole

Reproductor de YouTube Music desde la terminal para Arch Linux.

Busca canciones, selecciona con fzf y reproduce con mpv sin video.

## Requisitos

- Arch Linux (o cualquier distro con los paquetes)
- bash
- [mpv](https://mpv.io)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [jq](https://jqlang.github.io/jq/)
- [fzf](https://github.com/junegunn/fzf)
- [socat](http://www.dest-unreach.org/socat/)
- curl
- Alacritty
- bspwm (para ventanas flotantes)

```
sudo pacman -S mpv yt-dlp jq fzf socat curl alacritty bspwm
```

## Instalación

```
git clone https://github.com/wandy010/ytmusic-with-bash.git
cd ytmusic-with-bash
chmod +x *.sh
```

## Uso

### Buscar y reproducir (script principal)

```
./bar_busq.sh
```

Escribe el nombre de una canción, selecciona con fzf y empieza a sonar.
Se genera una playlist con canciones relacionadas.

### Controles (scripts individuales)

| Script | Acción |
|---|---|
| `./yt-music-next.sh` | Siguiente canción |
| `./yt-music-prev.sh` | Canción anterior |
| `./yt-music-toggle.sh` | Pausar / reanudar |
| `./yt-music-stop.sh` | Detener y limpiar |

Puedes asignar estos scripts a keybinds de tu WM o a botones en tu barra
(polybar, waybar, eww, etc).

### Obtener links desde lista de nombres

Crea `names.txt` con un nombre por línea:

```
Bohemian Rhapsody
Stairway to Heaven
```

Luego ejecuta:

```
./get_links.sh
```

Genera `links.txt` con las URLs de YouTube.

## Limitaciones

- Depende de los endpoints internos de YouTube Music (pueden romperse).
- Usa Alacritty como terminal temporal (hardcodeado).
- Las ventanas flotantes usan `bspc rule` (solo bspwm).
- No tiene cola de reproducción visible ni interfaz gráfica.
- El token de la API de YouTube Music no es público ni documentado por Google.
