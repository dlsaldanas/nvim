vim.pack.add({
  'https://github.com/neovim/nvim-lspconfig',
})

-- servers need to be installed from system package manager
vim.lsp.enable("vtsls")
vim.lsp.enable("denols")

vim.lsp.config('lua_ls', {
  filetypes = { 'lua' },
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
      telemetry = { enable = false },
    },
  },
})

vim.lsp.enable('lua_ls')

-- LspAttach autocmd: enable completion and other features
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(ev)
    local client = assert(vim.lsp.get_client_by_id(ev.data.client_id))
    -- Enable auto-completion. Note: Use CTRL-Y to select an item. |complete_CTRL-Y|
    if client:supports_method('textDocument/completion') then
      -- Optional: trigger autocompletion on EVERY keypress. May be slow!
      -- local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
      -- client.server_capabilities.completionProvider.triggerCharacters = chars

      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end
  end,
})

-- LSP keymaps (always available)
vim.keymap.set("n", "<leader>gca", function()
  vim.lsp.buf.code_action()
end, { desc = "LSP code action" })
vim.keymap.set("n", "<leader>grn", function()
  vim.lsp.buf.rename()
end, { desc = "LSP rename" })
vim.keymap.set("n", "<leader>f", ":lua vim.lsp.buf.format()<CR>", { desc = "Format buffer" })
