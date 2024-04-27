set background=dark
hi clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'nightly'

"
" Colors (taken from tokyonight.nvim by folke)
"

" white    cterm 153 gui #C0CAF5
" black    cterm 235 gui #24283B
" green    cterm 149 gui #9ECE6A
" blue     cterm 111 gui #7AA2F7
" cyan     cterm 80  gui #73DACA
" red      cterm 210 gui #F7768E
" magenta  cterm 141 gui #BB9AF7
" yellow   cterm 179 gui #E0AF68

" bright_black  cterm 234 gui #1F2335
" bright_white  cterm 253 gui #DADFE1
" bright_blue   cterm 62  gui #3D59A1
" blue_two      cterm 239 gui #3B4261
" blue_three    cterm 239 gui #364A82
" gray_two      cterm 235 gui #222229

" gray        cterm 60  gui #565F89
" light_gray  cterm 236 gui #292E42
" dark_gray   cterm 243 gui #6B7678


"
" UI
"

hi Normal        ctermfg=153   guifg=#C0CAF5  ctermbg=235    guibg=#24283B
hi Cursor        ctermfg=bg    guifg=bg       ctermbg=fg     guibg=fg
hi CursorLine    ctermfg=NONE  guifg=NONE     ctermbg=236    guibg=#292E42  cterm=NONE     gui=NONE
hi CursorLineNr  ctermfg=NONE  guifg=NONE     ctermbg=bg     guibg=bg
hi ColorColumn   ctermfg=NONE  guifg=NONE     ctermbg=234    guibg=#1F2335
hi LineNr        ctermfg=243   guifg=#6B7678  ctermbg=bg     guibg=bg
hi NonText       ctermfg=243   guifg=#6B7678  ctermbg=bg     guibg=bg
hi EndOfBuffer   ctermfg=243   guifg=#6B7678  ctermbg=bg     guibg=bg
hi VertSplit     ctermfg=234   guifg=#1F2335  ctermbg=235    guibg=#24283B  cterm=NONE     gui=NONE
hi Folded        ctermfg=243   guifg=#6B7678
hi FoldColumn    ctermfg=243   guifg=#6B7678
hi SignColumn    ctermfg=NONE  guifg=NONE     ctermbg=bg     guibg=bg
hi Pmenu         ctermbg=234   guibg=#1F2335
hi PmenuSel      ctermbg=236   guibg=#292E42
hi PmenuThumb    ctermbg=239   guibg=#3B4261
hi PmenuSbar     ctermbg=235   guibg=#222229
hi TabLine       ctermbg=234   guibg=#1F2335  cterm=NONE     gui=NONE
hi TabLineFill   ctermbg=234   guibg=#1F2335  cterm=NONE     gui=NONE
hi TabLineSel    ctermfg=NONE  guifg=NONE     ctermbg=235    guibg=#24283B
hi StatusLine    ctermbg=234   guibg=#1F2335  cterm=NONE     gui=NONE
hi StatusLineNC  ctermfg=243   guifg=#6B7678  ctermbg=234    guibg=#1F2335  cterm=NONE     gui=NONE
hi Visual        ctermfg=NONE  guifg=NONE     ctermbg=239    guibg=#364A82  cterm=NONE     gui=NONE
hi Search        ctermfg=NONE  guifg=NONE     ctermbg=62     guibg=#3D59A1
hi IncSearch     ctermfg=NONE  guifg=NONE     ctermbg=179    guibg=#E0AF68
hi MatchParen    ctermfg=179   guifg=#73DACA  ctermbg=NONE   guibg=NONE     gui=underline
hi Directory     ctermfg=111   guifg=#7AA2F7

hi DiagnosticError  ctermfg=210  guifg=#F7768E  ctermbg=NONE  guibg=NONE
hi DiagnosticWarn   ctermfg=179  guifg=#E0AF68  ctermbg=NONE  guibg=NONE
hi DiagnosticInfo   ctermfg=80   guifg=#73DACA  ctermbg=NONE  guibg=NONE
hi DiagnosticHint   ctermfg=fg   guifg=fg       ctermbg=NONE  guibg=NONE

hi DiagnosticUnderlineError  ctermfg=210  guifg=#F7768E  ctermbg=NONE  guibg=NONE cterm=underline gui=underline
hi DiagnosticUnderlineWarn   ctermfg=179  guifg=#E0AF68  ctermbg=NONE  guibg=NONE cterm=underline gui=underline
hi DiagnosticUnderlineInfo   ctermfg=80   guifg=#73DACA  ctermbg=NONE  guibg=NONE cterm=underline gui=underline
hi DiagnosticUnderlineHint   ctermfg=fg   guifg=fg       ctermbg=NONE  guibg=NONE cterm=underline gui=underline

hi link WildMenu    Search
hi link CurSearch   IncSearch
hi link Question    String
hi link ErrorMsg    DiagnosticError
hi link WarningMsg  DiagnosticWarn

