" Search buffers below the project root
command! FindProjectBuffers 
  \ call fzf#run(fzf#wrap({
  \   'source': map(ProjectBuffers(getcwd()), 's:format_buffer(v:val)'),
  \   'sink*': function('s:bufopen'),
  \   'options': ['+m', '--expect', 'ctrl-t,ctrl-v,ctrl-x']
  \ }))

" Show syntax id
command! SyntaxQuery call s:syntax_query()

" Get visually selected text
command! GetSelection call s:get_selection('/')

" Call file manager
command! ExploreDir call s:explore_dir()

" Override tab settings
command! ForceTab call s:force_tab()
command! -nargs=+ UseSpaces call s:use_spaces(<f-args>)
command! UseTabs call s:use_tabs()

" Guess buffer indentation
command! GuessIndent call s:vs_detect()
command! AutoGuessIndent call s:guess_indent()

" See tab related settings
command! TabStatus call s:tab_indicator()

" Called when opening a file
augroup syntaxOverride
  autocmd!
  autocmd FileType php call s:php_syntax_override()
  autocmd FileType python call s:python_syntax_override()
  autocmd FileType vaffle call s:customize_vaffle_mappings()
augroup END

" Theme debugging
function! s:syntax_query() abort
  for id in synstack(line("."), col("."))
    echo synIDattr(id, "name")
  endfor
endfunction

