# Repository Guidelines for Google Gemini

This file provides guidance to Google Gemini CLI when working with code in this repository.

## Repository Overview

This is a base repository providing shared devcontainer configuration and automation scaffolding for AI agent workflows. It standardizes development environments with strict network isolation and quality gates, supporting Claude, Codex, and Gemini AI coding assistants.

## Development Environment

### Devcontainer Setup (macOS with Colima)

The primary development environment is a Docker-based devcontainer with network restrictions:

**Prerequisites:**
- Colima must be running: `colima start --cpu 4 --memory 8 --vm-type vz`
- Set Docker context: `docker context use colima`

**Start devcontainer:**
- CLI: `devcontainer up --workspace-folder .`
- VS Code: "Reopen in Container" command

**Container specifications:**
- Base image: `node:24-bookworm`
- User: `node` (non-root)
- Node version: 24 (check for `.nvmrc`)
- Python 3 available for helper scripts
- Claude Code CLI pre-installed globally
- Default shell: zsh with powerline10k theme

### Network Isolation

The devcontainer runs with **strict iptables firewall rules** that:
- Block all outbound traffic by default
- Allow only specific domains via ipset (GitHub, npm registry, Anthropic API, VS Code marketplace, etc.)
- Allow HTTP (port 80) and HTTPS (port 443) for Playwright browser automation
- Run on container start via `init-firewall.sh` (requires NET_ADMIN and NET_RAW capabilities)

**Important**: When adding new external dependencies or APIs, you must update `init-firewall.sh` to include the domain in the allowed list.

**Playwright Exception**: HTTP/HTTPS traffic is allowed for browser automation and testing via Playwright MCP. While this relaxes the firewall for web traffic, other protocols (FTP, SMTP, etc.) remain blocked.

### MCP Server Integration

This devcontainer includes support for **MCP (Model Context Protocol)** servers, which extend AI assistant capabilities with external tools and services.

**Playwright MCP Server:**
- Browser automation (Chromium, Firefox, WebKit)
- Web scraping and testing
- Accessibility snapshot analysis
- Real-time web interaction

**Setup:**
```bash
# After starting devcontainer
.devcontainer/setup-playwright-mcp.sh

# Verify installation
claude mcp list
```

## Build and Test Commands

Standard commands for this repository:

- `make setup` or `npm ci` - Install dependencies
- `make lint` or `npm run lint` - Run ESLint (JS/TS) and Ruff (Python)
- `make format` or `npm run format` - Run Prettier (JS/TS) and Black (Python)
- `make test` or `npm test` - Run test suite with 100% coverage requirement
- `make ci` - Mirror CI pipeline locally

## Code Quality Standards

### Coverage and Testing Requirements

- **100% code coverage** required for all commits, pushes, and PR merges
- Block any coverage regression unless explicitly documented
- Test files: `*.test.ts` / `*.test.js` (Node) or `test_*.py` (Python)
- Run full test suite before any commit: `make test` or `npm test`

### Code Style

**Indentation and Formatting:**
- 2 spaces (no tabs unless language-required)
- Line length: 100-120 characters
- Trailing newline in all files

**Naming Conventions:**
- Files/variables: `snake_case`
- Functions: `camelCase`
- Classes/types: `PascalCase`

**Formatters/Linters:**
- Node: Prettier + ESLint
- Python: Black + Ruff

