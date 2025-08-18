# Version Control & GitHub Workflow Operations

## Detection Keywords
**Primary**: git, github, commit, push, pull, merge, branch, repository
**Context**: version control, pull request, issue tracking, repository management
**Intent**: git operations, github workflow, clean commits, collaboration
**Negative**: local files only, no version control needed

## When This Rule Applies
- Making git commits
- Creating pull requests  
- Managing GitHub issues
- Repository operations
- Branch management
- Code collaboration workflows

## Core Guidelines
Apply this rule for all git commits and GitHub operations:
- Making commits
- Creating pull requests
- Managing issues
- Repository operations

## Commit Message Guidelines

### ✅ DO: Clean, Professional Commits
```bash
# Good examples
git commit -m "Add user authentication middleware"
git commit -m "Fix memory leak in data processor
- Implement proper cleanup in event handlers
- Add unit tests for edge cases"

git commit -m "Update API documentation
- Add examples for new endpoints
- Fix typos in parameter descriptions"
```

### ❌ DON'T: Attribution in Commits
```bash
# Bad examples - never do this
git commit -m "Add feature @claude"
git commit -m "Fixed by @author"
git commit -m "Co-authored-by: Claude"
```

## GitHub Operations: Use `gh` Tool

### Standard Operations
```bash
# Create PR (gh is already authenticated)
gh pr create --title "Feature: user auth" --body "Implementation details"

# List issues
gh issue list --state open

# Create issue
gh issue create --title "Bug: login fails" --body "Steps to reproduce..."

# Review PR
gh pr review 123 --approve
gh pr review 123 --request-changes --body "Please fix..."

# Clone repos
gh repo clone owner/repo

# Check status
gh status
```

### Benefits
- **Pre-authenticated**: No setup needed
- **Consistent API**: Same commands across projects  
- **Rich features**: Full GitHub integration
- **Clean output**: Better than web interface for automation

## Quick Reference
- ✅ **Commits**: Descriptive, no attribution tags
- ✅ **GitHub**: Always use `gh` tool
- ❌ **Never**: Include @claude, @author, Co-authored-by Claude
- ❌ **Never**: Use git+web when `gh` available