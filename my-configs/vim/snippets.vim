:autocmd FileType php
  \ :iabbrev <buffer> ed@ echo; die();<Esc>F;i

:autocmd FileType php
  \ :iabbrev <buffer> jd@ echo json_encode(); die();<Esc>2F)i

:autocmd FileType php
  \ :iabbrev <buffer> vd@ echo var_dump(); die();<Esc>2F)i

:autocmd FileType php
  \ :iabbrev <buffer> pfun@ public function()<CR>{<CR>}<Esc>%kffwi

:autocmd FileType php
  \ :iabbrev <buffer> prfun@ private function()<CR>{<CR>}<Esc>%kffwi

:autocmd FileType php
  \ :iabbrev <buffer> for@ for($i=0; $i <; $i++) {<CR>}<Esc>%F<a

:autocmd FileType php
  \ :iabbrev <buffer> fore@ foreach(z as $key => $value) {<CR>}<Esc>%Fzxi

:autocmd FileType php
  \ :iabbrev <buffer> sw@ switch(z)<CR>{<CR>}<Up><CR>case :<CR><BS>break;<CR><CR>default:<CR><BS><TAB>break;<Esc>vi{>><Esc>kkfzxi

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

:autocmd FileType twig,html,javascript,vue
  \ :iabbrev <buffer> sw@ switch(z) {<CR>}<Up><End><CR>case :<CR><BS>break;<CR><CR>default:<CR><BS>break;<Esc>j%Fzxi

:autocmd FileType php,twig,html,javascript,vue
  \ :iabbrev <buffer> fun@ function() {<CR>}<Esc>%F(i
