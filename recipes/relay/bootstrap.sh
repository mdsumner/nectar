#!/bin/bash
# bootstrap.sh (relay): fetches recipes/relay from GitHub and runs its build.sh. For the dashboard's Customization
# Script box, see quickstart.sh. Settings come from the environment: FQDN (required for https), EMAIL (optional).
set -euo pipefail
REF=${RECIPE_REF:-main}
D=/opt/recipe-relay; mkdir -p "$D"
curl -fsSL "https://codeload.github.com/mdsumner/nectar/tar.gz/$REF" | tar xz -C "$D" --strip-components=3 --wildcards '*/recipes/relay/*'
printf "FQDN='%s' EMAIL='%s'\n" "${FQDN:-}" "${EMAIL:-}" > "$D/config"
exec bash "$D/build.sh"
