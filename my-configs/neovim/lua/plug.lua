local autocmd = require 'bridge'.augroup 'plug_init'

local M = {}
local done = false
local nofiles = vim.fn.argc() == 0

local p = {} -- still hate it
p.minpac_plugins = {}
p.lazy = {}
p.configs = {
  lazy = {},
  start = {}
}

local defer_fn = function(fn)
  return function()
    vim.defer_fn(fn, 20)
  end
end

local plug_name = function(plug)
  local name = plug.as
  if name == nil then
    name = plug[1]:match("^[%w-]+/([%w-_.]+)$")
  end

  return name
end

M.init = function(plugins)
  local deferred = {}

  for i, plug in pairs(plugins) do
    if plug.type == nil or plug.type == 'deferred' then
      table.insert(deferred, plug)
      plug.type = 'opt'
    end

    if plug.type == 'lazy' then
      table.insert(p.lazy, plug)
      plug.type = 'opt'
    end

    if plug.type == 'start' and type(plug.config) == 'function' then
      p.configs.start[plug_name(plug)] = plug.config
    end
  end

  -- setup minpac
  p.minpac_plugins = plugins
  p.setup_commands()

  local lazy_loading = defer_fn(p.load_plugins(deferred))
  p.apply_start_config()

  -- Figure out when to load the plugins
  if nofiles then
    autocmd({'CmdlineEnter', once = true}, lazy_loading)
    autocmd({'InsertEnter', once = true}, lazy_loading)
    autocmd({'SessionLoadPost', once = true}, lazy_loading)
    return
  end

  p.packadd(p.lazy)
  autocmd('VimEnter', defer_fn(lazy_loading))
end

p.load_plugins = function(plugins)
  return function()
    if done then
      return
    end

    p.packadd(plugins)

    vim.cmd([[ runtime! OPT after/plugin/*.vim ]])

    if nofiles then
      p.packadd(p.lazy)
    end

    vim.cmd 'doautocmd User PluginsLoaded'
    done = true
  end
end

p.packadd = function(plugins)
  local cmd = ''
  local add = 'packadd %s | lua require("plug").apply_lazy_config("%s")\n'

  for i, plug in pairs(plugins) do
    local name = plug_name(plug)
    cmd = cmd .. add:format(name, name)

    if type(plug.config) == 'function' then
      p.configs.lazy[name] = plug.config
    end
  end

  vim.cmd(cmd)
end

p.apply_start_config = function()
  for i, config in pairs(p.configs.start) do
    config()
  end
end

M.apply_lazy_config = function(plugin)
  local config = p.configs.lazy[plugin]

  if type(config) == 'function' then config() end
end

M.minpac = function()
  vim.cmd [[ packadd minpac ]]
  vim.call('minpac#init', {dir = vim.fn.stdpath 'data' .. '/site'})

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
  vim.cmd [[
    command! PackManDownload lua require 'plug'.minpac_download()
    command! PackUpdate lua require 'plug'.minpac(); vim.call 'minpac#update'
    command! PackClean  lua require 'plug'.minpac(); vim.call 'minpac#clean'
    command! PackStatus lua require 'plug'.minpac(); vim.call 'minpac#status'
  ]]
end

M.minpac_download = function()
  local install_path = vim.fn.stdpath 'data' .. '/site/pack/minpac/opt/minpac'

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    local gitclone = '!git clone https://github.com/k-takata/minpac.git %s'

    vim.cmd(gitclone:format(install_path))
    p.setup_commands()
  end
end

return M

