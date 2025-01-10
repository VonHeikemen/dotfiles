-- UI components
local Plugin = {'MunifTanjim/nui.nvim'}
local UI = {}

Plugin.user_event = {'SpecDefer'}

function Plugin.config()
  vim.ui.select = function(...)
    local select_item = UI.new_select()
    vim.ui.select = select_item
    select_item(...)
  end
  vim.ui.input = function(...)
    local input = UI.new_input()
    vim.ui.input = input
    input(...)
  end
end

function UI.input_opts()
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

function UI.select_opts()
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
        top = '[Select Item]',
        top_align = 'left',
      },
    },
    win_options = {
      winhighlight = 'Normal:Normal,FloatBorder:FloatBorder',
    },
  }
end

function UI.new_input()
  local Input = require('nui.input'):extend('VimInput')
  local input_ui = nil

  function Input:init(opts, on_done)
    local default_value = type(opts.default) == 'string'
      and opts.default
      or ''

    local popup_opts = UI.input_opts()

    if opts.prompt then
      local text = vim.trim(opts.prompt)

      if text:sub(-1) == ':' then
        text = text:sub(1, -2)
      end

      popup_opts.border.text.top = string.format('[%s]', text)
    end

    Input.super.init(self, popup_opts, {
      prompt = ' ',
      default_value = default_value,
      on_close = function()
        on_done(nil)
      end,
      on_submit = function(value)
        on_done(value)
      end
    })

    -- cancel operation if cursor leaves input
    self:on('BufLeave', function()
      on_done(nil)
    end, {once = true})

    -- cancel operation if <Esc> is pressed
    self:map('n', '<Esc>', function()
      on_done(nil)
    end, {noremap = true, nowait = true})
  end

  return function(opts, on_confirm)
    if input_ui then
      -- ensure single ui.input operation
      vim.api.nvim_err_writeln('[ui] another input is pending!')
      return
    end

    input_ui = Input(opts, function(value)
      if input_ui then
        input_ui:unmount()
      end

      on_confirm(value)

      input_ui = nil
    end)

    input_ui:mount()
  end
end

function UI.new_select()
  local Menu = require('nui.menu')
  local Select = Menu:extend('VimSelect')
  local select_ui = nil

  function Select:init(items, opts, on_done)
    local popup_opts = UI.select_opts()
    local kind = opts.kind or 'unknown'
    local format_item = opts.format_item or function(item)
      return tostring(item.__raw_item or item)
    end

    if opts.prompt then
      local text = vim.trim(opts.prompt)

      if text:sub(-1) == ':' then
        text = text:sub(1, -2)
      end

      popup_opts.border.text.top = string.format('[%s]', text)
    end

    if kind == 'codeaction' then
      -- change position for codeaction selection
      popup_opts.relative = 'cursor'
      popup_opts.position = {row = 1, col = 0}
    end

    local max_width = popup_opts.relative == 'editor' 
      and vim.o.columns - 4
      or vim.api.nvim_win_get_width(0) - 4

    local max_height = popup_opts.relative == 'editor'
      and math.floor(vim.o.lines * 80 / 100)
      or vim.api.nvim_win_get_height(0)

    local menu_items = {}
    for index, item in ipairs(items) do
      if type(item) ~= 'table' then
        item = { __raw_item = item }
      end
      item.index = index
      local item_text = string.sub(format_item(item), 0, max_width)
      menu_items[index] = Menu.item(item_text, item)
    end

    local menu_opts = {
      min_width = vim.api.nvim_strwidth(popup_opts.border.text.top),
      max_width = max_width,
      max_height = max_height,
      lines = menu_items,
      on_close = function()
        on_done(nil, nil)
      end,
      on_submit = function(item)
        on_done(item.__raw_item or item, item.index)
      end,
    }

    Select.super.init(self, popup_opts, menu_opts)

    -- cancel operation if cursor leaves select
    self:on('BufLeave', function()
      on_done(nil, nil)
    end, {once = true})
  end
  
  return function(items, opts, on_choice)
    if select_ui then
      -- ensure single ui.select operation
      vim.api.nvim_err_writeln('[ui] another select is pending!')
      return
    end

    select_ui = Select(items, opts, function(item, index)
      if select_ui then
        select_ui:unmount()
      end

      on_choice(item, index)

      select_ui = nil
    end)

    select_ui:mount()
  end
end

return Plugin

