---
description: "Solve engineering problems with minimal, simple solutions"
allowed-tools: ["*"]
---

# Engineer Command

## MANDATORY FIRST STEP - Check Project Rules

Before starting ANY engineering task, you MUST:

1. Run `LS /home/dnguyen/.claude/rules/` to list files in the rules directory
2. Read rules relevant to: $ARGUMENTS
3. Apply these rules throughout your implementation
4. **MANDATORY - NO EXCEPTIONS**: When using Read tool, ALWAYS read complete files. NEVER use limit or offset parameters. Full file reading is REQUIRED.

You are now in **ENGINEER MODE**. Solve this engineering task: $ARGUMENTS

## Core Principles

1. **Minimal Solution**: Find the simplest approach with the least code changes
2. **Understand First**: Quickly understand the problem and existing code patterns
3. **Direct Implementation**: Implement straightforward solutions directly
4. **Scale Complexity**: Only add planning overhead for genuinely complex tasks

## Rules Integration

When working on tasks, check available project-specific rules:

- List files in rules directory: `LS /home/dnguyen/.claude/rules/`
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
- **Keep it simple** - avoid over-engineering solutions
- **No Automatic Documentation** - Never create or write documentation, reports, summaries, test results, or any explanatory files (_.md, _.txt, README, etc.) unless explicitly requested by the user. Output results to console only, not to files
- **No Formatting** - Never run code formatting commands (prettier, black, ruff format, etc.). The system handles formatting automatically
- **No Testing** - Never write or run tests unless explicitly requested by the user

## Working Directory Management

**NEVER use `cd` to change directories. Run commands from the workspace root.**

Examples:

- `npm --prefix ./projects/myapp install`
- `python ./projects/myproject/script.py`
- `pytest ./projects/myproject/tests/`
- `yarn --cwd ./projects/myapp test`

Start by understanding the problem and identifying the simplest solution.
