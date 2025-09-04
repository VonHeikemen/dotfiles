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
}

function Plugin.update()
  vim.cmd('TSUpdate')
end

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

  local filetypes = user.map_filetypes(opts.parsers)
  autocmd('FileType', {
    group = group,
    callback = function(event)
      enable(event, filetypes)
    end,
  })
end

function user.textobject(lhs, ts_capture)
  vim.keymap.set({'x', 'o'}, lhs, function()
    require('nvim-treesitter-textobjects.select')
      .select_textobject(ts_capture, 'textobjects')
  end)
end

function user.map_filetypes(parsers)
  local result = {}
  local get_ft = vim.treesitter.language.get_filetypes

  for _, parser in ipairs(parsers) do
    for _, ft in ipairs(get_ft(parser)) do
      result[ft] = true
    end
  end

  return result
end

function user.enable_feature(event, filetypes)
  local ft = event.match
  if filetypes[ft] == nil then
    return
  end

  local bufnr = event.buf
  local ts = vim.treesitter
  local lang = ts.language.get_lang(ft)
  local ok, query = false, nil

  ok, query = pcall(ts.query.get, lang, 'highlights')
  if ok and query then
    ts.start(bufnr, lang)
  end

  ok, query = pcall(ts.query.get, lang, 'indents')
  if ok and query then
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

return {
  Plugin,
  {'nvim-treesitter/nvim-treesitter-textobjects', rev = 'main'},
}

