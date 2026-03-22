local cs = require('colorscheme')

local color = {
  white   = {gui = '#D3C6AA', cterm = 223},
  black   = {gui = '#272E33', cterm = 235},
  green   = {gui = '#A7C080', cterm = 142},
  blue    = {gui = '#7FBBB3', cterm = 109},
  cyan    = {gui = '#83C092', cterm = 108},
  red     = {gui = '#E67E80', cterm = 167},
  magenta = {gui = '#D699B6', cterm = 175},
  yellow  = {gui = '#DBBC7F', cterm = 214},

  gray         = {gui = '#859289', cterm = 245},
  dark_gray    = {gui = '#4F5B58', cterm = 240},
  light_gray   = {gui = '#2E383C', cterm = 236},
  bright_gray  = {gui = '#495156', cterm = 239},
  bright_black = {gui = '#374145', cterm = 237},
  soft_pink    = {gui = '#4C3743', cterm = 52 },
  orange       = {gui = '#E69875', cterm = 208},
  dark_blue    = {gui = '#809EDB', cterm = 110},
  pale_blue    = {gui = '#8D99C8', cterm = 239},
  eerie_black  = {gui = '#22282C', cterm = 234},
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
    constant = color.magenta,
    storage  = color.blue,
    special  = color.orange,
    error    = color.red,
    error_bg = nil
  },
  ui = {
    cursorline    = color.light_gray,
    selection     = color.soft_pink,
    colorcolumn   = color.light_gray,
    dark_text     = color.dark_gray,
    line_nr       = color.dark_gray,
    line_bg       = color.bright_black,
    folds         = color.gray,
    menu_item     = color.bright_black,
    menu_selected = color.green,
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
  },
}

cs.apply('evergreen', theme)

local link = cs.link
local hi = cs.highlight

hi('Cursor', color.black, color.pale_blue)
link('NormalFloat', 'Normal')

hi('PMenuSel', color.black, color.green)

hi('Search', color.black, color.green)
hi('IncSearch', color.black, color.red)

hi('SnacksPickerMatch', color.magenta)
hi('TelescopeMatching', color.magenta)
hi('TelescopeSelectionCaret', color.magenta, color.light_gray)

link('TelescopeSelection', 'CursorLine')
link('markdownError', cs.no_color)

hi('DiffAdd', color.green)
hi('DiffChange', color.yellow)
hi('DiffDelete', color.red)
hi('DiffText', color.cyan)

hi('MiniJump2dSpot', color.black, color.yellow)
link('MiniJump2dSpotAhead', 'MiniJump2dSpot')
link('LeapMatch', 'MiniJump2dSpot')
link('LeapLabel', 'MiniJump2dSpot')

hi('TermBg', color.white, color.eerie_black)

hi('MiniStatuslineModeNormal', color.black, color.blue)
hi('MiniStatuslineModeOther', color.black, color.orange)

hi('CmpItemKind', color.yellow)

hi('MatchParen', {}, color.bright_gray)
hi('htmlTagN', color.orange)
hi('@tag.delimiter.html', color.cyan)
link('htmlTagName', 'htmlTagN')
link('@tag.html', 'htmlTagN')

