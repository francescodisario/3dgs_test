#!/bin/bash

# === Input video files ===
videos=(
#   dc_ete_zoom1.mp4
#   shs_ete_zoom1.mp4
#   sgs_ete_zoom1.mp4
#   voronoi_ete_zoom1.mp4

  # mlp_reflective.mp4
  # shs_reflective.mp4
  # sgs_reflective.mp4
  # voronoi_reflective.mp4

  gt.mp4
  shs.mp4
  sgs8_mlp.mp4
  voronoi8_mlp.mp4
)

# === Custom labels ===
labels=(
#   "Diffuse-only"
#   "Spherical Harmonics"
#   "Spherical Gaussians"
#   "Spherical Voronoi"
    "GT"
    "SHS"
    #"Spherical Betas"
    "SGS"
    "SV"
)

# === Check ===
if [ ${#videos[@]} -ne 4 ] || [ ${#labels[@]} -ne 4 ]; then
  echo "❌ Must provide exactly 4 videos and 4 labels."
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

filters+="[l0][l1][l2][l3]xstack=inputs=4:layout=0_0|w0_0|w0+w1_0|w0+w1+w2_0[v]"

# === Final command ===
ffmpeg "${inputs[@]}" -filter_complex "$filters" -map "[v]" -c:v libx264 -crf 17 -preset slow output_compressed.mp4
