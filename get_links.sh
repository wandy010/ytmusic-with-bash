#!/bin/bash

input="names.txt"
output="links.txt"

[[ ! -f "$input" ]] && { echo "Error: $input no existe"; exit 1; }
[[ ! -r "$input" ]] && { echo "Error: $input no es legible"; exit 1; }

# Vaciar archivo de salida
> "$output"

while IFS= read -r line; do
    # Limpiar espacios extras
    query=$(echo "$line" | xargs)

    # Saltar líneas vacías
    [[ -z "$query" ]] && continue

    echo "🔎 Buscando: $query"

    # Buscar el primer resultado y sacar solo el ID
    video_id=$(yt-dlp "ytsearch1:${query}" --get-id 2>/dev/null | head -n 1)

    if [[ -n "$video_id" ]]; then
        url="https://www.youtube.com/watch?v=${video_id}"
        echo "$url" >> "$output"
        echo "✔ Guardado: $url"
    else
        echo "✘ No se encontró: $query"
    fi
done < "$input"
