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
- bspwm (opcional, solo para las ventanas flotantes)

```
sudo pacman -S mpv yt-dlp jq fzf socat curl alacritty
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

### Flujo del proyecto

- **`bar_busq.sh`** → script principal. Abre una ventana para que escribas
  una canción, busca en YouTube Music, te deja elegir una con fzf y la
  reproduce con mpv. Además genera una playlist con canciones relacionadas.
  Los controles (siguiente, anterior, pausa, stop) se manejan con los scripts
  `yt-music-*.sh`.

- **`get_links.sh`** → script secundario. Convierte una lista de nombres
  (`names.txt`, un nombre por línea) a URLs de YouTube y las guarda en
  `links.txt`. Útil si solo quieres recolectar enlaces sin reproducir.

## Limitaciones

- Depende de los endpoints internos de YouTube Music (pueden romperse).
- Usa Alacritty como terminal temporal (hardcodeado).
- Las ventanas flotantes usan `bspc rule` (solo bspwm; si usas otro WM ignora esa parte, todo lo demás funciona igual).
- No tiene cola de reproducción visible ni interfaz gráfica.
- El token de la API de YouTube Music no es público ni documentado por Google.
