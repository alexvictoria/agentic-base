#!/bin/bash
# Setup script for host machine to ensure credential directories exist
# Run this ONCE on your host machine (not in the container) before building the devcontainer

set -euo pipefail

echo "Creating credential directories on host machine..."

# Create directories if they don't exist
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.config/claude"
mkdir -p "$HOME/.codex"
mkdir -p "$HOME/.gemini"
mkdir -p "$HOME/.config/gh"
mkdir -p "$HOME/.config/gcloud"
mkdir -p "$HOME/.vercel"
mkdir -p "$HOME/.railway"

echo "Created directories:"
echo "  ~/.claude        - Claude Code CLI history and settings"
echo "  ~/.config/claude - Claude Code CLI (XDG-compliant path)"
echo "  ~/.codex         - Codex CLI settings"
echo "  ~/.gemini        - Gemini CLI settings"
echo "  ~/.config/gh     - GitHub CLI credentials"
echo "  ~/.config/gcloud - Google Cloud SDK credentials"
echo "  ~/.vercel        - Vercel CLI credentials"
echo "  ~/.railway       - Railway CLI credentials"

echo ""
echo "These directories will be mounted into the devcontainer."
echo "Your credentials will persist between container rebuilds."
echo ""

# macOS Keychain workaround for Claude Code
if [[ "$(uname)" == "Darwin" ]]; then
  echo "=== macOS Detected: Claude Code Keychain Workaround ==="
  echo ""
  echo "Claude Code on macOS stores credentials in the Keychain, not in files."
  echo "This means Linux containers cannot access your credentials."
  echo ""

  CREDS_FILE="$HOME/.claude/.credentials.json"

  if [[ -f "$CREDS_FILE" ]]; then
    echo "✓ Credentials file exists: $CREDS_FILE"
  else
    echo "Attempting to extract credentials from macOS Keychain..."

    # Try to extract Claude OAuth token from Keychain
    if CLAUDE_TOKEN=$(security find-generic-password -s "claude.ai" -a "oauth" -w 2>/dev/null); then
      echo '{"claudeAiOauth":{"accessToken":"'"$CLAUDE_TOKEN"'"}}' > "$CREDS_FILE"
      chmod 600 "$CREDS_FILE"
      echo "✓ Extracted credentials to $CREDS_FILE"
    else
      echo "Could not extract credentials from Keychain."
      echo ""
      echo "To fix this, run 'claude' on your Mac and authenticate, then run one of:"
      echo ""
      echo "Option 1: Use environment variable (recommended)"
      echo "  export ANTHROPIC_API_KEY=sk-ant-..."
      echo ""
      echo "Option 2: Extract from Keychain manually"
      echo "  security find-generic-password -s 'claude.ai' -a 'oauth' -w"
      echo "  # Then create ~/.claude/.credentials.json with the token"
      echo ""
      echo "Option 3: Authenticate inside the container"
      echo "  # Run 'claude' inside the devcontainer and login there"
      echo "  # Note: This requires re-auth on each container rebuild"
    fi
  fi
  echo ""
fi

echo "To authenticate each service (run these on your HOST machine first):"
echo "  gh auth login              # GitHub CLI"
echo "  gcloud auth login          # Google Cloud SDK"
echo "  vercel login               # Vercel CLI"
echo "  railway login              # Railway CLI"
echo "  claude                     # Claude Code (authenticates on first run)"
echo "  codex                      # Codex CLI (authenticates on first run)"
echo "  gemini                     # Gemini CLI (authenticates on first run)"
