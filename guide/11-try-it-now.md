# 11. Try it now, in your browser

> **Status:** draft, November 2026. The image builds and passes the recipe's
> own check; the Codespaces link is new.

Before you ask for an allocation or launch anything, you can try the software
a [ready-made server](09-ready-made-server.md) gets, in a browser tab, in a
couple of minutes:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new/mdsumner/nectar?quickstart=1)

This isn't Nectar. It's a small temporary computer from GitHub, running the
same software the recipe puts on a Nectar VM. It's for a first look. When you
want more memory, more disk, or a computer that's still there next month,
that's what Nectar is for.

## What you get

- R, with `sf`, `terra`, `gdalraster`, `vapour` and `sds`, compiled against the
  same GDAL, PROJ and GEOS as a recipe-built VM
- Python with GDAL's bindings, in `/opt/gdal-py`
- VS Code in the browser, with R and Python set up, and a terminal
- A login called `rstudio`, with `sudo`, because the container is yours to
  change

You need a GitHub account. Open the link, wait while it starts (the first
start takes a few minutes, while it fetches the image), then open a terminal
and type `R`. Try the same read the recipe uses as its final check:

```r
library(terra)
r <- rast(sds::gebco())
plot(crop(r, ext(147, 148, -43, -42)))
```

That reads one degree of GEBCO bathymetry over Tasmania out of a global file,
without downloading the file.

## What it costs, and what it isn't

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
same recipe layers as a VM (`30-gdal.sh`, `40-r.sh`), on the same Ubuntu
release. It's rebuilt monthly, and whenever those layers change. Codespaces is
only one place to run it.

| Where | You need | Good for |
|---|---|---|
| GitHub Codespaces (the link above) | A GitHub account | A first look, a workshop, trying a change |
| Your own computer | [Docker](https://docs.docker.com/get-started/get-docker/) | The same software, offline, on your own files |
| A JupyterHub that takes your own image | An account on that hub | A group or a class (some community hubs, such as [2i2c](https://2i2c.org/)'s, allow this) |
| A Nectar VM, [built by the recipe](09-ready-made-server.md) | A Nectar allocation | Real work: more memory and disk, RStudio Server, a computer that stays |

On your own computer, this runs it with the current folder available inside
as `~/work`:

```bash
docker run --rm -it -v "$PWD":/home/rstudio/work ghcr.io/mdsumner/nectar R
```

Because it's the same software at each step, code that works in one place
works in the next. You move it up when it outgrows where it is.

## Reading data from a browser page

If you go on to read data from a web page rather than from R (a map viewer
that reads a GeoTIFF directly, say), you may hit a browser rule, CORS, that
R doesn't have. The fix is on [A relay for browser reads](10-cors-relay.md).
