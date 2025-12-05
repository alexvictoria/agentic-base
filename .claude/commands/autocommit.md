# Autocommit - Autonomous Multi-Issue Workflow

Autonomously work through multiple GitHub issues in dependency order, with code review and auto-merge.

## Arguments

- `<issue_numbers>`: The issues to work on. Can be:
  - Space-separated: `4 5 6 7`
  - Range: `4-7`
  - Comma-separated: `4,5,6,7`

## Process

1. **Parse and fetch issues**:
   - Parse the issue numbers from arguments
   - Fetch all issues using `gh issue view`
   - Read issue content to understand each task

2. **Build dependency DAG**:
   - Analyze dependencies mentioned in each issue
   - Create a directed acyclic graph of dependencies
   - Determine the correct execution order
   - If there are circular dependencies, halt and report the problem

3. **For each batch of issues in dependency order**:

   a. **Check dependencies**: Verify all prerequisite issues are completed and merged

   b. **Execute /work commands in parallel**: For all issues in the current batch (those with no mutual dependencies):
   - Use SlashCommand tool to invoke `/work <issue_number>` for each issue
   - If multiple issues can run in parallel, invoke all `/work` commands in a single message
   - Each `/work` command will:
     - Create a branch
     - Implement the feature
     - Write tests following 100% coverage requirement
     - **Create commits using Conventional Commits format with issue reference**:
       - Format: `<type>: <description> (#<issue>)`
       - Example: `feat: add user authentication (#42)`
     - Create a PR
   - Wait for all parallel work to complete before proceeding

   c. **Launch code review agents**: For each completed PR, use the Task tool to spawn a review sub-agent:

   ```
   Task tool with subagent_type='general-purpose'
   Prompt: "Review PR #<pr_number> for issue #<issue_number>. Check:
   - Code quality and adherence to patterns
   - Test coverage and quality
   - Error handling
   - Type safety
   - Acceptance criteria met
   Provide detailed, actionable feedback."
   ```

   d. **Iterate on feedback**: If review finds issues:
   - Launch another sub-agent to address feedback:
     ```
     Task tool with subagent_type='general-purpose'
     Prompt: "Address the following code review feedback on PR #<pr_number>: <feedback>"
     ```
   - Re-review with a fresh sub-agent
   - Repeat until PR is approved or max iterations (3) reached

   e. **Handle stuck states**:
   - If after 3 iterations we're not converging, mark as "needs human review"
   - Report to user and skip to next issue
   - User can later manually resolve and resume

   f. **Merge when ready**:
   - Once code review approves, verify CI/tests pass
   - Merge the PR using `gh pr merge --auto --squash` (or preferred merge strategy)
   - Confirm merge completed
   - Move to next batch

4. **Report progress**: After completing all issues (or getting stuck):
   - Summary of completed issues and merged PRs
   - Any issues that need human attention
   - Overall status

## Guidelines

- Each sub-agent gets a fresh context window - use it fully
- The main conversation (this one) is just orchestration - keep it minimal
- Track state between issues carefully
- Don't skip dependency validation
- Be autonomous but cautious - if something looks really wrong, stop and report
- Use TodoWrite to track progress through the issue list
- **All commits MUST use Conventional Commits format with issue references**:
  - Format: `<type>: <description> (#<issue>)`
  - Types: `feat`, `fix`, `chore`, `docs`, `test`, `refactor`, `perf`, `ci`, `build`, `style`
  - Always include the GitHub issue number

## Context Management Strategy

The key to this command working for large workloads is context management:

- **Main conversation**: You're in it now. This stays small - just orchestration, tracking, decision-making. A few hundred tokens per issue.
- **`/work` slash command**: Expands its prompt inline, implements the feature, writes tests, creates PR. Efficient use of context since it's a direct command execution.
- **Review sub-agent**: Gets full context window. Can thoroughly review all code, tests, and provide detailed feedback.
- **Feedback sub-agent**: Gets full context window to address all feedback.

By using slash commands for implementation and isolating review/feedback in sub-agents, we can process many issues efficiently.

## Example Flow

```
autocommit 4-7

[Orchestrator] Fetching issues #4, #5, #6, #7...
[Orchestrator] Building dependency graph...
[Orchestrator] Execution order: #4 → #5 → (#6, #7 in parallel)

[Orchestrator] Starting batch 1: issue #4...
[/work 4] Implementing feature from issue #4...
[/work 4] Created PR #101

[Review Agent] Reviewing PR #101...
[Review Agent] Found 2 issues: missing error handling, incomplete tests
[Feedback Agent] Addressing feedback...
[Feedback Agent] Updated PR #101
[Review Agent] Re-reviewing PR #101...
[Review Agent] Approved ✓
[Orchestrator] Merging PR #101...
[Orchestrator] Issue #4 complete ✓

[Orchestrator] Starting batch 2: issues #5, #6, #7 (parallel)...
[/work 5] Implementing feature from issue #5...
[/work 6] Implementing feature from issue #6...
[/work 7] Implementing feature from issue #7...
[/work 5] Created PR #102
[/work 6] Created PR #103
[/work 7] Created PR #104
[Orchestrator] All batch 2 work complete, starting reviews...
...
```

## Output

- All specified issues worked and PRs created
- Code reviewed and feedback addressed
- PRs merged (or marked for human review)
- Summary report of all work completed
