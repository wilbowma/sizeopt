sizeopt.sh
===

A collection of scripts for optimizing the size of files.

Require some standard utilities that may not have standard flags: `file`,
`size`, `bc`.

I think it is `sh` compliant, but I might accidentally use `bash`.

For working with PDF files, requires `gs`, `pdfsizeopt`, `ect`, and `jbig2enc`.

For working with PNG, JPEG, ZIP, and GZIP files, requires `ect`.

## Usage:
`sizeopt.sh` takes a single argument, a file path, and either modifies it (if
using lossless compression), or modifies it after creating a backup of the
original.

The helper scripts, such as `pdfopt.sh`, `zipopt.sh`, etc, must be in your
`$PATH`.
They have the same interface.

This interface may change.

### Examples:
`sizeopt.sh image.png`

`sizeopt.sh paper.pdf`

If you're brave:
```
for i in *.pdf; do
  sizeopt.sh $i
done
```
