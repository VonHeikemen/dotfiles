-- Navigate quickly between files
local Plugin = {'ThePrimeagen/harpoon'}

Plugin.keys = {
  -- Toggle harpoon mark
  {'<leader>m', '<cmd>lua require("harpoon.mark").add_file()<cr>'},

  -- Search marks
  {'<F3>', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>'},

  -- Navigate marks
  {'<M-1>', '<cmd>lua require("harpoon.ui").nav_file(1)<cr>'},
  {'<M-2>', '<cmd>lua require("harpoon.ui").nav_file(2)<cr>'},
  {'<M-3>', '<cmd>lua require("harpoon.ui").nav_file(3)<cr>'},
  {'<M-4>', '<cmd>lua require("harpoon.ui").nav_file(4)<cr>'},
}

return Plugin

