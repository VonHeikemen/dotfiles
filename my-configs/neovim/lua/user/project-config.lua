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

  require('user.diagnostics')
  require('statusline').show_diagnostic = true

  require('lint').linter_by_ft = {php = {'php'}}

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'php',
    callback = function(event)
      vim.b.linter_attached = 1

      local try_lint = function()
        require('lint').try_lint('php')
      end

      vim.api.nvim_create_autocmd('BufWritePost', {
        buffer = event.buf,
        callback = try_lint,
      })
    end
  })
end

function Project.zk()
  vim.opt.path = {'.', '', '**'}

  local root_dir = vim.env.ZK_NOTEBOOK_DIR
  if root_dir then
    vim.cmd.lcd(root_dir)
  end

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

  local function cmd_new(input)
    local file = input.args
    local zk_cmd = {'zk', 'new', '--no-input', '--print-path'}

    if file ~= '' then
      table.insert(zk_cmd, file)
    end

    local path = vim.fn.system(zk_cmd)
    vim.cmd({cmd = 'edit', args = {vim.trim(path)}})
  end

  vim.api.nvim_create_user_command('New', cmd_new, {nargs = '?'})

  local function cmd_goto(input)
    local title = input.args
    local zk_cmd = {
      'zk', 'list', 
      '--quiet',
      '--format', 'path',
      '--match', string.format('title: %s', title)
    }

    local paths = vim.fn.system(zk_cmd)
    paths = vim.split(paths, '\n')

    if #paths <= 1 then
      vim.notify('No results')
      return
    end

    if #paths == 2 then
      local result = vim.trim(paths[1])
      vim.cmd({cmd = 'edit', args = {result}})
      return
    end

    zk_cmd[5] = '{{title}}'
    local titles = vim.fn.system(zk_cmd)
    titles = vim.split(titles, '\n')

    titles[#titles] = nil

    vim.ui.select(titles, {prompt = 'Select item'}, function(choice, i)
      if choice == nil then
        return
      end

      local result = paths[i]

      if result == nil then
        return
      end

      vim.cmd({cmd = 'edit', args = {result}})
    end)
  end

  vim.api.nvim_create_user_command('Goto', cmd_goto, {nargs = 1})

  vim.keymap.set('n', '<leader>x', 'mt0f[lclx<esc>`t', {desc = 'Mark task as done'})
  vim.keymap.set('i', '<C-g>x', '- [ ] ', {desc = 'Create task'})
  vim.keymap.set('n', '<leader>ux', 'mt0f[lcl <esc>`t', {desc = 'Undo task mark'})
  vim.keymap.set('n', '<leader>1', '<cmd>Goto Index<cr>', {desc = 'Go to index page'})
end

function Project.worktask()
  Project.zk()
  vim.o.textwidth = 80
end

return Project

