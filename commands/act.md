---
description: Execute tasks sequentially from a plan
---

## Act Configuration

```yaml
mode: execute
context_aware: true

instructions:
  - Find and read the plan's tasks.md
  - Execute each task sequentially within groups
  - Update checkbox to [x] after completion
  - Stop on first failure
  - MUST follow the workflow below

required_read:
  - tasks.md
  - context.md # if exists

thinking_mode:
  enabled: false

workflow:
  steps:
    - read_tasks: Parse all tasks maintaining group boundaries
    - execute_sequentially: Process each group in order
    - update_status: Mark [x] in tasks.md after each task
    - complete: Report summary of execution

execution_rules:
  sequential_processing:
    - Process groups in order (top to bottom)
    - Complete all tasks in a group before moving to next
    - Update tasks.md directly after each task
    - Complete all groups one by one sequentially until completion

output:
  summary_sections:
    - tasks_completed: Number of tasks successfully completed
    - tasks_remaining: Number of uncompleted tasks
    - files_modified: What was changed
    - error_encountered: Any failure details

completion:
  - show execution summary
  - suggest next steps if tasks remain
```