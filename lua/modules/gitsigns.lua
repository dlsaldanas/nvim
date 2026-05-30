vim.pack.add({
  'https://github.com/lewis6991/gitsigns.nvim',
})

-- Set up keymaps immediately (they will work once gitsigns loads)
local gitsigns = require 'gitsigns'

-- Navigation
vim.keymap.set('n', ']h', function()
  if vim.wo.diff then return ']c' end
  vim.schedule(function() gitsigns.next_hunk() end)
  return '<Ignore>'
end, { expr = true, desc = 'Next git hunk' })

vim.keymap.set('n', '[h', function()
  if vim.wo.diff then return '[c' end
  vim.schedule(function() gitsigns.prev_hunk() end)
  return '<Ignore>'
end, { expr = true, desc = 'Previous git hunk' })

-- Actions
vim.keymap.set('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
vim.keymap.set('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
vim.keymap.set('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'git [s]tage hunk' })
vim.keymap.set('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { desc = 'git [r]eset hunk' })
vim.keymap.set('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
vim.keymap.set('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
vim.keymap.set('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
vim.keymap.set('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
vim.keymap.set('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line' })
vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
vim.keymap.set('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })

-- Toggles
vim.keymap.set('n', '<leader>tb',  ':<C-U>Gitsigns blame<CR>', { desc = '[T]oggle git show [b]lame line' })
vim.keymap.set('n', '<leader>td', gitsigns.toggle_deleted, { desc = '[T]oggle git show [d]eleted' })

-- Text object
vim.keymap.set({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'git hunk text object' })

-- Defer gitsigns setup to UIEnter to avoid git scanning at startup
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    require('gitsigns').setup {
      signs = {
        add          = { text = '│' },
        change       = { text = '│' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
        untracked    = { text = '┆' },
      },
      signcolumn = true,
      numhl = false,
      linehl = false,
      word_diff = false,
      watch_gitdir = {
        follow_files = true
      },
      attach_to_untracked = true,
      current_line_blame = false,
      current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol',
        delay = 1000,
        ignore_whitespace = false,
      },
      sign_priority = 6,
      update_debounce = 100,
      status_formatter = nil,
      max_file_length = 40000,
      preview_config = {
        border = 'single',
        style = 'minimal',
        relative = 'cursor',
        row = 0,
        col = 1
      },
    }
  end,
})
