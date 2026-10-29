# 4. Launch a VM

> **Status:** draft. Checked against Nectar support and tutorial pages, October 2026.

The details behind the six steps on the [front page](../README.md#what-do-i-actually-do).
They take you from nothing to logging in to your own Ubuntu VM. Steps 3 and 4 are
done once per project; after that, each new VM is one launch.

Nothing here is precious. If a VM doesn't work, delete it and launch another.

Placeholders: `<ip>` is the VM's public IP address, `<az>` is an availability
zone, `<name>` is the instance name or a username (each step says which).

## 1. Log in to the dashboard

Go to the [dashboard](https://dashboard.rc.nectar.org.au), choose **Login via AAF**
(Australia) or **Login via Tuakiri** (New Zealand), and use your university
login. More, including what to do if your organisation isn't in AAF:
[Your allocation](02-your-allocation.md#logging-in).

## 2. Check your allocation

The project menu at the top left shows which project you're working in. After your
first login it's your Project Trial, `pt-NNNN`: up to 4 cores, for 6 months
([details](02-your-allocation.md#your-project-trial)). Project > Compute >
Overview shows how much of its quota is in use.

If you've been given a different project, choose it from that menu.

## 3. Create a keypair

Nectar images have no default passwords. You log in with an SSH key
([Nectar: keypairs](https://tutorials.rc.nectar.org.au/keypairs/03-ssh-keygen)).

1. On your own computer (Linux, macOS, or Windows PowerShell, which includes
   OpenSSH), run:

   ```bash
   ssh-keygen -t ed25519
   ```

   Accept the default location (`~/.ssh/id_ed25519`, or
   `C:\Users\<you>\.ssh\id_ed25519` on Windows) and set a passphrase.
2. In the [dashboard](https://dashboard.rc.nectar.org.au), go to
   Project > Compute > Key Pairs > **Import Public Key**. Give the key a
   name and paste in the contents of `id_ed25519.pub`. Paste the `.pub`
   file, never the private key.

The private key (`id_ed25519`, no `.pub`) stays on your computer. Don't
email it, copy it to shared drives, or commit it anywhere. If you lose it, you
can't log in to VMs launched with it: make a new key and launch new VMs.

On Windows, [MobaXterm](https://mobaxterm.mobatek.net/) is an alternative with a
built-in terminal, SSH client and file browser. It can use the same key.

## 4. Allow SSH in (security groups)

A security group is a firewall rule set attached to an instance. Inbound
traffic is blocked unless a rule allows it. Rules add up across groups, and
outbound traffic is open
([Nectar: security groups](https://support.ehelp.edu.au/support/solutions/articles/6000055387)).

An allocated project starts with one group, `default`. It has no inbound rules
and is **shared by every member of the project**, so don't add rules to it.
Create your own groups instead
(Project > Network > Security Groups > **Create Security Group**, then
**Manage Rules** > **Add Rule**;
[Nectar tutorial](https://tutorials.rc.nectar.org.au/sec-groups-101/03-create)):

| Group | Rule | Remote (CIDR) |
|---|---|---|
| `ssh` | SSH (TCP 22) | ideally your institution's network range rather than `0.0.0.0/0` |
| `http` | HTTP (TCP 80) | `0.0.0.0/0` |
| `https` | HTTPS (TCP 443) | `0.0.0.0/0` |

You only need `http` and `https` if the VM serves web pages, such as RStudio
Server behind nginx ([06](06-rstudio-server.md)).

**Never open port 8787 (RStudio Server) to the world.** Logins would cross
the network unencrypted. [06](06-rstudio-server.md) puts RStudio behind
HTTPS instead.

A Project Trial (`pt-NNNN`) comes with ready-made SSH, HTTP and ICMP groups,
so there you can skip this step and just pick the SSH group at launch.

## 5. Launch the instance

Go to Project > Compute > Instances > **Launch Instance**
([Nectar tutorial](https://tutorials.rc.nectar.org.au/launching-virtual-machines/02-launch-dialog)).
Work through the dialog's tabs:

1. **Details:** an instance name (`<name>`), and the availability zone.
   "Any Availability Zone" is fine, *unless* you'll attach a volume. A volume
   can only attach to an instance in the same zone, so pick that zone here
   (see [05](05-storage.md)). Some allocations are limited to one node's
   zones.
2. **Source:** Boot Source "Image". Filter for and select
   `NeCTAR Ubuntu 24.04 LTS (Noble) amd64`. The Nectar tutorials still show
   20.04, which is out of standard support, so don't copy it. A 26.04 image
   is in Nectar's [image build repo](https://github.com/NeCTAR-RC/nectar-images/tree/master/vars).
   TODO(verify): whether 26.04 appears in the dashboard yet.
   If asked "Create New Volume", choose **No** unless you want a volume-backed
   root disk (it uses volume quota; see [05](05-storage.md)).
3. **Flavour:** pick a size that fits your quota (see [03](03-sizing.md)),
   e.g. `m3.small` in a Project Trial, or `m3.medium`.
4. **Networks:** `Classic Provider`. This gives the instance a public IPv4
   address directly
   ([Nectar: classic vs advanced networking](https://tutorials.rc.nectar.org.au/advanced-networking/03-classic-vs-advanced-networking)).
5. **Security Groups:** add `ssh` (and `http`, `https` if needed). You can
   leave `default` attached, because it adds nothing inbound.
6. **Key Pair:** select the key you imported. Don't skip this. The key is put
   on the VM when it's first created, so a VM launched without one can't be
   logged in to. Delete it and launch again.

Click **Launch Instance**. The status goes from Build to Active in a minute or
two.

## 6. Connect with SSH

The IP is in the IP Address column of Project > Compute > Instances. From your
own computer:

```bash
ssh -i ~/.ssh/id_ed25519 ubuntu@<ip>
```

The first time, SSH asks you to confirm the host's fingerprint. Type `yes`. If
it says "Connection refused" or times out, wait a minute (the VM may still be
booting) and check that the `ssh` group is attached and allows your network.

The login user depends on the image
([Nectar: images](https://support.ehelp.edu.au/support/solutions/articles/6000106269)):

| Image | User |
|---|---|
| Ubuntu | `ubuntu` |
| Debian | `debian` |
| Rocky Linux | `rocky` |
| AlmaLinux | `almalinux` |
| Fedora | `fedora` |
| CentOS (old) | `ec2-user` |

## First steps on the VM

1. Update everything, then reboot:

   ```bash
   sudo apt update && sudo apt full-upgrade
   sudo reboot
   ```

   Wait a minute and log in again.
2. Create a normal user for yourself (and one for each other person):

   ```bash
   sudo adduser <name>
   ```

   Add `sudo usermod -aG sudo <name>` only for people who administer the
   machine.
3. To let that user log in over SSH with your key, copy it across:

   ```bash
   sudo mkdir -p /home/<name>/.ssh
   sudo cp ~/.ssh/authorized_keys /home/<name>/.ssh/
   sudo chown -R <name>:<name> /home/<name>/.ssh
   sudo chmod 700 /home/<name>/.ssh
   ```

   Each person should really use their own key: append their `.pub` to their
   own `authorized_keys`.

Next: storage ([05](05-storage.md)), RStudio Server ([06](06-rstudio-server.md)),
software ([07](07-software.md)).

## Same thing from the command line

After you've done this a few times, the OpenStack client is quicker and easy
to script. It runs on your laptop (Windows: use WSL) or on another VM.

### Install the client

Use a Python virtual environment
([Nectar: OpenStack client](https://tutorials.rc.nectar.org.au/openstack-cli/02-openstack-client)):

```bash
python3 -m venv ~/venvs/openstack
source ~/venvs/openstack/bin/activate
pip install python-openstackclient
```

Run `source ~/venvs/openstack/bin/activate` again in each new shell.

### Load credentials

- **Application credential (preferred).** In the dashboard, select the
  project, then Identity > Application Credentials > Create. Download the
  openrc file (or `clouds.yaml`). It is tied to one project, can be revoked,
  and doesn't expose your password
  ([Nectar: application credentials](https://tutorials.rc.nectar.org.au/application-credentials/03-using-app-credentials)).

  ```bash
  source app-cred-<name>-openrc.sh
  # or, with clouds.yaml in ~/.config/openstack/:
  export OS_CLOUD=openstack
  ```

- **Project RC file.** Click your email address (top right) > OpenStack RC
  File. It prompts for your *OpenStack password*, which is separate from your
  institutional login: set it under Settings > Reset Password
  ([Nectar: credentials](https://tutorials.rc.nectar.org.au/openstack-cli/04-credentials)).

Start from a fresh shell, or unset any old `OS_*` variables, so that two sets
of credentials don't mix. Never commit these files to a repository.

### Look around

```bash
openstack server list
openstack flavor list
openstack image list --property owner=28eadf5ad64b42a4929b2fb7df99275c   # official Nectar images
openstack availability zone list
openstack keypair list
openstack security group list
```

The owner ID is Nectar's Public-Images project
([Nectar: images](https://support.ehelp.edu.au/support/solutions/articles/6000106269)).
To narrow the list, add `--name "NeCTAR Ubuntu 24.04 LTS (Noble) amd64"`.

### Create the security groups

```bash
openstack security group create ssh
openstack security group rule create --protocol tcp --dst-port 22 --remote-ip <your-cidr> ssh
openstack security group create https
openstack security group rule create --protocol tcp --dst-port 443 --remote-ip 0.0.0.0/0 https
```

Do the same for `http` with port 80.

### Upload your key and launch

```bash
openstack keypair create --public-key ~/.ssh/id_ed25519.pub <keyname>

openstack server create \
  --image "NeCTAR Ubuntu 24.04 LTS (Noble) amd64" \
  --flavor m3.medium \
  --network "Classic Provider" \
  --key-name <keyname> \
  --security-group ssh \
  --availability-zone <az> \
  <name>
```

Repeat `--security-group` for each group. Leave out `--availability-zone` if
you don't need a particular zone. Nectar's CLI tutorial doesn't include a
`server create` example; these are the standard OpenStack client options.
TODO(verify): run this against Nectar and confirm the network name
`Classic Provider` is accepted as written.

Then get the IP and log in:

```bash
openstack server show <name> -c status -c addresses
ssh -i ~/.ssh/id_ed25519 ubuntu@<ip>
```

## Shut off still costs Service Units

A VM that is **shut off still uses your SU budget**. Only shelving or deleting
it stops the use
([Nectar: Service Units](https://support.ehelp.edu.au/support/solutions/articles/6000257023)).
If a VM will sit idle for weeks:

```bash
openstack server shelve <name>     # saves it as a snapshot and frees the resources
openstack server unshelve <name>   # brings it back later
```

(Dashboard: the instance's Actions menu > Shelve Instance.) Unshelving takes a
few minutes. TODO(verify): whether a Classic Provider instance keeps its IP
address after unshelving. If it changes, update any DNS record
([06](06-rstudio-server.md)).

Delete a VM you no longer need, after saving anything on it. See
[08](08-looking-after-it.md) for snapshots, shelving and handing a machine back.
