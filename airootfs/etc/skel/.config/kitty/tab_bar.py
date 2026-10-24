# ==============================================================================
# KryptonOS Kitty Custom Navigation Bar
# Features:
#   - Terminal Icon & Tab Management
#   - Interactive Window Navigation Buttons:
#       [ 🗕 ] Minimize  (Super+I / Special Workspace)
#       [ 🗖 ] Maximize  (Super+F / Fullscreen 1)
#       [ ✕ ] Close     (Super+Q / Alt+F4)
#   - Double-click to toggle maximize / restore
# ==============================================================================
import os
import subprocess
from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    TabBarData,
    as_rgb,
    draw_title,
)

def _setup_hooks():
    try:
        from kitty.boss import Boss
        if not getattr(Boss, "_krypton_nav_patched", False):
            orig_activate = getattr(Boss, "activate_tab_at", None)
            if orig_activate:
                def patched_activate_tab_at(self, os_window_id, x, is_double=False, *args, **kwargs):
                    try:
                        w = self.os_window_map.get(os_window_id)
                        cols = w.screen.columns if w and hasattr(w, "screen") else 80
                        if cols - 5 <= x <= cols:
                            subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "close"])
                            return
                        elif cols - 10 <= x < cols - 5:
                            subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "maximize"])
                            return
                        elif cols - 15 <= x < cols - 10:
                            subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "minimize"])
                            return
                        elif is_double:
                            subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "maximize"])
                            return
                    except Exception:
                        pass
                    return orig_activate(self, os_window_id, x, is_double, *args, **kwargs)

                Boss.activate_tab_at = patched_activate_tab_at
                Boss._krypton_nav_patched = True
    except Exception:
        pass

    try:
        from kitty.tabs import TabManager
        if not getattr(TabManager, "_krypton_nav_patched", False):
            orig_tm_activate = getattr(TabManager, "activate_tab_at", None)
            if orig_tm_activate:
                def patched_tm_activate(self, x, is_double=False, *args, **kwargs):
                    try:
                        cols = getattr(self, "screen_columns", 80)
                        if cols - 5 <= x <= cols:
                            subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "close"])
                            return
                        elif cols - 10 <= x < cols - 5:
                            subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "maximize"])
                            return
                        elif cols - 15 <= x < cols - 10:
                            subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "minimize"])
                            return
                        elif is_double:
                            subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "maximize"])
                            return
                    except Exception:
                        pass
                    return orig_tm_activate(self, x, is_double, *args, **kwargs)

                TabManager.activate_tab_at = patched_tm_activate
                TabManager._krypton_nav_patched = True
    except Exception:
        pass


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    _setup_hooks()

    # Draw left prefix icon on first tab
    if index == 1:
        screen.cursor.bg = as_rgb(0x181825)
        screen.cursor.fg = as_rgb(0xcba6f7)
        screen.cursor.bold = True
        screen.draw(" 󰞷 ")
        screen.cursor.bold = False

    # Draw the active or inactive tab
    if tab.is_active:
        screen.cursor.bg = as_rgb(0xcba6f7)
        screen.cursor.fg = as_rgb(0x11111b)
        screen.cursor.bold = True
    else:
        screen.cursor.bg = as_rgb(0x313244)
        screen.cursor.fg = as_rgb(0xcdd6f4)
        screen.cursor.bold = False

    tab_text = tab.title or "terminal"
    if len(tab_text) > 24:
        tab_text = tab_text[:22] + "…"
    screen.draw(f" {tab_text} ")
    screen.cursor.bold = False

    # Draw the rightmost navigation control buttons when on the last tab
    if is_last:
        cur_x = screen.cursor.x
        total_cols = screen.columns
        nav_width = 15
        rem_spaces = max(0, total_cols - cur_x - nav_width)

        # Fill background up to the buttons
        screen.cursor.bg = as_rgb(0x181825)
        screen.cursor.fg = as_rgb(0x6c7086)
        if rem_spaces > 0:
            screen.draw(" " * rem_spaces)

        # Draw Minimize button (yellowish)
        screen.cursor.bg = as_rgb(0x181825)
        screen.cursor.fg = as_rgb(0xf9e2af)
        screen.cursor.bold = True
        screen.draw(" 🗕  ")

        # Draw Maximize button (greenish)
        screen.cursor.fg = as_rgb(0xa6e3a1)
        screen.draw(" 🗖  ")

        # Draw Close button (reddish)
        screen.cursor.fg = as_rgb(0xf38ba8)
        screen.draw(" ✕ ")
        screen.cursor.bold = False

    return screen.cursor.x
