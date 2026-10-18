#!/usr/bin/env bash
# ==============================================================================
# AuraOS Repository Builder
# Compiles packages and creates the custom package repository database (auraos.db.tar.zst)
# ==============================================================================

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/x86_64"
PACKAGES_SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../packages" && pwd)"

mkdir -p "${REPO_DIR}"
echo "==> Building AuraOS Custom Packages..."

for pkg in "${PACKAGES_SRC}"/*; do
    if [ -d "${pkg}" ] && [ -f "${pkg}/PKGBUILD" ]; then
        pkgname="$(basename "${pkg}")"
        echo "--> Building ${pkgname}..."
        (
            cd "${pkg}"
            # makepkg compiles package inside clean chroot or user space
            makepkg -sc --noconfirm
            mv ./*.pkg.tar.zst "${REPO_DIR}/" || true
        )
    fi
done

echo "==> Generating Pacman Repository Database..."
cd "${REPO_DIR}"
repo-add -s -n -R auraos.db.tar.zst ./*.pkg.tar.zst

echo "==> AuraOS Repository ready in ${REPO_DIR}!"
ls -lh "${REPO_DIR}"
