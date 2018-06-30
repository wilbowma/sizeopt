#!/bin/sh

TYPE=$(file -b --mime-type "$1")

case "$TYPE" in
    "image/png"|"image/jpeg")
        ectopt.sh "$1"
        ;;
    "application/zip")
        zipopt.sh "$1"
        ;;
    "application/gzip")
        gzipopt.sh "$1"
        ;;
    "application/pdf")
        pdfopt.sh "$1"
        ;;
    *)
        echo "Sorry, I don't know how to optimize $TYPE"
        ;;
esac
