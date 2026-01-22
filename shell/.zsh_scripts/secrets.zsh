# Fetch API keys from 1Password at shell startup
# Uses `op read` to retrieve secrets securely from vault
if command -v op &> /dev/null; then
  export BOBSHELL_API_KEY=$(op read "op://Private/Project Bob API key/credential" 2>/dev/null)
fi
