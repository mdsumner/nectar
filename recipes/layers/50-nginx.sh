#!/bin/bash
# 50: nginx in front of RStudio Server at https://<fqdn>/rstudio/ (static page at /), Let's Encrypt certificate via certbot.
# Usage (as root), after 41-rstudio.sh:  50-nginx.sh <fqdn> [letsencrypt-email]
# The certificate step runs only when <fqdn> resolves to this host's public IP and port 80 is reachable
# (a security group opening 80/443). Until then nginx serves plain http, and a systemd timer (recipe-cert.timer)
# reruns this script every 5 min; it switches itself off once the certificate is in place.
set -euo pipefail
FQDN=${1:?fqdn, e.g. myhost.myproject.cloud.edu.au}
EMAIL=${2:-}
export DEBIAN_FRONTEND=noninteractive
apt-get install -y -qq nginx certbot python3-certbot-nginx bind9-dnsutils

cat > /etc/nginx/sites-available/rstudio <<CONF
# nectar-recipes: RStudio Server under /rstudio/ (https://docs.posit.co/ide/server-pro/access_and_security/running_with_a_proxy.html)
map \$http_upgrade \$connection_upgrade {
    default upgrade;
    ''      close;
}
server {
    listen 80;
    listen [::]:80;
    server_name $FQDN;
    root /var/www/html;
    index index.html;
    location / { try_files \$uri \$uri/ =404; }
    location = /rstudio { return 301 \$scheme://\$host/rstudio/; }
    location /rstudio/ {
        rewrite ^/rstudio/(.*)\$ /\$1 break;
        proxy_pass http://127.0.0.1:8787;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection \$connection_upgrade;
        proxy_set_header Host \$host;
        proxy_set_header X-RStudio-Root-Path /rstudio;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_read_timeout 20d;
        proxy_buffering off;
        client_max_body_size 0;
    }
}
CONF
ln -sf /etc/nginx/sites-available/rstudio /etc/nginx/sites-enabled/rstudio
rm -f /etc/nginx/sites-enabled/default
[ -f /var/www/html/index.html ] && grep -q nectar-recipes /var/www/html/index.html || \
  printf '<!doctype html><!-- nectar-recipes --><title>%s</title><p><a href="/rstudio/">RStudio Server</a></p>\n' "$FQDN" > /var/www/html/index.html
nginx -t
systemctl reload nginx; sleep 1
curl -s -o /dev/null -w "http://localhost/rstudio/ -> HTTP %{http_code} (%{redirect_url})\n" -H "Host: $FQDN" http://127.0.0.1/rstudio/

echo "== certificate"
# Nectar puts the public IP on the interface (the metadata service has no public-ipv4); behind NAT, ask outside
PUB=$(ip -4 route get 1.1.1.1 | grep -oP 'src \K\S+')
case "$PUB" in 10.*|172.1[6-9].*|172.2?.*|172.3[01].*|192.168.*) PUB=$(curl -fs --max-time 5 https://ifconfig.me || true);; esac
# ask the zone's own nameserver: resolvers cache "no such name" for the zone's negative TTL (an hour on Nectar zones),
# so a record added after the first lookup would otherwise stay invisible for that long
lookup() { local ns; ns=$(dig +short NS "${1#*.}" 2>/dev/null | head -1)
           if [ -n "$ns" ]; then dig +short A "$1" @"$ns" | head -1; else getent ahostsv4 "$1" | awk 'NR==1{print $1}'; fi; }
DNS=$(lookup "$FQDN" || true)
if [ -z "$DNS" ] || [ "$DNS" != "$PUB" ]; then
  echo "SKIPPED: $FQDN resolves to '${DNS:-nothing}', this host is $PUB."
  # retry every 5 min until DNS points here; the timer switches itself off once the certificate exists
  SELF=$(readlink -f "$0")
  cat > /etc/systemd/system/recipe-cert.service <<UNIT
[Unit]
Description=nectar-recipes: get the Let's Encrypt certificate once DNS points here
After=network-online.target
[Service]
Type=oneshot
ExecStart=/bin/bash $SELF $FQDN $EMAIL
UNIT
  cat > /etc/systemd/system/recipe-cert.timer <<UNIT
[Unit]
Description=retry recipe-cert every 5 min
[Timer]
OnBootSec=2min
OnUnitActiveSec=5min
[Install]
WantedBy=timers.target
UNIT
  systemctl daemon-reload
  systemctl enable --now recipe-cert.timer >/dev/null 2>&1
  echo "recipe-cert.timer will retry every 5 min: add the DNS A record $FQDN -> $PUB"; exit 0
fi
if [ -d "/etc/letsencrypt/live/$FQDN" ]; then echo "certificate exists; certbot renews it on its timer"
else
  certbot --nginx -d "$FQDN" --non-interactive --agree-tos --redirect \
    $([ -n "$EMAIL" ] && echo "-m $EMAIL" || echo "--register-unsafely-without-email")
fi
systemctl reload nginx
systemctl disable --now recipe-cert.timer >/dev/null 2>&1 || true
curl -s -o /dev/null -w "https://$FQDN/rstudio/ -> HTTP %{http_code}\n" "https://$FQDN/rstudio/"
