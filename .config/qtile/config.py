from libqtile.config import Key, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, bar, widget, hook

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
    black = "#242830"
    white = "#DCE0DD"
    red = "#FC8680"
    green = "#87D37C"
    magenta = "#AD69AF"
    dark_blue = "#1D2330"
    gray = "#576275"

class App:
    terminal = "kitty"
    browser = "firefox-developer-edition"
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
        "border_width": 2,
        "margin": 0,
        "border_focus": border_focus,
        "border_normal": Color.black,
    }


def set_layout(index):
    return lazy.function(lambda qtile: qtile.cmd_to_layout_index(index))


def reload_config(qtile):
    try:
        from py_compile import compile
        compile(config_file, doraise=True)
        qtile.cmd_restart()
    except Exception as err:
        from libqtile.log_utils import logger

        logger.error(err)
        qtile.cmd_spawn(inspect_log())


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


border_focus = Color.gray
lock_screen = lambda qtile: subprocess.call(["blurlock"])
inspect_log = lambda: term_exec(["less", "+F", log_file])
layout_theme = init_layout_theme()


keys = [
    # Launch common applications
    Key([mod], "Return", lazy.spawn(App.terminal)),
    Key([mod], "F2", lazy.spawn(App.browser)),
    Key([mod], "F3", lazy.spawn(App.filemanager)),
    Key([mod], "o", lazy.spawn(App.editor)),
    Key([mod], "F12", lazy.spawn(App.musicplayer)),
    Key([mod], "p", lazy.spawn(term_exec(["htop"]))),
    Key([mod, "shift"], "p", lazy.spawn(tmux_session("pomodoro"))),
    Key([mod], "F4", lazy.spawn("galculator")),
    Key([mod], "i", lazy.spawn("pamac-manager")),

    # Run an application (mod + backtick)
    Key([mod], "grave", lazy.spawn('sh -c "dmenu_recency"')),

    # Close application
    Key([mod, "shift"], "q", lazy.window.kill()),

    # Lock screen
    Key([mod], "9", lazy.function(lock_screen)),

    # Exit qtile
    Key([mod], "Escape", lazy.spawn(["oblogout", "-c", resolve("oblogout.conf")])),

    # Toggle between different layouts
    Key([mod], "a", set_layout(0)),        # set column
    Key([mod], "s", set_layout(2)),        # set monadwide
    Key([mod], "Tab", lazy.next_layout()), # rotate layouts

    # Move window focus in current group
    Key([mod], "h", lazy.layout.left()),
    Key([mod], "l", lazy.layout.right()),
    Key([mod], "j", lazy.layout.down()),
    Key([mod], "k", lazy.layout.up()),
    Key([mod], "space", lazy.group.next_window()),

    # Move windows
    Key([mod, "shift"], "h",
        lazy.layout.swap_left(),
        lazy.layout.shuffle_left()
    ),
    Key([mod, "shift"], "l",
        lazy.layout.swap_right(),
        lazy.layout.shuffle_right()
    ),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up()),

    # Resize windows
    Key([mod, alt], "h", lazy.layout.grow_left()),
    Key([mod, alt], "l", lazy.layout.grow_right()),
    Key([mod, alt], "j", lazy.layout.grow_down()),
    Key([mod, alt], "k", lazy.layout.grow_up()),
    Key([mod], "bracketright", lazy.layout.grow()),
    Key([mod], "bracketleft", lazy.layout.shrink()),
    Key([mod, alt], "equal", lazy.layout.normalize()),

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

    # Manage window
    Key([mod], "q", lazy.window.toggle_floating()),
    Key([mod], "w", lazy.window.toggle_maximize()),
    Key([mod], "e", lazy.window.toggle_minimize()),
    Key([mod], "f", lazy.window.bring_to_front()),

    # Move between groups
    Key([mod], "g", lazy.screen.next_group()),
    Key([mod, "shift"], "g", lazy.screen.prev_group()),
    Key([mod], "b", lazy.screen.toggle_group()),

    # Restart qtile
    Key([mod, "shift"], "F5", lazy.function(reload_config)),

    # Edit this file
    Key([mod], "F5", lazy.spawn(edit_file(config_file))),

    # Inspect log file
    Key([mod], "F6", lazy.spawn(inspect_log())),

    # Open config directory
    Key([mod], "F7", lazy.spawn([App.filemanager, config_dir])),

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
    Key([mod], "u", lazy.spawn("xdotool mousemove 0 1080")),

    # Move mouse cursor to the center of the screen
    Key([mod, "shift"], "u", lazy.spawn("xdotool mousemove 960 540")),
]

groups = [Group(i) for i in "1234"]

for i in groups:
    keys.extend([
        # mod + group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen()),

        # mod + shift + group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name)),
    ])

layouts = [
    layout.Columns(
        border_focus=layout_theme.get("border_focus"),
        border_normal=layout_theme.get("border_normal")
    ),
    layout.MonadTall(**layout_theme),
    layout.MonadWide(**layout_theme),
]

widget_defaults = dict(
    font="Noto Color",
    fontsize=14,
    padding=3,
    foreground=Color.white,
)
extension_defaults = widget_defaults.copy()

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(disable_drag=True),
                widget.CurrentLayoutIcon(scale=0.6),
                widget.Prompt(prompt="Run: "),
                widget.Sep(foreground=Color.black),
                widget.WindowName(),
                widget.Cmus(
                    play_color=Color.green,
                    noplay_color=Color.red,
                ),
                widget.TextBox(text=" 🗓"),
                widget.Clock(format="%a %I:%M %p %d-%m"),
                widget.Systray(),
            ],
            24,
            background=Color.black,
        )
    )
]

# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod],
        "Button3",
        lazy.window.set_size_floating(),
        start=lazy.window.get_size(),
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(
    float_rules=[
        {"wmclass": "confirm"},
        {"wmclass": "dialog"},
        {"wmclass": "download"},
        {"wmclass": "error"},
        {"wmclass": "file_progress"},
        {"wmclass": "notification"},
        {"wmclass": "splash"},
        {"wmclass": "toolbar"},
        {"wmclass": "confirmreset"},
        {"wmclass": "makebranch"},
        {"wmclass": "maketag"},
        {"wname": "branchdialog"},
        {"wname": "pinentry"},
        {"wmclass": "ssh-askpass"},
        {"wmclass": "Pamac-manager"},
        {"wmclass": "Galculator"},
        {"wmclass": "alsamixer"},
        {"wmclass": "Nitrogen"},
        {"wmclass": "gcolor2"},
    ],
    border_focus=border_focus,
)

auto_fullscreen = True
focus_on_window_activation = "smart"

wmname = "LG3D"

@hook.subscribe.startup_once
def start_once():
    subprocess.call([resolve("autostart.sh")])

