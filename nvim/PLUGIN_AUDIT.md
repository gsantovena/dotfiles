# Neovim plugin audit

## Scope

This document describes the **current Neovim-only plugin/runtime structure**.

Primary sources:
- `nvim/init.vim:6-14`
- `nvim/coc-settings.json:1-14`
- `nvim/lua/lazy-init.lua:4-55`
- `nvim/lua/plugins/init.lua:1-10`
- `nvim/lua/plugins/navigation.lua:1-48`
- `nvim/lua/plugins/ui.lua:1-24`
- `nvim/lua/plugins/lsp.lua:1-149`
- `nvim/lua/plugins/ai.lua:1-93`
- `nvim/lua/plugins/tools.lua:1-100`
- `nvim/lua/config/options.lua:1-51`
- `nvim/lua/config/keymaps.lua:1-50`
- `nvim/lua/config/commands.lua:1-18`
- `nvim/lua/config/autocmds.lua:1-21`
- `nvim/lua/config/personal.lua:1-26`

## Current runtime path

1. `nvim/init.vim:6-14` is a thin Neovim entrypoint.
2. `nvim/init.vim:10` boots `lazy.nvim` through `require('lazy-init')`.
3. `nvim/lua/lazy-init.lua:19` loads grouped specs from `nvim/lua/plugins/init.lua:1-10`.
4. General Neovim behavior is owned by Lua config modules:
   - `nvim/lua/config/options.lua`
   - `nvim/lua/config/keymaps.lua`
   - `nvim/lua/config/commands.lua`
   - `nvim/lua/config/autocmds.lua`
   - `nvim/lua/config/personal.lua`
5. CoC JSON settings live in `nvim/coc-settings.json:1-14`.

## High-level findings

- **Neovim is self-contained under `nvim/`.**
- **Plugin specs are grouped by responsibility.**
- **The main preserved UX boundary is CoC, not legacy file structure.**
- **The old classic Vim compatibility tree has been removed from the active repo layout.**
- **The remaining cleanup opportunities are plugin/product decisions, not structural ownership problems.**

## Current plugin ownership inventory

| Plugin | Current Neovim owner | Hooks / behavior | Recommendation | Migration risk | Notes |
|---|---|---|---|---|---|
| `nvim-lua/plenary.nvim` | dependency in grouped plugin modules | dependency only | Keep | Low | Shared Lua dependency. |
| `AndrewRadev/splitjoin.vim` | `nvim/lua/plugins/editing.lua` | default plugin behavior | Keep | Low | No active structure problem. |
| `tpope/vim-surround` | `nvim/lua/plugins/editing.lua` | default mappings | Keep | Low | Stable, low-maintenance. |
| `tpope/vim-commentary` | `nvim/lua/plugins/editing.lua` | default mappings | Keep | Low | Stable, low-maintenance. |
| `tpope/vim-repeat` | `nvim/lua/plugins/editing.lua` | implicit repeat support | Keep | Low | Companion plugin. |
| `Konfekt/FastFold` | `nvim/lua/plugins/editing.lua` | fold behavior | Keep | Low | No current pressure to replace. |
| `lukas-reineke/indent-blankline.nvim` | `nvim/lua/plugins/ui.lua` | visual indent guides | Keep | Low | Lua-native indent guide plugin using the `ibl` entrypoint. |
| native root detection | `nvim/lua/config/project-root.lua` | project root detection via `vim.fs.root()` | Keep | Low | Plugin removed; behavior is handled with built-in Neovim APIs. |
| `stevearc/aerial.nvim` | `nvim/lua/plugins/navigation.lua` | `Aerial*` commands, `<F8>` | Keep | Medium | Modern outline workflow with the familiar toggle key preserved. |
| `nvim-telescope/telescope.nvim` | `nvim/lua/plugins/navigation.lua` | `:Telescope`, ui-select integration | Keep | Low | Modern, Lua-native. |
| `nvim-telescope/telescope-ui-select.nvim` | dependency in `navigation.lua` | UI select extension | Keep | Low | Owned with Telescope. |
| `tpope/vim-fugitive` | `nvim/lua/plugins/git.lua` | `:Git`, `:Gdiffsplit`, etc. | Keep | Low | Clear command-scoped tool. |
| `nvim-lualine/lualine.nvim` | `nvim/lua/plugins/ui.lua` | statusline/tabline | Keep | Low | Lua-native statusline/tabline using an evil_lualine-inspired layout. |
| `nvim-treesitter/nvim-treesitter` | `nvim/lua/plugins/ui.lua` | syntax highlighting | Keep | Low | Modern plugin, already colocated. |
| `neoclide/coc.nvim` | `nvim/lua/plugins/lsp.lua` plus `nvim/coc-settings.json` | completion, navigation, explorer, diagnostics, lists | Keep now | High | UX is preserved; future replacement should be parity-driven. |
| `github/copilot.vim` | `nvim/lua/plugins/ai.lua` | `<C-J>` accept, tab-map disable | Keep | Medium | Config and mapping are active and colocated. |
| `CopilotC-Nvim/CopilotChat.nvim` | `nvim/lua/plugins/ai.lua` | `<leader>cc`, `<leader>cs` | Keep | Medium | Config and keymaps are colocated. |
| `greggh/claude-code.nvim` | `nvim/lua/plugins/ai.lua` | `<C-,>`, `<leader>cC`, `<leader>cV` | Keep | Low | Modern plugin, config colocated. |
| `rizzatti/dash.vim` | `nvim/lua/plugins/tools.lua` | `:Dash*` commands | Keep | Low | Command-based utility. |
| `aquach/vim-http-client` | `nvim/lua/plugins/tools.lua` | filetype workflow | Keep | Low | No immediate change needed. |
| `vitapluvia/vim-gurl` | `nvim/lua/plugins/tools.lua` | `<leader>gr` | Keep | Low | Keymap is colocated with the plugin. |
| `skywind3000/asyncrun.vim` | `nvim/lua/plugins/tools.lua` | async command workflow | Keep | Low | No immediate change needed. |
| `ravitemer/mcphub.nvim` | `nvim/lua/plugins/tools.lua` | `:MCPHub` | Keep | Low | Large config now lives in the correct module. |

## Completed migration outcomes

### General Neovim config owned in Lua
- options and editor defaults: `nvim/lua/config/options.lua`
- general keymaps: `nvim/lua/config/keymaps.lua`
- user commands including `FormatJSON` and `WP`: `nvim/lua/config/commands.lua`
- reload autocmd: `nvim/lua/config/autocmds.lua`
- popup/personal helpers: `nvim/lua/config/personal.lua`

### Plugin-owned behavior colocated
- root detection: `nvim/lua/config/project-root.lua`
- Aerial outline binding: `nvim/lua/plugins/navigation.lua`
- lualine statusline/tabline config: `nvim/lua/plugins/ui.lua`
- CoC globals, mappings, commands, and autocmds: `nvim/lua/plugins/lsp.lua`
- Copilot/CopilotChat bindings: `nvim/lua/plugins/ai.lua`
- Gurl keymap: `nvim/lua/plugins/tools.lua`

## Remaining review targets

These are product/maintenance decisions, not structural problems:

1. Telescope overlap/extensions strategy
2. CoC replacement only when a parity-first migration plan exists

## Recommended next moves

1. Consider a later replacement plan for:
   - eventually CoC, only if parity is documented first
2. Reduce headless verification noise by separating plugin bootstrap/install checks from config-structure checks.
