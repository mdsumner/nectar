# Recipes

Scripts that build a research server on a fresh Nectar VM. Start with the guide
page: [A ready-made research server](../guide/09-ready-made-server.md).

- `quickstart.sh`: what you paste into the dashboard's Customization Script box.
- `bootstrap.sh`: fetches this folder from GitHub and runs `build.sh`.
- `launch.sh`: the command-line way in, with options (volume, web address, users).
- `build.sh`: runs the layers on the server, logging to `/var/log/recipe-build.log`.

## Layers

Each is a short script run as root, in this order, and safe to read on its own.

| Layer | What it does | When |
|---|---|---|
| `10-volume.sh` | Formats (if empty) and mounts the home volume | With a volume |
| `20-docker.sh` | Docker Engine, on the volume if there is one | Always |
| `30-gdal.sh` | GDAL, PROJ and GEOS lifted from a gdal-r-ci image, plus system libraries | Always |
| `40-r.sh` | R, and `sf`, `terra`, `gdalraster`, `vapour`, `sds` from source | Always |
| `41-rstudio.sh` | RStudio Server on localhost | Always |
| `42-rust.sh` | Rust toolchain | `--rust` |
| `43-jupyter.sh` | JupyterLab, R and Python (GDAL) kernels, RStudio in its launcher | Container image only, for now |
| `45-login.sh` | `rstudio` account with a random password | No users file |
| `60-users.sh` | Accounts from a users file | `--users` |
| `50-nginx.sh` | nginx and a Let's Encrypt certificate | `--fqdn` |
| `70-check.sh` | Reads a remote dataset from R, end to end | Always |

Layers 30 to 43 also build a container image, `ghcr.io/mdsumner/nectar`
(`image/Dockerfile`), for Codespaces, Binder (`binder/Dockerfile`), JupyterHubs and
Docker: see
[Try it now](../guide/11-try-it-now.md).

Requires Ubuntu 26.04: the GDAL build is lifted from images built on that release,
so the host's glibc must match.

## Testing a change

The bootstrap takes the git ref from `RECIPE_REF`, so a branch can be tested as a
stranger would run it:

```bash
#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/mdsumner/nectar/<branch>/recipes/bootstrap.sh | RECIPE_REF=<branch> bash
```

## Other recipes

- [`relay/`](relay/README.md): a small separate server that relays byte-range reads for web pages
  (CORS), see [A relay for browser reads](../guide/10-cors-relay.md).
