local autocmd = require('bridge').augroup('plug_init')

local M = {
  skip_config = false
}

local done = false
local nofiles = vim.fn.argc() == 0

local p = {} -- still hate it
p.packpath = vim.fn.stdpath('data') .. '/site'
p.minpac_path = vim.fn.stdpath('data') .. '/site/pack/minpac/opt/minpac'

p.minpac_plugins = {}
p.lazy = {}
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

M.init = function(plugins)
  local deferred = {}
  local config_fns = {}

  for i, plug in pairs(plugins) do
    if plug.type == 'start' and type(plug.config) == 'function' then
      config_fns[plug_name(plug)] = plug.config
    end

    if plug.type == 'opt' and type(plug.config) == 'function' then
      p.configs.opts[plug_name(plug)] = plug.config
    end

    if plug.type == nil or plug.type == 'deferred' then
      table.insert(deferred, plug)
      plug.type = 'opt'
    end

    if plug.type == 'lazy' then
      table.insert(p.lazy, plug)
      plug.type = 'opt'
    end
  end

  -- setup minpac
  p.minpac_plugins = plugins
  p.setup_commands()

  local lazy_loading = defer_fn(p.load_plugins(deferred))
  p.apply_start_config(config_fns)

  -- Figure out when to load the plugins
  if nofiles then
    autocmd({'CmdlineEnter', once = true}, lazy_loading)
    autocmd({'InsertEnter', once = true}, lazy_loading)
    autocmd({'SessionLoadPost', once = true}, lazy_loading)
    return
  end

  p.packadd(p.lazy)
  autocmd('VimEnter', lazy_loading)
end

p.load_plugins = function(plugins)
  return function()
    if done then return end

    p.packadd(plugins)

    vim.cmd([[
      runtime! OPT after/plugin/*.vim 
      runtime! OPT after/plugin/*.lua 
    ]])

    if nofiles then
      p.packadd(p.lazy)
    end

    vim.cmd('doautocmd User PluginsLoaded')
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

M.apply_opt_config = function(plugin)
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
  vim.cmd([[
    command! PackManDownload lua require('plug').minpac_download()
    command! PackUpdate lua require('plug').minpac(); vim.call('minpac#update')
    command! PackClean  lua require('plug').minpac(); vim.call('minpac#clean')
    command! PackStatus lua require('plug').minpac(); vim.call('minpac#status')
    command! -nargs=1 -complete=packadd PackAdd lua require('plug').apply_opt_config(<q-args>)
  ]])
end

M.has_minpac = function()
  local empty = vim.fn.empty(vim.fn.glob(p.minpac_path)) > 0
  return not empty
end

M.minpac_download = function()
  local gitclone = '!git clone https://github.com/k-takata/minpac.git %s'
  vim.cmd(gitclone:format(p.minpac_path))
end

return M

