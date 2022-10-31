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

lw.apply('annie', theme)

---
-- Custom rules
---
local link = lw.link
local hs = lw.set_hl
local hi = lw.highlight

link('TelescopeMatching', 'Boolean')
link('TelescopeSelection', 'CursorLine')
link('NormalFloat', 'Normal')
link('markdownError', lw.no_color)

hi('TelescopeSelectionCaret', color.orange, color.metal_blue)

hi('DiffAdd', color.green)
hi('DiffChange', color.yellow)
hi('DiffDelete', color.red)
hi('DiffText', color.cyan)

hs('IndentBlanklineChar', {fg = '#494E5B'})
hs('IndentBlanklineContextChar', {fg = '#6D717C'})

