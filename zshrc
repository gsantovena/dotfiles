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
    common-aliases
    docker 
    docker-compose 
    dotenv
    git 
    github
    gitignore
    go 
    knife 
    knife_ssh
    kubectl
    mvn 
    mosh
    nmap 
    osx 
    pyenv 
    ssh-agent
    taskwarrior
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
zstyle :omz:plugins:ssh-agent agent-forwarding on

source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
