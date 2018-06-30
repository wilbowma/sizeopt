#!/bin/sh


# screen < ebook < print
QUALITY=${QUALITY-ebook}

OUT="$1"
INPUT="$1.preshrink.pdf"
JOBS=${JOBS-2}

if [ ! -e "$INPUT" ]; then
   cp "$OUT" "$INPUT"
fi

shift

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.5 \
   -dNOPAUSE -dQUIET -dBATCH -dDetectDuplicateImages \
   -dSubsetFonts=true -dEmbedAllFonts=true -dPDFFITPAGE -dColorConversionStrategy=/LeaveColorUnchanged \
   -dCompressFonts=true -dPDFSETTINGS=/$QUALITY $@ -sOutputFile="$OUT" "$INPUT"

if which cpdf; then
    TMP=`mktemp`
    cp "$OUT" "$TMP"
    cpdf -squeeze "$TMP" AND -compress AND -clean -o "$OUT"
    rm "$TMP"
fi

if which pdfsizeopt; then
    TMP=`mktemp`
    cp "$OUT" "$TMP"
    pdfsizeopt --use-image-optimizer="ect -9 -strip -progressive --mt-deflate=$JOBS %(targetfnq)s" "$TMP" "$OUT"
    rm "$TMP"
fi

SIZE1=`stat -c"%s" "$INPUT"`
SIZE2=`stat -c"%s" "$OUT"`
PERC=`bc <<< "scale=2; ($SIZE2 - $SIZE1)/$SIZE1 * 100"`
if [[ $SIZE2 -ge $SIZE1 ]]; then
    echo "Didn't shrink; reverting."
    mv "$INPUT" "$OUT"
else
    echo "Saved $PERC %; try manually spot-checking $OUT"
fi
