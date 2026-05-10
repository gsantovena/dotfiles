# Shell-agnostic shared configuration previously pulled in through bash_profile.

for file in "$HOME"/.{aliases,exports,functions,functions.extra}; do
    [ -r "$file" ] && source "$file"
done
unset file

if [ -x /usr/local/bin/git-tip ]; then
    git-tip
fi
