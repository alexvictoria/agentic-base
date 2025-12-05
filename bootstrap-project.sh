#!/usr/bin/env bash
#
# bootstrap-project.sh
#
# Simple tool to copy base template files to a project directory.
#
# Usage:
#   ./bootstrap-project.sh <target-directory> [options]
#
# Options:
#   --agents-only       Copy only AI agent files (.claude, .cursor, .gemini, CLAUDE.md, etc.)
#   --devcontainer-only Copy only devcontainer files
#   (no options)        Copy everything (agents + devcontainer + config files)
#
# Examples:
#   ./bootstrap-project.sh ../my-project                  # Full bootstrap
#   ./bootstrap-project.sh ../my-project --agents-only    # AI files only
#   ./bootstrap-project.sh ../my-project --devcontainer-only  # Devcontainer only

set -euo pipefail

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Parse arguments
TARGET_DIR=""
MODE="all"  # all, agents, devcontainer

while [[ $# -gt 0 ]]; do
    case $1 in
        --agents-only)
            MODE="agents"
            shift
            ;;
        --devcontainer-only)
            MODE="devcontainer"
            shift
            ;;
        -*)
            echo "Unknown option: $1"
            exit 1
            ;;
        *)
            TARGET_DIR="$1"
            shift
            ;;
    esac
done

if [ -z "$TARGET_DIR" ]; then
    echo "Usage: $0 <target-directory> [--agents|--devcontainer]"
    exit 1
fi

# Determine if updating or creating
if [ -d "$TARGET_DIR" ]; then
    ACTION="Updating"
else
    ACTION="Creating"
    mkdir -p "$TARGET_DIR"
fi

echo -e "${GREEN}${ACTION} project with mode: ${MODE}${NC}"
echo "Target: $TARGET_DIR"
echo ""

# Helper to copy file/dir
copy_item() {
    local src="$1"
    local name=$(basename "$src")
    if [ -e "$src" ]; then
        cp -r "$src" "$TARGET_DIR/"
        echo "  ✓ $name"
    fi
}

# Copy AI agent files
copy_agents() {
    echo -e "${YELLOW}Copying AI agent files...${NC}"

    # Directories
    copy_item "$SCRIPT_DIR/.claude"
    copy_item "$SCRIPT_DIR/.cursor"
    copy_item "$SCRIPT_DIR/.gemini"

    # MD files for agents
    copy_item "$SCRIPT_DIR/CLAUDE.md"
    copy_item "$SCRIPT_DIR/AGENTS.md"
    copy_item "$SCRIPT_DIR/GEMINI.md"

    # Create .plan if it doesn't exist
    if [ ! -d "$TARGET_DIR/.plan" ]; then
        mkdir -p "$TARGET_DIR/.plan"
        echo "  ✓ .plan/"
    fi
}

# Copy devcontainer files
copy_devcontainer() {
    echo -e "${YELLOW}Copying devcontainer files...${NC}"
    copy_item "$SCRIPT_DIR/.devcontainer"
}

# Copy config files (not package.json)
copy_config() {
    echo -e "${YELLOW}Copying config files...${NC}"
    copy_item "$SCRIPT_DIR/.gitignore"
    copy_item "$SCRIPT_DIR/.editorconfig"
    copy_item "$SCRIPT_DIR/.prettierrc"
    copy_item "$SCRIPT_DIR/.eslintrc.json"
    copy_item "$SCRIPT_DIR/.tool-versions"
    copy_item "$SCRIPT_DIR/README.md"
}

# Execute based on mode
case $MODE in
    agents)
        copy_agents
        ;;
    devcontainer)
        copy_devcontainer
        ;;
    all)
        copy_agents
        copy_devcontainer
        copy_config
        ;;
esac

echo ""
echo -e "${GREEN}✓ Done!${NC}"
