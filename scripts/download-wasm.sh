#!/usr/bin/env bash
# Download the latest WASM artifacts from the simulator repo.
# Usage: ./scripts/download-wasm.sh [tag]
# Example: ./scripts/download-wasm.sh v0.1.0
# If no tag is given, downloads the latest release.

set -euo pipefail

REPO="stasis-industry/mafis"
DEST="public/simulator"
TAG="${1:-latest}"

echo "Downloading WASM artifacts from $REPO ($TAG)..."

if [ "$TAG" = "latest" ]; then
  gh release download --repo "$REPO" --pattern "mafis-wasm.tar.gz" --dir /tmp --clobber
else
  gh release download "$TAG" --repo "$REPO" --pattern "mafis-wasm.tar.gz" --dir /tmp --clobber
fi

mkdir -p "$DEST"
tar -xzf /tmp/mafis-wasm.tar.gz -C "$DEST"
rm /tmp/mafis-wasm.tar.gz

echo "WASM artifacts extracted to $DEST/"
ls -lh "$DEST/"
