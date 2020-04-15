# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

from typing import List  # noqa: F401

from os import path
import subprocess

mod = "mod4"
alt = "mod1"
ctrl = "control"
caps = "lock"

config_dir = path.expanduser("~/.config/qtile")
config_file = path.expanduser("~/.config/qtile/config.py")
log_file = path.expanduser("~/.local/share/qtile/qtile.log")

class Color:
    black = "#222222"
    white = "#DCE0DD"
    red = "#FC8680"
    green = "#87D37C"
    magenta = "#AD69AF"
    dark_blue = "#1D2330"
    gray = "#576275"

class App:
    terminal = "kitty"
    browser = "firefox"
    filemanager = "pcmanfm"
    editor = [terminal, "-e", "nvim"]
    tmux = [terminal, "-e", "tmux", "new-session", "-A", "-D", "-s"]
    musicplayer = tmux + ["music", '"$(which cmus)"']


def term_exec(cmd):
    return [App.terminal, "-e"] + cmd


def tmux_session(name, cmd=""):
    return App.tmux + [name, cmd]


def resolve(path):
    return config_dir + "/" + path


def edit_file(path):
    return App.editor + [path]


def init_layout_theme():
    return {
        "single_border_width": 0,
        "border_width": 1,
        "margin": 0,
        "border_focus": border_focus,
        "border_normal": Color.black,
    }


def set_layout(index):
    return lazy.function(lambda qtile: qtile.cmd_to_layout_index(index))


def move_mouse(mov_x, mov_y):
    def move(qtile):
        subprocess.call([
            "xdotool",
            "mousemove_relative",
            "--sync",
            "--",
            str(mov_x),
            str(mov_y)
        ])

    return lazy.function(move)


def hide_bar(qtile):
    qtile.cmd_hide_show_bar()


border_focus = Color.magenta
lock_screen = lambda qtile: subprocess.call(["blurlock"])
inspect_log = lambda: term_exec(["less", "+F", log_file])

