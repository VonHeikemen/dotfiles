local wezterm = require('wezterm')
local config = {}

config.font = wezterm.font('DejaVu Sans Mono')
config.font_size = 12

config.max_fps = 120
config.webgpu_power_preference = 'HighPerformance'

config.color_scheme = 'Sigil'
config.hide_tab_bar_if_only_one_tab = true
config.window_padding = {left = 0, right = 0, top = 0, bottom = 0}

return config

