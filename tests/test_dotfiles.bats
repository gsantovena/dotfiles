#!/usr/bin/env bats

# Bats tests for dotfiles installation
# Run with: bats tests/test_dotfiles.bats

setup() {
    # Create a temporary directory for tests
    export TEST_TMPDIR="/tmp/dotfiles-bats-$$"
    mkdir -p "$TEST_TMPDIR"
    
    # Set up test environment
    export DOTFILES_DIR="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
}

teardown() {
    # Clean up test directory
    if [ -d "$TEST_TMPDIR" ]; then
        rm -rf "$TEST_TMPDIR"
    fi
}

@test "install script syntax is valid" {
    [ ! -e "$DOTFILES_DIR/install-dotfiles.sh" ]
    run bash -n "$DOTFILES_DIR/scripts/install-enhanced.sh"
    [ "$status" -eq 0 ]
}

@test "security check script runs without errors" {
    run "$DOTFILES_DIR/scripts/security-check.sh"
    [ "$status" -eq 0 ]
}

@test "test install script runs without errors" {
    run "$DOTFILES_DIR/scripts/test-install.sh"
    [ "$status" -eq 0 ]
}

@test "installer replaces existing directories instead of nesting symlinks" {
    mkdir -p "$TEST_TMPDIR/enhanced-home/.git"
    echo "# Original git metadata" > "$TEST_TMPDIR/enhanced-home/.git/config"
    mkdir -p "$TEST_TMPDIR/enhanced-home/.config/nvim"
    echo '" Original Neovim config' > "$TEST_TMPDIR/enhanced-home/.config/nvim/init.vim"
    mkdir -p "$TEST_TMPDIR/enhanced-home/.config/tmux"
    echo "# Original tmux config" > "$TEST_TMPDIR/enhanced-home/.config/tmux/tmux.conf"

    run env HOME="$TEST_TMPDIR/enhanced-home" DOTFILES_SKIP_TPM_BOOTSTRAP=true bash "$DOTFILES_DIR/scripts/install-enhanced.sh" --backup
    [ "$status" -eq 0 ]
    [ -L "$TEST_TMPDIR/enhanced-home/.git" ]
    [ -L "$TEST_TMPDIR/enhanced-home/.config/nvim" ]
    [ -L "$TEST_TMPDIR/enhanced-home/.config/ghostty" ]
    [ -L "$TEST_TMPDIR/enhanced-home/.config/tmux" ]
    [ ! -L "$TEST_TMPDIR/enhanced-home/.git/git" ]
    [ ! -L "$TEST_TMPDIR/enhanced-home/.config/nvim/nvim" ]
    [ ! -L "$TEST_TMPDIR/enhanced-home/.config/tmux/tmux" ]
}

@test "installer dry-run announces TPM bootstrap" {
    run env HOME="$TEST_TMPDIR/dry-home" bash "$DOTFILES_DIR/scripts/install-enhanced.sh" --dry-run
    [ "$status" -eq 0 ]
    [[ "$output" == *"Would install TPM from https://github.com/tmux-plugins/tpm.git"* ]]
}

@test "installer bootstraps TPM into configured plugin directory" {
    local fake_bin="$TEST_TMPDIR/fake-bin"
    local tpm_dir="$TEST_TMPDIR/tpm"
    local real_git
    real_git="$(command -v git)"
    mkdir -p "$fake_bin"

    cat > "$fake_bin/git" <<EOF
#!/bin/bash
set -euo pipefail

if [ "\${1:-}" = "clone" ]; then
    shift
    if [ "\${1:-}" = "--depth" ]; then
        shift 2
    fi
    repo="\$1"
    target="\$2"
    mkdir -p "\$target"
    printf '#!/bin/sh\n' > "\$target/tpm"
    chmod +x "\$target/tpm"
    printf '%s\n' "\$repo" > "\$target/cloned-from"
    exit 0
fi

exec "$real_git" "\$@"
EOF
    chmod +x "$fake_bin/git"

    run env PATH="$fake_bin:$PATH" HOME="$TEST_TMPDIR/bootstrap-home" TPM_INSTALL_DIR="$tpm_dir" bash "$DOTFILES_DIR/scripts/install-enhanced.sh" --backup
    [ "$status" -eq 0 ]
    [ -x "$tpm_dir/tpm" ]
    [ "$(cat "$tpm_dir/cloned-from")" = "https://github.com/tmux-plugins/tpm.git" ]
}

