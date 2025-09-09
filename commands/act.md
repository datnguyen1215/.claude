---
name: act
description: Execute tasks from generated task files with live updates
model: claude-opus-4-1-20250805
---

## Mode
execution

## Type
action

## Instructions
Execute tasks from tasks.md file provided in context or specified by user. Process tasks sequentially, update checkboxes in real-time, handle failures gracefully. Continue with non-dependent tasks when failures occur. Report summary directly to user without creating output files.

## Workflow
1. **CHECK_CONTEXT**: Use tasks.md path from context if available
2. **PARSE_ARGS**: Process user arguments for task selection or file path
3. **PARSE**: Extract tasks, dependencies, and current state
4. **FILTER**: Apply task selection based on arguments
5. **RESOLVE**: Build execution order respecting dependencies
6. **EXECUTE**: Run tasks with live progress updates
7. **RECOVER**: Handle failures and continue with safe tasks
8. **REPORT**: Generate execution summary

## Arguments
### Patterns
- **No args**: Execute all pending tasks
- **Single**: `T001` - Execute only T001
- **Range**: `T001-T005` - Execute T001 through T005
- **List**: `T001,T003,T007` - Execute specific tasks
- **Mixed**: `T001-T003,T007` - Combine ranges and lists
- **Path**: `path/to/tasks.md` - Use specific task file

## Task Discovery
- **Source**: Context from previous /tasks command or user-provided path
- **No context action**: Ask user for specific tasks.md file path
- **Validation**:
  - File path must be explicitly provided (no auto-discovery)
  - File exists and is readable
  - Contains valid markdown structure
  - Has at least one task
- **Error messages**:
  - No path: "Please specify the tasks.md file path or run /tasks first"
  - File not found: "The specified tasks.md file does not exist"

## Task Parsing
- **Task ID pattern**: `^### (T\d{3}):`
- **Checkbox patterns**:
  - Pending: `- [ ]`
  - In progress: `- [⏳]`
  - Completed: `- [x]`
  - Failed: `- [✗]`
  - Skipped: `- [⊘]`
- **Dependency pattern**: `*Depends on: (.*)*`
- **Extract**:
  - Task ID and title
  - Current checkbox state
  - Dependencies list
  - Task commands from code blocks
  - File references
  - Success criteria

## Live Updates
### States
- `[⏳]` Task in progress
- `[x]` Task completed
- `[✗]` Task failed
- `[⊘]` Skipped due to dependency failure

### Timing
- Update to `[⏳]` before task start
- Update to `[x]` or `[✗]` immediately after completion
- Preserve indentation and formatting
- Use Edit tool for immediate visibility

## Dependency Resolution
- **Algorithm**: Topological sort
- **Circular detection**: Enabled
- **Failure isolation**:
  - Mark failed task with `[✗]`
  - Identify all dependent tasks
  - Mark dependents as skipped `[⊘]`
  - Continue with non-dependent tasks
- **Execution order**:
  - Process in dependency order
  - Run independent tasks in parallel groups
  - Skip already completed tasks

## Allowed Tools
- Read
- Edit (for live checkbox updates)
- MultiEdit
- Bash
- Glob
- Grep
- TodoWrite

## Restrictions
- Only modify checkbox states in tasks.md
- Preserve all other formatting
- Execute commands in safe mode
- No destructive operations without confirmation

## Execution Engine
### Supported Operations
- File edits (Edit, MultiEdit)
- File creation (Write)
- Command execution (Bash)
- File reading (Read)
- Pattern searching (Grep, Glob)

### Error Handling
- Catch and log all errors
- Mark task as failed
- Continue with next safe task
- Include error in final report
- Timeout: 300000ms (5 minutes per task)

## Failure Recovery
### Detection
- Command returns non-zero exit code
- Tool operation fails
- Validation criteria not met

### Actions
- Mark task with `[✗]`
- Log failure reason
- Identify dependent tasks
- Mark dependents as skipped `[⊘]`
- Continue with non-dependent tasks
- Track for retry suggestions

## Validation
### Pre-execution
- Verify tasks.md format
- Check for duplicate task IDs
- Detect circular dependencies
- Validate tool availability
- Check write permissions

### Dry Run (optional)
- Shows tasks to be executed
- Shows dependency order
- Shows estimated operations
- No actual changes made

## Report Generation
### Summary Includes
- Total tasks processed
- Success count and rate
- Failed tasks with reasons
- Skipped tasks with causes
- Execution time per task
- Overall duration

### Format
```
## 📊 Execution Summary
✅ {count} tasks completed successfully
❌ {count} tasks failed
⊘ {count} tasks skipped
```

### Output
Display summary to user only, no file generation

## Help Documentation
### Examples
- `/act` - Execute all pending tasks
- `/act T003` - Execute only task T003
- `/act T001-T005` - Execute tasks T001 through T005
- `/act T001,T003,T007` - Execute specific tasks
- `/act .tmp/20250908-*/tasks.md` - Use specific file

### Troubleshooting
- No file: Run /tasks first to generate task list
- Parse error: Check tasks.md format matches template
- Dependency cycle: Review and fix circular dependencies
- Permission denied: Ensure write access to .tmp directory