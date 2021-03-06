" ============================================================================ "
" ===                            DEPENDENCIES                              === "
" ============================================================================ "

" fzf      - https://github.com/junegunn/fzf
" ripgrep  - https://github.com/BurntSushi/ripgrep
" minpac   - https://github.com/k-takata/minpac

" ============================================================================ "
" ===                           EDITING OPTIONS                            === "
" ============================================================================ "

" Don't include vi compatibility
set nocompatible

" Temp files directory
set backupdir=~/.vim/tmp/
set directory=~/.vim/tmp/

" Ignore the case when the search pattern is all lowercase
set smartcase
set ignorecase

" Sensible backspace
set backspace=indent,eol,start

" Leader key
let mapleader = "\<Space>"

" Autosave when navigating between buffers
set autowrite

" Automatically re-read file if a change was detected outside of vim
set autoread

" Disable line wrapping
set nowrap

" Keep lines below cursor when scrolling
set scrolloff=2
set sidescrolloff=5

" Don't highlight search results
set nohlsearch

" Enable incremental search
set incsearch

" Enable cursorline
set cursorline

" Enable status bar
set laststatus=2

" Enable syntax highlight
syntax enable

" Add a bit extra margin to the left
set foldcolumn=1

" When opening a window put it right or below the current one
set splitright
set splitbelow

" Better color support
if (has("termguicolors"))
  set termguicolors
endif

" In Vim, Change the shape of cursor in insert mode
" for VTE compatible terminals
if !has('nvim')
  let &t_SI = "\<Esc>[6 q"
  let &t_SR = "\<Esc>[4 q"
  let &t_EI = "\<Esc>[2 q"
endif

" Speed up syntax highlight
syntax sync minlines=10000
set redrawtime=10000

" Preserve state (undo, marks, etc) in non visible buffers
set hidden

" Tab set to two spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

" Mouse support
set mouse=a

" Look for a tag file in the git folder
set tags^=./.git/tags;

