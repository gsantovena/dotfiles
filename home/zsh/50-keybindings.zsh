# ZSH Hacks - Dreams of Code

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Clear screen but keep current command buffer.
function clear-screen-and-scrollback() {
    echoti civis >"$TTY"
    printf '%b' '\e[H\e[2J\e[3J' >"$TTY"
    echoti cnorm >"$TTY"
    zle redisplay
}
zle -N clear-screen-and-scrollback
bindkey '^Xl' clear-screen-and-scrollback

# Copy current command buffer to clipboard (macOS).
function copy-buffer-to-clipboard() {
    echo -n "$BUFFER" | pbcopy
    zle -M "Copied to clipboard"
}
zle -N copy-buffer-to-clipboard
bindkey '^Xc' copy-buffer-to-clipboard

# Insert git commit template (Ctrl+X, G, C).
# \C-b moves cursor back one position.
bindkey -s '^Xgc' 'git commit -m ""\C-b'
bindkey -s '^Xgp' 'git push origin '
bindkey -s '^Xgs' 'git status\n'
bindkey -s '^Xgl' 'git log --oneline -n 10\n'
