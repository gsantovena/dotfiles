# Neovim plugin audit

## Scope

This document describes the **current Neovim plugin/runtime structure** after the Lua migration work.

Primary sources:
- `nvim/init.vim:6-14`
- `nvim/lua/lazy-init.lua:4-55`
- `nvim/lua/plugins/init.lua:1-10`
- `nvim/lua/plugins/navigation.lua:1-48`
- `nvim/lua/plugins/ui.lua:1-24`
- `nvim/lua/plugins/lsp.lua:1-159`
- `nvim/lua/plugins/ai.lua:1-93`
- `nvim/lua/plugins/tools.lua:1-100`
- `nvim/lua/config/options.lua:1-52`
- `nvim/lua/config/keymaps.lua:1-50`
- `nvim/lua/config/autocmds.lua:1-21`
- `nvim/lua/config/personal.lua:1-26`
- `vim/vimrc:23-27`
- `vim/vimrc.plugin_config:1-305`
- `vim/vimrc.personal:1-33`
- `vim/coc-settings.json:1-14`

## Current Neovim runtime path

1. `nvim/init.vim:6-14` is now a thin Neovim entrypoint.
2. `nvim/init.vim:10` boots `lazy.nvim` through `require('lazy-init')`.
3. `nvim/lua/lazy-init.lua:19` loads grouped specs from `nvim/lua/plugins/init.lua:1-10`.
4. General Neovim behavior is owned by Lua config modules:
   - `nvim/lua/config/options.lua:1-52`
   - `nvim/lua/config/keymaps.lua:1-50`
   - `nvim/lua/config/commands.lua:1-18`
   - `nvim/lua/config/autocmds.lua:1-21`
   - `nvim/lua/config/personal.lua:1-26`
5. Neovim no longer sources `vim/vimrc.ui`, `vim/vimrc.mappings`, `vim/vimrc.plugin_config`, or `vim/vimrc.personal` from `nvim/init.vim`.

## High-level findings

- **Neovim is now self-contained under `nvim/`.** The active runtime path is Lua-owned from `nvim/init.vim:6-14` onward.
- **Plugin specs are grouped by responsibility.** `nvim/lua/plugins/init.lua:1-10` imports `editing`, `navigation`, `git`, `ui`, `lsp`, `ai`, and `tools`.
- **The main preserved UX boundary is CoC, not legacy file structure.** CoC behavior is now colocated in `nvim/lua/plugins/lsp.lua:1-159`, while JSON settings still live in `vim/coc-settings.json:1-14`.
- **Classic Vim still has its own legacy path.** `vim/vimrc:23-27` continues to source `vimrc.plugins`, `vimrc.plugin_config`, `vimrc.ui`, `vimrc.mappings`, and `vimrc.personal`.
- **There are still plugin review opportunities, but not structural blockers.** The clearest review-later targets remain `vim-indent-guides`, `root.vim`, `tagbar`, `vim-airline`, `fzf`, and `vim-ai`.

## Current plugin ownership inventory

