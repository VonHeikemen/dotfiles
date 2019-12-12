" ============================================================================ "
" ===                            DEPENDENCIES                              === "
" ============================================================================ "

" fzf      - https://github.com/junegunn/fzf
" ripgrep  - https://github.com/BurntSushi/ripgrep
" vim-plug - https://github.com/junegunn/vim-plug

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

" Disable status bar
set laststatus=0

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
syntax sync minlines=256
set synmaxcol=300

" Preserve state (undo, marks, etc) in non visible buffers
set hidden

" Tab set to two spaces
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab


" ============================================================================ "
" ===                               PLUGINS                                === "
" ============================================================================ "

call plug#begin('~/.vim/plugged')

" Fuzzy finder
Plug 'junegunn/fzf.vim'

" Better tabline
Plug 'VonHeikemen/tabline.vim'

" Theme
Plug 'VonHeikemen/rubber-themes.vim'

" Session manager
Plug 'tpope/vim-obsession'

" Autocomplete
Plug 'maxboisvert/vim-simple-complete'

" Clipboard support
Plug 'christoomey/vim-system-copy'

" File manager
Plug 'cocopon/vaffle.vim'

" Language support
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'html', 'twig'] }
Plug 'maxmellon/vim-jsx-pretty', { 'for': ['javascript', 'html', 'twig'] }
Plug 'othree/html5.vim', { 'for': ['html', 'twig', 'php'] }
Plug 'StanAngeloff/php.vim', { 'for': 'php' }
Plug 'lumiliet/vim-twig', { 'for': 'twig' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }

" Snippets
Plug 'tpope/vim-commentary'
Plug 'mattn/emmet-vim', { 'for': ['javascript', 'vue', 'html', 'php'] }
Plug 'jiangmiao/auto-pairs'

" Utilities
Plug 'wellle/targets.vim'
Plug 'moll/vim-bbye'
Plug 'justinmk/vim-sneak'
Plug 'dbakker/vim-projectroot'
Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-surround'
Plug 'unblevable/quick-scope'
Plug 'dhruvasagar/vim-zoom'

call plug#end()

" ============================================================================ "
" ===                            PLUGIN CONFIG                             === "
" ============================================================================ "

" Python syntax
let g:python_no_builtin_highlight = 1
let g:python_no_doctest_code_highlight = 1
let g:python_no_doctest_highlight = 1
let g:python_no_exception_highlight = 1
let g:python_space_error_highlight = 1

" FZF
let $FZF_DEFAULT_OPTS='--layout=reverse'

" Sleuth
let g:sleuth_automatic = 0

" Emmet
let g:user_emmet_leader_key = '<C-A>'
let g:user_emmet_install_global = 0
autocmd FileType html,javascript,vue,php EmmetInstall

" Auto-pairs
let g:AutoPairsMapBS = 0
let g:AutoPairsMapCR = 0

" Simple-complete 
let g:vsc_type_complete = 0

" Tabline
let g:tablineclosebutton = 1

" Quick-scope
let g:qs_highlight_on_keys = ['f', 'F', 't', 'T']
let g:qs_max_chars = 200

" Sneak
let g:sneak#label = 1
let g:sneak#s_next = 1

" Theme
colorscheme rubber-enhanced

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
noremap <Leader>e %

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

" Use tab for indenting
vnoremap <M-Tab> >gv|
vnoremap <S-Tab> <gv
nmap <M-Tab>   >>_
nmap <S-Tab> <<_

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

" Find pattern in directory
nnoremap <Leader>F :Rg<Space>
xnoremap <Leader>F :<C-u>GetSelection<CR>:Rg<Space><C-R>/

" Find buffer under project root
nnoremap <Leader>B :FindProjectBuffers<CR>

" Switch working directory to project root
nnoremap <Leader>dg :ProjectRootLCD<CR>:pwd<CR>

" Open file manager
nnoremap <Leader>da :ExploreDir<CR>
nnoremap <Leader>de :vsplit \| ExploreDir<CR>
nnoremap <Leader>ds :split \| ExploreDir<CR>
nnoremap <Leader>dd :Vaffle<CR>

" Begin search & replace using the selected text
xnoremap <Leader>r :<C-u>GetSelection<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>

" Open terminal
nnoremap <Leader><CR> :exe has('nvim') ? 'vsplit \| term' : 'vert term'<CR>

" Put selected text in register '/'
vnoremap <Leader>y :<C-u>GetSelection<CR>gv

" Close buffer while preserving the layout
nnoremap <Leader>bc :Bdelete<CR>

" Put content in register 'a'
vnoremap cay "ay

" Extract content from register 'a'
nnoremap cap "ap

" Replace selected text with register 'a'
vnoremap cap d"ap

" Delete and put content in register 'a'
vnoremap cad "ad

" Prevent vim-sneak from hijacking ; and ,
nmap <M-;> <Plug>Sneak_;
omap <M-;> <Plug>Sneak_;
xmap <M-;> <Plug>Sneak_;
nmap <M-,> <Plug>Sneak_,
omap <M-,> <Plug>Sneak_,
xmap <M-,> <Plug>Sneak_,

