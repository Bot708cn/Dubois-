#!/bin/bash
set -e
cd /app/applet/public/assets/aistudio

# We have technicien_pur.jpg (748x840)
# Create a 1600x840 canvas filled with #030c1b
convert -size 1600x840 xc:"#030b1e" canvas.png

# Create a smooth left-feather mask for technicien_pur (w=748, h=840)
# The first 120px will fade from 0 to 1 opacity
convert -size 120x840 gradient:black-white left_mask.png
convert -size 628x840 xc:white right_mask.png
convert +append left_mask.png right_mask.png full_feather_mask.png

# Apply feather mask to technicien_pur.jpg
convert technicien_pur.jpg full_feather_mask.png -alpha off -compose CopyOpacity -composite feathered_tech.png

# Place feathered_tech onto canvas at x=852, y=0
convert canvas.png feathered_tech.png -geometry +852+0 -composite hero_bg_desktop.jpg

# Save clean mobile visual image
cp technicien_pur.jpg technicien_mobile.jpg

echo "Desktop and mobile backgrounds generated"
