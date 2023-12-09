local Project = {}

local function cmp_source(ft, new_source)
  local cmp = require('cmp')
  local sources = vim.deepcopy(cmp.get_config().sources)

  for _, s in pairs(new_source) do
    table.insert(sources, {name = s, keyword_length = 3})
  end

  cmp.setup.filetype(ft, {sources = sources})
end

function Project.nvim_config()
  vim.cmd('Lsp')
  cmp_source('lua', {'nvim_lua'})

  require('lsp-zero').use('nvim_lua', {})
end

function Project.nvim_plugin(opts)
  vim.cmd('Lsp')

  local lsp_zero = require('lsp-zero')
  local dependencies = {vim.fn.expand('$VIMRUNTIME/lua')}
  local lua = vim.fn.stdpath('data') .. '/lazy/*/lua/%s'

  if opts.dependencies then
    for i, mod in ipairs(opts.dependencies) do
      local path = vim.fn.glob(lua:format(mod))
      dependencies[i + 1] = path == '' and nil or path
    end
  end

  local lua_opts = {
    settings = {
      Lua = {
        workspace = {
          library = dependencies
        },
      }
    }
  }

  cmp_source('lua', {'nvim_lua'})

  lsp_zero.use('nvim_lua', lua_opts)
end

function Project.legacy_php()
  local cmp = require('cmp')
  local config = {}
  config.sources = {
    {name = 'omni'},
    {name = 'tags'},
  }

  cmp.setup.filetype('php', {
    mapping = {
      ['<C-l>'] = cmp.mapping(function()
        vim.cmd('UserCmpEnable')
        cmp.complete({config = config})
      end)
    }
  })

  vim.keymap.set('n', 'gd', "<cmd>exe 'tjump' expand('<cword>')<cr>")
end

function Project.zk()
  vim.opt.path = {'.', '', '**'}

  vim.keymap.set('n', 'gd', function()
    local fmt = string.format
    local delimeter = '/,-,:'

    vim.cmd(fmt('set iskeyword+=%s', delimeter))
    local file = fmt('%s.md', vim.fn.expand('<cword>'))
    vim.cmd(fmt('set iskeyword-=%s', delimeter))

    vim.cmd({cmd = 'find', args = {file}})
  end, {desc = 'Go to linked file'})
end

function Project.worktask()
  Project.zk()
  vim.opt.textwidth = 80

  vim.keymap.set('n', 'gw', 'mt0cl><esc>`t', {desc = 'Mark current task'})
  vim.keymap.set('n', 'ge', 'mt0cl <esc>`t', {nowait = true, desc = 'Delete mark'})
  vim.keymap.set('n', 'gu', 'mt0cl?<esc>`t', {desc = 'Mark task as paused'})
  vim.keymap.set('n', 'gt', 'gg/^><cr>zz', {desc = 'Go to current task'})

  vim.keymap.set('n', 'gs', function()
    local line = vim.api.nvim_get_current_line()
    local index = line:find('%d+.')
    if index == nil then
      return
    end

    local pattern = '\\[%s\\]'
    vim.fn.setreg('/', pattern:format(vim.trim(line:sub(2, index))))
    vim.api.nvim_feedkeys('nzz', 'n', false)
  end, {desc = 'Go to task note'})
end

return Project

