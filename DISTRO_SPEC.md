# AuraOS (Arch + Hyprland Custom Distro) Architecture & Recipe

## 1. Aesthetic & Tech Stack
* **Compositor**: Hyprland (Wayland) with blur, rounded corners, drop shadows, and smooth workspace animations.
* **Status Bar**: Waybar with custom CSS (pill/island style, workspace icons, audio/battery/network widgets).
* **Terminal**: Kitty (GPU-accelerated, transparent blur, ligatures support).
* **Shell & Prompt**: Zsh + Oh My Posh / Starship prompt + zsh-autosuggestions + zsh-syntax-highlighting.
* **File Explorer**:
  * **GUI**: Thunar (with catppuccin GTK theme, custom icon theme, and tumbler thumbnailers).
  * **TUI (terminal)**: Yazi (blazing fast Rust terminal file manager with live image previews via kitty graphics protocol).
* **Launcher / App Menu**: Rofi-wayland (fuzzy search, app launcher, power menu, clipboard manager).
* **Notification Daemon**: Dunst / SwayNC (control center panel style).
* **Wallpapers & Lockscreen**: Hyprpaper / SWWW + Hyprlock.
* **Installer**: Calamares with custom branding slides and automated partition setup.

---

## 2. Archiso Blueprint Structure
The distribution tree follows the standard `archiso` profile layout:

```text
arch-custom-distro/
├── airootfs/                         # Root filesystem overlay
│   ├── etc/
│   │   ├── calamares/                # Calamares installer configuration & branding
│   │   │   ├── modules/
│   │   │   ├── branding/auraos/
│   │   │   └── settings.conf
│   │   ├── skel/                     # Default dotfiles deployed for new users
│   │   │   ├── .config/
│   │   │   │   ├── hypr/
│   │   │   │   │   └── hyprland.conf
│   │   │   │   ├── waybar/
│   │   │   │   │   ├── config.jsonc
│   │   │   │   │   └── style.css
│   │   │   │   ├── kitty/
│   │   │   │   │   └── kitty.conf
│   │   │   │   ├── yazi/
│   │   │   │   │   └── yazi.toml
│   │   │   │   ├── rofi/
│   │   │   │   │   └── config.rasi
│   │   │   │   ├── starship.toml
│   │   │   │   └── fastfetch/
│   │   │   │       └── config.jsonc
│   │   │   └── .zshrc
│   │   ├── systemd/system/
│   │   └── issue                     # Custom boot login banner
│   └── root/
├── pacman.conf                       # Arch repositories + Chaotic-AUR / Custom repo
├── packages.x86_64                   # List of all packages baked into the ISO
├── profiledef.sh                     # Archiso metadata, permissions, boot labels
├── build.sh                          # One-click build script
└── README.md                         # Building & testing guide
```

---

## 3. How We Build It
Since building an ISO with `archiso` requires Linux loop-mounting (`mkarchiso`), we can build it directly inside your Arch / CachyOS VM, or run a GitHub Actions pipeline that builds the bootable ISO in the cloud and provides a direct download link.
