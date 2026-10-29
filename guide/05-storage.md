# 5. Storage

> **Status:** draft. Facts checked against Nectar support and tutorial pages, October 2026.

A Nectar VM has a small root disk. Put your data somewhere that outlives the
VM: a **volume** for working data, **object storage** for sharing and
archiving.

## Overview

| | Root disk | Volume | Object storage | Shared filesystem (Manila) |
|---|---|---|---|---|
| What | the VM's own disk: OS, software, home directories | a block device you attach to one VM, like a USB drive | buckets/containers of files reached over HTTPS (Swift or S3) | a network filesystem several VMs can mount |
| Size | 30 GB (10 GB on `t3` flavours) | what you request | what you request | what you request |
| Persistent? | **No**: deleted with the instance, unless you booted from a volume | Yes, until you delete it | Yes | Yes |
| Shared? | No | One VM at a time, in the same availability zone | Yes, from anywhere, and can be made public | Yes, VMs in the same availability zone |
| Backed up? | No (snapshots are up to you, [08](08-looking-after-it.md)) | No, unless you use the volume backup service | **No** (replicated across 3 availability zones, but not backed up) | TODO(verify) |
| Quota | comes with the flavour | "Location Specific Resources" in your allocation request, per availability zone | included in Resource Bundles (500 GB in Standard) | Location Specific Resources; **Monash and Auckland only** |

