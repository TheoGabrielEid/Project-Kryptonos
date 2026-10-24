"""
KryptonOS Kitty Custom Tab Bar & Navigation Header
Renders active tab and title on the left and navigation buttons (🗕, 🗖, ✕) on the right.
Clicking the buttons triggers system window management via Hyprland, krypton-win-ctl, and Kitty Boss.
"""
import os
import subprocess
import types
from kitty.fast_data_types import Screen, get_boss
from kitty.tab_bar import DrawData, ExtraData, TabBarData

_boss_patched = False
_tm_patched = False
_last_cols = 80
_last_cell_w = 10.0


def _do_close(os_win_id=0):
    try:
        subprocess.Popen(["hyprctl", "dispatch", "killactive"], env=os.environ.copy())
    except Exception:
        pass
    try:
        boss = get_boss()
        if boss:
            if hasattr(boss, "close_os_window"):
                boss.close_os_window(os_win_id)
            elif hasattr(boss, "close_window"):
                boss.close_window()
    except Exception:
        pass
    try:
        subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "close"], env=os.environ.copy())
    except Exception:
        pass


def _do_maximize(os_win_id=0):
    try:
        subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "maximize"], env=os.environ.copy())
    except Exception:
        try:
            subprocess.Popen(["hyprctl", "dispatch", "fullscreen", "1"], env=os.environ.copy())
        except Exception:
            pass


def _do_minimize(os_win_id=0):
    try:
        subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "minimize"], env=os.environ.copy())
    except Exception:
        try:
            subprocess.Popen(["hyprctl", "dispatch", "movetoworkspacesilent", "special:minimized"], env=os.environ.copy())
        except Exception:
            pass


def _handle_click(os_win_id, x, is_double=False):
    global _last_cols, _last_cell_w
    cols_from_right = None

    try:
        from kitty.fast_data_types import viewport_for_window
        central, tab_bar_geom, vw, vh, cell_w, cell_h = viewport_for_window(os_win_id)
        cw = float(cell_w)
        right_edge = float(tab_bar_geom.left + tab_bar_geom.width)
        dist_from_right = right_edge - float(x)
        cols_from_right = dist_from_right / max(1.0, cw)
    except Exception:
        pass

    if cols_from_right is None:
        try:
            from kitty.fast_data_types import cell_size_for_window
            cw, ch = cell_size_for_window(os_win_id)
            cw = float(cw)
        except Exception:
            cw = float(_last_cell_w)
        cols = float(_last_cols)
        col = float(x) / max(1.0, cw)
        cols_from_right = cols - col

    try:
        with open("/tmp/kitty_tab_click.log", "a") as f:
            f.write(f"CLICK: os_win={os_win_id}, x={x}, cols_from_right={cols_from_right:.2f}, is_double={is_double}\n")
    except Exception:
        pass

    # Navigation buttons: "  🗕    🗖    ✕  " (16 cols total from right edge)
    # [✕] Close: rightmost 5 columns
    if cols_from_right <= 5.0:
        _do_close(os_win_id)
        return True
    # [🗖] Maximize / Restore: 5 to 10 columns from right
    elif cols_from_right <= 10.0:
        _do_maximize(os_win_id)
        return True
    # [🗕] Minimize: 10 to 16 columns from right
    elif cols_from_right <= 16.0:
        _do_minimize(os_win_id)
        return True
    # Double click anywhere on empty header bar toggles maximize / windowed
    elif is_double:
        _do_maximize(os_win_id)
        return True

    return False


def _krypton_boss_activate(self, os_window_id, x, is_double=False, is_middle=False, *args, **kwargs):
    try:
        if _handle_click(os_window_id, x, is_double=is_double):
            return
    except Exception:
        pass

    orig = getattr(self.__class__, "_krypton_orig_boss_activate", None)
    if orig:
        return orig(self, os_window_id, x, is_double, is_middle, *args, **kwargs)
    tm = self.os_window_map.get(os_window_id)
    if tm is not None:
        return tm.activate_tab_at(x, is_double, is_middle)


def _krypton_tm_activate(self, x, is_double=False, is_middle=False, *args, **kwargs):
    try:
        os_win_id = getattr(self, "os_window_id", 0)
        if _handle_click(os_win_id, x, is_double=is_double):
            return
    except Exception:
        pass

    orig = getattr(self.__class__, "_krypton_orig_tm_activate", None)
    if orig:
        return orig(self, x, is_double, is_middle, *args, **kwargs)


def _ensure_patch():
    global _boss_patched, _tm_patched

    # 1. Patch Boss class and instance
    if not _boss_patched:
        try:
            from kitty.boss import Boss
            if not hasattr(Boss, "_krypton_orig_boss_activate"):
                Boss._krypton_orig_boss_activate = Boss.activate_tab_at
                Boss.activate_tab_at = _krypton_boss_activate
                _boss_patched = True
        except Exception:
            pass

    try:
        boss = get_boss()
        if boss is not None and not hasattr(boss, "_krypton_instance_patched"):
            boss.activate_tab_at = types.MethodType(_krypton_boss_activate, boss)
            boss._krypton_instance_patched = True
            _boss_patched = True
    except Exception:
        pass

    # 2. Patch TabManager class
    if not _tm_patched:
        try:
            from kitty.tabs import TabManager
            if not hasattr(TabManager, "_krypton_orig_tm_activate"):
                TabManager._krypton_orig_tm_activate = TabManager.activate_tab_at
                TabManager.activate_tab_at = _krypton_tm_activate
                _tm_patched = True
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
    global _last_cols, _last_cell_w
    _ensure_patch()
    _last_cols = screen.columns
    try:
        from kitty.fast_data_types import cell_size_for_window
        os_win = getattr(extra_data, "os_window_id", 0)
        cw, ch = cell_size_for_window(os_win)
        _last_cell_w = float(cw)
    except Exception:
        pass

    title = tab.title if tab.title else f"Terminal {index}"
    if len(title) > 28:
        title = title[:25] + "..."
    marker = "● " if tab.is_active else "○ "
    screen.draw(f" {marker}{title} ")
    end = screen.cursor.x

    if is_last:
        btns = "  🗕    🗖    ✕  "
        pad = screen.columns - screen.cursor.x - len(btns)
        if pad > 0:
            screen.draw(" " * pad)
        screen.draw(btns)

    return end
