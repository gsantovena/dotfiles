# Neovim configuration

This Neovim setup uses `lazy.nvim` as the plugin manager and treats `nvim/` as the source of truth for Neovim runtime behavior.

## Current structure

```text
nvim/
├── init.vim
├── lazy-lock.json
├── PLUGIN_AUDIT.md
├── lua/
│   ├── lazy-init.lua
│   ├── config/
│   │   ├── autocmds.lua
│   │   ├── commands.lua
│   │   ├── keymaps.lua
│   │   ├── options.lua
│   │   ├── personal.lua
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

## CoC and legacy compatibility

- Neovim still uses `coc.nvim` and the existing CoC-style UX.
- CoC JSON settings live in `nvim/coc-settings.json`.

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
3. Review `nvim/PLUGIN_AUDIT.md` before replacing older plugins or changing CoC-era UX.
