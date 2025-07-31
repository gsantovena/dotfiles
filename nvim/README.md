# Neovim Configuration with Lazy.nvim

This Neovim configuration has been migrated from vim-plug to lazy.nvim for better performance and modern plugin management.

## Structure

```
nvim/
├── init.vim                    # Main configuration file
├── coc-settings.json          # COC LSP settings
├── lua/
│   ├── lazy-init.lua          # Lazy.nvim bootstrap and setup
│   ├── plugins/
│   │   └── init.lua           # Plugin specifications
│   └── config/
│       └── showpopup.lua      # Custom floating window function
```

## Plugin Manager Migration

- **Before**: vim-plug (`call plug#begin()` / `call plug#end()`)
- **After**: lazy.nvim (modern Lua-based plugin manager)

## Features

### Lazy Loading
- Telescope: Loads on command usage
- CopilotChat: Loads on command usage  
- Copilot: Loads on entering insert mode
- MCPHub: Loads on command usage

### Performance Optimizations
- Disabled unnecessary built-in plugins
- Organized plugins by category and loading strategy
- Efficient dependency management

### Plugin Categories

1. **Essential utilities**: plenary.nvim
2. **Editing**: surround, commentary, repeat, splitjoin
3. **File management**: fzf, root.vim, tagbar
4. **Git**: fugitive
5. **UI**: airline, indent-guides
6. **Language tools**: dash, markdown-preview, http-client
7. **Modern tools**: telescope, treesitter
8. **LSP**: coc.nvim with extensions
9. **AI**: copilot, copilot-chat, vim-ai
10. **Advanced**: mcphub.nvim

## Installation

When you first start Neovim after this migration:

1. Lazy.nvim will automatically bootstrap itself
2. All plugins will be installed automatically
3. COC extensions will be installed on first COC usage
4. Build commands (like treesitter compilation) will run automatically

## Commands

- `:Lazy` - Open lazy.nvim plugin manager UI
- `:Lazy update` - Update all plugins
- `:Lazy clean` - Remove unused plugins
- `:Lazy profile` - Profile plugin loading times

## Compatibility

All existing functionality is preserved:
- All COC mappings and extensions work as before
- Copilot and CopilotChat work as before  
- Telescope configuration is maintained
- All custom mappings and configurations are preserved

## Troubleshooting

If you encounter issues:

1. Check `:Lazy` UI for plugin installation status
2. Run `:checkhealth` for general Neovim diagnostics
3. Existing COC and other plugin configurations remain in `~/.vim/vimrc.plugin_config`