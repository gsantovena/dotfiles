#
# References:
# - https://github.com/paulirish/dotfiles
##

for file in ~/.{aliases,exports,functions,secrets}; do
    [ -r "$file" ] && source "$file"
done
unset file

if [ -x /usr/local/bin/thefuck ]; then
    eval "$(thefuck --alias)"
fi

if [ -x /usr/local/bin/fortune ]; then
	echo
	fortune
	echo
fi

if [ -x /usr/local/bin/git-tip ]; then
    git-tip
fi

if [[ -n "$ZSH_VERSION" ]]; then
    return 1 2> /dev/null || exit 1;
fi;

if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

complete -C aws_completer aws

