vim.pack.add({
  'https://github.com/lewis6991/gitsigns.nvim',
})

-- Defer gitsigns setup to UIEnter to avoid git scanning at startup
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    require('gitsigns').setup {}

    local gitsigns = require 'gitsigns'

    vim.keymap.set('n', '<leader>hb', function() gitsigns.blame_line { full = true } end, { desc = 'git [b]lame line' })
    vim.keymap.set('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    vim.keymap.set('n', '<leader>hD', function() gitsigns.diffthis '@' end, { desc = 'git [D]iff against last commit' })
    vim.keymap.set('n', '<leader>hQ', function() gitsigns.setqflist 'all' end)
    vim.keymap.set('n', '<leader>hq', gitsigns.setqflist)
    -- Toggles
    vim.keymap.set('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
  end,
})
