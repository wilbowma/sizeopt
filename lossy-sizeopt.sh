#!/bin/sh

# screen < ebook < print
QUALITY=${QUALITY-ebook}

IN="$1"
OUT=`mktemp`
JOBS=${JOBS-2}

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
    mv "$IN" "$IN.preshrink.pdf"
    mv "$OUT" "$IN"
    echo "Saved $PERC %. Original saved as \"$IN.preshrink.pdf\". Try manually spot-checking before removing."
fi
