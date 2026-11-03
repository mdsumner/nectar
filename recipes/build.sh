#!/bin/bash
# build.sh: runs the layers in order, as root, on the new server. Both ways in end here: bootstrap.sh (dashboard) and
# launch.sh (command line). Settings come from the environment, or ./config beside this script:
#   RECIPE_HOME  where homes live (default /home; with a volume, /mnt/data/home)    VOLID     OpenStack volume to mount there
#   FQDN, EMAIL  public web address + Let's Encrypt contact (default: none, SSH tunnel only)
#   RUST=1       add the Rust toolchain                                             ./users.tsv  accounts (replaces the `rstudio` login)
# Log: /var/log/recipe-build.log. Status: /var/lib/recipe-status (running, failed <layer>, done).
set -uo pipefail
cd "$(dirname "$(readlink -f "$0")")"
[ -f config ] && . ./config
exec > >(tee -a /var/log/recipe-build.log) 2>&1
export HOME=/root DEBIAN_FRONTEND=noninteractive
VOLID=${VOLID:-} FQDN=${FQDN:-} EMAIL=${EMAIL:-} RUST=${RUST:-}
[ -n "$VOLID" ] && : "${RECIPE_HOME:=/mnt/data/home}"
export RECIPE_HOME=${RECIPE_HOME:-/home}
echo 'DPkg::Lock::Timeout "900";' > /etc/apt/apt.conf.d/99lock-timeout   # first boot: unattended-upgrades holds the lock
echo running > /var/lib/recipe-status
run() { echo "=== $(date -u +%T) start $*"
        if bash "layers/$1" "${@:2}"; then echo "=== $(date -u +%T) ok $1"
        else echo "=== $(date -u +%T) FAILED $1"; echo "failed $1" > /var/lib/recipe-status; exit 1; fi; }
[ -n "$VOLID" ] && run 10-volume.sh "$VOLID"
run 20-docker.sh
run 30-gdal.sh
run 40-r.sh
run 41-rstudio.sh
[ -n "$RUST" ] && run 42-rust.sh
if [ -s users.tsv ] && grep -qvE '^\s*(#|$)' users.tsv; then run 60-users.sh users.tsv; else run 45-login.sh; fi
# ask the zone's own nameserver: resolvers cache "no such name" for the zone's negative TTL (an hour on Nectar zones),
# so a record added after the first lookup would otherwise stay invisible for that long
lookup() { local ns; ns=$(dig +short NS "${1#*.}" 2>/dev/null | head -1)
           if [ -n "$ns" ]; then dig +short A "$1" @"$ns" | head -1; else getent ahostsv4 "$1" | awk 'NR==1{print $1}'; fi; }
if [ -n "$FQDN" ]; then
  me=$(ip -4 route get 1.1.1.1 | grep -oP 'src \K\S+')
  echo "=== waiting up to 5 min for $FQDN -> $me (after that, recipe-cert.timer keeps retrying)"
  for i in $(seq 30); do [ "$(lookup "$FQDN")" = "$me" ] && break; sleep 10; done
  run 50-nginx.sh "$FQDN" $EMAIL
fi
run 70-check.sh
echo done > /var/lib/recipe-status
echo "=== $(date -u +%T) all layers done"
