#!/bin/bash
# Setup script for host machine to ensure credential directories exist
# Run this ONCE on your host machine (not in the container) before building the devcontainer

set -euo pipefail

echo "Creating credential directories on host machine..."

# Create directories if they don't exist
mkdir -p "$HOME/.codex"
mkdir -p "$HOME/.gemini"
mkdir -p "$HOME/.config/gh"
mkdir -p "$HOME/.config/gcloud"
mkdir -p "$HOME/.vercel"
mkdir -p "$HOME/.railway"

echo "Created directories:"
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

echo "=== Claude Code Credentials ==="
echo ""
echo "Claude Code uses a Docker volume for credential persistence (not bind mounts)."
echo "This avoids permission issues and state corruption on macOS."
echo ""
echo "To authenticate Claude Code:"
echo "  1. Start the devcontainer: devcontainer up --workspace-folder ."
echo "  2. Run 'claude' inside the container and login"
echo "  3. Credentials will persist across all container rebuilds"
echo ""

echo "To authenticate each service (run these on your HOST machine first):"
echo "  gh auth login              # GitHub CLI"
echo "  gcloud auth login          # Google Cloud SDK"
echo "  vercel login               # Vercel CLI"
echo "  railway login              # Railway CLI"
echo "  codex                      # Codex CLI (authenticates on first run)"
echo "  gemini                     # Gemini CLI (authenticates on first run)"
echo ""
echo "Note: Claude Code authentication happens INSIDE the container, not on the host."
