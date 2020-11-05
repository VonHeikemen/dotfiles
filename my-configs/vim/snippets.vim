:autocmd FileType php
  \ :iabbrev <buffer> ed@ echo; die();<Esc>F;i

:autocmd FileType php
  \ :iabbrev <buffer> jd@ echo json_encode(); die();<Esc>2F)i

:autocmd FileType php
  \ :iabbrev <buffer> vd@ echo var_dump(); die();<Esc>2F)i

:autocmd FileType php
  \ :iabbrev <buffer> pfun@ public function()<CR>{<CR>}<Esc>%kf(i

:autocmd FileType php
  \ :iabbrev <buffer> prfun@ private function()<CR>{<CR>}<Esc>%kf(i

:autocmd FileType php
  \ :iabbrev <buffer> for@ for($i=0; $i <; $i++) {<CR><CR>}<Esc>%F<a

:autocmd FileType php
  \ :iabbrev <buffer> fore@ foreach(z as $key => $value) {<CR><CR>}<Esc>%Fzxi

:autocmd FileType php
  \ :iabbrev <buffer> sw@ switch(z)<CR>{<CR>}<Up><CR>case :<CR><BS>break;<CR><CR>default:<CR><BS><TAB>break;<Esc>vi{>><Esc>kkfzxi

:autocmd FileType html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> con@ console.log();<Left><Left>

:autocmd FileType html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> im@ import {} from '';<Left><Left>

:autocmd FileType php,html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> if@ if() {<CR>}<Esc>%<Left><Left>i

:autocmd FileType php,html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> el@ else {<CR>}<Up><End>

:autocmd FileType php,html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> eli@ else {<CR>}<Esc>%iif() <Left><Left>

:autocmd FileType html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> sw@ switch(z) {<CR>}<Up><End><CR>case :<CR><BS>break;<CR><CR>default:<CR><BS>break;<Esc>j%Fzxi

:autocmd FileType php,html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> fun@ function() {<CR>}<Esc>%F(i

:autocmd FileType php,html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> afun@ async function() {<CR>}<Esc>%F(i

:autocmd FileType php,html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> forii@ for(let i = 0; i <z; i++) {<CR><CR>}<Esc><Up><Up>fzxi 

:autocmd FileType php,html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> forof@ for(let value ofz) {<CR><CR>}<Esc><Up><Up>fzxi 

:autocmd FileType php,html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> iife@ (async function () {z})()<Esc>%Fzxi<CR><CR><Up>

:autocmd FileType vue
  \ :iabbrev <buffer> vbase@ <template><CR>here<CR></template><CR><CR><script><CR>export default {<CR><CR>};<CR></script><CR><CR><style scoped><CR><CR></style><Esc>?here<CR>dwi

:autocmd FileType vue
  \ :iabbrev <buffer> vdata@ <Esc>0i<Tab>data() {},<Left><Left><CR><CR><Up><Tab><Tab>return {};

:autocmd FileType vue
  \ :iabbrev <buffer> vvcomp@ <Esc>bvediimport <Esc>pa from '@/components/<Esc>pa.vue';<Esc>/export default {<CR>o<Tab>components: {},<Left><Left><CR><CR><Up><Tab><Tab><Esc>pa,<Esc><C-o>a

:autocmd FileType vue
  \ :iabbrev <buffer> vcomp@ <Esc>bvediimport <Esc>pa from '@/components/<Esc>pa.vue';<Esc>/components: {<CR>o<Tab><Esc>pa,<Esc>ddk$%ko<Esc>Pjdd<C-o><C-o>a

:autocmd FileType vue
  \ :iabbrev <buffer> vimap@ <Esc>bvgUlhvediimport { map<Esc>pa } from 'vuex';

:autocmd FileType vue
  \ :iabbrev <buffer> vmap@ <Esc>bvgUlhvedi...map<Esc>pa(['']),<Esc>4ha

:autocmd FileType vue
  \ :iabbrev <buffer> vfor@ v-for="item inz" :key=""<Esc>Fzxi

:autocmd FileType vue
  \ :iabbrev <buffer> vprops@ props: {<CR><TAB>z: {<CR><TAB>type: String,<CR>default: ""<CR><BS>},<CR><BS>},<Esc>?z<CR>xi

:autocmd FileType vue
  \ :iabbrev <buffer> vprop@ z: {<CR><TAB>type: String,<CR>default: ""<CR><BS>},<Esc>?z<CR>xi

:autocmd FileType php,html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> :O@ <Esc>bea: {},<Left><Left><CR><CR><Up>

:autocmd FileType php,html.twig,html,javascript,typescript,vue
  \ :iabbrev <buffer> :F@ <Esc>bea() {},<Left><Left><CR><CR><Up><Up><Esc>f(a

:autocmd FileType markdown,md
  \ :iabbrev <buffer> `@ ```<CR><Up><End><CR>

:autocmd FileType markdown,md
  \ :iabbrev <buffer> js@ ```<CR><Up><End>js<CR>

:autocmd FileType markdown,md
  \ :iabbrev <buffer> sh@ ```<CR><Up><End>sh<CR>

:autocmd FileType markdown,md
  \ :iabbrev <buffer> html@ ```<CR><Up><End>html<CR>

:autocmd FileType markdown,md
  \ :iabbrev <buffer> css@ ```<CR><Up><End>css<CR>

:autocmd FileType markdown,md
  \ :iabbrev <buffer> +dv@ +++<CR><CR>+++<Up>title = <CR>description = ""<CR>date = <CR>lang = ""<CR>[taxonomies]<CR>tags = []<Esc>5ki " 

:autocmd FileType markdown,md
  \ :iabbrev <buffer> -dv@ ---<CR><CR>---<Up>title:<CR>published: false<CR>description: <CR>tags: <Esc>3ka

