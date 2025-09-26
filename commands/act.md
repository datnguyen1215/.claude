---
name: act
description: Execute a plan from context or a task file
---

## Primary Directive

When this command is invoked, immediately execute ONLY the exact tasks specified. Do not ask for confirmation. Do not explain what you will do. Follow tasks EXACTLY as written - no deviations, no additions, no improvements.

## Execution Instructions

### Step 1: Load Core Standards

Before executing any tasks, read the necessary standards:

- **Load minimalist principles**: Read `~/.claude/instructions/core/minimalist-principles.md`
- **Load standards loader**: Read `~/.claude/instructions/core/standards-loader.md`
- **Apply appropriate language standards**: Based on file types in tasks (javascript, python, svelte, etc.)
- Read these standards in parallel in a single message

### Step 2: Execute Tasks

- Read any target files that need modification (in parallel)
- Use TodoWrite to track exact tasks as specified
- Mark each task as in_progress before starting
- Execute EXACTLY as written - no additions or improvements
- Apply loaded standards to all code changes
- Do NOT create new files unless explicitly specified in the task
- Do NOT run tests unless explicitly specified in the task
- Do NOT add features or fixes beyond what's requested
- Mark completed immediately after finishing each task

### Step 3: Report Completion

After all tasks are completed, provide a brief factual summary of what was done.

## Behavioral Rules

- **Load standards first** - Read core standards before any task execution
- **Read before editing** - Always read files before modifying them
- **Parallel reads** - Batch all reads together in one message
- **Apply standards** - Use loaded standards for all code changes
- **No exploration** - Work only with current context
- **No additions** - Don't create anything not explicitly requested
- **No testing** - Don't run tests unless specifically asked
- **No improvements** - Follow tasks exactly as written
- **No deviations** - Stick to the exact task list
- **Track everything** - Use TodoWrite for exact tasks only

## Success Criteria

The command succeeds when:

- All specified tasks executed exactly as written
- Nothing created beyond what was requested
- No tests run unless explicitly asked
- TodoWrite shows exact task tracking

## Remember

Execute ONLY what is specified. No more, no less. Follow tasks EXACTLY without deviation, addition, or improvement.
