" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

if !has('nvim')
  set nocompatible
  set backspace=indent,eol,start
  set belloff=all
  set autoread
  set autowrite
  set autoindent
  set incsearch
  set laststatus=2
  set wildmenu

  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
endif

set hidden
set noswapfile
set nobackup
set nohlsearch
set nowrap
set mouse=a
set termguicolors
set scrolloff=2
set inccommand=nosplit
set relativenumber
set cursorline

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

let g:netrw_winsize = 30
let g:netrw_banner = 0

" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

let g:mapleader = ' '

" Enter command mode
nnoremap <CR> :

" Escape to normal mode
noremap <M-L> <Esc>
inoremap <M-L> <Esc>
tnoremap <M-L> <C-\><C-n>

" Shortcuts
noremap <Leader>h ^
noremap <Leader>l g_
noremap <C-u> <C-u>M
noremap <C-d> <C-d>M
nmap <Leader>e %
vmap <Leader>e %
nnoremap <Leader>a ggVG

if has('clipboard')
  noremap cp "+y
  noremap cv "+p
endif

" Moving lines and preserving indentation
nnoremap <C-j> :move .+1<CR>==
nnoremap <C-k> :move .-2<CR>==
vnoremap <C-j> :move '>+1<CR>gv=gv
vnoremap <C-k> :move '<-2<CR>gv=gv

" Commands
nnoremap <Leader>w :write<CR>
nnoremap <Leader>qq :quitall<CR>
nnoremap <Leader>Q :quitall!<CR>
nnoremap <Leader>bq :bdelete<CR>
nnoremap <Leader>bl :buffer #<CR>
nnoremap <Leader>bb :buffers<CR>:buffer<Space>
nnoremap <Leader><space> :echo ''<CR>
nnoremap <Leader>dd :Lexplore %:p:h<CR>
nnoremap <Leader>da :Lexplore<CR>

function! NetrwMapping()
  " close window
  nmap <buffer> <leader>dd :Lexplore<CR>
  nmap <buffer> <leader>da :Lexplore<CR>

  " Better navigation
  nmap <buffer> H u
  nmap <buffer> h -^
  nmap <buffer> l <CR>
  nmap <buffer> L <CR>:Lexplore<CR>

  " Toggle dotfiles
  nmap <buffer> . gh
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

" ============================================================================ "
" ===                              COLORSCHEME                             === "
" ============================================================================ "

syntax enable

function! MyHighlights() abort
  hi! Normal ctermfg=153 ctermbg=235 guifg=#C0CAF5 guibg=#24283B
  hi! LineNr ctermfg=243 guifg=#6B7678
  hi! CursorLineNr ctermfg=153 ctermbg=235 guifg=#C0CAF5 guibg=#24283B
  hi! CursorLine ctermfg=NONE ctermbg=236 guifg=NONE guibg=#292E42
  hi! MatchParen ctermfg=179 ctermbg=NONE guifg=#73DACA guibg=NONE gui=underline
  hi! Visual ctermfg=NONE ctermbg=239 guifg=NONE guibg=#364A82 cterm=NONE gui=NONE
  hi! Pmenu ctermbg=234 guibg=#1F2335
  hi! PmenuSel ctermbg=236 guibg=#292E42
  hi! PmenuThumb ctermbg=239 guibg=#3B4261
  hi! PmenuSbar ctermbg=235 guibg=#222229
  hi! Search ctermfg=NONE ctermbg=62 guifg=NONE guibg=#3D59A1
  hi! StatusLine ctermbg=234 guibg=#1F2335 cterm=NONE gui=NONE
  hi! StatusLineNC ctermfg=243 ctermbg=234 guifg=#6B7678 guibg=#1F2335 cterm=NONE gui=NONE
  hi! TabLine ctermbg=234 guibg=#1F2335 cterm=NONE gui=NONE
  hi! TabLineFill ctermbg=234 guibg=#1F2335 cterm=NONE gui=NONE
  hi! TabLineSel ctermfg=NONE ctermbg=235 guifg=NONE guibg=#24283B
  hi! VertSplit ctermfg=234 ctermbg=235 guifg=#1F2335 guibg=#24283B cterm=NONE gui=NONE

  hi! Comment ctermfg=210 guifg=#F7768E
  hi! String ctermfg=149 guifg=#9ECE6A
  hi! Function ctermfg=111 guifg=#7AA2F7
  hi! Boolean ctermfg=141 guifg=#BB9AF7
  hi! Number ctermfg=141 guifg=#BB9AF7
  hi! Special ctermfg=243 guifg=#6B7678
  hi! link IncSearch Search
  hi! link WildMenu Search
  hi! link NonText LineNr
  hi! link Constant Boolean
  hi! link PreProc Normal
  hi! link Identifier Normal
  hi! link Keyword Normal
  hi! link Include Normal
  hi! link Statement Normal
  hi! link Type Normal
  hi! link Title Normal
  hi! link Tag Function

  hi! link Directory Function

  hi! link jsonBraces Normal

  hi! link yamlFlowIndicator     Normal
  hi! link yamlKeyValueDelimiter Normal
  hi! link yamlBlockMappingKey   Function

  hi! link cssClassName Normal
  hi! link cssBraces    Normal

  hi! link javaScript         Normal
  hi! link javaScriptNumber   Number
  hi! link javaScriptNull     Number
  hi! link javaScriptBraces   Normal
  hi! link javaScriptFunction Normal

  hi! link typescriptImport    Normal
  hi! link typescriptExport    Normal
  hi! link typescriptBraces    Normal
  hi! link typescriptDecorator Normal
  hi! link typescriptMember    Normal

  hi! link phpParent  Normal
  hi! link phpDocTags Comment

  hi! link htmlTagName        Function
  hi! link htmlSpecialTagName Function
  hi! link htmlScriptTag      Special
  hi! link htmlEndTag         Special
  hi! link htmlTagN           Special
  hi! link htmlTag            Special

  hi! link vimParenSep Normal
endfunction

augroup MyColors
  autocmd!
  autocmd ColorScheme default call MyHighlights()
augroup END

call MyHighlights()
