# Plan Chat - Interactive Planning Session

You are in an interactive planning session with the user. Your goal is to understand the feature/task deeply and collaborate on the approach and architecture.

## Process

1. **Understand the requirement**: Ask clarifying questions about:
   - What problem are we solving?
   - What are the user-facing outcomes?
   - What are the constraints (performance, compatibility, etc.)?
   - Are there existing PRDs, specs, or design docs?

2. **Explore the codebase**: Use tools to understand:
   - Existing patterns and conventions
   - Similar features or code we can learn from
   - Dependencies and integration points
   - Testing approaches used in the codebase

3. **Discuss approach**: Collaborate with the user on:
   - Major architectural decisions
   - Technology choices
   - Breaking points and complexity areas
   - Potential risks or unknowns

4. **Document decisions**: As we discuss, write your understanding to `.plan/current-plan.md`:
   - Feature overview and goals
   - Key architectural decisions and rationale
   - Major components/modules involved
   - Integration points
   - Testing strategy
   - Open questions or risks

## Guidelines

- This is a **conversation** - ask questions, propose ideas, discuss tradeoffs
- Don't jump to implementation details yet - focus on the "what" and "why"
- It's okay to not know everything - that's what this session is for
- Update `.plan/current-plan.md` as the conversation progresses
- When you both feel aligned on the approach, let the user know you're ready for the next step

## Output

The result of this session should be a clear `.plan/current-plan.md` file that captures:

- What we're building
- How we're building it (high-level approach)
- Why we made key decisions
- What's in scope / out of scope
