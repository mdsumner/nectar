# To do

A running list. Tick things off, add as they come up.

## Try it and write it up

Each of these gets tested on a real Nectar VM, then becomes a guide page of its own.

- [ ] marimo: install on a VM, serve it behind nginx + HTTPS like RStudio (06)
- [ ] Jupyter (JupyterLab): same, and check the command in 07 against a current image.
      Smoke test from issue #12: open a public Zarr store with xarray
      (`xr.open_dataset(<zarr url>, engine='zarr', chunks={})`)
- [ ] Positron: connect to a VM over SSH from the desktop app
- [ ] VS Code Remote-SSH, as the alternative to Positron
- [ ] "Next: put something on the web": one simple page serving a static site with
      nginx and a `<project>.cloud.edu.au` name, before RStudio
- [ ] Applications > Quick Deploy R-Studio: try it from a Project Trial and allocated project
- [ ] Maybe: Open Data Cube / DEA sandbox in Docker on a VM (issue #13), as an example
      of a group-maintained stack
- [ ] Interactive HPC pointers: NCI ARE, NCI and Pawsey docs for RStudio/Jupyter in a job

## Verify on a real VM

The `TODO(verify)` markers in the guide, by page:

- [ ] 02: which institutions belong to which node (two support pages disagree)
- [ ] 03: instance metadata (`meta_data.json`, `instance-type`) on a current VM;
      the `tas.*` node-private flavours
- [ ] 04: whether Ubuntu 26.04 is in the dashboard; `server create` with
      `--network "Classic Provider"`; whether the IP survives shelve/unshelve
- [ ] 05: volume quota flags; backup quota and location; GDAL S3 settings
      (`AWS_VIRTUAL_HOSTING`)
- [ ] 01: Virtual Desktop shelve period (pages disagree)
- [ ] 06: Ubuntu 26.04 image; RStudio download redirect; `snapd` on the image;
      certbot's HTTP to HTTPS redirect
- [ ] 07: PPM `HTTPUserAgent`; rocker bind-mount ownership; JupyterLab command
- [ ] 08: IP after unshelve; any formal hand-back process
- [ ] README: Monash link (returns 403 to scripts)

## Site

- [ ] Go live: Quarto site on GitHub Pages from main (workflows are in `.github/`)
- [ ] Decide whether `guide/_research-notes.md` stays in the repo (it's not rendered)
- [ ] Hooks for other groups' pages (join a project, managed stacks) once they nominate owners
- [ ] Branding/voice check with Media and manager before promoting it
