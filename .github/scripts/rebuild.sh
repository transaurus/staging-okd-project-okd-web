#!/usr/bin/env bash
set -euo pipefail

# Rebuild script for okd-project/okd-web
# Runs on existing source tree (no clone). Installs deps, runs pre-build steps, builds.

# --- Node version ---
# Docusaurus 3.9.2, engines require >=20
export NVM_DIR="$HOME/.nvm"
if [ -f "$NVM_DIR/nvm.sh" ]; then
    . "$NVM_DIR/nvm.sh"
    nvm use 20 2>/dev/null || nvm install 20
else
    NODE_VERSION=$(node --version 2>/dev/null | cut -d. -f1 | tr -d 'v' || echo "0")
    if [ "$NODE_VERSION" -lt 20 ]; then
        echo "ERROR: Node 20+ required, found: $(node --version 2>/dev/null || echo 'not found')"
        exit 1
    fi
fi

echo "[INFO] Using Node: $(node --version)"
echo "[INFO] Using npm: $(npm --version)"

# --- Package manager + dependencies ---
npm ci

# --- Build ---
npm run build

echo "[DONE] Build complete."
