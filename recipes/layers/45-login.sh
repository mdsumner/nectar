#!/bin/bash
# 45: a login for RStudio. Creates the unprivileged account `rstudio` with a random password, saved for the admin in
# /home/ubuntu/rstudio-password (mode 600). The `ubuntu` admin account keeps its key-only login. Rerun: no change.
# Skipped by build.sh when a users file is given.
set -euo pipefail
PWFILE=/home/ubuntu/rstudio-password
HOMEDIR=${RECIPE_HOME:-/home}
id rstudio >/dev/null 2>&1 || useradd -m -s /bin/bash -d "$HOMEDIR/rstudio" rstudio
if [ ! -f "$PWFILE" ]; then
  PW=$(openssl rand -base64 18 | tr -d '/+=')
  ( umask 077; printf '%s\n' "$PW" > "$PWFILE" )
  chown ubuntu:ubuntu "$PWFILE"
  printf 'rstudio:%s\n' "$PW" | chpasswd
fi
echo "account rstudio ready; password in $PWFILE"
