local UI = {}

local popup = {
  relative = 'win',
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
    winhighlight = 'Normal:Normal',
  },
}

UI.input = function()
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

    if opts.prompt then
      popup.border.text.top = string.format(' %s ', opts.prompt)
    end

    input_ui = Input(popup, {
      prompt = ' ',
      default_value = opts.default,
      on_close = function()
        on_done(nil)
      end,
      on_submit = function(value)
        on_done(value)
      end,
    })

    input_ui:mount()

    -- cancel operation if cursor leaves input
    input_ui:on(event.BufLeave, function()
      on_done(nil)
    end, {once = true})

    -- cancel operation if <Esc> is pressed
    input_ui:map('n', '<Esc>', function()
      on_done(nil)
    end, {noremap = true, nowait = true})
  end
end


UI.input()

return UI

