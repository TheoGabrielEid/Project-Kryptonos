#!/usr/bin/env bash
# ==============================================================================
# AuraOS ISO Build Script
# Run this inside an Arch Linux / CachyOS environment with sudo privileges
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORK_DIR="/tmp/archiso-work"
OUT_DIR="${SCRIPT_DIR}/out"

echo "==> Checking prerequisites..."
if ! command -v mkarchiso &> /dev/null; then
    echo "[-] archiso is not installed. Installing archiso..."
    sudo pacman -S --noconfirm --needed archiso
fi

echo "==> Preparing directories..."
mkdir -p "${OUT_DIR}"
rm -rf "${WORK_DIR}"
mkdir -p "${WORK_DIR}"

echo "==> Building AuraOS ISO with mkarchiso..."
sudo mkarchiso -v -w "${WORK_DIR}" -o "${OUT_DIR}" "${SCRIPT_DIR}"

echo "==> Build complete! ISO generated in ${OUT_DIR}:"
ls -lh "${OUT_DIR}"/*.iso
