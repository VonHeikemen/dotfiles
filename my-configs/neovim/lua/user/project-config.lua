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

  local get_label = function(bufnr)
    local curpos = vim.fn.getcurpos()
    local line = curpos[2]

    local ob = vim.fn.searchpos('\\V[', 'bn', line)
    if ob[1] == 0 then
      -- opening bracket not found
      return
    end

    local cb = vim.fn.searchpos('\\V]', 'n', line)
    if cb[1] == 0 or curpos[3] > cb[2] then
      -- closing bracket not found or was found before the cursor
      return
    end

    local label_cb = vim.fn.searchpos('\\v(.{-}\\zs]){2}', 'n', line)
    if label_cb[1] == 0 then
      -- reference closing bracket was not found
      return
    end

    line = line - 1
    local start = cb[2]
    local ends = label_cb[2]
    return vim.api.nvim_buf_get_text(bufnr, line, start, line, ends, {})[1]
  end

  local get_content = function()
    local query = ''
    local cword = get_word('.,-,^')
    local bufnr = vim.api.nvim_get_current_buf()

    if cword:sub(1, 1) == '^' then
      query = string.format('[%s]', cword)
    else
      query = get_label(bufnr) or ''
    end

    if query == '' then
      return
    end

    local pattern = string.format([[\V\^%s:\s\*]], query)
    local results = vim.fn.matchbufline(bufnr, pattern, 1, '$')[1]

    if results == nil then
      vim.notify('No links found', warn)
      return
    end

    local lnum = results.lnum
    local line = vim.api.nvim_buf_get_lines(bufnr, lnum - 1, lnum, true)[1]
    -- local idx = line:find(']:') + 3

    return line, results.lnum
  end

  vim.keymap.set('n', 'K', '<cmd>GoToLink<cr>')
  vim.keymap.set('n', '<leader>1', '<cmd>find 00-index.md<cr>')

  vim.keymap.set('n', 'gl', function()
    local query = get_word('/,-,:,.')
    local ok = pcall(vim.cmd, {cmd = 'find', args = {query}})
    if not ok then
      vim.notify('No file found', warn)
    end
  end)

  vim.keymap.set('n', 'gx', function()
    local line = get_content()
    if line == nil then
      return
    end

    local idx = line:find(']:') + 3
    local content = vim.trim(line:sub(idx))

    if content == '' then
      return
    end

    vim.fn.setreg('+', content)
    vim.notify('Content copied to clipboard')
  end)

  if vim.fn.bufname() == '00-index.md' then
    vim.keymap.set('n', 'K', '<cmd>Browse<cr>', {buffer = true})
  end

  vim.api.nvim_create_autocmd('BufReadPost', {
    pattern = '*00-index.md',
    command = 'nnoremap <buffer> K <cmd>Browse<cr>'
  })

  ---
  -- Jump to the "content" of a reference-style link or footnote.
  -- Example: this is [a link][01] and this is a [^footnote]
  --
  -- [01]: #link-content
  -- [^footnote]: footnote content
  --
  -- If the content begins with an @ character, treat it like a filename.
  -- Use the `find` command to open the file.
  ---
  vim.api.nvim_create_user_command('GoToLink', function()
    local line, lnum = get_content()
    if line == nil then
      return
    end

    local idx = line:find(']:') + 3

    if line:sub(idx, idx) == '@' then
      local file = line:sub(idx + 1)
      local ok = pcall(vim.cmd, {cmd = 'find', args = {file}})
      if not ok then
        vim.notify('No file found', warn)
      end
      return
    end

    vim.cmd("normal! m'")
    vim.api.nvim_win_set_cursor(0, {lnum, 1})
  end, {})

  vim.api.nvim_create_user_command('Browse', function()
    local line = vim.trim(vim.fn.getline('.'))
    local kind = line:sub(3, 3)
    local id, name

    if kind == '.' then
      -- ID/Content
      id = line:sub(1, 5)
      name = line:sub(7)
    elseif kind == ' ' then
      -- Category
      id = line:sub(1, 2)
      name = line:sub(4)
    elseif kind == '-' then
      -- Area
      id = line:sub(1, 2)
      name = line:sub(7)
    else
      return
    end

    local pattern = 'find %s'
    local query = string.format('%s-%s', id, name:gsub(' ', '-'):lower())  
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

