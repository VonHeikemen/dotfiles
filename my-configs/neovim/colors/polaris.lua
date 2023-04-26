local cs = require('local.colorscheme')

local color = {
  white   = {gui = '#C0CAF5', cterm = 153},
  black   = {gui = '#24283B', cterm = 235},
  green   = {gui = '#9ECE6A', cterm = 149},
  blue    = {gui = '#7AA2F7', cterm = 111},
  cyan    = {gui = '#73DACA', cterm = 80 },
  red     = {gui = '#F7768E', cterm = 210},
  magenta = {gui = '#BB9AF7', cterm = 141},
  yellow  = {gui = '#E0AF68', cterm = 179},

  bright_black  = {gui = '#1F2335', cterm = 234},
  bright_white  = {gui = '#DADFE1', cterm = 253},
  bright_blue   = {gui = '#3D59A1', cterm = 62 },
  blue_two      = {gui = '#3B4261', cterm = 239},
  blue_three    = {gui = '#364A82', cterm = 239},
  gray_two      = {gui = '#222229', cterm = 235},

  gray       = {gui = '#565F89', cterm = 60},
  light_gray = {gui = '#292E42', cterm = 236},
  dark_gray  = {gui = '#6B7678', cterm = 243},
}

local theme = {
  globals = {
    type = 'dark',
    foreground = color.white,
    background = color.black,
  },
  syntax = {
    comment  = color.red,
    string   = color.yellow,
    constant = color.magenta,
    storage  = color.blue,
    special  = color.dark_gray,
    error    = color.red,
    error_bg = nil
  },
  ui = {
    cursorline    = color.light_gray,
    selection     = color.blue_three,
    colorcolumn   = color.bright_black,
    dark_text     = color.dark_gray,
    line_nr       = color.dark_gray,
    line_bg       = color.bright_black,
    folds         = color.dark_gray,
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

cs.apply('polaris', theme)

local link = cs.link
local hi = cs.highlight

hi('PmenuThumb', {}, color.blue_two)
hi('PmenuSbar', {}, color.gray_two)
hi('Search', {}, color.bright_blue)

link('TelescopeMatching', 'Boolean')
link('TelescopeSelection', 'CursorLine')
link('markdownError', cs.no_color)

hi('DiffAdd', color.green)
hi('DiffChange', color.yellow)
hi('DiffDelete', color.red)
hi('DiffText', color.cyan)

local statusline = require('local.statusline').higroups()

hi(statusline['COMMAND'], color.black, color.cyan)
hi(statusline['INSERT'], color.black, color.green)
hi(statusline['STATUS-BLOCK'], color.white, color.blue_two)

local tabline = require('local.tabline').higroups()

link(tabline['TABLINE-SEPARATOR'], 'Function')

