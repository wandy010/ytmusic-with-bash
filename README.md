# ytconsole

Reproductor de YouTube Music desde la terminal.

Busca canciones, selecciona con fzf y reproduce con mpv sin video.
Integración con bspwm, polybar y controles por teclado.

## Requisitos

- bash
- [mpv](https://mpv.io)
- [yt-dlp](https://github.com/yt-dlp/yt-dlp)
- [jq](https://jqlang.github.io/jq/)
- [fzf](https://github.com/junegunn/fzf)
- [socat](http://www.dest-unreach.org/socat/)
- curl
- Alacritty
- bspwm

## Instalación

```
git clone https://github.com/wandy010/ytmusic-with-bash.git
cd ytmusic-with-bash
chmod +x *.sh
```

## Uso

### Buscar y reproducir

```
./bar_busq.sh
```

Escribe el nombre de una canción, selecciona con fzf y empieza a sonar.
Se genera una playlist con canciones relacionadas.

### Controles

| Comando | Acción |
|---|---|
| `./yt-music-next.sh` | Siguiente canción |
| `./yt-music-prev.sh` | Canción anterior |
| `./yt-music-toggle.sh` | Pausar / reanudar |
| `./yt-music-stop.sh` | Detener y limpiar |

### Polybar

Agrega esto a tu polybar config:

```
[module/ytmusic]
type = custom/script
exec = ~/ytmusic-with-bash/yt-music-polybar.sh
interval = 1
```

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