@test "tmux config uses TPM and ignores installed plugin checkouts" {
    grep -q "@plugin 'tmux-plugins/tpm'" "$DOTFILES_DIR/tmux/tmux.conf"
    grep -q "run '~/.config/tmux/plugins/tpm/tpm'" "$DOTFILES_DIR/tmux/tmux.conf"
    grep -q '^tmux/plugins/$' "$DOTFILES_DIR/.gitignore"
}

@test "tmux preserves Shift+Enter for Codex multiline input" {
    grep -q 'terminal-features.*,xterm-ghostty:extkeys:hyperlinks' "$DOTFILES_DIR/tmux/tmux.conf"
    grep -q '^set-option -g extended-keys always$' "$DOTFILES_DIR/tmux/tmux.conf"
    grep -q '^set-option -g extended-keys-format csi-u$' "$DOTFILES_DIR/tmux/tmux.conf"
    grep -q '^bind-key -n S-Enter send-keys -H 1b 5b 31 33 3b 32 75$' "$DOTFILES_DIR/tmux/tmux.conf"
    grep -q '^keybind = shift+enter=csi:13;2u$' "$DOTFILES_DIR/ghostty/config"
}

@test "tmux and ghostty preserve clickable URLs" {
    grep -q 'terminal-features.*,xterm-ghostty:extkeys:hyperlinks' "$DOTFILES_DIR/tmux/tmux.conf"
    grep -q '^set -g word-separators " "$' "$DOTFILES_DIR/tmux/tmux.conf"
    grep -q '^bind-key -n MouseDown1Pane if -F "#{mouse_hyperlink}"' "$DOTFILES_DIR/tmux/tmux.conf"
    grep -q 'open-url.sh "#{q:mouse_hyperlink}"' "$DOTFILES_DIR/tmux/tmux.conf"
    grep -q 'open-url.sh "#{q:mouse_word}"' "$DOTFILES_DIR/tmux/tmux.conf"
    grep -q '^link-url = true$' "$DOTFILES_DIR/ghostty/config"
}

@test "tmux URL opener normalizes plain links safely" {
    local fake_bin="$TEST_TMPDIR/fake-bin"
    local opened_url="$TEST_TMPDIR/opened-url"
    mkdir -p "$fake_bin"

    cat > "$fake_bin/open" <<EOF
#!/bin/bash
printf '%s\n' "\$1" > "$opened_url"
EOF
    chmod +x "$fake_bin/open"

    run env PATH="$fake_bin:$PATH" "$DOTFILES_DIR/tmux/open-url.sh" '"https://example.com/path?x=1".'
    [ "$status" -eq 0 ]
    [ "$(cat "$opened_url")" = "https://example.com/path?x=1" ]

    rm -f "$opened_url"
    run env PATH="$fake_bin:$PATH" "$DOTFILES_DIR/tmux/open-url.sh" 'www.example.com/docs,'
    [ "$status" -eq 0 ]
    [ "$(cat "$opened_url")" = "https://www.example.com/docs" ]
}

@test "tmux config syntax is valid" {
    if ! command -v tmux >/dev/null 2>&1; then
        skip "tmux not available"
    fi

    run tmux -L "dotfiles-bats-$$" -f /dev/null start-server \; source-file -n "$DOTFILES_DIR/tmux/tmux.conf" \; kill-server
    [ "$status" -eq 0 ]
}

@test "ghostty config syntax is valid when ghostty is available" {
    if ! command -v ghostty >/dev/null 2>&1; then
        skip "ghostty not available"
    fi

    run ghostty +validate-config --config-file="$DOTFILES_DIR/ghostty/config"
    [ "$status" -eq 0 ]
}

