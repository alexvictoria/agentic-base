# Architect - Node.js/Next.js Architecture Expert

Launches a specialized full-stack architecture expert sub-agent to provide comprehensive architectural guidance for Next.js, React, APIs, databases, and AI/ML integrations.

## Instructions for Claude Code

When this command is invoked:

1. **Read the agent definition**:

   ```text
   Read .claude/agents/fullstack-architect.md
   ```

2. **Ask the user for their architectural question**:

   ```text
   What architectural question or challenge do you have?

   Examples:
   - "Should we use WebSockets, SSE, or polling for real-time notifications?"
   - "What's the best authentication approach for our API?"
   - "How should we structure our database schema for multi-tenancy?"
   - "What caching strategy should we use?"
   - "Should we use Prisma or Drizzle for our ORM?"
   - "How should we implement RAG with vector search?"
   ```

3. **Launch the sub-agent**:

   ```text
   Use the Task tool with:
   - subagent_type: "general-purpose"
   - description: "Architecture guidance for [brief description]"
   - prompt: "[Full content from .claude/agents/fullstack-architect.md]

   The user has the following architectural question:
   [User's question]

   Follow the process outlined in your agent definition to provide comprehensive architectural guidance."
   ```

4. **After the sub-agent completes**, summarize the key recommendations for the user.
