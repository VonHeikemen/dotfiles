set background=light
hi clear

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'daily'

"
" Colors
"

" white    cterm 254 gui #FBFBFB
" black    cterm 238 gui #403F53
" green    cterm 22  gui #4E7240
" blue     cterm 26  gui #4876D6
" cyan     cterm 30  gui #0C969B
" red      cterm 131 gui #BC5454
" magenta  cterm 57  gui #994CC3
" yellow   cterm 167 gui #C96765
"
" gray              cterm 247 gui #989FB1
" light_cyan        cterm 247 gui #93A1A1
" smoke_white       cterm 254 gui #F0F0F0
" gainsboro_white   cterm 254 gui #E0E0E0
" darkness          cterm 252 gui #CECECE
" dim_gray          cterm 251 gui #CBCBCB
" whiteee           cterm 254 gui #EEEEEE
" bright_black      cterm 242 gui #5F6672
" pink              cterm 198 gui #FF2C83
" blue_wonder       cterm 146 gui #A8AECB
" light_silver      cterm 253 gui #D8D8DC


"
" UI
"

hi Normal        ctermfg=238   guifg=#403F53  ctermbg=254     guibg=#FBFBFB
hi Cursor        ctermfg=bg    guifg=bg       ctermbg=fg     guibg=fg
hi CursorLine    ctermfg=NONE  guifg=NONE     ctermbg=250    guibg=#F0F0F0  cterm=NONE       gui=NONE
hi CursorLineNr  ctermfg=NONE  guifg=NONE     ctermbg=bg     guibg=bg
hi ColorColumn   ctermfg=NONE  guifg=NONE     ctermbg=254    guibg=#F0F0F0
hi LineNr        ctermfg=247   guifg=#989FB1  ctermbg=bg     guibg=bg
hi NonText       ctermfg=247   guifg=#989FB1  ctermbg=bg     guibg=bg
hi EndOfBuffer   ctermfg=247   guifg=#989FB1  ctermbg=bg     guibg=bg
hi VertSplit     ctermfg=252   guifg=#CECECE  ctermbg=bg     guibg=bg       cterm=NONE       gui=NONE
hi Folded        ctermfg=242   guifg=#5F6672
hi FoldColumn    ctermfg=242   guifg=#5F6672
hi SignColumn    ctermfg=NONE  guifg=NONE     ctermbg=bg     guibg=bg
hi Pmenu         ctermbg=254   guibg=#EEEEEE
hi PmenuSel      ctermbg=251   guibg=#CBCBCB
hi PmenuThumb    ctermbg=146   guibg=#A8AECB
hi PmenuSbar     ctermbg=253   guibg=#D8D8DC
hi TabLine       ctermfg=fg    guibg=fg       ctermbg=252   guibg=#CECECE  cterm=NONE     gui=NONE
hi TabLineFill   ctermbg=252   guibg=#CECECE  cterm=NONE     gui=NONE
hi TabLineSel    ctermfg=NONE  guifg=NONE     ctermbg=254    guibg=#FBFBFB
hi StatusLine    ctermbg=252   guibg=#CECECE  cterm=NONE     gui=NONE
hi StatusLineNC  ctermfg=247   guifg=#989FB1  ctermbg=252    guibg=#CECECE  cterm=NONE       gui=NONE
hi Visual        ctermfg=NONE  guifg=NONE     ctermbg=250    guibg=#E0E0E0  cterm=NONE       gui=NONE
hi Search        ctermfg=bg    guifg=bg       ctermbg=247    guibg=#93A1A1 
hi MatchParen    ctermfg=57    guifg=#994CC3  ctermbg=NONE   guibg=NONE     cterm=underline  gui=underline
hi Directory     ctermfg=26    guifg=#4876D6

hi DiagnosticError  ctermfg=131  guifg=#BC5454  ctermbg=NONE  guibg=NONE
hi DiagnosticWarn   ctermfg=167  guifg=#C96765  ctermbg=NONE  guibg=NONE
hi DiagnosticInfo   ctermfg=30   guifg=#0C969B  ctermbg=NONE  guibg=NONE
hi DiagnosticHint   ctermfg=fg   guifg=fg       ctermbg=NONE  guibg=NONE

hi DiagnosticUnderlineError  ctermfg=131  guifg=#BC5454  ctermbg=NONE  guibg=NONE cterm=underline gui=underline
hi DiagnosticUnderlineWarn   ctermfg=167  guifg=#C96765  ctermbg=NONE  guibg=NONE cterm=underline gui=underline
hi DiagnosticUnderlineInfo   ctermfg=30   guifg=#0C969B  ctermbg=NONE  guibg=NONE cterm=underline gui=underline
hi DiagnosticUnderlineHint   ctermfg=fg   guifg=fg       ctermbg=NONE  guibg=NONE cterm=underline gui=underline

hi link WildMenu    Search
hi link CurSearch   Search
hi link IncSearch   Search
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

hi Comment      ctermfg=22  guifg=#4E7240
hi String       ctermfg=167 guifg=#C96765
hi Character    ctermfg=131 guifg=#BC5454
hi Number       ctermfg=131 guifg=#BC5454
hi Boolean      ctermfg=131 guifg=#BC5454
hi Float        ctermfg=131 guifg=#BC5454
hi Function     ctermfg=27  guifg=#4876D6
hi Special      ctermfg=247 guifg=#93A1A1
hi SpecialChar  ctermfg=247 guifg=#93A1A1
hi SpecialKey   ctermfg=247 guifg=#93A1A1
hi Error        ctermfg=198 guifg=#FF2C83


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
  let g:terminal_color_foreground = '#403F53'
  let g:terminal_color_background = '#FBFBFB'

  " black
  let g:terminal_color_0          = '#403F53'
  let g:terminal_color_8          = '#403F53'

  " red
  let g:terminal_color_1          = '#F7768E'
  let g:terminal_color_9          = '#F7768E'

  " green
  let g:terminal_color_2          = '#4E7240'
  let g:terminal_color_10         = '#4E7240'

  " yellow
  let g:terminal_color_3          = '#C96765'
  let g:terminal_color_11         = '#C96765'

  " blue
  let g:terminal_color_4          = '#4876D6'
  let g:terminal_color_12         = '#4876D6'

  " magenta
  let g:terminal_color_5          = '#994CC3'
  let g:terminal_color_13         = '#994CC3'

  " cyan
  let g:terminal_color_6          = '#0C969B'
  let g:terminal_color_14         = '#0C969B'

  " white
  let g:terminal_color_7          = '#FBFBFB'
  let g:terminal_color_15         = '#EEEEEE'

  let g:terminal_ansi_colors      = [
  \ '#403F53', '#F7768E', '#4E7240', '#C96765',
  \ '#4876D6', '#994CC3', '#0C969B', '#FBFBFB',
  \
  \ '#403F53', '#F7768E', '#4E7240', '#C96765',
  \ '#4876D6', '#994CC3', '#0C969B', '#EEEEEE'
  \ ]
endif

