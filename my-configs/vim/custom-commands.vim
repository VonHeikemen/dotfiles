" Show syntax id
command! SyntaxQuery call s:syntax_query()

" Get visually selected text
command! GetSelection call s:get_selection('/')

" Toggle terminal
command! -nargs=+ OpenTerm call s:show_term(<f-args>)

" Enter 'writer mode'
command! WriterMode call feedkeys(':Goyo x100%-1<CR>')

" Run writer_mode when calling Goyo
autocmd! User GoyoEnter nested call <SID>writer_mode()

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

" Settings for writing in markdown
function! s:writer_mode() abort
  set wrap
  noremap j gj
  noremap k gk

  let g:qs_max_chars = 2000
  set synmaxcol=2000
endfunction

" Returns visually selected text
" taken from https://github.com/rafi/vim-config
function! s:get_selection(cmdtype) "{{{
  let temp = @s
  normal! gv"sy
  let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
  let @s = temp
endfunction "}}}

" Handle terminal state
let g:_terminal_open = 0
function! s:show_term(mode) abort
  let g:_terminal_open = !g:_terminal_open
  let l:cmd = 'noautocmd Nuake'
  
  if a:mode == 'current'
    exec l:cmd
  elseif a:mode == 'right'
    let g:nuake_position='right'
    exec l:cmd
  elseif a:mode == 'bottom'
    let g:nuake_position='bottom'
    exec l:cmd
  elseif a:mode == 'fullscreen'
    if g:_terminal_open
      exec l:cmd
      call zoom#toggle()
    else
      call zoom#toggle()
      exec l:cmd
    endif
  endif

  if g:_terminal_open
    call feedkeys('i')
  else
    call feedkeys("\<Esc>")
  endif
endfunction

if has('nvim-0.4')
  " Using the custom window creation function
  let g:fzf_layout = { 'window': 'call FloatingFZF()' }

  " Function to create the custom floating window
  function! FloatingFZF()
    " creates a scratch, unlisted, new, empty, unnamed buffer
    " to be used in the floating window
    let buf = nvim_create_buf(v:false, v:true)

    " 50% of the height
    let height = float2nr(&lines * g:floating_windows.height)
    " 90% of the width
    let width = float2nr(&columns * g:floating_windows.width)
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