@test "required dotfiles exist" {
    local files=("zshrc" "bash_profile" "gitconfig" "aliases" "exports" "functions")
    
    for file in "${files[@]}"; do
        [ -f "$DOTFILES_DIR/$file" ]
    done

    [ -d "$DOTFILES_DIR/zsh" ]
    [ -f "$DOTFILES_DIR/zsh/00-zinit.zsh" ]
    [ -f "$DOTFILES_DIR/zsh/10-shared-shell.zsh" ]
    [ -f "$DOTFILES_DIR/zsh/20-tools.zsh" ]
    [ -f "$DOTFILES_DIR/zsh/30-completions.zsh" ]
    [ -f "$DOTFILES_DIR/zsh/40-vendor.zsh" ]
    [ -f "$DOTFILES_DIR/zsh/50-keybindings.zsh" ]
    [ -f "$DOTFILES_DIR/zsh/55-aliases.zsh" ]
    [ -f "$DOTFILES_DIR/zsh/60-zmv.zsh" ]
    [ -f "$DOTFILES_DIR/zsh/70-named-directories.zsh" ]
}

@test "git configuration is valid" {
    run git config --file "$DOTFILES_DIR/gitconfig" --list
    [ "$status" -eq 0 ]
}

@test "zsh configuration syntax" {
    # Skip if zsh is not available
    if ! command -v zsh >/dev/null 2>&1; then
        skip "zsh not available"
    fi
    
    # Test basic syntax (may not catch all oh-my-zsh issues)
    run zsh -n "$DOTFILES_DIR/zshrc"
    [ "$status" -eq 0 ]

    for file in "$DOTFILES_DIR"/zsh/*.zsh; do
        run zsh -n "$file"
        [ "$status" -eq 0 ]
    done
}

@test "bash profile syntax" {
    run bash -n "$DOTFILES_DIR/bash_profile"
    [ "$status" -eq 0 ]
}

@test "neovim configuration files exist" {
    [ -f "$DOTFILES_DIR/nvim/init.vim" ]
    [ -f "$DOTFILES_DIR/nvim/coc-settings.json" ]
    [ -f "$DOTFILES_DIR/nvim/lua/lazy-init.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/config/options.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/config/keymaps.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/config/commands.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/config/autocmds.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/config/personal.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/config/project-root.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/config/showpopup.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/plugins/init.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/plugins/editing.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/plugins/navigation.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/plugins/git.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/plugins/ui.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/plugins/lsp.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/plugins/ai.lua" ]
    [ -f "$DOTFILES_DIR/nvim/lua/plugins/tools.lua" ]
    [ ! -d "$DOTFILES_DIR/vim" ]
}

@test "neovim migration from vim-plug to lazy.nvim" {
    # Verify init.vim no longer sources vim-plug config
    ! grep -q "source.*vimrc.plugins" "$DOTFILES_DIR/nvim/init.vim"
    
    # Verify init.vim sources lazy-init instead
    grep -q "require('lazy-init')" "$DOTFILES_DIR/nvim/init.vim"
    grep -q "require('config.options')" "$DOTFILES_DIR/nvim/init.vim"
    grep -q "require('config.keymaps')" "$DOTFILES_DIR/nvim/init.vim"
    grep -q "require('config.commands')" "$DOTFILES_DIR/nvim/init.vim"
    grep -q "require('config.autocmds')" "$DOTFILES_DIR/nvim/init.vim"
    grep -q "require('config.personal')" "$DOTFILES_DIR/nvim/init.vim"
    grep -q "require('config.project-root')" "$DOTFILES_DIR/nvim/init.vim"
    ! grep -q "source ~/.vim/" "$DOTFILES_DIR/nvim/init.vim"
    
    # Verify lazy imports grouped plugin modules
    local lazy_plugins="$DOTFILES_DIR/nvim/lua/plugins"
    grep -q 'import = "plugins.editing"' "$lazy_plugins/init.lua"
    grep -q 'import = "plugins.navigation"' "$lazy_plugins/init.lua"
    grep -q 'import = "plugins.lsp"' "$lazy_plugins/init.lua"
    grep -R -q "github/copilot.vim" "$lazy_plugins"
    grep -R -q "neoclide/coc.nvim" "$lazy_plugins"
    grep -R -q "nvim-telescope/telescope.nvim" "$lazy_plugins"
    grep -R -q "tpope/vim-surround" "$lazy_plugins"
    ! grep -R -q 'ctrlpvim/ctrlp.vim' "$lazy_plugins"
    ! grep -R -q 'junegunn/fzf' "$lazy_plugins"
    ! grep -R -q 'dylanaraps/root.vim' "$lazy_plugins"
    ! grep -R -q 'dir = "~/.fzf"' "$lazy_plugins"
    ! grep -R -q 'build = "./install --all"' "$lazy_plugins"
    ! grep -R -q 'madox2/vim-ai' "$lazy_plugins"
}

@test "enhanced installer prints lazy.nvim bootstrap guidance" {
    mkdir -p "$TEST_TMPDIR/home"
    run env HOME="$TEST_TMPDIR/home" bash "$DOTFILES_DIR/scripts/install-enhanced.sh" --no-backup
    [ "$status" -eq 0 ]
    [[ "$output" == *"lazy.nvim"* ]]
    [[ "$output" == *"Lazy install"* ]]
    [[ "$output" != *"PlugInstall"* ]]
    [[ "$output" != *"plug.vim"* ]]
}

@test "shared Neovim mappings do not reference removed or conflicting plugin keys" {
    local keymaps_file="$DOTFILES_DIR/nvim/lua/config/keymaps.lua"
    local navigation_plugins="$DOTFILES_DIR/nvim/lua/plugins/navigation.lua"
    local lsp_plugins="$DOTFILES_DIR/nvim/lua/plugins/lsp.lua"
    local ai_plugins="$DOTFILES_DIR/nvim/lua/plugins/ai.lua"
    local tools_plugins="$DOTFILES_DIR/nvim/lua/plugins/tools.lua"

    ! grep -q "NERDTreeToggle" "$lsp_plugins"
    grep -q "AerialToggle" "$navigation_plugins"
    ! grep -q "majutsushi/tagbar" "$navigation_plugins"
    grep -q "CocCommand explorer --toggle --position left" "$lsp_plugins"
    grep -q "markdown-preview-enhanced.openPreview" "$lsp_plugins"
    grep -q "CopilotChatOpen" "$ai_plugins"
    grep -q "call Gurl()" "$tools_plugins"
    grep -q "<cmd>cclose<CR>" "$keymaps_file"
    grep -q "<cmd>tabnew<CR>" "$keymaps_file"
    grep -q "coc-codeaction-selected" "$lsp_plugins"
    grep -q "CopilotChatAddSelection" "$ai_plugins"
}

@test "neovim non-plugin options and keymaps are owned by Lua config modules" {
    local init_file="$DOTFILES_DIR/nvim/init.vim"
    local options_file="$DOTFILES_DIR/nvim/lua/config/options.lua"
    local keymaps_file="$DOTFILES_DIR/nvim/lua/config/keymaps.lua"
    local autocmds_file="$DOTFILES_DIR/nvim/lua/config/autocmds.lua"
    local personal_file="$DOTFILES_DIR/nvim/lua/config/personal.lua"
    local root_file="$DOTFILES_DIR/nvim/lua/config/project-root.lua"

    grep -q "require('config.options')" "$init_file"
    grep -q "require('config.keymaps')" "$init_file"
    grep -q "require('config.autocmds')" "$init_file"
    grep -q "require('config.personal')" "$init_file"

    grep -q 'opt.termguicolors = true' "$options_file"
    ! grep -q 'opt.laststatus = 2' "$options_file"
    ! grep -q 'statusline =' "$options_file"
    grep -q 'keymap("n", "<leader>tn"' "$keymaps_file"
    grep -q 'keymap("n", "<leader><space>"' "$keymaps_file"
    grep -q 'BufWritePost' "$autocmds_file"
    grep -q 'BufEnter' "$autocmds_file"
    grep -q 'EchoVimrcReloaded' "$personal_file"
    grep -q 'ShowFloatingMessage' "$personal_file"
    grep -q 'vim.fs.root' "$root_file"
}

@test "copilot mapping is owned in ai plugin config and not lazy on insert" {
    local ai_plugins="$DOTFILES_DIR/nvim/lua/plugins/ai.lua"
    local lsp_plugins="$DOTFILES_DIR/nvim/lua/plugins/lsp.lua"

    grep -q 'github/copilot.vim' "$ai_plugins"
    grep -q 'lazy = false' "$ai_plugins"
    grep -q 'copilot#Accept' "$ai_plugins"
    ! grep -q 'default_server = "avante"' "$ai_plugins"
    ! grep -q 'coc-snippets' "$lsp_plugins"
    ! grep -q 'coc-snippets-expand-jump' "$lsp_plugins"
    ! grep -q "coc_snippet_next" "$lsp_plugins"
    ! grep -q 'set statusline+=%{coc#status()}%=' "$lsp_plugins"
    ! grep -q 'set statusline+=%{CocStatus()}%=' "$lsp_plugins"
}

@test "lualine uses the evil_lualine theme" {
    local ui_plugins="$DOTFILES_DIR/nvim/lua/plugins/ui.lua"

    grep -q 'nvim-lualine/lualine.nvim' "$ui_plugins"
    grep -q 'bg = "#202328"' "$ui_plugins"
    grep -q 'component_separators = ""' "$ui_plugins"
    grep -q 'section_separators = ""' "$ui_plugins"
    grep -q 'config = setup_evil_lualine' "$ui_plugins"
    grep -q 'sources = { "nvim_diagnostic", "coc" }' "$ui_plugins"
    grep -q 'lukas-reineke/indent-blankline.nvim' "$ui_plugins"
    grep -q 'main = "ibl"' "$ui_plugins"
    ! grep -q 'vim-airline/vim-airline' "$ui_plugins"
}

@test "treesitter eagerly manages javascript-family parsers without auto install races" {
    local ui_plugins="$DOTFILES_DIR/nvim/lua/plugins/ui.lua"

    grep -q 'nvim-treesitter/nvim-treesitter' "$ui_plugins"
    grep -q '"diff"' "$ui_plugins"
    grep -q '"javascript"' "$ui_plugins"
    grep -q '"typescript"' "$ui_plugins"
    grep -q '"tsx"' "$ui_plugins"
    grep -q 'auto_install = false' "$ui_plugins"
}

@test "Neovim plugin setup for lazy-loaded plugins lives in lazy specs" {
    local lazy_plugins="$DOTFILES_DIR/nvim/lua/plugins"
    local coc_settings="$DOTFILES_DIR/nvim/coc-settings.json"

    grep -R -q 'local telescope = require("telescope")' "$lazy_plugins"
    grep -R -q 'require("aerial").setup({' "$lazy_plugins"
    grep -R -q 'telescope.load_extension("ui-select")' "$lazy_plugins"
    grep -R -q 'require("CopilotChat").setup({' "$lazy_plugins"
    grep -R -q 'require("mcphub").setup({' "$lazy_plugins"
    grep -R -q 'require("claude-code").setup({' "$lazy_plugins"
    grep -R -q 'coc_global_extensions' "$lazy_plugins"
    grep -R -q 'lualine.setup(config)' "$lazy_plugins"
    grep -R -q 'copilot_no_tab_map' "$lazy_plugins"
    grep -q '"suggest.noselect": true' "$coc_settings"
}

@test "neovim plugin specs are split into grouped lazy modules" {
    local plugins_dir="$DOTFILES_DIR/nvim/lua/plugins"

    grep -q "return {" "$plugins_dir/init.lua"
    grep -q 'import = "plugins.editing"' "$plugins_dir/init.lua"
    grep -q 'import = "plugins.navigation"' "$plugins_dir/init.lua"
    grep -q 'import = "plugins.git"' "$plugins_dir/init.lua"
    grep -q 'import = "plugins.ui"' "$plugins_dir/init.lua"
    grep -q 'import = "plugins.lsp"' "$plugins_dir/init.lua"
    grep -q 'import = "plugins.ai"' "$plugins_dir/init.lua"
    grep -q 'import = "plugins.tools"' "$plugins_dir/init.lua"

    for module in editing navigation git ui lsp ai tools; do
        [ -f "$plugins_dir/$module.lua" ]
        grep -q "return {" "$plugins_dir/$module.lua"
    done
}

@test "neovim lua files have valid basic structure" {
    local lazy_init_file="$DOTFILES_DIR/nvim/lua/lazy-init.lua"

    grep -q 'require("lazy")' "$lazy_init_file"

    for lua_file in "$DOTFILES_DIR"/nvim/lua/plugins/*.lua; do
        local open_braces=$(grep -o "{" "$lua_file" | wc -l)
        local close_braces=$(grep -o "}" "$lua_file" | wc -l)
        [ "$open_braces" -eq "$close_braces" ]
    done
}
