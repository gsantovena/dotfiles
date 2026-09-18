# Vendor-generated and machine-local shell integrations.

# Ping Identity - Added with 'pingctl config' on Thu Jan 12 11:24:43 CST 2023
PING_IDENTITY_CONFIG="$HOME/.pingidentity/config"
if [ -r "$PING_IDENTITY_CONFIG" ]; then
    set -a
    source "$PING_IDENTITY_CONFIG"
    set +a
fi
unset PING_IDENTITY_CONFIG

# Salesforce CLI and Docker CLI completions are registered in 00-zinit.zsh, where they
# precede compinit. Do not source their vendor setup scripts here: each runs its own
# compinit, costing ~300ms per extra call.
