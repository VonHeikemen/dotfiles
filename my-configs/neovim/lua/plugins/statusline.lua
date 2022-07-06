local M = {}
local state = {}

local default_hl = function(name, style)
  local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, 1)
  if hl == 0 then return end
  vim.api.nvim_set_hl(0, name, style)
end

local mode_higroups = {
  ['NORMAL'] = 'Mode_NORMAL',
  ['VISUAL'] = 'Mode_VISUAL',
  ['V-BLOCK'] = 'Mode_V_BLOCK',
  ['V-LINE'] = 'Mode_V_LINE',
  ['INSERT'] = 'Mode_INSERT',
  ['COMMAND'] = 'Mode_COMMAND',
}

local apply_hl = function()
  default_hl('StatusPercent', {bg = '#464D5D', fg = '#D8DEE9'})
  default_hl('Mode_xx', {bg = '#FC8680', fg = '#353535', bold = true})

  default_hl(mode_higroups['NORMAL'],  {bg = '#6699CC', fg = '#353535'})
  default_hl(mode_higroups['VISUAL'],  {bg = '#DDA0DD', fg = '#353535'})
  default_hl(mode_higroups['V-BLOCK'], {link = mode_higroups['VISUAL']})
  default_hl(mode_higroups['V-LINE'],  {link = mode_higroups['VISUAL']})
  default_hl(mode_higroups['INSERT'],  {bg = '#99C794', fg = '#353535'})
  default_hl(mode_higroups['COMMAND'], {bg = '#5FB4B4', fg = '#101010'})
end

-- mode_map copied from:
-- https://github.com/nvim-lualine/lualine.nvim/blob/5113cdb32f9d9588a2b56de6d1df6e33b06a554a/lua/lualine/utils/mode.lua
local mode_map = {
  ['n']      = 'NORMAL',
  ['no']     = 'O-PENDING',
  ['nov']    = 'O-PENDING',
  ['noV']    = 'O-PENDING',
  ['no\22']  = 'O-PENDING',
  ['niI']    = 'NORMAL',
  ['niR']    = 'NORMAL',
  ['niV']    = 'NORMAL',
  ['nt']     = 'NORMAL',
  ['v']      = 'VISUAL',
  ['vs']     = 'VISUAL',
  ['V']      = 'V-LINE',
  ['Vs']     = 'V-LINE',
  ['\22']    = 'V-BLOCK',
  ['\22s']   = 'V-BLOCK',
  ['s']      = 'SELECT',
  ['S']      = 'S-LINE',
  ['\19']    = 'S-BLOCK',
  ['i']      = 'INSERT',
  ['ic']     = 'INSERT',
  ['ix']     = 'INSERT',
  ['R']      = 'REPLACE',
  ['Rc']     = 'REPLACE',
  ['Rx']     = 'REPLACE',
  ['Rv']     = 'V-REPLACE',
  ['Rvc']    = 'V-REPLACE',
  ['Rvx']    = 'V-REPLACE',
  ['c']      = 'COMMAND',
  ['cv']     = 'EX',
  ['ce']     = 'EX',
  ['r']      = 'REPLACE',
  ['rm']     = 'MORE',
  ['r?']     = 'CONFIRM',
  ['!']      = 'SHELL',
  ['t']      = 'TERMINAL',
}

local fmt = string.format
local hi_pattern = '%%#%s#%s%%*'

_G._statusline_component = function(name)
  return state[name]()
end

state.mode_group = mode_higroups['NORMAL']

state.mode = function()
  local mode = vim.api.nvim_get_mode().mode
  local mode_name = mode_map[mode]

  local higroup = mode_higroups[mode_name] 

  if higroup then
    state.mode_group = higroup
    return fmt(hi_pattern, higroup, ' ')
  end
  
  state.mode_group = 'Mode_xx'
  local text = fmt(' %s ', mode_name)
  return fmt(hi_pattern, state.mode_group, text)
end

state.position = function()
  return fmt(hi_pattern, state.mode_group, ' %2l:%-2c ')
end

state.percent = fmt(hi_pattern, 'StatusPercent', ' %3p%% ')

state.full_status = {
  '%{%v:lua._statusline_component("mode")%} ',
  '%t',
  '%r',
  '%m',
  '%=',
  '%{&filetype} ',
  state.percent,
  '%{%v:lua._statusline_component("position")%}'
}

state.short_status = {
  state.full_status[1],
  '%=',
  state.percent,
  state.full_status[8]
}

M.setup = function()
  local augroup = vim.api.nvim_create_augroup('statusline_cmds', {clear = true})
  local autocmd = vim.api.nvim_create_autocmd
  vim.opt.showmode = false

  apply_hl()
  autocmd('ColorScheme', {
    group = augroup,
    desc = 'Apply statusline highlights',
    callback = apply_hl
  })
  autocmd('FileType', {
    desc = 'Apply short statusline',
    group = augroup,
    pattern = {'lir', 'Neogit*'},
    callback = function()
      vim.wo.statusline = M.get_status('short')
    end
  })
end

M.get_status = function(name)
  return table.concat(state[fmt('%s_status', name)], '')
end

M.apply = function(name)
  vim.o.statusline = M.get_status(name)
end

return M

