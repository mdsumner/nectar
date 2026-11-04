#!/bin/bash
# 30: GDAL/PROJ/GEOS (+ spatialite, kea, uv, /opt/gdal-py venv) lifted from a gdal-r-ci image, plus apt deps.
# Usage (as root), after 20-docker.sh:  30-gdal.sh [image]   (default ghcr.io/hypertidy/gdal-system:latest)
# In an image build (image/Dockerfile), the Dockerfile copies /usr/local and /opt/gdal-py in itself and sets
# GDAL_PRELIFTED=<image>; the lift is skipped and everything else (apt deps, Arrow, checks) runs as on a VM.
#
# The image is plain Ubuntu (26.04 since gdal-r-ci 73d922b; glibc must match the host) with GDAL built into /usr/local, so its /usr/local runs on a host of the same release given
# the same apt libraries. :latest = release GDAL (not bleeding edge). To upgrade: rerun with a newer tag.
# Rust (/usr/local/rustup, /usr/local/cargo) is left out; only the image build needs it.
# Arrow: GDAL links a specific Arrow ABI (e.g. libarrow.so.2600); the matching packages are installed and held.
set -euo pipefail
IMG=${1:-ghcr.io/hypertidy/gdal-system:latest}
export DEBIAN_FRONTEND=noninteractive

. /etc/os-release
# HDF4: 26.04's libhdf4-dev already renames its netCDF API; libhdf4-alt-dev only exists up to 24.04 (as upstream does)
HDF4=$([ "$VERSION_ID" = "24.04" ] && echo libhdf4-alt-dev || echo libhdf4-dev)
echo "== apt deps (same list as gdal-system's Dockerfile; the -dev packages also let R packages compile)"
apt-get update -qq
apt-get install -y -qq --no-install-recommends \
  build-essential cmake git wget curl ca-certificates pkg-config software-properties-common lsb-release unzip \
  python3-dev swig libsqlite3-dev sqlite3 libcurl4-openssl-dev libtiff-dev libpng-dev libjpeg-turbo8-dev libgif-dev \
  libwebp-dev libopenjp2-7-dev libdeflate-dev liblzma-dev libblosc-dev libzstd-dev liblz4-dev liblerc-dev libxml2-dev \
  libexpat1-dev libminizip-dev $HDF4 libhdf5-dev libnetcdf-dev netcdf-bin libpq-dev libmysqlclient-dev \
  libkml-dev libxerces-c-dev libpoppler-dev libpoppler-private-dev libcfitsio-dev libfreexl-dev libspdlog-dev \
  libsqlite3-0 libmuparser-dev

if [ -n "${GDAL_PRELIFTED:-}" ]; then
  echo "== /usr/local and /opt/gdal-py already copied in from $GDAL_PRELIFTED"
  echo "$GDAL_PRELIFTED" > /etc/gdal-lifted-from
else
  echo "== lift /usr/local and /opt/gdal-py from $IMG"
  docker pull -q "$IMG"
  docker inspect --format '{{index .RepoDigests 0}}' "$IMG" | tee /etc/gdal-lifted-from
  docker run --rm --entrypoint tar "$IMG" -C / -cf - \
    --exclude=usr/local/rustup --exclude=usr/local/cargo usr/local opt/gdal-py | tar -C / -xf -
  docker rmi -f "$IMG" >/dev/null   # its files are now on the host; don't keep several GB of image on a small root disk
fi
echo /usr/local/lib > /etc/ld.so.conf.d/gdal-r-local.conf
ldconfig

echo "== Arrow libs matching the ABI GDAL was linked against"
if [ ! -f /etc/apt/sources.list.d/apache-arrow.sources ]; then
  wget -q -O /tmp/arrow-src.deb "https://packages.apache.org/artifactory/arrow/ubuntu/apache-arrow-apt-source-latest-$VERSION_CODENAME.deb"
  apt-get install -y -qq /tmp/arrow-src.deb && apt-get update -qq
fi
# libarrow_dataset.so.2600 -> libarrow-dataset2600
PKGS=$(objdump -p /usr/local/lib/libgdal.so | awk '/NEEDED/ && /lib(arrow|parquet)/{print $2}' \
       | sed -E 's/\.so\./ /; s/_/-/g' | awk '{print $1 $2}' | sort -u)
echo "arrow packages: $PKGS"
apt-get install -y -qq --no-install-recommends $PKGS
# the -dev packages, at the same version, as the image has them (they also pull in opentelemetry-cpp, which libgdal needs)
AV=$(dpkg-query -W -f='${Version}' libarrow$(echo "$PKGS" | grep -m1 -oE '^libarrow[0-9]+$' | sed 's/libarrow//'))
DEV="libarrow-dev=$AV libparquet-dev=$AV libarrow-dataset-dev=$AV libarrow-acero-dev=$AV"
echo "arrow dev packages: $DEV"
apt-get install -y -qq --no-install-recommends $DEV
apt-mark hold $PKGS libarrow-dev libparquet-dev libarrow-dataset-dev libarrow-acero-dev

echo "== checks"
missing=$(for f in /usr/local/lib/*.so* /usr/local/bin/*; do [ -f "$f" ] && file -b "$f" | grep -q ELF && ldd "$f" 2>/dev/null | grep 'not found'; done | sort -u || true)
[ -z "$missing" ] && echo "ldd: no missing libraries" || { echo "MISSING:"; echo "$missing"; exit 1; }
gdalinfo --version
echo "PROJ $(pkg-config --modversion proj)  GEOS $(geos-config --version)"
gdal-config --formats | tr ' ' '\n' | grep -iE '^(arrow|parquet|netcdf|hdf5|zarr|kea|gpkg|cog)' | tr '\n' ' '; echo
/opt/gdal-py/bin/python -c 'from osgeo import gdal; import numpy; print("osgeo", gdal.__version__, "numpy", numpy.__version__)'
