local M = {}
local state = {}

local fmt = string.format
local hi_pattern = '%%#%s#%s%%*'

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

local mode_higroups = {
  ['DEFAULT'] = 'MiniStatuslineModeOther',
  ['NORMAL'] = 'MiniStatuslineModeNormal',
  ['VISUAL'] = 'MiniStatuslineModeVisual',
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

    if M.show_diagnostic then
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
  local get = vim.api.nvim_get_option_value
  local current_pattern = get('statusline', {scope = 'local'})
  if current_pattern == state.inactive_pattern then
    if vim.w.stl_style == 'short' then
      vim.wo.statusline = state.short_pattern
    else
      vim.wo.statusline = nil
    end
  end
end

function M.apply_default_hl()
  local get = vim.api.nvim_get_hl
  local set = vim.api.nvim_set_hl
  local normal = get(0, {name = 'Normal'})

  local default_hl = function(name, style)
    local hl = next(get(0, {name = name}))
    if hl then
      return
    end

    local fallback = get(0, {name = style, link = false})

    set(0, name, {fg = normal.bg, bg = fallback.fg})
  end

  local group = mode_higroups
  default_hl(group['DEFAULT'], 'Comment')
  default_hl(group['NORMAL'], 'Directory')
  default_hl(group['INSERT'], 'String')
  default_hl(group['COMMAND'], 'Special')
  default_hl(group['VISUAL'], 'Number')
  default_hl(group['V-BLOCK'], 'Number')
  default_hl(group['V-LINE'], 'Number')
end

function M.setup()
  state.set_mode()
  state.position()

  vim.o.showmode = false
  vim.o.statusline = state.default_pattern

  local augroup = vim.api.nvim_create_augroup('statusline_cmds', {clear = true})
  local autocmd = vim.api.nvim_create_autocmd

  autocmd('ColorScheme', {
    group = augroup,
    desc = 'Ensure statusline highlights',
    callback = M.apply_default_hl,
  })

  autocmd({'ModeChanged', 'BufEnter', 'DiagnosticChanged'}, {
    group = augroup,
    desc = 'Update statusline highlights',
    callback = function()
      state.set_mode()
      state.position()
      vim.cmd('redrawstatus')
    end
  })

  autocmd('FileType', {
    group = augroup,
    desc = 'Apply "short" statusline pattern',
    pattern = {'lir', 'ctrlsf'},
    callback = function(event)
      vim.w.stl_style = 'short'
      vim.wo.statusline = state.short_pattern

      autocmd('BufUnload', {
        buffer = event.buf,
        callback = function()
          vim.w.stl_style = nil
          vim.wo.statusline = nil
        end,
      })
    end,
  })

  autocmd('LspAttach', {
    group = augroup,
    once = true,
    desc = 'Enable diagnostic check in statusline';
    callback = function()
      M.show_diagnostic = true
    end,
  })

  autocmd('LspAttach', {
    group = augroup,
    desc = 'Show diagnostic sign in statusline',
    callback = function(event)
      local id = vim.tbl_get(event, 'data', 'client_id')
      local client = id and vim.lsp.get_client_by_id(id)

      if client then
        vim.b.linter_attached = 1
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
end

return M

