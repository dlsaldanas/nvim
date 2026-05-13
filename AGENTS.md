# AGENTS.md — nvim config

Personal Neovim config. Experimental, in flux.

## Plugin Manager: `vim.pack` (NOT lazy.nvim)

Built-in `vim.pack` (Neovim nightly/HEAD only). Important differences vs lazy.nvim:

- Add plugins with `vim.pack.add({ 'url', { src = 'url', version = 'tag' } })`.
- No `config = function()` callback — call `setup()` yourself after `vim.pack.add`.
- No declarative lazy-loading — defer manually with autocmds (`UIEnter`, `LspAttach`, `VimEnter`) or wrapper functions.
- Lockfile: `nvim-pack-lock.json` (do not hand-edit).
- Update plugins: `:Packupdate` (custom command, init.lua:91).

## Startup model (do not break)

Only the colorscheme and `floaterminal` load at startup. Everything else is deferred from init.lua:149-167 inside a `UIEnter` autocmd. When adding a new module:

1. Add `require("modules.<name>")` inside the `UIEnter` block in init.lua.
2. Inside the module, defer heavy `setup()` calls behind `UIEnter` / `LspAttach` / `VimEnter` or a first-use wrapper (see `telescope.lua` `ensure_telescope_ready`).
3. Keymaps can be registered eagerly; the underlying plugin setup runs later.

Stated startup budget: ~85ms. Avoid eager `setup()` calls in module top-level.

## Module layout

`init.lua` requires modules under `lua/modules/`:

| Module | Purpose | Defer trigger |
|--------|---------|---------------|
| `floaterminal` | `:Floaterminal` + `<space>tt` toggle | eager (lightweight) |
| `treesitter` | parsers, `auto_install = true`, fold expr | `VimEnter` + 100ms |
| `lsp` | `vim.lsp.enable(...)` per server | `UIEnter` (via require) |
| `telescope` | pickers + LSP refs/defs | first keypress |
| `blink` | completion (blink.cmp v1.10.2 pinned) | `LspAttach` |
| `gitsigns` | git gutter, hunk keymaps | `UIEnter` |
| `statusline` | mini.statusline (`laststatus=3`) | eager inside UIEnter block |
| `todocomments` | TODO highlights (`signs = false`) | `UIEnter` |

`fzf-lua` and `quicker.nvim` are added inline in init.lua:160-165 (also UIEnter), not as separate modules. fzf-lua and telescope coexist intentionally.

## LSP

`lua/modules/lsp.lua` enables servers via `vim.lsp.enable(...)`: `vtsls`, `denols`, `jsonls`, `zls`, `lua_ls`. **Servers must be installed via system package manager** (Homebrew etc.) — there is no Mason. To add a new server: install the binary, then add `vim.lsp.enable('<name>')` to lsp.lua. Use `vim.lsp.config('<name>', {...})` first if custom settings are needed (see `lua_ls`).

`nvim-lspconfig` is the only plugin pulled in by lsp.lua; configs are written using the new built-in `vim.lsp.config` / `vim.lsp.enable` API, not `require('lspconfig').<name>.setup`.

## Conventions

- Leader: `<Space>`. Indent: 2 spaces, expandtab.
- Colorscheme: `tokyonight-storm` with transparent overrides (`Normal`, `NormalFloat`, `SignColumn`, `VertSplit` set to `bg = "none"` in init.lua).
- Window nav `<C-h/j/k/l>` mapped in normal, insert, and terminal modes.
- Folding: treesitter expr with indent fallback; `foldlevel = 99` (open by default).
- Diagnostics: `update_in_insert = false`, `virtual_text = true`, `virtual_lines = false`.

## Custom commands & key shortcuts

| Command / map | Action | Source |
|---------------|--------|--------|
| `:W` / `:Q` | Aliases for `:w` / `:q` | init.lua:61-62 |
| `:Packupdate` | `vim.pack.update()` | init.lua:91 |
| `:Floaterminal` / `<space>tt` | Toggle floating terminal | floaterminal.lua |
| `<leader>yy` | Copy buffer relative path to `+` register | init.lua:93-104 |
| `<leader>Ex` | netrw | init.lua:57 |
| `<leader>q` | `vim.diagnostic.setqflist()` | init.lua:84 |
| `<leader>gca` / `<leader>grn` / `<leader>f` | LSP code action / rename / format | lsp.lua:77-83 |
| `<leader>sf` / `<leader>sg` / `<leader>sw` / `<leader>sr` | Telescope find / live grep / grep word / resume | telescope.lua |
| `grr` / `grd` | Telescope LSP refs / defs (warns if no LSP) | telescope.lua:29-45 |
| `]h` / `[h` | Next / prev git hunk | gitsigns.lua |
| `<leader>h*` | gitsigns hunk actions (`s/r/S/u/R/p/b/d/D`) | gitsigns.lua |

There is **no fugitive** and no `<leader>gs` / `<C-p>` mapping — older docs claiming this are stale.

## Language

- Conversation with the user: Spanish.
- Code, comments, commit messages, filenames: English.
