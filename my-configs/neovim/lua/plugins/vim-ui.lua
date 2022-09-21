local augroup = vim.api.nvim_create_augroup('vim-ui_cmds', {clear = true})
local autocmd = vim.api.nvim_create_autocmd

local UI = {}

local function input_opts()
  return {
    relative = 'win',
    zindex = 48,
    position = {
      row = '10%',
      col = '50%',
    },
    size = {
      width = '60%'
    },
    border = {
      style = 'rounded',
      text = {
        top_align = 'left'
      }
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
  }
end

local function select_opts()
  return {
    relative = 'editor',
    zindex = 48,
    position = {
      row = '10%',
      col = '50%'
    },
    border = {
      style = 'rounded',
      highlight = 'Normal',
      text = {
        top = '[Choose an Item]',
        top_align = 'left',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
  }
end

function UI.input()
  local Input = require('nui.input')
  local event = require('nui.utils.autocmd').event

  local input_ui

  vim.ui.input = function(opts, on_confirm)
    if input_ui then
      -- ensure single ui.input operation
      vim.notify('Another input is pending!', vim.log.levels.ERROR)
      return
    end

    local on_done = function(value)
      if input_ui then
        -- if it's still mounted, unmount it
        input_ui:unmount()
      end

      -- indicate the operation is done
      input_ui = nil

      -- pass the input value
      local ok, err = pcall(on_confirm, value)

      -- report error if there is any
      if not ok then vim.notify(err, vim.log.levels.ERROR) end
    end

    local popup_opts = input_opts()

    if opts.prompt then
      popup_opts.border.text.top = string.format(' %s ', opts.prompt)
    end

    input_ui = Input(popup_opts, {
      prompt = ' ',
      default_value = opts.default,
      on_close = function() on_done(nil) end,
      on_submit = function(value) on_done(value) end,
    })

    input_ui:mount()

    -- cancel operation if cursor leaves input
    input_ui:on(event.BufLeave, function() on_done(nil) end, {once = true})

    -- cancel operation if <Esc> is pressed
    input_ui:map('n', '<Esc>', function()
      on_done(nil)
    end, {noremap = true, nowait = true})
  end
end

function UI.select()
  local Menu = require('nui.menu')
  local event = require('nui.utils.autocmd').event

  local select_ui = nil

  vim.ui.select = function(items, opts, on_choice)
    if select_ui then
      -- ensure single ui.select operation
      vim.notify('Another select is pending!', vim.log.levels.ERROR)
      return
    end

    local on_done = function(item, index)
      if select_ui then
        -- if it's still mounted, unmount it
        select_ui:unmount()
      end
      -- pass the select value
      local ok, err = pcall(on_choice, item, index)
      if not ok then vim.notify(err, vim.log.levels.ERROR) end

      -- indicate the operation is done
      select_ui = nil
    end

    local popup_opts = select_opts()

    local format_item = function(item)
      return string.format('* %s', tostring(item))
    end

    if type(opts.format_item) == 'function' then
      format_item = opts.format_item
    end

    local kind = opts.kind or 'unknown'

    if kind == 'codeaction' then
      -- change position for codeaction selection
      popup_opts.relative = 'cursor'
      popup_opts.position = {
        row = 1,
        col = 0,
      }

      format_item = function(...)
        local text = opts.format_item(...)
        return string.format('* %s', text)
      end
    end

    if opts.prompt then
      popup_opts.border.text.top = string.format(' %s ', opts.prompt)
    end

    local max_width = vim.api.nvim_win_get_width(0)
    local menu_items = {}

    for index, item in ipairs(items) do
      local data = {index = index, value = item}
      local text = string.sub(format_item(item), 0, max_width - 2)
      table.insert(menu_items, Menu.item(text, data))
    end

    select_ui = Menu(popup_opts, {
      lines = menu_items,
      min_width = popup_opts.border.text.top:len() + 2,
      on_close = function()
        on_done(nil, nil)
      end,
      on_submit = function(item)
        on_done(item.value, item.index)
      end,
    })

    select_ui:mount()

    -- cancel operation if cursor leaves select
    select_ui:on(event.BufLeave, function()
      on_done(nil, nil)
    end, { once = true })

  end
end

function UI.load()
  UI.input()
  UI.select()
end

autocmd('User', {
  pattern = 'PluginsLoaded',
  group = augroup,
  once = true,
  callback = UI.load
})

return UI

