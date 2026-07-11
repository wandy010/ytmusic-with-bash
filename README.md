<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>ytconsole</title>
<style>
  body {
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
    max-width: 720px;
    margin: 40px auto;
    padding: 0 20px;
    background: #0d1117;
    color: #c9d1d9;
    line-height: 1.6;
  }
  h1 { color: #58a6ff; border-bottom: 1px solid #21262d; padding-bottom: 8px; }
  h2 { color: #58a6ff; margin-top: 32px; }
  code { background: #161b22; padding: 2px 6px; border-radius: 4px; font-size: 0.9em; }
  pre { background: #161b22; padding: 16px; border-radius: 6px; overflow-x: auto; }
  table { border-collapse: collapse; width: 100%; }
  th, td { border: 1px solid #30363d; padding: 8px 12px; text-align: left; }
  th { background: #21262d; }
  a { color: #58a6ff; }
  hr { border: none; border-top: 1px solid #21262d; margin: 32px 0; }
  ul { padding-left: 20px; }
  blockquote {
    border-left: 4px solid #30363d;
    margin: 0;
    padding-left: 16px;
    color: #8b949e;
  }
</style>
</head>
<body>

<h1>ytconsole</h1>

<p>Reproductor de YouTube Music desde la terminal.</p>

<p>Busca canciones, selecciona con fzf y reproduce con mpv sin video. Integración con bspwm, polybar y controles por teclado.</p>

<h2>Requisitos</h2>

<ul>
  <li>bash</li>
  <li><a href="https://mpv.io">mpv</a></li>
  <li><a href="https://github.com/yt-dlp/yt-dlp">yt-dlp</a></li>
  <li><a href="https://jqlang.github.io/jq/">jq</a></li>
  <li><a href="https://github.com/junegunn/fzf">fzf</a></li>
  <li><a href="http://www.dest-unreach.org/socat/">socat</a></li>
  <li>curl</li>
  <li>Alacritty</li>
  <li>bspwm (para ventanas flotantes centradas)</li>
</ul>

<h2>Instalación</h2>

<pre><code>git clone https://github.com/TU_USUARIO/ytconsole.git
cd ytconsole
chmod +x *.sh</code></pre>

<h2>Uso</h2>

<h3>Buscar y reproducir</h3>

<pre><code>./bar_busq.sh</code></pre>

<p>Escribe el nombre de una canción, selecciona con fzf y empieza a sonar. Se genera una playlist con canciones relacionadas.</p>

<h3>Controles</h3>

<table>
  <tr><th>Comando</th><th>Acción</th></tr>
  <tr><td><code>./yt-music-next.sh</code></td><td>Siguiente canción</td></tr>
  <tr><td><code>./yt-music-prev.sh</code></td><td>Canción anterior</td></tr>
  <tr><td><code>./yt-music-toggle.sh</code></td><td>Pausar / reanudar</td></tr>
  <tr><td><code>./yt-music-stop.sh</code></td><td>Detener y limpiar</td></tr>
</table>

<h3>Polybar</h3>

<p>Agrega esto a tu configuración de polybar:</p>

<pre><code>[module/ytmusic]
type = custom/script
exec = ~/ytconsole/yt-music-polybar.sh
interval = 1</code></pre>

<h3>Obtener links desde lista de nombres</h3>

<p>Crea <code>names.txt</code> con un nombre por línea:</p>

<pre><code>Bohemian Rhapsody
Stairway to Heaven</code></pre>

<p>Luego ejecuta:</p>

<pre><code>./get_links.sh</code></pre>

<p>Genera <code>links.txt</code> con las URLs de YouTube.</p>

<h2>Limitaciones</h2>

<ul>
  <li>Depende de los endpoints internos de YouTube Music (pueden romperse).</li>
  <li>Usa Alacritty como terminal temporal (hardcodeado).</li>
  <li>Las ventanas flotantes usan <code>bspc rule</code> (solo bspwm).</li>
  <li>No tiene cola de reproducción visible ni interfaz gráfica.</li>
  <li>El token interno de YouTube Music no es público ni documentado por Google.</li>
</ul>

<hr>

<p><em>Hecho con bash y café.</em></p>

</body>
</html>
