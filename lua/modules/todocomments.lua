-- Add todo-comments plugin with plenary dependency
vim.pack.add({
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/folke/todo-comments.nvim',
})

local opts = {
  signs = false, -- disable signs in sign column
}

require('todo-comments').setup(opts)
