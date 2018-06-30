#!/bin/sh

IN=$1

# Compress the hell out of it; needs gzip flag for some reason.
ect -9 -gzip -progressive --mt-deflate $1
