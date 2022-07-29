local lw = require('little-wonder')
local mariana = require('little-wonder.themes.mariana')
local color = mariana.palette()

color.red.gui = '#D78084'
color.blue.gui = '#7AABDC'
color.metal_blue = {gui = '#272E38', cterm = 236}

local theme = mariana.update({
  syntax = {
    storage = color.blue
  },
  ui = {
    cursorline = color.metal_blue
  }
})

lw.apply('anny', theme)

---
-- Custom rules
---
local none = 'LittleWonderNone'
local link = lw.link
local hs = lw.set_hl
local hi = function(group, colors)
  vim.api.nvim_set_hl(0, group, {
    fg = colors.fg.gui,
    bg = colors.bg.gui,
    ctermfg = colors.fg.cterm,
    ctermbg = colors.bg.cterm,
  })
end

link('TelescopeMatching', 'Boolean')
link('TelescopeSelection', 'CursorLine')
link('NormalFloat', 'Normal')
link('markdownError', none)

hi('TelescopeSelectionCaret', {fg = color.orange, bg = color.metal_blue})

hi('DiffAdd', {fg = color.green, bg = lw.NONE})
hi('DiffChange', {fg = color.yellow, bg = lw.NONE})
hi('DiffDelete', {fg = color.red, bg = lw.NONE})
hi('DiffText',   {fg = color.cyan, bg = lw.NONE})

hs('IndentBlanklineChar', {fg = '#494E5B'})
hs('IndentBlanklineContextChar', {fg = '#6D717C'})

