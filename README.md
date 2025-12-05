# Base Agent Standards

This repo provides the shared devcontainer and automation scaffolding for Codex and Claude workflows. The devcontainer ships with Node 24 plus codex-cli and the Claude Code CLI preinstalled for consistent agent behavior.

## Code Quality Principles

This repository enforces **world-class development standards** through specialized AI agent personas:

### DRY, KISS, YAGNI Philosophy

All code must follow these core principles with **HARD LIMITS**:

- **DRY (Don't Repeat Yourself)**: Extract repeated logic after 3+ uses; prefer duplication over wrong abstractions
- **KISS (Keep It Simple, Stupid)**: Choose the simplest solution; **max 20 lines/function, 250 lines/file, 3 levels nesting**; avoid cleverness
- **YAGNI (You Aren't Gonna Need It)**: Build only what's needed NOW; no speculative features; delete unused code immediately

### Next.js/Node.js Standards (Node.js 24)

For Next.js projects, we follow modern best practices:

- **App Router First**: Use `app/` directory; Server Components by default
- **TypeScript Strict**: `strict: true` in tsconfig; **ZERO `any` types** without justification
- **Server Actions**: Prefer over API routes for mutations
- **Performance**: Optimize for Core Web Vitals; leverage Next.js built-in optimizations
- **Progressive Enhancement**: Build features that work without JavaScript when possible

See `AGENTS.md` for complete architectural guidelines and technology stack.

## Network Isolation & MCP

The devcontainer runs with **strict iptables firewall rules** blocking all outbound traffic by default. Only specific domains are allowed via `init-firewall.sh`.

**MCP (Model Context Protocol)** servers extend AI capabilities:
- **Playwright MCP**: Browser automation for UI verification
- Setup: `.devcontainer/setup-playwright-mcp.sh`
- Verify: `claude mcp list`

## Specialized Sub-Agents

AI-powered experts in `.claude/agents/`:

- **`/architect`**: Full-stack architecture guidance (Next.js, APIs, databases, LLM integration)
- **`/refactor`**: Ruthless code simplification (enforces DRY, KISS, YAGNI hard limits)

## Coverage and Quality Gates

- Require 100% automated code coverage for every commit, push, and PR merge; block if the suite drops below full coverage.
- Run the full test suite (`make test` / `npm test`) locally and in CI before shipping; document any deliberate exclusions and rationale in the test config.
- Keep changes aligned with the guidelines in `AGENTS.md` and the Claude command docs under `.claude/commands/`.
- **All commits MUST use [Conventional Commits](https://www.conventionalcommits.org/) format**:
  - Format: `<type>(<scope>): <description> (#<issue>)`
  - **Always reference GitHub issue number** when available
  - Types: `feat`, `fix`, `chore`, `docs`, `test`, `refactor`, `perf`, `ci`, `build`, `style`
  - Examples: `feat: add authentication (#42)`, `fix: resolve memory leak (#123)`

## Quick Start

```bash
# 1. Start Colima (macOS)
colima start --cpu 4 --memory 8 --vm-type vz
docker context use colima

# 2. Open in devcontainer
devcontainer up --workspace-folder .
# OR use VS Code "Reopen in Container"

# 3. Setup project
make setup          # Install dependencies
make lint           # Run linters
make test           # Run tests (100% coverage required)
make ci             # Run full CI pipeline locally
```

## Development Workflow

This repository includes custom Claude Code slash commands for automated workflows:

```bash
/setup-husky        # Initialize git hooks (NEVER skip with --no-verify)
/architect          # Launch architecture expert sub-agent
/refactor           # Launch refactoring expert sub-agent
/plan-chat          # Interactive feature planning
/plan-breakdown     # Break epic into stories
/plan-create        # Create GitHub issues
/work 42            # Implement single issue
/autocommit 1-10    # Autonomous implementation of issues 1-10
```

See `.claude/commands/README.md` for complete command documentation.

### Husky Git Hooks

All projects use husky for pre-commit enforcement:
- Linting and formatting (lint-staged)
- Type checking (TypeScript, mypy)
- **NEVER skip hooks with `--no-verify`**

Installs automatically via `npm install` (using the `prepare` script in package.json).

## File Organization

```
.devcontainer/      # Docker environment with network isolation
.claude/commands/   # Custom slash commands for workflows
scripts/            # CLI helpers for local and CI usage
tests/              # Test files mirroring runtime code paths
AGENTS.md           # Detailed agent personas and standards
CLAUDE.md           # Complete development guide for Claude Code
```
