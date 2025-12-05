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
- Claude Code, Codex, and Gemini CLIs pre-installed globally
- Default shell: zsh with powerline10k theme

### BuildKit Optimization

The devcontainer uses **Docker BuildKit** for faster builds with advanced caching:

**Setup (one-time)**:

```bash
# Install buildx plugin for colima
mkdir -p ~/.docker/cli-plugins
BUILDX_VERSION=0.30.1
curl -sSL "https://github.com/docker/buildx/releases/download/v${BUILDX_VERSION}/buildx-v${BUILDX_VERSION}.darwin-arm64" \
  -o ~/.docker/cli-plugins/docker-buildx
chmod +x ~/.docker/cli-plugins/docker-buildx
```

**Features enabled**:

- **Cache mounts**: npm cache persists across builds (~50s → 0.5s on rebuilds)
- **Pinned CLI versions**: Prevents unnecessary re-downloads (versions in `devcontainer.json`)
- **Layer caching**: Reuses unchanged layers automatically
- **Inline cache**: `BUILDKIT_INLINE_CACHE=1` for better cache reuse

**Build performance**:

- First build: ~3-4 minutes (downloads all dependencies)
- Rebuild with cache: ~5-10 seconds (only changed layers)
- CLI update: ~1 minute (only reinstalls changed packages)

**Verification**:

```bash
docker buildx version  # Should show v0.30.1+
docker buildx ls       # Should show colima builder active
```

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

This repository uses **Makefile as the primary interface** for all development tasks. Makefile targets delegate to npm scripts, which in turn run the actual build tools. This provides a consistent interface across host development, devcontainer development, and GitHub Actions CI.

### Standard Commands

**Use Makefile commands** (preferred for consistency):

- `make setup` → Install dependencies and set up git hooks
- `make build` → Build TypeScript code
- `make lint` → Run ESLint
- `make lint-fix` → Run ESLint with --fix
- `make format` → Format code with Prettier
- `make format-check` → Check code formatting
- `make test` → Run test suite with 100% coverage requirement
- `make ci` → Run full CI pipeline (lint + format-check + test + build)
- `make clean` → Remove generated files

**npm scripts** are also available but Makefile is preferred for uniformity:

- `npm ci` = `make setup`
- `npm run build` = `make build`
- `npm run lint` = `make lint`
- `npm run format` = `make format`
- `npm test` = `make test`
- `npm run ci` = `make ci`

Run `make help` to see all available targets.

## Code Quality Standards

### Completion Requirements (Definition of Done)

**CRITICAL**: Before claiming ANY task is complete, you MUST verify all quality gates pass:

1. **Run `make lint`** - All ESLint warnings and errors MUST be fixed
   - Zero warnings allowed
   - Zero errors allowed
   - If lint fails, the task is NOT complete

2. **Run `make test`** - 100% code coverage REQUIRED
   - All tests must pass
   - Coverage must be 100% for branches, functions, lines, and statements
   - If coverage is less than 100%, the task is NOT complete

3. **Run `make format-check`** - All files MUST be properly formatted
   - Zero formatting violations allowed
   - Run `make format` to auto-fix if needed
   - If format-check fails, the task is NOT complete

4. **Run `make build`** - TypeScript compilation MUST succeed
   - Zero build errors allowed
   - If build fails, the task is NOT complete

**Shortcut**: Run `make ci` to check all gates at once (lint + format-check + test + build)

**Never** claim completion without verifying these gates. **Never** commit code that fails these checks.

### Coverage and Testing Requirements

- **100% code coverage** required for all commits, pushes, and PR merges
- Block any coverage regression unless explicitly documented
- Test files: `*.test.ts` / `*.test.js` (Node) or `test_*.py` (Python)
- Run full test suite before any commit: `make test`

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

### Husky Git Hooks

This repository uses Husky git hooks for quality enforcement:

**Pre-commit hook** (`.husky/pre-commit`):

- Runs `lint-staged` on staged files only
- Auto-fixes with ESLint and Prettier
- Fast, focused checks on changed files

