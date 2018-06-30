#!/bin/sh


# screen < ebook < print
QUALITY=ebook

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


#SIZE1=`stat -f "%z" "$1.safe.pdf"`
#SIZE2=`stat -f "%z" "$1"`
#PERC=`bc <<< "scale=2; ($SIZE2 - $SIZE1)/$SIZE1 * 100"`
#echo "$PERC %"
