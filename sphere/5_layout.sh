#!/bin/bash

# === Input video files ===
videos=(
  gt.mp4
  mlp_rd.mp4
  shs.mp4
  sgs8_mlp.mp4
  voronoi8_mlp.mp4
)

# === Custom labels ===
labels=(
  "GT"
  "MLP"
  "SHS"
  "SGS"
  "SV"
)

# === Check ===
if [ ${#videos[@]} -ne 5 ] || [ ${#labels[@]} -ne 5 ]; then
  echo "❌ Must provide exactly 5 videos and 5 labels."
  exit 1
fi

# === Build input and filter string ===
inputs=()
filters=""
for i in "${!videos[@]}"; do
  inputs+=("-i" "${videos[$i]}")
  filters+="[$i:v]drawtext=text='${labels[$i]}':fontcolor=white:fontsize=30:box=1:boxcolor=black@0.5:"
  filters+="boxborderw=5:x=(w-text_w)/2:y=10[l$i];"
done

# Layout for 5 columns and 1 row (horizontal stack)
filters+="[l0][l1][l2][l3][l4]xstack=inputs=5:layout=0_0|w0_0|w0+w1_0|w0+w1+w2_0|w0+w1+w2+w3_0[v]"

# === Final command ===
ffmpeg "${inputs[@]}" -filter_complex "$filters" -map "[v]" -c:v libx264 -crf 17 -preset slow output_compressed.mp4
