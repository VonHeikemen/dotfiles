" Override tab settings
command! ForceTab call s:force_tab()
command! -nargs=+ UseSpaces call s:use_spaces(<f-args>)
command! UseTabs call s:use_tabs()

" Guess buffer indentation
command! GuessIndent call s:vs_detect()
command! AutoGuessIndent call s:guess_indent()

" See tab related settings
command! TabStatus call s:tab_indicator()

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
  autocmd BufAdd * if expand('<afile>') ==# '' | echo "" | else | call feedkeys(":GuessIndent\<CR>", 'n')
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

" taken from Tim Pope's vim-sl:euth
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

