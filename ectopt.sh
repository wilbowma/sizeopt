#!/bin/sh

IN=$1

# Compress the hell out of it.
ect -9 -progressive --mt-deflate $1