**Commits:**
Use [Conventional Commits](https://www.conventionalcommits.org/) format:
- Format: `<type>(<scope>): <description> (#<issue>)`
- Types: `feat`, `fix`, `chore`, `docs`, `test`, `refactor`, `perf`, `ci`, `build`, `style`
- **MUST reference GitHub issue** when available: e.g., `feat: add user authentication (#42)`
- Examples:
  - `feat: add dark mode toggle (#123)`
  - `fix: resolve memory leak in data processor (#456)`
  - `docs: update API documentation (#789)`
  - `test: add unit tests for auth service (#234)`
- Scope is optional but recommended for monorepos or large codebases

### Git Hooks

All projects use husky for pre-commit enforcement:
- Linting and formatting (lint-staged)
- Type checking (TypeScript, mypy)
- Unit tests (optional in pre-push)
- **NEVER** skip hooks with `--no-verify`

Husky installs automatically via `npm install` (using the `prepare` script in package.json).

## Architecture Principles

### Code Quality Philosophy

All code in this repository must adhere to **DRY, KISS, and YAGNI** principles:

**DRY (Don't Repeat Yourself):**
- Extract repeated logic after 3+ occurrences
- Prefer duplication over wrong abstractions
- Use composition to eliminate redundancy

**KISS (Keep It Simple, Stupid):**
- Choose the simplest working solution
- Max 20 lines per function, 250 lines per file
- Avoid clever code; prefer explicit and readable
- Max 3 levels of nesting in conditionals

**YAGNI (You Aren't Gonna Need It):**
- Build only what's needed NOW
- No speculative features or "future-proofing"
- Delete unused code immediately (never comment out)
- Refactor when requirements change, not before

### Node.js/Next.js Standards

For Node.js and Next.js projects, follow these architectural guidelines:

**Next.js Best Practices:**
- Use **App Router** (`app/`) as default
- **Server Components First**: Only add `'use client'` when needed (interactivity, hooks, browser APIs)
- Use **Server Actions** for mutations over API routes
- Implement proper loading states (`loading.tsx`) and error boundaries (`error.tsx`)
- Leverage Next.js optimizations: `<Image>`, `<Link>`, `<Font>`

**TypeScript:**
- Enable `strict: true` in `tsconfig.json`
- No `any` types without explicit justification
- Use proper type inference; avoid unnecessary annotations
- Define types in `src/types/` for shared interfaces

**Data Fetching:**
- Server Components: Fetch directly in component
- Client Components: Use SWR or React Query
- Never fetch in `useEffect` when RSC can handle it
- Implement caching strategies (revalidate, cache tags)

**Code Organization:**
```
app/                    # Next.js App Router
├── (routes)/           # Route groups
├── _components/        # Private components (not routes)
└── layout.tsx

src/
├── components/         # Shared UI components
├── lib/                # Utilities, configs
├── hooks/              # Custom hooks
├── types/              # TypeScript types
└── actions/            # Server Actions
```

**Technology Stack:**
- **Runtime**: Node.js 24 LTS
- **Framework**: Next.js 14+ with App Router
- **Styling**: Tailwind CSS or CSS Modules
- **Forms**: React Hook Form + Zod
- **State**: Server Components (server state), Zustand/Jotai (client state)
- **Testing**: Vitest + Testing Library (unit), Playwright (e2e)

### Configuration Files

Place at root for AI assistant discoverability:
- `Makefile`, `package.json`, `pyproject.toml`, `.tool-versions`
- Language/runtime configs should be easily detectable

### Test Organization

- Tests under `tests/` mirroring runtime code paths
- Shared fixtures in `tests/fixtures/`
- Fast, deterministic tests with minimal static JSON

### Pull Requests

- Include summary, linked issue, validation commands
- Screenshots for UX changes
- Keep focused: split environment changes from runtime code
- All PRs gated on 100% test coverage and passing CI

## Directory Structure

```
.devcontainer/           # Devcontainer configuration
├── devcontainer.json    # VS Code devcontainer settings
├── Dockerfile           # Node 24 + Python + Claude Code CLI
└── init-firewall.sh     # Network isolation (iptables + ipset)

.claude/
├── agents/              # Specialized sub-agent definitions
│   ├── README.md        # Agent documentation
│   ├── fullstack-architect.md     # Node.js/Next.js architecture expert
│   └── refactor-expert.md      # DRY/YAGNI/KISS refactoring expert
│
└── commands/            # Custom slash commands for workflows
    ├── README.md        # Command documentation
    ├── plan-chat.md
    ├── plan-breakdown.md
    ├── plan-create.md
    ├── work.md
    ├── autocommit.md
    ├── architect.md     # Launches architect sub-agent
    ├── refactor.md      # Launches refactor sub-agent
    └── setup-husky.md

.plan/                   # Planning artifacts (created by workflow)
├── current-plan.md      # Overall feature plan
├── story-NNN.md         # Individual story specs
├── dependency-map.md    # Dependency graph
└── issue-mapping.md     # Story → GitHub issue mapping
```

## Security

- **Never commit secrets** (API keys, tokens)
- Store in `.env` (gitignored) with `.env.example` for placeholders
- Commit lockfiles for reproducibility
- Network isolation via firewall enforces external dependency allowlist
- Run dependency scanning (`npm audit`, `pip-audit`) in CI

## Code Quality Checklist

Before submitting any code changes, verify:

1. **Simplicity**: Can this be simpler? Does it follow KISS?
2. **Duplication**: Is there repeated code? Should it be extracted (3+ uses)?
3. **Necessity**: Is this feature needed NOW? (YAGNI)
4. **Size**: Are functions under 20 lines? Files under 250 lines?
5. **Complexity**: Max 3 levels of nesting? Single responsibility?
6. **Types**: TypeScript strict mode? No `any` types?
7. **Tests**: 100% coverage? Fast and deterministic?
8. **Commits**: Conventional Commits format? Issue referenced?
9. **Hooks**: All pre-commit hooks passing?
10. **Security**: No secrets committed? Dependencies scanned?

## Reference Documentation

- **CLAUDE.md**: Complete development guide for Claude Code (most comprehensive)
- **AGENTS.md**: Detailed agent personas and architectural standards
- **README.md**: Project overview for human developers
- **.cursorrules**: Cursor IDE-specific AI instructions
- **.claude/commands/**: Custom workflow commands
- **.claude/agents/**: Specialized sub-agent definitions
