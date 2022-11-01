local M = {}
local concat  = '%s%s'
local active_tab_highlight = 'UserTablineSeparator'
local separator_active = ''

function M.setup()
  M.set_separator()
  _G._user_tabline = M.tabline
  vim.o.tabline = '%!v:lua._user_tabline()'
end

function M.tabpage(opts)
  local highlight = '%#TabLine#'
  local separator = '%#TabLine#▏'
  local label = '[No Name]'

  if opts.selected then
    highlight = '%#TabLineSel#'
    separator = separator_active
  end

  if opts.bufname ~= '' then
    label = vim.fn.pathshorten(vim.fn.fnamemodify(opts.bufname, ':p:~:t'))
  end

  local str = '%s%s%s '
  return str:format(separator, highlight, label)
end

function M.tabline()
  local line = ''
  local tabs = vim.fn.tabpagenr('$')

  for index = 1, tabs, 1 do
    local buflist = vim.fn.tabpagebuflist(index)
    local winnr = vim.fn.tabpagewinnr(index)
    local bufname = vim.fn.bufname(buflist[winnr])

    line = concat:format(
      line,
      M.tabpage({
        selected = vim.fn.tabpagenr() == index,
        bufname = bufname,
      })
    )
  end

  line = concat:format(line, '%#TabLineFill#%=')

  if tabs > 1 then
    line = concat:format(line, '%#TabLine#%999XX')
  end

  return line
end

function M.set_separator()
  local ok, hl = pcall(vim.api.nvim_get_hl_by_name, active_tab_highlight, 1)
  local valid_highlight = ok and (hl.background or hl.foreground)

  if not valid_highlight then
    vim.api.nvim_set_hl(0, active_tab_highlight, {link = 'Directory'})
  end

  separator_active = '%#' .. active_tab_highlight .. '#▍'
end

function M.higroups()
  return {
    ['TABLINE-SEPARATOR'] = active_tab_highlight
  }
end

return M

