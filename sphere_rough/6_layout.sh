#!/bin/bash

# === Input video files ===
videos=(
  gt.mp4
  mlp.mp4
  sgs.mp4
  voronoi.mp4
  cube_map.mp4
  sph_mip.mp4     # <- Aggiunto sesto video
)

# === Custom labels ===
labels=(
  "GT"
  "MLP"
  "SGS"
  "SV"
  "CUBE-MAP"
  "SPH-MIP"              # <- Aggiunta sesta etichetta
)

# === Check ===
if [ ${#videos[@]} -ne 6 ] || [ ${#labels[@]} -ne 6 ]; then
  echo "❌ Must provide exactly 6 videos and 6 labels."
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

# Layout for 6 columns and 1 row
filters+="[l0][l1][l2][l3][l4][l5]xstack=inputs=6:layout=0_0|w0_0|w0+w1_0|w0+w1+w2_0|w0+w1+w2+w3_0|w0+w1+w2+w3+w4_0[v]"

# === Final command ===
ffmpeg "${inputs[@]}" -filter_complex "$filters" -map "[v]" -c:v libx264 -crf 17 -preset slow output_compressed.mp4
