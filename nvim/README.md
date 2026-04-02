# Neovim configuration

This Neovim setup uses `lazy.nvim` as the plugin manager and treats `nvim/` as the source of truth for Neovim runtime behavior.

## Current structure

```text
nvim/
├── coc-settings.json
├── init.vim
├── lazy-lock.json
├── PLUGIN_AUDIT.md
├── PLUGIN_REEVALUATION.md
├── lua/
│   ├── lazy-init.lua
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── commands.lua
│   │   ├── keymaps.lua
│   │   ├── options.lua
│   │   ├── personal.lua
│   │   ├── project-root.lua
│   │   └── showpopup.lua
│   └── plugins/
│       ├── init.lua
│       ├── editing.lua
│       ├── navigation.lua
│       ├── git.lua
│       ├── ui.lua
│       ├── lsp.lua
│       ├── ai.lua
│       └── tools.lua
```

## Ownership model

- `nvim/init.vim` is a thin Neovim entrypoint.
- `nvim/lua/config/*` owns general Neovim behavior:
  - options
  - keymaps
  - commands
  - autocmds
  - personal popup helpers
- `nvim/lua/config/project-root.lua` owns built-in project root detection.
- `nvim/lua/plugins/*` owns plugin declarations and Neovim-side plugin configuration.

## Plugin organization

Current grouped plugin modules:

1. `plugins/editing.lua`
2. `plugins/navigation.lua`
3. `plugins/git.lua`
4. `plugins/ui.lua`
5. `plugins/lsp.lua`
6. `plugins/ai.lua`
7. `plugins/tools.lua`

## CoC and statusline

- Neovim still uses `coc.nvim` and the existing CoC-style UX.
- CoC JSON settings live in `nvim/coc-settings.json`.
- `lualine.nvim` owns the statusline/tabline with an evil_lualine-inspired layout.
- A Nerd Font such as Hack Nerd Font is recommended if you want all glyphs to render cleanly.

## Verification workflow

Useful checks after editing the configuration:

```bash
bats tests/test_dotfiles.bats
make test
nvim --headless '+qa'
```

If `shellcheck` is installed:

```bash
make lint
```

## Troubleshooting

1. Open `:Lazy` to inspect plugin installation state.
2. Run `:checkhealth` for Neovim diagnostics.
3. Review `nvim/PLUGIN_AUDIT.md` and `nvim/PLUGIN_REEVALUATION.md` before replacing plugins or changing CoC-era UX.
