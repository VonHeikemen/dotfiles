local wezterm = require('wezterm')
local action = wezterm.action
local config = wezterm.config_builder()

config.font = wezterm.font_with_fallback({
  'Liberation Mono',
  'Noto Color Emoji'
})

config.font_size = 12
config.harfbuzz_features = { 'calt = 0', 'clig = 0', 'liga = 0' }

config.max_fps = 120

config.color_scheme = 'Sigil'
config.hide_tab_bar_if_only_one_tab = true
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.window_padding = {left = 0, right = 0, top = 0, bottom = 0}

config.leader = {key = 'g', mods = 'ALT'}

config.keys = {
  {key = 'w', mods = 'ALT', action = action.ActivateKeyTable({name = 'alt_w'})},
  {key = 'q', mods = 'ALT', action = action.ActivateCopyMode},
  {key = ',', mods = 'LEADER', action = action.PromptInputLine({
    description = 'Rename tab',
    action = wezterm.action_callback(function(window, pane, line)
      if line == nil or line == '' then
        return
      end

      window:active_tab():set_title(line)
    end)
  })}
}

config.key_tables = {
  alt_w = {
    {key = '1', action = action.ActivateTab(0)},
    {key = '2', action = action.ActivateTab(1)},
    {key = '3', action = action.ActivateTab(2)},
    {key = '4', action = action.ActivateTab(3)},
    {key = 'f', action = action.ActivateTabRelative(1)},
    {key = 'b', action = action.ActivateTabRelative(-1)},
    {key = 'o', action = action.ActivateLastTab},

    {key = 'f', mods = 'SHIFT', action = action.MoveTabRelative(1)},
    {key = 'b', mods = 'SHIFT', action = action.MoveTabRelative(-1)},

    {key = 'h', action = action.ActivatePaneDirection('Left')},
    {key = 'j', action = action.ActivatePaneDirection('Down')},
    {key = 'k', action = action.ActivatePaneDirection('Up')},
    {key = 'l', action = action.ActivatePaneDirection('Right')},

    {key = 'i', action = action.SpawnTab('CurrentPaneDomain')},
    {key = 's', action = action.SplitVertical({domain = 'CurrentPaneDomain'})},
    {key = 'v', action = action.SplitHorizontal({domain = 'CurrentPaneDomain'})},
    {key = 'q', action = action.CloseCurrentTab({confirm = true})},
    {
      key = 'c',
      action = action.SpawnCommandInNewTab({
        label = 'Arch dev',
        args = {'distrobox', 'enter', 'arch-dev'},
      })
    },
  }
}

return config

