#!/bin/bash
# 41: RStudio Server. Multi-user via PAM (real Linux accounts), listening on localhost only: reach it with an SSH tunnel, or nginx (layer 50).
# Usage (as root), after 40-r.sh:  41-rstudio.sh [release|daily]   (default: daily, from RStudio's daily-build index)
# The daily index maps each Ubuntu release (jammy, noble, resolute) to a .deb; currently the same jammy-built deb.
# In a container (no systemd: the image build) it only installs: there's no service, and JupyterLab starts rserver
# itself per user, through jupyter-rsession-proxy (43-jupyter.sh).
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
. /etc/os-release
CHANNEL=${1:-daily}
if [ "$CHANNEL" = daily ]; then
  URL=$(curl -fsSL https://dailies.rstudio.com/rstudio/latest/index.json | python3 -c \
    "import sys,json; print(json.load(sys.stdin)['products']['server']['platforms']['$VERSION_CODENAME-amd64']['link'])")
else
  URL=${RSTUDIO_DEB_URL:?set RSTUDIO_DEB_URL for a release build}
fi
DEB=/tmp/$(basename "$URL")
echo "== $URL"
if [ "$(dpkg-query -W -f='${Version}' rstudio-server 2>/dev/null)" != "$(basename "$URL" | sed -E 's/rstudio-server-(.*)-amd64.deb/\1/')" ]; then
  curl -fsSL "$URL" -o "$DEB"
  apt-get update -qq
  apt-get install -y -qq "$DEB"
fi
if [ ! -d /run/systemd/system ]; then rstudio-server version; exit 0; fi
cat > /etc/rstudio/rserver.conf <<'CONF'
# nectar-recipes: localhost only; nginx terminates HTTPS and proxies to 8787
www-address=127.0.0.1
www-port=8787
CONF
systemctl restart rstudio-server
sleep 2
rstudio-server version
systemctl is-active rstudio-server
curl -s -o /dev/null -w 'localhost:8787 -> HTTP %{http_code}\n' http://127.0.0.1:8787/
