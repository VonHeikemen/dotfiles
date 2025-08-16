local state = {}

local fmt = string.format
local hi_pattern = '%%#%s#%s%%*'
local get_option = vim.api.nvim_get_option_value

state.default_pattern = table.concat({
  '%{%g:stl_mode%} ',
  '%t',
  '%r',
  '%m',
  '%=',
  '%{&filetype} ',
  '%2p%% ',
  '%{%g:stl_position%}'
}, '')

state.short_pattern = table.concat({
  '%{%g:stl_mode%}',
  '%=',
  '%2p%% ',
  '%{%g:stl_position%}'
}, '')

state.inactive_pattern = table.concat({
  ' %t',
  '%r',
  '%m',
  '%=',
  '%{&filetype} |',
  ' %2p%% | ',
  '%3l:%-2c ',
}, '')

-- Use mini.statusline highlight groups because 
-- popular colorschemes already support them
local mode_higroups = {
  ['DEFAULT'] = 'MiniStatuslineModeOther',
  ['NORMAL'] = 'MiniStatuslineModeNormal',
  ['VISUAL'] = 'MiniStatuslineModeVisual',
  ['O-PENDING'] = 'MiniStatuslineModeVisual',
  ['V-BLOCK'] = 'MiniStatuslineModeVisual',
  ['V-LINE'] = 'MiniStatuslineModeVisual',
  ['INSERT'] = 'MiniStatuslineModeInsert',
  ['SELECT'] = 'MiniStatuslineModeInsert',
  ['REPLACE'] = 'MiniStatuslineModeInsert',
  ['COMMAND'] = 'MiniStatuslineModeCommand',
}

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

function state.set_mode()
  local mode = vim.api.nvim_get_mode().mode
  local mode_name = mode_map[mode]
  local text = ' '

  local higroup = mode_higroups[mode_name]

  if higroup then
    state.mode_group = higroup

    if state.show_diagnostic then
      text = state.show_sign(mode_name)
    end

    vim.g.stl_mode = fmt(hi_pattern, higroup, text)
    return
  end

  state.mode_group = mode_higroups['DEFAULT']
  text = fmt(' %s ', mode_name)

  vim.g.stl_mode = fmt(hi_pattern, state.mode_group, text)
end

function state.position()
  vim.g.stl_position = fmt(hi_pattern, state.mode_group, ' %3l:%-2c ')
end

function state.show_sign(mode)
  local empty = ' '
  local bufnr = vim.api.nvim_get_current_buf()

  -- This just checks a user defined variable
  -- it ignores completely if there are linters
  if vim.b[bufnr].linter_attached == nil then
    return empty
  end

  local ok = ' λ '
  local ignore = {
    'INSERT',
    'COMMAND',
    'TERMINAL'
  }

  if vim.tbl_contains(ignore, mode) then
    return ok
  end

  local errors = #vim.diagnostic.count(bufnr, {severity = 1})
  if errors > 0 then
    return ' ✘ '
  end

  local warnings = #vim.diagnostic.count(bufnr, {severity = 2})
  if warnings > 0 then
    return ' ▲ '
  end

  return ok
end

function state.restore_active()
  if state.transition == 'done' then
    return
  end

  -- restore pattern of current window
  local current_pattern = get_option('statusline', {scope = 'local'})
  if current_pattern == state.inactive_pattern then
    if vim.w.stl_style == 'short' then
      vim.wo.statusline = state.short_pattern
    else
      vim.wo.statusline = nil
    end
  end
end

