#!/bin/bash
# 70: the end-to-end test: R reads a small window of a remote cloud-ready dataset through the host's GDAL, without downloading the file.
set -euo pipefail
Rscript --vanilla -e '
r <- terra::rast(sds::gebco())
w <- terra::crop(r, terra::ext(147, 148, -43, -42))
cat("GEBCO, 1 degree over Tasmania:", dim(w)[1:2], "cells, elevation range", range(terra::values(w)), "\n")
'
