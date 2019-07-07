:autocmd FileType php
  \ :iabbrev <buffer> ed@ echo; die();<Esc>F;i

:autocmd FileType php
  \ :iabbrev <buffer> jd@ echo json_encode(); die();<Esc>2F)i

:autocmd FileType php
  \ :iabbrev <buffer> vd@ echo var_dump(); die();<Esc>2F)i

:autocmd FileType javascript,vue
  \ :iabbrev <buffer> con@ console.log();<Left><Left>

:autocmd FileType twig,html,javascript,vue
  \ :iabbrev <buffer> im@ import {} from '';<Left><Left>

:autocmd FileType php,twig,html,javascript,vue
  \ :iabbrev <buffer> if@ if() {<CR>}<Esc>%<Left><Left>i

:autocmd FileType php,twig,html,javascript,vue
  \ :iabbrev <buffer> el@ else {<CR>}<Up><End>

:autocmd FileType php,twig,html,javascript,vue
  \ :iabbrev <buffer> eli@ else {<CR>}<Esc>%iif() <Left><Left>

:autocmd FileType php,twig,html,javascript,vue
  \ :iabbrev <buffer> fun@ function() {<CR>}<Esc>%F(i
