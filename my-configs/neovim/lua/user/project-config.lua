local Project = {}

function Project.legacy_php()
  vim.keymap.set('n', 'gd', "<cmd>exe 'tjump' expand('<cword>')<cr>")

  vim.cmd([[
    StlDiagnostics enable
    LintSave php php
    LintSave quick-lint-js javascript
  ]])

  local extend_cmp = function()
    local cmp = require('cmp')
    local config = {}
    config.sources = {
      {name = 'omni'},
      {name = 'tags'},
    }

    cmp.setup.filetype('php', {
      mapping = {
        ['<C-l>'] = cmp.mapping(function()
          vim.cmd('UserCmpEnable')
          cmp.complete({config = config})
        end)
      }
    })
  end

  vim.api.nvim_create_autocmd('User', {
    once = true,
    pattern = 'CmpReady',
    callback = extend_cmp,
  })
end

return Project

