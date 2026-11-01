#!/bin/bash
# 10: format (first time only) and mount the home volume at $RECIPE_HOME (default /mnt/data/home). Optional layer.
# Usage (as root): 10-volume.sh <openstack-volume-id>
# Finds the disk by its virtio serial (the first 20 chars of the volume ID), not by /dev/vdX, and mounts it by UUID
# with nofail, so a missing volume never blocks boot. Never formats a disk that already has a filesystem.
set -euo pipefail
VOLID=${1:?volume id}
MNT=${RECIPE_HOME:-/mnt/data/home}
DEV=/dev/disk/by-id/virtio-${VOLID:0:20}
for i in $(seq 30); do [ -e "$DEV" ] && break; sleep 2; done
[ -e "$DEV" ] || { echo "no disk for volume $VOLID"; exit 1; }
DEV=$(readlink -f "$DEV")
if ! blkid "$DEV" >/dev/null; then
  echo "formatting $DEV (empty)"; mkfs.ext4 -q -L home "$DEV"
fi
UUID=$(blkid -s UUID -o value "$DEV")
mkdir -p "$MNT"
grep -q "UUID=$UUID" /etc/fstab || echo "UUID=$UUID $MNT ext4 defaults,nofail,x-systemd.device-timeout=30 0 2" >> /etc/fstab
systemctl daemon-reload
mountpoint -q "$MNT" || mount "$MNT"
mkdir -p "$MNT/data"
findmnt "$MNT"
