#!/bin/bash
# 40: R from CRAN's Ubuntu apt repo, plus the core spatial packages compiled from source against the lifted GDAL.
# Usage (as root), after 30-gdal.sh:  40-r.sh [extra R packages...]
# Spatial packages must build from source: binary builds (e.g. Posit Package Manager) link Ubuntu's own GDAL, not /usr/local.
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
. /etc/os-release

echo "== CRAN apt repo ($VERSION_CODENAME-cran40)"
install -d -m 755 /etc/apt/keyrings
[ -f /etc/apt/keyrings/cran.asc ] || curl -fsSL https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc -o /etc/apt/keyrings/cran.asc
cat > /etc/apt/sources.list.d/cran.sources <<SRC
Types: deb
URIs: https://cloud.r-project.org/bin/linux/ubuntu
Suites: $VERSION_CODENAME-cran40/
Components:
Signed-By: /etc/apt/keyrings/cran.asc
SRC
apt-get update -qq
# R itself, and the system libraries R packages commonly need (as in gdal-r-ci's gdal-r image)
apt-get install -y -qq --no-install-recommends r-base r-base-dev \
  libcurl4-openssl-dev libssl-dev libxml2-dev libfontconfig1-dev libfreetype6-dev libharfbuzz-dev libfribidi-dev \
  libpng-dev libjpeg-dev libtiff-dev libudunits2-dev libabsl-dev libuv1-dev pandoc qpdf locales
sed -i 's/^# *en_US.UTF-8/en_US.UTF-8/; s/^# *en_AU.UTF-8/en_AU.UTF-8/' /etc/locale.gen && locale-gen >/dev/null

echo "== site-wide R options"
SITE=/etc/R/Rprofile.site
grep -q 'nectar-recipes' $SITE || cat >> $SITE <<'R'
## nectar-recipes: CRAN, source builds (link /usr/local GDAL), all cores
local({
  options(repos = c(CRAN = "https://cloud.r-project.org"), pkgType = "source", Ncpus = parallel::detectCores())
})
R

echo "== reticulate uses the Python that has GDAL (/opt/gdal-py), as gdal-r-python does; R sessions read Renviron.site"
sed -i '/^RETICULATE_PYTHON=/d; /^RETICULATE_USE_MANAGED_VENV=/d' /etc/R/Renviron.site 2>/dev/null || true
printf 'RETICULATE_PYTHON=/opt/gdal-py/bin/python\nRETICULATE_USE_MANAGED_VENV=no\n' >> /etc/R/Renviron.site

echo "== spatial packages from source"
Rscript -e '
pkgs <- c("sf", "terra", "gdalraster", "vapour", "sds", commandArgs(TRUE))
need <- setdiff(pkgs, rownames(installed.packages()))
if (length(need)) install.packages(need, lib = "/usr/local/lib/R/site-library")
bad <- pkgs[!vapply(pkgs, requireNamespace, logical(1), quietly = TRUE)]
if (length(bad)) stop("failed: ", paste(bad, collapse = ", "))
' "$@"

echo "== checks"
R --version | head -1
Rscript -e '
cat("sf:", format(sf::sf_extSoftVersion()[c("GDAL", "PROJ", "GEOS")]), "\n")
cat("terra GDAL:", terra::gdal(), "\n")
cat("gdalraster GDAL:", gdalraster::gdal_version()[1], "\n")
cat("vapour GDAL:", vapour::vapour_gdal_version(), "\n")
'
