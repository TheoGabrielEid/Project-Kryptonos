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
_last_win_w = 1200.0


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


def get_window_geometry(os_win_id):
    """Safely unpacks Kitty viewport geometry without tuple length assumptions."""
    global _last_cell_w, _last_win_w
    cw = _last_cell_w
    vw = _last_win_w
    try:
        from kitty.fast_data_types import cell_size_for_window, viewport_for_window
        cs = cell_size_for_window(os_win_id)
        if cs and len(cs) >= 1 and cs[0] > 0:
            cw = float(cs[0])
            _last_cell_w = cw

        vp = viewport_for_window(os_win_id)
        # Modern Kitty (0.49+) returns 6-tuple: (central, tab_bar, vw, vh, cell_w, cell_h)
        # Older Kitty returns 4-tuple: (x, y, vw, vh)
        if vp and len(vp) >= 4:
            vw = float(vp[2])
            _last_win_w = vw
        if vp and len(vp) >= 6 and vp[4] > 0:
            cw = float(vp[4])
            _last_cell_w = cw
    except Exception:
        pass
    return cw, vw


def get_cols_from_right(os_win_id, x):
    global _last_cols
    cw, vw = get_window_geometry(os_win_id)
    try:
        x_val = float(x)
        # Support both cell-based and pixel-based coordinates from GLFW
        if x_val <= _last_cols + 2 and _last_cols > 0:
            cols_col = float(_last_cols) - x_val
            if 0 <= cols_col <= 25:
                return cols_col
        dist_px = vw - x_val
        return dist_px / max(1.0, cw)
    except Exception:
        return 999.0


def is_in_button_area(os_win_id, x):
    cols = get_cols_from_right(os_win_id, x)
    return 0 <= cols <= 15.0


def handle_button_click(os_win_id, x, is_double=False):
    cols_from_right = get_cols_from_right(os_win_id, x)

    # Buttons layout on right edge:
    # [  ✕  ] Close button: 0 to 4.5 cols from right
    if 0 <= cols_from_right <= 4.5:
        do_close(os_win_id)
        return True
    # [  🗖 ] Maximize / Windowed: 4.5 to 8.5 cols from right
    elif 4.5 < cols_from_right <= 8.5:
        do_maximize()
        return True
    # [  🗕 ] Minimize: 8.5 to 14.5 cols from right
    elif 8.5 < cols_from_right <= 14.5:
        do_minimize()
        return True
    # Double click anywhere on top tab bar: toggle Maximize / Windowed
    elif is_double:
        do_maximize()
        return True
    return False


def _krypton_boss_mouse(self, os_window_id, x, y, button=0, modifiers=0, action=1, *args, **kwargs):
    # Action 1 = GLFW_PRESS; intercept click on titlebar buttons and prevent tab drag
    if button == 0:
        if action == 1:
            if handle_button_click(os_window_id, x, is_double=False):
                try:
                    tm = self.os_window_map.get(os_window_id)
                    if tm and hasattr(tm, "set_tab_being_dragged"):
                        tm.set_tab_being_dragged(None)
                except Exception:
                    pass
                return True
        elif action == 0:
            # Action 0 = GLFW_RELEASE; consume release if inside button area
            if is_in_button_area(os_window_id, x):
                return True

    orig = getattr(self.__class__, "_krypton_orig_boss_mouse", None)
    if orig:
        return orig(self, os_window_id, x, y, button, modifiers, action, *args, **kwargs)


def _krypton_tm_mouse(self, x, y, button=0, modifiers=0, action=1, *args, **kwargs):
    os_win_id = getattr(self, "os_window_id", 0)
    if button == 0:
        if action == 1:
            if handle_button_click(os_win_id, x, is_double=False):
                try:
                    if hasattr(self, "set_tab_being_dragged"):
                        self.set_tab_being_dragged(None)
                except Exception:
                    pass
                return True
        elif action == 0:
            if is_in_button_area(os_win_id, x):
                return True

    orig = getattr(self.__class__, "_krypton_orig_tm_mouse", None)
    if orig:
        return orig(self, x, y, button, modifiers, action, *args, **kwargs)


def _krypton_boss_activate(self, os_window_id, x, is_double=False, *args, **kwargs):
    if handle_button_click(os_window_id, x, is_double=is_double):
        return 0

    orig = getattr(self.__class__, "_krypton_orig_boss_activate", None)
    if orig:
        return orig(self, os_window_id, x, is_double, *args, **kwargs)


def _krypton_tm_activate(self, x, is_double=False, *args, **kwargs):
    os_win_id = getattr(self, "os_window_id", 0)
    if handle_button_click(os_win_id, x, is_double=is_double):
        return

    orig = getattr(self.__class__, "_krypton_orig_tm_activate", None)
    if orig:
        return orig(self, x, is_double, *args, **kwargs)


def _ensure_patch():
    global _patched
    if _patched:
        return

    try:
        from kitty.boss import Boss
        if not hasattr(Boss, "_krypton_orig_boss_mouse"):
            Boss._krypton_orig_boss_mouse = getattr(Boss, "handle_tab_bar_mouse", None)
            Boss.handle_tab_bar_mouse = _krypton_boss_mouse
        if not hasattr(Boss, "_krypton_orig_boss_activate"):
            Boss._krypton_orig_boss_activate = getattr(Boss, "activate_tab_at", None)
            Boss.activate_tab_at = _krypton_boss_activate
    except Exception:
        pass

    try:
        boss = get_boss()
        if boss is not None and not hasattr(boss, "_krypton_inst_mouse_patched"):
            boss.handle_tab_bar_mouse = types.MethodType(_krypton_boss_mouse, boss)
            boss.activate_tab_at = types.MethodType(_krypton_boss_activate, boss)
            boss._krypton_inst_mouse_patched = True
    except Exception:
        pass

    try:
        from kitty.tabs import TabManager
        if not hasattr(TabManager, "_krypton_orig_tm_mouse"):
            TabManager._krypton_orig_tm_mouse = getattr(TabManager, "handle_tab_bar_mouse", None)
            TabManager.handle_tab_bar_mouse = _krypton_tm_mouse
        if not hasattr(TabManager, "_krypton_orig_tm_activate"):
            TabManager._krypton_orig_tm_activate = getattr(TabManager, "activate_tab_at", None)
            TabManager.activate_tab_at = _krypton_tm_activate
    except Exception:
        pass

    _patched = True


# Run initial patching on module load
try:
    _ensure_patch()
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
    global _last_cols, _last_cell_w, _last_win_w
    try:
        _ensure_patch()
    except Exception:
        pass

    _last_cols = screen.columns
    try:
        os_win = getattr(extra_data, "os_window_id", 0)
        get_window_geometry(os_win)
    except Exception:
        pass

    try:
        # Active vs Inactive Tab Header (Catppuccin Mocha aesthetic)
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
