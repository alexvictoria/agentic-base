# Plan Create - Convert Plans to GitHub Issues

Read all the story files from `.plan/` and create GitHub issues for each one.

## Process

1. **Read all stories**: Load all `.plan/story-*.md` files

2. **Check GitHub setup**: Verify we're in a git repo with GitHub remote configured

3. **Create issues**: For each story file, create a GitHub issue using `gh issue create`:
   - Use the story title as the issue title
   - Use the full story content as the issue body
   - Add appropriate labels (e.g., `feature`, `story`, `planned`)
   - If the story has dependencies, note them in the issue body

4. **Track mapping**: Create `.plan/issue-mapping.md` that maps:
   - Story number → GitHub issue number
   - This is critical for the /work and /autocommit commands

5. **Update dependency map**: Update `.plan/dependency-map.md` to include GitHub issue numbers

## Example Issue Format

```
Title: [Story 003] Implement user authentication API

Body:
# Story 003: Implement user authentication API

[Full content from story-003.md]

---
**GitHub Issue Created**: #42
**Dependencies**: Requires #40 (Story 001), #41 (Story 002)
```

## Guidelines

- Preserve all story details in the GitHub issue
- Make sure dependencies are clearly noted
- The issue should be fully self-contained
- Don't create issues for stories that are already implemented

## Output

- GitHub issues created for all stories
- `.plan/issue-mapping.md` created with story → issue number mapping
- Console output showing created issue numbers
