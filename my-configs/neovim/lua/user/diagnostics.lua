local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
local level = vim.diagnostic.severity

vim.diagnostic.config({
  virtual_text = false,
  float = {
    border = 'rounded',
  },
  signs = {
    text = {
      [level.ERROR] = '✘',
      [level.WARN] = '▲',
      [level.HINT] = '⚑',
      [level.INFO] = '»',
    }
  }
})

local group = augroup('diagnostic_cmds', {clear = true})

autocmd('ModeChanged', {
  group = group,
  pattern = {'n:i', 'v:s'},
  desc = 'Disable diagnostics while typing',
  callback = function(e) vim.diagnostic.enable(false, {bufnr = e.buf}) end
})

autocmd('ModeChanged', {
  group = group,
  pattern = 'i:n',
  desc = 'Enable diagnostics when leaving insert mode',
  callback = function(e) vim.diagnostic.enable(true, {bufnr = e.buf}) end
})