local function apply_default_hl()
  local get = vim.api.nvim_get_hl
  local set = vim.api.nvim_set_hl
  local normal = get(0, {name = 'Normal'})

  local defaults = {
    DEFAULT = 'Comment',
    NORMAL = 'Directory',
    INSERT = 'String',
    COMMAND = 'Special',
    VISUAL = 'Number'
  }

  for name, style in pairs(defaults) do
    local group = mode_higroups[name]
    local hl = next(get(0, {name = group}))
    if hl == nil then
      local fallback = get(0, {name = style, link = false})
      local ctermfg = rawget(normal, 'ctermbg')
      local ctermbg = rawget(fallback, 'ctermfg')

      local new_hl = {fg = normal.bg, bg = fallback.fg}
      if ctermfg and ctermbg then
        new_hl.ctermfg = ctermfg
        new_hl.ctermbg = ctermbg
      else
        new_hl.cterm = {reverse = true}
      end

      set(0, group, new_hl)
    end
  end
end

---
-- Setup
---

state.set_mode()
state.position()
apply_default_hl()

vim.o.showmode = false
vim.o.statusline = state.default_pattern

local augroup = vim.api.nvim_create_augroup('statusline_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command

command('StlDiagnostics', function(input)
  local param = input.args

  if param == 'enable' then
    state.show_diagnostic = true
  elseif param == 'disable' then
    state.show_diagnostic = false
  elseif param == 'toggle' then
    state.show_diagnostic = not state.show_diagnostic
  else
    local msg = fmt('Invalid command "%s"', param)
    vim.notify(msg, vim.log.levels.WARN)
    return
  end

  if input.bang then
    vim.cmd('redrawstatus')
  end
end, {nargs = 1, bang = true, desc = 'Manage diagnostic icon in statusline'})

autocmd('ColorScheme', {
  group = augroup,
  desc = 'Ensure statusline highlights',
  callback = apply_default_hl,
})

autocmd({'ModeChanged', 'BufEnter', 'DiagnosticChanged'}, {
  group = augroup,
  desc = 'Update statusline highlights',
  callback = function()
    state.set_mode()
    state.position()
    state.update_done = false
    vim.schedule(function()
      if state.update_done then
        return
      end

      state.update_done = true
      vim.cmd('redrawstatus')
    end)
  end
})

autocmd('FileType', {
  group = augroup,
  desc = 'Apply "short" statusline pattern',
  pattern = {'lir', 'ctrlsf'},
  callback = function(event)
    vim.wo.statusline = state.short_pattern
    vim.w.stl_style = 'short'

    autocmd('BufUnload', {
      buffer = event.buf,
      callback = function()
        vim.w.stl_style = 'default'
      end
    })
  end,
})

autocmd('LspAttach', {
  group = augroup,
  once = true,
  desc = 'Enable diagnostic check in statusline',
  callback = function(event)
    local id = vim.tbl_get(event, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)
    if client == nil then
      return
    end

    if client:supports_method('textDocument/diagnostics') then
      state.show_diagnostic = true
    end
  end,
})

autocmd('LspAttach', {
  group = augroup,
  desc = 'Show diagnostic sign in statusline',
  callback = function(event)
    local id = vim.tbl_get(event, 'data', 'client_id')
    local client = id and vim.lsp.get_client_by_id(id)
    if client == nil then
      return
    end

    if client:supports_method('textDocument/diagnostics') then
      vim.b.linter_attached = 1
      vim.cmd('redrawstatus')
    end
  end
})

autocmd('WinLeave', {
  group = augroup,
  desc = 'Store previous window id',
  callback = function()
    state.prev_win = vim.api.nvim_get_current_win()
    state.transition = 'leave'

    -- try to restore statusline if WinEnter is never triggered
    vim.schedule(state.restore_active)
  end,
})

autocmd('WinEnter', {
  group = augroup,
  desc = 'Handle state',
  callback = function()
    -- don't do anything if its a floating window
    local winconfig = vim.api.nvim_win_get_config(0)
    if winconfig.relative ~= '' then
      state.transition = 'done'
      return
    end

    -- restore current window pattern
    state.restore_active()

    -- apply inactive state in previous window
    local winid = state.prev_win
    if winid and vim.api.nvim_win_is_valid(winid) then
      vim.wo[winid].statusline = state.inactive_pattern
    end

    state.transition = 'done'
  end,
})

