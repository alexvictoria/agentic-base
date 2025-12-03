#!/bin/bash
# Setup Playwright MCP Server for Claude Code
# This script installs and configures the Microsoft Playwright MCP server for browser automation

set -euo pipefail

echo "Setting up Microsoft Playwright MCP Server..."

# Check if Claude Code CLI is available
if ! command -v claude &> /dev/null; then
    echo "ERROR: Claude Code CLI not found. Please install it first."
    exit 1
fi

# Install Microsoft Playwright MCP server (official version)
# This provides browser automation capabilities to Claude Code
echo "Installing Microsoft Playwright MCP server..."
claude mcp add playwright -s user -- npx @playwright/mcp@latest

echo "✓ Microsoft Playwright MCP server installed successfully!"
echo ""
echo "To verify the installation, run:"
echo "  claude mcp list"
echo ""
echo "To use Playwright in Claude Code, start a session with:"
echo "  claude"
echo ""
echo "Then you can use commands like:"
echo "  'Use Playwright in headless mode to navigate to localhost:3000 and take a screenshot at 600x800'"
echo "  'Use Playwright to open a browser to example.com'"
echo "  'Navigate to google.com and search for playwright'"
echo ""
