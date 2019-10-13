" Find in files command
command! -bang -nargs=* Find
  \ call fzf#vim#grep(
    \ 'rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --color "always" '.shellescape(<q-args>), 1,
    \ <bang>0)

" Search buffers below the project root
command! FindProjectBuffers
  \ call fzf#run(fzf#wrap({
    \'source': map(ProjectBuffers(getcwd()), function('s:format_buffer')),
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
