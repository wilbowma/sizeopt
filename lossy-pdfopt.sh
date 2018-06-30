#!/bin/sh

# screen < ebook < print
QUALITY=${QUALITY-ebook}

IN="$1"
OUT=`mktemp`

shift

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 \
   -dNOPAUSE -dQUIET -dBATCH -dDetectDuplicateImages \
   -dSubsetFonts=true -dEmbedAllFonts=true -dPDFFITPAGE -dColorConversionStrategy=/LeaveColorUnchanged \
   -dCompressFonts=true -dPDFSETTINGS=/$QUALITY $@ -sOutputFile="$OUT" "$IN"

SIZE1=`stat -c"%s" "$IN"`
SIZE2=`stat -c"%s" "$OUT"`
PERC=`bc <<< "scale=2; ($SIZE2 - $SIZE1)/$SIZE1 * 100"`
if [[ $SIZE2 -ge $SIZE1 ]]; then
    echo "Didn't shrink; reverting."
    rm "$OUT"
else
    echo "Saved $PERC %. Original saved as \"$IN.prelossy.pdf\". Try manually spot-checking before removing, and consider running sizeopt.sh after."
    mv "$IN" "$IN.prelossy.pdf"
    mv "$OUT" "$IN"
fi
