source ~/.homebrew_apikey
source ~/.aliases
source ~/.exports
source ~/.functions

#if [ -f $(brew --prefix)/etc/bash_completion ]; then
#	. $(brew --prefix)/etc/bash_completion
#fi

#complete -C aws_completer aws

if [ -x /usr/local/bin/fortune ]; then
	echo
	fortune
	echo
fi

