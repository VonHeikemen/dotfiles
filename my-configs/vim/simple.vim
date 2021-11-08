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
noremap <C-L> <Esc>
inoremap <C-L> <Esc>
tnoremap <C-L> <C-\><C-n>

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

try
  colorscheme rubber-enhanced
  set cursorline
  set foldcolumn=1
catch
  set relativenumber
  function! MyHighlights() abort
    hi! Normal guifg=#D2D7D3 guibg=#2F343F
    hi! LineNr guifg=#939393
    hi! CursorLineNr guifg=#D2D7D3

    hi! Comment guifg=#FC8680
    hi! String guifg=#87D37C
    hi! Function guifg=#89C4F4
    hi! Boolean guifg=#DDA0DD
    hi! Number guifg=#DDA0DD
    hi! link NonText LineNr
    hi! link Constant Boolean
    hi! link PreProc Normal
    hi! link Identifier Normal
    hi! link Keyword Normal
    hi! link Include Normal
    hi! link Statement Normal
    hi! link Type Normal

    hi! link jsonBraces Normal

    hi! link yamlFlowIndicator Normal
    hi! link yamlKeyValueDelimiter Normal

    hi! link javaScriptNumber   Number
    hi! link javaScriptNull     Number
    hi! link javaScriptBraces   Normal
    hi! link javaScriptFunction Normal

    hi! link phpParent Normal
  endfunction
  augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
  augroup END

  colorscheme default
endtry

