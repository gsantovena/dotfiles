# Shell-agnostic shared configuration previously pulled in through bash_profile.

for file in "$HOME"/.{aliases,exports,functions,functions.extra}; do
    [ -r "$file" ] && source "$file"
done
unset file

if command -v brew >/dev/null 2>&1; then
    HOMEBREW_PREFIX="$(brew --prefix)"

    if [ -x "$HOMEBREW_PREFIX/bin/thefuck" ]; then
        eval "$(thefuck --alias)"
    fi

#    if [ -x "$HOMEBREW_PREFIX/bin/fortune" ]; then
#        echo
#        fortune
#        echo
#    fi

    unset HOMEBREW_PREFIX
fi

if [ -x /usr/local/bin/git-tip ]; then
    git-tip
fi
