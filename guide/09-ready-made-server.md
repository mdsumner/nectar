# A ready-made research server

You've launched a VM and connected to it. This page turns that into a working
research computer without you installing anything: RStudio Server, R, GDAL and
the main spatial packages, built by a recipe while you do something else.

It fits in a Project Trial, needs no web address, and opens no ports beyond SSH.
If you don't like the result, delete the VM and try again.

## What you get

- R, with `sf`, `terra`, `gdalraster`, `vapour` and `sds`, compiled against a
  current GDAL, PROJ and GEOS from
  [gdal-r-ci](https://github.com/hypertidy/gdal-r-ci)
- RStudio Server, reachable only through your SSH connection
- Docker, and a Python environment with GDAL's bindings in `/opt/gdal-py`
- A login called `rstudio`, separate from the `ubuntu` admin account

You don't need to download data to start: see
[Try some cloud-ready data](#try-some-cloud-ready-data).

To try the same software before launching anything, see
[Try it now, in your browser](11-try-it-now.md).

## Launch it

Follow [Launch a VM](04-launch-a-vm.md) as usual, with these choices:

1. **Source:** `NeCTAR Ubuntu 26.04 LTS (Resolute) amd64`. It must be 26.04,
   because the GDAL build comes from images built on that release.
2. **Flavour:** `m3.small` or bigger. The `t3` flavours have only 10 GB of disk,
   which isn't enough.
3. **Security Groups:** `ssh`, as usual. Nothing else.
4. **Key Pair:** your key, as usual.
5. **Configuration:** paste this into **Customization Script**:

   ```bash
   #!/bin/bash
   curl -fsSL https://raw.githubusercontent.com/mdsumner/nectar/main/recipes/bootstrap.sh | bash
   ```

Click **Launch Instance**. The VM goes Active in a minute or two, then builds
itself for about 20 minutes on an `m3.small`, and less on a bigger flavour.

That script downloads and runs the [recipes](https://github.com/mdsumner/nectar/tree/main/recipes) from this guide's
repository as root on your VM. Read them first if you'd like to; they're short.

## Watch it build (optional)

SSH in and follow the log. You can leave and come back; it doesn't depend on
your connection.

```bash
ssh ubuntu@<ip>
tail -f /var/log/recipe-build.log     # Ctrl-C to stop watching
cat /var/lib/recipe-status            # running, failed <layer>, or done
```

## Connect to RStudio

When the status says `done`, get your password. The build saved it in a file
called `rstudio-password` in the `ubuntu` home directory on your VM. If you're
still logged in to the VM, the file is right there:

```bash
cat rstudio-password
```

Or fetch it from a terminal on your own computer, without logging in:

```bash
ssh ubuntu@<ip> cat rstudio-password
```

Then, from a terminal on your own computer, connect with a tunnel, which carries
RStudio through your SSH connection:

```bash
ssh -L 8787:localhost:8787 ubuntu@<ip>
```

Leave that running, open <http://localhost:8787> in your browser, and log in as
`rstudio` with that password. Traffic is encrypted by SSH, and nobody else can
reach the port. Close the SSH session and RStudio is unreachable again, though
your R session carries on running on the VM.

On Windows, the same `ssh` command works in PowerShell.

## Try some cloud-ready data

A lot of data no longer needs downloading. The
[`sds`](https://CRAN.R-project.org/package=sds) package lists sources of
cloud-ready data, and GDAL reads only the parts you ask for. This reads one
degree of [GEBCO](https://www.gebco.net/) bathymetry over Tasmania out of a
global file:

```r
library(terra)
r <- rast(sds::gebco())
plot(crop(r, ext(147, 148, -43, -42)))
```

The recipe runs this same read as its final step, so if the status says `done`,
it worked on your VM.

## What to look after

You own this server, so a few things are now yours to keep up with.

- **Your files are on the VM's own disk.** Without a volume, deleting the VM
  deletes them. Keep code in git, and read [Storage](05-storage.md) before you
  have results you'd miss.
- **Keep it updated.** See [Updates](08-looking-after-it.md). Ubuntu's security
  updates are automatic, but reboots aren't.
- **RStudio is a daily build**, not a stable release. It has worked well for
  us, but expect the occasional rough edge.
- **Don't `sudo pip install`.** It's the classic way to break a server's system
  Python. Use a virtual environment.
- **Rebuild rather than repair.** When a server gets old, launch a new one and
  move your work over. Keep your own changes in a script
  ([Recipes age better than snapshots](08-looking-after-it.md#recipes-age-better-than-snapshots)).
- **Delete it when you're finished.** It uses your allocation while it exists.

## More options

Launching from the command line lets you add a volume, a public web address,
more accounts, or the Rust toolchain. [`recipes/launch.sh`](https://github.com/mdsumner/nectar/blob/main/recipes/launch.sh)
needs the [OpenStack client](04-launch-a-vm.md) set up with your project's
credentials:

```bash
recipes/launch.sh myserver --key mykey --az tasmania --new-volume 100 --flavor m3.large
```

With a volume, home directories and Docker's data live on it (at
`/mnt/data/home`) and survive the VM. Volumes need
[an allocation](02-your-allocation.md), because a Project Trial has no volume
quota. The volume and the VM must be in the same availability zone.

`--fqdn` serves RStudio at `https://<name>/rstudio/`, needing a DNS record and a
security group that opens ports 80 and 443 (see
[RStudio Server](06-rstudio-server.md)). `recipes/launch.sh` lists all its
options at the top of the file.

### JupyterLab, and a bigger Python stack

`--jupyter` adds JupyterLab, with R and Python kernels and RStudio in its
launcher. Each user starts their own, through a tunnel as for RStudio:

```bash
ssh -L 8888:localhost:8888 ubuntu@<ip>     # then, on the VM:
jupyter lab --no-browser
```

and opens the `http://localhost:8888/lab?token=...` link it prints.

Python on the server is `/opt/gdal-py`, built against the same GDAL as R's
packages, and R's reticulate uses it too. By default it has only GDAL's own
bindings and numpy. `--python-full` swaps in the full stack from
[gdal-r-ci](https://github.com/hypertidy/gdal-r-ci)'s `gdal-r-python` image:
rasterio, geopandas, pyogrio, pyarrow, xarray, dask, pystac-client, odc-geo,
rioxarray and more. It adds about 3 GB on disk and a few minutes to the build.

From the dashboard, put the same settings before `bash` in the Customization Script:

```bash
#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/mdsumner/nectar/main/recipes/bootstrap.sh | JUPYTER=1 GDAL_IMAGE=ghcr.io/hypertidy/gdal-r-python:latest bash
```
