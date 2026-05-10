# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::async_prompt.zsh
zinit snippet OMZL::directories.zsh
zinit snippet OMZL::functions.zsh
zinit snippet OMZL::git.zsh
zinit snippet OMZP::command-not-found
zinit snippet OMZP::1password
zinit snippet OMZP::aws
zinit snippet OMZP::bundler
zinit snippet OMZP::brew
zinit snippet OMZP::common-aliases
zinit snippet OMZP::copypath
zinit snippet OMZP::docker
zinit snippet OMZP::docker-compose
zinit snippet OMZP::dotenv
zinit snippet OMZP::gh
zinit snippet OMZP::git
zinit snippet OMZP::git-prompt
zinit snippet OMZP::github
zinit snippet OMZP::gitignore
zinit snippet OMZP::golang
zinit snippet OMZP::helm
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::minikube
zinit snippet OMZP::mvn
zinit snippet OMZP::mosh
zinit snippet OMZP::nmap
zinit snippet OMZP::podman
zinit snippet OMZP::pyenv
zinit snippet OMZP::python
zinit snippet OMZP::rbenv
zinit snippet OMZP::ruby
zinit snippet OMZP::rust
zinit snippet OMZP::ssh-agent
zinit snippet OMZP::sudo
zinit snippet OMZP::systemadmin
zinit snippet OMZP::terraform
zinit snippet OMZP::thefuck
zinit snippet OMZP::transfer
zinit snippet OMZP::vagrant
zinit snippet OMZP::vagrant-prompt
zinit snippet OMZP::virtualenv
zinit snippet OMZP::vscode
zinit snippet OMZP::web-search
zinit snippet OMZP::z

zinit ice depth=1 \
  cloneopts"--filter=blob:none --sparse" \
  atclone"git sparse-checkout set --no-cone plugins/macos" \
  atpull"%atclone" \
  pick"plugins/macos/macos.plugin.zsh" \
  nocompile

zinit light ohmyzsh/ohmyzsh

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias vi='vim'
alias c='clear'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
