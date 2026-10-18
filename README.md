# AuraOS (Arch + Hyprland Distribution)

AuraOS is a modern, aesthetics-focused Arch Linux distribution featuring **Hyprland**, GPU-accelerated **Kitty**, the blazing-fast Rust **Yazi** file manager, **Catppuccin Mocha** theming, and an out-of-the-box **Calamares** graphical installer.

---

## ✨ Features
- **Window Manager**: Hyprland with dynamic blur, smooth bounce/overshot animations, and drop shadows.
- **Top Bar**: Waybar with floating pill modules, workspace indicators, and system monitors.
- **Terminal Experience**:
  - **Kitty**: GPU-accelerated, transparent blur, JetBrainsMono Nerd Font.
  - **Starship Prompt**: Pill-style prompt showing Git branches, execution times, language runtimes.
  - **Zsh**: Enhanced with `eza` (modern ls), `bat` (syntax-highlighted cat), `zoxide` (smart cd), and `fastfetch`.
- **File Explorers**:
  - **Yazi**: Blazing-fast Rust terminal file explorer with instant image previews.
  - **Thunar**: Clean GTK file manager with Papirus icons and Catppuccin theme.
- **App Launcher**: Rofi-Wayland with fuzzy search.
- **Installer**: Calamares graphical installer for one-click installation to SSD/NVMe.

---

## 🚀 How to Build the ISO

### Option A: Build in your Arch / CachyOS VirtualBox VM (Fastest Local)
1. Share this folder (`arch-custom-distro`) with your CachyOS VM (or copy it over).
2. Inside your Arch/CachyOS terminal, run:
   ```bash
   cd arch-custom-distro
   chmod +x build.sh
   ./build.sh
   ```
3. `mkarchiso` will pull packages, build the squashfs root, and produce `out/auraos-*.iso`.

### Option B: Build Automatically in GitHub Actions (Cloud)
1. Push this directory to a GitHub repository:
   ```bash
   git init
   git add .
   git commit -m "Initial AuraOS distro recipe"
   git remote add origin https://github.com/<your-username>/auraos.git
   git push -u origin main
   ```
2. Go to **Actions** in GitHub and trigger the **Build AuraOS ISO** workflow.
3. Once finished, download your ready-to-flash `.iso` directly from GitHub Artifacts/Releases!

---

## ⌨️ Default Keybindings
| Keybinding | Action |
| :--- | :--- |
| `Super + Return` | Launch Kitty Terminal |
| `Super + Space` | Launch Rofi App Menu |
| `Super + E` | Open Thunar File Manager |
| `Super + Shift + E` | Open Yazi Terminal File Explorer |
| `Super + B` | Launch Firefox |
| `Super + Q` | Close Active Window |
| `Super + P` | Screenshot region to clipboard (`grim + slurp`) |
| `Super + L` | Lock screen (`hyprlock`) |
