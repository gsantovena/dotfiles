# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# export UPDATE_ZSH_DAYS=13

#ZSH_THEME="robbyrussell"
ZSH_THEME="intheloop"

# CASE_SENSITIVE="true"
# HYPHEN_INSENSITIVE="true"
# DISABLE_AUTO_UPDATE="true"
# DISABLE_LS_COLORS="true"
# DISABLE_AUTO_TITLE="true"
# ENABLE_CORRECTION="true"
# DISABLE_UNTRACKED_FILES_DIRTY="true"
# HIST_STAMPS="mm/dd/yyyy"
# ZSH_CUSTOM=/path/to/new-custom-folder

COMPLETION_WAITING_DOTS="true"
plugins=(
    aws 
    brew 
    brew-cask 
    command-not-found
    docker 
    docker-compose 
    git 
    github
    gitignore
    go 
    knife 
    knife_ssh
    mvn 
    mosh
    nmap 
    osx 
    pyenv 
    ssh-agent
    terraform 
    thefuck
    vagrant 
    vault 
    virtualenv
    web-search
    z
)

# User configuration

source $ZSH/oh-my-zsh.sh
source $HOME/.bash_profile

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
