local autocmd = require('bridge').augroup('compe_cmds')
local lua_cmd = require('bridge').lua_cmd

local cmp = require('cmp')
local luasnip = require('luasnip')
local user = {}

local select_opts = {behavior = cmp.SelectBehavior.Select}

user.config = {
  completion = {
    completeopt = 'menu,menuone,noinsert',

    -- setting it to `nil` enables automatic completion
    autocomplete = nil,
  },
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp', keyword_length = 4},
    {name = 'buffer', keyword_length = 3},
    {name = 'luasnip', keyword_length = 2},
  },
  documentation = {
    maxheight = 15,
    maxwidth = 50,
    border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<M-k>'] = cmp.mapping.select_prev_item(select_opts),
    ['<M-j>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-d>'] = cmp.mapping.scroll_docs(5),
    ['<C-u>'] = cmp.mapping.scroll_docs(-5),

    ['<C-e>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.close()
        user.set_autocomplete(false)
        fallback()
      else
        cmp.complete()
        user.set_autocomplete(true)
      end
    end),

    ['<Tab>'] = cmp.mapping(function(fallback)
      user.set_autocomplete(true)

      if cmp.visible() then
        cmp.confirm({select = true})
      elseif luasnip.jumpable(1) then
        luasnip.jump(1)
      elseif user.check_back_space() then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function() luasnip.jump(-1) end, {'i', 's'}),
  }
}

user.set_autocomplete = function(value)
  -- `nil` means autocomplete is enabled
  local new_value = nil

  if value == false then
    new_value = false
  end

  if new_value == user.config.completion.autocomplete then
    return
  end

  if new_value == false then
    -- restore autocomplete in the next word
    local keymap = '<cmd>%s<CR><Space>'
    vim.api.nvim_buf_set_keymap(
      0,
      'i',
      '<Space>',
      keymap:format(user.enable_cmd),
      {noremap = true}
    )

    -- restore when leaving insert mode
    autocmd({'InsertLeave', once = true}, user.enable_cmd)
  end

  user.config.completion.autocomplete = new_value
  cmp.setup.buffer(user.config)
end

user.check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

user.enable_cmd = lua_cmd(function()
  if user.config.completion.autocomplete == nil then return end

  pcall(vim.api.nvim_buf_del_keymap, 0, 'i', '<Space>')
  user.set_autocomplete(true)
end)

cmp.setup(user.config)

