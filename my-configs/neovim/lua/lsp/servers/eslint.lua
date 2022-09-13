local config = require('lsp.config')
local cwd = vim.fn.getcwd()

local server = config.make({
  cmd = {'vscode-eslint-language-server', '--stdio'},
  name = 'eslint',
  filetypes = {
    'javascript',
    'javascriptreact',
    'javascript.jsx',
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'vue'
  },
  settings = {
    -- required
    validate = 'on',
    rulesCustomizations = {},
    nodePath = '',
    workspaceFolder = {
      uri = vim.uri_from_fname(cwd),
      name = cwd,
    },

    -- optional
    packageManager = 'npm',
    useESLintClass = false,
    codeActionOnSave = {
      enable = false,
      mode = 'all',
    },
    format = false,
    quiet = false,
    onIgnoredFiles = 'off',
    run = 'onType',
    workingDirectory = {mode = 'location'},
    codeAction = {
      disableRuleComment = {
        enable = true,
        location = 'separateLine',
      },
    },
  },
  handlers = {
    ['eslint/confirmESLintExecution'] = function(_, result)
      if not result then
        return
      end
      return 4 -- approved
    end,
    ['eslint/probeFailed'] = function()
      vim.notify('[lsp] ESLint probe failed.', vim.log.levels.WARN)
      return {}
    end,
    ['eslint/noLibrary'] = function()
      vim.notify('[lsp] Unable to find ESLint library.', vim.log.levels.WARN)
      return {}
    end,
  }
})

return server

