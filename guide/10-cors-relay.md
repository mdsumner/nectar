# 10. A relay for browser reads

> **Status:** draft, November 2026. The recipe is tested on a sandbox host; the
> first real run on a Nectar VM is still to do.

A web page can read a slice of a remote file (a few kilobytes out of a
netCDF, a tile out of a GeoTIFF) directly, with no server of its own, as long
as the host serving the file says it may. The host says so with a response
header, `Access-Control-Allow-Origin`, and most object storage does (Pawsey,
source.coop, AWS). Many institutional file servers do not: they were set up
for `wget`, not for browsers. The browser then refuses the read, and the page
sees "Failed to fetch".

A relay fixes that from your side. It is a very small web service that
fetches the bytes on the page's behalf and adds the header. It keeps no copy
of the data, serves only the hosts you list, and fits on the smallest VM.

This page builds one. It is the simplest "put something on the web" there is:
a name, a certificate, and one process.

## What you get

- A relay at `https://<name>.<project>.cloud.edu.au/?url=<file url>`, with
  Range requests passed through, so a page that reads byte ranges keeps
  reading byte ranges.
- An allow-list in `/etc/cors-relay/hosts`. Anything else gets a 403.
- nginx with a Let's Encrypt certificate in front, renewed automatically.
- `/healthz`, which prints `ok` and the current allow-list.

## Before you launch

You need a DNS name and open ports, so this does not fit a Project Trial as
neatly as the research server did. From an allocated project:

1. **DNS.** Your project has a zone `<project>.cloud.edu.au`
   ([Nectar DNS service](https://support.ehelp.edu.au/support/solutions/articles/6000201311-nectar-dns-service)).
   Decide the name now, say `relay.<project>.cloud.edu.au`; you add the A
   record once the VM has an IP.
2. **Security group.** One that opens 80 and 443 in addition to `ssh`
   ([06](06-rstudio-server.md) has the steps).

## Launch it

Follow [Launch a VM](04-launch-a-vm.md) with:

1. **Source:** any current Ubuntu LTS image.
2. **Flavour:** `t3.small` is enough.
3. **Security Groups:** `ssh` and your 80/443 group.
4. **Key Pair:** your key.
5. **Configuration:** paste this, with your own name in `FQDN`:

   ```bash
   #!/bin/bash
   curl -fsSL https://raw.githubusercontent.com/mdsumner/nectar/main/recipes/relay/bootstrap.sh | FQDN=relay.<project>.cloud.edu.au bash
   ```

When the VM is Active, add the DNS A record `relay.<project>.cloud.edu.au`
to its IP. The build waits for that record, then gets the certificate; if it
gave up waiting, a timer retries every five minutes, so there is nothing to
redo.

```bash
ssh ubuntu@<ip>
cat /var/lib/recipe-status            # running, failed <layer>, or done
tail /var/log/recipe-build.log
```

The last layer makes one real request through the relay and reports the
result: `relay: 10 bytes of noaadata.apps.nsidc.org through the relay, with CORS`.

## Use it

From a terminal, the same test from outside:

```bash
curl -sI -H "Range: bytes=0-9" \
  "https://relay.<project>.cloud.edu.au/?url=https://noaadata.apps.nsidc.org/NOAA/G02202_V6/south/daily/2025/sic_pss25_20250511_am2_v06r00.nc"
```

You should see `206 Partial Content`, a `Content-Range`, and
`Access-Control-Allow-Origin: *`.

In a page, prefix the data URL:

```js
const relay = "https://relay.<project>.cloud.edu.au/?url=";
fetch(relay + encodeURIComponent(url), { headers: { Range: "bytes=0-9" } });
```

Pages built to read virtual stores usually have a setting for this prefix.

## Add a host

```bash
sudo nano /etc/cors-relay/hosts     # one hostname per line
```

No restart: the list is read on every request. Keep it short. The relay
will fetch anything on a listed host for anyone who asks, so list public data
servers only, never anything that needs a login.

## What to look after

- **It is public.** Anyone can use your relay to read from the listed hosts.
  The list is your only control, and the logs are in `journalctl -u cors-relay`.
- **It costs you traffic, not storage.** Every byte a page reads passes
  through the VM. A map that reads a few megabytes per view is fine; a bulk
  download is not what this is for.
- **It can be forgotten.** A relay that nobody remembers is a relay that
  stops when the allocation ends. Write the name down where the page that
  uses it lives, and delete the VM when the page is retired.
- **The better fix is upstream.** A one-line change on the data host's web
  server would make the relay unnecessary. If a host matters to you, ask them;
  the relay is for the months before they answer.
