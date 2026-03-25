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

function Project.notes()
  vim.o.path = '.,,**'
  local warn = vim.log.levels.WARN

  local get_word = function(delimeter)
    local fmt = string.format
    vim.cmd(fmt('set iskeyword+=%s', delimeter))
    local word = vim.fn.expand('<cword>')
    vim.cmd(fmt('set iskeyword-=%s', delimeter))
    return word
  end

  vim.keymap.set('n', 'K', '<cmd>GoToLink<cr>')
  vim.keymap.set('n', '<leader>1', '<cmd>find 00-index.md<cr>')

  if vim.fn.bufname() == '00-index.md' then
    vim.keymap.set('n', 'K', '<cmd>Browse<cr>', {buffer = true})
  end

  vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = '*00-index.md',
    command = 'nnoremap <buffer> K <cmd>Browse<cr>'
  })

  ---
  -- In this case a "link" is a markdown footnote, like [^1].
  -- The text of the footnote must be a valid file path.
  ---
  vim.api.nvim_create_user_command('GoToLink', function()
    local bufnr = vim.api.nvim_get_current_buf()
    local pattern = string.format('^\\V[^%s]: ', get_word('/,-,:,.'))

    local results = vim.fn.matchbufline(bufnr, pattern, 1, '$')[1]
    if results == nil then
      vim.notify('No links found', warn)
      return
    end

    local lnum = results.lnum
    local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, true)[1]
    local file = line:sub(line:find(':') + 1)

    local ok = pcall(vim.cmd, {cmd = 'find', args = {file}})
    if not ok then
      vim.notify('No file found', warn)
    end
  end, {})

  vim.api.nvim_create_user_command('Browse', function()
    local query = get_word('-,.')
    local pattern = 'find %s'

    if query:find('-') then
      query = query:sub(1, 3)
    end

    local results = vim.fn.getcompletion(pattern:format(query), 'cmdline')[1]

    if results == nil then
      vim.notify('No directory found', warn)
      return
    end

    local ok = pcall(vim.cmd, {cmd = 'find', args = {results}})
    if not ok then
      vim.notify('No file found', warn)
    end
  end, {})
end

return Project

