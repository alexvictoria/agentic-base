# Work - Implement a GitHub Issue

Fetch a GitHub issue, implement it completely, and create a pull request.

## Arguments

- `<issue_number>`: The GitHub issue number to work on (required)

## Process

1. **Fetch the issue**: Use `gh issue view <issue_number>` to get the full issue details

2. **Understand the task**: Read the issue carefully:
   - What needs to be implemented?
   - What are the acceptance criteria?
   - What are the dependencies? (Make sure they're completed first)
   - What files need to be changed?

3. **Architectural planning** (if needed):
   - If the issue requires architectural decisions (choosing between approaches, designing new systems, etc.), use the `/architect` command
   - Provide the architect with:
     - The issue details
     - Relevant existing code patterns
     - Any specific constraints or requirements
   - The architect will recommend the best approach with implementation guidance
   - Skip this step for straightforward bug fixes or simple additions

4. **Check out a branch**: Create a new branch for this work:

   ```bash
   git checkout -b issue-<issue_number>-<short-description>
   ```

5. **Implement the feature**:
   - Follow the technical approach outlined in the issue
   - Adhere to existing code patterns and conventions
   - Handle errors appropriately
   - Add logging where appropriate
   - Update or add documentation as needed

6. **Write tests**:
   - Unit tests for all new functions/components
   - Integration tests for workflows or API endpoints
   - Test edge cases and error conditions
   - Ensure tests pass: run the test suite

7. **Verify completion**: Check all acceptance criteria are met

8. **Pre-commit validation**: Before committing:
   - Check if husky is installed (`ls .husky` or check package.json)
   - If husky hooks exist, they will run automatically on commit
   - If pre-commit hooks fail (linting, formatting, tests):
     - Fix the issues reported by the hooks
     - Re-run the commit
   - Common husky hooks to expect:
     - lint-staged (formatting, linting)
     - type checking
     - unit tests
   - NEVER skip hooks with `--no-verify` unless absolutely necessary

9. **Commit changes**: Create a commit message following [Conventional Commits](https://www.conventionalcommits.org/) format:
   - **Format**: `<type>(<scope>): <description> (#<issue>)`
   - **MUST include issue reference**: Use `(#<issue_number>)` at the end
   - **Types**: `feat`, `fix`, `chore`, `docs`, `test`, `refactor`, `perf`, `ci`, `build`, `style`
   - **Examples**:
     - `feat: add user authentication flow (#42)`
     - `fix: resolve race condition in data sync (#123)`
     - `test: add integration tests for API endpoints (#89)`
   - Husky pre-commit hooks will run automatically
   - If hooks modify files (e.g., prettier), review and re-commit if needed

10. **Create pull request**: Use `gh pr create`:

- Title: "Fixes #<issue_number>: <issue title>"
- Body should include:
  - Summary of changes
  - How to test
  - Checklist of acceptance criteria (all checked)
  - Notes on any implementation decisions
- Link to the issue (use "Fixes #<issue_number>")

## Guidelines

- Use `/architect` for any non-trivial architectural decisions before implementation
- Follow the issue specifications exactly
- Don't add extra features or refactoring not mentioned in the issue
- Make sure all tests pass before creating the PR
- Respect husky hooks - if they fail, fix the issues, don't skip them
- If husky hooks modify files (formatting), include those changes in the commit
- The PR should be ready for review - no TODOs or placeholders
- If you discover the issue can't be completed (missing dependencies, unclear requirements), document why and ask for guidance

## When to Use /architect

Use the `/architect` command when the issue involves:

- Choosing between multiple implementation approaches
- Designing new features or systems
- Making technology decisions (which library, pattern, etc.)
- Significant refactoring or architectural changes
- Performance optimization strategies
- Database schema design
- API design decisions

Skip `/architect` for:

- Simple bug fixes with obvious solutions
- Straightforward feature additions following existing patterns
- Minor tweaks or adjustments
- Documentation updates

## Output

- Feature branch created and pushed
- All code implemented and tested
- Pull request created and linked to the issue
- PR URL displayed for the user
