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
    'zsh',
    'json',
    'lua',
    'sql',
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

  textobject('af', '@function.outer')
  textobject('if', '@function.inner')
  textobject('ac', '@class.outer')
  textobject('ic', '@class.inner')

  local filetypes = vim.iter(opts.parsers)
    :map(vim.treesitter.language.get_filetypes)
    :flatten()
    :fold({}, function(tbl, v)
      tbl[v] = 0
      return tbl
    end)

  autocmd('FileType', {
    group = group,
    desc = 'enable treesitter',
    callback = function(event)
      local ft = event.match
      local available = filetypes[ft]
      if available == nil then
        return
      end

      local bufnr = event.buf
      local tsl = vim.treesitter.language
      local lang = tsl.get_lang(ft) or ''

      if available == 0 and tsl.add(lang) then
        available = 1
        filetypes[ft] = 1
      end

      if available == 1 then
        enable(bufnr, lang)
        return
      end

      require('nvim-treesitter').install(lang):await(function()
        local parser_installed = tsl.add(lang) == true
        if not parser_installed then
          filetypes[ft] = nil
          return
        end

        filetypes[ft] = 1
        enable(bufnr, lang)
      end)
    end,
  })
end

function user.textobject(lhs, ts_capture)
  vim.keymap.set({'x', 'o'}, lhs, function()
    require('nvim-treesitter-textobjects.select')
      .select_textobject(ts_capture, 'textobjects')
  end)
end

function user.enable_feature(bufnr, lang)
  local ts = vim.treesitter

  local ok_hl, hl = pcall(ts.query.get, lang, 'highlights')
  if ok_hl and hl then
    ts.start(bufnr, lang)
  end

  local ok_idt, idt = pcall(ts.query.get, lang, 'indents')
  if ok_idt and idt then
    vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end
end

return {
  Plugin,
  {'nvim-treesitter/nvim-treesitter-textobjects', rev = 'main'},
}

