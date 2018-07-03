#!/bin/sh

IN=$1

# Compress the hell out of it; need -zip flag for some reason.
ect -9 -zip -progressive --mt-deflate $1
