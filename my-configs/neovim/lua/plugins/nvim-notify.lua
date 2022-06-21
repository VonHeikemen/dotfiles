vim.notify = require('notify')

vim.notify.setup({
  stages = 'slide',
  level = 'DEBUG',
  background_colour = vim.g.terminal_color_background,
  minimum_width = 15
})

