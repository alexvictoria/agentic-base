# Cursor AI Rules for Agentic Base Repository

This file provides rules and guidelines for Cursor IDE's AI assistant when working in this repository.

## Repository Context

This is a base repository for AI agent workflows with strict quality gates and network-isolated devcontainer. Node.js 24, TypeScript strict mode, and 100% test coverage are mandatory.

## Core Principles - ALWAYS ENFORCE

### DRY (Don't Repeat Yourself)
- Extract repeated logic after 3+ occurrences
- Prefer duplication over wrong abstractions
- Use composition to eliminate redundancy
- Create shared utilities for common operations

### KISS (Keep It Simple, Stupid)
- Choose the simplest working solution
- **HARD LIMIT**: Max 20 lines per function
- **HARD LIMIT**: Max 250 lines per file
- **HARD LIMIT**: Max 3 levels of nesting in conditionals
- Avoid clever code; prefer explicit and readable
- No premature optimization

### YAGNI (You Aren't Gonna Need It)
- Build only what's needed NOW
- No speculative features or "future-proofing"
- Delete unused code immediately (NEVER comment out)
- No configuration for hypothetical use cases
- Refactor when requirements change, not before

## TypeScript Standards - STRICT ENFORCEMENT

- `strict: true` in `tsconfig.json` - ALWAYS
- **ZERO tolerance for `any` types** - must have explicit justification
- Use proper type inference; avoid unnecessary annotations
- Define shared types in `src/types/`
- Prefer `interface` over `type` for object shapes
- Use `unknown` instead of `any` for truly unknown types

## Next.js Best Practices - MANDATORY

### App Router First
- Use `app/` directory (NOT Pages Router)
- Server Components by default
- Only add `'use client'` when absolutely necessary:
  - Browser APIs (window, localStorage)
  - React hooks (useState, useEffect)
  - Event handlers (onClick, onChange)
  - Third-party libraries requiring client-side

### Server Actions
- Prefer Server Actions over API routes for mutations
- Use `'use server'` directive
- Proper error handling with try-catch
- Return serializable data only

### Data Fetching
- Server Components: Fetch directly in component (async/await)
- Client Components: Use SWR or React Query
- NEVER fetch in `useEffect` when RSC can handle it
- Implement caching: `revalidate`, `cache: 'force-cache'`, cache tags

### File Organization
```
app/
├── (routes)/           # Route groups for layout organization
├── _components/        # Private components (NOT routes)
├── layout.tsx          # Root layout
└── page.tsx            # Route pages

src/
├── components/         # Shared UI components
├── lib/                # Utilities, configs
├── hooks/              # Custom React hooks
├── types/              # TypeScript definitions
└── actions/            # Server Actions
```

### Next.js Optimizations - USE ALWAYS
- `<Image>` for images (NOT `<img>`)
- `<Link>` for navigation (NOT `<a>`)
- `<Font>` for fonts (next/font)
- Implement `loading.tsx` and `error.tsx` in routes
- Use Suspense boundaries for streaming

## Code Style - AUTO-ENFORCE

### Formatting
- **2 spaces** (NO tabs)
- **100-120 character** line length
- Trailing newline in all files
- Single quotes for strings (except JSX attributes)

### Naming Conventions
- Files/variables: `snake_case` (e.g., `user_profile.ts`)
- Functions: `camelCase` (e.g., `getUserById`)
- Classes/types: `PascalCase` (e.g., `UserProfile`)
- Constants: `UPPER_SNAKE_CASE` (e.g., `MAX_RETRIES`)
- Private variables: `_prefixedCamelCase` (e.g., `_internalState`)

### Imports
- Group imports: external → internal → relative
- Use TypeScript path aliases (`@/`)
- Sort alphabetically within groups
- Remove unused imports (lint-staged enforces)

## Testing - 100% COVERAGE REQUIRED

### Test Files
- Location: `tests/` mirroring runtime code paths
- Naming: `*.test.ts` / `*.test.js` (Node) or `test_*.py` (Python)
- Shared fixtures in `tests/fixtures/`

### Test Requirements
- **100% code coverage** - NO EXCEPTIONS
- Fast and deterministic (no sleeps/waits)
- Minimal static JSON; prefer factories
- Test behavior, not implementation
- Mock external dependencies

### Test Stack
- Unit: Vitest + Testing Library
- E2E: Playwright
- Run before every commit: `make test` or `npm test`

## Git Workflow - STRICT

### Conventional Commits - MANDATORY
Format: `<type>(<scope>): <description> (#<issue>)`

**MUST reference GitHub issue** when available!

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `chore`: Maintenance
- `docs`: Documentation
- `test`: Testing
- `refactor`: Code refactoring
- `perf`: Performance
- `ci`: CI/CD
- `build`: Build system
- `style`: Formatting

**Examples:**
- `feat: add dark mode toggle (#123)`
- `fix: resolve memory leak in data processor (#456)`
- `docs: update API documentation (#789)`
- `test: add unit tests for auth service (#234)`

### Git Hooks - NEVER SKIP
- Pre-commit: lint-staged (formatting, linting, type-check)
- Pre-push: tests (optional)
- **NEVER use `--no-verify`** - hooks exist for a reason

### Branch Strategy
- Never commit directly to `main`
- Branch naming: `feat/issue-123-description`, `fix/issue-456-description`
- Keep branches focused and short-lived

## Security - ZERO TOLERANCE

### Secrets Management
- **NEVER commit secrets** (API keys, tokens, passwords)
- Store in `.env` (gitignored)
- Provide `.env.example` with placeholders
- Use environment variables for all sensitive data

