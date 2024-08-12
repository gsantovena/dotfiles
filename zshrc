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
ZSH_THEME="steeef"
ZSH_THEME="peepcode"
ZSH_THEME="avit"

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
    bundler
    brew 
    colorize
    common-aliases
    copypath
    docker 
    docker-compose 
    dotenv
    gh
    git 
    git-prompt
    github
    gitignore
    golang
    helm
    knife 
    knife_ssh
    kubectl
    kubectx
    macos
    minikube
    mvn 
    mosh
    nmap 
    pyenv 
    rbenv
    ruby
    ssh-agent
    sudo
    systemadmin
    terraform 
    thefuck
    transfer
    vagrant 
    vagrant-prompt
    virtualenv
    vscode
    web-search
    z
    zsh-autosuggestions
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

# ----------------
# rbenv
# ----------------
eval "$(rbenv init - zsh)"

export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

#export PATH="/opt/homebrew/opt/openssl@1.0/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
#export PATH="$PATH:$HOME/.rvm/bin"

# Ping Identity - Added with 'pingctl config' on Thu Jan 12 11:24:43 CST 2023
set -a
test -f '/Users/gsantovena/.pingidentity/config' && source '/Users/gsantovena/.pingidentity/config'
set +a

# PostreSQL
export PATH="/opt/homebrew/opt/postgresql@16/bin:$PATH"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/vault vault
