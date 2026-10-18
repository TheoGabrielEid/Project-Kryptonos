#!/usr/bin/env bash
# ==============================================================================
# KryptonOS Repository Builder
# Compiles packages and creates the custom package repository database (kryptonos.db.tar.zst)
# ==============================================================================

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/x86_64"
PACKAGES_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../packages" && pwd)"

mkdir -p "${REPO_DIR}"
echo "==> Building KryptonOS Custom Packages..."

for pkg in "${PACKAGES_SRC}"/*; do
    if [ -d "${pkg}" ] && [ -f "${pkg}/PKGBUILD" ]; then
        pkgname="$(basename "${pkg}")"
        echo "--> Building ${pkgname}..."
        (
            cd "${pkg}"
            makepkg -sc --noconfirm
            mv ./*.pkg.tar.zst "${REPO_DIR}/" || true
        )
    fi
done

echo "==> Generating Pacman Repository Database..."
cd "${REPO_DIR}"
repo-add -s -n -R kryptonos.db.tar.zst ./*.pkg.tar.zst

echo "==> KryptonOS Repository ready in ${REPO_DIR}!"
ls -lh "${REPO_DIR}"