Sources: [root disk and boot sources](https://support.ehelp.edu.au/support/solutions/articles/6000222487),
[flavours](https://support.ehelp.edu.au/support/solutions/articles/6000205341),
[Resource Bundles](https://support.ehelp.edu.au/support/solutions/articles/6000272093),
[object storage overview](https://tutorials.rc.nectar.org.au/object-storage/01-overview),
[Manila](https://support.ehelp.edu.au/support/solutions/articles/6000183607).

Standard flavours have no separate ephemeral disk; only some GPU and
huge-memory flavours do.

Rule of thumb: treat the root disk as disposable. Keep code in git, data on a
volume or in object storage, and your setup as a script ([08](08-looking-after-it.md#recipes-age-better-than-snapshots)).

## Volumes

### Get quota

Volume storage is not part of the Resource Bundles. Request it as a
**Location Specific Resource** in your allocation request (or an amendment,
Dashboard → Allocations → My Requests → Amend), for a specific availability
zone, e.g. `tasmania` or `melbourne-qh2`. Ask for it in the same availability
zone you will run your VM in. See [02](02-your-allocation.md) and the
[Resource Bundles page](https://support.ehelp.edu.au/support/solutions/articles/6000272093).

Check your quota at Project → Volumes → Overview, or:

```bash
openstack quota show --volume
```

TODO(verify): exact flag; `openstack quota show` without flags also lists volume `gigabytes`.

### Create and attach

Following the [Nectar volume tutorial](https://tutorials.rc.nectar.org.au/volume-storage/03-create-attach):

1. Find your instance's availability zone: Project → Compute → Instances → click the instance.
2. Project → Volumes → Volumes → **Create Volume**. Give it a name, a size in
   GB, and **the same availability zone as the instance**. A volume in another
   zone can't be attached.
3. In the volume's dropdown, **Manage Attachments** → choose the instance → Attach.

Or from the command line:

```bash
openstack volume create --size 500 --availability-zone <zone> <volname>
openstack server add volume <server> <volname>
```

4. On the VM, see the new disk:

   ```bash
   lsblk
   ```

   It usually appears as `/dev/vdb` or `/dev/vdc`, with no mount point. Check
   the size matches what you created.

### Format (new volumes only)

> **Warning:** `mkfs` erases everything on the device. Only do this to a brand
> new, empty volume. If you are re-attaching a volume that already holds data,
> skip to [Mount](#mount).

If you're not sure, check for an existing filesystem first:

```bash
sudo blkid /dev/vdc        # prints TYPE="ext4" etc. if it is already formatted
```

No output means no filesystem. Then:

```bash
sudo mkfs -t ext4 /dev/vdc
```

### Mount

This guide mounts volumes at `/mnt/data/<name>` (e.g. `/mnt/data/project`, as
used in [07](07-software.md)). The Nectar tutorial uses `/pvol`; either works,
just be consistent.

1. Make the mount point:

   ```bash
   sudo mkdir -p /mnt/data/project
   ```

2. Get the volume's UUID:

   ```bash
   sudo blkid /dev/vdc
   # /dev/vdc: UUID="3f1c...-...." BLOCK_SIZE="4096" TYPE="ext4"
   ```

3. Add a line to `/etc/fstab` (`sudo nano /etc/fstab`):

   ```
   UUID=3f1c...-....  /mnt/data/project  ext4  defaults,nofail  0  2
   ```

   Use the UUID rather than `/dev/vdc`: device names can change when you attach
   volumes in a different order, the UUID doesn't. `nofail` lets the VM boot
   even if the volume isn't attached. (The
   [Nectar tutorial](https://tutorials.rc.nectar.org.au/volume-storage/04-format-mount)
   uses `/dev/vdc /pvol auto defaults,nofail 0 2`.)

4. Mount everything in fstab, and check:

   ```bash
   sudo mount -a
   df -h /mnt/data/project
   ```

   If `mount -a` reports an error, fix `/etc/fstab` before you reboot.

5. Make it yours (or a group's):

   ```bash
   sudo chown ubuntu:ubuntu /mnt/data/project
   ```

   For several users, create a group and give it the directory:

   ```bash
   sudo groupadd lab
   sudo usermod -aG lab <username>
   sudo chgrp lab /mnt/data/project
   sudo chmod 2775 /mnt/data/project   # setgid: new files inherit the group
   ```

### Unmount, detach, delete

Always in this order ([Nectar tutorial](https://tutorials.rc.nectar.org.au/volume-storage/07-unmount-detach)):

1. Stop anything using it (RStudio sessions, containers), then unmount:

   ```bash
   sudo umount /mnt/data/project
   ```

   "target is busy" means something still has files open; `sudo lsof +f -- /mnt/data/project` shows what.
2. Comment out its line in `/etc/fstab` if it is not coming back.
3. Detach: Project → Volumes → Manage Attachments → Detach, or
   `openstack server remove volume <server> <volname>`.
4. Delete, only if you are sure: Project → Volumes → Delete Volume. This is
   irreversible. A volume with snapshots can't be deleted until the snapshots are.

To move a volume to another VM, do steps 1 to 3, attach it to the new VM (same
availability zone), and [mount](#mount) it. Don't format it.

### Resize

Volumes can grow, not shrink ([Nectar tutorial](https://tutorials.rc.nectar.org.au/volume-storage/08-increasing-size)):

1. Unmount and detach (above).
2. Project → Volumes → **Extend Volume**, enter the new size (needs quota), or
   `openstack volume set --size <new-GB> <volname>`.
3. Re-attach, then grow the filesystem before mounting:

   ```bash
   sudo e2fsck -f /dev/vdc
   sudo resize2fs /dev/vdc
   sudo mount -a
   df -h /mnt/data/project
   ```

### Backups

A volume is not backed up by default. Nectar offers a
[volume backup service](https://support.ehelp.edu.au/support/solutions/articles/6000185788)
at all nodes:

```bash
openstack volume backup create --name project-2026-10 --force <volname>
openstack volume backup list
```

`--force` allows backing up an attached volume; for a consistent copy, unmount
first. TODO(verify): whether backups need their own quota, and where they are stored.

A volume snapshot is not a backup: it lives on the same storage and uses
volume quota equal to the volume's size ([08](08-looking-after-it.md#snapshots)).

## Object storage

Object storage holds files ("objects") in containers (S3 calls them buckets),
reached over HTTPS from anywhere, not just your VM. Good for sharing results,
staging inputs, and keeping copies off the VM. It is replicated across three
availability zones but **not backed up**: a deleted object is gone
([overview](https://tutorials.rc.nectar.org.au/object-storage/01-overview)). There is no server-side
encryption ([support](https://support.ehelp.edu.au/support/solutions/articles/6000061932)).

### rclone with the S3 API

Following the [Nectar S3 tutorial](https://tutorials.rc.nectar.org.au/object-storage/06-object-storage-s3):

1. With the OpenStack client set up for your project ([04](04-launch-a-vm.md)), create EC2-style credentials:

   ```bash
   openstack ec2 credentials create
   ```

   Keep the `access` and `secret` values in a password manager. Anyone with
   them can read and write your project's object storage. List or revoke with
   `openstack ec2 credentials list` / `openstack ec2 credentials delete <access>`.

2. Install rclone (`sudo apt install rclone`, or the newer build from
   [rclone.org](https://rclone.org/install/)) and add this to
   `~/.config/rclone/rclone.conf` (`rclone config file` shows the path):

   ```ini
   [nectar_s3]
   type = s3
   provider = Other
   endpoint = https://object-store.rc.nectar.org.au
   access_key_id = <access>
   secret_access_key = <secret>
   ```

3. Use it:

   ```bash
   rclone mkdir nectar_s3:my-bucket
   rclone copy /mnt/data/project/results nectar_s3:my-bucket/results --progress
   rclone ls nectar_s3:my-bucket
   ```

Nectar doesn't support S3 v4 streaming ("aws-chunked") uploads. rclone works
with its defaults; if any S3 client fails with a signature or authorisation
error on upload, look for an option to turn off chunked/streaming uploads, or
add `v2_auth = true` to the rclone remote.

Other S3 tools work with the same endpoint, e.g.
`aws --endpoint-url https://object-store.rc.nectar.org.au s3 ls`, and so do
GDAL (`/vsis3/` with `AWS_S3_ENDPOINT=object-store.rc.nectar.org.au`) and R
packages built on it. TODO(verify): GDAL may also need `AWS_VIRTUAL_HOSTING=FALSE`.

### swift

The native Swift client uses your OpenStack credentials directly:

```bash
pip install python-swiftclient
swift list                          # containers
swift upload my-container results/  # upload a directory
swift download my-container         # download a container
```

The dashboard (Project → Object Store → Containers) is fine for small files
and for making a container public.

## Network mounts of shared data collections

Some groups make large data collections available to VMs by network mount
(e.g. NFS or SMB), so you can read them without copying. Access is arranged
case by case with the collection's maintainers, not through Nectar. Expect to need:

- the VM's IP address registered with them;
- the right security group on the VM (outbound traffic is open by default, but
  some protocols need inbound rules too);
- possibly a VPN, a key or credentials;
- the VM in a particular availability zone, close to the data.

Ask the maintainers for the mount details, then add the mount to `/etc/fstab`
with `nofail` as above, so the VM still boots if the share is unreachable.

Manila shared filesystems (Monash and Auckland only) are mounted the same way;
see the [Nectar Manila article](https://support.ehelp.edu.au/support/solutions/articles/6000183607).
