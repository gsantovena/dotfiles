# Neovim plugin reevaluation

## Scope

This document records the plugin reevaluation decisions that shaped the current
Neovim-only setup. It classifies plugins into:
- keep
- removed
- replaced
- revisit later

It is based on:
- current repo usage and keymaps under `nvim/lua/plugins/*`
- current test expectations in `tests/test_dotfiles.bats`
- primary-source plugin/documentation review for replacement candidates

## Current conclusion summary

### Keep
- `coc.nvim`
- `telescope.nvim`
- `telescope-ui-select.nvim`
- `copilot.vim`
- `CopilotChat.nvim`
- `claude-code.nvim`
- `mcphub.nvim`
- `vim-fugitive`
- `vim-surround`
- `vim-commentary`
- `vim-repeat`
- `splitjoin.vim`
- `FastFold`
- `dash.vim`
- `vim-http-client`
- `vim-gurl`
- `asyncrun.vim`
- `nvim-treesitter`

### Removed
- `junegunn/fzf`
- `madox2/vim-ai`

### Replaced
- `nathanaelkane/vim-indent-guides` -> `lukas-reineke/indent-blankline.nvim`
- `dylanaraps/root.vim` -> native `vim.fs.root()`
- `majutsushi/tagbar` -> `stevearc/aerial.nvim`
- `vim-airline/vim-airline` -> `nvim-lualine/lualine.nvim`

### Revisit later
- `coc.nvim`, but only as a dedicated parity-first migration project

## Detailed recommendations

### 1. `junegunn/fzf` — removed

**Why it was removed**
- There were no active Neovim mappings or command integrations pointing to it.
- Telescope already covered the active fuzzy-finding workflow.

**Why remove**
- In this repo, `fzf` was providing installation/build overhead without a visible Neovim UX surface.
- The config did not include `fzf.vim`; it only installed the `fzf` repository itself.
- Keeping both `fzf` and Telescope increased maintenance and bootstrap noise without demonstrated benefit.

**Recommendation**
- Remove `fzf` first.
- If you miss a specific fuzzy workflow later, add it back intentionally or use Telescope extensions instead.

**Risk**: low

### 2. `madox2/vim-ai` — removed

**Why it was removed**
- No config, keymaps, or commands in the repo pointed to it.
- The AI lane already included:
  - Copilot
  - CopilotChat
  - Claude Code
  - MCPHub

**Why remove**
- It overlaps conceptually with the current AI stack.
- There is no evidence in the repo that you actively use it.
- It increases plugin count and potential mental overhead for little observable value.

**Recommendation**
- Remove `vim-ai` now unless you can name a specific workflow that only it provides.

**Risk**: low

### 3. `nathanaelkane/vim-indent-guides` — replaced

**Why it was replaced**
- No custom behavior or keymaps depended on it.

**Why replace**
- `indent-blankline.nvim` is a modern Neovim indent-guide plugin with a documented `ibl` entrypoint, lazy.nvim config, and Lua-first setup.
- It is a better fit for the now Lua-owned Neovim configuration.

**Suggested replacement**
- `lukas-reineke/indent-blankline.nvim`

**Primary-source note**
- The README describes it as adding indentation guides to Neovim, using virtual text, with `ibl.setup()` and lazy.nvim support.

**Risk**: low

### 4. `majutsushi/tagbar` — replaced

**Why it was replaced**
- The outline toggle was an active workflow surface, so the replacement had to preserve `<F8>`.

**Why replace**
- This was an active, visible workflow surface, so the replacement preserved the existing F8 toggle workflow.

**Suggested replacement**
- `stevearc/aerial.nvim`

**Primary-source note**
- Aerial describes itself as a code outline window for skimming and quick navigation, with Neovim 0.11+ support and integrations with Telescope, fzf, and Lualine.

**Implemented replacement**
- `nvim/lua/plugins/navigation.lua`
- `AerialToggle!` on `<F8>`

**Risk**: medium

### 5. `vim-airline/vim-airline` — replaced

**Why it was replaced**
- The statusline is now fully Lua-owned.
- The current replacement is a lualine layout adapted from the upstream `evil_lualine.lua` example.

**Why replace**
- The statusline is now fully Lua-owned, and lualine fits the Neovim-only layout better than carrying a Vimscript-era statusline plugin.

**Implemented replacement**
- `nvim-lualine/lualine.nvim`
- evil_lualine-inspired configuration adapted for this repo, with tabline support preserved and CoC-aware diagnostics/status

**Primary-source note**
- Lualine describes itself as a blazing fast and easy to configure Neovim statusline written in Lua.

**Why it fits this repo**
- Pure Lua
- Better aligned with the new module ownership model
- Easier long-term than carrying Vimscript-era statusline assumptions

**Risk**: medium

### 6. `dylanaraps/root.vim` — replaced with native Neovim

**Why it was replaced**
- Root detection is now handled in `nvim/lua/config/project-root.lua`.

**Why replace**
- This is a narrow behavior area that Neovim can now handle natively.
- Native root detection would reduce plugin count.

**Implemented replacement**
- `nvim/lua/config/project-root.lua`
- buffer-local root detection driven by `vim.fs.root()`

**Primary-source note**
- Neovim documents `vim.fs.root()` as a built-in way to find the first parent directory containing a marker such as `.git`.

**Risk**: medium

### 7. `coc.nvim` — keep for now

**Current repo evidence**
- Deeply integrated in `nvim/lua/plugins/lsp.lua`
- Current UX preference is explicitly CoC-style

**Why keep**
- Your current goal was structure and configuration cleanup, not an LSP UX reset.
- CoC still owns a large amount of established motion and commands.
- Replacing it now would turn a maintenance pass into a workflow migration.

**Recommendation**
- Keep CoC until you explicitly want an LSP/completion migration project.

**Risk if changed now**: high

## Remaining future work

1. Revisit CoC only as a separate project with explicit UX parity goals.

## Sources

Primary sources reviewed:
- indent-blankline.nvim: https://github.com/lukas-reineke/indent-blankline.nvim
- aerial.nvim: https://github.com/stevearc/aerial.nvim
- lualine.nvim: https://github.com/nvim-lualine/lualine.nvim
- Neovim Lua docs (`vim.fs.root()`): https://neovim.io/doc/user/lua.html

Repo-local evidence:
- `nvim/lua/plugins/navigation.lua`
- `nvim/lua/plugins/ui.lua`
- `nvim/lua/plugins/lsp.lua`
- `nvim/lua/plugins/ai.lua`
- `nvim/lua/plugins/tools.lua`
- `tests/test_dotfiles.bats`
