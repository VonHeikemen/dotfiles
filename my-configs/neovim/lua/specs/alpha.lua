-- Startup screen
local Plugin = {'goolord/alpha-nvim'}

Plugin.event = 'VimEnter'

function Plugin.opts()
  local theme = {}
  local section = {}
  local action = {}
  local env = require('user.env')

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
      'v%s.%s.%s',
      version.major,
      version.minor,
      version.patch
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
    fn = '<cmd>enew<cr>'
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
    fn = '<cmd>FileExplorer!<cr>'
  }

  action.restore_session = {
    name = 'Restore Session',
    display = 's',
    keys = 's',
    fn = '<cmd>ResumeWork<cr>'
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
    fn = '<cmd>quitall<cr>'
  }

  action.execute = {
    name = 'Execute Command',
    display = 'x',
    keys = 'x',
    fn = function()
      require('fine-cmdline').open({})
    end
  }

  action.lazy_ui = {
    name = 'Open lazy.nvim UI',
    display = 'L',
    keys = 'L',
    fn = '<cmd>Lazy<cr>'
  }

  action.open_last = {
    name = 'Open last file',
    display = 'o',
    keys = 'o',
    fn = '<C-o><C-o>'
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
        cursor = 2,
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
  if vim.o.lines < env.small_screen_lines then
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

  return {theme = theme, action = action}
end

function Plugin.config(_, opts)
  local augroup = vim.api.nvim_create_augroup('alpha_cmds', {clear = true})
  local autocmd = vim.api.nvim_create_autocmd

  autocmd('User', {
    pattern = 'AlphaReady',
    group = augroup,
    callback = function()
      for _, item in pairs(opts.action) do
        vim.keymap.set(
          'n',
          item.keys,
          item.fn,
          {silent = true, buffer = true, nowait = true}
        )
      end

      if vim.g.terminal_color_background then
        vim.cmd('highlight UserHideChar guifg=' .. vim.g.terminal_color_background)
        vim.cmd('setlocal winhl=EndOfBuffer:UserHideChar')
      end
    end
  })

  autocmd('User', {
    pattern = 'AlphaClosed',
    group = augroup,
    callback = function()
      vim.defer_fn(function() vim.w.status_style = 'full' end, 5)
    end
  })

  require('alpha').setup(opts.theme)
end

return Plugin

