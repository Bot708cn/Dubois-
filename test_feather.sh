#!/bin/bash
set -e
cd /app/applet/public/assets/aistudio

# Base crop containing the man and boiler (w=828, h=921, x=880, y=0)
convert file_00000000489081f6b8c856527cd893c1_193c4f40.png -crop 828x921+880+0 +repage base_crop.png

# The button in base_crop is at x = 1370 - 880 = 490, y = 25, w = 310, h = 92
# The patch source directly below is at x = 490, y = 125, w = 310, h = 92
convert base_crop.png -crop 310x92+490+125 patch_source.png

# Create a feathered alpha mask for the patch:
convert -size 310x92 xc:black -fill white -draw "rectangle 10,8 300,84" -blur 0x8 patch_mask.png

# Apply mask to patch_source
convert patch_source.png patch_mask.png -alpha off -compose CopyOpacity -composite patch_feathered.png

# Composite feathered patch onto base_crop
convert base_crop.png patch_feathered.png -geometry +490+25 -composite step1.png

# Clean "ct" at top-left (in base_crop, x=0..35, y=35..65):
# Sample the pipe/wall color right next to it at x=45, y=50:
WALL_COL=$(convert step1.png -format "%[pixel:p{45,50}]" info:)
# Feathered patch over "ct"
convert -size 45x40 xc:"$WALL_COL" -blur 0x4 patch_ct.png
convert step1.png patch_ct.png -geometry +0+32 -composite step2.png

# Clean tiny red fringe if any at x=0..15, y=670..750:
convert step2.png -fill "#041530" -draw "rectangle 0,665 15,755" step3.png

# Convert to high-quality JPG
convert step3.png -quality 95 technicien_clean_hd.jpg
echo "HD technician created successfully"
