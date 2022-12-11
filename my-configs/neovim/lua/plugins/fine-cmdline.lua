require('fine-cmdline').setup({
  cmdline = {
    prompt = ' '
  },
})

vim.keymap.set('n', '<CR>', ':FineCmdline<CR>')
vim.keymap.set('x', '<CR>', ":<C-u>FineCmdline '<,'><CR>")

