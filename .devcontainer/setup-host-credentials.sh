#!/bin/bash
# Setup script for host machine to ensure credential directories exist
# Run this ONCE on your host machine (not in the container) before building the devcontainer

set -euo pipefail

echo "Creating credential directories on host machine..."

# Create directories if they don't exist
mkdir -p "$HOME/.claude"
mkdir -p "$HOME/.codex"
mkdir -p "$HOME/.config/gh"
mkdir -p "$HOME/.config/gcloud"
mkdir -p "$HOME/.vercel"
mkdir -p "$HOME/.railway"

echo "Created directories:"
echo "  ~/.claude        - Claude Code CLI history and settings"
echo "  ~/.codex         - Codex CLI settings"
echo "  ~/.config/gh     - GitHub CLI credentials"
echo "  ~/.config/gcloud - Google Cloud SDK credentials"
echo "  ~/.vercel        - Vercel CLI credentials"
echo "  ~/.railway       - Railway CLI credentials"

echo ""
echo "These directories will be mounted into the devcontainer."
echo "Your credentials will persist between container rebuilds."
echo ""
echo "To authenticate each service (run these on your HOST machine first):"
echo "  gh auth login              # GitHub CLI"
echo "  gcloud auth login          # Google Cloud SDK"
echo "  vercel login               # Vercel CLI"
echo "  railway login              # Railway CLI"
echo "  claude                     # Claude Code (authenticates on first run)"
