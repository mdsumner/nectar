# Binder (mybinder.org, and other BinderHubs) builds this, via repo2docker. It's thin on purpose: everything is in the
# recipe's image (image/Dockerfile), which has the uid-1000 user, JupyterLab and jupyterhub-singleuser Binder needs.
FROM ghcr.io/mdsumner/nectar:latest
# repo2docker passes these; the image's user (rstudio, uid 1000) already matches
ARG NB_USER=rstudio
ARG NB_UID=1000
COPY --chown=1000:1000 binder/try-it.ipynb /home/rstudio/
CMD ["jupyter", "lab", "--ip=0.0.0.0", "--no-browser"]
