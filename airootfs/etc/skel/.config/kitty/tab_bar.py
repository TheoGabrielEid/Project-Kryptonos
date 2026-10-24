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

_patched = False
_last_cols = 80
_last_cell_w = 10.0


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
        boss = get_boss()
        if boss and hasattr(boss, "close_os_window"):
            boss.close_os_window(os_win_id)
            return
    except Exception:
        pass
    try:
        subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "close"], env=get_hypr_env())
    except Exception:
        subprocess.Popen(["hyprctl", "dispatch", "killactive"], env=get_hypr_env())


def do_maximize():
    try:
        subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "maximize"], env=get_hypr_env())
    except Exception:
        subprocess.Popen(["hyprctl", "dispatch", "fullscreen", "1"], env=get_hypr_env())


def do_minimize():
    try:
        subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "minimize"], env=get_hypr_env())
    except Exception:
        subprocess.Popen(["hyprctl", "dispatch", "movetoworkspacesilent", "special:minimized"], env=get_hypr_env())


def handle_button_click(os_win_id, x, is_double=False, total_cols=80, cell_w=10.0):
    try:
        col = int(float(x) / max(1.0, float(cell_w)))
        cols_from_right = total_cols - col

        # Navigation buttons occupy the last 15 columns:
        # [✕] Close: 0 to 5 cols from right
        if cols_from_right <= 5:
            do_close(os_win_id)
            return True
        # [🗖] Maximize / Windowed: 5 to 10 cols from right
        elif cols_from_right <= 10:
            do_maximize()
            return True
        # [🗕] Minimize: 10 to 15 cols from right
        elif cols_from_right <= 15:
            do_minimize()
            return True
        # Double click anywhere on empty tab bar toggles maximize / windowed
        elif is_double:
            do_maximize()
            return True
    except Exception:
        pass
    return False


def _krypton_boss_activate(self, os_window_id, x, is_double=False, is_middle=False, *args, **kwargs):
    try:
        tm = self.os_window_map.get(os_window_id)
        if tm is not None:
            cell_w = getattr(tm.tab_bar, "cell_width", _last_cell_w) or _last_cell_w
            cols = getattr(tm.tab_bar.screen, "columns", _last_cols) or _last_cols
            if handle_button_click(os_window_id, x, is_double=is_double, total_cols=cols, cell_w=cell_w):
                return 0
    except Exception:
        pass

    orig = getattr(self.__class__, "_krypton_orig_boss_activate", None)
    if orig:
        return orig(self, os_window_id, x, is_double, is_middle, *args, **kwargs)


def _krypton_tm_activate(self, x, is_double=False, is_middle=False, *args, **kwargs):
    try:
        cell_w = getattr(self.tab_bar, "cell_width", _last_cell_w) or _last_cell_w
        cols = getattr(self.tab_bar.screen, "columns", _last_cols) or _last_cols
        os_win_id = getattr(self, "os_window_id", 0)
        if handle_button_click(os_win_id, x, is_double=is_double, total_cols=cols, cell_w=cell_w):
            return
    except Exception:
        pass

    orig = getattr(self.__class__, "_krypton_orig_tm_activate", None)
    if orig:
        return orig(self, x, is_double, is_middle, *args, **kwargs)


def _ensure_patch():
    global _patched
    if _patched:
        return

    try:
        from kitty.boss import Boss
        if not hasattr(Boss, "_krypton_orig_boss_activate"):
            Boss._krypton_orig_boss_activate = Boss.activate_tab_at
            Boss.activate_tab_at = _krypton_boss_activate
    except Exception:
        pass

    try:
        boss = get_boss()
        if boss is not None and not hasattr(boss, "_krypton_boss_inst_patched"):
            boss.activate_tab_at = types.MethodType(_krypton_boss_activate, boss)
            boss._krypton_boss_inst_patched = True
    except Exception:
        pass

    try:
        from kitty.tabs import TabManager
        if not hasattr(TabManager, "_krypton_orig_tm_activate"):
            TabManager._krypton_orig_tm_activate = TabManager.activate_tab_at
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
    global _last_cols, _last_cell_w
    _ensure_patch()

    _last_cols = screen.columns
    try:
        from kitty.fast_data_types import cell_size_for_window
        os_win = getattr(extra_data, "os_window_id", 0)
        cw, _ = cell_size_for_window(os_win)
        _last_cell_w = float(cw)
    except Exception:
        pass

    # Active vs Inactive Tab Header
    if tab.is_active:
        screen.cursor.bg = draw_data.active_bg
        screen.cursor.fg = draw_data.active_fg
        screen.cursor.bold = True
        marker = "  "
    else:
        screen.cursor.bg = draw_data.inactive_bg
        screen.cursor.fg = draw_data.inactive_fg
        screen.cursor.bold = False
        marker = "   "

    title = tab.title if tab.title else f"Terminal {index}"
    if len(title) > 28:
        title = title[:25] + "..."

    screen.draw(f"{marker} {title} ")
    screen.cursor.bold = False
    end = screen.cursor.x

    # If this is the last tab, render spacer and window control buttons on the right
    if is_last:
        btns_len = 15  # 5 cols for min, 5 cols for max, 5 cols for close
        pad = screen.columns - screen.cursor.x - btns_len
        if pad > 0:
            screen.cursor.bg = draw_data.default_bg
            screen.cursor.fg = draw_data.inactive_fg
            screen.draw(" " * pad)

        # Draw Minimize button [ 🗕 ] (Catppuccin Blue)
        screen.cursor.bg = draw_data.default_bg
        screen.cursor.fg = 0x89b4fa
        screen.draw("  🗕  ")

        # Draw Maximize / Windowed button [ 🗖 ] (Catppuccin Mauve)
        screen.cursor.fg = 0xcba6f7
        screen.draw("  🗖  ")

        # Draw Close button [ ✕ ] (Catppuccin Red)
        screen.cursor.fg = 0xf38ba8
        screen.draw("  ✕  ")

    return end
