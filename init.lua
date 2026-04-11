vim.g.mapleader = " "

local opt = vim.o

opt.number = true
opt.relativenumber = true

opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.swapfile = false
opt.backup = false
opt.guicursor = ""

opt.termguicolors = true

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})

opt.cursorline = true
vim.api.nvim_set_hl(0, "LineNr", { fg = "#555555" })
vim.api.nvim_set_hl(0, "CursorLineNr", {
  fg = "#ffffff",
  bold = true,
})

vim.api.nvim_set_hl(0, "CursorLine", { bg = "#111111" })

vim.pack.add({
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
})

require("telescope").setup({})

local builtin = require("telescope.builtin")

vim.keymap.set("n", "<leader>sf", builtin.find_files)
vim.keymap.set("n", "<C-p>", builtin.git_files)

vim.keymap.set("n", "<leader>sg", function()
  builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set("n", "grr", builtin.lsp_references, { buffer = buf, desc = "[G]oto [R]eferences" })

vim.pack.add({
  { src = "https://github.com/tpope/vim-fugitive" },
})

vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

vim.pack.add({
  {
    src = "https://github.com/nvim-treesitter/nvim-treesitter",
    config = function()
      require("nvim-treesitter.configs").setup({
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
        },
      })
    end,
  },
})

vim.keymap.set("n", "<leader>gca", function()
  vim.lsp.buf.code_action()
end, opts)
vim.keymap.set("n", "<leader>grn", function()
  vim.lsp.buf.rename()
end, opts)

vim.pack.add({
  { src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" },
})

require("blink.cmp").setup({
  keymap = { preset = "default" },
  completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
  sources = {
    providers = {
      path = {
        opts = {
          get_cwd = function(_)
            return vim.fn.getcwd()
          end,
        },
      },
    },
    default = { "lsp", "path", "snippets", "buffer" },
    fuzzy = { implementation = 'lua' },
    signature = { enabled = true }
  },
})

vim.pack.add({ { src = "https://github.com/folke/tokyonight.nvim" } })
vim.cmd("colorscheme tokyonight")

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })
require("modules")
