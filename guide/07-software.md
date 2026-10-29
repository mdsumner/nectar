# 7. Software

> **Status:** draft

There are three ways to get software onto your VM. They're listed from least to
most systematic. Most people should start with the first, move to the second
when they want a ready-made environment, and only use the third when library
versions really matter.

1. [Install on the VM](#install-on-the-vm): apt, CRAN and a Python venv. Quick, familiar, and good enough for most work.
2. [Containers](#containers): a ready-made image (rocker) run with Docker. Reproducible and disposable.
3. [A systematic dependency stack](#a-systematic-dependency-stack-gdal-r-ci): images in which GDAL, PROJ and GEOS are aligned across R and Python.

All commands assume the Nectar Ubuntu 24.04 LTS ("noble") image and a user with
`sudo`.

## Install on the VM

### R from CRAN

Ubuntu's own `r-base` falls behind. CRAN's Ubuntu repository has the current R
release for 22.04, 24.04 and 26.04, on both amd64 and arm64
([CRAN: Ubuntu packages for R](https://cloud.r-project.org/bin/linux/ubuntu/)):

```bash
sudo apt update -qq
sudo apt install --no-install-recommends software-properties-common dirmngr
# Michael Rutter's signing key for the CRAN Ubuntu repository
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
  | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt install --no-install-recommends r-base r-base-dev
```

To check the key, run the command below. The fingerprint should be
`E298A3A825C0D65DFD57CBB651716619E084DAB9`.

```bash
gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
```

The old c2d4u PPA (CRAN packages as `.deb`s) is
[on hiatus](https://cloud.r-project.org/bin/linux/ubuntu/), so don't add it.
Use r2u instead (see below).

### Geospatial system libraries

**Use the stock Ubuntu 24.04 libraries.** Noble ships GDAL 3.8.4, PROJ 9.4.0,
GEOS 3.12.1 and netCDF 4.9.2. That's recent enough for current sf, terra,
gdalraster, stars, vapour and ncdf4. It also matches what r2u and Posit Package
Manager build their binaries against.

The [ubuntugis-unstable PPA](https://launchpad.net/~ubuntugis/+archive/ubuntu/ubuntugis-unstable)
does publish a newer GDAL for noble (3.11.4 at the time of writing). It has not
updated PROJ (9.4.1) or GEOS (3.12.2) since 2024. The "stable" ubuntugis PPA has
nothing for noble. Add the unstable PPA only if you need a specific GDAL
feature, and then build your R packages from source rather than using r2u or
PPM binaries, which are linked against the stock GDAL. If you need newer
libraries throughout, use [gdal-r-ci](#a-systematic-dependency-stack-gdal-r-ci)
instead of mixing repositories.

The list below covers sf, terra, gdalraster, stars, vapour, ncdf4, units, s2,
ragg and devtools. It was generated with
`pak::pkg_sysreqs(..., sysreqs_platform = "ubuntu-24.04")`:

```bash
sudo apt install --no-install-recommends \
  gdal-bin libgdal-dev libproj-dev libgeos-dev libsqlite3-dev \
  libnetcdf-dev netcdf-bin libudunits2-dev libabsl-dev \
  libxml2-dev libicu-dev libzstd-dev libssl-dev libcurl4-openssl-dev \
  libfreetype6-dev libfontconfig1-dev libfribidi-dev libharfbuzz-dev \
  libjpeg-dev libpng-dev libtiff-dev libwebp-dev libx11-dev \
  libgit2-dev libuv1-dev zlib1g-dev \
  cmake make git pandoc
```

If you need other packages, ask pak which system libraries they want:

```r
pak::pkg_sysreqs(c("sf", "terra", "gdalraster"))
```

### R packages: binaries, not source

When you compile packages from source, `install.packages()` can take an hour
on a fresh VM. There are two fast alternatives. Choose one.

**r2u** ([eddelbuettel/r2u](https://github.com/eddelbuettel/r2u)) turns all of
CRAN (and part of Bioconductor) into Ubuntu `.deb` binaries. It works on
jammy, noble and resolute. With
[bspm](https://cloud.r-project.org/package=bspm) enabled,
`install.packages()` calls apt for you, and dependencies (including system
libraries) are resolved automatically. CRAN's Ubuntu page recommends r2u. Set
it up with the project's script, and read it first:

```bash
wget https://raw.githubusercontent.com/eddelbuettel/r2u/master/inst/scripts/add_cranapt_noble.sh
less add_cranapt_noble.sh
sudo bash add_cranapt_noble.sh
```

Then, in R, run:

```r
install.packages(c("sf", "terra", "gdalraster", "ncdf4", "stars"))
```

Packages installed this way are system-wide, in `/usr/lib/R/site-library`, and
are updated by `apt upgrade`. That suits a shared VM.

**Posit Public Package Manager (PPM)** serves precompiled Linux binaries of
CRAN packages ([p3m.dev](https://p3m.dev/)). This is what the rocker images
use. Point R at the noble binary repository, for example in `~/.Rprofile` or
`/etc/R/Rprofile.site`:

```r
options(repos = c(CRAN = "https://p3m.dev/cran/__linux__/noble/latest"))
```

PPM binaries don't install system libraries for you. You still need the apt
list above.
TODO(verify): whether PPM needs an explicit `HTTPUserAgent` option with
`install.packages()` on R 4.6 to get binaries rather than source.

**pak** ([pak.r-lib.org](https://pak.r-lib.org/)) is a faster, parallel
installer. It also installs from GitHub, and it can look up and install the
system requirements itself (`pak::pkg_sysreqs()`, and
`pak::pkg_install()` when run as root). It works with either repository
above:

```r
install.packages("pak")
pak::pkg_install(c("sf", "terra"))      # from CRAN
pak::pkg_install("hypertidy/vapour")     # from GitHub
```

### RStudio Server

[Section 6](06-rstudio-server.md) covers installing RStudio Server and putting
it behind nginx and HTTPS.

### Python: a virtual environment, not `sudo pip`

Ubuntu 24.04 marks the system Python as externally managed
([PEP 668](https://peps.python.org/pep-0668/)), so `sudo pip install` is
refused, and you shouldn't force it. Use a virtual environment per project.

With the standard library:

```bash
sudo apt install python3-venv
python3 -m venv ~/venvs/geo
source ~/venvs/geo/bin/activate
pip install rasterio xarray rioxarray geopandas
```

Or with [uv](https://docs.astral.sh/uv/), which is much faster and also
manages Python versions:

```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
uv venv ~/venvs/geo
source ~/venvs/geo/bin/activate
uv pip install rasterio xarray rioxarray geopandas
```

Wheels from PyPI (rasterio, pyogrio, pyproj, shapely) bundle their own copies
of GDAL, PROJ and GEOS. These are usually different versions from the
system libraries that R uses. That's normally fine. It matters when you pass
data between R and Python in one process (reticulate), or when you need both
sides to agree on drivers and CRS behaviour. For that, see
[gdal-r-ci](#a-systematic-dependency-stack-gdal-r-ci).

To point reticulate at your venv, add this line to `~/.Renviron`:

```bash
RETICULATE_PYTHON=~/venvs/geo/bin/python
```

## Containers

A container image gives you a complete, versioned environment that you can
start, throw away and recreate. Nothing is installed into the VM itself except
Docker.

### Install Docker

Use Docker's official apt repository
([Docker docs: Install on Ubuntu](https://docs.docker.com/engine/install/ubuntu/)):

```bash
sudo apt install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc
sudo tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}")
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Ubuntu's own `docker.io` package also works (`sudo apt install docker.io`) and
is simpler, but it's older. Don't install both. Docker's docs list `docker.io`
among the packages to remove before installing theirs.

To run `docker` without `sudo`, add yourself to the `docker` group, then log
out and back in:

```bash
sudo usermod -aG docker $USER
```

Membership of the `docker` group is effectively root on the VM. Only add people
you'd give `sudo` to.

**Docker and firewalls:** ports that Docker publishes bypass `ufw` rules
([Docker docs](https://docs.docker.com/engine/network/packet-filtering-firewalls/)).
On Nectar, the security group is your outer firewall. On the VM itself, always
publish ports on `127.0.0.1` unless you mean them to be public.

### rocker/geospatial as RStudio Server

The [rocker project](https://rocker-project.org/) publishes versioned R images.
[`rocker/geospatial`](https://rocker-project.org/images/versioned/rstudio.html)
is RStudio Server plus tidyverse, LaTeX and the common spatial packages, on
Ubuntu 24.04 with packages from a dated PPM snapshot. Tags follow the R version.
At the time of writing, `4.6.1` (also `4.6`, `4`, `latest`) is current, and
`dev-osgeo` builds against the latest GDAL, PROJ and GEOS releases
([tags on Docker Hub](https://hub.docker.com/r/rocker/geospatial/tags)). For
reproducible work, pin a full version tag rather than `latest`.

Create a data directory on your volume, then run the container. The port is
bound to localhost only. `/mnt/data` here, and below, stands for wherever you
mounted your volume ([section 5](05-storage.md)).

```bash
mkdir -p /mnt/data/project
docker run -d --name rstudio --restart unless-stopped \
  -e PASSWORD='choose-a-strong-password' \
  -p 127.0.0.1:8787:8787 \
  -v /mnt/data/project:/home/rstudio/project \
  rocker/geospatial:4.6.1
```

- `-p 127.0.0.1:8787:8787` means RStudio is reachable only from the VM. Put the
  nginx + HTTPS proxy from [section 6](06-rstudio-server.md) in front of it
  (`proxy_pass http://127.0.0.1:8787`). Don't publish 8787 to the world or open
  it in a security group. Without HTTPS, your password crosses the network in
  clear text. If you want quick access without nginx, use an SSH tunnel
  (`ssh -L 8787:localhost:8787 ubuntu@<vm>`) and browse to `http://localhost:8787`.
- The login user is `rstudio`. The `-v` bind mount puts your data at
  `~/project` inside RStudio. Rocker advises against bind-mounting the whole
  home directory.
- Packages you install from inside RStudio go into the container. They're lost
  when you remove it, unless you also bind-mount a library directory and set
  `R_LIBS_USER` to it.
- `DISABLE_AUTH=true` turns off the login. Only use it with the localhost binding and an
  SSH tunnel, never behind a public proxy.

TODO(verify): file ownership on the bind mount. The `rstudio` user is UID 1000,
which matches the default `ubuntu` user on Nectar images. Other users may need
`-e USERID=$(id -u) -e GROUPID=$(id -g)`.

Useful commands:

```bash
docker logs rstudio          # see startup messages
docker stop rstudio          # stop
docker start rstudio         # start again
docker rm -f rstudio         # remove (bind-mounted data is kept)
docker pull rocker/geospatial:4.6.1
```

## A systematic dependency stack: gdal-r-ci

This is the process for more systematic dependencies. It's not the first port
of call. Use it when the versions of the geospatial libraries themselves
matter.

[hypertidy/gdal-r-ci](https://github.com/hypertidy/gdal-r-ci) publishes
container images to GHCR. In these images, GDAL, PROJ and GEOS are built from
source once, into `/usr/local` on plain Ubuntu 26.04. R and Python then link
against those same libraries: sf, terra, gdalraster and vapour on the R side,
and rasterio, fiona, pyogrio, shapely, pyproj and the osgeo bindings on the
Python side. The images contain one `libproj`, one `libgdal`, one `libgeos` and one
numpy ABI, so reticulate can pass objects between R and Python without the
duplicate-library crashes you get from mixing wheels, apt and other images (see
the README's
"[Why build from source?](https://github.com/hypertidy/gdal-r-ci#why-build-from-source)").

### When to use it

- You need GDAL, PROJ and GEOS versions aligned across R and Python, for
  example with reticulate, or when comparing results between rasterio and
  terra.
- You want the same environment on your Nectar VM, in GitHub Actions CI and on
  your laptop. These are the same images that test sf, terra, gdalraster and
  vapour.
- You need a newer GDAL than Ubuntu 24.04 ships (`:latest`) or GDAL's
  development branch (`:dev`).

### The image ladder

Each image builds on the previous one:

```
gdal-system → gdal-r → gdal-r-full → gdal-r-python → gdal-r-python-extras → gdal-r-python-extras-rust
```

| Image (`ghcr.io/hypertidy/...`) | Adds | Use for |
|---|---|---|
| `gdal-system` | GDAL + PROJ + GEOS from source, a uv venv at `/opt/gdal-py` with numpy 2.x | Base for your own images |
| `gdal-r` | R (from CRAN) + dev tooling + tinytex | R package development |
| `gdal-r-full` | gdalraster, sf, terra, vapour, gdalcubes | Package CI |
| `gdal-r-python` | rasterio, fiona, geopandas, xarray, zarr, kerchunk, ...; reticulate pinned to the venv | R/Python interop |
| `gdal-r-python-extras` | A curated everyday R set (arrow, duckdb, targets, tidy core, dev tooling) | Interactive workbench |
| `gdal-r-python-extras-rust` | A pinned Rust toolchain | Rust + geospatial dev |

There are also side branches: `gdal-r-mesh` (meshes and triangulation, built
off `gdal-r-full`), `gdal-r-esmf` (ESMF/xESMF regridding), and `gdal-conda`, a
conda-forge counterpart that is also usable without Docker through pixi. See
the [README](https://github.com/hypertidy/gdal-r-ci#images) for details, and
the [image report](https://hypertidy.github.io/gdal-r-ci/) for each tag's
exact versions and sizes.

**`:latest` and `:dev`:** `:latest` tracks the latest *releases* of GDAL, PROJ
and GEOS and is rebuilt weekly. `:dev` tracks GDAL's development branch
(`master`) with the latest released PROJ and GEOS, and is rebuilt daily as an
early warning of breaking changes. Use `:latest` for work. Only the first four
images have `:dev` variants. `gdal-r-python-extras` and the leaf images are
`:latest` only. To work against GDAL dev, use `gdal-r-python:dev` and add the
packages you need yourself (see below).

### Using it on a VM

The images start in a `bash` shell in `/workspace`, with R, Python and the GDAL
command-line tools all on `PATH`. A banner prints the GDAL, PROJ, GEOS, R and
Python versions. They don't include RStudio Server. `gdal-r-python` and its
descendants do include JupyterLab (Python kernel; no R kernel is installed).

For an interactive shell with your project mounted, run:

```bash
docker run --rm -ti \
  -v /mnt/data/project:/workspace \
  ghcr.io/hypertidy/gdal-r-python-extras:latest
```

To check that everything links the same libraries, run:

```bash
docker run --rm ghcr.io/hypertidy/gdal-r-full:latest \
  Rscript /opt/scripts/check-r-versions.R
```

To add packages without rebuilding the image, mount a writable library and
point `R_LIBS_USER` at it. Packages you install there persist on the host
across container runs, and are layered over the image's own library. This
is how the README suggests working against `:dev`:

```bash
mkdir -p ~/R/gdal-r-ci-lib
docker run --rm -ti \
  -v /mnt/data/project:/workspace \
  -v ~/R/gdal-r-ci-lib:/opt/r-overlay \
  -e R_LIBS_USER=/opt/r-overlay \
  ghcr.io/hypertidy/gdal-r-python:dev
```

To build spatial packages in the overlay against the image's GDAL, install them
from source and stop pak from pulling in apt's GDAL (the README's "dual GDAL"
problem):

```r
options(pkg.sysreqs = FALSE)
pak::pkg_install("hypertidy/vapour?source")
```

To use JupyterLab from the browser, bind it to localhost and reach it through an
SSH tunnel or the nginx proxy from [section 6](06-rstudio-server.md):

```bash
docker run --rm -ti \
  -p 127.0.0.1:8888:8888 \
  -v /mnt/data/project:/workspace \
  ghcr.io/hypertidy/gdal-r-python:latest \
  jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --no-browser
```

TODO(verify): the JupyterLab command above has not been tested against the
current image. The containers run as root, so files written to `/workspace`
will be owned by root on the host. Consider `--user $(id -u):$(id -g)`
(untested; `HOME` and venv permissions may need care).

TODO: a workbench variant (RStudio Server on top of `gdal-r-python-extras`, or
an R kernel for JupyterLab) so these images can be run like rocker behind
nginx on a Nectar VM.

## Group-maintained stacks

Your group may maintain its own pathway: a shared VM image, an internal
container registry, a package list, or a set of setup scripts. If so, document
it here. Say what it provides, who maintains it, how to request access, and how
it relates to the three pathways above. Open a pull request or an issue on
this repository to add it.
