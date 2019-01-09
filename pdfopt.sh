#!/bin/sh

IN="$1"
OUT=`mktemp`

# jbig2 makes a big difference.
# ect makes a difference, and is faster than pngout
/usr/bin/pdfsizeopt --do-double-check-type1c-output=yes --use-jbig2=yes --use-image-optimizer="ect -9 -strip --mt-deflate %(targetfnq)s" "$IN" "$OUT"

SIZE1=`stat -c"%s" "$IN"`
SIZE2=`stat -c"%s" "$OUT"`
PERC=`bc <<< "scale=2; ($SIZE2 - $SIZE1)/$SIZE1 * 100"`
if [[ $SIZE2 -ge $SIZE1 ]]; then
    echo "Didn't shrink; reverting."
    rm "$OUT"
else
    echo "Saved $PERC %. Original saved as \"$IN.preshrink.pdf\". This operation should be lossless; however, it can sometimes screw with fonts."
    mv "$IN" "$IN.preshrink.pdf"
    mv "$OUT" "$IN"
fi
