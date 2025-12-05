# Sync Agents - Documentation Synchronization Command

Synchronizes all project documentation files to ensure consistency and accuracy across:

- **CLAUDE.md** - Machine instructions for Claude Code AI
- **AGENTS.md** - Repository guidelines and standards for OpenAI Codex
- **GEMINI.md** - Repository guidelines and standards for Google Gemini CLI
- **README.md** - Project overview and quick start for human developers
- **.cursorrules** - Cursor IDE-specific rules

## Usage

```
/sync-agents                    # Synchronize existing files only
/sync-agents --create-missing   # Also create any missing documentation files
```

## Instructions for Claude Code

When this command is invoked:

1. **Check for arguments**:
   - If user includes `--create-missing` or asks to create missing files, set `createMissing: true`
   - Otherwise, set `createMissing: false` (default)

2. **Launch the agent-sync-specialist sub-agent**:

   ```text
   Use the Task tool with:
   - subagent_type: "general-purpose"
   - description: "Synchronize documentation files"
   - prompt: See below
   ```

3. **Sub-agent prompt**:

   ```text
   You are a documentation synchronization expert. Your task is to synchronize all project documentation files to ensure consistency.

   ## Documentation Files to Synchronize

   - CLAUDE.md - Machine instructions for Claude Code AI
   - AGENTS.md - Repository guidelines for OpenAI Codex
   - GEMINI.md - Repository guidelines for Google Gemini CLI
   - README.md - Project overview for human developers
   - .cursorrules - Cursor IDE-specific rules

   ## Create Missing Files Mode: [true/false]

   If "true": Create any missing documentation files based on existing ones as the source of truth.
   If "false": Only synchronize files that already exist. Report which files are missing but do NOT create them.

   ## Your Task

   1. **Analyze**: Read all existing documentation files to identify the source of truth
   2. **Report Missing**: List any documentation files that don't exist
   3. **Compare**: Detect inconsistencies in directives across existing files
   4. **Synchronize**: Update existing files to ensure consistency while preserving each file's unique purpose
   5. **Create** (only if Create Missing Files Mode is true): Generate missing files based on existing documentation
   6. **Verify**: Confirm all existing files are consistent

   ## Critical Directives to Synchronize

   Ensure these key directives are consistent across all files:

   - **Code Quality**: DRY, KISS, YAGNI principles; TypeScript strict mode; no `any` types
   - **Testing**: Coverage requirements; test output modes; pre-commit validation
   - **Git Workflow**: Conventional Commits; never commit to main; never force push
   - **Development Environment**: Node.js version; tech stack; MCP setup
   - **Project Structure**: File organization; import aliases; naming conventions
   - **Security**: No secrets in code; input validation; authentication patterns

   ## Expected Output

   Provide:

   1. **Analysis Summary**: Which file is the source of truth
   2. **Missing Files**: List files that don't exist (and whether they were created)
   3. **Directive Comparison Table**: Status of each directive across existing files
   4. **Changes Required**: Specific updates needed for each file
   5. **Implementation**: Make actual file updates with explanations
   6. **Verification**: Confirm all files are synchronized

   ## Guidelines

   - Preserve each file's unique purpose and format
   - Do NOT create missing files unless Create Missing Files Mode is true
   - Don't remove content unless contradictory or outdated
   - Maintain cross-references between files
   - Ask for clarification when contradictions are found

   Now, analyze all documentation files and synchronize them.
   ```

4. **After the sub-agent completes**, summarize:
   - Files that were updated
   - Files that are missing (and whether they were created)
   - Key changes made
   - Any issues that need manual review

## When to Use This Command

Run `/sync-agents` when:

- You've updated any documentation file (CLAUDE.md, AGENTS.md, GEMINI.md, README.md)
- You've added new development standards or workflows
- You want to ensure all documentation is consistent
- You've onboarded to a project and want to verify documentation integrity
- Before starting a new feature to ensure you have the latest guidelines
- After a major refactoring or architectural change

Run `/sync-agents --create-missing` when:

- You want to generate missing documentation files (GEMINI.md, .cursorrules, etc.)
- Setting up a new project that needs all documentation files

## Notes

- By default, missing files are reported but NOT created
- Use `--create-missing` flag to create missing documentation files
- The agent preserves each file's unique purpose and format
- No content is removed unless it's contradictory or outdated
- Cross-references between files are maintained
