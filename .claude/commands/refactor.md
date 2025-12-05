# Refactor - DRY/YAGNI/KISS Expert

Launches a specialized refactoring expert sub-agent to ruthlessly eliminate complexity, duplication, and speculative code following DRY, KISS, and YAGNI principles.

## Instructions for Claude Code

When this command is invoked:

1. **Read the agent definition**:

   ```text
   Read .claude/agents/refactor-expert.md
   ```

2. **Ask the user what to refactor**:

   ```text
   What code would you like me to refactor?

   Options:
   - Specific file path (e.g., "src/components/UserProfile.tsx")
   - Directory to analyze (e.g., "src/lib/")
   - Code snippet (paste the code)
   - Current file (if working in a file)
   - Entire codebase scan for violations
   ```

3. **Read the code if file/directory provided**:
   - Use Read tool for specific files
   - Use Glob tool for directories

4. **Launch the sub-agent**:

   ```text
   Use the Task tool with:
   - subagent_type: "general-purpose"
   - description: "Refactor code for DRY/KISS/YAGNI"
   - prompt: "[Full content from .claude/agents/refactor-expert.md]

   The user wants to refactor the following code:
   [File path(s) and/or code contents]

   Follow the process outlined in your agent definition to provide comprehensive refactoring recommendations."
   ```

5. **After the sub-agent completes**, summarize the key refactorings and total improvements.
