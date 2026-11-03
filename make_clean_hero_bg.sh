#!/bin/bash
set -e
cd /app/applet/public/assets/aistudio

# 1. Start from file_00000000489081f6b8c856527cd893c1_193c4f40.png (1708x921)
# 2. Patch the top right button (x: 1300 to 1708, y: 15 to 125) using the vertical slice from y=140
convert file_00000000489081f6b8c856527cd893c1_193c4f40.png -crop 408x1+1300+140 +repage -scale 408x110\! top_slice.png
convert file_00000000489081f6b8c856527cd893c1_193c4f40.png top_slice.png -geometry +1300+15 -composite bg_step1.png

# 3. Create a clean left overlay in solid dark navy #030b1e
# From x=0 to 860 is solid #030b1e, then from 860 to 1060 it smoothly fades to transparent!
convert -size 860x921 xc:"#030b1e" left_solid.png
convert -size 220x921 gradient:"#030b1e-none" left_fade.png

# Combine left solid and left fade into a 1080x921 overlay
convert -size 1708x921 xc:none \
  left_solid.png -geometry +0+0 -composite \
  left_fade.png -geometry +860+0 -composite left_navy_scrim.png

# Composite the navy scrim over bg_step1
convert bg_step1.png left_navy_scrim.png -composite hero_bg_flawless.jpg

# Also create a dedicated crop of JUST the man and boiler for mobile / cards (e.g. 780x780 or 800x900)
# This crop starts at x=920, y=80, w=788, h=840 (no text anywhere!)
convert bg_step1.png -crop 788x840+920+80 +repage technicien_portrait.jpg

echo "Both images created successfully"