### Dependencies
- Commit lockfiles (`package-lock.json`, `pnpm-lock.yaml`)
- Run `npm audit` / `pip-audit` regularly
- Update dependencies via PRs, not direct commits
- Review dependency changes in PRs

### Network Isolation
- Devcontainer has strict firewall rules
- Update `init-firewall.sh` when adding external dependencies
- Test connectivity after firewall changes

## Code Quality Checklist - BEFORE EVERY COMMIT

Ask yourself:

1. **Simplicity**: Can this be simpler? (KISS)
2. **Duplication**: Is code repeated 3+ times? Extract it. (DRY)
3. **Necessity**: Is this needed NOW? (YAGNI)
4. **Size**: Functions <20 lines? Files <250 lines?
5. **Complexity**: Max 3 levels of nesting?
6. **Types**: No `any` types? Strict mode on?
7. **Tests**: 100% coverage? Tests passing?
8. **Commits**: Conventional Commits format? Issue referenced?
9. **Hooks**: Pre-commit hooks passing?
10. **Security**: No secrets? Dependencies audited?

## Anti-Patterns - REJECT IMMEDIATELY

- God objects/functions that do too much
- Deep inheritance hierarchies (use composition)
- Premature abstractions (wait for 3+ uses)
- Commented-out code (use git history)
- Magic numbers (extract to named constants)
- Unused parameters/variables/imports
- `any` types without justification
- Skipping git hooks with `--no-verify`
- Committing directly to `main`
- Over-engineering simple features

## Code Review Standards

### Before Requesting Review
- All tests pass locally
- 100% coverage maintained
- Pre-commit hooks pass
- Conventional Commits used
- No console.log/debugger statements
- Types properly defined
- Documentation updated

### PR Requirements
- Summary of changes
- Linked GitHub issue
- Screenshots for UI changes
- Validation commands listed
- Test coverage report
- No merge conflicts

## Development Environment

### Devcontainer
- Node.js 24 LTS (check `.nvmrc`)
- Python 3 for helper scripts
- Claude Code, Codex, and Gemini CLIs pre-installed
- Playwright MCP for browser automation
- Network isolation via iptables

### Build System

This repository uses **npm as the primary build system**, with **Makefile providing generic wrapper commands** for convenience. All make targets delegate to npm scripts defined in package.json.

Run `make help` to see all available targets.

### Setup Commands
```bash
# Start Colima (macOS)
colima start --cpu 4 --memory 8 --vm-type vz
docker context use colima

# Start devcontainer
devcontainer up --workspace-folder .

# Install dependencies
make setup  # or npm ci

# Run tests
make test   # or npm test

# Lint and format
make lint   # or npm run lint
make format # or npm run format

# Run CI pipeline locally
make ci
```

## Technology Stack

- **Runtime**: Node.js 24 LTS
- **Framework**: Next.js 14+ with App Router
- **Language**: TypeScript (strict mode)
- **Styling**: Tailwind CSS or CSS Modules
- **Forms**: React Hook Form + Zod validation
- **State**: Server Components (server), Zustand/Jotai (client)
- **Testing**: Vitest + Testing Library (unit), Playwright (e2e)
- **Linting**: ESLint + Prettier (Node), Ruff + Black (Python)
- **Git Hooks**: Husky + lint-staged

## AI Assistant Behavior

### When Writing Code
1. Check if file exists - prefer editing over creating
2. Follow DRY, KISS, YAGNI principles
3. Enforce TypeScript strict mode
4. Keep functions under 20 lines
5. Keep files under 250 lines
6. Write tests for new code (maintain 100% coverage)
7. Use Conventional Commits format

### When Refactoring
1. Identify DRY/KISS/YAGNI violations
2. Provide before/after examples
3. Measure improvement (lines, complexity, duplication)
4. Ensure tests still pass
5. Maintain 100% coverage

### When Reviewing Code
1. Check for anti-patterns
2. Verify HARD LIMITS (20 lines/function, 250 lines/file, 3 nesting levels)
3. Ensure TypeScript strict mode compliance
4. Verify test coverage
5. Check commit message format
6. Look for security issues

## Specialized Sub-Agents

This repository includes specialized sub-agents in `.claude/agents/` that provide expert guidance:

### `/architect` - Full-Stack Architecture Expert

Launches a specialized sub-agent (`fullstack-architect`) with comprehensive full-stack expertise:
- Analyzes codebase to understand existing patterns
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

## Reference Files

- `CLAUDE.md`: Complete guide for Claude Code (most comprehensive)
- `AGENTS.md`: Agent personas and architectural standards
- `GEMINI.md`: Guidelines for Gemini CLI
- `README.md`: Project overview for humans
- `.claude/commands/`: Custom workflow commands
- `.claude/agents/`: Specialized sub-agents

## Quick Reference

**Max Limits:**
- Function: 20 lines
- File: 250 lines
- Nesting: 3 levels
- Coverage: 100%
- `any` types: 0 (without justification)

**Commit Format:**
`<type>(<scope>): <description> (#<issue>)`

**File Naming:**
- `snake_case.ts` (files)
- `camelCase()` (functions)
- `PascalCase` (classes/types)

**Always Run:**
```bash
make test    # Before commit
make lint    # Before commit
make format  # Before commit
make ci      # Before PR
```

---

**Remember**: These rules are not suggestions - they are requirements. Cursor AI must enforce them strictly to maintain code quality and consistency.
