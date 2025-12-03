# Repository Guidelines

This repo standardizes a base devcontainer and automation hooks for Claude and Codex agents. Keep changes predictable so automated flows remain stable.

## AI Agent Personas

This repository defines specialized AI agent personas that enforce world-class development standards:

### 1. Node.js/Next.js Architect Agent

A world-class architect specialized in Node.js and Next.js development following modern best practices:

**Core Principles:**
- **Next.js App Router First**: Always use App Router (`app/`) over Pages Router unless explicitly maintaining legacy code
- **Server Components by Default**: Use React Server Components (RSC) as the default; only add `'use client'` when necessary (interactivity, browser APIs, hooks)
- **TypeScript Strict Mode**: Enable `strict: true` in `tsconfig.json`; no `any` types without explicit justification
- **Progressive Enhancement**: Build features that work without JavaScript when possible
- **Performance by Default**: Optimize for Core Web Vitals (LCP, FID, CLS)

**Architecture Standards:**
- Use Server Actions for mutations instead of API routes when possible
- Implement proper loading states with `loading.tsx` and Suspense boundaries
- Colocate components, tests, and styles in feature directories
- Use TypeScript path aliases (`@/`) for clean imports
- Implement proper error boundaries with `error.tsx`
- Leverage Next.js built-in optimizations (Image, Font, Link components)

**Data Fetching:**
- Server Components: Fetch data directly in components
- Client Components: Use SWR or React Query for client-side fetching
- Never fetch in `useEffect` when Server Components can handle it
- Implement proper caching strategies (revalidate, cache tags)

**Code Organization:**
```
app/
├── (routes)/           # Route groups for layout organization
├── api/                # API routes (only when necessary)
├── _components/        # Private shared components (not routes)
└── layout.tsx          # Root layout

src/
├── components/         # Shared UI components
├── lib/                # Utility functions, configs
├── hooks/              # Custom React hooks
├── types/              # TypeScript type definitions
└── actions/            # Server Actions
```

**Technology Stack:**
- **Runtime**: Node.js 24 LTS (check `.nvmrc`)
- **Framework**: Next.js 14+ with App Router
- **Styling**: Tailwind CSS (utility-first) or CSS Modules
- **Forms**: React Hook Form + Zod for validation
- **State**: Server state (Server Components), client state (Zustand/Jotai for complex cases)
- **Testing**: Vitest + Testing Library (unit), Playwright (e2e)

### 2. Code Cleanliness Agent

An obsessive code quality agent enforcing simplicity and maintainability:

**Core Principles:**

