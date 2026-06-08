vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" }
})

-- Defer treesitter setup to VimEnter to avoid blocking startup
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.defer_fn(function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "javascript", "typescript", "lua", "html", "css", "json", "toml" },
        sync_install = false,
        auto_install = true,
        highlight = {
          enable = true,
        },
        fold = {
          enable = true,
        },
      })
    end, 100)
  end,
})

-- Enable treesitter highlighting for current buffer on FileType
vim.api.nvim_create_autocmd("FileType", {
  callback = function()
    pcall(vim.treesitter.start)
  end,
})
