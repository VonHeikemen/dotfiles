local augroup = vim.api.nvim_create_augroup('alpha_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd

local theme = {}
local section = {}
local action = {}

local version = vim.version()

-- Disable built-in intro message
vim.opt.shortmess:append('I')

section.header = {
  type = 'text',
  val = 'NEOVIM',
  opts = {
    position = 'center',
    hl = 'string'
  }
}

section.footer = {
  type = 'text',
  val = string.format(
    'v%s.%s.%s%s',
    version.major,
    version.minor,
    version.patch,
    version.api_prerelease and ' (Nightly)' or ''
  ),
  opts = {
    position = 'center',
    hl = 'comment'
  }
}
action.new_file = {
  name = 'New File',
  display = 'n',
  keys = 'n',
  fn = function()
    vim.cmd('enew')
  end
}

action.search_file = {
  name = 'Find File',
  display = 'f f',
  keys = 'ff',
  fn = function()
    require('telescope.builtin').find_files()
  end
}

action.recently_used = {
  name = 'History',
  display = 'h',
  keys = 'h',
  fn = function()
    require('telescope.builtin').oldfiles()
  end
}

action.explore = {
  name = 'Explore',
  display = 'e',
  keys = 'e',
  fn = function()
    require('user.functions').file_explorer(vim.fn.getcwd())
  end
}

action.restore_session = {
  name = 'Restore Session',
  display = 's',
  keys = 's',
  fn = function()
    local session = require('plugins.session')
    local name = session.read_name(vim.fn.getcwd())
    if name then
      session.load_current(name)
    else
      vim.notify('There is no session available')
    end
  end
}

action.help = {
  name = 'Get Help',
  display = 'H',
  keys = 'H',
  fn = function()
    require('telescope.builtin').help_tags()
  end
}

action.quit = {
  name = 'Quit',
  display = 'q',
  keys = 'q',
  fn = function()
    vim.cmd('quitall')
  end
}

action.execute = {
  name = 'Execute Command',
  display = 'x',
  keys = 'x',
  fn = function()
    require('fine-cmdline').open({})
  end
}

action.update_plugins = {
  name = 'Update Plugins',
  display = 'U',
  keys = 'U',
  fn = function()
    vim.cmd('PackUpdate')
  end
}

-- Add buttons
local function button(args)
  return {
    type = 'button',
    val = '➤ ' .. args.name,
    on_press = args.fn,
    opts = {
      position = 'center',
      shortcut = args.display,
      cursor = 4,
      width = 50,
      align_shortcut = 'right',
      hl_shortcut = 'number',
    },
  }
end

section.buttons = {
  type = 'group',
  opts = {spacing = 1}
}

-- very small screen
if vim.o.lines < 18 then
  section.buttons.val = {
    button(action.search_file),
    button(action.recently_used),
    button(action.explore),
  }
else
  section.buttons.val = {
    button(action.new_file),
    button(action.search_file),
    button(action.recently_used),
    button(action.explore),
    button(action.restore_session),
    button(action.quit)
  }
end

theme.layout = {
  {type = 'padding', val = 2},
  section.header,
  {type = 'padding', val = 2},
  section.buttons,
  section.footer
}

theme.opts = {}

autocmd('User', {
  pattern = 'AlphaReady',
  group = augroup,
  callback = function()
    for _, item in pairs(action) do
      vim.keymap.set(
        'n',
        item.keys,
        item.fn,
        {silent = true, buffer = true}
      )
    end

    if vim.g.terminal_color_background then
      vim.cmd('highlight UserHideChar guifg=' .. vim.g.terminal_color_background)
      vim.cmd('setlocal winhl=EndOfBuffer:UserHideChar')
    end

    vim.w.status_style = 'short'
    vim.wo.statusline = require('plugins.statusline').get_status('short')
  end
})

autocmd('User', {
  pattern = 'AlphaClosed',
  group = augroup,
  callback = function()
    vim.defer_fn(function() vim.w.status_style = 'full' end, 5)
  end
})

require('alpha').setup(theme)

