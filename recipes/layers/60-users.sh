#!/bin/bash
# 60: login accounts for RStudio (PAM) and SSH, from a users file.
# Usage (as root):  60-users.sh users.tsv
# Each line:  name  uid  gid  groups  home      ('-' = let the system choose; '#' starts a comment)
#   Simple:    alice  -     -     -        -     -> next free uid/gid, home $RECIPE_HOME/alice
#   Recreate:  alice 1001 1002 sudo,docker /mnt/data/home/alice   (uid/gid copied from an old host)
# Recreating keeps uid/gid, so homes on a moved volume keep their owners. An existing home dir is kept as is;
# a missing one is created (mode 750 from login.defs). Unknown groups are skipped with a note.
# New accounts are locked until a password is set (passwd/chpasswd) or a key is added.
# Idempotent: existing accounts are checked (uid must match) and only get missing groups added.
set -euo pipefail
FILE=${1:?users file}
rc=0
while read -r name uid gid groups home; do
  [[ -z "${name:-}" || "$name" == \#* ]] && continue
  [[ -z "${home:-}" || "$home" == - ]] && home=${RECIPE_HOME:-/home}/$name
  # supplementary groups that exist here
  keep=()
  for g in ${groups//,/ }; do [ "$g" = - ] && continue
    if getent group "$g" >/dev/null; then keep+=("$g"); else echo "  $name: group $g not on this host, skipped"; fi
  done
  G=$(IFS=,; echo "${keep[*]:-}")
  if id "$name" >/dev/null 2>&1; then
    if [ "$uid" != - ] && [ "$(id -u "$name")" != "$uid" ]; then echo "!! $name exists with uid $(id -u "$name"), wanted $uid"; rc=1; continue; fi
    [ -n "$G" ] && usermod -aG "$G" "$name"
    echo "ok   $name (exists) $(id "$name")"; continue
  fi
  args=(-s /bin/bash -d "$home")
  if [ "$uid" != - ]; then
    if getent passwd "$uid" >/dev/null; then echo "!! $name: uid $uid already used by $(getent passwd "$uid" | cut -d: -f1)"; rc=1; continue; fi
    args+=(-u "$uid")
  fi
  if [ "$gid" != - ]; then
    if ! getent group "$gid" >/dev/null; then groupadd -g "$gid" "$name"
    elif [ "$(getent group "$gid" | cut -d: -f1)" != "$name" ]; then echo "!! $name: gid $gid already used by group $(getent group "$gid" | cut -d: -f1)"; rc=1; continue; fi
    args+=(-g "$gid")
  else
    args+=(-U)
  fi
  [ -n "$G" ] && args+=(-G "$G")
  if [ -d "$home" ]; then args+=(-M); else args+=(-m); fi
  useradd "${args[@]}" "$name"
  echo "new  $name $(id "$name")  home $(stat -c '%U:%G %a' "$home")"
done < "$FILE"
exit $rc
