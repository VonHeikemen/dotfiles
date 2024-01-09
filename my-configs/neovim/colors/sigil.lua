local cs = require('local.colorscheme')

local color = {
  white   = {gui = '#D4BE98', cterm = 180},
  black   = {gui = '#1D2021', cterm = 234},
  green   = {gui = '#A9B665', cterm = 143},
  blue    = {gui = '#7DAEA3', cterm = 109},
  cyan    = {gui = '#89B482', cterm = 108},
  red     = {gui = '#EA6962', cterm = 167},
  magenta = {gui = '#D3869B', cterm = 174},
  yellow  = {gui = '#D8A657', cterm = 179},

  sad_blue      = {gui = '#5B8DD7', cterm = 109},
  orange        = {gui = '#BD6F3E', cterm = 131},
  light_green   = {gui = '#3D4C3E', cterm = 238},
  bright_black  = {gui = '#191C1D', cterm = 233},

  gray        = {gui = '#958272', cterm = 8  },
  light_gray  = {gui = '#212425', cterm = 235},
  bright_gray = {gui = '#2A2D2E', cterm = 236},
  dark_gray   = {gui = '#45494A', cterm = 235},
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
    special  = color.magenta,
    error    = color.red,
    error_bg = nil
  },
  ui = {
    cursorline    = color.light_gray,
    selection     = color.bright_gray,
    colorcolumn   = color.bright_black,
    dark_text     = color.dark_gray,
    line_nr       = color.dark_gray,
    line_bg       = color.bright_black,
    folds         = color.gray,
    menu_item     = color.bright_black,
    menu_selected = color.light_gray,
    search        = color.yellow,
    matchparen    = color.cyan,
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
  },
}

cs.apply('sigil', theme)

local link = cs.link
local hi = cs.highlight

hi('Search', color.white, color.light_green)
hi('MatchParen', color.orange, color.bright_gray)
hi('TelescopeMatching', color.magenta)
hi('TelescopeSelectionCaret', color.orange)

link('TelescopeSelection', 'CursorLine')
link('markdownError', cs.no_color)

hi('DiffAdd', color.green)
hi('DiffChange', color.yellow)
hi('DiffDelete', color.red)
hi('DiffText', color.cyan)

hi('htmlTag', color.magenta)
hi('@tag.delimiter', color.magenta)

hi('Underlined', color.sad_blue, nil, {'underline'})

local statusline = require('local.statusline').higroups()

hi(statusline['NORMAL'], color.black, color.blue)
hi(statusline['COMMAND'], color.black, color.magenta)
hi(statusline['INSERT'], color.black, color.green)
hi(statusline['DEFAULT'], color.black, color.orange)

local tabline = require('local.tabline').higroups()

link(tabline['TABLINE-SEPARATOR'], 'Function')

