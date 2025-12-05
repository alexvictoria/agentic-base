# Feature Development Workflow Commands

This directory contains commands for a complete feature development workflow using GitHub Issues and autonomous sub-agents.

## Commands Overview

### `/plan-chat`
**Interactive planning session**
- Discuss the feature/task with Claude
- Explore codebase and understand context
- Make architectural decisions collaboratively
- Writes plan to `.plan/current-plan.md`
- Duration: 5-20 minutes depending on complexity

### `/plan-breakdown`
**Autonomous story breakdown**
- Reads `.plan/current-plan.md`
- Breaks epic into individually deliverable stories
- Creates detailed specs for each story in `.plan/story-NNN.md`
- Includes testing requirements, acceptance criteria, dependencies
- Generates dependency map for execution order

### `/plan-create`
**Convert plans to GitHub issues**
- Reads all `.plan/story-*.md` files
- Creates GitHub issues using `gh` CLI
- Tracks story → issue number mapping in `.plan/issue-mapping.md`
- Each issue is fully self-contained with all details

### `/work <issue_number>`
**Implement a single issue**
- Fetches GitHub issue details
- Creates feature branch
- Implements the feature with full testing
- Creates pull request
- Returns PR URL

### `/autocommit <issue_numbers>`
**Autonomous multi-issue workflow** ⭐
- Takes multiple issue numbers (e.g., `4-7` or `4 5 6 7`)
- Determines dependency order automatically
- For each issue:
  - Launches work sub-agent to implement and create PR
  - Launches review sub-agent to thoroughly review
  - Launches feedback sub-agent to address issues
  - Iterates until approved or max attempts
  - Auto-merges when ready
  - Reports issues that need human attention
- Uses sub-agents to manage context efficiently
- Can run for hours autonomously

### `/architect`
**Full-stack architecture expert sub-agent** 🏗️

Launches a specialized sub-agent (defined in [.claude/agents/fullstack-architect.md](../agents/fullstack-architect.md)) with comprehensive full-stack expertise.

- Analyzes codebase and proposes 2-3 architectural approaches with trade-offs
- **Expertise**: Next.js, Node.js, REST, JSON:API 1.1, OpenAPI 3.1, GraphQL, PostgREST, PostgreSQL, LLM integration (RAG, embeddings, function calling), auth, security, testing, performance
- Balances DRY, KISS, YAGNI principles with production-grade requirements
- Works in isolated context window (doesn't consume main conversation)
- **Use when**: Designing features, API architecture, database design, LLM integration, tech decisions

### `/refactor`
**DRY/YAGNI/KISS refactoring expert sub-agent** 🔧

Launches a specialized sub-agent (defined in [.claude/agents/refactor-expert.md](../agents/refactor-expert.md)) focused on ruthless code simplification.

- Identifies all DRY, KISS, YAGNI violations with specific file:line references
- Enforces HARD LIMITS: 20 lines/function, 250 lines/file, 3 levels nesting
- Removes dead code, commented code, unused abstractions
- Provides before/after examples with measurable improvement metrics
- Works in isolated context window (doesn't consume main conversation)
- **Use when**: Code review reveals complexity, proactive maintenance, post-feature cleanup

### `/sync-agents`
**Documentation synchronization specialist** 📄

Launches a specialized sub-agent (defined in [.claude/agents/agent-sync-specialist.md](../agents/agent-sync-specialist.md)) for keeping project documentation consistent.

- Synchronizes directives across CLAUDE.md, AGENTS.md, GEMINI.md, README.md, .cursorrules
- Identifies source of truth and detects inconsistencies
- Preserves each file's unique purpose and audience
- Use `--create-missing` flag to generate missing documentation files
- Works in isolated context window (doesn't consume main conversation)
- **Use when**: After updating documentation, adding new standards, or verifying documentation integrity

## Typical Workflow

### Feature Development Workflow
```bash
# 1. Start planning session (use /architect for complex features)
/plan-chat

# 2. Break down into stories (autonomous)
/plan-breakdown

# 3. Create GitHub issues
/plan-create

# 4. Auto-implement all stories
/autocommit 1-10

# Or work on specific issues
/work 5
```

### Architecture and Code Quality Workflow
```bash
# Get architectural guidance before implementing complex features
/architect
# User: "We need to add real-time notifications. What's the best approach?"

# Review and refactor code to maintain quality
/refactor
# Analyzes current file/code and suggests DRY/KISS/YAGNI improvements

# Combine with implementation workflow
/architect              # Design the feature
/plan-chat              # Plan implementation
/plan-breakdown         # Break into stories
/autocommit 1-5         # Implement
/refactor               # Clean up and simplify
```

## Quality Gates

All code must pass these automated quality gates:

- **Test Coverage**: 100% automated test coverage required before commits, pushes, or PR merges
- **Test Suite**: Full test suite (`make test` / `npm test`) must pass locally and in CI
- **Husky Hooks**: Pre-commit hooks enforce:
  - Linting (ESLint, Flake8, etc.)
  - Code formatting (Prettier, Black, etc.)
  - Type checking (TypeScript, mypy, etc.)
  - Unit tests (optional, can be in pre-push)
- **No Bypassing**: NEVER use `--no-verify` to skip hooks
- **Coverage Regression**: Block on any coverage regression unless documented and approved

These gates are enforced via husky hooks locally and CI checks remotely.

## Directory Structure

```
.plan/
├── current-plan.md          # Overall feature plan
├── story-001.md            # Individual story specs
├── story-002.md
├── ...
├── dependency-map.md       # Dependency graph
└── issue-mapping.md        # Story → GH issue mapping
```

## Key Benefits

- **Context Management**: Sub-agents get fresh context windows, preventing context exhaustion
- **Autonomous Execution**: `/autocommit` can work for hours without intervention
- **Quality**: Every PR gets thorough code review before merging
- **Traceability**: Clear mapping from plan → story → issue → PR
- **Flexibility**: Swap GitHub for JIRA or local files easily

## Requirements

- `gh` CLI installed and authenticated
- Git repository with GitHub remote
- Standard testing framework in your project
- Husky configured (runs automatically via `npm install`)
- Linting and formatting tools (ESLint, Prettier, etc.)

## Customization

Edit the command files in `.claude/commands/` to adjust:
- Testing requirements
- Code review criteria
- Merge strategies
- Issue labels and formatting
- Standards and conventions
