#!/usr/bin/env bash
#
# bootstrap-project.sh
#
# Description:
#   Copies base template files to a new project directory.
#   Creates a clean starting point with devcontainer, Claude workflows,
#   and essential configuration files.
#
# Usage:
#   ./bootstrap-project.sh <target-directory>
#
# Example:
#   ./bootstrap-project.sh ../my-new-project
#
# What gets copied:
#   - .claude/          (agents and commands)
#   - .devcontainer/    (Docker setup with network isolation)
#   - .plan/            (empty, for planning artifacts)
#   - package.json      (base dependencies)
#   - .gitignore        (base ignore rules)
#   - *.md files        (CLAUDE.md, AGENTS.md, README.md)
#   - .npmrc, .nvmrc    (if present)

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory (absolute path to this script's location)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validate arguments
if [ $# -ne 1 ]; then
    echo -e "${RED}Error: Missing target directory${NC}"
    echo "Usage: $0 <target-directory>"
    echo "Example: $0 ../my-new-project"
    exit 1
fi

TARGET_DIR="$1"

# Prompt for project name
echo -e "${BLUE}Enter project name (will be used in package.json):${NC}"
read -p "> " PROJECT_NAME

# Validate project name
if [ -z "$PROJECT_NAME" ]; then
    echo -e "${RED}Error: Project name cannot be empty${NC}"
    exit 1
fi

# Prompt for project description (optional)
echo -e "${BLUE}Enter project description (optional, press enter to skip):${NC}"
read -p "> " PROJECT_DESCRIPTION

# Check if target directory already exists
if [ -d "$TARGET_DIR" ]; then
    echo -e "${RED}Error: Directory '$TARGET_DIR' already exists${NC}"
    echo "Please choose a different name or remove the existing directory"
    exit 1
fi

echo -e "${GREEN}Bootstrapping new project from base template...${NC}"
echo "Source: $SCRIPT_DIR"
echo "Target: $TARGET_DIR"
echo ""

# Create target directory
mkdir -p "$TARGET_DIR"

# Copy directories
echo -e "${YELLOW}Copying directories...${NC}"
cp -r "$SCRIPT_DIR/.claude" "$TARGET_DIR/"
echo "  ✓ .claude/"

cp -r "$SCRIPT_DIR/.devcontainer" "$TARGET_DIR/"
echo "  ✓ .devcontainer/"

mkdir -p "$TARGET_DIR/.plan"
echo "  ✓ .plan/ (empty)"

# Copy files
echo -e "${YELLOW}Copying configuration files...${NC}"
cp "$SCRIPT_DIR/package.json" "$TARGET_DIR/"
echo "  ✓ package.json"

# Update package.json with project name and description
echo -e "${YELLOW}Updating package.json...${NC}"
if command -v jq &> /dev/null; then
    # Use jq if available (more robust)
    if [ -n "$PROJECT_DESCRIPTION" ]; then
        jq --arg name "$PROJECT_NAME" --arg desc "$PROJECT_DESCRIPTION" \
           '.name = $name | .description = $desc' \
           "$TARGET_DIR/package.json" > "$TARGET_DIR/package.json.tmp"
    else
        jq --arg name "$PROJECT_NAME" \
           '.name = $name' \
           "$TARGET_DIR/package.json" > "$TARGET_DIR/package.json.tmp"
    fi
    mv "$TARGET_DIR/package.json.tmp" "$TARGET_DIR/package.json"
else
    # Fallback to sed if jq is not available
    sed -i.bak "s/\"name\": \"base\"/\"name\": \"$PROJECT_NAME\"/" "$TARGET_DIR/package.json"
    if [ -n "$PROJECT_DESCRIPTION" ]; then
        sed -i.bak "s/\"description\": \".*\"/\"description\": \"$PROJECT_DESCRIPTION\"/" "$TARGET_DIR/package.json"
    fi
    rm -f "$TARGET_DIR/package.json.bak"
fi
echo "  ✓ Updated name to: $PROJECT_NAME"
if [ -n "$PROJECT_DESCRIPTION" ]; then
    echo "  ✓ Updated description to: $PROJECT_DESCRIPTION"
fi

cp "$SCRIPT_DIR/.gitignore" "$TARGET_DIR/"
echo "  ✓ .gitignore"

# Copy markdown files
cp "$SCRIPT_DIR/CLAUDE.md" "$TARGET_DIR/"
echo "  ✓ CLAUDE.md"

cp "$SCRIPT_DIR/AGENTS.md" "$TARGET_DIR/"
echo "  ✓ AGENTS.md"

cp "$SCRIPT_DIR/README.md" "$TARGET_DIR/"
echo "  ✓ README.md"

# Copy optional rc files if they exist
for rc_file in .npmrc .nvmrc .editorconfig .prettierrc .eslintrc.json .tool-versions; do
    if [ -f "$SCRIPT_DIR/$rc_file" ]; then
        cp "$SCRIPT_DIR/$rc_file" "$TARGET_DIR/"
        echo "  ✓ $rc_file"
    fi
done

# Copy any other *rc files in root (excluding .gitignore which was already copied)
shopt -s nullglob
for rc_file in "$SCRIPT_DIR"/.*rc; do
    filename=$(basename "$rc_file")
    if [ ! -f "$TARGET_DIR/$filename" ]; then
        cp "$rc_file" "$TARGET_DIR/"
        echo "  ✓ $filename"
    fi
done
shopt -u nullglob

# Initialize git repository
echo -e "${YELLOW}Initializing git repository...${NC}"
cd "$TARGET_DIR"
git init
echo "  ✓ git init"

# Create initial commit
git add .
git commit -m "chore: initial commit from base template

Bootstrapped from base repository with:
- Claude Code workflows (.claude/)
- Devcontainer with network isolation (.devcontainer/)
- Base package.json and configuration files
- Planning directory structure (.plan/)

Generated with bootstrap-project.sh"
echo "  ✓ Initial commit created"

echo ""
echo -e "${GREEN}✓ Project '$PROJECT_NAME' bootstrapped successfully!${NC}"
echo ""
echo "Next steps:"
echo "  1. cd $TARGET_DIR"
echo "  2. Update README.md with your project-specific details"
echo "  3. Start devcontainer: devcontainer up --workspace-folder ."
echo "  4. Install dependencies: npm install"
echo ""
echo "Happy coding!"
