#!/bin/sh

IN=$1

# Compress the hell out of it.
ect -9 --mt-deflate $1
