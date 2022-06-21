require('searchbox').setup({
  hooks = {
    on_done = function(value)
      if value == nil then return end
      vim.fn.setreg('s', value)
    end
  }
})

