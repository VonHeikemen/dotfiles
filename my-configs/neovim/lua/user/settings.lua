local env = require('user.env')

if not env.tempdir then
  -- Don't use temp files
  vim.o.swapfile = false
  vim.o.backup = false
end

-- Ignore the case when the search pattern is all lowercase
vim.o.smartcase = true
vim.o.ignorecase = true

-- Disable line wrapping
vim.o.wrap = false

-- Keep lines below cursor when scrolling
vim.o.scrolloff = 2
vim.o.sidescrolloff = 5

-- Don't highlight search results
vim.o.hlsearch = false

-- Enable cursorline
vim.o.cursorline = true

-- Always display signcolumn (for diagnostic related stuff)
vim.o.signcolumn = 'yes'

-- When opening a window put it right or below the current one
vim.o.splitright = true
vim.o.splitbelow = true

-- Tab set to two spaces
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.expandtab = true

-- Enable mouse support
vim.o.mouse = 'a'

-- Insert mode completion setting
vim.o.completeopt = 'menu,menuone'

-- Use the pretty colors
vim.o.termguicolors = true

