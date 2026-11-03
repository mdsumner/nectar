#!/bin/bash
# build.sh (relay): runs the relay layers in order, as root. Settings from the environment or ./config beside this script:
#   FQDN, EMAIL   public web address + Let's Encrypt contact (required: the relay is useless without https)
#   ./hosts       optional allow-list, one host per line (default: NSIDC and Bremen sea ice servers)
# Log: /var/log/recipe-build.log. Status: /var/lib/recipe-status (running, failed <layer>, done).
set -uo pipefail
cd "$(dirname "$(readlink -f "$0")")"
[ -f config ] && . ./config
exec > >(tee -a /var/log/recipe-build.log) 2>&1
export HOME=/root DEBIAN_FRONTEND=noninteractive
FQDN=${FQDN:-} EMAIL=${EMAIL:-}
echo 'DPkg::Lock::Timeout "900";' > /etc/apt/apt.conf.d/99lock-timeout
echo running > /var/lib/recipe-status
run() { echo "=== $(date -u +%T) start $*"
        if bash "layers/$1" "${@:2}"; then echo "=== $(date -u +%T) ok $1"
        else echo "=== $(date -u +%T) FAILED $1"; echo "failed $1" > /var/lib/recipe-status; exit 1; fi; }
run 10-relay.sh "$( [ -s hosts ] && echo "$PWD/hosts" )"
if [ -n "$FQDN" ]; then
  me=$(ip -4 route get 1.1.1.1 | grep -oP 'src \K\S+')
  echo "=== waiting up to 5 min for $FQDN -> $me (after that, recipe-cert.timer keeps retrying)"
  for i in $(seq 30); do [ "$(getent ahostsv4 "$FQDN" | awk 'NR==1{print $1}')" = "$me" ] && break; sleep 10; done
  run 50-nginx.sh "$FQDN" $EMAIL
else
  echo "=== no FQDN: relay is on 127.0.0.1:8787 only; set FQDN (and a DNS record) to serve it over https"
fi
run 70-check.sh
echo done > /var/lib/recipe-status
echo "=== $(date -u +%T) all layers done"
