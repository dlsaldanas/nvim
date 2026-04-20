vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
})

local builtin = require("telescope.builtin")

-- Defer telescope setup to first use
local telescope_setup_done = false
local function ensure_telescope_ready()
  if not telescope_setup_done then
    require("telescope").setup({})
    pcall(require('telescope').load_extension, 'fzf')
    telescope_setup_done = true
  end
end

vim.keymap.set("n", "<leader>sf", function()
  ensure_telescope_ready()
  builtin.find_files()
end, { desc = "Find files" })

vim.keymap.set("n", "<leader>sg", function()
  ensure_telescope_ready()
  vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
end, { desc = "Grep string" })

-- LSP keymaps with LSP client check
vim.keymap.set("n", "grr", function()
  if not vim.lsp.get_clients({ bufnr = 0 })[1] then
    vim.notify("No LSP client attached", vim.log.levels.WARN)
    return
  end
  ensure_telescope_ready()
  builtin.lsp_references()
end, { desc = "[G]oto [R]eferences" })

vim.keymap.set('n', 'grd', function()
  if not vim.lsp.get_clients({ bufnr = 0 })[1] then
    vim.notify("No LSP client attached", vim.log.levels.WARN)
    return
  end
  ensure_telescope_ready()
  builtin.lsp_definitions()
end, { desc = '[G]oto [D]efinition' })

vim.keymap.set('n', '<leader>sr', function()
  if not vim.lsp.get_clients({ bufnr = 0 })[1] then
    vim.notify("No LSP client attached", vim.log.levels.WARN)
    return
  end
  ensure_telescope_ready()
  builtin.resume()
end, { desc = '[S]earch [R]esume' })

vim.keymap.set({ 'n', 'v' }, '<leader>sw', function()
  if not vim.lsp.get_clients({ bufnr = 0 })[1] then
    vim.notify("No LSP client attached", vim.log.levels.WARN)
    return
  end
  ensure_telescope_ready()
  builtin.grep_string()
end, { desc = '[S]earch current [W]ord' })