hi link DiffAdd    DiagnosticWarn
hi link DiffChange DiagnosticInfo
hi link DiffDelete DiagnosticError
hi link DiffText   Visual

"
" Basic Syntax
"

hi Comment      ctermfg=210 guifg=#F7768E
hi String       ctermfg=149 guifg=#9ECE6A
hi Character    ctermfg=141 guifg=#BB9AF7
hi Number       ctermfg=141 guifg=#BB9AF7
hi Boolean      ctermfg=141 guifg=#BB9AF7
hi Float        ctermfg=141 guifg=#BB9AF7
hi Function     ctermfg=111 guifg=#7AA2F7
hi Special      ctermfg=243 guifg=#6B7678
hi SpecialChar  ctermfg=243 guifg=#6B7678
hi SpecialKey   ctermfg=243 guifg=#6B7678
hi Error        ctermfg=210  guifg=#F7768E


hi Constant       ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Statement      ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Conditional    ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Exception      ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Identifier     ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Type           ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Repeat         ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Label          ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Operator       ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Keyword        ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Delimiter      ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Tag            ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi SpecialComment ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Debug          ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi PreProc        ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Include        ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Define         ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Macro          ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi PreCondit      ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi StorageClass   ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Structure      ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Typedef        ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Title          ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE
hi Todo           ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE


"
" Language Support
"
hi UserNone ctermfg=NONE guifg=NONE ctermbg=NONE guibg=NONE

" JSON
hi link jsonBraces  Normal

" YAML
hi link yamlFlowIndicator      UserNone
hi link yamlKeyValueDelimiter  UserNone
hi link yamlBlockMappingKey    Function

" CSS
hi link cssClassName  UserNone
hi link cssBraces     UserNone

" Javascript
hi link javaScript          UserNone
hi link javaScriptNumber    Number
hi link javaScriptNull      Number
hi link javaScriptBraces    UserNone
hi link javaScriptFunction  UserNone

" Typescript
hi link typescriptImport     UserNone
hi link typescriptExport     UserNone
hi link typescriptBraces     UserNone
hi link typescriptDecorator  UserNone
hi link typescriptMember     UserNone

" PHP
hi link phpParent   UserNone
hi link phpDocTags  Comment

" HTML
hi link htmlTagName         Function
hi link htmlSpecialTagName  Function
hi link htmlScriptTag       Special
hi link htmlEndTag          Special
hi link htmlTagN            Special
hi link htmlTag             Special
hi link htmlArg             UserNone
hi link htmlTitle           UserNone

" viml
hi link vimUserFunc     Function
hi link vimParenSep     UserNone
hi link vimCommand      UserNone
hi link vimGroup        UserNone
hi link vimHiGroup      UserNone
hi link vimHiCtermFgBg  UserNone
hi link vimHiGuiFgBg    UserNone

" lua
hi link luaStatement  UserNone

if has('nvim-0.8')
  " Treesitter
  hi link @constructor          UserNone
  hi link @method.vue           UserNone
  hi link @punctuation.bracket  UserNone
  hi link @tag.attribute        UserNone
  hi link @text.title           UserNone
  hi link @type                 UserNone
  hi link @constant             UserNone

  hi link @function.call     Function
  hi link @function.builtin  Function
  hi link @constant.builtin  Number
  hi link @type.css          Function
  hi link @constructor.php   Function
  hi link @tag.delimiter     Special
  hi link @tag               Function
  hi link @text.uri.html     String
endif

"
" Terminal
"

if (has('termguicolors') && &termguicolors) || has('gui_running')
  let g:terminal_color_foreground = '#C0CAF5'
  let g:terminal_color_background = '#24283B'

  " black
  let g:terminal_color_0          = '#24283B'
  let g:terminal_color_8          = '#24283B'

  " red
  let g:terminal_color_1          = '#F7768E'
  let g:terminal_color_9          = '#F7768E'

  " green
  let g:terminal_color_2          = '#9ECE6A'
  let g:terminal_color_10         = '#9ECE6A'

  " yellow
  let g:terminal_color_3          = '#E0AF68'
  let g:terminal_color_11         = '#E0AF68'

  " blue
  let g:terminal_color_4          = '#7AA2F7'
  let g:terminal_color_12         = '#7AA2F7'

  " magenta
  let g:terminal_color_5          = '#BB9AF7'
  let g:terminal_color_13         = '#BB9AF7'

  " cyan
  let g:terminal_color_6          = '#73DACA'
  let g:terminal_color_14         = '#73DACA'

  " white
  let g:terminal_color_7          = '#C0CAF5'
  let g:terminal_color_15         = '#C0CAF5'

  let g:terminal_ansi_colors      = [
  \ '#24283B', '#F7768E', '#9ECE6A', '#E0AF68',
  \ '#7AA2F7', '#BB9AF7', '#73DACA', '#C0CAF5',
  \ 
  \ '#24283B', '#F7768E', '#9ECE6A', '#E0AF68',
  \ '#7AA2F7', '#BB9AF7', '#73DACA', '#C0CAF5'
  \ ]
endif

