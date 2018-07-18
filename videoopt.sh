#!/bin/sh

echo "You may not not this script until you manually remove the following"
echo "exit."
echo "By default, this script does lossy-to-lossy transcoding, which is"
echo "Bad (TM)."
# However, in practice, I haven't noticed significant loss of quality in the
# videos.
# Audio optimize for voice; remove -application voip for other and consider
# adjusting bitrate (-b:a)
# Adjust -b:a to improve audio equality, or change set -c:a copy
# Adjust -crf to improve video quality.
# 34 is a pretty low quality factor... but I haven't noticed anything yet.
# 23 is the default, and 17 is consider visually lossless. 0 is lossless.
# Adjust PRESENT if you want worse, but faster, compression.
# Anecdata suggests that actually veryfast is the best speed/compression
# ratio... but I only transcode things once, while many people may download
# them.
exit

IN="$1"
OUT=`mktemp`
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
