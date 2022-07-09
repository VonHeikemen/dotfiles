local M = {}
local state = {}

local default_hl = function(name, style)
  local ok, _ = pcall(vim.api.nvim_get_hl_by_name, name, 1)
  if ok then return end

  vim.api.nvim_set_hl(0, name, style)
end

local mode_higroups = {
  ['NORMAL'] = 'UserStatusMode_NORMAL',
  ['VISUAL'] = 'UserStatusMode_VISUAL',
  ['V-BLOCK'] = 'UserStatusMode_V_BLOCK',
  ['V-LINE'] = 'UserStatusMode_V_LINE',
  ['INSERT'] = 'UserStatusMode_INSERT',
  ['COMMAND'] = 'UserStatusMode_COMMAND',
}

local apply_hl = function()
  default_hl('UserStatusBlock', {bg = '#464D5D', fg = '#D8DEE9'})
  default_hl('UserStatusMode_xx', {bg = '#FC8680', fg = '#353535', bold = true})

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

local show_sign = function(mode)
  local empty = ' '

  -- This just checks a user defined variable
  -- it ignores completely if there are active clients
  if vim.b.lsp_attached == nil then
    return empty
  end

  local ok = ' λ '
  local ignore = {
    ['INSERT'] = true,
    ['COMMAND'] = true
  }

  if ignore[mode] then return ok end

  local levels = vim.diagnostic.severity
  local errors = #vim.diagnostic.get(0, {severity = levels.ERROR})
  if errors > 0 then return ' ✘ ' end

  local warnings = #vim.diagnostic.get(0, {severity = levels.WARN})
  if warnings > 0 then return ' ▲ ' end

  return ok
end

state.show_diagnostic = false
state.mode_group = mode_higroups['NORMAL']

state.mode = function()
  local mode = vim.api.nvim_get_mode().mode
  local mode_name = mode_map[mode]
  local text = ' '

  local higroup = mode_higroups[mode_name]

  if higroup then
    state.mode_group = higroup
    if state.show_diagnostic then text = show_sign(mode_name) end

    return fmt(hi_pattern, higroup, text)
  end

  state.mode_group = 'UserStatusMode_xx'
  text = fmt(' %s ', mode_name)
  return fmt(hi_pattern, state.mode_group, text)
end

state.position = function()
  return fmt(hi_pattern, state.mode_group, ' %2l:%-2c ')
end

state.percent = fmt(hi_pattern, 'UserStatusBlock', ' %3p%% ')

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

M.setup = function(status)
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
    group = augroup,
    pattern = {'lir', 'Neogit*'},
    desc = 'Apply short statusline',
    callback = function()
      vim.wo.statusline = M.get_status('short')
    end
  })
  autocmd('InsertEnter', {
    group = augroup,
    desc = 'Clear message area',
    command = "echo ''"
  })
  autocmd('User', {
    group = augroup,
    once = true,
    pattern = 'LspAttached',
    desc = 'Show diagnostic sign',
    callback = function()
      state.show_diagnostic = true
    end
  })

  local pattern = M.get_status(status)
  if pattern then
    vim.o.statusline = pattern
  end
end

M.get_status = function(name)
  return table.concat(state[fmt('%s_status', name)], '')
end

M.apply = function(name)
  vim.o.statusline = M.get_status(name)
end

M.higroups = function()
  local res = vim.deepcopy(mode_higroups)
  res['DEFAULT'] = 'UserStatusMode_xx'
  res['STATUS-BLOCK'] = 'UserStatusBlock'
  return res
end

return M

