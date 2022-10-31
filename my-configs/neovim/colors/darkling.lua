local lw = require('little-wonder')

local color = {
  white   = {gui = '#DCE0DD', cterm = 249},
  black   = {gui = '#2F343F', cterm = 234},
  green   = {gui = '#87D37C', cterm = 108},
  blue    = {gui = '#89C4F4', cterm = 75 },
  cyan    = {gui = '#50C6D8', cterm = 73 },
  red     = {gui = '#FC8680', cterm = 168},
  magenta = {gui = '#DDA0DD', cterm = 139},
  yellow  = {gui = '#F2CA27', cterm = 173},

  bright_black  = {gui = '#5F6672', cterm = 242},
  bright_white  = {gui = '#DADFE1', cterm = 253},

  dark_gray  = {gui = '#939393', cterm = 246},
  gray       = {gui = '#8893A6', cterm = 103},
  light_gray = {gui = '#404750', cterm = 238},
  wild_red   = {gui = '#DF334A', cterm = 167},
  dark_blue  = {gui = '#242830', cterm = 235},
  darkness   = {gui = '#3B4252', cterm = 238},

  -- For statusline
  blue_gray    = {gui = '#6699CC', cterm = 68 },
  jet_white    = {gui = '#353535', cterm = 236},
  eton_green   = {gui = '#99C794', cterm = 114},
  crystal_cyan = {gui = '#5FB4B4', cterm = 73 },
  pitch_black  = {gui = '#101010', cterm = 233},
  kinda_white  = {gui = '#D8DEE9', cterm = 253},
  other_gray   = {gui = '#464D5D', cterm = 239},
}

local theme = {
  globals = {
    type = 'dark',
    foreground = color.white,
    background = color.black,
  },
  syntax = {
    comment  = color.red,
    string   = color.green,
    constant = color.magenta,
    storage  = color.blue,
    special  = color.dark_gray,
    error    = color.wild_red,
    error_bg = nil
  },
  ui = {
    cursorline    = color.dark_blue,
    selection     = color.light_gray,
    colorcolumn   = color.bright_black,
    dark_text     = color.dark_gray,
    line_nr       = color.dark_gray,
    line_bg       = color.darkness,
    folds         = color.dark_gray,
    menu_item     = color.dark_blue,
    menu_selected = color.bright_black,
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

lw.apply('darkling', theme)

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

hi('TelescopeSelectionCaret', color.red, color.dark_blue)

hi('DiffAdd', color.green)
hi('DiffChange', color.yellow)
hi('DiffDelete', color.red)
hi('DiffText', color.cyan)

hs('IndentBlanklineChar', {fg = '#494E5B'})
hs('IndentBlanklineContextChar', {fg = '#6D717C'})

local statusline = require('plugins.statusline').higroups()

hi(statusline['NORMAL'], color.jet_white, color.blue_gray)
hi(statusline['VISUAL'], color.jet_white, color.magenta)
hi(statusline['V-BLOCK'], color.jet_white, color.magenta)
hi(statusline['V-LINE'], color.jet_white, color.magenta)
hi(statusline['INSERT'], color.jet_white, color.eton_green)
hi(statusline['COMMAND'], color.pitch_black, color.crystal_cyan)
hi(statusline['STATUS-BLOCK'], color.kinda_white, color.other_gray)
hi(statusline['DEFAULT'], color.pitch_black, color.red)

