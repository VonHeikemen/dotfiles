local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = {behavior = cmp.SelectBehavior.Select}

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

local scroll_or_jump = function(direction)
  local opts = {}
  if direction == 'up' then
    opts = {scroll = 5, jump = 1}
  elseif direction == 'down' then
    opts = {scroll = -5, jump = -1}
  end

  return function(fallback)
    if cmp.visible() then
      cmp.scroll_docs(opts.scroll)
    elseif luasnip.jumpable(opts.jump) then
      luasnip.jump(opts.jump)
    else
      fallback()
    end
  end
end

cmp.setup({
  completion = {
    autocomplete = false
  },
  sources = {
    {name = 'path'},
    {name = 'buffer'},
    {name = 'luasnip'}
  },
  documentation = {
    maxheight = 15,
    maxwidth = 50
  },
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({select = true}),
    ['<C-e>'] = cmp.mapping.close(),

    ['<C-j>'] = cmp.mapping.select_next_item(select_opts),
    ['<C-k>'] = cmp.mapping.select_prev_item(select_opts),

    ['<C-d>'] = cmp.mapping(scroll_or_jump('up'), {'i', 's'}),
    ['<C-u>'] = cmp.mapping(scroll_or_jump('down'), {'i', 's'}),

    ['<C-Space>'] = function()
      if cmp.visible() then
        cmp.confirm({select = true})
      else
        cmp.complete()
      end
    end,

    ['<Tab>'] = function(fallback)
      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif check_back_space() then
        fallback()
      else
        cmp.complete()
      end
    end,

    ['<S-Tab>'] = function()
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      end
    end,
  }
})

