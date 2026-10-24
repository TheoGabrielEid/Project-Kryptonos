"""
KryptonOS Kitty Custom Tab Bar & Navigation Header
Renders active tab and title on the left and navigation buttons (🗕, 🗖, ✕) on the right.
Clicking the buttons triggers system window management via krypton-win-ctl and Kitty boss.
"""
import subprocess
from kitty.fast_data_types import Screen, get_boss
from kitty.tab_bar import DrawData, ExtraData, TabBarData

_patched = False
_last_cols = 80
_last_cell_w = 10.0


def _ensure_patch():
    global _patched
    if _patched:
        return
    _patched = True

    try:
        from kitty.tabs import TabManager

        orig_activate_tab_at = TabManager.activate_tab_at

        def _krypton_activate_tab_at(self, *args, **kwargs):
            try:
                x = float(args[0]) if args else 0.0
                is_double = bool(args[1]) if len(args) > 1 else False
                cw = _last_cell_w
                if hasattr(self, "tab_bar") and getattr(self.tab_bar, "cell_width", 0):
                    cw = float(self.tab_bar.cell_width)
                cols = _last_cols
                if hasattr(self, "tab_bar") and hasattr(self.tab_bar, "screen") and getattr(self.tab_bar.screen, "columns", 0):
                    cols = int(self.tab_bar.screen.columns)

                col = int(x / max(1.0, cw))

                # Double click anywhere on empty bar toggles maximize / windowed
                if is_double and col < cols - 14:
                    subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "maximize"])
                    return

                # Navigation buttons occupy the last 14 columns
                # [🗕] cols-14 to cols-10 | [🗖] cols-9 to cols-5 | [✕] cols-4 to cols
                if col >= cols - 14:
                    if col >= cols - 4:
                        # Close (✕)
                        try:
                            get_boss().close_os_window(self.os_window_id)
                        except Exception:
                            subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "close"])
                    elif col >= cols - 9:
                        # Maximize / Fullscreen (🗖)
                        subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "maximize"])
                    else:
                        # Minimize (🗕)
                        subprocess.Popen(["/usr/local/bin/krypton-win-ctl", "minimize"])
                    return
            except Exception:
                pass

            return orig_activate_tab_at(self, *args, **kwargs)

        TabManager.activate_tab_at = _krypton_activate_tab_at

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
        _last_cell_w = float(getattr(draw_data, "cell_width", 10.0) or 10.0)
    except Exception:
        pass

    title = tab.title if tab.title else f"Terminal {index}"
    if len(title) > 30:
        title = title[:27] + "..."
    marker = "● " if tab.is_active else "○ "
    screen.draw(f" {marker}{title} ")
    end = screen.cursor.x

    if is_last:
        btns = " 🗕   🗖   ✕ "
        pad = screen.columns - screen.cursor.x - len(btns)
        if pad > 0:
            screen.draw(" " * pad)
        screen.draw(btns)

    return end
