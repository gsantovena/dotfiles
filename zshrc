# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
# export UPDATE_ZSH_DAYS=13

ZSH_THEME="nanotech"
ZSH_THEME="arrow"
ZSH_THEME="clean"
ZSH_THEME="intheloop"
ZSH_THEME="robbyrussell"
ZSH_THEME="cypher"
ZSH_THEME="af-magic"

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
    common-aliases
    docker 
    docker-compose 
    dotenv
    git 
    git-prompt
    github
    gitignore
    golang
    knife 
    knife_ssh
    kubectl
    minikube
    mvn 
    mosh
    nmap 
    osx 
    pyenv 
    ssh-agent
    sudo
    systemadmin
    taskwarrior
    terraform 
    thefuck
    transfer
    vagrant 
    vagrant-prompt
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

GCP_ZSH_PATH='/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
GCP_COMPLETION='/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'

[ -f $GCP_ZSH_PATH ] && source $GCP_ZSH_PATH
[ -f $GCP_COMPLETION ] && source $GCP_COMPLETION

export PATH="/usr/local/opt/ruby/bin:$PATH"
