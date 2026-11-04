# 11. Try it now, in your browser

> **Status:** draft, November 2026. The image builds and passes the recipe's
> own check; the Codespaces and Binder links are new.

Before you ask for an allocation or launch anything, you can try the software
a [ready-made server](09-ready-made-server.md) gets, in a browser tab, in a
couple of minutes, two ways:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new/mdsumner/nectar?quickstart=1)
[![Launch Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/mdsumner/nectar/main?urlpath=lab/tree/try-it.ipynb)

- **Codespaces** gives you VS Code, and opens the same JupyterLab in a second
  tab. It needs a GitHub account, and it's the roomier of the two.
- **Binder** gives you JupyterLab, with RStudio a click away. It needs no
  account at all, but it's small (around 2 GB of memory) and forgets
  everything when you close the tab.

Neither is Nectar. Each is a small temporary computer from someone else
(GitHub, or the volunteer-run [mybinder.org](https://mybinder.org)), running the
same software the recipe puts on a Nectar VM. It's for a first look. When you
want more memory, more disk, or a computer that's still there next month,
that's what Nectar is for.

## What you get

- R, with `sf`, `terra`, `gdalraster`, `vapour` and `sds`, compiled against the
  same GDAL, PROJ and GEOS as a recipe-built VM
- Python with GDAL's bindings, in `/opt/gdal-py`
- JupyterLab, with an R kernel, a Python kernel that has GDAL, and RStudio in
  its launcher (this is what Binder opens)
- VS Code in the browser, with R and Python set up, and a terminal (Codespaces
  opens this, with JupyterLab in a second tab)
- A login called `rstudio`, with `sudo`, because the container is yours to
  change

Open either link and wait while it starts. The first start can take several
minutes, because the image is several gigabytes and has to be fetched. Both open
a notebook with this in it. Codespaces also shows a welcome page, with the
other ways in: RStudio, or R in a VS Code terminal. It's the same read the
recipe uses as its final check:

```r
library(terra)
r <- rast(sds::gebco())
plot(crop(r, ext(147, 148, -43, -42)))
```

That reads one degree of GEBCO bathymetry over Tasmania out of a global file,
without downloading the file.

## What it costs, and what it isn't

Binder is free, and run by volunteers on donated computers, so it can be busy;
if a launch fails, try again later. A session ends after about 10 minutes
without activity, and takes everything in it with it.

Personal GitHub accounts get a free monthly allowance of Codespaces hours and
storage. The link asks for a 4-core machine, which uses up the allowance
faster than a 2-core one does. Check
[GitHub's current figures](https://docs.github.com/en/billing/managing-billing-for-your-products/managing-billing-for-github-codespaces/about-billing-for-github-codespaces).
A codespace stops when you leave it idle, and it's deleted after a few weeks
unused, along with anything you saved in it. Push your work somewhere, or
download it.

It isn't a place for big data or long runs. That's the point of the ladder below.

## One image, several places to run it

The software is a container image, `ghcr.io/mdsumner/nectar`, built from the
same recipe layers as a VM (`30-gdal.sh`, `40-r.sh`, `41-rstudio.sh`), on the
same Ubuntu release, plus `43-jupyter.sh` for JupyterLab. It's rebuilt monthly,
and whenever those layers change. Binder and Codespaces are just two of the
places it runs.

| Where | You need | Good for |
|---|---|---|
| [Binder](https://mybinder.org/v2/gh/mdsumner/nectar/main?urlpath=lab/tree/try-it.ipynb) | Nothing | A first look, a link in a talk or a paper |
| [GitHub Codespaces](https://github.com/codespaces/new/mdsumner/nectar?quickstart=1) | A GitHub account | A workshop, a longer session, trying a change |
| Your own computer | [Docker](https://docs.docker.com/get-started/get-docker/) | The same software, offline, on your own files |
| A JupyterHub that takes your own image | An account on that hub | A group or a class (some community hubs, such as [2i2c](https://2i2c.org/)'s, allow this) |
| A Nectar VM, [built by the recipe](09-ready-made-server.md) | A Nectar allocation | Real work: more memory and disk, RStudio Server, a computer that stays |

On your own computer, this runs R, with the current folder available inside
as `~/work`:

```bash
docker run --rm -it -v "$PWD":/home/rstudio/work ghcr.io/mdsumner/nectar R
```

Or JupyterLab, with RStudio in its launcher: run this, then open the
`http://127.0.0.1:8888/lab?token=...` address it prints.

```bash
docker run --rm -it -p 127.0.0.1:8888:8888 -v "$PWD":/home/rstudio/work \
  ghcr.io/mdsumner/nectar jupyter lab --ip=0.0.0.0 --no-browser
```

A JupyterHub that lets you bring your own image needs only the name,
`ghcr.io/mdsumner/nectar:latest`. The image has the user (uid 1000) and the
`jupyterhub-singleuser` program hubs expect.

Because it's the same software at each step, code that works in one place
works in the next. You move it up when it outgrows where it is.

## Reading data from a browser page

If you go on to read data from a web page rather than from R (a map viewer
that reads a GeoTIFF directly, say), you may hit a browser rule, CORS, that
R doesn't have. The fix is on [A relay for browser reads](10-cors-relay.md).
