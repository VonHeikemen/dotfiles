local Project = {}

function Project.store_dir()
  local store = require('project').store
  if store.dir then
    return store.dir
  end

  return ''
end

function Project.buffers(name)
  require('project').load_buffer_list(name)
end

function Project.nvim_config()
  vim.cmd('Lsp')
  require('lsp-zero').use('nvim_lua', {})
end

function Project.nvim_plugin(opts)
  local join = vim.fs.joinpath

  vim.cmd('Lsp')

  local lsp_zero = require('lsp-zero')
  local dependencies = {join(vim.env.VIMRUNTIME, 'lua')}
  local lua = join(vim.fn.stdpath('data'), 'lazy', '*', 'lua', '%s')

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
  local get_path = function()
    local delimeter = '/,-,:'
    local fmt = string.format
    vim.cmd(fmt('set iskeyword+=%s', delimeter))
    local file = fmt('%s.md', vim.fn.expand('<cword>'))
    vim.cmd(fmt('set iskeyword-=%s', delimeter))
    return file
  end

  vim.keymap.set('n', 'gd', function()
    local file = get_path()
    local ok = pcall(vim.cmd, {cmd = 'find', args = {file}})
    if not ok then
      local msg = string.format('Could not find "%s"', file)
      vim.notify(msg, vim.log.levels.WARN)
    end
  end, {desc = 'Go to linked file'})

  vim.keymap.set('n', '<C-g>g', function()
    local file = get_path()
    local exec = {cmd = 'edit', args = {file}}
    if vim.fn.filereadable(file) == 1 then
      vim.cmd(exec)
      return
    end

    vim.fn.system({'zk', 'new', '--no-input', '--print-path', file})
    vim.cmd(exec)
  end, {desc = 'Edit linked file under cursor'})

  local function new(input)
    local file = input.args
    local zk_cmd = {'zk', 'new', '--no-input', '--print-path'}

    if file ~= '' then
      table.insert(zk_cmd, file)
    end

    local path = vim.fn.system(zk_cmd)
    vim.cmd({cmd = 'edit', args = {vim.trim(path)}})
  end

  vim.api.nvim_create_user_command('New', new, {nargs = '?'})
end

function Project.worktask()
  Project.zk()
  vim.opt.textwidth = 80

  vim.keymap.set('n', 'gw', 'mt0cl><esc>`t', {desc = 'Mark current task'})
  vim.keymap.set('n', 'gx', 'mt0cl <esc>`t', {nowait = true, desc = 'Delete mark'})
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