" Statusline
set statusline=
set statusline+=%=
set statusline+=\ %r
set statusline+=\%m
set statusline+=\%{zoom#statusline()}
set statusline+=\ %l:%c
set statusline+=\ %p%%
set statusline+=\ %y
if exists('$TMUX')
  set statusline+=\ \[\%{fnamemodify(getcwd(),':t')}\]
endif
set statusline+=\ 

" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "

function! Plug() abort
  " Initialize plugin manager
  packadd minpac
  call minpac#init()

  " Plugin manager
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  " Fuzzy finder
  call minpac#add('junegunn/fzf.vim')

  " Better tabline
  call minpac#add('VonHeikemen/tabline.vim')

  " Theme
  call minpac#add('VonHeikemen/rubber-themes.vim')

  " Session manager
  call minpac#add('tpope/vim-obsession')

  " Autocomplete
  call minpac#add('maxboisvert/vim-simple-complete')

  " Clipboard support
  call minpac#add('christoomey/vim-system-copy')

  " Language support
  call minpac#add('pangloss/vim-javascript')
  call minpac#add('maxmellon/vim-jsx-pretty')
  call minpac#add('othree/html5.vim')
  call minpac#add('StanAngeloff/php.vim')
  call minpac#add('lumiliet/vim-twig')
  call minpac#add('rust-lang/rust.vim', {'type': 'opt'})

  " Snippets
  call minpac#add('tpope/vim-commentary')
  call minpac#add('mattn/emmet-vim')
  call minpac#add('jiangmiao/auto-pairs')

  " Editor config
  call minpac#add('editorconfig/editorconfig-vim')

  " Enhanced quickfix
  call minpac#add('romainl/vim-qf')
  call minpac#add('stefandtw/quickfix-reflector.vim')

  " Utilities
  call minpac#add('wellle/targets.vim')
  call minpac#add('moll/vim-bbye')
  call minpac#add('justinmk/vim-sneak')
  call minpac#add('dbakker/vim-projectroot')
  call minpac#add('tpope/vim-surround')
  call minpac#add('unblevable/quick-scope')
  call minpac#add('dhruvasagar/vim-zoom')
  call minpac#add('Lenovsky/nuake')
  call minpac#add('junegunn/goyo.vim')
  call minpac#add('tpope/vim-abolish')
  call minpac#add('tpope/vim-repeat')
endfunction

" ============================================================================ "
" ===                            PLUGIN CONFIG                             === "
" ============================================================================ "

" Load fzf
" - Homebrew linux
" set rtp+=/home/linuxbrew/.linuxbrew/opt/fzf
"
" - Debian
" set rtp+=/usr/share/doc/fzf/examples
"
" - Arch
" set rtp+=/usr/share/vim/vimfiles

" Set grep default grep command with ripgrep
set grepprg=rg\ --vimgrep\ --smart-case\ --follow
set errorformat+=%f:%l:%c%p%m

" Floating windows settings
let g:floating_windows = { "height": 0.6, "width": 0.9 }

" Python syntax
let g:python_no_builtin_highlight = 1
let g:python_no_doctest_code_highlight = 1
let g:python_no_doctest_highlight = 1
let g:python_no_exception_highlight = 1
let g:python_space_error_highlight = 1

" FZF
let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_preview_window = ''

" Auto-pairs
let g:AutoPairsMapBS = 0
let g:AutoPairsMapCR = 0

" Simple-complete 
let g:vsc_type_complete = 0

" Tabline
let g:tablineclosebutton = 1

" Quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars = 250

" Sneak
let g:sneak#label = 1
let g:sneak#s_next = 1

" Theme
colorscheme rubber-enhanced

" Nuake
let g:nuake_position = 'bottom'
let g:nuake_size = 0.30

" Zoom
let g:zoom#statustext = '[M]'

" ============================================================================ "
" ===                             KEY MAPPINGS                             === "
" ============================================================================ "

" Enter command mode
nnoremap <CR> :

" Escape to normal mode
noremap <C-L> <Esc>
inoremap <C-L> <Esc>

" Go to normal mode from terminal mode
tnoremap <C-L> <C-\><C-n>

" Select all text in current buffer
nnoremap <Leader>a ggvGg_

" Go to matching pair
nmap <Leader>e %
vmap <Leader>e %

" Go to first character in line
noremap <Leader>h ^

" Go to last character in line
noremap <Leader>l g_

" Scroll half page and center
noremap <C-u> <C-u>M
noremap <C-d> <C-d>M

" Search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap # #zz
nnoremap * *zz

" ============================================================================ "
" ===                           COMMAND MAPPINGS                           === "
" ============================================================================ "

" Moving lines and preserving indentation
nnoremap <C-j> :move .+1<CR>==
nnoremap <C-k> :move .-2<CR>==
vnoremap <C-j> :move '>+1<CR>gv=gv
vnoremap <C-k> :move '<-2<CR>gv=gv

" Write file
nnoremap <Leader>w :write<CR>

" Safe quit
nnoremap <Leader>qq :quitall<CR>

" Force quit
nnoremap <Leader>Q :quitall!<CR>

" Close buffer
nnoremap <Leader>bq :bdelete<CR>

" Move to last active buffer
nnoremap <Leader>bl :buffer #<CR>

" Navigate between buffers
nnoremap [b :bprevious<CR>
nnoremap ]b :bnext<CR>

" Open new tabpage
nnoremap <Leader>tn :tabnew<CR>

" Navigate between tabpages
nnoremap [t :tabprevious<CR>
nnoremap ]t :tabnext<CR>

" Clear messages
nnoremap <Leader><space> :echo ''<CR>

" Switch to the directory of the open buffer
nnoremap <Leader>cd :lcd %:p:h<CR>:pwd<CR>

" ============================================================================ "
" ===                           SEARCH COMMANDS                            === "
" ============================================================================ "

" Show key bindings list
nnoremap <Leader>? :Maps<CR>

" Find files by name
nnoremap <Leader>f :FZF<Space>
nnoremap <Leader>ff :FZF<CR>

" Search symbols in buffer
nnoremap <Leader>fs :BTags<CR>

" Search symbols in workspace
nnoremap <Leader>fS :Tags<CR>

" Search in files history
nnoremap <Leader>fh :History<CR>

" Search in active buffers list
nnoremap <Leader>bb :Buffers<CR>

" ============================================================================ "
" ===                           TOGGLE ELEMENTS                            === "
" ============================================================================ "

" Search result highlight
nnoremap [oh :set hlsearch<CR>
nnoremap ]oh :set nohlsearch<CR>

" Tabline
nnoremap [ot :set showtabline=1<CR>
nnoremap ]ot :set showtabline=0<CR>

" Line length ruler
nnoremap [ol :setlocal colorcolumn=81<CR>
nnoremap ]ol :setlocal colorcolumn=0<CR>

" Cursorline highlight
nnoremap [oc :set cursorline<CR>
nnoremap ]oc :set nocursorline<CR>

" Line numbers
nnoremap [on :set number<CR>
nnoremap ]on :set nonumber<CR>

" Relative line numbers
nnoremap [or :set relativenumber<CR>
nnoremap ]or :set norelativenumber<CR>

" ============================================================================ "
" ===                            MISCELLANEOUS                             === "
" ============================================================================ "

" Navigate to previous 'zoomed' buffer
nmap <Leader>bu <C-w>m<C-w>w<C-w>m

" Find pattern in directory
nnoremap <Leader>F :Rg<Space>
xnoremap <Leader>F :<C-u>GetSelection<CR>:Rg<Space><C-R>/

" Find buffer under project root
nnoremap <Leader>B :FindProjectBuffers<CR>

" Open file manager
nnoremap <leader>dd :Lexplore %:p:h<CR>
nnoremap <Leader>da :Lexplore<CR>

" Begin search & replace using the selected text
nnoremap <Leader>r :%s///gc<Left><Left><Left><Left>
xnoremap <Leader>r :s///gc<Left><Left><Left><Left>
xnoremap <Leader>R :<C-u>GetSelection<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>

" Toggle terminal
nnoremap <F4> :OpenTerm current<CR>
inoremap <F4> <C-\><C-n>:OpenTerm current<CR>
tnoremap <F4> <C-\><C-n>:OpenTerm current<CR>
nnoremap <F5> :OpenTerm fullscreen<CR>
tnoremap <F5> <C-\><C-n>:OpenTerm fullscreen<CR>

" Change terminal position
nnoremap <Leader>ql :OpenTerm right<CR>
nnoremap <Leader>qj :OpenTerm bottom<CR>

" Use tmux inside terminal
tnoremap <M-v> tmux new-session -A -D -s vi<CR>

" Put selected text in register '/'
vnoremap <Leader>y :<C-u>GetSelection<CR>gv
vnoremap <Leader>Y :<C-u>GetSelection<CR>:set hlsearch<CR>

" Close buffer while preserving the layout
nnoremap <Leader>bc :Bdelete<CR>

" Prevent vim-sneak from hijacking ; and ,
nmap <M-;> <Plug>Sneak_;
omap <M-;> <Plug>Sneak_;
xmap <M-;> <Plug>Sneak_;
nmap <M-,> <Plug>Sneak_,
omap <M-,> <Plug>Sneak_,
xmap <M-,> <Plug>Sneak_,

" Manage the quickfix list
nmap [q <Plug>(qf_qf_previous)zz
nmap ]q <Plug>(qf_qf_next)zz
nmap <Leader>cc <Plug>(qf_qf_toggle)

function! QuickfixMapping()
  " Go to location under the cursor
  nnoremap <buffer> gl <CR>
  
  " Go to next location and stay in the quickfix window
  nmap <buffer> K <Plug>(qf_qf_previous)zz<C-w>w

  " Go to previous location and stay in the quickfix window
  nmap <buffer> J <Plug>(qf_qf_next)zz<C-w>w
endfunction
augroup quickfix_mapping
    autocmd!
    autocmd filetype qf call QuickfixMapping()
augroup END

