#!/bin/bash
set -e

cd /app/applet/public/assets/aistudio

# 1. Clean the top-right button area:
# Sample region y=130..220, x=420..760 (w=340, h=90)
convert tech_base.png -crop 340x90+420+130 patch_slice.png

# Composite patch over the button at 420, 25
convert tech_base.png patch_slice.png -geometry +420+25 -composite tech_step1.png

# Slightly soften horizontal seams of the patch (y=24..28 and y=112..118)
# We can apply a subtle blur on the seam box
convert tech_step1.png \( -size 340x10 xc:none -fill "rgba(240,244,248,0.85)" -draw "rectangle 0,0 340,10" -blur 0x3 \) -geometry +420+20 -composite tech_step2.png
convert tech_step2.png \( -size 340x10 xc:none -fill "rgba(240,244,248,0.85)" -draw "rectangle 0,0 340,10" -blur 0x3 \) -geometry +420+112 -composite tech_step3.png

# 2. Cover "ct" at top-left (x=0..30, y=40..85) with dark navy #072346
convert tech_step3.png -fill "#072346" -draw "rectangle 0,40 30,90" tech_step4.png

# 3. Cover red button residue at bottom-left (x=0..40, y=660..760) with navy #03142e
convert tech_step4.png -fill "#03142e" -draw "rectangle 0,660 40,760" tech_step5.png

# 4. Now create a smooth left-to-right fade mask:
# The far left (x=0 to 140) smoothly fades to transparent or solid navy #030b1e
convert tech_step5.png \
  \( -size 140x921 gradient:black-white \) \
  -geometry +0+0 -composite technicien_hero_clean.png

# Let's also create the final JPEG for web
convert tech_step5.png -quality 92 technicien_hero_final.jpg
echo "Done"
