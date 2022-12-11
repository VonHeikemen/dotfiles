local bind = vim.keymap.set
local remap = {remap = true}

bind('n', 'cvv', 'ax<Esc><plug>SystemPastel', remap)
bind('n', 'cvk', 'Ox<Esc><Plug>SystemPastel', remap)
bind('n', 'cvj', 'ox<Esc><Plug>SystemPastel', remap)

