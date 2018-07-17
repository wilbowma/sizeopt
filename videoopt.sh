#!/bin/sh

IN="$1"
OUT=`mktemp`
# configure this if you want worse, but faster, compression
PRESET=veryslow

EXTENSION="${IN##*.}"

ffmpeg -i "$IN" -c:v libx265 -preset $PRESET -crf 34 -c:a copy "$OUT.mkv"

SIZE1=`stat -c"%s" "$IN"`
SIZE2=`stat -c"%s" "$OUT"`
PERC=`bc <<< "scale=2; ($SIZE2 - $SIZE1)/$SIZE1 * 100"`
if [[ $SIZE2 -ge $SIZE1 ]]; then
    echo "Inexplicably, didn't shrink."
    echo "Output in $OUT for inspection."
else
    echo "$IN $PERC %; renaming"
    mv "$IN" "$IN.preshrink.$EXTENSION"
    mv "$OUT" $(echo "$IN" | sed s/$EXTENSION/mkv/)
fi
