# Vendor-generated and machine-local shell integrations.

# Ping Identity - Added with 'pingctl config' on Thu Jan 12 11:24:43 CST 2023
PING_IDENTITY_CONFIG="$HOME/.pingidentity/config"
if [ -r "$PING_IDENTITY_CONFIG" ]; then
    set -a
    source "$PING_IDENTITY_CONFIG"
    set +a
fi
unset PING_IDENTITY_CONFIG

SF_AC_ZSH_SETUP_PATH="$HOME/Library/Caches/sf/autocomplete/zsh_setup"
[ -r "$SF_AC_ZSH_SETUP_PATH" ] && source "$SF_AC_ZSH_SETUP_PATH"
unset SF_AC_ZSH_SETUP_PATH

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
DOCKER_COMPLETIONS_DIR="$HOME/.docker/completions"
if [ -d "$DOCKER_COMPLETIONS_DIR" ]; then
    fpath=("$DOCKER_COMPLETIONS_DIR" $fpath)
    autoload -Uz compinit
    compinit
fi
unset DOCKER_COMPLETIONS_DIR
# End of Docker CLI completions
