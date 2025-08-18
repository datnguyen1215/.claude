---
description: "Solve engineering problems with minimal, simple solutions"
allowed-tools: ["*"]
---

# Engineer Command

## MANDATORY FIRST STEP - Check Project Rules

Before starting ANY engineering task, you MUST:

1. Run `LS rules/` to see available rules
2. Read rules relevant to: $ARGUMENTS
3. Apply these rules throughout your implementation

You are now in **ENGINEER MODE**. Solve this engineering task: $ARGUMENTS

## Core Principles

1. **Minimal Solution**: Find the simplest approach with the least code changes
2. **Understand First**: Quickly understand the problem and existing code patterns
3. **Direct Implementation**: Implement straightforward solutions directly
4. **Scale Complexity**: Only add planning overhead for genuinely complex tasks

## Rules Integration

When working on tasks, check available project-specific rules:

- List available rules: `LS rules/`
- Read relevant rules based on current task/todo
- Only read rules that haven't been read before in the current session

## Approach

**For Simple Tasks** (bug fixes, small features):

- Understand the problem
- Find the minimal code change needed
- Implement and verify

**For Complex Tasks** (major features, architecture changes):

- Research existing patterns and structure
- Create todo list for multi-step implementation
- Plan integration points and dependencies
- Implement incrementally

## Implementation Guidelines

- **Prefer existing patterns** over creating new ones
- **Modify existing files** rather than creating new ones when possible
- **Follow code conventions** already established in the codebase
- **Test changes** by running available linting/testing commands
- **Keep it simple** - avoid over-engineering solutions
- **No Automatic Documentation** - Never create or write documentation, reports, summaries, test results, or any explanatory files (_.md, _.txt, README, etc.) unless explicitly requested by the user. Output results to console only, not to files

## Working Directory Management

**NEVER use `cd` to change directories. Run commands from the workspace root.**

Examples:
- `npm --prefix ./projects/myapp install`
- `python ./projects/myproject/script.py`
- `pytest ./projects/myproject/tests/`
- `yarn --cwd ./projects/myapp test`

## Server Testing Protocol

When testing requires running a server:

1. **Start server in tmux session**: Use `tmux new-session -d -s project-test-server 'command'` (use unique project-based session name)
2. **Read logs from tmux**: Use `tmux capture-pane -t project-test-server -p` to view output
3. **Close tmux session**: Use `tmux kill-session -t project-test-server` when done
4. **NEVER kill all tmux sessions** - only close the specific test session

Start by understanding the problem and identifying the simplest solution.
