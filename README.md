# KryptonOS (Custom Linux Distribution)

A lightweight, high-performance, aesthetics-first Linux distribution powered by **Hyprland**, GPU-accelerated **Kitty**, the blazing-fast Rust **Yazi** file manager, **Catppuccin Mocha** colors, and an out-of-the-box **Calamares** installer.

---

## ⚡ Highlights
- **Independent Ecosystem**: Own package repository (`[kryptonos]`), system branding (`krypton-branding`), and automated ALPM hooks (`krypton-hooks`).
- **Hyprland Compositor**: 3-pass dual-Kawase blur, soft drop shadows, smooth spring animations, and multi-monitor support.
- **Top Bar**: Custom Waybar with floating island pills and hardware usage widgets.
- **Terminal Experience**:
  - **Kitty**: GPU-accelerated with Catppuccin Mocha, background blur, and JetBrainsMono Nerd Font.
  - **Prompt**: Starship powerline pill prompt with Git, Python, Rust, Node, and Go environment badges.
  - **Modern Shell**: Zsh with `eza`, `bat`, `zoxide`, `btop`, and `fastfetch`.
- **File Explorers**:
  - **Yazi**: Rust-powered terminal file manager with instantaneous live image previews using Kitty’s graphics protocol.
  - **Thunar**: Modern GTK file explorer with Papirus icon theme.
- **Installer**: Calamares graphical installer for effortless installation.

---

## 🚀 Cloud Build via GitHub Actions (Recommended)

1. Create a new GitHub repository:
   ```bash
   git remote add origin https://github.com/<your-username>/kryptonos.git
   git branch -M main
   git push -u origin main
   ```
2. In your GitHub repo, go to the **Actions** tab.
3. Select **Build Distro ISO** and click **Run workflow**.
4. GitHub Actions spins up an Arch container, compiles the custom packages, builds the repository, generates the bootable `.iso`, and attaches it directly to the run's **Artifacts** for download!

---

## ⌨️ Default Shortcuts
| Shortcut | Action |
| :--- | :--- |
| `Super + Return` | Kitty Terminal |
| `Super + Space` | Rofi Application Launcher |
| `Super + E` | Thunar File Manager |
| `Super + Shift + E` | Yazi Terminal File Explorer |
| `Super + B` | Firefox Browser |
| `Super + Q` | Close Window |
| `Super + P` | Screenshot Area (`grim` + `slurp`) |
| `Super + L` | Lock Screen (`hyprlock`) |
