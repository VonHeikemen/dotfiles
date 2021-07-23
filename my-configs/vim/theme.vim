function! MyHighlights() abort
  " highlight Special    cterm=NONE ctermbg=NONE ctermfg=103  gui=NONE guibg=NONE    guifg=#8893A6
  " highlight CursorLine cterm=NONE ctermbg=0    ctermfg=NONE gui=NONE guibg=#242830 guifg=NONE

    hi! link QuickScopePrimary Search
    hi! link QuickScopeSecondary DiffChange
    " highlight QuickScopeSecondary cterm=NONE ctermbg=73 ctermfg=235 gui=NONE guibg=#56B6C2 guifg=#21252B

    hi! link SneakLabel Search
    highlight SneakLabelMask cterm=NONE ctermbg=NONE ctermfg=NONE  gui=NONE guibg=NONE guifg=NONE

    hi! link WarningMsg Comment
    hi! link ErrorMsg Error
    hi! link Question String
    hi! link NonText LineNr

    hi! link netrwMarkFile Search

    hi! link TSConstructor Normal
    hi! link TSVariableBuiltin Normal
    hi! link TSConstBuiltin Number
    hi! link TSFuncBuiltin Function
    hi! link luaTSPunctBracket Normal

    hi! link TelescopeMatching Boolean
    hi! link TelescopeSelection CursorLine
    hi! TelescopeSelectionCaret guifg=#FC8680 guibg=#242830

    hi default link BqfPreviewRange CursorLine
endfunction

augroup MyColors
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END