**Pre-push hook** (`.husky/pre-push`):

- Runs full `make ci` pipeline
- Enforces 100% test coverage
- Catches all issues before pushing

**Setup**: Hooks install automatically when you run `make setup` (via the `prepare` npm script).

**NEVER** skip hooks with `--no-verify` - they prevent broken code from entering the repository.

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
├── Dockerfile           # Node 24 + Python + Claude/Codex/Gemini CLIs
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

## Specialized Sub-Agents

This repository includes specialized sub-agents in `.claude/agents/` that provide expert guidance:

### `/architect` - Full-Stack Architecture Expert

Launches a specialized sub-agent (`fullstack-architect`) with comprehensive full-stack expertise to provide architectural guidance:

- Analyzes your codebase to understand existing patterns
- Proposes 2-3 architectural approaches with detailed trade-offs
- Provides specific implementation guidance with code examples
- **Frontend**: Next.js, React, Server Components, TypeScript
- **Backend**: Node.js, Express, Fastify, API design
- **APIs**: REST, JSON:API 1.1, OpenAPI 3.1, GraphQL, Server Actions
- **Database**: PostgreSQL, PostgREST, Prisma, pgvector
- **AI/ML**: LLM integration (OpenAI/Anthropic), embeddings, RAG, function calling
- **Standards**: HTTP best practices, API versioning, security patterns
- Enforces DRY, KISS, YAGNI principles while meeting production requirements
- Works in own context window (doesn't consume main conversation)

**Use when**: Designing new features, making technology decisions, API architecture, LLM integration, database design, optimizing architecture

### `/refactor` - DRY/YAGNI/KISS Refactoring Expert

Launches a specialized sub-agent (`refactor-expert`) focused on ruthless code simplification:

- Identifies all DRY, KISS, YAGNI violations with specific file:line references
- Enforces HARD LIMITS: 20 lines/function, 250 lines/file, 3 levels nesting
- Removes dead code, commented code, unused abstractions
- Extracts repeated logic (only after 3+ occurrences)
- Provides before/after examples with measurable improvement metrics
- Works in own context window (doesn't consume main conversation)

**Use when**: Code review reveals complexity, proactive maintenance, post-feature cleanup, eliminating technical debt

## Custom Workflow Commands

This repository includes custom slash commands in `.claude/commands/` for feature development:

### Planning and Breakdown

1. **`/plan-chat`** - Interactive planning session (5-20 min)
   - Collaborative discussion of approach and architecture
   - Outputs: `.plan/current-plan.md`

2. **`/plan-breakdown`** - Autonomous story breakdown
   - Breaks epic into individually deliverable stories
   - Outputs: `.plan/story-NNN.md`, `.plan/dependency-map.md`
   - Includes testing requirements, acceptance criteria, dependencies

3. **`/plan-create`** - Convert plans to GitHub issues
   - Creates GitHub issues via `gh` CLI
   - Outputs: `.plan/issue-mapping.md` (story → issue mapping)

### Implementation

4. **`/work <issue_number>`** - Implement single issue
   - Fetches issue, creates branch, implements with tests, creates PR
   - Respects husky hooks (never skips with --no-verify)
   - Returns PR URL

5. **`/autocommit <issue_numbers>`** - Autonomous multi-issue workflow
   - Takes issue numbers (e.g., `4-7` or `4 5 6 7`)
   - Determines dependency order (DAG)
   - For each issue, spawns sub-agents for:
     - Work (implement + create PR)
     - Code review (thorough review)
     - Feedback (address review comments)
   - Iterates until approved (max 3 attempts)
   - Auto-merges approved PRs
   - **Context management**: Each sub-agent gets fresh context window (can use 80-90%), main thread stays minimal
   - Can run autonomously for hours

### Typical Workflow

```bash
/plan-chat                # Interactive planning
/plan-breakdown           # Break into stories
/plan-create              # Create GitHub issues
/autocommit 1-10          # Autonomous implementation
```

### UI Development and Verification

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
