# Relay recipe

A small, separate server that lets a web page read byte ranges from data hosts
that do not send CORS headers. Guide page: [A relay for browser reads](../../guide/10-cors-relay.md).

- `quickstart.sh`: what you paste into the dashboard's Customization Script box (set `FQDN`).
- `bootstrap.sh`: fetches this folder from GitHub and runs `build.sh`.
- `build.sh`: runs the layers, logging to `/var/log/recipe-build.log`.
- `cors_relay.py`: the relay, about 80 lines of Python on aiohttp.
- `hosts` (optional, beside build.sh): the allow-list, one host per line.

| Layer | What it does | When |
|---|---|---|
| `10-relay.sh` | Installs the relay as a systemd service on `127.0.0.1:8787`, allow-list in `/etc/cors-relay/hosts` | Always |
| `50-nginx.sh` | nginx on 80/443 in front of it, Let's Encrypt certificate, DNS-wait timer | `FQDN` set |
| `70-check.sh` | One Range request through the relay to the first allowed host: expects 206 plus CORS | Always |

Fits a `t3.small` (2 cores, 10 GB disk) and any Ubuntu LTS image; nothing here
needs 26.04. The allow-list is read on every request, so editing
`/etc/cors-relay/hosts` is the whole procedure for adding a host.
