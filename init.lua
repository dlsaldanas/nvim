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
opt.grepprg = "rg --vimgrep" --usar rg como grep de vim
opt.autoread = true -- Auto reload files changed outside vim
opt.ignorecase = true
opt.smartcase = true

opt.cursorline = true -- Highlight the line where the cursor is on.
opt.scrolloff = 10    -- Keep this many screen lines above/below the cursor.
opt.list = true       -- Show <tab> and trailing spaces.

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s). See `:h 'confirm'`
opt.confirm = true

opt.smoothscroll = true
-- Folding configuration with treesitter fallback
local function setup_folding()
  -- Try treesitter first, fallback to indent
  local has_treesitter = pcall(require, 'nvim-treesitter')
  if has_treesitter then
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
  else
    vim.wo.foldmethod = "indent"
  end
  
  vim.o.foldlevel = 99 -- Start with all folds open
  vim.o.foldnestmax = 10 -- Max nested folds
end

-- Setup folding after UIEnter to ensure treesitter is loaded
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    vim.defer_fn(setup_folding, 200)
  end,
})
opt.cursorline = true



vim.keymap.set("n", "<leader>Ex", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})

vim.api.nvim_set_hl(0, "LineNr", { fg = "#555555" })
vim.api.nvim_set_hl(0, "CursorLineNr", {
  fg = "#ffffff",
  bold = true,
})

vim.api.nvim_set_hl(0, "CursorLine", { bg = "#111111" })

vim.diagnostic.config {
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = { min = vim.diagnostic.severity.WARN } },
  virtual_text = true,   -- Text shows up at the end of the line
  virtual_lines = false, -- Text shows up underneath the line, with virtual lines

  -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
  -- jump = { float = true },
}
-- *vim.diagnostic.setqflist()*
vim.keymap.set("n", "<leader>q", vim.diagnostic.setqflist)

vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
vim.api.nvim_set_hl(0, "VertSplit", { bg = "none" })

vim.api.nvim_create_user_command('Packupdate', function() vim.pack.update() end, {})

local function copy_relative_path()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Ruta copiada: " .. path, vim.log.levels.INFO)
end

vim.keymap.set(
  "n",
  "<leader>yy",
  copy_relative_path,
  { desc = "Copiar ruta relativa del buffer" }
)

-- Sync clipboard between OS and Neovim. Schedule the setting after `UIEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:h 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- KEYMAPS
--
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

vim.keymap.set({ 't', 'i' }, '<C-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<C-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<C-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<C-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<C-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<C-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<C-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<C-l>', '<C-w>l')

-- AUTOCOMMANDS (EVENT HANDLERS)
--
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Add the "nohlsearch" package to automatically disable search highlighting after
-- 'updatetime' and when going to insert mode.
vim.cmd('packadd! nohlsearch')

-- Load required modules first (lightweight)
require("modules.floaterminal")

-- Defer heavy modules to UIEnter
vim.api.nvim_create_autocmd('UIEnter', {
  once = true,
  callback = function()
    require("modules.treesitter")
    require("modules.lsp")
    require("modules.telescope")
    require("modules.blink")
    require("modules.gitsigns")
    require("modules.statusline")
    require("modules.todocomments")
    -- Defer fzf-lua and quicker
    vim.pack.add({
      'https://github.com/ibhagwan/fzf-lua',
      'https://github.com/stevearc/quicker.nvim',
    })
    require('fzf-lua').setup { fzf_colors = true }
    require('quicker').setup {}
  end,
})

vim.pack.add({ { src = "https://github.com/folke/tokyonight.nvim" } })
vim.cmd("colorscheme tokyonight-storm")
