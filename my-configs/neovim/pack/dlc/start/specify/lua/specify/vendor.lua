local M = {}
local packpath = vim.fn.stdpath('data') .. '/site'

function M.manage(MiniDeps, specs, state)
  MiniDeps.setup({
    path = {
      package = packpath,
    },
  })

  vim.api.nvim_create_autocmd('FileType', {
    group = state.augroup,
    pattern = {'minideps-confirm'},
    command = 'nnoremap <buffer> q <cmd>close<cr>'
  })

  local nvim_cmd = vim.cmd
  local cmd_patch = function(c)
    if type(c) == 'string' and vim.startswith(c, 'packadd') then
      return
    end

    return nvim_cmd(c)
  end

  vim.cmd = cmd_patch
  local opts = {bang = true}
  local add = MiniDeps.add
  for _, i in ipairs(specs) do
    local spec = {source = i.src, name = i.name, checkout = i.version}
    if i.data.on_update then
      spec.hooks = {}
      speck.hooks.post_checkout = i.data.on_update
    end

    add(spec, opts)
  end

  vim.cmd = nvim_cmd
end

function M.require_deps()
  local uv = vim.uv or vim.loop

  local revision = 'v0.17.0'
  local mini_path = packpath .. '/pack/specify/start/mini.deps'

  if not uv.fs_stat(mini_path) then
    print('Installing mini.deps....')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      'https://github.com/nvim-mini/mini.deps',
      mini_path
    })

    local switch_cmd = {'git', 'switch', '--detach', revision}
    local job_opts = {cwd = mini_path}
    vim.fn.jobwait({vim.fn.jobstart(switch_cmd, job_opts)})

    vim.cmd('packadd mini.deps | helptags ALL')
  end

  local ok, deps = pcall(require, 'mini.deps')
  if not ok then
    return {}
  end

  return deps
end

function M.actions()
  local items = {
    {'Update Plugins', 'SpecUpdate'},
    {'Make snapshot', 'SpecSnapshot'},
    {'Restore from snapshot', 'SpecRestore'},
    {'Show update logs', 'SpecLog'},
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

  command('Spec', M.actions, {})

  command('SpecUpdate', function()
    require('mini.deps').update()
  end, {})

  command('SpecSnapshot', function()
    require('mini.deps').snap_save()
  end, {})

  command('SpecRestore', function()
    require('mini.deps').snap_load()
  end, {})

  command('SpecEvent', function(input)
    require('specify').event(input.fargs)
  end, {nargs = '*'})

  command('SpecLog', 'DepsShowLog', {})

  command('SpecShow', function(input)
    local param = input.args
    local show = vim.print
    if input.bang then
      show = function(a) vim.notify(vim.inspect(a)) end
    end

    if param == 'loaded' then
      show(require('specify.state').loaded_plugins)
      return
    end

    if param == 'session' then
      for _, d in pairs(require('mini.deps').get_session()) do
        show(d)
      end
      return
    end

    vim.print('sub-commands: "loaded" "session"')
  end, {nargs = '?', bang = true})
end

return M

