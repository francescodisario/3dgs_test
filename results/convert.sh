#!/bin/bash

# Cambia la cartella di destinazione se necessario
for input_file in ./*.mp4; do
  output_file="${input_file%.mp4}-encoded.mp4"
  ffmpeg -i "$input_file" -vcodec libx264 -acodec aac "$output_file"
done