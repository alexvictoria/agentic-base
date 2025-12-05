# Plan Breakdown - Break Epic into Stories

You are in architect mode. Read the plan from `.plan/current-plan.md` and autonomously break it down into individually deliverable stories.

## Process

1. **Read the plan**: Load and understand `.plan/current-plan.md`

2. **Identify stories**: Break the epic into logical, deliverable chunks:
   - Each story should be independently valuable
   - Stories should have clear dependencies (what must come before what)
   - Stories should be small enough to complete in one focused session
   - Consider: data models, APIs, UI components, integrations, testing, docs

3. **Write detailed stories**: For each story, create `.plan/story-NNN.md` with:
   - **Title**: Clear, descriptive title
   - **Overview**: What this story delivers and why
   - **Dependencies**: Which other stories must be completed first (by story number)
   - **Technical approach**: Specific implementation guidance
   - **Files to modify/create**: List of expected file changes
   - **Testing requirements**:
     - Unit tests for all new functions/components
     - Integration tests for API endpoints or workflows
     - Test edge cases and error conditions
     - Maintain or improve code coverage
     - All tests must pass before PR creation
   - **Acceptance criteria**: Specific, testable conditions for "done"
   - **Standards reminder**:
     - Follow existing code patterns and conventions
     - Use TypeScript strict mode (or equivalent type safety)
     - Handle errors appropriately
     - Add appropriate logging
     - Update documentation if needed
     - Code must pass all husky pre-commit hooks:
       - Linting (ESLint, etc.)
       - Formatting (Prettier, etc.)
       - Type checking
       - Unit tests (if configured in hooks)
     - NEVER skip husky hooks with --no-verify
     - If hooks modify files, include changes in commit

4. **Create dependency map**: Write `.plan/dependency-map.md` showing:
   - List of all stories with their numbers
   - Dependency graph (which stories depend on which)
   - Suggested implementation order

## Guidelines

- Be thorough and specific - these stories will be implemented autonomously
- Each story should be completable without additional context
- Include enough technical detail that an engineer can execute
- Don't be afraid to create more stories rather than bigger stories
- Number stories starting from 001

## Output

After completion, `.plan/` should contain:

- `current-plan.md` (unchanged from plan-chat)
- `story-001.md`, `story-002.md`, etc. (detailed stories)
- `dependency-map.md` (dependency graph and implementation order)
