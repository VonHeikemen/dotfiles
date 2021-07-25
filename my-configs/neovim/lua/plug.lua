local autocmd = require 'bridge'.augroup 'plug_init'

local M = {}
local done = false
local nofiles = vim.fn.argc() == 0

local p = {} -- I hate it less now
p.minpac_plugins = {}
p.not_loaded = {}
p.lazy = {}

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
  end

  -- setup minpac
  p.minpac_plugins = plugins
  p.setup_commands()

  local load_deferred = p.load_plugins(deferred)

  -- Figure out when to load the plugins
  if nofiles then
    local lazy_loading = defer_fn(load_deferred)

    autocmd({'CmdlineEnter', once = true}, lazy_loading)
    autocmd({'InsertEnter', once = true}, lazy_loading)
    autocmd({'SessionLoadPost', once = true}, lazy_loading)
    return
  end

  p.load_lazy()
  autocmd('VimEnter', defer_fn(load_deferred))
end

p.load_plugins = function(plugins)
  return function()
    if done then
      return
    end

    local cmd = ''
    local add = 'packadd %s\n'
    for i, plug in pairs(plugins) do
      cmd = cmd .. add:format(plug_name(plug))
    end

    cmd = cmd .. [[
      runtime! OPT after/plugin/*.vim
    ]]

    vim.cmd(cmd)

    if nofiles then
      p.load_lazy()
    end

    p.config_plugins()
    done = true
  end
end

p.load_lazy = function()
  local cmd = ''
  local add = 'packadd %s\n'

  for i, plug in pairs(p.lazy) do
    cmd = cmd .. add:format(plug_name(plug))
  end

  vim.cmd(cmd)
end

p.config_plugins = function()
  local success = {}

  for m, config in pairs(p.not_loaded) do
    local status, lib = pcall(require, m)
    if status then
      config(lib)
      success[m] = m
    end
  end

  for m in pairs(success) do
    p.not_loaded[m] = nil
  end
end

M.load_module = function(module, fn)
  local status, lib = pcall(require, module)

  if not status then
    p.not_loaded[module] = fn
    return
  end

  return fn(lib)
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

