# Base Agent Standards

This repo provides the shared devcontainer and automation scaffolding for Claude, Codex, and Gemini workflows. The devcontainer ships with Node 24 plus all three CLIs (Claude Code, Codex, and Gemini) preinstalled for consistent agent behavior.

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

# 3. Setup MCP (Playwright browser automation)
.devcontainer/setup-playwright-mcp.sh
claude mcp list  # Verify installation

# 4. Setup project
make setup          # Install dependencies (npm ci)
make build          # Build TypeScript code
make lint           # Run linters
make test           # Run tests (100% coverage required)
make ci             # Run full CI pipeline locally

# Alternative: Use npm directly
npm ci              # Install dependencies
npm run build       # Build TypeScript code
npm run lint        # Run linters
npm test            # Run tests
npm run ci          # Run full CI pipeline
```

### Build System

This repository uses **npm as the primary build system**, with **Makefile providing generic wrapper commands** for convenience. All make targets delegate to npm scripts in `package.json`.

Run `make help` to see all available targets.

## Network Isolation

The devcontainer runs with **strict iptables firewall rules** that:

- Block all outbound traffic by default
- Allow only specific domains via ipset (GitHub, npm registry, Anthropic API, VS Code marketplace, etc.)
- Allow HTTP (port 80) and HTTPS (port 443) for Playwright browser automation
- Run on container start via `init-firewall.sh` (requires NET_ADMIN and NET_RAW capabilities)

**Important**: When adding new external dependencies or APIs, you must update `init-firewall.sh` to include the domain in the allowed list.

**Playwright Exception**: HTTP/HTTPS traffic is allowed for browser automation and testing via Playwright MCP. While this relaxes the firewall for web traffic, other protocols (FTP, SMTP, etc.) remain blocked.

## Specialized Sub-Agents

AI-powered experts in `.claude/agents/`:

- **`/architect`**: Full-stack architecture guidance (Next.js, APIs, databases, LLM integration)
- **`/refactor`**: Ruthless code simplification (enforces DRY, KISS, YAGNI hard limits)

These sub-agents work in their own context windows for deep analysis without consuming your main conversation.

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

## Next.js/Node.js Architecture Standards

For Next.js projects, follow these architectural guidelines:

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

## Security

- **Never commit secrets** (API keys, tokens)
- Store in `.env` (gitignored) with `.env.example` for placeholders
- Commit lockfiles for reproducibility
- Network isolation via firewall enforces external dependency allowlist
- Run dependency scanning (`npm audit`, `pip-audit`) in CI

## UI Development and Verification

When working on UI tasks, **ALWAYS** use Playwright MCP in headless mode to verify work before declaring completion:

**Requirements**:

- All screenshots must be 600x800 pixels (configured in `playwright.config.ts`)
- Always use headless mode for verification (default setting)
- Verify UI in browser before marking task complete
- Store verification screenshots in `screenshots/` directory (committed to repo)

**Workflow**:

1. Implement UI changes
2. Use Playwright MCP to verify in headless mode:
   ```
   Use Playwright in headless mode to navigate to localhost:3000 and take a screenshot
   ```
3. Review screenshot for correctness
4. Only mark task complete after verification passes
5. Include screenshots in PR for review

**Example verification commands**:

```
Use Playwright to verify the login page renders correctly at localhost:3000/login
Use Playwright to test the dark mode toggle on the settings page
Use Playwright to capture the mobile viewport of the dashboard
```

**Benefits**:

- Catch UI regressions before committing
- Small screenshots (600x800) save repo space
- Headless mode enables fast, automated verification
- Screenshots provide visual documentation in PRs

## File Organization

```
.devcontainer/      # Docker environment with network isolation
.claude/
├── agents/         # Specialized sub-agent definitions
└── commands/       # Custom slash commands for workflows
scripts/            # CLI helpers for local and CI usage
tests/              # Test files mirroring runtime code paths
AGENTS.md           # Detailed agent personas and standards
CLAUDE.md           # Complete development guide for Claude Code (most comprehensive)
GEMINI.md           # Repository guidelines for Google Gemini CLI
```
