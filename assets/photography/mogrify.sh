#!/bin/bash

### smartresize function from: https://www.smashingmagazine.com/2015/06/efficient-image-resizing-with-imagemagick/

INPUTFILE=$1
SIZE=$2
OUTPUT_DIR=$3
#smartresize $1 $2 $3

smartresize() {
   mogrify -path $OUTPUT_DIR -filter Triangle -define filter:support=2 -thumbnail $SIZE -unsharp 0.25x0.08+8.3+0.045 -dither None -posterize 136 -quality 82 -define jpeg:fancy-upsampling=off -define png:compression-filter=5 -define png:compression-level=9 -define png:compression-strategy=1 -define png:exclude-chunk=all -interlace none -colorspace sRGB $INPUTFILE
}

smartresize

OUTFILE=($(echo $INPUTFILE | cut -f2 -d '/')) #get the filename without the path
echo $OUTFILE
NAME=($(echo $OUTFILE | cut -f1 -d '.'))
SUFFIX=($(echo $OUTFILE | cut -f2 -d '.'))
echo $NAME $SUFFIX
mv $OUTPUT_DIR/$OUTFILE $OUTPUT_DIR/$NAME-$SIZE.$SUFFIX
