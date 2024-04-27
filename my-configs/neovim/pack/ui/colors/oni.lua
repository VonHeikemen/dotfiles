local cs = require('colorscheme')

local color = {
  white   = {gui = '#ABB2BF', cterm = 145},
  black   = {gui = '#282C34', cterm = 235},
  green   = {gui = '#98C379', cterm = 114},
  blue    = {gui = '#61AFEF', cterm = 39 },
  cyan    = {gui = '#56B6C2', cterm = 38 },
  red     = {gui = '#E06C75', cterm = 204},
  magenta = {gui = '#C678DD', cterm = 170},
  yellow  = {gui = '#E5C07B', cterm = 180},

  gray        = {gui = '#5C6370', cterm = 59 },
  light_gray  = {gui = '#2C323C', cterm = 236},
  dark_gray   = {gui = '#4B5263', cterm = 238},
  bright_gray = {gui = '#3E4452', cterm = 237},
  eerie_black = {gui = '#1E2229', cterm = 235},
  darkness    = {gui = '#3B4048', cterm = 238},
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
    constant = color.yellow,
    storage  = color.blue,
    special  = color.white,
    error    = color.red,
    error_bg = nil
  },
  ui = {
    cursorline    = color.light_gray,
    selection     = color.blue,
    colorcolumn   = color.light_gray,
    dark_text     = color.dark_gray,
    line_nr       = color.dark_gray,
    line_bg       = color.light_gray,
    folds         = color.gray,
    menu_item     = color.bright_gray,
    menu_selected = color.blue,
    search        = color.yellow,
    matchparen    = color.blue,
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
    yellow  = color.yellow.gui,
    cyan    = color.cyan.gui,

    bright_black = color.bright_gray.gui,
  },
}

cs.apply('oni', theme)

local link = cs.link
local hi = cs.highlight

hi('Visual', cs.NONE, color.bright_gray)
hi('PMenuSel', color.light_gray, color.blue)
hi('PmenuThumb', color.light_gray, color.white)
hi('PmenuSbar', cs.NONE, color.light_gray)

hi('Cursor', color.black, color.blue)

hi('Search', color.black, color.yellow)

hi('TelescopeMatching', color.cyan)
hi('TelescopeSelectionCaret', color.magenta, color.light_gray)

link('TelescopeSelection', 'CursorLine')
link('markdownError', cs.no_color)

hi('DiffAdd', color.green)
hi('DiffChange', color.yellow)
hi('DiffDelete', color.red)
hi('DiffText', color.cyan)

hi('MiniJump2dSpot', color.eerie_black, color.yellow)
link('MiniJump2dSpotAhead', 'MiniJump2dSpot')

local statusline = require('statusline').higroups()

hi(statusline['NORMAL'], color.black, color.blue)
hi(statusline['COMMAND'], color.black, color.magenta)
hi(statusline['INSERT'], color.black, color.green)
hi(statusline['DEFAULT'], color.black, color.yellow)

local tabline = require('tabline').higroups()

link(tabline['TABLINE-SEPARATOR'], 'Function')

hi('TermBg', color.white, color.eerie_black)

