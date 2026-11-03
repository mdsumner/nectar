#!/usr/bin/env python3
"""
Minimal CORS relay for byte-range reads of public data files.

  GET /?url=https://noaadata.apps.nsidc.org/...   (Range header forwarded)

Only hosts in ALLOW are relayed. GET and HEAD only. No caching, no auth.
Installed by the nectar relay recipe as a systemd service on 127.0.0.1:8787,
behind nginx with a Let's Encrypt certificate. Allowed hosts are read from
/etc/cors-relay/hosts on every request, so editing that file is enough.
"""
import sys
from urllib.parse import urlparse
from aiohttp import web, ClientSession, ClientTimeout

# One host per line in /etc/cors-relay/hosts (comments with #); else these.
ALLOW = {
    "noaadata.apps.nsidc.org",
    "data.seaice.uni-bremen.de",
}
HOSTS_FILE = "/etc/cors-relay/hosts"


def load_allow():
    try:
        with open(HOSTS_FILE) as f:
            hosts = {ln.strip() for ln in f if ln.strip() and not ln.startswith("#")}
        return hosts or ALLOW
    except OSError:
        return ALLOW
FORWARD_REQ = ("Range", "If-Range", "If-None-Match", "If-Modified-Since", "Accept")
FORWARD_RESP = ("Content-Type", "Content-Length", "Content-Range", "Accept-Ranges",
                "ETag", "Last-Modified", "Cache-Control")
CORS = {
    "Access-Control-Allow-Origin": "*",
    "Access-Control-Allow-Methods": "GET, HEAD, OPTIONS",
    "Access-Control-Allow-Headers": "Range, If-Range, If-None-Match, If-Modified-Since",
    "Access-Control-Expose-Headers": "Content-Range, Content-Length, Accept-Ranges, ETag, Last-Modified",
    "Access-Control-Max-Age": "86400",
}


async def healthz(request):
    return web.Response(text="ok " + " ".join(sorted(load_allow())) + "\n", headers=CORS)


async def relay(request):
    if request.method == "OPTIONS":
        return web.Response(status=204, headers=CORS)
    url = request.query.get("url", "")
    host = urlparse(url).hostname or ""
    if urlparse(url).scheme != "https" or host not in load_allow():
        return web.Response(status=403, text="host not allowed", headers=CORS)
    headers = {k: v for k, v in request.headers.items() if k in FORWARD_REQ}
    headers["User-Agent"] = "nuyina-map-relay/1.0"
    session = request.app["session"]
    async with session.request(request.method, url, headers=headers, allow_redirects=True) as up:
        out = {k: v for k, v in up.headers.items() if k in FORWARD_RESP}
        out.update(CORS)
        resp = web.StreamResponse(status=up.status, headers=out)
        await resp.prepare(request)
        if request.method == "GET":
            async for chunk in up.content.iter_chunked(1 << 16):
                await resp.write(chunk)
        await resp.write_eof()
        return resp


async def on_startup(app):
    app["session"] = ClientSession(timeout=ClientTimeout(total=120))


async def on_cleanup(app):
    await app["session"].close()


def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8787
    app = web.Application()
    app.on_startup.append(on_startup)
    app.on_cleanup.append(on_cleanup)
    app.router.add_route("*", "/", relay)
    app.router.add_get("/healthz", healthz)
    web.run_app(app, host="127.0.0.1", port=port, access_log=None)


if __name__ == "__main__":
    main()
