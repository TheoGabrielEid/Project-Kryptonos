#!/usr/bin/env bash
# profiledef.sh - Archiso metadata configuration for KryptonOS

iso_name="kryptonos"
iso_label="KRYPTON_$(date +%Y%m)"
iso_publisher="KryptonOS Project <https://github.com/TheoGabrielEid/Project-Kryptonos>"
iso_application="KryptonOS Hyprland Daily-Driver Live / Installer"
iso_version="$(date +%Y.%m.%d)"
install_dir="arch"
buildmodes=('iso')
bootmodes=('bios.syslinux' 'uefi.systemd-boot')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')
bootstrap_tarball_compression=('zstd' '-c' '-T0' '--auto-threads=logical' '--long' '-19')

file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/sudoers.d"]="0:0:750"
  ["/etc/sudoers.d/00-live-wheel"]="0:0:440"
  ["/root"]="0:0:700"
  ["/home/live"]="1000:1000:750"
  ["/usr/local/bin/krypton-welcome"]="0:0:755"
  ["/usr/local/bin/krypton-install"]="0:0:755"
  ["/usr/local/bin/krypton-powermenu"]="0:0:755"
)
