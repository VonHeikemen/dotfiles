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
    'json',
    'lua',
    'vim',
    'vimdoc',
  },
  ft = {
    vimdoc = {'help'},
    tsx = {'javascriptreact', 'typescriptreact'}
  },
}

function Plugin.config(opts)
  local group = vim.api.nvim_create_augroup('treesitter_cmds', {clear = true})
  local textobject = user.textobject
  local autocmd = vim.api.nvim_create_autocmd

  user.ensure_installed(opts.parsers)

  textobject('af', '@function.outer')
  textobject('if', '@function.inner')
  textobject('ac', '@class.outer')
  textobject('ic', '@class.inner')

  autocmd('FileType', {
    pattern = user.get_filetypes(opts),
    group = group,
    callback = function()
      vim.treesitter.start()
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })
end

function user.textobject(lhs, ts_capture)
  vim.keymap.set({'x', 'o'}, lhs, function()
    require('nvim-treesitter-textobjects.select')
      .select_textobject(ts_capture, 'textobjects')
  end)
end

function user.get_filetypes(opts)
  local filetypes = {}
  for i, lang in pairs(opts.parsers) do
    local map = opts.ft[lang]
    if map then
      vim.list_extend(filetypes, map)
    else
      table.insert(filetypes, lang)
    end
  end

  return filetypes
end

function user.ensure_installed(parsers)
  local ts = require('nvim-treesitter')
  local installed_parsers = ts.get_installed()
  local missing = {}

  for _, parser in ipairs(parsers) do
    local installed = vim.tbl_contains(installed_parsers, parser)

    if not installed then
      table.insert(missing, parser)
    end
  end

  if not vim.tbl_isempty(missing) then
    ts.install(missing)
  end
end

return {
  Plugin,
  {'nvim-treesitter/nvim-treesitter-textobjects', rev = 'main'},
}

