#!/bin/bash
# bootstrap.sh: fetches this folder from GitHub and runs build.sh. For the dashboard's Customization Script box, see quickstart.sh.
set -euo pipefail
REF=${RECIPE_REF:-main}
D=/opt/recipe; mkdir -p "$D"
curl -fsSL "https://codeload.github.com/mdsumner/nectar/tar.gz/$REF" | tar xz -C "$D" --strip-components=2 --wildcards '*/recipes/*'
exec bash "$D/build.sh"