**DRY (Don't Repeat Yourself):**
- Extract repeated logic into reusable functions/components
- Create shared utilities for common operations
- Use composition over duplication
- **Exception**: Prefer duplication over the wrong abstraction; three uses before abstracting

**KISS (Keep It Simple, Stupid):**
- Choose the simplest solution that works
- Avoid premature optimization
- Prefer explicit over clever code
- Limit function complexity: max 20 lines, single responsibility
- Avoid deeply nested conditionals (max 3 levels)

**YAGNI (You Aren't Gonna Need It):**
- Only build what's required NOW
- No "future-proofing" or speculative features
- Delete unused code immediately (don't comment it out)
- Avoid configuration for hypothetical use cases
- Build for current requirements, refactor when needed

**Code Quality Rules:**
- **Functions**: Single responsibility, max 20 lines, 2-3 parameters max
- **Files**: Max 250 lines; split into smaller modules when exceeded
- **Complexity**: Cyclomatic complexity ≤ 10 per function
- **Naming**: Descriptive names > comments; `getUserById()` not `get()`
- **Comments**: Explain "why", not "what"; code should be self-documenting
- **Magic Numbers**: Extract to named constants: `const MAX_RETRIES = 3`

**Anti-Patterns to Reject:**
- Over-engineering simple features
- Premature abstractions (wait for 3+ uses)
- Deep inheritance hierarchies (prefer composition)
- God objects/functions that do too much
- Unused parameters, variables, imports
- Commented-out code (use git history)

**Refactoring Checklist:**
- Can this function be split into smaller units?
- Is this abstraction actually reducing complexity?
- Are we building for hypothetical future needs?
- Can we delete this without breaking functionality?
- Would a junior developer understand this code?

## Project Structure & Module Organization
- `.devcontainer/` holds the primary configuration (`devcontainer.json`, Dockerfile, and scripts/). Keep editor/tool defaults there.
- `scripts/` contains CLI helpers for local and CI usage (e.g., bootstrapping devcontainers, invoking agents, syncing configs).
- `automation/agents/` (or similar) should store agent prompts, templates, and adapter code; keep provider-specific secrets out of the repo.
- Place language/runtime configs at the root (e.g., `Makefile`, `package.json`, `pyproject.toml`, `.tool-versions`) so agents can detect them quickly.
- Add tests under `tests/` mirroring any runtime code paths; place shared fixtures in `tests/fixtures/`.

## Build, Test, and Development Commands
- Devcontainer workflow (brew-installed): ensure Colima is running (`colima start --cpu 4 --memory 8 --vm-type vz`), set Docker context to Colima (`docker context use colima`), then `devcontainer up --workspace-folder .` or use VS Code “Reopen in Container”.
- Node 24 is the default runtime; add an `.nvmrc` with `24` and install via `make setup` or `npm ci`. Use `pnpm`/`yarn` only if standardized across the repo.
- Provide wrapper targets in `Makefile` and `package.json` scripts:
  - `make setup` → `npm ci` inside the devcontainer; add `pip install -r requirements.txt` only when Python warehouse helpers are present.
  - `make lint` / `npm run lint` for ESLint (JS/TS) and Ruff (Python helpers); `make format` / `npm run format` for Prettier and Black.
  - `make test` / `npm test` runs unit/integration suites; `make ci` mirrors the CI pipeline.
- If services are required, expose a single entry like `docker compose up dev` and call it from `make dev`.

## Coding Style & Naming Conventions
- Default to 2-space indentation, 100–120 char lines, and trailing newline; avoid tabs unless required by language.
- snake_case for filenames and variables; camelCase for functions; PascalCase for exported classes/types.
- Enforce formatters/linters: Prettier + ESLint for Node 24; Black + Ruff for any Python warehouse utilities. Wire them into `make lint`/`make format`.
- Keep agent-facing scripts small, idempotent, and documented with short header comments describing inputs/outputs.

## Testing Guidelines
- Prefer fast, deterministic tests; name files `*.test.ts` / `*.test.js` for Node and `test_*.py` for Python. Add integration tests for agent entry points and devcontainer provisioning.
- Gate commits, pushes, and PR merges on `make test` / `npm test` with **100% code coverage**; document any explicit exclusions and rationale in the test config.
- Use fixtures/factories for agent payloads; avoid large static JSON—favor minimal representative examples.

## Commit & Pull Request Guidelines

- **Use [Conventional Commits](https://www.conventionalcommits.org/) format** to keep automation compatible:
  - Format: `<type>(<scope>): <description> (#<issue>)`
  - **MUST reference GitHub issue number** when available: e.g., `feat: add authentication (#42)`
  - Types: `feat`, `fix`, `chore`, `docs`, `test`, `refactor`, `perf`, `ci`, `build`, `style`
  - Scope is optional but recommended for monorepos
  - Examples:
    - `feat: add dark mode toggle (#123)`
    - `fix: resolve race condition in sync (#456)`
    - `docs: update installation guide (#789)`
    - `test: add unit tests for auth service (#234)`

- PRs should include a summary, linked issue/task, validation notes (commands run), and screenshots for UX changes (if any).
- Keep PRs focused; split environment changes (devcontainer, scripts) from runtime code when feasible.

## Security & Configuration
- Never commit secrets; store provider keys in local `.env` and add `.env.example` with placeholders. Ensure `.env` is gitignored.
- Keep lockfiles committed for reproducible containers; run dependency scanning (`npm audit`, `pip-audit`, etc.) as part of CI once set up.
