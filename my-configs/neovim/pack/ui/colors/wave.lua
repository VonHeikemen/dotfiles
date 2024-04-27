local cs = require('colorscheme')

local color = {
  white   = {gui = '#DCD7BA', cterm = 187},
  black   = {gui = '#1F1F28', cterm = 235},
  green   = {gui = '#98BB6C', cterm = 107},
  blue    = {gui = '#7E9CD8', cterm = 110},
  cyan    = {gui = '#7FB4CA', cterm = 110},
  red     = {gui = '#FF5D62', cterm = 203},
  magenta = {gui = '#957FB8', cterm = 103},
  yellow  = {gui = '#E6C384', cterm = 186},

  gray         = {gui = '#727169', cterm = 243},
  pale_pink    = {gui = '#D27E99', cterm = 174},
  high_blue    = {gui = '#223249', cterm = 236},
  dark_gray    = {gui = '#54546D', cterm = 240},
  bright_black = {gui = '#363646', cterm = 237},
  orange       = {gui = '#FF9E3B', cterm = 215},
  eerie_black  = {gui = '#171A1A', cterm = 234},
  bright_blue  = {gui = '#2D4F67', cterm = 239},
  light_gray   = {gui = '#252530', cterm = 235},
  bright_gray  = {gui = '#2A2A37', cterm = 236},
  darkness     = {gui = '#2C2C3A', cterm = 236},

  light_green = {gui = '#3D4C3E', cterm = 238},
  dim_gray    = {gui = '#727169', cterm = 243},
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
    constant = color.pale_pink,
    storage  = color.blue,
    special  = color.cyan,
    error    = color.red,
    error_bg = nil
  },
  ui = {
    cursorline    = color.light_gray,
    selection     = color.high_blue,
    colorcolumn   = color.darkness,
    dark_text     = color.dark_gray,
    line_nr       = color.dark_gray,
    line_bg       = color.bright_gray,
    folds         = color.gray,
    menu_item     = color.bright_black,
    menu_selected = color.darkness,
    search        = color.yellow,
    matchparen    = color.orange,
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

    bright_black = color.dim_gray.gui,
  },
}

cs.apply('wave', theme)

local link = cs.link
local hi = cs.highlight

hi('Search', color.yellow, color.bright_blue)
hi('IncSearch', color.yellow, color.bright_blue)

hi('TelescopeMatching', color.orange)
hi('TelescopeSelectionCaret', color.cyan, color.light_gray)

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
hi(statusline['DEFAULT'], color.black, color.orange)

local tabline = require('tabline').higroups()

link(tabline['TABLINE-SEPARATOR'], 'Function')

hi('TermBg', color.white, color.eerie_black)

