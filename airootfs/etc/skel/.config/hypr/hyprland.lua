-- ==============================================================================
-- KryptonOS Hyprland 0.56+ Configuration - Coding Focus
-- Native dynamic tiling and developer shortcuts
-- ==============================================================================

hl.monitor({
    output   = "",
    mode     = "1920x1200@60",
    position = "auto",
    scale    = "1",
})

-- Environment variables
hl.env("XCURSOR_THEME", "breeze_cursors")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_WAYLAND_DECORATION", "bradient")
hl.env("LIBDECOR_PLUGIN_DIR", "/usr/lib/libdecor/plugins-1")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("BROWSER", "helium-browser")
hl.env("EDITOR", "nvim")
hl.env("VISUAL", "code")
hl.env("GSK_RENDERER", "cairo")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")
hl.env("WLR_RENDERER_ALLOW_SOFTWARE", "1")

-- Autostart Essential Services
hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("xdg-user-dirs-update")
    hl.exec_cmd("waybar")
    hl.exec_cmd("python3 /usr/local/bin/krypton-dock")
    hl.exec_cmd("swaync")
    hl.exec_cmd("/usr/local/bin/krypton-wallpaper")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("nm-applet --indicator")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
    hl.exec_cmd("/usr/local/bin/krypton-welcome")
end)

-- Look and Feel (Catppuccin Mocha — Optimized for Coding Focus)
hl.config({
    layout = "dwindle",
    dwindle = {
        pseudotile = true,
        preserve_split = true,
    },

    general = {
        gaps_in        = 4,
        gaps_out       = 8,
        border_size    = 2,
        col = {
            active_border   = { colors = { "rgba(cba6f7ee)", "rgba(89b4faee)" }, angle = 45 },
            inactive_border = "rgba(313244aa)",
        },
        resize_on_border        = true,
        extend_border_grab_area = 15,
        hover_icon_on_border    = true,
        allow_tearing           = false,
    },

    decoration = {
        rounding         = 10,
        rounding_power   = 2,
        active_opacity   = 1.0,
        inactive_opacity = 0.95,

        shadow = {
            enabled      = false,
        },

        blur = {
            enabled  = false,
        },
    },

    animations = {
        enabled = false,
    },

    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },

    cursor = {
        no_hardware_cursors = true,
        no_warps            = true,
        hotspot_padding     = 0,
    },

    input = {
        kb_layout      = "us",
        follow_mouse   = 1,
        sensitivity    = 0,
        accel_profile  = "flat",
        touchpad = {
            natural_scroll       = true,
            tap_to_click         = true,
            drag_lock            = true,
            disable_while_typing = true,
        },
    },
})

-- 3-finger touchpad swipe gesture
hl.gesture({
    fingers   = 3,
    direction = "horizontal",
    action    = "workspace",
})

-- Window Rules for Dialogs & Quick Dev Overlays
hl.window_rule({
    name  = "float-pavucontrol",
    match = { class = "^(pavucontrol)$" },
    float = true,
})
hl.window_rule({
    name  = "float-blueman",
    match = { class = "^(blueman-manager)$" },
    float = true,
})
hl.window_rule({
    name  = "float-nm-editor",
    match = { class = "^(nm-connection-editor)$" },
    float = true,
})
hl.window_rule({
    name  = "float-calculator",
    match = { class = "^(org.gnome.Calculator)$" },
    float = true,
})
hl.window_rule({
    name  = "float-fileroller",
    match = { class = "^(file-roller)$" },
    float = true,
})
hl.window_rule({
    name  = "float-krypton-settings",
    match = { class = "^(krypton-settings|KryptonSettings|org\\.kryptonos\\.Settings)$" },
    float = true,
})
-- Keybindings
local mainMod = "SUPER"

-- Core Developer Applications
hl.bind(mainMod .. " + RETURN",        hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + C",             hl.dsp.exec_cmd("code --no-sandbox"))
hl.bind(mainMod .. " + G",             hl.dsp.exec_cmd("kitty --class lazygit -e lazygit"))
hl.bind(mainMod .. " + Y",             hl.dsp.exec_cmd("kitty -e yazi"))
hl.bind(mainMod .. " + T",             hl.dsp.exec_cmd("kitty --class btop -e btop"))
hl.bind(mainMod .. " + B",             hl.dsp.exec_cmd("helium-browser"))
hl.bind(mainMod .. " + E",             hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + SPACE",         hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + R",             hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + S",             hl.dsp.exec_cmd("/usr/local/bin/krypton-settings"))
hl.bind(mainMod .. " + I",             hl.dsp.exec_cmd("/usr/local/bin/krypton-settings"))
hl.bind(mainMod .. " + N",             hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + V",             hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p 'Clipboard History' | cliphist decode | wl-copy"))

-- Window Management (Native Tiling Workflow)
hl.bind(mainMod .. " + Q",             hl.dsp.window.close())
hl.bind("ALT + F4",                    hl.dsp.window.close())
hl.bind(mainMod .. " + F",             hl.dsp.window.fullscreen())
hl.bind("F11",                         hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + SHIFT + M",     hl.dsp.exit())
hl.bind(mainMod .. " + L",             hl.dsp.exec_cmd("hyprlock"))

-- Vim-style Navigation (H, J, K, L) + Arrow Keys
hl.bind(mainMod .. " + left",          hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right",         hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",            hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",          hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + h",             hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + l",             hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + k",             hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + j",             hl.dsp.focus({ direction = "down" }))

-- Move Active Window in Layout (Vim + Arrows)
hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + h",     hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + l",     hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + k",     hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + j",     hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down",    hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",      hl.dsp.focus({ workspace = "e-1" }))

-- Mouse drag/resize: SUPER + LeftClick moves tile/window, SUPER + RightClick resizes
hl.bind(mainMod .. " + mouse:272",     hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",     hl.dsp.window.resize(), { mouse = true })

-- Screenshots & Slurp
hl.bind("Print",                       hl.dsp.exec_cmd("grim - | swappy -f -"))
hl.bind(mainMod .. " + SHIFT + S",     hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | swappy -f -"))
hl.bind(mainMod .. " + SHIFT + C",     hl.dsp.exec_cmd("hyprpicker -a"))

-- Hardware Multimedia & Brightness Keys
hl.bind("XF86AudioRaiseVolume",        hl.dsp.exec_cmd("pamixer -i 5"),                 { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume",        hl.dsp.exec_cmd("pamixer -d 5"),                 { locked = true, repeating = true })
hl.bind("XF86AudioMute",               hl.dsp.exec_cmd("pamixer -t"),                   { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",            hl.dsp.exec_cmd("pamixer --default-source -t"),  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",         hl.dsp.exec_cmd("brightnessctl set +5%"),        { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",       hl.dsp.exec_cmd("brightnessctl set 5%-"),        { locked = true, repeating = true })
hl.bind("XF86AudioNext",               hl.dsp.exec_cmd("playerctl next"),               { locked = true })
hl.bind("XF86AudioPause",              hl.dsp.exec_cmd("playerctl play-pause"),         { locked = true })
hl.bind("XF86AudioPlay",               hl.dsp.exec_cmd("playerctl play-pause"),         { locked = true })
hl.bind("XF86AudioPrev",               hl.dsp.exec_cmd("playerctl previous"),           { locked = true })
