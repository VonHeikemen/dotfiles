" Find in files command
command! -bang -nargs=* Find
  \ call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color "always" '.shellescape(<q-args>), 1,
    \ <bang>0)

" Search buffers below the project root
command! FindProjectBuffers
  \ call fzf#run(fzf#wrap({
    \'source': map(ProjectBuffers(), function('s:format_buffer')),
    \'sink*': function('s:bufopen'),
    \'options': ['+m', '--expect', 'ctrl-t,ctrl-v,ctrl-x']})) 

" Show syntax id
command! SyntaxQuery call s:syntax_query()

" Get visually selected text
command! GetSelection call s:get_selection('/')

" Change window working directory
command! ProjectRootGuess call s:auto_project_root_cd() 

" Call file manager
command! ExploreDir call s:explore_dir()

" Override tab settings
command! ForceTab call s:force_tab()

" Guess buffer indentation
command! GuessIndent call s:set_indentation()
command! AutoGuessIndent call s:guess_indent()
command! TabStatus call s:tab_indicator()

" Called when switching between tabpages
autocmd TabEnter * call s:auto_project_root_cd()

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

" Guess project root of current buffer
function! s:auto_project_root_cd()
  try
    if &ft != 'help'
      ProjectRootLCD
    endif
  catch
    " Silently ignore invalid buffers
  endtry
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
function! s:format_buffer(key, val)
  let index = '[%' . len(bufnr('$')) . 'd]'
  let name = fnamemodify(a:val, ':p:~:.')
  let bufnum = bufnr(a:val)
  let flag = bufnr('') == bufnum ? '%' 
    \ : bufnr('#') == bufnum ? '#'
    \ : '-'

  return printf(index . ' %s %s', bufnum, flag, name)
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
    exe 'Vaffle %:~:h'
  catch
    exe 'Vaffle'
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

function! s:guess_indentation() abort
  let l:sample_len = min([line('$'), float2nr(pow(2, 14))])
  let l:sample = getline(1, l:sample_len)

  let l:starts_with_tab = 0
  let l:spaces_list = []
  let l:indented_lines = 0
  let l:line_count = 1

  for line in sample
    if len(line) is 0
      continue
    elseif line[0] =~# '^\t\+$'
      " line starts with tab
      let l:starts_with_tab += 1
      let l:indented_lines += 1
    elseif line[0] =~# '^\s\+$' 
      " line starts with space
      call add(l:spaces_list, indent(l:line_count))
      let l:indented_lines += 1
    endif
    let l:line_count += 1
  endfor

  let l:evidence = [1.0, 1.0, 0.8, 0.9, 0.8, 0.9, 0.9, 0.95, 1.0]

  if len(l:spaces_list) > l:starts_with_tab
    let l:index = 8

    while l:index >= 0
      let l:same_indent = []

      " create same_indent list
      for x in l:spaces_list
        if x % l:index == 0
          call add(l:same_indent, x)
        endif
      endfor

      if len(l:same_indent) >= l:evidence[l:index] * len(l:spaces_list)
        return ["spaces", l:index]
      endif

      let l:index -= 1
    endwhile

    " start again
    let l:index = 8

    while l:index >= 0
     let l:same_indent = []

      " create same_indent list
      for x in l:spaces_list
        if x % l:index == 0 || x % indent == 1
          call add(l:same_indent, x)
        endif
      endfor

      if len(l:same_indent) >= l:evidence[l:index] * len(l:spaces_list)
        return ["spaces", l:index]
      endif

      let l:index -= 2
    endwhile

  elseif l:starts_with_tab >= 0.75 * l:indented_lines
    return ["tabs", 0]

  endif
  
  return ["default", 0]
endfunction

function! s:force_tab()
  set tabstop=4
  set shiftwidth=0
  set softtabstop=0
  set noexpandtab
endfunction

function! s:set_indentation() abort
  let l:guess = s:guess_indentation()

  if l:guess[0] ==# 'spaces'
    echo 'Setting indentation to' l:guess[1] 'spaces'
    call setbufvar('', '&tabstop', l:guess[1])
	  call setbufvar('', '&shiftwidth', l:guess[1])
	  call setbufvar('', '&softtabstop', l:guess[1])
    return
  endif

  if l:guess[0] ==# 'tabs'
    echo 'Setting indentation to tabs'
    call setbufvar('', '&tabstop', 4)
    call setbufvar('', '&shiftwidth', 0)
    call setbufvar('', '&softtabstop', 0)
    return
  endif

  echo 'Unclear indentation'
endfunction

function! s:guess_indent() abort
  autocmd BufAdd * call feedkeys(":GuessIndent\<CR>", 'n')
endfunction

function! s:tab_indicator() abort
  let sw = &shiftwidth
  echo 'sw=' sw 'ts=' &tabstop 
endfunction
