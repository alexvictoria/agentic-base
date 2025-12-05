# Claude Specialized Agents

This directory contains specialized agent definitions that can be launched as sub-agents via slash commands. Sub-agents work autonomously with their own context windows, allowing them to handle complex tasks without polluting your main conversation.

## Available Agents

### Fullstack Architect Agent (`fullstack-architect.md`)

**Purpose**: Full-stack architecture expert for modern web applications

**Expertise**:
- **Frontend**: Next.js App Router, Server Components, TypeScript, React patterns
- **Backend**: Node.js, Express, Fastify, API architecture
- **APIs**: REST, JSON:API 1.1, OpenAPI 3.1, GraphQL, Server Actions
- **Database**: PostgreSQL, PostgREST, Prisma, Drizzle, migrations
- **AI/ML**: LLM integration (OpenAI/Anthropic), embeddings, RAG, prompt engineering
- **Standards**: HTTP/REST best practices, API versioning, error handling
- **Auth**: next-auth, JWT, RBAC, session management
- **Performance**: Caching strategies, bundle optimization, database optimization
- **Testing**: Unit, integration, E2E testing with 100% coverage requirements
- **Security**: Input validation, CSRF, XSS, SQL injection prevention

**When to Use**:
- Designing new features or major components
- Making technology selection decisions
- Optimizing performance bottlenecks
- Planning scalable API architectures
- Evaluating trade-offs between approaches

**Launch via**: `/architect` command

---

### Refactor Expert Agent (`refactor-expert.md`)

**Purpose**: DRY/YAGNI/KISS refactoring expert for code quality improvement

**Expertise**:
- Identifying and eliminating code duplication (DRY)
- Removing complexity and over-engineering (KISS)
- Deleting dead code and speculative features (YAGNI)
- Enforcing strict code limits (20 lines/function, 250 lines/file, 3 levels nesting)
- Reducing nesting and improving readability
- Extracting functions and simplifying logic

**When to Use**:
- Code review reveals complexity or duplication
- Proactive maintenance to keep codebase clean
- After feature completion to simplify implementation
- Eliminating technical debt
- Ensuring code meets CLAUDE.md quality standards

**Launch via**: `/refactor` command

---

### Agent Sync Specialist (`agent-sync-specialist.md`)

**Purpose**: Documentation synchronization expert for keeping all project documentation consistent

**Expertise**:
- Synchronizing directives across CLAUDE.md, AGENTS.md, GEMINI.md, README.md, .cursorrules
- Identifying source of truth among documentation files
- Detecting inconsistencies and contradictions
- Preserving each file's unique purpose and audience
- Creating missing documentation files when requested

**When to Use**:
- After updating any documentation file
- When adding new development standards or workflows
- To verify documentation integrity
- Before starting a new feature to ensure latest guidelines
- After major refactoring or architectural changes

**Launch via**: `/sync-agents` command

---

## How Agents Work

### Agent Invocation

1. **User invokes slash command**: `/architect` or `/refactor`
2. **Command reads agent definition**: From this directory
3. **Command prompts user**: For specific question or code to analyze
4. **Command launches sub-agent**: Using Task tool with `subagent_type="general-purpose"`
5. **Sub-agent works autonomously**: With full access to tools and codebase
6. **Sub-agent returns results**: Comprehensive guidance or refactoring recommendations
7. **Main agent summarizes**: Key takeaways for the user

### Context Management

Sub-agents have their own context windows, which provides several benefits:

- **Main conversation stays clean**: Long analysis doesn't consume your main context
- **Deep exploration**: Sub-agents can use 80-90% of their context for thorough analysis
- **Parallel work**: Multiple sub-agents can work simultaneously
- **Focused expertise**: Each agent has specialized knowledge for its domain

### Agent Structure

Each agent definition file contains:

1. **Role and Mission**: What the agent does and its goals
2. **Core Expertise**: Detailed knowledge base and best practices
3. **Mandatory Principles**: DRY, KISS, YAGNI limits from CLAUDE.md
4. **Task Instructions**: How to approach user requests
5. **Output Format**: Structure for deliverables

## Creating New Agents

To create a new specialized agent:

