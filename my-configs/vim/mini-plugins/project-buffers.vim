" Search buffers below the project root
command! FindProjectBuffers 
  \ call fzf#run(fzf#wrap({
  \   'source': map(ProjectBuffers(getcwd()), 's:format_buffer(v:val)'),
  \   'sink*': function('s:bufopen'),
  \   'options': ['+m', '--expect', 'ctrl-t,ctrl-v,ctrl-x']
  \ }))

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

