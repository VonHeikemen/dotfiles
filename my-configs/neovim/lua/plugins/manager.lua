local augroup = vim.api.nvim_create_augroup('plug_init', {clear = true})
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command
local doautocmd = vim.api.nvim_exec_autocmds

local done = false

local M = {
  skip_config = false
}

local p = {
  packpath = vim.fn.stdpath('data') .. '/site',
  minpac_path = vim.fn.stdpath('data') .. '/site/pack/minpac/opt/minpac',
  minpac_plugins = {},
  opt_config = {},
  hasfiles = vim.fn.argc() > 0,
}

local plug_name = function(plug)
  local name = plug.as
  if name == nil then
    name = plug[1]:match('^[%w-]+/([%w-_.]+)$')
  end

  return name
end

M.init = function(user_plugins)
  local start_config = {}
  local deferred = {}

  for i, plug in pairs(user_plugins) do
    if plug.type == 'start' and type(plug.config) == 'function' then
      start_config[plug_name(plug)] = plug.config
    end

    if plug.type == 'opt' and type(plug.config) == 'function' then
      p.opt_config[plug_name(plug)] = plug.config
    end

    if plug.type == nil then
      table.insert(deferred, plug)
      plug.type = 'opt'
    end
  end

  p.minpac_plugins = user_plugins
  p.setup_commands()
  p.apply_start_config(start_config)

  local arg = vim.v.argv[2] or ''
  local starts_with_command = arg == '-S'
    or arg == '-c'
    or vim.startswith(arg, '+')

  if p.hasfiles or starts_with_command then
    p.load_plugins(deferred, true)
    return
  end

  -- wait for startup screen
  autocmd('User', {
    pattern = 'AlphaReady',
    group = augroup,
    callback = function()
      vim.defer_fn(function() p.load_plugins(deferred, false) end, 10)
    end
  })
end

p.apply_start_config = function(fns)
  if M.skip_config then return end

  for i, config in pairs(fns) do
    config()
  end
end

M.apply_opt_config = function(input)
  local plugin = input.args
  vim.cmd('packadd ' .. plugin)

  local config = p.opt_config[plugin]
  if type(config) == 'function' then
    config()
  end
end

p.load_plugins = function(plugins, startup)
  if done then return end

  p.packadd(plugins)

  if startup == false then
    vim.cmd([[
      runtime! OPT after/plugin/*.vim
      runtime! OPT after/plugin/*.lua
    ]])
  end

  doautocmd('User', {pattern = 'PluginsLoaded'})
  done = true
end

p.packadd = function(plugins)
  local add = 'packadd %s\n'
  local add_cmd = ''
  local config_fns = {}

  for i, plug in pairs(plugins) do
    local name = plug_name(plug)
    add_cmd = add_cmd .. add:format(name)

    if type(plug.config) == 'function' then
      config_fns[name] = plug.config
    end
  end

  if M.skip_config then
    return
  end

  vim.cmd(add_cmd)

  for i, config in pairs(config_fns) do
    config()
  end
end

M.minpac = function()
  vim.cmd('packadd minpac')
  vim.call('minpac#init', {dir = p.packpath})

  for i, plug in pairs(p.minpac_plugins) do
    local opts = {}
    for i, v in pairs(plug) do
      if type(i) == 'string' then opts[i] = v end
    end

    opts['do'] = opts.run
    opts.run = nil
    opts.config = nil
    vim.call('minpac#add', plug[1], opts)
  end
end

p.setup_commands = function()
  local action = function(minpac_fn)
    return function() M.minpac(); vim.call(minpac_fn) end
  end

  command('PackManDownload', M.minpac_download, {})
  command('PackUpdate', action('minpac#update'), {})
  command('PackClean', action('minpac#clean'), {})
  command('PackStatus', action('minpac#status'), {})
  command('PackAdd', M.apply_opt_config, {nargs = 1, complete='packadd'})
end

M.has_minpac = function()
  return vim.fn.isdirectory(p.minpac_path) == 1
end

M.minpac_download = function()
  local gitclone = '!git clone https://github.com/k-takata/minpac.git %s'
  vim.cmd(gitclone:format(p.minpac_path))
end

return M

