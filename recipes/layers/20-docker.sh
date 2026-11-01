#!/bin/bash
# 20: Docker Engine from Docker's apt repo (deb822 .sources). Idempotent. Run as root.
# With a home volume (RECIPE_HOME set and not /home), run after 10-volume.sh: Docker's and containerd's data go on the volume.
# Without one, Docker keeps its default location on the root disk.
# Docker 29 fresh installs use the containerd image store: images live under containerd's root (/var/lib/containerd),
# NOT Docker's data-root. So containerd's root is moved to the volume too.
set -euo pipefail
HOMEDIR=${RECIPE_HOME:-/home}
DATA=$HOMEDIR/data/docker
CTR=$HOMEDIR/data/containerd
if [ "$HOMEDIR" != /home ]; then mountpoint -q "$HOMEDIR" || { echo "home volume not mounted: run 10-volume.sh first"; exit 1; }; fi
install -d -m 755 /etc/apt/keyrings
[ -f /etc/apt/keyrings/docker.asc ] || curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc
. /etc/os-release
cat > /etc/apt/sources.list.d/docker.sources <<SRC
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: $VERSION_CODENAME
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
SRC
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
if [ "$HOMEDIR" != /home ]; then
  mkdir -p /etc/docker "$DATA"
  printf '{\n  "data-root": "%s"\n}\n' "$DATA" > /etc/docker/daemon.json
  if ! grep -q "^root = \"$CTR\"" /etc/containerd/config.toml; then
    systemctl stop docker docker.socket containerd
    mkdir -p "$CTR"
    if [ -d /var/lib/containerd ] && [ ! -L /var/lib/containerd ]; then cp -a /var/lib/containerd/. "$CTR/" && rm -rf /var/lib/containerd; fi
    sed -i "1i root = \"$CTR\"" /etc/containerd/config.toml
  fi
  # start containerd and docker only once the volume is mounted (otherwise they'd quietly write to the root disk)
  for u in containerd docker; do
    mkdir -p /etc/systemd/system/$u.service.d
    printf '[Unit]\nRequiresMountsFor=%s\n' "$HOMEDIR" > /etc/systemd/system/$u.service.d/volume.conf
  done
fi
systemctl daemon-reload
systemctl enable --now containerd docker
docker info --format 'docker {{.ServerVersion}}, data-root {{.DockerRootDir}}, driver {{.Driver}}'
grep '^root' /etc/containerd/config.toml || true
docker run --rm hello-world | head -2
