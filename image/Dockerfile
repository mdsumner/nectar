# The recipe's software as a container image: the same layers a Nectar VM runs (30-gdal, 40-r, 41-rstudio, optionally
# 42-rust), on the same Ubuntu release, so "try it in the browser" and "your own server" run the same stack. Plus
# 43-jupyter: JupyterLab with R, Python (GDAL) and RStudio inside it, which Binder and JupyterHubs need.
# The VM-only layers (volume, Docker, nginx, accounts) are left out, and RStudio runs per user, not as a service.
# Build from the repo root:  docker build -f image/Dockerfile -t nectar .      (add --build-arg RUST=1 for Rust)
ARG GDAL_IMAGE=ghcr.io/hypertidy/gdal-system:latest

# The GDAL build, minus the Rust toolchain that only its own build needed (as 30-gdal.sh excludes on a VM)
FROM ${GDAL_IMAGE} AS gdal
RUN rm -rf /usr/local/rustup /usr/local/cargo

FROM ubuntu:26.04
ARG GDAL_IMAGE
ARG RUST=
LABEL org.opencontainers.image.source=https://github.com/mdsumner/nectar \
      org.opencontainers.image.description="GDAL, R and the core spatial packages, as built by the Nectar recipe"
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends ca-certificates curl file sudo git less nano \
 && rm -rf /var/lib/apt/lists/*

COPY --from=gdal /usr/local /usr/local
COPY --from=gdal /opt/gdal-py /opt/gdal-py

COPY recipes/layers/30-gdal.sh /tmp/layers/
RUN GDAL_PRELIFTED="$GDAL_IMAGE" bash /tmp/layers/30-gdal.sh && rm -rf /var/lib/apt/lists/*

# languageserver: what VS Code's R extension uses for completion and help (Codespaces)
COPY recipes/layers/40-r.sh /tmp/layers/
RUN bash /tmp/layers/40-r.sh languageserver && rm -rf /var/lib/apt/lists/* /tmp/Rtmp*
# the locale 40-r.sh generated
ENV LANG=en_US.UTF-8

COPY recipes/layers/41-rstudio.sh recipes/layers/43-jupyter.sh /tmp/layers/
RUN bash /tmp/layers/41-rstudio.sh && bash /tmp/layers/43-jupyter.sh \
 && rm -rf /var/lib/apt/lists/* /tmp/*.deb /tmp/Rtmp* /root/.cache
ENV PATH=/opt/jupyter/bin:$PATH

COPY recipes/layers/42-rust.sh /tmp/layers/
RUN if [ -n "$RUST" ]; then bash /tmp/layers/42-rust.sh; fi && rm -rf /tmp/layers

# The user: `rstudio`, as on a VM built by the recipe, with uid 1000 (what Codespaces, Binder and hubs expect) and sudo,
# since a container is yours to change. Ubuntu's images ship an `ubuntu` user at 1000; it makes way.
RUN userdel -r ubuntu 2>/dev/null; useradd -m -u 1000 -s /bin/bash rstudio \
 && echo 'rstudio ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/rstudio && chmod 440 /etc/sudoers.d/rstudio
USER rstudio
WORKDIR /home/rstudio
EXPOSE 8888
CMD ["bash", "-l"]