keys = [
    # Launch common applications
    Key([mod], "Return", lazy.spawn(App.terminal)),
    Key([mod], "F2", lazy.spawn(App.browser)),
    Key([mod], "F3", lazy.spawn(App.filemanager)),
    Key([mod], "F4", lazy.spawn("galculator")),
    Key([mod], "F12", lazy.spawn(App.musicplayer)),
    Key([mod], "p", lazy.spawn(term_exec(["htop"]))),
    Key([mod, "shift"], "p", lazy.spawn(tmux_session("pomodoro"))),

    # Run an application
    Key([mod], "d", lazy.spawn(["rofi", "-show", "drun"])),

    # Close application
    Key([mod, "shift"], "q", lazy.window.kill()),

    # Lock screen
    Key([mod], "9", lazy.function(lock_screen)),

    # Exit qtile
    Key([mod], "Escape", lazy.spawn(["powermenu", resolve("powermenu.conf")])),

    # Toggle bar
    Key([mod], "b", lazy.function(hide_bar)),

    # Toggle floating window
    Key([mod], "f", lazy.window.toggle_floating()),

    # Toggle between different layouts
    Key([mod], "t", set_layout(0)),        # set monadtall
    Key([mod], "u", set_layout(1)),        # set monadwide
    Key([mod], "m", set_layout(2)),        # set max
    Key([mod], "Tab", lazy.next_layout()), # rotate layouts

    # Move window focus in current group
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),

    # Move windows up or down in current stack
    Key([mod, "control"], "k", lazy.layout.shuffle_down()),
    Key([mod, "control"], "j", lazy.layout.shuffle_up()),

    # Switch window focus to other pane(s) of stack
    Key([mod], "space", lazy.layout.next()),
    Key([mod, "shift"], "space", lazy.layout.previous()),

    # Resize windows
    Key([mod], "bracketright", lazy.layout.grow()),
    Key([mod], "bracketleft", lazy.layout.shrink()),
    Key([mod], "e", lazy.layout.normalize()),

    # Move floating window
    Key([mod, ctrl], "Left", lazy.window.move_floating(-25, 0, None, None)),
    Key([mod, ctrl], "Right", lazy.window.move_floating(25, 0, None, None)),
    Key([mod, ctrl], "Up", lazy.window.move_floating(0, -25, None, None)),
    Key([mod, ctrl], "Down", lazy.window.move_floating(0, 25, None, None)),

    # Resize floating window
    Key([mod, alt], "Left", lazy.window.resize_floating(-25, 0, None, None)),
    Key([mod, alt], "Right", lazy.window.resize_floating(25, 0, None, None)),
    Key([mod, alt], "Up", lazy.window.resize_floating(0, -25, None, None)),
    Key([mod, alt], "Down", lazy.window.resize_floating(0, 25, None, None)),
    Key([mod, alt, ctrl], "Down", lazy.window.resize_floating(-25, -25, None, None)),
    Key([mod, alt, ctrl], "Up", lazy.window.resize_floating(25, 25, None, None)),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "r", lazy.spawncmd()),

    # Inspect log file
    Key([mod], "F6", lazy.spawn(inspect_log())),

    # Control cmus
    Key([], "F9", lazy.spawn("cmus-remote --pause")),
    Key([], "F10", lazy.spawn("cmus-remote --prev")),
    Key([], "F11", lazy.spawn("cmus-remote --next")),
    Key([mod], "equal", lazy.spawn("cmus-remote --vol +10%")),
    Key([mod], "minus", lazy.spawn("cmus-remote --vol -10%")),

    # Take screenshot
    Key([], "Print", lazy.spawn("i3-scrot")),
    Key([mod], "Print", lazy.spawn("i3-scrot -w")),
    Key([mod, "shift"], "Print", lazy.spawn('sh -c "i3-scrot -s"')),

    # Move mouse
    Key([caps], "KP_Left", move_mouse(-25, 0)),
    Key([caps], "KP_Right", move_mouse(25, 0)),
    Key([caps], "KP_Up", move_mouse(0, -25)),
    Key([caps], "KP_Begin", move_mouse(0, 25)),
    Key([caps], "KP_Insert", lazy.spawn(["xdotool", "click", "1"])),
    Key([caps], "KP_End", lazy.spawn(["xdotool", "click", "3"])),

    # Move mouse cursor to a corner
    Key([mod], "x", lazy.spawn("xdotool mousemove 0 1080")),

    # Move mouse cursor to the center of the screen
    Key([mod, "shift"], "x", lazy.spawn("xdotool mousemove 960 540")),
]

groups = [Group(i) for i in "1234"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen()),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ])


layout_theme = init_layout_theme()

layouts = [
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
    layout.Max()
]

widget_defaults = dict(
    font='Noto Color',
    fontsize=12,
    padding=3,
    foreground=Color.white,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        top=bar.Bar(
            [
                widget.GroupBox(),
                widget.CurrentLayoutIcon(scale=0.6),
                widget.Prompt(prompt="Run: "),
                widget.Sep(foreground=Color.black),
                widget.WindowTags(selected=("  ", "")),
                widget.Clock(format='%A, %B %d | %l:%M %p '),
                widget.Systray(),
            ],
            24,
            background=Color.black
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        {'wmclass': 'confirm'},
        {'wmclass': 'dialog'},
        {'wmclass': 'download'},
        {'wmclass': 'error'},
        {'wmclass': 'file_progress'},
        {'wmclass': 'notification'},
        {'wmclass': 'splash'},
        {'wmclass': 'toolbar'},
        {'wmclass': 'confirmreset'},  # gitk
        {'wmclass': 'makebranch'},  # gitk
        {'wmclass': 'maketag'},  # gitk
        {'wname': 'branchdialog'},  # gitk
        {'wname': 'pinentry'},  # GPG key password entry
        {'wmclass': 'ssh-askpass'},  # ssh-askpass
        {"wmclass": "Pamac-manager"},
        {"wmclass": "Galculator"},
        {"wmclass": "alsamixer"},
        {"wmclass": "Nitrogen"},
        {"wmclass": "gcolor2"},
    ],
    border_focus=border_focus
)

auto_fullscreen = True
focus_on_window_activation = "smart"

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"

@hook.subscribe.startup_once
def start_once():
    subprocess.call([path.expanduser("~/my-configs/autostart.sh")])

