" ============================================================================
" ===                           EDITOR SETTINGS                            ===
" ============================================================================

if !has('nvim')
  set hidden
  set belloff=all
  set autoread
  set autoindent
  set laststatus=2
  set wildmenu
  set wildoptions=pum,tagfile

  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"

  syntax enable
  tnoremap <F2> <C-\><C-n>
endif

set nowrap
set nohlsearch
set noswapfile
set notermguicolors
set mouse=a
set scrolloff=2
set relativenumber

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

let g:netrw_winsize = 30
let g:netrw_banner = 0

try
  colorscheme habamax
catch
  colorscheme desert
endtry

" ============================================================================
" ===                               KEYMAPS                                ===
" ============================================================================

let g:mapleader = "\<Space>"

" Enter command mode
nnoremap <CR> :

" Escape to normal mode
noremap <M-l> <Esc>
inoremap <M-l> <Esc>
cnoremap <M-l> <Esc>
tnoremap <M-l> <C-\><C-n>

" remaps
noremap <C-u> <C-u>M
noremap <C-d> <C-d>M
nnoremap U <C-r>
nnoremap x "_x
xnoremap x "_x
nnoremap X "_d
xnoremap X "_d
nnoremap c "_c
xnoremap c "_c

" Shortcuts
noremap <Leader>h ^
noremap <Leader>l g_
nmap <Leader>e %
vmap <Leader>e %
nnoremap <Leader>a ggVG

if has('clipboard')
  noremap gy "+y
  noremap gp "+p
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
  nmap <buffer> za gh
endfunction

augroup netrw_mapping
  autocmd!
  autocmd filetype netrw call NetrwMapping()
augroup END

