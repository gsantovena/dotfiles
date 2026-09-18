# Tool and runtime initialization.

[ -r "$HOME/.fzf.zsh" ] && source "$HOME/.fzf.zsh"

# Google Cloud SDK path and completion scripts installed by Homebrew cask.
GCP_ZSH_PATH="/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
GCP_COMPLETION="/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"

[ -r "$GCP_ZSH_PATH" ] && source "$GCP_ZSH_PATH"
[ -r "$GCP_COMPLETION" ] && source "$GCP_COMPLETION"
unset GCP_ZSH_PATH GCP_COMPLETION

# --no-rehash skips regenerating all shims on every shell start, which takes over a
# second across the installed Ruby versions. Run `rbenv rehash` after installing a gem
# that ships an executable.
if command -v rbenv >/dev/null 2>&1; then
    eval "$(rbenv init - --no-rehash zsh)"
fi

# --no-use skips nvm's default-version activation, which spends over a second
# validating the alias chain. Put that version's bin on PATH directly instead; `nvm use`
# still switches away from it normally.
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    source "/opt/homebrew/opt/nvm/nvm.sh" --no-use

    if [ -r "$NVM_DIR/alias/default" ]; then
        nvm_default_bin=("$NVM_DIR"/versions/node/v$(<"$NVM_DIR/alias/default")*/bin(N/n[-1]))
        if [ -n "$nvm_default_bin" ]; then
            path=("$nvm_default_bin" $path)
        else
            # The default alias points at something a version-prefix glob cannot resolve.
            nvm use --silent default
        fi
        unset nvm_default_bin
    fi
fi

[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# THIS MUST BE AT THE END OF THE SDKMAN BLOCK FOR SDKMAN TO WORK.
export SDKMAN_DIR="$HOME/.sdkman"
[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# export PATH="/opt/homebrew/opt/openssl@1.0/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
# export PATH="$PATH:$HOME/.rvm/bin"

# PostgreSQL
[ -d /opt/homebrew/opt/postgresql@16/bin ] && export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

[ -r "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"