| Plugin | Current Neovim owner | Hooks / behavior | Recommendation | Migration risk | Notes |
|---|---|---|---|---|---|
| `nvim-lua/plenary.nvim` | dependency in `nvim/lua/plugins/editing.lua:3`, `navigation.lua:31-34`, `ai.lua:37-39`, `tools.lua:24` | dependency only | Keep | Low | Shared Lua dependency. |
| `AndrewRadev/splitjoin.vim` | `nvim/lua/plugins/editing.lua:6` | default plugin behavior | Keep | Low | No active structure problem. |
| `tpope/vim-surround` | `nvim/lua/plugins/editing.lua:7` | default mappings | Keep | Low | Stable, low-maintenance. |
| `tpope/vim-commentary` | `nvim/lua/plugins/editing.lua:8` | default mappings | Keep | Low | Stable, low-maintenance. |
| `tpope/vim-repeat` | `nvim/lua/plugins/editing.lua:9` | implicit repeat support | Keep | Low | Companion plugin. |
| `Konfekt/FastFold` | `nvim/lua/plugins/editing.lua:10` | fold behavior | Keep | Low | No current pressure to replace. |
| `nathanaelkane/vim-indent-guides` | `nvim/lua/plugins/ui.lua:10` | visual indent guides | Replace later | Low | Still a reasonable modernization target. |
| `dylanaraps/root.vim` | `nvim/lua/plugins/navigation.lua:3-9` | auto root detection | Replace later | Medium | Behavior is now colocated; replacement can be evaluated cleanly later. |
| `majutsushi/tagbar` | `nvim/lua/plugins/navigation.lua:10-21` | `Tagbar*` commands, `<F8>` | Replace later | Medium | Sidebar UX remains intact; still a candidate for a later native outline workflow. |
| `junegunn/fzf` | `nvim/lua/plugins/navigation.lua:22-25` | build/install integration | Review overlap | Low | Reevaluate alongside Telescope. |
| `nvim-telescope/telescope.nvim` | `nvim/lua/plugins/navigation.lua:28-47` | `:Telescope`, ui-select integration | Keep | Low | Modern, Lua-native. |
| `nvim-telescope/telescope-ui-select.nvim` | dependency in `nvim/lua/plugins/navigation.lua:31-34` | UI select extension | Keep | Low | Owned with Telescope. |
| `tpope/vim-fugitive` | `nvim/lua/plugins/git.lua:3-15` | `:Git`, `:Gdiffsplit`, etc. | Keep | Low | Clear command-scoped tool. |
| `vim-airline/vim-airline` | `nvim/lua/plugins/ui.lua:3-9` plus `nvim/lua/config/options.lua:51-52` | statusline/tabline | Replace later | Medium | Ownership is clearer now, but statusline layering should still be reviewed before replacement. |
| `nvim-treesitter/nvim-treesitter` | `nvim/lua/plugins/ui.lua:13-23` | syntax highlighting | Keep | Low | Modern plugin, already colocated. |
| `neoclide/coc.nvim` | `nvim/lua/plugins/lsp.lua:3-155` plus `vim/coc-settings.json:1-14` | completion, navigation, explorer, diagnostics, lists | Keep now | High | UX is preserved; future replacement should be parity-driven, not structural. |
| `github/copilot.vim` | `nvim/lua/plugins/ai.lua:3-12` | `<C-J>` accept, tab-map disable | Keep | Medium | Behavior is now fully Neovim-owned. |
| `CopilotC-Nvim/CopilotChat.nvim` | `nvim/lua/plugins/ai.lua:13-33` | `<leader>cc`, `<leader>cs` | Keep | Medium | Config and keymaps are now colocated. |
| `madox2/vim-ai` | `nvim/lua/plugins/ai.lua:34` | no explicit config found | Review overlap | Low | Likely overlapping with the rest of the AI stack. |
| `greggh/claude-code.nvim` | `nvim/lua/plugins/ai.lua:35-92` | `<C-,>`, `<leader>cC`, `<leader>cV` | Keep | Low | Modern plugin, config colocated. |
| `rizzatti/dash.vim` | `nvim/lua/plugins/tools.lua:3-10` | `:Dash*` commands | Keep | Low | Command-based utility. |
| `aquach/vim-http-client` | `nvim/lua/plugins/tools.lua:12` | filetype workflow | Keep | Low | No immediate change needed. |
| `vitapluvia/vim-gurl` | `nvim/lua/plugins/tools.lua:13-18` | `<leader>gr` | Keep | Low | Keymap is now owned alongside the plugin. |
| `skywind3000/asyncrun.vim` | `nvim/lua/plugins/tools.lua:19` | async command workflow | Keep | Low | No immediate change needed. |
| `ravitemer/mcphub.nvim` | `nvim/lua/plugins/tools.lua:22-99` | `:MCPHub` | Keep | Low | Large config now lives in the correct module. |

## Completed migration outcomes

### General Neovim config now owned in Lua
- options and statusline base: `nvim/lua/config/options.lua:1-52`
- general keymaps: `nvim/lua/config/keymaps.lua:1-50`
- user commands including `FormatJSON` and `WP`: `nvim/lua/config/commands.lua:1-18`
- reload autocmd: `nvim/lua/config/autocmds.lua:6-21`
- popup/personal helper functions: `nvim/lua/config/personal.lua:1-26`

### Plugin-owned behavior now colocated
- root detection: `nvim/lua/plugins/navigation.lua:3-9`
- Tagbar binding: `nvim/lua/plugins/navigation.lua:18-20`
- airline globals: `nvim/lua/plugins/ui.lua:3-9`
- CoC globals, mappings, commands, autocmds: `nvim/lua/plugins/lsp.lua:6-156`
- Copilot/CopilotChat bindings: `nvim/lua/plugins/ai.lua:6-31`
- Gurl keymap: `nvim/lua/plugins/tools.lua:13-18`

## Remaining Neovim-specific review targets

These are no longer structure problems; they are product/maintenance decisions:

1. **`vim-indent-guides`**
   - still an older Vim-era UI plugin in `nvim/lua/plugins/ui.lua:10`
2. **`root.vim`**
   - behavior is stable, but may be replaceable with a more native project-root approach later
3. **`tagbar`**
   - still a good candidate for a later native outline evaluation
4. **`vim-airline`**
   - now cleaner structurally, but still a possible Lua-native replacement target later
5. **`fzf` vs Telescope**
   - overlap decision still open in `nvim/lua/plugins/navigation.lua:22-47`
6. **`vim-ai`**
   - overlap with Copilot / CopilotChat / Claude Code remains unresolved

## Legacy Vim boundaries

These files still matter for classic Vim, but not for Neovim runtime:

- `vim/vimrc:23-27`
  - classic Vim entrypoint that still sources the old Vimscript config fragments
- `vim/vimrc.plugin_config:1-305`
  - legacy Vim plugin configuration
- `vim/vimrc.personal:1-33`
  - legacy Vim personal helper functions
- `vim/vimrc.plugins:1-41`
  - vim-plug manifest for classic Vim

Reference-only historical material:

- `vim/vimrc.all:1-120`
  - preserved historical snapshot; not part of the active Neovim runtime path

## Recommended next moves

If you continue polishing beyond the completed Neovim migration:

1. Reevaluate overlap plugins:
   - `fzf`
   - `vim-ai`
   - `vim-indent-guides`
2. Decide whether classic Vim support should remain first-class:
   - if yes, keep `vim/vimrc*` maintained
   - if no, archive or trim legacy Vim-only files
3. Consider reducing headless verification noise by separating plugin bootstrap/install checks from config-structure checks.
