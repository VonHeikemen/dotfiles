local env = require('conf.env')
local cwd = vim.fn.getcwd()
local f = string.format

local set = vim.opt

if env.tempdir then
   -- Temp files directory
  set.backupdir = env.tempdir
  set.directory = env.tempdir
else
  -- Don't use temp files
  set.swapfile = false
  set.backup = false
end

-- Ignore the case when the search pattern is all lowercase
set.smartcase = true
set.ignorecase = true

-- Autosave when navigating between buffers
set.autowrite = true

-- Disable line wrapping
set.wrap = false

-- Keep lines below cursor when scrolling
set.scrolloff = 2
set.sidescrolloff = 5

-- Don't highlight search results
set.hlsearch = false

-- Enable incremental search
set.incsearch = true

-- Enable cursorline
set.cursorline = true

-- Enable syntax highlight
vim.cmd('syntax enable')

-- Add a bit extra margin to the left
set.foldcolumn = '1'

-- When opening a window put it right or below the current one
set.splitright = true
set.splitbelow = true

if vim.fn.has('termguicolors') == 1 then
  set.termguicolors = true
end

-- Preserve state (undo, marks, etc) in non visible buffers
set.hidden = true

-- Tab set to two spaces
set.tabstop = 2
set.shiftwidth = 2
set.softtabstop = 2
set.expandtab = true

-- Enable mouse support
set.mouse = 'a'

-- Look for a tag file in the git folder
-- I shouldn't have to use `cwd` but here we are
set.tags:prepend(f('%s/.git/tags', cwd))

-- Insert mode completion setting
set.completeopt = {'menuone', 'noselect'}

-- Theme
pcall(vim.cmd, 'colorscheme rubber-enhanced')

-- Set grep default grep command with ripgrep
set.grepprg = 'rg --vimgrep --follow'
set.errorformat:append '%f:%l:%c%p%m'

-- Status line
set.statusline = '%=%r%m %l:%c %p%% %y '

if vim.env.TMUX then
  local dirname = vim.fn.fnamemodify(cwd, ':t')
  set.statusline:append(f('[%s] ', dirname))
end

