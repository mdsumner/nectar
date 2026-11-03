#!/bin/bash
# 10: the relay itself: one Python file as a systemd service on 127.0.0.1:8787, allow-list in /etc/cors-relay/hosts.
# Usage (as root):  10-relay.sh [hosts-file]   (default allow-list is NSIDC and Bremen sea ice; edit the file to add hosts)
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive
apt-get install -y -qq python3-aiohttp
install -d /opt/cors-relay /etc/cors-relay
install -m 644 "$(dirname "$0")/../cors_relay.py" /opt/cors-relay/cors_relay.py
if [ -n "${1:-}" ] && [ -s "$1" ]; then install -m 644 "$1" /etc/cors-relay/hosts
elif [ ! -f /etc/cors-relay/hosts ]; then
  cat > /etc/cors-relay/hosts <<'HOSTS'
# cors-relay: hosts the relay will fetch from, one per line. Read on every request; no restart needed.
noaadata.apps.nsidc.org
data.seaice.uni-bremen.de
HOSTS
fi
cat > /etc/systemd/system/cors-relay.service <<'UNIT'
[Unit]
Description=cors-relay: allow-listed byte-range pass-through with CORS headers
After=network-online.target
[Service]
DynamicUser=yes
ExecStart=/usr/bin/python3 /opt/cors-relay/cors_relay.py 8787
Restart=always
RestartSec=3
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable --now cors-relay
sleep 1
curl -fs http://127.0.0.1:8787/healthz
