local concat  = '%s%s'
local active_tab_highlight = 'Function'
local separator_active = ''

local function tabpage(opts)
  local highlight = '%#TabLine#'
  local separator = '%#TabLine#▏'
  local label = '[No Name]'

  if opts.selected then
    highlight = '%#TabLineSel#'
    separator = separator_active
  end

  if opts.bufname ~= '' then
    local name = vim.fn.pathshorten(vim.fn.fnamemodify(opts.bufname, ':p:~:t'))
    if name ~= '' then
      label = name
    end
  end

  local str = '%s%s%s '
  return str:format(separator, highlight, label)
end

local function tabline()
  local line = ''
  local tabs = vim.fn.tabpagenr('$')

  for index = 1, tabs, 1 do
    local buflist = vim.fn.tabpagebuflist(index)
    local winnr = vim.fn.tabpagewinnr(index)
    local bufname = vim.fn.bufname(buflist[winnr])

    line = concat:format(
      line,
      tabpage({
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

local function set_separator()
  local hl = vim.api.nvim_get_hl(0, {name = active_tab_highlight})

  if next(hl) == nil then
    vim.api.nvim_set_hl(0, active_tab_highlight, {link = 'Directory'})
  end

  separator_active = '%#' .. active_tab_highlight .. '#▍'
end

---
-- Setup
---

set_separator()
_G._user_tabline = tabline
vim.o.tabline = '%!v:lua._user_tabline()'

