# 8. Looking after it

> **Status:** draft. Facts checked against Nectar support and tutorial pages, October 2026.

A VM is yours to run: nobody patches it, backs it up, or tidies it away for
you. This page covers the routine jobs.

## Users

Placeholders: `<username>` is a Linux account on the VM; `<server>` is the
instance name.

### Add a user

```bash
sudo adduser <username>
```

This creates the home directory and prompts for a password. The password is
what they use for RStudio Server ([06](06-rstudio-server.md#8-add-users)).

Nectar images turn off SSH password login (`PasswordAuthentication no`), so
for SSH each user needs a key
([nectar-images ssh role](https://github.com/NeCTAR-RC/nectar-images/blob/master/ansible/roles/ssh/tasks/main.yml)):

1. They run `ssh-keygen -t ed25519` on their own computer and send you the
   **public** key (`~/.ssh/id_ed25519.pub`). Never accept or send a private key.
2. You install it:

   ```bash
   sudo mkdir -p /home/<username>/.ssh
   echo 'ssh-ed25519 AAAA... them@laptop' | sudo tee -a /home/<username>/.ssh/authorized_keys
   sudo chown -R <username>:<username> /home/<username>/.ssh
   sudo chmod 700 /home/<username>/.ssh
   sudo chmod 600 /home/<username>/.ssh/authorized_keys
   ```

3. They log in with `ssh <username>@<ip>`.

To give access to a shared data directory, add them to its group
([05](05-storage.md#mount)): `sudo usermod -aG lab <username>` (takes effect at
their next login).

### sudo, sparingly

`sudo` lets a user do anything, including read everyone's files and break the
machine. Keep it to the one or two people who administer the VM:

```bash
sudo usermod -aG sudo <username>     # grant
sudo deluser <username> sudo         # revoke
getent group sudo                    # who has it
```

Most users never need it: R packages install into their own library, and
containers can be run for them.

### Passwords

```bash
sudo passwd <username>        # set a new password (e.g. they forgot it)
sudo passwd -e <username>     # force a change at next login
```

Users change their own with `passwd`. Send temporary passwords by a different
channel from the username.

### Remove a user

1. Copy off anything worth keeping from `/home/<username>` and their files on
   volumes (`sudo find /mnt/data -user <username>`).
2. Remove the account and home directory:

   ```bash
   sudo deluser --remove-home <username>
   ```

   To lock an account without deleting it: `sudo usermod -L -e 1 <username>`.

## Updates

### Automatic security updates

Official Nectar Ubuntu and Debian images ship with `unattended-upgrades`
enabled, installing **security updates only**, daily
([nectar-images unattended-upgrades role](https://github.com/NeCTAR-RC/nectar-images/tree/master/ansible/roles/unattended-upgrades)).
Check:

```bash
cat /etc/apt/apt.conf.d/20auto-upgrades
# APT::Periodic::Unattended-Upgrade "1";
sudo unattended-upgrades --dry-run -v | head
```

If it's missing (another image, or you turned it off):

```bash
sudo apt install unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades    # answer Yes
```

It does not reboot the VM for you.

### Everything else, by hand

Do this every month or so, and before installing anything big:

```bash
sudo apt update
sudo apt full-upgrade
sudo apt autoremove
```

`full-upgrade` is like `upgrade` but may also add or remove packages to
complete an upgrade (typical for new kernels). Read what it proposes to
remove before saying yes.

### Reboot when needed

Kernel and core library updates only take effect after a reboot:

```bash
cat /var/run/reboot-required 2>/dev/null       # exists if a reboot is needed
cat /var/run/reboot-required.pkgs 2>/dev/null  # which packages asked for it
```

Warn your users, then `sudo reboot`. Volumes in `/etc/fstab` remount
automatically ([05](05-storage.md#mount)); check with `df -h` afterwards.

R and Python packages are not touched by `apt` unless installed from it; see
[07](07-software.md).

## Costs: shut off vs shelve

Every running instance uses Service Units (SU) per hour, and **a shut-off
instance still uses SU**. Only shelving or deleting it stops the meter
([SU and usage](https://support.ehelp.edu.au/support/solutions/articles/6000257023)).

If the VM will be idle for weeks, shelve it:

```bash
openstack server shelve <server>
openstack server unshelve <server>   # when you need it again
```

or Project → Compute → Instances → Shelve Instance.

Shelving snapshots the root disk and frees the hypervisor. Attached volumes
and object storage are untouched. Unshelving takes a few minutes, longer for
big disks. TODO(verify): whether a Classic Provider instance keeps its public
IP across shelve/unshelve; if not, update its DNS record ([06](06-rstudio-server.md)).

## Snapshots

### Instance snapshots

An instance snapshot is an image of the **root disk only**, not attached
volumes ([Nectar tutorial](https://tutorials.rc.nectar.org.au/snapshots/02-instance-snapshots)).
Take one before risky changes (a release upgrade, a big reconfiguration):

```bash
openstack server image create --name <server>-2026-10-29 <server>
openstack image list --private
```

You can launch a new instance from it (Launch Instance → Source: Instance Snapshot).

### Volume snapshots

A volume snapshot uses volume quota equal to the volume's size, and a volume
can't be deleted while it has snapshots
([Nectar tutorial](https://tutorials.rc.nectar.org.au/snapshots/06-volume-storage-snapshots)).

```bash
openstack volume snapshot create --volume <volname> --force <volname>-2026-10-29
```

For real backups of data, use the volume backup service or copy to object
storage ([05](05-storage.md#backups)).

### Share a snapshot with another project

E.g. to give a colleague's project a copy of your set-up, or to move to a new
allocation ([image sharing](https://support.ehelp.edu.au/support/solutions/articles/6000106269)):

1. You (owner):

   ```bash
   openstack image set --shared <image>
   openstack image add project <image> <their-project-id>
   ```

   (The older form is `glance member-create <image-id> <project-id>`.)
2. They accept it, from their project:

   ```bash
   openstack image set --accept <image-id>
   ```

It then shows in their image list. Shared snapshots survive the deletion of
your project at allocation expiry
([expiry](https://support.ehelp.edu.au/support/solutions/articles/6000171494)).

### Recipes age better than snapshots

A snapshot is a frozen machine: old OS, old packages, and nobody remembers
what was done to it. A script records what you did and can be re-run on a
fresh, current image.

- Keep your setup as a script in git (e.g. `setup.sh`: `apt install` lines,
  R/Python installs, users, fstab entries, nginx config).
- Each time you do something by hand on the VM, add it to the script.
- Test it now and then by launching a fresh VM and running it.
- You can pass the script as a **Customization Script** (user data) when you
  launch an instance, and cloud-init runs it at first boot.

Then a snapshot is just a convenience, and losing the VM costs you an hour,
not a month.

## Instance metadata

Inside the VM, OpenStack's metadata service tells you about the instance
([OpenStack metadata docs](https://docs.openstack.org/nova/latest/user/metadata.html)):

```bash
# the Customization Script (user data) you launched with
curl -s http://169.254.169.254/openstack/latest/user_data

# instance name, UUID, availability zone, keypair, project ID
curl -s http://169.254.169.254/openstack/latest/meta_data.json | python3 -m json.tool

# network configuration
curl -s http://169.254.169.254/openstack/latest/network_data.json | python3 -m json.tool
```

The older EC2-style paths (`http://169.254.169.254/latest/meta-data/`,
`.../latest/user-data`) still work. These addresses only answer from inside
the instance.

Handy in scripts, e.g. to find the availability zone before creating a volume:

```bash
curl -s http://169.254.169.254/openstack/latest/meta_data.json \
  | python3 -c 'import json,sys; print(json.load(sys.stdin)["availability_zone"])'
```

## Allocation expiry and handing back

Allocations last up to 12 months. As expiry approaches you get warnings, then
quota drops to zero, then instances are stopped, snapshotted and terminated,
and finally everything is deleted. See [02](02-your-allocation.md) for the
timeline and how to extend, and the
[Nectar expiry article](https://support.ehelp.edu.au/support/solutions/articles/6000171494).
Submitting an extension request pauses the process.

Don't rely on the automatic clean-up. To hand back cleanly:

1. **Tell your users** and agree a date.
2. **Copy data off**: from volumes and home directories to object storage,
   your institution's storage, or another project. Check the copy
   (`rclone check`, file counts, sizes).
3. **Save the recipe**: make sure your setup script and any config (nginx,
   fstab, crontab) are in git.
4. **Delete instances**: Project → Compute → Instances → Delete, or
   `openstack server delete <server>`.
5. **Delete volume snapshots, then volumes**:

   ```bash
   openstack volume snapshot list
   openstack volume snapshot delete <snapshot>
   openstack volume list
   openstack volume delete <volname>
   ```

6. **Delete instance snapshots** you no longer need (`openstack image list --private`,
   `openstack image delete <image>`), and stop sharing any you shared.
7. **Empty object storage** you no longer need (`rclone purge nectar_s3:my-bucket`,
   or `swift delete <container>`). Public containers survive project deletion,
   so don't leave data public by accident.
8. **Release DNS records** so the names don't point at an IP someone else may get:

   ```bash
   openstack recordset list <project>.cloud.edu.au.
   openstack recordset delete <project>.cloud.edu.au. <server>.<project>.cloud.edu.au.
   ```

   If you used your own domain, remove its records at your DNS provider.
9. **Revoke credentials**: `openstack ec2 credentials delete <access>`, and
   delete application credentials (Identity → Application Credentials).
10. Tell the node or [support](mailto:support@nectar.org.au) you're done, if
    the allocation is still running. TODO(verify): whether there is a formal
    "close allocation" step in the dashboard.
