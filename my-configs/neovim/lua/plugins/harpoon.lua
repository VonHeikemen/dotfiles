local bind = vim.keymap.set

-- Toggle harpoon mark
bind('n', '<leader>m', '<cmd>lua require("harpoon.mark").add_file()<cr>')

-- Search marks
bind('n', '<F3>', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>')

-- Navigate marks
bind('n', '<leader>1', '<cmd>lua require("harpoon.ui").nav_file(1)<cr>')
bind('n', '<leader>2', '<cmd>lua require("harpoon.ui").nav_file(2)<cr>')
bind('n', '<leader>3', '<cmd>lua require("harpoon.ui").nav_file(3)<cr>')
bind('n', '<leader>4', '<cmd>lua require("harpoon.ui").nav_file(4)<cr>')

