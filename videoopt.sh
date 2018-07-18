#!/bin/sh

echo "You may not not this script until you manually remove the following"
echo "exit."
echo "By default, this script does lossy-to-lossy audio transcoding, which is"
echo "Bad (TM)."
# However, in practice, it has halved the size of my videos with no noticable
# loss in quality.
# NB: Audio optimize for voice; remove -application voip for other and consider
# adjusting bitrate (-b:a)
exit

IN="$1"
OUT=`mktemp`
# configure this if you want worse, but faster, compression
# anecdata suggests that actually veryfast is the best speed/compression
# ratio... but I only transcode things once, while many people may download
# them.
PRESET=veryslow

EXTENSION="${IN##*.}"

ffmpeg -i "$IN" -c:v libx265 -preset $PRESET -crf 34 -c:a libopus -vbr on -compression_level 10 -b:a 48k -application voip "$OUT.mkv"

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
