local M = {did_setup = false}
local noop = function() end
local md = {add = noop, now = noop, later = noop}

local state = require('mini-specs.state')
M.augroup = state.augroup

function M.bootstrap()
  local config = vim.g.mini_specs
  if type(config) ~= 'table' then
    config = {}
  end

  if type(config.package_path) == 'string' then
    state.config.path.package_path = config.package_path
  end

  M.install()

  if vim.tbl_isempty(config) then
    return
  end

  M.setup(config)
end

function M.setup(opts)
  if M.did_setup then
    return
  end

  if type(opts.import_dir) == 'string'  then
    state.import_dir = opts.import_dir
  end

  if state.import_dir == '' then
    M.did_setup = true
    return
  end

  vim.go.packpath = table.concat({
    vim.env.VIMRUNTIME,
    state.config.path.package_path,
    vim.fn.stdpath('config')
  }, ',')

  local ok, deps = pcall(require, 'mini.deps')

  if not ok then
    M.did_setup = true
    return
  end

  md = deps
  deps.setup(state.config)

  M.did_setup = true
  require('mini-specs.source').scandir(state.import_dir)
end

function M.install()
  local path = vim.fs.joinpath(
    state.config.path.package_path,
    'pack',
    'deps',
    'start',
    'mini.deps'
  )

  if vim.uv.fs_stat(path) then
    return
  end

  print('Installing mini.deps....')
  vim.fn.system({
   'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/echasnovski/mini.deps',
    path,
  })

  vim.cmd('packadd mini.deps | helptags ALL')
  print('Done.')

  state.lazy_load = false
end

function M.event(events)
  local opts = {
    group = M.augroup,
    modeline = false,
  }

  if type(events) == 'string' then
    events = {events}
  end

  for _, event in pairs(events) do
    opts.pattern = event
    vim.api.nvim_exec_autocmds('User', opts)
  end
end

function M.actions()
  local items = {
    {'Update Plugins', 'SpecUpdate'},
    {'Make snapshot', 'SpecSnapshot'},
    {'Load all plugins', 'SpecLoadAll'},
    {'Plugins loaded', 'SpecShow used'},
    {'Show loaded', 'SpecShow! loaded'},
    {'Inspect session', 'SpecShow! session'},
  }

  local options = vim.tbl_map(function(i) return i[1] end, items)

  vim.ui.select(options, {prompt = 'Plugin manager'}, function(choice, i)
    if choice == nil then
      return
    end

    vim.cmd(items[i][2])
  end)
end

function M.commands()
  local command = vim.api.nvim_create_user_command

  local function load_all()
    for _, spec in ipairs(state.all_plugins) do
      md.add(spec)
    end
  end

  command('Spec', M.actions, {})

  command('SpecLoadAll', load_all, {})

  command('SpecEvent', function(input)
      M.event(input.fargs)
  end, {nargs = '*'})

  command('SpecUpdate', function()
    load_all()
    vim.cmd('DepsUpdate')
  end, {})

  command('SpecSnapshot', function()
    load_all()
    vim.cmd('DepsSnapSave')
  end, {})

  command('SpecShow', function(input)
    local param = input.args
    local show = vim.print
    if input.bang then
      show = function(a) vim.notify(vim.inspect(a)) end
    end

    if param == 'loaded' then
      show(state.loaded)
      return
    end

    if param == 'sourced' then
      for _, d in pairs(state.all_plugins) do
        show(d)
      end
      return
    end

    if param == 'session' then
      for _, d in pairs(md.get_session()) do
        show(d)
      end
      return
    end

    if param == 'used' then
      local msg = '%s plugins loaded'
      vim.notify(msg:format(#md.get_session()))
      return 
    end

    vim.print('sub-commands: "loaded" "sourced" "session" "used"')
  end, {nargs = '?', bang = true})
end

return M

