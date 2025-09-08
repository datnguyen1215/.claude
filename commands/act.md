---
name: act
description: Execute tasks from generated tasks.md files with live progress updates
---

# Act Command Configuration

```yaml
configuration:
  mode: execution
  type: action
  arguments: optional # Can be task IDs, ranges, or empty for all

instructions:
  primary: |
    Execute tasks from the tasks.md file provided in context or specified by user.
    Process tasks sequentially, updating checkboxes in real-time.
    Continue with non-dependent tasks when failures occur.
    Report summary directly to user without creating output files.

    IMPORTANT:
    - Use context-provided tasks.md path from /tasks command output
    - If no context path exists, ask user for specific tasks.md file path
    - Use Edit tool for live checkbox updates, not MultiEdit

  workflow:
    - CHECK_CONTEXT: Use tasks.md path from context if available
    - PARSE_ARGS: Process user arguments for task selection or file path
    - PARSE: Extract tasks, dependencies, and current state
    - FILTER: Apply task selection based on arguments
    - RESOLVE: Build execution order respecting dependencies
    - EXECUTE: Run tasks with live progress updates
    - RECOVER: Handle failures and continue with safe tasks
    - REPORT: Generate execution summary

  argument_patterns:
    no_args: Execute all pending tasks
    single: "T001" - Execute only T001
    range: "T001-T005" - Execute T001 through T005
    list: "T001,T003,T007" - Execute specific tasks
    mixed: "T001-T003,T007" - Combine ranges and lists
    path: "path/to/tasks.md" - Use specific task file

  task_discovery:
    source: context_or_user_provided
    context_check: Look for tasks.md path from previous /tasks command output
    no_context_action: Ask user for specific tasks.md file path
    validation:
      - File path must be explicitly provided (no auto-discovery)
      - File exists and is readable
      - Contains valid markdown structure
      - Has at least one task
    error_messages:
      no_path: "Please specify the tasks.md file path or run /tasks first"
      file_not_found: "The specified tasks.md file does not exist"

  task_parsing:
    task_id_pattern: "^### (T\\d{3}):"
    checkbox_patterns:
      pending: "- \\[ \\]"
      in_progress: "- \\[⏳\\]"
      completed: "- \\[x\\]"
      failed: "- \\[✗\\]"
    dependency_pattern: "\\*\\*Dependencies:\\*\\* \\[(.*?)\\]"
    extract:
      - Task ID and title
      - Current checkbox state
      - Dependencies list
      - Task commands from code blocks
      - File references
      - Success criteria

  dependency_resolution:
    algorithm: topological_sort
    circular_detection: enabled
    failure_isolation:
      - Mark failed task with [✗]
      - Identify all dependent tasks
      - Mark dependents as skipped
      - Continue with non-dependent tasks
    execution_order:
      - Process in dependency order
      - Run independent tasks in parallel groups
      - Skip already completed tasks

permissions:
  allowed_tools:
    - Read
    - Edit (for live updates)
    - MultiEdit
    - Bash
    - Glob
    - Grep
    - TodoWrite

  restrictions:
    - Only modify checkbox states in tasks.md
    - Preserve all other formatting
    - Execute commands in safe mode
    - No destructive operations without confirmation

behavior:
  live_updates:
    states:
      starting: "- [⏳]" # Task in progress
      success: "- [x]"   # Task completed
      failure: "- [✗]"   # Task failed
      skipped: "- [⊘]"   # Skipped due to dependency
    timing:
      - Update to [⏳] before task start
      - Update to [x] or [✗] immediately after completion
      - Preserve indentation and formatting
    method: Edit tool for immediate visibility

  execution_engine:
    supported_operations:
      - File edits (Edit, MultiEdit)
      - File creation (Write)
      - Command execution (Bash)
      - File reading (Read)
      - Pattern searching (Grep, Glob)
    error_handling:
      - Catch and log all errors
      - Mark task as failed
      - Continue with next safe task
      - Include error in final report
    timeout: 300000 # 5 minutes per task
    progress_callback: Update checkbox after each subtask

  failure_recovery:
    detection:
      - Command returns non-zero exit code
      - Tool operation fails
      - Validation criteria not met
    actions:
      - Mark task with [✗]
      - Log failure reason
      - Identify dependent tasks
      - Mark dependents as skipped [⊘]
      - Continue with non-dependent tasks
      - Track for retry suggestions

  validation:
    pre_execution:
      - Verify tasks.md format
      - Check for duplicate task IDs
      - Detect circular dependencies
      - Validate tool availability
      - Check write permissions
    dry_run:
      enabled: optional
      shows:
        - Tasks to be executed
        - Dependency order
        - Estimated operations
        - No actual changes made

  report_generation:
    summary_includes:
      - Total tasks processed
      - Success count and rate
      - Failed tasks with reasons
      - Skipped tasks with causes
      - Execution time per task
      - Overall duration
    format:
      header: "## 📊 Execution Summary"
      success: "✅ {count} tasks completed successfully"
      failures: "❌ {count} tasks failed"
      skipped: "⊘ {count} tasks skipped"
      details: Table with task ID, status, duration, notes
    output: Display summary to user only, no file generation

  help_documentation:
    examples:
      - "/act" - Execute all pending tasks
      - "/act T003" - Execute only task T003
      - "/act T001-T005" - Execute tasks T001 through T005
      - "/act T001,T003,T007" - Execute specific tasks
      - "/act .tmp/20250908-*/tasks.md" - Use specific file
    troubleshooting:
      no_file: "Run /tasks first to generate task list"
      parse_error: "Check tasks.md format matches template"
      dependency_cycle: "Review and fix circular dependencies"
      permission_denied: "Ensure write access to .tmp directory"
```