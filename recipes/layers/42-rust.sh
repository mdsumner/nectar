#!/bin/bash
# 42: Rust toolchain for R packages that compile Rust (optional; launch.sh --rust). Run as root, after 40-r.sh (it writes R's Renviron.site).
# Usage:  42-rust.sh [toolchain]   (default stable)
#
# rustup and the toolchain are system-wide and root-maintained in /usr/local (root disk); no CARGO_HOME is set, so each
# user's crate cache lands in their own ~/.cargo on the home volume. Renviron.site carries this to R and RStudio sessions, which don't read profile.d.
set -euo pipefail
TC=${1:-stable}
export RUSTUP_HOME=/usr/local/rustup CARGO_HOME=/usr/local/cargo
mkdir -p "$RUSTUP_HOME" "$CARGO_HOME"
[ -x "$CARGO_HOME/bin/rustup" ] || curl -fsSL https://sh.rustup.rs | sh -s -- -y --no-modify-path --profile minimal --default-toolchain none
"$CARGO_HOME/bin/rustup" toolchain install "$TC" --profile minimal
"$CARGO_HOME/bin/rustup" default "$TC"
chmod -R a+rX "$RUSTUP_HOME" "$CARGO_HOME"

cat > /etc/profile.d/rust.sh <<'SH'
export RUSTUP_HOME=/usr/local/rustup
export PATH="/usr/local/cargo/bin:$PATH"
SH
sed -i '/^RUSTUP_HOME=/d; /usr\/local\/cargo\/bin/d' /etc/R/Renviron.site 2>/dev/null || true
cat >> /etc/R/Renviron.site <<'RE'
RUSTUP_HOME=/usr/local/rustup
PATH=/usr/local/cargo/bin:${PATH}
RE
"$CARGO_HOME/bin/rustc" --version
