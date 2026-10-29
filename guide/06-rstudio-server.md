# 6. RStudio Server

> **Status:** draft. Source: `legacy/openstack/create_install_rstudio_openstack.md` and [issue #14](https://github.com/mdsumner/nectar/issues/14), updated against current docs (October 2026).

The goal is RStudio Server at `https://<server>.<project>.cloud.edu.au`, not
`http://<ip>:8787`. Without HTTPS, passwords and data cross the network in
clear text.

The arrangement is:

```
browser ──HTTPS:443──> nginx (on the VM) ──HTTP──> RStudio Server on 127.0.0.1:8787
```

nginx holds the certificate and talks to the outside world. RStudio Server
only listens on the VM itself.

## The easy path: Applications > Quick Deploy R-Studio

If you don't need full control, let Nectar do the setup. In the dashboard,
the Applications tab has a **Quick Deploy** option for R-Studio. It launches a
VM with RStudio Server and Shiny Server already installed. If you choose a DNS
zone during the deploy, you get automatic HTTPS at
`https://<host>.<project>.cloud.edu.au`. You can also add a volume, which must
be in the same availability zone as the VM
([Nectar support: R-Studio application](https://support.ehelp.edu.au/support/solutions/articles/6000164849),
[tutorial: configuring applications](https://tutorials.rc.nectar.org.au/applications/03-configuring)).

Each deploy creates its own security group. Delete these when you delete the
application, or they pile up
([Nectar support: application security groups](https://support.ehelp.edu.au/support/solutions/articles/6000168298)).

The rest of this page is the do-it-yourself route: more steps, but you choose
the versions, the configuration and what else runs on the machine.

Placeholders used below:

| Placeholder | Meaning | Example |
|---|---|---|
| `<project>` | your Nectar project name, which is also your DNS zone | `myproject` |
| `<server>` | the hostname you choose for this VM | `rstudio` |
| `<ip>` | the VM's public IP address (dashboard: Project → Compute → Instances) | `203.0.113.10` |
| `<fqdn>` | `<server>.<project>.cloud.edu.au` | `rstudio.myproject.cloud.edu.au` |
| `<username>` | a user account on the VM | `alice` |

## Before you start

- A running Ubuntu 24.04 LTS VM you can SSH into as `ubuntu`
  ([04](04-launch-a-vm.md)). Ubuntu 26.04 LTS is supported by CRAN and
  Posit, so it should work the same way.
  TODO(verify): whether Nectar currently offers an official Ubuntu 26.04 image.
- Your project has an allocation. Nectar creates a DNS zone named after the
  project (`<project>.cloud.edu.au.`) for new and renewed allocations
  ([Nectar DNS service](https://support.ehelp.edu.au/support/solutions/articles/6000201311-nectar-dns-service)).

## 1. Install R

Follow [CRAN's Ubuntu instructions](https://cloud.r-project.org/bin/linux/ubuntu/).
On the VM:

```bash
sudo apt update -qq
sudo apt install --no-install-recommends software-properties-common dirmngr
wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc \
  | sudo tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
# optional: fingerprint should be E298A3A825C0D65DFD57CBB651716619E084DAB9
gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc
sudo add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"
sudo apt install --no-install-recommends r-base r-base-dev
```

`$(lsb_release -cs)` fills in your release (`noble` for 24.04, `resolute` for
26.04). For geospatial libraries and binary packages, see [07](07-software.md).

## 2. Install RStudio Server

Get the current Ubuntu `.deb` from Posit's
[download page](https://posit.co/download/rstudio-server/) (it currently
redirects to [docs.posit.co/ide/user/download.html](https://docs.posit.co/ide/user/download.html)).
The one package, built on `jammy`, is for Ubuntu 22, 24 and 26. Don't copy a
version number from old notes: the filename changes with every release.

Either copy the link from that page, or use Posit's "latest stable" redirect
and check which version it points to:

```bash
curl -sI https://rstudio.org/download/latest/stable/server/jammy/rstudio-server-latest-amd64.deb | grep -i ^location
```

Then download and install it (in October 2026 the current file was
`rstudio-server-2026.10.1-239-amd64.deb`):

```bash
wget https://rstudio.org/download/latest/stable/server/jammy/rstudio-server-latest-amd64.deb
sudo apt install ./rstudio-server-latest-amd64.deb
sudo systemctl status rstudio-server
```

`apt install ./file.deb` pulls in dependencies, so you no longer need `gdebi`.
TODO(verify): the `rstudio.org/download/latest/...` redirect is not documented
on Posit's download page, though it worked when this was written. If it stops
working, copy the link from the download page instead.

## 3. Make RStudio Server listen only on localhost

nginx will be the only way in, so tell RStudio Server not to listen on the
public interface ([Posit: running with a proxy](https://docs.posit.co/ide/server-pro/admin/access_and_security/running_with_a_proxy.html)):

```bash
echo "www-address=127.0.0.1" | sudo tee -a /etc/rstudio/rserver.conf
sudo systemctl restart rstudio-server
```

Check it:

```bash
sudo ss -tlnp | grep 8787
```

You should see `127.0.0.1:8787`, not `0.0.0.0:8787`.

## 4. Create the DNS record

You do this with the OpenStack command-line client and its DNS (Designate)
plugin. It can run on any machine, such as your laptop or the VM itself.

### Install the clients in a Python virtual environment

Use a venv rather than `apt install python3-openstackclient`. The apt packages
can lag behind and mixing them with system Python caused trouble before (see
[issue #14](https://github.com/mdsumner/nectar/issues/14)). Ubuntu 24.04 also
refuses `pip install` outside a venv.

```bash
sudo apt install python3-venv python3-pip
python3 -m venv ~/venvs/openstack
source ~/venvs/openstack/bin/activate
pip install python-openstackclient python-designateclient
```

When you come back later, run `source ~/venvs/openstack/bin/activate` again
first.
References: [Nectar: OpenStack client](https://tutorials.rc.nectar.org.au/openstack-cli/02-openstack-client),
[Python venv docs](https://docs.python.org/3/library/venv.html).

### Load your credentials

Do either of the following.

**Application credential (preferred for anything scripted or left on a
machine).** In the Nectar dashboard, select the right project, then go to
Identity → Application Credentials, create one, and download its openrc file.
It is tied to one project, can be revoked, and doesn't expose your personal
password
([Nectar: application credentials](https://tutorials.rc.nectar.org.au/application-credentials/01-overview),
[using them](https://tutorials.rc.nectar.org.au/application-credentials/03-using-app-credentials)).

```bash
# clear any leftover OS_* variables first, e.g. open a fresh shell
source app-cred-<name>-openrc.sh
```

**Project OpenStack RC file.** In the dashboard, select the project, click
your email address (top right), and choose "OpenStack RC File". You'll be
asked for your *OpenStack password*. This is not your institutional login:
generate it under Settings → Reset Password
([Nectar: credentials](https://tutorials.rc.nectar.org.au/openstack-cli/04-credentials)).

```bash
source <project>-openrc.sh
```

Never commit either file, or paste its secret, into a repository or
document.

### Create and check the record

Find your zone, then create an A record pointing `<server>` at the VM's IP
([Nectar: create a recordset](https://tutorials.rc.nectar.org.au/dns/05-create-recordset)):

```bash
openstack zone list
openstack recordset create <project>.cloud.edu.au. <server> --type A --record <ip>
openstack recordset list <project>.cloud.edu.au.
```

Note the **trailing dot** on the zone name. It is a fully qualified name and
the commands fail without it.

Wait a minute or two, then check that the name resolves to your IP:

```bash
host <fqdn>
```

You can also create the record in the dashboard: Project → DNS → Zones →
Create Record Set.

## 5. Open ports 80 and 443 (and never 8787)

In the dashboard (Project → Network → Security Groups), add a group, e.g.
`http-https`, with ingress rules for TCP 80 and TCP 443 from `0.0.0.0/0`, and
attach it to the instance. Port 80 is needed for the Let's Encrypt challenge
and the HTTP to HTTPS redirect.

The same from the command line:

```bash
openstack security group create http-https
openstack security group rule create --protocol tcp --dst-port 80 --remote-ip 0.0.0.0/0 http-https
openstack security group rule create --protocol tcp --dst-port 443 --remote-ip 0.0.0.0/0 http-https
openstack server add security group <server> http-https
```

Do **not** open 8787. If an old group allows it, remove that group from the
instance:

```bash
openstack server remove security group <server> <group-with-8787>
```

## 6. Install nginx and add a site for RStudio

```bash
sudo apt install nginx
```

Create `/etc/nginx/sites-available/rstudio`, based on Posit's
[proxy configuration](https://docs.posit.co/ide/server-pro/admin/access_and_security/running_with_a_proxy.html).
Files in `sites-available` are included inside nginx's `http { }` block, so
don't edit `/etc/nginx/nginx.conf`.

```bash
sudo nano /etc/nginx/sites-available/rstudio
```

```nginx
# Support proxying of websocket connections (RStudio needs these)
map $http_upgrade $connection_upgrade {
  default upgrade;
  ''      close;
}

server {
  listen 80;
  listen [::]:80;
  server_name <fqdn>;

  # allow larger uploads through the RStudio Files pane
  client_max_body_size 100M;

  location / {
    proxy_pass http://127.0.0.1:8787;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection $connection_upgrade;
    proxy_set_header Host $host;
    proxy_read_timeout 20d;
  }
}
```

Posit's example uses `proxy_set_header Host $host:$server_port;` and says to
leave out the port when serving on the default 80/443, so this uses `$host`.
`client_max_body_size` is optional (nginx's default is 1M).

Enable the site, disable the default one, test, and reload:

```bash
sudo ln -s /etc/nginx/sites-available/rstudio /etc/nginx/sites-enabled/rstudio
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

At this point `http://<fqdn>` should show the RStudio login page. **Don't log
in yet**, because it isn't encrypted.

## 7. Get a certificate with certbot

[certbot.eff.org](https://certbot.eff.org/instructions?ws=nginx&os=snap)
recommends installing certbot as a snap, and Ubuntu cloud images ship with
`snapd`:

```bash
sudo apt remove certbot   # only if an old apt version is installed
sudo snap install --classic certbot
sudo ln -s /snap/bin/certbot /usr/local/bin/certbot
```

TODO(verify): that the Nectar Ubuntu 24.04 image includes `snapd`. If it
doesn't (or you'd rather avoid snaps), `sudo apt install python3-certbot-nginx`
also works on 24.04, with a slightly older certbot.

Request the certificate and let certbot edit the nginx site:

```bash
sudo certbot --nginx -d <fqdn>
```

It asks for an email address (for expiry warnings) and for you to agree to
the terms. If it asks about redirecting, choose redirect.
TODO(verify): recent certbot seems to add the HTTP to HTTPS redirect without
asking. If it doesn't, add `--redirect` to the command. Afterwards the `server` block in
`/etc/nginx/sites-available/rstudio` has `listen 443 ssl` and certificate
lines marked `# managed by Certbot`, plus a second block that redirects port
80.

Renewal is automatic. The snap installs a systemd timer (the apt package does
too), and certificates renew before they expire. Check it and do a dry run:

```bash
systemctl list-timers | grep -i certbot
sudo certbot renew --dry-run
```

Now open `https://<fqdn>`. `http://<fqdn>` should redirect there.

## 8. Add users

RStudio Server logs in with ordinary Linux accounts. For each person:

```bash
sudo adduser <username>
```

Give them a temporary password, sent separately from the username (e.g. by a
different channel), and ask them to change it on first login:

1. Log in at `https://<fqdn>`.
2. Open the Terminal tab (Tools → Terminal → New Terminal) and run:

   ```bash
   passwd
   ```

3. Choose a long, unique password, ideally from a password manager. Sign out
   and back in so the password manager saves the new one.

Don't give users `sudo` unless they need it. See [08](08-looking-after-it.md)
for managing users over time. Never write real usernames, passwords, IP
addresses or credential files into shared notes or this repo.

## If something goes wrong

```bash
sudo nginx -t                              # config syntax
sudo journalctl -u nginx -e                # nginx service log
sudo tail -n 50 /var/log/nginx/error.log   # proxy errors (502 = RStudio not reachable)
sudo systemctl status rstudio-server
sudo rstudio-server verify-installation
sudo tail -n 50 /var/log/letsencrypt/letsencrypt.log
```

- **certbot fails the challenge:** check that `host <fqdn>` returns your IP and
  that port 80 is open in the security group.
- **Login page loads but the session hangs or keeps disconnecting:** the
  websocket `Upgrade`/`Connection` headers are missing from the nginx site.
- **502 Bad Gateway:** RStudio Server isn't running, or isn't on
  `127.0.0.1:8787`.

## Variation: RStudio under a path

To serve RStudio at `https://<fqdn>/rstudio/` with something else (a landing
page, Jupyter) at `/`, see Posit's
[proxy guide](https://docs.posit.co/ide/server-pro/admin/access_and_security/running_with_a_proxy.html)
for the sub-path configuration. In outline, add this inside the existing
`server` block, keeping the websocket headers from above:

```nginx
location /rstudio/ {
  rewrite ^/rstudio/(.*)$ /$1 break;
  proxy_pass http://127.0.0.1:8787;
  proxy_http_version 1.1;
  proxy_set_header Upgrade $http_upgrade;
  proxy_set_header Connection $connection_upgrade;
  proxy_set_header Host $host;
  proxy_set_header X-RStudio-Root-Path /rstudio;
  proxy_read_timeout 20d;
}
```

The `X-RStudio-Root-Path` header and `www-root-path=/rstudio` in
`/etc/rstudio/rserver.conf` do the same job, so you need only one. If both are
set, the header wins.
