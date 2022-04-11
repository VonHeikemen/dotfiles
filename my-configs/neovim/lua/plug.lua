local autocmd = require('bridge').augroup('plug_init')
local doautocmd = require('bridge').doautocmd
local command = require('bridge').create_excmd

local M = {
  skip_config = false
}

local done = false
local nofiles = vim.fn.argc() == 0

local p = {} -- I hate it
p.packpath = vim.fn.stdpath('data') .. '/site'
p.minpac_path = vim.fn.stdpath('data') .. '/site/pack/minpac/opt/minpac'

p.minpac_plugins = {}
p.configs = {opts = {}}

local defer_fn = function(fn)
  return function()
    vim.defer_fn(fn, 20)
  end
end

local plug_name = function(plug)
  local name = plug.as
  if name == nil then
    name = plug[1]:match('^[%w-]+/([%w-_.]+)$')
  end

  return name
end

M.init = function(user_plugins)
  local plugins = {deferred = {}, lazy = {}}
  local config_fns = {}

  for i, plug in pairs(user_plugins) do
    if plug.type == 'start' and type(plug.config) == 'function' then
      config_fns[plug_name(plug)] = plug.config
    end

    if plug.type == 'opt' and type(plug.config) == 'function' then
      p.configs.opts[plug_name(plug)] = plug.config
    end

    if plug.type == nil or plug.type == 'deferred' then
      table.insert(plugins.deferred, plug)
      plug.type = 'opt'
    end

    if plug.type == 'lazy' then
      table.insert(plugins.lazy, plug)
      plug.type = 'opt'
    end
  end

  -- setup minpac
  p.minpac_plugins = user_plugins
  p.setup_commands()

  local lazy_loading = defer_fn(p.load_plugins(plugins))
  p.apply_start_config(config_fns)

  autocmd({'User', 'PluginsLoaded', once = true}, function()
    print('✔')
    vim.defer_fn(function() print(' ') end, 600)
  end)

  -- Figure out when to load the plugins
  if nofiles then
    autocmd({'VimEnter', once = true}, lazy_loading)
    autocmd({'SessionLoadPost', once = true}, lazy_loading)
    return
  end

  p.packadd(plugins.lazy)
  autocmd('VimEnter', lazy_loading)
end

p.load_plugins = function(plugins)
  return function()
    if done then return end

    p.packadd(plugins.deferred)

    vim.cmd([[
      runtime! OPT after/plugin/*.vim
      runtime! OPT after/plugin/*.lua
    ]])

    if nofiles then
      p.packadd(plugins.lazy)
    end

    doautocmd({'User', 'PluginsLoaded'})
    done = true
  end
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

  vim.cmd(add_cmd)

  if M.skip_config then
    return
  end

  for i, config in pairs(config_fns) do
    config()
  end
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
  local config = p.configs.opts[plugin]
  if type(config) == 'function' then
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

  command('PackManDownload', M.minpac_download)
  command('PackUpdate', action('minpac#update'))
  command('PackClean', action('minpac#clean'))
  command('PackStatus', action('minpac#status'))
  command({'PackAdd', nargs = 1, complete='packadd'}, M.apply_opt_config)
end

M.has_minpac = function()
  return vim.fn.isdirectory(p.minpac_path) == 1
end

M.minpac_download = function()
  local gitclone = '!git clone https://github.com/k-takata/minpac.git %s'
  vim.cmd(gitclone:format(p.minpac_path))
end

return M

