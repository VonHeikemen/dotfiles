local lw = require('little-wonder')
local kyoto = require('little-wonder.themes.kyoto')
local color = kyoto.palette()

local theme = kyoto.update({
  syntax = {
    comment = color.red,
    constant = color.magenta,
    string = color.yellow,
  },
  ui = {
    matchparen = color.cyan,
  },
})

lw.apply('polaris', theme)

local link = lw.link
local hi = lw.highlight

link('TelescopeMatching', 'Boolean')
link('TelescopeSelection', 'CursorLine')
link('markdownError', lw.no_color)

hi('DiffAdd', color.green)
hi('DiffChange', color.yellow)
hi('DiffDelete', color.red)
hi('DiffText', color.cyan)

local statusline = require('plugins.statusline').higroups()

hi(statusline['COMMAND'], color.black, color.cyan)
hi(statusline['INSERT'], color.black, color.green)
hi(statusline['STATUS-BLOCK'], color.white, color.blue_two)

