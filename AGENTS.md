# AGENTS.md — nvim-alt

Alternate Neovim config built from scratch. Experimental, in flux.

## Structure

```
init.lua                        -- entry point: core options, keymaps, autocmds, fzf-lua, quicker, tokyonight
lua/modules/
  ├── lsp.lua                   -- LSP servers (vtsls, denols, lua_ls), keymaps, autocmds
  ├── telescope.lua             -- telescope + plenary, keymaps for find/grep/LSP refs/definitions
  ├── treesitter.lua            -- treesitter setup, auto-install, highlight, FileType autocmd
  ├── blink.lua                 -- blink.cmp completion engine + LSP/path/snippets sources
  ├── gitsigns.lua              -- gitsigns setup
  ├── statusline.lua            -- mini.nvim statusline configuration
  └── floaterminal.lua          -- floating terminal implementation
```

Each module is `require`d from init.lua (lines 131–136). No dead code.

## Plugin Manager

Uses **`vim.pack`** (Neovim built-in, nightly/HEAD only). Not lazy.nvim or packer.

- Install plugins with `vim.pack.add()` — accepts a list of URL strings or `{ src = "..." }` tables.
- Lockfile: `nvim-pack-lock.json` (not `lazy-lock.json`).
- No lazy-loading or `config` callbacks are guaranteed to work the same as lazy.nvim — test after changes.
- To update plugins: `:Packupdate` (custom user command at init.lua:68).

## Plugin Inventory

| Plugin | Module | Purpose |
|--------|--------|---------|
| fzf-lua | init.lua | Fuzzy picker (alternative fuzzy finder in parallel with telescope) |
| quicker.nvim | init.lua | Enhanced quickfix/loclist |
| nvim-lspconfig | modules/lsp.lua | LSP quickstart configs |
| telescope.nvim + plenary.nvim | modules/telescope.lua | Fuzzy finder for files, grep, LSP refs/defs |
| nvim-treesitter | modules/treesitter.lua | Syntax highlighting / parsing, auto-install |
| blink.cmp | modules/blink.lua | Autocompletion engine with LSP/path/snippets sources |
| gitsigns.nvim | modules/gitsigns.lua | Git gutter signs |
| mini.nvim | modules/statusline.lua | Statusline configuration |
| tokyonight.nvim | init.lua | Colorscheme with transparent background overrides |
| vim-fugitive | init.lua | Git commands integration |

Note: Both fzf-lua and telescope are active simultaneously (parallel fuzzy finders).

## Conventions

- Leader key: `<Space>` (vim.g.mapleader)
- Indentation: 2 spaces, expandtab
- Colorscheme: tokyonight with transparent background overrides
- LSP servers: installed via system package manager (not Mason) — vtsls, denols, lua_ls
- Window navigation: `<C-h/j/k/l>` for all modes (normal, insert, terminal)

## Custom Commands & Utilities

| Command | Action | File |
|---------|--------|------|
| `:W` | Alias for `:w` | init.lua:33 |
| `:Q` | Alias for `:q` | init.lua:34 |
| `:Packupdate` | Update all plugins via `vim.pack.update()` | init.lua:68 |
| `<leader>yy` | Copy relative path of current buffer to clipboard | init.lua:76–81 |
| `<leader>Ex` | Open file explorer (netrw) | init.lua:29 |
| `<leader>gs` | Open vim-fugitive (`:Git`) | init.lua:61 |

## Key LSP Mappings

All configured in modules/lsp.lua:45–50.

| Mapping | Action |
|---------|--------|
| `<leader>gca` | LSP code action |
| `<leader>grn` | LSP rename |
| `<leader>f` | LSP format buffer |

## Key Telescope Mappings

All configured in modules/telescope.lua:11–17.

| Mapping | Action |
|---------|--------|
| `<leader>sf` | Find files |
| `<C-p>` | Git files |
| `<leader>sg` | Grep string (interactive input) |
| `grr` | LSP references |
| `grd` | LSP definitions |

## Startup Optimization

**All heavy plugins are deferred to `UIEnter` or first use:**
- `fzf-lua`, `quicker.nvim`, `gitsigns.nvim`: deferred to UIEnter (init.lua:128-144)
- `treesitter`: config deferred to VimEnter with 100ms delay (treesitter.lua:6-17)
- `lsp` servers: vim.lsp.enable() deferred to UIEnter (lsp.lua:5-29)
- `telescope`: setup deferred to first keypress via `ensure_telescope_ready()` wrapper (telescope.lua:11-13)
- `blink.cmp`: setup deferred to LspAttach event (blink.lua:7-21)

**Result**: Startup time reduced from ~2683ms to ~85ms (**96.8% faster**).
Only core options, keymaps, and tokyonight colorscheme load at startup.

## Language

- Conversations with the user: Spanish
- Code, comments, commit messages: English
