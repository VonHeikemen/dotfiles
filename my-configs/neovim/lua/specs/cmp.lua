-- Autocompletion
local Plugin = {'hrsh7th/nvim-cmp'}

Plugin.event = {'InsertEnter'}

local user = {}

function Plugin.opts(cmp)
  local select_opts = {behavior = cmp.SelectBehavior.Select}
  local cmp_enable = cmp.get_config().enabled

  return {
    enabled = function()
      if user.autocomplete then
        return cmp_enable()
      end

      return false
    end,
    completion = {
      completeopt = 'menu,menuone',
    },
    snippet = {
      expand = function(args)
        require('mini.snippets').default_insert({body = args.body})
        cmp.resubscribe({'TextChangedI', 'TextChangedP'})
        require('cmp.config').set_onetime({sources = {}})
      end,
    },
    sources = {
      {name = 'path'},
      {name = 'nvim_lsp', keyword_length = 3},
      {name = 'buffer', keyword_length = 3},
      {name = 'mini_snippets', keyword_length = 2},
    },
    view = {
      docs = {
        auto_open = false,
      }
    },
    window = {
      documentation = {
        border = 'rounded',
        max_height = 15,
        max_width = 50,
        zindex = 50,
      }
    },
    formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
        local n = entry.source.name

        if n == 'nvim_lsp' then
          item.menu = 'λ'
        elseif n == 'mini_snippets' then
          item.menu = '⋗'
        elseif n == 'buffer' then
          item.menu = 'Ω'
        elseif n == 'path' then
          item.menu = '🖫'
        elseif n == 'omni' then
          item.menu = 'Π'
        elseif n == 'tags' then
          item.menu = 'Π'
        else
          item.menu = '?'
        end

        return item
      end,
    },
    mapping = {
      ['<M-b>'] = cmp.mapping.confirm({select = true}),
      ['<C-k>'] = cmp.mapping.scroll_docs(-5),
      ['<C-j>'] = cmp.mapping.scroll_docs(5),
      ['<C-g>'] = cmp.mapping(function(fallback)
        if cmp.visible_docs() then
          cmp.close_docs()
        elseif cmp.visible() then
          cmp.open_docs()
        else
          fallback()
        end
      end),

      ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
      ['<Down>'] = cmp.mapping.select_next_item(select_opts),

      ['<M-k>'] = cmp.mapping.select_prev_item(select_opts),
      ['<M-j>'] = cmp.mapping.select_next_item(select_opts),
      ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
      ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

      ['<M-u>'] = cmp.mapping(function()
        if cmp.visible() then
          user.set_autocomplete(false)
          cmp.abort()
        else
          user.set_autocomplete(true)
          cmp.complete()
        end
      end),

      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.confirm({select = true})
        elseif user.is_whitespace() then
          fallback()
        else
          user.set_autocomplete(true)
          cmp.complete()
        end
      end, {'i', 's'}),

      ['<S-Tab>'] = cmp.mapping(function()
        vim.api.nvim_feedkeys(user.tab_keycode, 'n', true)
      end, {'i', 's'}),
    }
  }
end

function Plugin.config(opts)
  vim.cmd('SpecEvent mini-snippets')
  local cmp = require('cmp')

  user.autocomplete = true
  user.tab_keycode = vim.keycode('<Tab>')
  user.augroup = vim.api.nvim_create_augroup('compe_cmds', {clear = true})
  vim.api.nvim_create_user_command('UserCmpEnable', user.enable_cmd, {})

  cmp.setup(opts(cmp))

  cmp.setup.filetype('BufferNav', {
    enabled = true,
    sources = {{name = 'path'}},
  })
end

function user.lsp_capabilities()
  local capabilities = require('cmp_nvim_lsp').default_capabilities()
  vim.lsp.config('*', {capabilities = capabilities})
end

function user.set_autocomplete(new_value)
  local old_value = user.autocomplete

  if new_value == old_value then
    return
  end

  if new_value == false then
    -- restore autocomplete in the next word
    vim.api.nvim_buf_set_keymap(
      0,
      'i',
      '<space>',
      '<cmd>UserCmpEnable<cr><space>',
      {noremap = true}
    )

    -- restore when leaving insert mode
    vim.api.nvim_create_autocmd('InsertLeave', {
      group = user.augroup,
      command = 'UserCmpEnable',
      once = true,
    })
  end

  user.autocomplete = new_value
end

function user.is_whitespace()
  local col = vim.fn.col('.') - 1
  if col == 0 then
    return true
  end

  local char = vim.fn.getline('.'):sub(col, col)
  return type(char:match('%s')) == 'string'
end

function user.enable_cmd()
  if user.autocomplete then
    return
  end

  pcall(vim.api.nvim_buf_del_keymap, 0, 'i', '<Space>')
  user.set_autocomplete(true)
end

local function ext(spec)
  spec.event = Plugin.event
  return spec
end

return {
  Plugin,
  ext({'hrsh7th/cmp-buffer'}),
  ext({'hrsh7th/cmp-path'}),
  ext({'abeldekat/cmp-mini-snippets'}),
  ext({'hrsh7th/cmp-omni'}),
  ext({'quangnguyen30192/cmp-nvim-tags'}),
  {
    'hrsh7th/cmp-nvim-lsp',
    user_event = {'SpecVimEdit'},
    config = user.lsp_capabilities,
  },
}