" Tweak php syntax highlight
function! s:php_syntax_override()
  " Tweak keywords
  syn keyword phpFunctions isset unset empty

  " Function call match
  syn match phpFunctionCall /\v\h\w*\ze(\s?\()/ 
    \ containedin=phpRegion,phpIdentifier
 
  " highlight all types of functions
  hi! link phpFunctionCall Function
  hi! link phpMethod Function
  hi! link phpFunction Function

endfunction

function! s:python_syntax_override()
  " Function match
  syn match pythonFunction /\v[[:alpha:]_]+\ze(\s?\()/
  
  " Known constants
  syn keyword pythonConstant False None True

  hi! link pythonFunction Function
  hi! link pythonConstant Boolean
endfunction

" Returns visually selected text
" taken from https://github.com/rafi/vim-config
function! s:get_selection(cmdtype) "{{{
  let temp = @s
  normal! gv"sy
  let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
  let @s = temp
endfunction "}}}

" Return formatted buffer name
function! s:format_buffer(val)
  let name = fnamemodify(a:val, ':p:~:.')
  let bufnum = bufnr(a:val)
  let flag = bufnr('') == bufnum ? '%' 
    \ : bufnr('#') == bufnum ? '#'
    \ : ' '

  return printf("[%d] %s\t%s", bufnum, flag, name)
endfunction

" Handle open selected file
function! s:bufopen(lines)
  let cmd = get({
    \ 'ctrl-x': 'split',
    \ 'ctrl-v': 'vsplit',
    \ 'ctrl-t': 'tabe'}, a:lines[0], 'e')

  let parts = split(a:lines[1], '\]')
  let buf = substitute(parts[0], '^\[\s*', '', 'g')
  let name = fnamemodify(bufname(buf + 0), ':p')

  exe cmd name
endfunction

" Add mappings to vaffle
function! s:customize_vaffle_mappings() abort
  nmap <buffer> <CR> :
  nmap <buffer> e <Plug>(vaffle-open-selected)
  nmap <buffer> s <Plug>(vaffle-open-selected-split)
  nmap <buffer> v <Plug>(vaffle-open-selected-vsplit)
endfunction

" Handle file manager call
function! s:explore_dir()
  try
    if isdirectory( expand('%:p:h') )
      exe 'Vaffle %:p:h'
    else
      echo 'Not a valid directory'
    endif
  catch
  endtry

endfunction

" Test floating windows
if has('nvim-0.4')
  if !exists(':FZF')
    source /usr/share/vim/vimfiles/plugin/fzf.vim
  endif

  " Using the custom window creation function
  let g:fzf_layout = { 'window': 'call FloatingFZF()' }

  " Function to create the custom floating window
  function! FloatingFZF()
    " creates a scratch, unlisted, new, empty, unnamed buffer
    " to be used in the floating window
    let buf = nvim_create_buf(v:false, v:true)

    " 50% of the height
    let height = float2nr(&lines * 0.5)
    " 60% of the width
    let width = float2nr(&columns * 0.6)
    " horizontal position (centralized)
    let horizontal = float2nr((&columns - width) / 2)
    " vertical position
    let vertical = height * 0.3

    let opts = {
          \ 'relative': 'editor',
          \ 'row': vertical,
          \ 'col': horizontal,
          \ 'width': width,
          \ 'height': height
          \ }

    " open the new window, floating, and enter to it
    call nvim_open_win(buf, v:true, opts)
  endfunction
endif

function! s:tab_indicator() abort
  let sw = &shiftwidth
  echo 'sw=' sw 'ts=' &tabstop 
endfunction

function! s:use_spaces(size) abort
  call setbufvar('', '&tabstop', a:size)
  call setbufvar('', '&shiftwidth', a:size)
  call setbufvar('', '&softtabstop', a:size)
  call setbufvar('', '&expandtab', 1)
endfunction

function! s:use_tabs() abort
  call setbufvar('', '&tabstop', 4)
  call setbufvar('', '&shiftwidth', 0)
  call setbufvar('', '&softtabstop', 0)
  call setbufvar('', '&expandtab', 0)
endfunction

function! s:guess_indent() abort
  autocmd BufAdd * call feedkeys(":GuessIndent\<CR>", 'n')
endfunction

" taken from Tim Pope's vim-sleuth
" source: https://github.com/tpope/vim-sleuth
function! s:vs_guess(lines) abort
  let options = {}
  let heuristics = {'spaces': 0, 'hard': 0, 'soft': 0}
  let ccomment = 0
  let podcomment = 0
  let triplequote = 0
  let backtick = 0
  let xmlcomment = 0
  let softtab = repeat(' ', 8)

  for line in a:lines
    if !len(line) || line =~# '^\s*$'
      continue
    endif

    if line =~# '^\s*/\*'
      let ccomment = 1
    endif
    if ccomment
      if line =~# '\*/'
        let ccomment = 0
      endif
      continue
    endif

    if line =~# '^=\w'
      let podcomment = 1
    endif
    if podcomment
      if line =~# '^=\%(end\|cut\)\>'
        let podcomment = 0
      endif
      continue
    endif

    if triplequote
      if line =~# '^[^"]*"""[^"]*$'
        let triplequote = 0
      endif
      continue
    elseif line =~# '^[^"]*"""[^"]*$'
      let triplequote = 1
    endif

    if backtick
      if line =~# '^[^`]*`[^`]*$'
        let backtick = 0
      endif
      continue
    elseif &filetype ==# 'go' && line =~# '^[^`]*`[^`]*$'
      let backtick = 1
    endif

    if line =~# '^\s*<\!--'
      let xmlcomment = 1
    endif
    if xmlcomment
      if line =~# '-->'
        let xmlcomment = 0
      endif
      continue
    endif

    if line =~# '^\t'
      let heuristics.hard += 1
    elseif line =~# '^' . softtab
      let heuristics.soft += 1
    endif
    if line =~# '^  '
      let heuristics.spaces += 1
    endif
    let indent = len(matchstr(substitute(line, '\t', softtab, 'g'), '^ *'))
    if indent > 1 && (indent < 4 || indent % 2 == 0) &&
          \ get(options, 'shiftwidth', 99) > indent
      let options.shiftwidth = indent
    endif
  endfor

  if heuristics.hard && !heuristics.spaces
    return {'expandtab': 0, 'shiftwidth': &tabstop}
  elseif heuristics.soft != heuristics.hard
    let options.expandtab = heuristics.soft > heuristics.hard
    if heuristics.hard
      let options.tabstop = 4
    endif
  endif

  return options
endfunction

function! s:vs_apply(options) abort
  if !has_key(a:options, 'expandtab') || !has_key(a:options, 'shiftwidth')
    return 0
  else
    for [option, value] in items(a:options)
      call setbufvar('', '&'.option, value)
    endfor
    return 1
  endif
endfunction

function! s:vs_detect() abort
  if &buftype ==# 'help' || bufname('%') ==# ''
    echo ''
    return
  endif

  let l:max = 16384 " float2nr(pow(2, 14))
  let l:sample = getline(1, min([line('$'), l:max]))

  let l:options = s:vs_guess(l:sample)

  if s:vs_apply(l:options)
    let l:msg = 'Apply settings: '
    for [option, value] in items(l:options)
      let l:msg .= option . ' ' . value . ' '
    endfor
    echo msg
  else
    echo 'could not guess indentation'
  endif
endfunction

