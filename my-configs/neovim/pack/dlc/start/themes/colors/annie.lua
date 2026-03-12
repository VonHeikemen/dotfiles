local cs = require('colorscheme')

local color = {
  white   = {gui = '#D8DEE9', cterm = 253},
  black   = {gui = '#343D46', cterm = 237},
  green   = {gui = '#99C794', cterm = 114},
  blue    = {gui = '#7AABDC', cterm = 111},
  cyan    = {gui = '#5FB4B4', cterm = 73 },
  red     = {gui = '#D78084', cterm = 203},
  magenta = {gui = '#C695C6', cterm = 176},
  yellow  = {gui = '#FFCB6B', cterm = 221},

  orange         = {gui = '#F9AE58', cterm = 215},
  gray           = {gui = '#A6ACB9', cterm = 145},
  bright_gray    = {gui = '#46505B', cterm = 239},
  space_gray     = {gui = '#3D4752', cterm = 239},
  dark_gray      = {gui = '#2F353C', cterm = 235},
  light_gray     = {gui = '#939393', cterm = 238},
  dark_blue      = {gui = '#4E5A65', cterm = 240},
  charcoil       = {gui = '#3D4751', cterm = 239},
  dim_gray       = {gui = '#62686F', cterm = 242},
  silver         = {gui = '#B0AEB0', cterm = 145},
  bright_yellow  = {gui = '#F2CA27', cterm = 220},
  metal_gray     = {gui = '#2E363E', cterm = 236},
  darkness       = {gui = '#272E35', cterm = 237},
}

local theme = {
  globals = {
    type = 'dark',
    foreground = color.white,
    background = color.black,
  },
  syntax = {
    comment  = color.gray,
    string   = color.green,
    constant = color.orange,
    storage  = color.blue,
    special  = color.cyan,
    error    = color.red,
    error_bg = nil
  },
  ui = {
    cursorline    = color.metal_gray,
    selection     = color.bright_gray,
    colorcolumn   = color.dark_blue,
    dark_text     = color.silver,
    line_nr       = color.light_gray,
    line_bg       = color.charcoil,
    folds         = color.dim_gray,
    menu_item     = color.dark_gray,
    menu_selected = color.dim_gray,
    search        = color.bright_yellow,
    matchparen    = color.yellow,
    info          = color.cyan,
    warning       = color.yellow,
    error         = color.red
  },
  terminal = {
    white   = color.white.gui,
    black   = color.black.gui,
    red     = color.red.gui,
    green   = color.green.gui,
    blue    = color.blue.gui,
    magenta = color.magenta.gui,
    yellow  = color.orange.gui,
    cyan    = color.cyan.gui,
  },
}

cs.apply('annie', theme)

---
-- Custom rules
---
local link = cs.link
local hs = cs.set_hl
local hi = cs.highlight

link('NormalFloat', 'Normal')
link('markdownError', cs.no_color)

hi('DiffAdd', color.green)
hi('DiffChange', color.yellow)
hi('DiffDelete', color.red)
hi('DiffText', color.cyan)

link('TelescopeMatching', 'Boolean')
link('TelescopeSelection', 'CursorLine')
hi('TelescopeSelectionCaret', color.orange, color.metal_gray)

hs('IndentBlanklineChar', {fg = '#494E5B'})
hs('IndentBlanklineContextChar', {fg = '#6D717C'})

hi('MiniJump2dSpot', color.black, color.yellow)
link('MiniJump2dSpotAhead', 'MiniJump2dSpot')

hi('TermBg', color.white, color.darkness)

