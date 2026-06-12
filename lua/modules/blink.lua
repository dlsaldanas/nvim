vim.pack.add({
  { src = "https://github.com/Saghen/blink.cmp", version = "v1.10.2" },
})

-- Defer blink.cmp setup to LspAttach (when completion is actually needed)
vim.api.nvim_create_autocmd('LspAttach', {
  once = true,
  callback = function()
    require("blink.cmp").setup({
      keymap = { preset = "default" },
      completion = { documentation = { auto_show = false, auto_show_delay_ms = 500 } },
      sources = {
        providers = {
          path = {
            opts = {
              get_cwd = function(context)
                return vim.fn.expand(('#%d:p:h'):format(context.bufnr)) --relative to the current buffer
              end,
            },
          },
        },
        default = { "lsp", "path", "snippets", "buffer" },
      },
      fuzzy = { implementation = 'lua' },
      signature = { enabled = true }
    })
  end,
})
