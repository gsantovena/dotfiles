## EXPORTS
source ~/.homebrew_apikey

#export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth:erasedups
export GOPATH=/Users/gsantovena/Projects/Go
export PATH=$PATH:$GOPATH/bin

## ALIAS
alias ls='ls -F'

## FUNCTIONS

brew-cask-upgrade() { 
  if [ "$1" != '--continue' ]; then 
    echo "Removing brew cache" 
    rm -rf "$(brew --cache)" 
    echo "Running brew update" 
    brew update 
  fi 
  for c in $(brew cask list); do 
    echo -e "\n\nInstalled versions of $c: " 
    ls /usr/local/Caskroom/$c 
    echo "Cask info for $c" 
    brew cask info $c 
    select ynx in "Yes" "No" "Exit"; do  
      case $ynx in 
        "Yes") echo "Uninstalling $c"; brew cask uninstall --force "$c"; echo "Re-installing $c"; brew cask install "$c"; break;; 
        "No") echo "Skipping $c"; break;; 
        "Exit") echo "Exiting brew-cask-upgrade"; return;; 
      esac 
    done 
  done 
} 

## OTHER

if [ -f $(brew --prefix)/etc/bash_completion ]; then
	. $(brew --prefix)/etc/bash_completion
fi

complete -C aws_completer aws

if [ -x /usr/local/bin/fortune ]; then
	echo
	fortune
	echo
fi

