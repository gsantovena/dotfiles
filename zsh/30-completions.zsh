# Additional completions not handled by Oh My Zsh.

autoload -U +X bashcompinit && bashcompinit

if [ -x /opt/homebrew/bin/vault ]; then
    complete -o nospace -C /opt/homebrew/bin/vault vault
fi
