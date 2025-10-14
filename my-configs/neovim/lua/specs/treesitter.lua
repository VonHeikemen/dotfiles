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

  local filetypes = vim.iter(opts.parsers)
    :map(vim.treesitter.language.get_filetypes)
    :flatten()
    :fold({}, function(tbl, v)
      tbl[v] = true
      return tbl
    end)

  autocmd('FileType', {
    group = group,
    desc = 'enable treesitter',
    callback = function(event)
      local ft = event.match
      if filetypes[ft] == nil then
        return
      end

      enable(event.buf, ft)
    end,
  })
end

function user.textobject(lhs, ts_capture)
  vim.keymap.set({'x', 'o'}, lhs, function()
    require('nvim-treesitter-textobjects.select')
      .select_textobject(ts_capture, 'textobjects')
  end)
end

function user.enable_feature(bufnr, filetype)
  local ts = vim.treesitter
  local lang = ts.language.get_lang(filetype)

  local ok, hl = pcall(ts.query.get, lang, 'highlights')
  if ok and hl then
    ts.start(bufnr, lang)
  end

  local ok, idt = pcall(ts.query.get, lang, 'indents')
  if ok and idt then
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

return {
  Plugin,
  {'nvim-treesitter/nvim-treesitter-textobjects', rev = 'main'},
}

