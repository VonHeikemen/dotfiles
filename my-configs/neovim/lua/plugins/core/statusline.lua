local M = {}
local state = {}

local function default_hl(name, style, opts)
  opts = opts or {}
  local ok, hl = pcall(vim.api.nvim_get_hl_by_name, name, 1)
  if ok and (hl.background or hl.foreground) then
    return
  end

  if opts.link then
    vim.api.nvim_set_hl(0, name, {link = style})
    return
  end

  local normal = vim.api.nvim_get_hl_by_name('Normal', 1)
  local fallback = vim.api.nvim_get_hl_by_name(style, 1)

  vim.api.nvim_set_hl(0, name, {fg = normal.background, bg = fallback.foreground})
end

local mode_higroups = {
  ['NORMAL'] = 'UserStatusMode_NORMAL',
  ['VISUAL'] = 'UserStatusMode_VISUAL',
  ['V-BLOCK'] = 'UserStatusMode_V_BLOCK',
  ['V-LINE'] = 'UserStatusMode_V_LINE',
  ['INSERT'] = 'UserStatusMode_INSERT',
  ['COMMAND'] = 'UserStatusMode_COMMAND',
}

local function apply_hl()
  default_hl('UserStatusBlock', 'StatusLine', {link = true})
  default_hl('UserStatusMode_DEFAULT', 'Comment')

  default_hl(mode_higroups['NORMAL'],  'Directory')
  default_hl(mode_higroups['VISUAL'],  'Number')
  default_hl(mode_higroups['V-BLOCK'], 'Number')
  default_hl(mode_higroups['V-LINE'],  'Number')
  default_hl(mode_higroups['INSERT'],  'String')
  default_hl(mode_higroups['COMMAND'], 'Special')
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

function _G._statusline_component(name)
  return state[name]()
end

local function show_sign(mode)
  local empty = ' '

  -- This just checks a user defined variable
  -- it ignores completely if there are active clients
  if vim.b.lsp_attached == nil then
    return empty
  end

  local ok = ' λ '
  local ignore = {
    ['INSERT'] = true,
    ['COMMAND'] = true,
    ['TERMINAL'] = true
  }

  if ignore[mode] then
    return ok
  end

  local levels = vim.diagnostic.severity
  local errors = #vim.diagnostic.get(0, {severity = levels.ERROR})
  if errors > 0 then
    return ' ✘ '
  end

  local warnings = #vim.diagnostic.get(0, {severity = levels.WARN})
  if warnings > 0 then
    return ' ▲ '
  end

  return ok
end

state.show_diagnostic = false
state.mode_group = mode_higroups['NORMAL']

function state.mode()
  local mode = vim.api.nvim_get_mode().mode
  local mode_name = mode_map[mode]
  local text = ' '

  local higroup = mode_higroups[mode_name]

  if higroup then
    state.mode_group = higroup
    if state.show_diagnostic then text = show_sign(mode_name) end

    return fmt(hi_pattern, higroup, text)
  end

  state.mode_group = 'UserStatusMode_DEFAULT'
  text = fmt(' %s ', mode_name)
  return fmt(hi_pattern, state.mode_group, text)
end

function state.position()
  return fmt(hi_pattern, state.mode_group, ' %3l:%-2c ')
end

state.percent = fmt(hi_pattern, 'UserStatusBlock', ' %2p%% ')

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

state.inactive_status = {
  ' %t',
  '%r',
  '%m',
  '%=',
  '%{&filetype} |',
  ' %2p%% | ',
  '%3l:%-2c ',
}

function M.setup()
  local augroup = vim.api.nvim_create_augroup('statusline_cmds', {clear = true})
  local autocmd = vim.api.nvim_create_autocmd
  vim.opt.showmode = false

  apply_hl()
  local pattern = M.get_status('full')
  if pattern then
    vim.o.statusline = pattern
  end

  autocmd('ColorScheme', {
    group = augroup,
    desc = 'Apply statusline highlights',
    callback = apply_hl
  })
  autocmd('FileType', {
    group = augroup,
    pattern = {'ctrlsf', 'Neogit*'},
    desc = 'Apply short statusline',
    callback = function()
      vim.w.status_style = 'short'
      vim.wo.statusline = M.get_status('short')
    end
  })
  autocmd('InsertEnter', {
    group = augroup,
    desc = 'Clear message area',
    command = "echo ''"
  })
  autocmd('LspAttach', {
    group = augroup,
    once = true,
    desc = 'Show diagnostic sign',
    callback = function()
      state.show_diagnostic = true
    end
  })
  autocmd('WinEnter', {
    group = augroup,
    desc = 'Change statusline',
    callback = function()
      local winconfig = vim.api.nvim_win_get_config(0)
      if winconfig.relative ~= '' then
        return
      end

      local style = vim.w.status_style
      if style == nil then
        style = 'full'
        vim.w.status_style = style
      end

      vim.wo.statusline = M.get_status(style)

      local winnr = vim.fn.winnr('#')
      if winnr == 0 then
        return
      end

      local curwin = vim.api.nvim_get_current_win()
      local winid = vim.fn.win_getid(winnr)
      if winid == 0 or winid == curwin then
        return
      end

      if vim.api.nvim_win_is_valid(winid) then
        vim.wo[winid].statusline = M.get_status('inactive')
      end
    end
  })
end

function M.get_status(name)
  return table.concat(state[fmt('%s_status', name)], '')
end

function M.apply(name)
  vim.o.statusline = M.get_status(name)
end

function M.higroups()
  local res = vim.deepcopy(mode_higroups)
  res['DEFAULT'] = 'UserStatusMode_DEFAULT'
  res['STATUS-BLOCK'] = 'UserStatusBlock'
  return res
end

M.default_hl = apply_hl

return M

