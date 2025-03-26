#!/bin/bash

# Controlla se ffmpeg è installato
if ! command -v ffmpeg &> /dev/null; then
    echo "ffmpeg non è installato. Per favore installalo prima di procedere."
    exit 1
fi

# Crea directory di output se non esiste
mkdir -p output_gifs

# Itera su tutti i file video nella directory corrente
for video in *.mp4 *.avi *.mov *.mkv; do
    # Salta se non ci sono file che corrispondono al pattern
    [ -f "$video" ] || continue

    # Ottieni il nome del file senza estensione
    filename=$(basename -- "$video")
    filename_noext="${filename%.*}"

    echo "Conversione di $video in GIF..."

    # Converti il video in GIF
    ffmpeg -i "$video" \
           -vf "fps=15,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" \
           -loop 0 \
           "output_gifs/${filename_noext}.gif"

    echo "Completato: output_gifs/${filename_noext}.gif"
done

echo "Conversione completata!"