1. **Create agent definition**: `my-agent.md` in this directory
   ```markdown
   # My Agent Title

   You are a specialized [domain] expert sub-agent...

   ## Your Role
   [Description of what this agent does]

   ## Core Expertise
   [Detailed knowledge and best practices]

   ## Your Task
   [Instructions for handling user requests]

   ## Output Format
   [Structure for deliverables]
   ```

2. **Create slash command**: `.claude/commands/my-agent.md`
   ```markdown
   # My Agent - Brief Description

   Launches specialized sub-agent for [purpose]

   ## Instructions for Claude Code

   When this command is invoked:
   1. Read .claude/agents/my-agent.md
   2. Get user input for [specific need]
   3. Launch sub-agent with Task tool
   4. Pass agent definition and user input
   5. Summarize results
   ```

3. **Document in commands README**: Add to `.claude/commands/README.md`

## Best Practices

### When to Use Sub-Agents

✅ **Use sub-agents for**:
- Complex analysis requiring deep exploration
- Specialized domain expertise (architecture, refactoring, security)
- Tasks that might consume significant context
- Autonomous work that can run independently
- Situations where multiple perspectives help

❌ **Don't use sub-agents for**:
- Simple, quick tasks (reading a file, making small edits)
- Tasks requiring frequent back-and-forth with user
- Very short operations (< 5 minutes)

### Agent Design Principles

1. **Single Responsibility**: Each agent should have one clear purpose
2. **Comprehensive Knowledge**: Include all relevant expertise in the definition
3. **Clear Instructions**: Specific steps for handling requests
4. **Structured Output**: Define expected deliverable format
5. **Quality Standards**: Enforce CLAUDE.md principles (DRY, KISS, YAGNI)
6. **Commit Standards**: All agents MUST follow [Conventional Commits](https://www.conventionalcommits.org/):
   - Format: `<type>(<scope>): <description> (#<issue>)`
   - **Always reference GitHub issue number** when available
   - Types: `feat`, `fix`, `chore`, `docs`, `test`, `refactor`, `perf`, `ci`, `build`, `style`
   - Examples: `feat: add authentication (#42)`, `fix: resolve memory leak (#123)`

### Integration with Workflows

Agents can be combined with the feature development workflow:

```bash
# Architecture-driven feature development
/architect              # Design approach and architecture
/plan-chat              # Plan implementation collaboratively
/plan-breakdown         # Break into stories
/autocommit 1-5         # Implement autonomously
/refactor               # Clean up and simplify

# Quality-focused development
/work 42                # Implement a feature
/refactor               # Refactor the implementation
/architect              # Validate architectural decisions

# Codebase health
/refactor               # Scan for violations
# Address violations
/refactor               # Verify improvements
```

## Agent Capabilities

All agents have access to:
- **Read**: Read any file in the codebase
- **Glob**: Find files by pattern
- **Grep**: Search code for keywords
- **Bash**: Run terminal commands (if needed)
- **WebFetch**: Fetch external documentation (if needed)
- **WebSearch**: Search for information (if needed)

Agents are focused on **analysis and recommendation**, not implementation. They provide:
- Comprehensive analysis
- Specific recommendations
- Code examples and patterns
- Implementation guidance

The main conversation or `/work` command handles actual implementation.

## Directory Structure

```
.claude/
├── agents/              # Specialized agent definitions (THIS DIRECTORY)
│   ├── README.md        # This file
│   ├── fullstack-architect.md     # Node.js/Next.js architecture expert
│   ├── refactor-expert.md         # DRY/YAGNI/KISS refactoring expert
│   └── agent-sync-specialist.md   # Documentation synchronization expert
│
└── commands/            # Slash commands that launch agents
    ├── README.md
    ├── architect.md     # Launches architect agent
    ├── refactor.md      # Launches refactor agent
    ├── sync-agents.md   # Launches agent-sync-specialist
    ├── work.md          # Implementation workflow
    ├── plan-chat.md     # Planning session
    ├── plan-breakdown.md
    ├── plan-create.md
    ├── autocommit.md
    └── setup-husky.md
```

## Contributing

When adding new agents:
1. Ensure agent has clear, single purpose
2. Include comprehensive domain knowledge
3. Define structured output format
4. Enforce CLAUDE.md quality standards
5. Document in this README
6. Create corresponding slash command
7. Update `.claude/commands/README.md`
8. Test agent with realistic scenarios
