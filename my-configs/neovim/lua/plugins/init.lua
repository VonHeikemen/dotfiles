local Plugins = {
  -- Editor Config
  {'editorconfig/editorconfig-vim', lazy = true},
  {'mattn/emmet-vim', enabled = false},

  -- Language Support
  {'othree/html5.vim'},
  {'pangloss/vim-javascript'},
  {'lumiliet/vim-twig'},

  -- Git
  {'rhysd/conflict-marker.vim', lazy = true},

  -- Utilities
  {'tpope/vim-repeat'},
  {'tpope/vim-abolish'},
  {'nvim-treesitter/playground', lazy = true},
}

return Plugins

