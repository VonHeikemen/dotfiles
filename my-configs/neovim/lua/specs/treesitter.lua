local Plugin = {'nvim-treesitter/nvim-treesitter'}
local user = {}

Plugin.rev = 'main'

Plugin.opts = {
  parsers = {
    'javascript',
    'typescript',
    'tsx',
    'php',
    'html',
    'twig',
    'css',
    'bash',
    'json',
    'lua',
    'vim',
    'vimdoc',
    'markdown',
    'markdown_inline',
  },
  filetypes = {
    vim = true,
    php = true,
    css = true,
    html = true,
    twig = true,
    markdown = true,
    javascript = true,
    javascriptreact = true,
    typescript = true,
    typescriptreact = true,
    lua = {indent = true},
    json = {highlight = true},
  }
}

function Plugin.config(opts)
  local group = vim.api.nvim_create_augroup('treesitter_cmds', {clear = true})
  local autocmd = vim.api.nvim_create_autocmd
  local textobject = user.textobject
  local enable = user.enable_feature

  -- use bash parser for zsh. it should be good enough.
  vim.treesitter.language.register('bash', 'zsh')

  require('nvim-treesitter').install(opts.parsers)

  textobject('af', '@function.outer')
  textobject('if', '@function.inner')
  textobject('ac', '@class.outer')
  textobject('ic', '@class.inner')

  autocmd('FileType', {
    pattern = vim.tbl_keys(opts.filetypes),
    group = group,
    callback = function(event) enable(event, opts.filetypes) end,
  })
end

function user.textobject(lhs, ts_capture)
  vim.keymap.set({'x', 'o'}, lhs, function()
    require('nvim-treesitter-textobjects.select')
      .select_textobject(ts_capture, 'textobjects')
  end)
end

function user.enable_feature(event, filetypes)
  local ft = filetypes[event.match]

  if ft == true then
    ft = {highlight = true, indent = true}
  end


  if ft.highlight then
    vim.treesitter.start()
  end

  if ft.regex then
    vim.bo.syntax = 'on'
  end

  if ft.indent then
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

return {
  Plugin,
  {'nvim-treesitter/nvim-treesitter-textobjects', rev = 'main'},
}

