#!/bin/bash
# 70: end-to-end: one Range request through the relay to the first allowed host comes back as a 206 with CORS headers.
set -euo pipefail
HOST=$(grep -vE '^\s*(#|$)' /etc/cors-relay/hosts | head -1)
case "$HOST" in
  noaadata.apps.nsidc.org) URL="https://$HOST/NOAA/G02202_V6/south/daily/2025/sic_pss25_20250511_am2_v06r00.nc";;
  data.seaice.uni-bremen.de) URL="https://$HOST/amsr2/asi_daygrid_swath/s3125/netcdf/2025/asi-AMSR2-s3125-20250120-v5.4.nc";;
  *) echo "no test URL known for $HOST; relay is up (healthz) but untested end to end"; exit 0;;
esac
OUT=$(curl -s -D - -o /dev/null -H "Range: bytes=0-9" -H "Origin: https://example.org" "http://127.0.0.1:8787/?url=$URL")
echo "$OUT" | grep -iE '^HTTP|content-range|access-control-allow-origin'
echo "$OUT" | grep -q '^HTTP/1.1 206' && echo "$OUT" | grep -qi 'access-control-allow-origin: \*' \
  && echo "relay: 10 bytes of $HOST through the relay, with CORS" || { echo "relay check FAILED"; exit 1; }
