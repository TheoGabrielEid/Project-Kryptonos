"""
KryptonOS Kitty Integrated Navigation Header & Tab Bar
Provides native window management buttons (🗕 Minimize, 🗖 Maximize/Windowed, ✕ Close)
integrated directly into Kitty's top tab bar for a seamless desktop experience.
"""
import glob
import os
import subprocess
import types

from kitty.fast_data_types import Screen, get_boss
from kitty.tab_bar import DrawData, ExtraData, TabBarData

def to_color_int(c):
    if isinstance(c, int):
        return c
    if hasattr(c, "red") and hasattr(c, "green") and hasattr(c, "blue"):
        return (int(c.red) << 16) | (int(c.green) << 8) | int(c.blue)
    return 0

def safe_as_rgb(c):
    try:
        from kitty.tab_bar import as_rgb
        return as_rgb(to_color_int(c))
    except Exception:
        return (to_color_int(c) << 8) | 2

_patched = False
_last_cols = 80
_last_cell_w = 10.0
_last_win_w = 800.0


def get_hypr_env():
    env = os.environ.copy()
    if not env.get("HYPRLAND_INSTANCE_SIGNATURE"):
        matches = glob.glob("/run/user/1000/hypr/*/.socket2.sock") + glob.glob("/tmp/hypr/*/.socket2.sock")
        if matches:
            sig = os.path.basename(os.path.dirname(matches[0]))
            env["HYPRLAND_INSTANCE_SIGNATURE"] = sig
    if "XDG_RUNTIME_DIR" not in env:
        env["XDG_RUNTIME_DIR"] = "/run/user/1000"
    return env


def do_close(os_win_id=0):
    try:
        subprocess.Popen(["hyprctl", "dispatch", "killactive"], env=get_hypr_env())
    except Exception:
        pass


def do_maximize():
    try:
        subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "maximize"], env=get_hypr_env())
    except Exception:
        pass


def do_minimize():
    try:
        subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "minimize"], env=get_hypr_env())
    except Exception:
        pass


def handle_button_click(os_win_id, x, is_double=False):
    global _last_cell_w, _last_win_w
    cw = _last_cell_w
    vw = _last_win_w
    try:
        from kitty.fast_data_types import cell_size_for_window, viewport_for_window
        cw_val, _ = cell_size_for_window(os_win_id)
        if cw_val and cw_val > 0:
            cw = float(cw_val)
        _, _, vw_val, _ = viewport_for_window(os_win_id)
        if vw_val and vw_val > 0:
            vw = float(vw_val)
    except Exception:
        pass

    try:
        dist_px = vw - float(x)
        cols_from_right = dist_px / max(1.0, cw)

        # Buttons layout on right:
        # [  ✕  ] Close button: 0 to 4.5 cols from right
        if 0 <= cols_from_right <= 4.5:
            do_close(os_win_id)
            return True
        # [  🗖 ] Maximize / Windowed: 4.5 to 8.5 cols from right
        elif 4.5 < cols_from_right <= 8.5:
            do_maximize()
            return True
        # [  🗕 ] Minimize: 8.5 to 13.5 cols from right
        elif 8.5 < cols_from_right <= 13.5:
            do_minimize()
            return True
        # Double click anywhere on top tab bar: toggle Maximize / Windowed
        elif is_double:
            do_maximize()
            return True
    except Exception:
        pass
    return False


def _krypton_boss_activate(self, os_window_id, x, is_double=False, *args, **kwargs):
    try:
        if handle_button_click(os_window_id, x, is_double=is_double):
            return 0
    except Exception:
        pass

    orig = getattr(self.__class__, "_krypton_orig_boss_activate", None)
    if orig:
        return orig(self, os_window_id, x, is_double, *args, **kwargs)


def _krypton_tm_activate(self, x, is_double=False, *args, **kwargs):
    try:
        os_win_id = getattr(self, "os_window_id", 0)
        if handle_button_click(os_win_id, x, is_double=is_double):
            return
    except Exception:
        pass

    orig = getattr(self.__class__, "_krypton_orig_tm_activate", None)
    if orig:
        return orig(self, x, is_double, *args, **kwargs)


def _ensure_patch():
    global _patched
    if _patched:
        return

    try:
        from kitty.boss import Boss
        if not hasattr(Boss, "_krypton_orig_boss_activate"):
            Boss._krypton_orig_boss_activate = getattr(Boss, "activate_tab_at", None)
            Boss.activate_tab_at = _krypton_boss_activate
    except Exception:
        pass

    try:
        boss = get_boss()
        if boss is not None and not hasattr(boss, "_krypton_inst_patched"):
            boss.activate_tab_at = types.MethodType(_krypton_boss_activate, boss)
            boss._krypton_inst_patched = True
    except Exception:
        pass

    try:
        from kitty.tabs import TabManager
        if not hasattr(TabManager, "_krypton_orig_tm_activate"):
            TabManager._krypton_orig_tm_activate = getattr(TabManager, "activate_tab_at", None)
            TabManager.activate_tab_at = _krypton_tm_activate
    except Exception:
        pass

    _patched = True


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
    global _last_cols, _last_cell_w, _last_win_w
    try:
        _ensure_patch()
    except Exception:
        pass

    _last_cols = screen.columns
    try:
        from kitty.fast_data_types import cell_size_for_window, viewport_for_window
        os_win = getattr(extra_data, "os_window_id", 0)
        cw, _ = cell_size_for_window(os_win)
        if cw:
            _last_cell_w = float(cw)
        _, _, vw, _ = viewport_for_window(os_win)
        if vw:
            _last_win_w = float(vw)
    except Exception:
        pass

    try:
        # Active vs Inactive Tab Header
        if tab.is_active:
            screen.cursor.bg = safe_as_rgb(draw_data.active_bg)
            screen.cursor.fg = safe_as_rgb(draw_data.active_fg)
            screen.cursor.bold = True
            marker = "  "
        else:
            screen.cursor.bg = safe_as_rgb(draw_data.inactive_bg)
            screen.cursor.fg = safe_as_rgb(draw_data.inactive_fg)
            screen.cursor.bold = False
            marker = "   "

        title = tab.title if tab.title else f"Terminal {index}"
        if len(title) > 28:
            title = title[:25] + "..."

        screen.draw(f"{marker} {title} ")
        screen.cursor.bold = False
    except Exception:
        pass

    end = screen.cursor.x

    # If this is the last tab, render spacer and window control buttons on the right
    if is_last:
        try:
            btns = "  🗕   🗖   ✕  "
            btns_len = len(btns)
            target_x = max(end, screen.columns - btns_len)
            if screen.cursor.x < target_x:
                screen.cursor.bg = safe_as_rgb(draw_data.default_bg)
                screen.cursor.fg = safe_as_rgb(draw_data.inactive_fg)
                screen.draw(" " * (target_x - screen.cursor.x))

            screen.cursor.x = target_x

            # Draw Minimize button [ 🗕 ] (Catppuccin Blue)
            screen.cursor.bg = safe_as_rgb(draw_data.default_bg)
            screen.cursor.fg = safe_as_rgb(0x89b4fa)
            screen.draw("  🗕 ")

            # Draw Maximize / Windowed button [ 🗖 ] (Catppuccin Mauve)
            screen.cursor.fg = safe_as_rgb(0xcba6f7)
            screen.draw("  🗖 ")

            # Draw Close button [ ✕ ] (Catppuccin Red)
            screen.cursor.fg = safe_as_rgb(0xf38ba8)
            screen.draw("  ✕  ")
        except Exception:
            pass
        return screen.cursor.x

    return end
