local autocmd = require 'conf.functions'.autocmd

local M = {}
local p = {} -- I hate this

local not_loaded = {}
local done = false

M.init_plugins = function(plugins)
  local deferred = {}
  for i, plug in pairs(plugins) do
    if plug.type == nil or plug.type == 'deferred' then
      table.insert(deferred, plug)
    end

    plug.opt = plug.type ~= 'start'
    plug.type = nil
  end

  -- Do we even have paq installed?
  local status, paq = pcall(require, 'paq')

  if not status then
    print('paq-nvim is not loaded. Use the command PaqDownload to clone it from github')
    return
  end

  -- let paq know about the plugins
  paq(plugins)

  -- Thing that actually loads plugins
  local lazy_loading = function()
    vim.defer_fn(p.load_plugins(deferred), 50)
  end

  -- Figure out when to load the plugins
  if vim.fn.argc() == 0 then
    autocmd({'CmdlineEnter', once = true}, lazy_loading)
    autocmd({'InsertEnter', once = true}, lazy_loading)
  else
    autocmd('VimEnter', lazy_loading)
  end
end

p.load_plugins = function(plugins)
  return function()
    if done then
      return
    end

    local cmd = ''
    local add = 'packadd %s\n'
    for i, plug in pairs(plugins) do
      local name = plug.as
      if name == nil then
        name = plug[1]:match("^[%w-]+/([%w-_.]+)$")
      end

      cmd = cmd .. add:format(name)
    end

    cmd = cmd .. [[
      runtime OPT ftdetect/*.vim
      runtime OPT after/ftdetect/*.vim
      runtime OPT after/plugin/*.vim
    ]]

    vim.cmd(cmd)

    p.config_plugins()
    done = true
  end
end

p.config_plugins = function()
  local success = {}

  for m, config in pairs(not_loaded) do
    local status, lib = pcall(require, m)
    if status then
      config(lib)
      success[m] = m
    end
  end

  for m in pairs(success) do
    not_loaded[m] = nil
  end
end


M.load_module = function(module, fn)
  local status, lib = pcall(require, module)

  if not status then
    not_loaded[module] = fn
    return
  end

  return fn(lib)
end

M.paq_download = function()
  local install_path = vim.fn.stdpath 'data' .. '/site/pack/paqs/start/paq-nvim'

  if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    local gitclone = '!git clone https://github.com/savq/paq-nvim.git %s'

    vim.cmd(gitclone:format(install_path))
    vim.cmd 'packadd paq-nvim'
  end
end

return M

